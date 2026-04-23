# matilha-software-arch-pack — skills inventory (draft)

17 skills organized in 5 families. Caminho C (opinions-from-practice) source:
Danilo's Argos + Gravicode rules in `rules-draft/`.

Prefix: `swarch-*`. Category: `swarch`.

## Family 1 — Dependency & layering (3 skills)

| Skill | Triggering intent (voz de Danilo) | Key principle | Source rule |
|---|---|---|---|
| `swarch-dependency-direction` | "Esse import tá certo? Domínio pode importar SDK AWS?" / "A regra de negócio depende de Lambda?" | Dependências apontam sempre para o domínio; infra é periferia adaptadora. | `Layering e Dependency Direction.md` |
| `swarch-lambda-chain-shape` | "Como desenho essa cadeia de Lambdas?" / "Meu handler tá virando bagunça" | Lambda handler é fino (~30 linhas): parse → domínio puro → side-effect. Uma função por Lambda. | `Layering e Dependency Direction.md` — seção Lambda Chain |
| `swarch-handler-as-adapter` | "Preciso testar essa lógica sem subir LocalStack" / "Handler tem if aninhado demais" | Handler é adapter; lógica de domínio vive em função pura injetada. Teste offline vira trivial. | `Layering e Dependency Direction.md` — handlers burros |

## Family 2 — Event-driven patterns (4 skills)

| Skill | Triggering intent | Key principle | Source rule |
|---|---|---|---|
| `swarch-fact-vs-command-events` | "Que nome dou pra esse evento?" / "Isso é evento ou RPC?" | Eventos são fatos no passado (ContentProcessed), não comandos imperativos (NotifyUser). | `Event-Driven Decoupling.md` |
| `swarch-event-gateway-boundary` | "Quando publico no EventBridge vs chamada direta?" / "Tenho N consumidores, como organizo?" | Event Gateway (EventBridge bus dedicado + regras por consumer) quando 1 evento tem 3+ consumidores heterogêneos. | `Event-Driven Decoupling.md` — Event Gateway |
| `swarch-ordering-decision` | "Preciso de FIFO?" / "Uso Kinesis ou SQS?" | Só pague por ordenação quando a semântica do domínio exige. Unordered escala melhor; ordered é caro. | `Event-Driven Decoupling.md` — ordered vs unordered |
| `swarch-event-schema-contract` | "Posso mudar esse campo do evento?" / "Como versionar o contrato?" | Evento em produção é contrato público: só adiciona opcional, nunca renomeia, nunca remove sem versionar. | `Event-Driven Decoupling.md` — schema é contrato |

## Family 3 — Data architecture (4 skills)

| Skill | Triggering intent | Key principle | Source rule |
|---|---|---|---|
| `swarch-dual-store-source-of-truth` | "Postgres ou Dynamo?" / "Preciso dos dois?" | Dual-store só justifica com cargas qualitativamente diferentes (control plane vs hot state). Um é SoT, o outro é projeção. | `Dual-Store Architecture.md` |
| `swarch-cdc-over-dual-write` | "Como mantenho Postgres e Dynamo sincronizados?" / "Chamo os dois na aplicação?" | CDC (Streams, logical replication, Debezium) ou outbox > dual-write síncrono. | `Dual-Store Architecture.md` — CDC |
| `swarch-hot-state-via-status-machine` | "Como modelo o ciclo de vida dessa entidade?" / "Usar máquina de estados?" | Estado explícito no DynamoDB (PENDING → CRAWLING → …) + Stream como trigger. Reprocessar = atualizar status. | `Dual-Store Architecture.md` — hot state |
| `swarch-projection-rebuild-discipline` | "E se a projeção divergir?" / "Como reconstituo o admin DB?" | Toda projeção precisa de watermark/lag metric e procedimento de rebuild documentado antes de produção. | `Dual-Store Architecture.md` — sinais de alerta |

## Family 4 — Bounded contexts (3 skills)

| Skill | Triggering intent | Key principle | Source rule |
|---|---|---|---|
| `swarch-context-by-vocabulary` | "Isso é um novo serviço?" / "Onde desenho a fronteira?" | Bounded Context é descoberto pelo vocabulário e invariantes, não pelo org chart ou pelo deploy. | `Bounded Contexts na Prática.md` |
| `swarch-context-without-microservice` | "Preciso quebrar em microserviços?" / "Ainda é um monólito, tá bem?" | Bounded context lógico primeiro (módulo num deploy). Microserviço é consequência, não causa. | `Bounded Contexts na Prática.md` — microserviço é consequência |
| `swarch-acl-between-contexts` | "Esse consumer tá lendo tabela interna do producer?" / "Evento tá vazando modelo interno?" | Entre contextos, contrato é o evento (fato) passado por anti-corruption layer. Schema interno nunca cruza fronteira. | `Bounded Contexts na Prática.md` — ACL |

## Family 5 — Escalabilidade disciplinada (3 skills)

| Skill | Triggering intent | Key principle | Source rule |
|---|---|---|---|
| `swarch-ticker-vs-rule-per-entity` | "Como agendo N alvos?" / "Cada alvo tem uma regra EventBridge?" | GSI-based polling (Ticker) escala pra milhões; rule-per-entity esgota limites AWS. | `Escalabilidade sem Prematuridade.md` — Ticker |
| `swarch-pull-over-push-orchestration` | "Lambda chama ecs:RunTask num loop, tá bom?" / "Como disparo 10k tasks?" | Nunca orquestre escala via API síncrona em loop. Workers fazem pull de fila/stream. | `Escalabilidade sem Prematuridade.md` — plano de controle |
| `swarch-measure-before-scale` | "Esse endpoint tá lento" / "Acho que precisamos escalar" | EXPLAIN / profile / golden signals antes de horizontalizar, cachear ou migrar. "Não escala" sem número é chute. | `Escalabilidade sem Prematuridade.md` — meça antes |

## Overlap disclosures (preview — see overlap-analysis.md for detail)

- `swarch-dual-store-source-of-truth` **Complementa** `matilha-sysdesign-pack:sysdesign-dual-write-event-sourcing` — sysdesign trata dual-write como anti-padrão com 3 alternativas; swarch foca no caso Postgres-SoT + Dynamo-hot-state quando **é** a resposta certa e como implementá-lo via CDC.
- `swarch-event-gateway-boundary` **Complementa** `matilha-sysdesign-pack:sysdesign-event-streaming-kafka` — sysdesign decide Kafka-vs-alternativas; swarch foca no design do Event Gateway (EventBridge bus + regras) para fan-out entre bounded contexts.
- `swarch-ticker-vs-rule-per-entity` e `swarch-pull-over-push-orchestration` **Complementam** `matilha-sysdesign-pack:sysdesign-scalability-horizontal-vs-vertical` — sysdesign é geral (horizontal/vertical/stateful); swarch traz o case concreto do Argos (Ticker GSI + DLQ + jitter) com números reais de falha.
- `swarch-lambda-chain-shape` **Complementa** `matilha-harness-pack:harness-orchestrator-workers` — harness é sobre arquitetura de agentes LLM (Planner/Generator/Evaluator); swarch é sobre cadeia de Lambdas AWS (pipeline de processamento). Mesma forma abstrata, substratos diferentes.

## Source distillation

Caminho C — opinions-from-practice. Fontes: `rules-draft/` (5 regras
autorais baseadas em Argos + Gravicode, não em livros/artigos). Padrão
igual ao de `matilha-software-eng-pack`.
