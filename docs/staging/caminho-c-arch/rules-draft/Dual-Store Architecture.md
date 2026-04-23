---
title: Dual-Store Architecture
date: 2026-04-21
version: 0.1.0
alwaysApply: false
---

## Princípios Fundamentais

**UM BANCO SÓ QUASE SEMPRE BASTA. QUANDO NÃO BASTA, OS DOIS TÊM PAPÉIS DIFERENTES — NÃO REDUNDANTES.**

Dual-store é um trade-off caro: complexidade de sincronização, risco de
divergência, duas superfícies operacionais. Só compensa quando as cargas de
leitura/escrita são **qualitativamente diferentes** — e mesmo aí, existe uma
fonte da verdade e uma projeção, nunca dois peers.

### Regras Fundamentais

1. **Um é Source of Truth. O outro é derivado.**
   - Decida, no começo, qual banco carrega a verdade. Em caso de
     divergência, ele ganha, o outro é reconstruído.
   - "Ambos são verdade" é receita de bug de produção permanente. Não
     existe consistência eventual entre dois masters sem coordenação
     custosa (consensus, CRDTs, ou dor).

2. **Motivação tem que ser qualitativa, não quantitativa**
   - ❌ "Postgres tá lento, vou botar Dynamo do lado" → provavelmente
     falta índice ou query mal escrita. Profile antes.
   - ✅ "Precisamos de escrita em burst de 10k/s com latência <10ms e
     Postgres não foi feito pra isso; mas relatórios administrativos
     com JOIN complexo são diários" → cargas qualitativamente diferentes.
     Dual-store se justifica.

3. **CDC > dual-write (quase sempre)**
   - Dual-write síncrono (aplicação escreve nos dois) é o anti-padrão
     clássico: se o segundo write falha depois do primeiro commitar,
     você tem estado inconsistente sem como reconciliar sem retry
     manual ou outbox.
   - CDC (Change Data Capture — DynamoDB Streams, Postgres logical
     replication, Debezium) garante: o write vai ao Source of Truth, a
     projeção é atualizada a partir do log. Falha na projeção pode ser
     replaídeada; falha no SoT é tratada como falha do write.
   - Outbox pattern é o meio-termo: escreve na mesma transação numa
     tabela `outbox`, um processo separado lê e publica. Mais simples
     que CDC nativo, mais seguro que dual-write.

4. **Cada banco otimizado pra seu papel**
   - Postgres no Argos é **control plane**: configuração de targets,
     knowledge base curada, checkpoints durávies da Lambda Chain,
     admin UI. JOIN, filtro complexo, transações.
   - DynamoDB no Argos é **hot state**: estado do ciclo de vida de cada
     URL (PENDING → CRAWLING → …), GSI esparso pra auditoria,
     Streams como trigger. Leitura por PK, escrita de alto volume,
     latência <10ms.
   - Não é duplicação: são cargas que um banco só atende com tradeoffs
     dolorosos.

### Decisão: qual banco é Source of Truth?

Use estes critérios (ordem importa):

1. **Durabilidade / auditoria legal**: se você precisa provar em
   auditoria o que aconteceu, o SoT é o que tem log imutável ou
   point-in-time recovery forte. Tipicamente Postgres ou event store.
2. **Schema estável e bem conhecido**: SoT é onde o schema é tratado
   com rigor. Projeções podem ser reconstruídas.
3. **Mutação complexa**: se a entidade sofre updates parciais com
   invariantes multi-campo, SoT é o que suporta transações.

Hot state é tipicamente derivado: pode ser reconstruído do SoT +
histórico de eventos. A recíproca não é verdadeira.

## Padrões na Prática

### Argos — Postgres como SoT, Dynamo como hot state

Quando a v3 do Argos foi desenhada, a tentação inicial foi "tudo no
Dynamo, ele aguenta". Duas cargas mataram essa ideia:

1. **Admin UI precisa listar targets com filtro complexo**: "me dá
   todos os targets do domínio X, ativos, que nunca foram processados
   com sucesso, ordenados por última tentativa". Isso é `WHERE ... AND
   ... ORDER BY` — pão com manteiga de Postgres, pesadelo de Dynamo
   (exigiria múltiplas GSIs, scans, ou agregação client-side).

2. **Hot path precisa de status updates em burst**: processar 200k
   URLs × 3 verificações/dia = 600k writes/dia, com picos. Cada mudança
   de status é uma escrita. Postgres sem tuning sofre; Dynamo On-Demand
   com boa partition key nem pisca.

Solução:

```
Postgres (SoT)                         DynamoDB (hot state)
─────────────                          ────────────────────
targets                                target_state
  target_id (PK)                         target_id (PK)
  domain                                 status (PENDING|CRAWLING|…)
  url_pattern                            last_crawl_at
  config                                 last_hash
  created_at                             s3_latest_uri
  active                                 error_count
  ...
                                       GSI: status (esparso — só ERROR)
```

Sync: mudanças em `targets` (admin cria/desativa/edita) disparam
replicação via processo de configuração → DynamoDB. Mudanças em
`target_state` (status flips do pipeline) **não voltam** pra Postgres
no hot path — são projetadas assincronamente via CDC (DynamoDB Streams
→ Lambda → upsert num `target_state_projection` em PG) para consumo
do admin UI.

Pergunta: o que acontece se a projeção quebrar? Resposta: admin UI
mostra dados defasados por alguns minutos. Nada crítico. Podemos
reconstruir a projeção relendo o Stream (com tabela retention
adequada) ou recomputando a partir do estado atual do Dynamo.

Pergunta: e se o Dynamo perder dados? Resposta: point-in-time recovery
de 35 dias + backup diário. Na pior das hipóteses, perdemos algumas
horas de `last_crawl_at` — reprocesso de madrugada reconstrói.

### Argos — Lambda Chain checkpoints em Postgres

A Lambda Chain escreve checkpoints no Postgres a cada estágio concluído
(`cleaner_done_at`, `classifier_done_at`, etc.). Isso não é hot path
(baixa frequência), mas é **SoT do pipeline**: permite replay seletivo
("reprocessa o Extractor pra todos os conteúdos classificados como
CRITICO entre 10:00 e 11:00"). Dynamo não seria adequado aqui — a
query exige filtro composto e timestamp range.

### Fluency (contraponto) — Dual-Write justificado

Fluency usa Cognee (event store imutável) + Postgres (projeção) com
dual-write **intencional**, porque:
- Event store é SoT absoluto (auditoria pedagógica, replay de
  pipelines de memória).
- Postgres é projeção pra admin UI.
- A dual-write é feita na mesma aplicação, com idempotência em ambos
  os lados, e reconciliação automática: Cognee ganha em divergência.

Não é o padrão default — é uma exceção consciente porque o overhead
de CDC entre Cognee e PG seria maior que a complexidade de manter
idempotência nos dois writes.

## Sinais de Alerta

### Você está fazendo dual-store mal se:

- **Não consegue nomear o SoT**: "ambos". Errado.
- **Dual-write síncrono sem outbox**: a transação fecha no primeiro
  banco, o segundo falha, retry manual. Em dias de pico, vai divergir.
- **Projeção tenta ser autoritativa**: "o admin UI criou o registro
  direto no Postgres, vou espelhar pro Dynamo" — agora você tem duas
  portas de entrada. SoT deve ter uma porta de entrada única; projeção
  é read-only.
- **Duplicação de dados sem propósito claro**: os dois bancos têm
  99% do mesmo schema. Se o uso é o mesmo, um basta. Dual-store
  existe pra servir cargas diferentes, não pra "ter backup".

### Você está prematurizando dual-store se:

- **Ainda não profiled a query lenta**: Postgres com índice errado
  parece "não escalar". Meça antes de duplicar.
- **Não tem burst real**: se o pico é 100 writes/s, Postgres
  tranquilamente aguenta. Dual-store adiciona complexidade sem
  retorno.
- **Equipe nunca operou os dois bancos**: dual-store em produção
  exige monitoria dupla, runbook duplo, expertise dupla. Se vocês
  ainda estão aprendendo Postgres direito, Dynamo vai multiplicar
  dor por 2.

### Você tem inconsistência iminente se:

- Projeção não tem watermark/lag metric — ninguém sabe quantos
  segundos de atraso ela carrega.
- Não existe procedimento de rebuild da projeção. Quando (não se)
  divergir, você vai improvisar às 3h da manhã.
- Eventos publicados da projeção (não do SoT) — agora consumidores
  downstream dependem de dados derivados, propagando erros de
  sincronização.

### Teste de fumaça

Se o banco secundário ficar fora por 1 hora, qual é o impacto?
- "Sistema para completamente" → ele não é secundário, é SoT também
  (ou você tem dependência síncrona mal feita).
- "Admin UI mostra dados defasados, mas hot path segue" → ✅ bom
  desacoplamento.
- "Não faz diferença nenhuma" → o banco talvez nem precise existir.

## Conexões

- CDC e Change Streams: event-driven regra (regra
  `Event-Driven Decoupling.md`)
- Bounded contexts (decisão de quantos stores por contexto): regra
  `Bounded Contexts na Prática.md`
- Sysdesign-pack: `sysdesign-dual-write-event-sourcing` trata o
  anti-padrão geral e suas três alternativas — esta regra foca no
  caso específico Postgres-SoT + Dynamo-hot-state e quando ele é a
  resposta certa.
