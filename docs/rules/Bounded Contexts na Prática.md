---
title: Bounded Contexts na Prática
date: 2026-04-21
version: 0.1.0
alwaysApply: false
---

## Princípios Fundamentais

**BOUNDED CONTEXT É LINHA DE LINGUAGEM, NÃO LINHA DE DEPLOY.**

Bounded Context não é sinônimo de microserviço. É uma decisão de modelagem:
dentro desta fronteira, um termo tem um significado específico, invariantes
coerentes, e o modelo é internamente consistente. Cruzar a fronteira exige
tradução explícita. Deploy (monólito, vários serviços, Lambdas) é decisão
separada, subordinada a ela.

### Regras Fundamentais

1. **Descubra contextos pelo vocabulário, não pelo org chart**
   - Quando a mesma palavra (ex.: "target", "aluno", "conteúdo") tem
     semânticas diferentes em partes diferentes do sistema, você tem
     bounded contexts diferentes — mesmo que rode no mesmo processo.
   - No Argos: "target" pra Target Management é **configuração**
     (URL + regras). Pra Crawl/Changes é **estado** (último hash,
     status atual). Pra Notifications é **destinatário** (canal Slack,
     template). Mesma palavra, três modelos.

2. **Fronteira explícita = tradução explícita**
   - Quando um evento/dado cruza fronteira, passe por um **anti-corruption
     layer** (ACL) — uma tradução. Não deixe o modelo interno de um
     contexto vazar pro outro.
   - Se o consumer tem que saber 15 campos internos do producer pra
     fazer seu trabalho, a fronteira tá errada ou o evento é pobre.

3. **Microserviço é consequência, não causa**
   - Bounded context claro **permite** microserviço quando/se precisar
     (escalar, time separado, tecnologia diferente). Mas começar
     microserviços sem contextos claros → "microservice-spaghetti":
     tudo chamando tudo, fronteiras acidentais via endpoints HTTP,
     sem o benefício de um modelo coerente.
   - Regra prática: prove o bounded context num módulo dentro de um
     deploy único primeiro. Se a separação lógica se sustenta sob
     pressão de feature, **aí** considere separar o deploy.

4. **Contextos compartilham eventos, não schemas**
   - Entre contextos, o contrato é o **evento** (fato publicado). Nunca
     "o consumer lê direto a tabela do producer".
   - Se consumer precisa de todos os dados, o evento deve carregá-los.
     Se o evento ficou pesado, provavelmente você está forçando
     acoplamento que deveria ser síncrono ou os contextos estão mal
     desenhados.

### Heurística para encontrar contextos

Sentando com o domain expert:
- Peça pra explicar o fluxo ponta-a-ponta com as próprias palavras.
- Onde o vocabulário muda? ("Aqui a gente chama de 'target', mas quando
  chega na notificação, a equipe do Slack chama de 'canal'.")
- Onde os invariantes mudam? ("Aqui pode ser desativado a qualquer
  hora, lá uma vez criado não pode sumir.")
- Quem toma decisão sobre mudanças em cada parte? (Se é o mesmo time
  tomando decisão sobre duas partes com linguagens diferentes, talvez
  os contextos ainda devam ser separados mesmo com time único.)

## Padrões na Prática

### Argos — Quatro bounded contexts dentro de um monólito lógico

```
┌─────────────────────┐   ┌─────────────────────┐
│  Target Management  │   │     Changes         │
│  (configuração)     │   │  (estado + hash)    │
│  Postgres SoT       │   │  Dynamo SoT         │
│                     │   │                     │
│  - targets          │   │  - target_state     │
│  - domains          │   │  - history          │
│  - schedules        │   │  - diffs            │
└──────────┬──────────┘   └──────────┬──────────┘
           │                         │
           ▼                         ▼
        evento                    evento
  TargetActivated           ContentProcessed
           │                         │
           ▼                         ▼
┌─────────────────────┐   ┌─────────────────────┐
│  Knowledge Base     │   │   Notifications     │
│  (curadoria)        │   │  (fan-out)          │
│                     │   │                     │
│  - entities         │   │  - channels         │
│  - relations        │   │  - templates        │
│  - confidence       │   │  - dispatch_log     │
└─────────────────────┘   └─────────────────────┘
```

**Target Management** — domínio: "quais páginas monitoramos e com que
regras". Vocabulário: *target, schedule, rate limit, allowed methods*.
Invariantes: todo target tem dono, todo target tem domínio registrado.

**Changes** — domínio: "o que mudou, quando, e qual a classificação
semântica". Vocabulário: *hash, diff, classification (CRITICO /
INFORMATIVO / IRRELEVANTE), extracted entities*. Invariantes:
toda mudança detectada tem conteúdo antes/depois imutável em S3.

**Knowledge Base** — domínio: "conhecimento curado do ecossistema
Gran Cursos (entidades: concurso, banca, cargo, jurisprudência)".
Vocabulário: *entity, relation, confidence, source*. Invariantes:
toda entidade tem ao menos uma fonte rastreável.

**Notifications** — domínio: "como fan-out de eventos vira alertas
pra humanos/sistemas". Vocabulário: *channel, template, dispatch,
acknowledgment*. Invariantes: todo dispatch tem evento de origem
rastreável.

Os quatro compartilham infraestrutura (mesmo AWS account, mesmo
Postgres cluster com schemas separados, mesmo EventBridge bus), mas
**não compartilham modelos**. Mudança interna de Changes (ex.:
adicionar novo tipo de classificação) não toca em Notifications.
Mudança interna de Notifications (ex.: novo canal Teams) não toca
em Changes.

Comunicação entre eles é por evento, sempre:
- `TargetActivated` (Target Management → Changes): agora monitore
  esta URL.
- `ContentProcessed` (Changes → Notifications, Knowledge Base, etc.):
  mudou, classificado, aqui está o resumo e metadados.
- `NotificationDispatched` (Notifications → auditoria): enviado,
  timestamp, resultado.

### Argos — Teste de separação sob pressão de feature

Feature: "queremos que o Slack receba só alertas CRITICO no canal
#editais, mas INFORMATIVO vai pra #geral".

Antes de bounded contexts claros: essa feature teria alterado o
produtor (Changes publicando N eventos diferentes), o schema de evento,
o cliente Slack. Mudança cascateando.

Com bounded contexts: a feature é **100% interna a Notifications**.
O produtor já publica `ContentProcessed` com `classification`.
Notifications define a regra de roteamento. Zero impacto nos outros
contextos. Implementação: ~4 horas, 1 PR.

### Gravicode — Consulta Clínica vs Knowledge Graph

No Gravicode, a Consulta Clínica (orchestrator + 14 agentes) é um
bounded context; o Knowledge Graph (Neo4j + curadoria manual do
Harrison's) é outro. Eles se falam via contrato de query + resultado
estruturado. A Consulta não sabe que Neo4j existe (passa pelo GraphRAG
layer, que é o ACL). O Knowledge Graph não sabe que existe LangGraph,
Pedagogo, HITL. Cada um evolui no seu ritmo.

Quando chegou a hora de migrar partes do graph pra FalkorDB (cache
layer), mexemos só no módulo de retrieval. Consulta Clínica não
percebeu.

## Sinais de Alerta

### Você tem microservice-spaghetti se:

- **Mesmo conceito, schema diferente em cada serviço, sincronizado na
  raça**: "cliente" tem 8 campos no Billing, 12 no CRM, 5 no
  Shipping, e toda feature nova exige deploy nos três. Não são
  contextos, é um modelo só mal distribuído.
- **Serviço A chama serviço B síncrono, B chama C, C chama D pra
  uma ação do usuário**: cadeia de dependências síncronas entre
  "contextos" mostra que eles não são independentes. São um único
  contexto mal distribuído.
- **Mudança de schema em um serviço exige coordenação com 4 times
  antes de deploy**: fronteira vazando por todos os lados.
- **Deploy de um serviço sempre precisa de rollback em cascata dos
  outros**: acoplamento de release, não bounded contexts.

### Você vazou o modelo se:

- O evento público carrega campos que só fazem sentido no contexto
  interno (`internal_target_state_hash`, `db_row_version`).
- O consumer tem que fazer lookup num segundo endpoint do producer
  pra entender o evento. Se o evento é pobre, enriqueça-o; se o
  consumer precisa de tudo, talvez esteja no contexto errado.
- Duas equipes brigam sobre o "nome certo" de um conceito. Se ambas
  têm argumentos válidos, provavelmente são dois conceitos com a
  mesma palavra. Separe-os e dê nomes diferentes por contexto.

### Você não tem contextos, tem camadas mal nomeadas se:

- "Bounded context" acaba virando: frontend / backend / database.
  Isso é arquitetura de camadas (view / controller / model), não
  contextos de domínio.
- Você criou um contexto por **pasta** sem um modelo interno
  coerente. Pastas são gratuitas; contextos são disciplinados.
- Tirar um contexto do sistema quebra coisas aparentemente não
  relacionadas. Fronteira não está se mantendo.

### Teste de fumaça

Entre dois "contextos", pergunte:
- Se o time A dobrar de tamanho, o time B precisa mudar a velocidade
  de release?
- Se o time A trocar de linguagem, o time B precisa mudar código?
- Se o time A deletar uma tabela interna, o time B percebe?

Respostas desejadas: **não, não, não** (com eventuais mitigações
via tradução/replay).

## Conexões

- Event-driven como contrato entre contextos: regra
  `Event-Driven Decoupling.md`
- Dual-store dentro de contexto: regra `Dual-Store Architecture.md`
- Layering dentro de contexto: regra
  `Layering e Dependency Direction.md`
