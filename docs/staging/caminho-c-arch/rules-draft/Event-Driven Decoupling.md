---
title: Event-Driven Decoupling
date: 2026-04-21
version: 0.1.0
alwaysApply: false
---

## Princípios Fundamentais

**EVENTOS NÃO SÃO RPC DISFARÇADO. SÃO FATOS PUBLICADOS SOBRE O MUNDO.**

Event-driven mal feito é pior que chamada síncrona explícita: adiciona
latência, dificulta debug, cria acoplamento temporal invisível e ainda
continua acoplado. Event-driven bem feito quebra o sistema em domínios
independentes que evoluem sozinhos — o produtor publica o que aconteceu, os
consumidores decidem o que fazer.

### Regras Fundamentais

1. **Publique fatos, não comandos**
   - ✅ `ContentProcessed` (um fato — "este conteúdo foi processado") —
     qualquer consumidor interessado reage.
   - ❌ `NotifyUser` (um comando disfarçado — "alguém, notifique o usuário")
     — se só tem um consumidor, é RPC com passo a mais. Se tem vários,
     é acoplamento por nome de destino.
   - O payload descreve **o que aconteceu**, não **o que fazer**. Quem
     decide o que fazer é o consumidor.

2. **Ordered vs unordered — decida conscientemente**
   - Ordered (FIFO SQS, Kinesis com partition key, Kafka) é caro: limita
     paralelismo, complica retry, exige backpressure.
   - Unordered (EventBridge, SNS, SQS standard) escala horizontalmente
     sem dor.
   - Regra prática: só pague por ordenação quando a semântica do domínio
     **exige**. "Seria bom se chegasse em ordem" não é exigência — é
     conveniência.

3. **Event Gateway quando há N consumidores heterogêneos**
   - Se 1 evento tem 1 consumidor → chamada direta (Lambda invoke, HTTP,
     fila dedicada) pode ser mais honesto.
   - Se 1 evento tem 3+ consumidores com latências e necessidades
     diferentes (um quer processar em ms, outro pode esperar minutos),
     um Event Gateway (EventBridge bus dedicado + regras por consumidor)
     desacopla de verdade.

4. **Schema do evento é contrato público**
   - Uma vez publicado, um evento não muda de shape sem versionamento.
     Adicione campos opcionais; nunca remova nem renomeie.
   - Se quebrar schema compat, consumidores quebram em produção sem
     aviso — porque eles não te chamam, eles te escutam.

### Quando publicar evento vs chamar direto

| Sinal | Evento | Chamada direta |
|---|---|---|
| Múltiplos consumidores | ✅ | ❌ |
| Consumer precisa da resposta síncrona | ❌ | ✅ |
| Fan-out para domínios diferentes | ✅ | ❌ |
| Parte do mesmo bounded context | Talvez | ✅ |
| Precisa de replay/auditoria | ✅ | ❌ |
| Latência end-to-end crítica (<100ms) | Talvez | ✅ |
| Consumer pode estar indisponível | ✅ (fila) | ❌ |

## Padrões na Prática

### Argos — Event Gateway `argos.platform`

Depois que o Lambda Chain (Cleaner → Classifier → Extractor → Router → Notifier)
processa um conteúdo, a última Lambda publica **um único evento** em um
EventBridge bus dedicado (`argos.platform`):

```json
{
  "source": "argos.platform",
  "detail-type": "ContentProcessed",
  "detail": {
    "content_id": "...",
    "classification": "CRITICO",
    "domain": "gran-cursos",
    "category": "edital",
    "extracted": { "cargo": "...", "fase": "...", "banca": "..." },
    "s3_summary_uri": "s3://...",
    "processed_at": "2026-04-21T14:22:01Z"
  }
}
```

Consumidores (cada um com regra EventBridge filtrando o que interessa):
- **Plataforma pedagógica**: consome só `classification=CRITICO` e
  `category=edital` → dispara geração de conteúdo.
- **Admin dashboard**: consome tudo → alimenta projeção materializada em PG.
- **Slack notifier**: consome `classification in [CRITICO, INFORMATIVO]` →
  envia pra canal apropriado.
- **Auditoria**: consome tudo → escreve em S3 particionado por data.

Valor real: quando o time da plataforma pedagógica pediu nova feature
("quero também reagir a `category=sumula`"), **não tocamos em nenhum
código do Argos**. Mudamos só a regra EventBridge do consumidor. O
produtor não sabe, não deveria saber, e não precisou saber.

### Argos — Dentro da pipeline: coreografia via estado

Dentro do Lambda Chain, a coreografia é via **mudança de estado no
DynamoDB + Streams** (não via EventBridge):

```
Cleaner    → escreve status=READY_TO_CLASSIFY  → Stream dispara Classifier
Classifier → escreve status=READY_TO_EXTRACT   → Stream dispara Extractor
Extractor  → escreve status=READY_TO_ROUTE     → Stream dispara Router
Router     → escreve status=READY_TO_NOTIFY    → Stream dispara Notifier
Notifier   → escreve status=COMPLETED          → publica evento público
```

Por que não EventBridge entre cada passo? Porque:
- Todos os passos pertencem ao **mesmo bounded context** (processamento
  de conteúdo).
- A ordem importa e é sequencial.
- Reprocessar é trivial: basta atualizar o `status`.
- Não há consumidor externo em nenhum passo intermediário.

EventBridge fica reservado para o **contrato público** (`ContentProcessed`).
Estado + Streams é o mecanismo interno. Essa separação é intencional.

### Gravicode — Orchestrator não comanda, delega

O Orchestrator do Gravicode não chama `SafetyAgent.run()` como função. Ele
atualiza o estado do LangGraph e o SafetyAgent é ativado como nó. Isso
permite: parada HITL (human-in-the-loop) em qualquer ponto, replay de
estado via PostgreSQL checkpointer, e adição de novos agentes sem o
Orchestrator "saber" deles.

## Sinais de Alerta

### Você tem RPC disfarçado se:

- **O nome do evento é verbo imperativo**: `SendEmail`, `ProcessOrder`,
  `NotifyUser` — eventos descrevem fatos no passado (`OrderPlaced`,
  `EmailRequested`, `UserNotified`).
- **Tem um único consumidor e provavelmente sempre terá**: eventos são
  para desacoplar múltiplos consumidores. Para 1↔1, chamada direta é
  mais clara.
- **Produtor "espera" resposta via polling**: se depois de publicar o
  evento o produtor fica lendo status pra ver se terminou, você construiu
  RPC síncrono com 3 pulos de rede. Faça chamada direta.
- **O payload contém instruções**: "notifique com tom alegre em
  português" não é fato — é comando. O fato é "item X ficou pronto";
  decisão de tom é do notificador.

### Você está sofrendo de ordenação mal decidida se:

- Usa FIFO SQS + consumidor paralelizado e reclama de duplicatas → FIFO
  com paralelismo exige message group ID bem escolhida; senão degrada
  para standard com hat de FIFO.
- Usa Kafka com 1 partição "para garantir ordem" → throughput cai ao
  chão. Se precisa de ordem global, Kafka é a ferramenta errada.
- "Eventualmente consistente" vira "às vezes chega antes do anterior e
  quebra projeção" → projeção precisa ser idempotente e ordenável por
  timestamp, ou tem que ter ordenação garantida.

### Você quebrou o contrato público se:

- Mudou nome de campo em evento já em produção (sem versionar).
- Adicionou campo obrigatório novo (em vez de opcional).
- Mudou semântica de um campo mantendo o nome.
- Publica a mesma detail-type em buses diferentes para consumidores
  diferentes — agora tem dois "contratos públicos" pra manter
  sincronizados.

### Teste de fumaça

Pegue o evento mais importante do sistema. Se você remover um consumidor
qualquer, o produtor:
- nota? → acoplamento vazando
- quebra? → muito acoplamento
- nem sabe? → ✅ bom

Se você adicionar um consumidor novo, precisa:
- mudar código do produtor? → acoplamento vazando
- só adicionar regra no bus / subscrever ao tópico? → ✅ bom

## Conexões

- Bounded contexts (para decidir quando publicar vs não): ver regra
  `Bounded Contexts na Prática.md`
- Dual-store (projeção materializada de eventos): ver regra
  `Dual-Store Architecture.md`
- Layering (onde o publisher vive): ver regra `Layering e Dependency Direction.md`
