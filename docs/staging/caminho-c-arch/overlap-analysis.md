# matilha-software-arch-pack — overlap analysis

Cross-check de 17 skills propostas contra:
- `matilha-sysdesign-pack` (19 skills shipped)
- `matilha-harness-pack` (22 skills shipped)

## Diferenciador mestre

Uma linha que resolve 80% das fronteiras:

| Pack | Angle | Audience |
|---|---|---|
| `matilha-sysdesign-pack` | Catálogo de padrões genéricos + tradeoff-forcing, tom interview-framing | Quem projeta sistema do zero, prepara entrevista, ou precisa vocabulário compartilhado de padrão clássico |
| `matilha-software-arch-pack` | Opiniões de prática ("no Argos eu escolhi X porque Y falhou") | Quem está implementando decisões arquiteturais agora, com substrato AWS-específico (EventBridge, DynamoDB Streams, Lambda, Postgres RDS) |
| `matilha-harness-pack` | Arquitetura de agentes LLM (Planner/Generator/Evaluator, evals, orchestrator-workers de agente) | Quem constrói sistema multi-agente, não sistema distribuído clássico |

Regra: quando o prompt é "qual o padrão certo aqui?" → sysdesign.
Quando é "como o Argos resolveu isso concretamente?" → swarch.
Quando é "como arquiteto meu coding agent?" → harness.

## Overlaps identificados

### 1. `swarch-dual-store-source-of-truth` vs `sysdesign-dual-write-event-sourcing`

**Superfície comum**: ambos disparam em "dois stores na mesma operação".

**Diferenciação**:
- sysdesign trata **dual-write** como anti-padrão e apresenta 3 alternativas
  consistentes (transactional outbox, CDC, event sourcing como SoT). É um
  skill de "force honest accounting of event sourcing cost".
- swarch ataca o caso **onde dual-store é a resposta certa** (Postgres
  control plane + Dynamo hot state no Argos) e dita: (a) quem é SoT, (b)
  implementação via CDC/Streams, (c) procedimento de rebuild da projeção,
  (d) sinais de que você está fazendo dual-write disfarçado.

**Proposed disclosure** (ambas direções):
- swarch skill body: > **Complementa** `matilha-sysdesign-pack:sysdesign-dual-write-event-sourcing`. Aquela skill força a análise honesta do custo de event sourcing e apresenta as 3 alternativas ao dual-write. Esta skill foca no caso concreto Postgres-SoT + Dynamo-hot-state e como implementá-lo via CDC (DynamoDB Streams) no padrão que o Argos usa em produção.
- sysdesign skill body (se revisado numa wave futura): > Para o caso específico Postgres control plane + Dynamo hot state com CDC, veja `matilha-software-arch-pack:swarch-dual-store-source-of-truth`.

### 2. `swarch-event-gateway-boundary` + `swarch-ordering-decision` vs `sysdesign-event-streaming-kafka`

**Superfície comum**: escolhas em event streaming.

**Diferenciação**:
- sysdesign é **binária**: Kafka vs. alternativa. A skill decide yes/no no
  Kafka em função de replay, ordering, fan-out, e operational appetite.
- swarch assume Kafka já não é a escolha (na stack Argos, EventBridge +
  DynamoDB Streams + SQS); foca em:
  - `swarch-event-gateway-boundary`: **desenho** do Event Gateway
    (EventBridge bus dedicado + regras por consumer) para fan-out entre
    bounded contexts.
  - `swarch-ordering-decision`: decisão fina de ordered vs unordered
    **dentro** da escolha já feita (SQS FIFO vs Standard, Kinesis vs
    EventBridge).

**Proposed disclosure**:
- swarch-event-gateway-boundary: > **Complementa** `matilha-sysdesign-pack:sysdesign-event-streaming-kafka`. Aquela skill decide Kafka vs alternativas em substrate generalista. Esta skill trata do **desenho do bus** (EventBridge tipicamente, regras por consumer) quando você já escolheu não-Kafka e precisa fan-out entre bounded contexts.
- swarch-ordering-decision: > **Complementa** `matilha-sysdesign-pack:sysdesign-event-streaming-kafka`. A decisão Kafka-vs-não-Kafka carrega parte desta pergunta; esta skill é mais fina: dado que você já escolheu SQS/Kinesis/EventBridge, quando FIFO, quando Standard, quando partition key.

### 3. `swarch-ticker-vs-rule-per-entity` + `swarch-pull-over-push-orchestration` + `swarch-measure-before-scale` vs `sysdesign-scalability-horizontal-vs-vertical`

**Superfície comum**: "preciso escalar".

**Diferenciação**:
- sysdesign foca em **decisão estrutural**: vertical (upgrade do host) vs
  horizontal (mais hosts) + detectar stateless vs stateful + identificar
  estado compartilhado em write como teto.
- swarch traz **padrões concretos operados em produção**:
  - Ticker Pattern com GSI-based polling é específico de AWS e resolve
    um problema que sysdesign nem toca (scheduler explosion).
  - Pull-over-push-orchestration é uma falha específica de plano de
    controle AWS (ThrottlingException em `ecs:RunTask`) que sysdesign
    não aborda.
  - Measure-before-scale é disciplina de medição com golden signals
    específicos — sysdesign menciona o conceito, swarch ensina o
    ritual de EXPLAIN / pg_stat_statements / CloudWatch.

**Proposed disclosure**:
- swarch-ticker-vs-rule-per-entity: > **Complementa** `matilha-sysdesign-pack:sysdesign-scalability-horizontal-vs-vertical`. Aquela skill decide horizontal/vertical/stateful. Esta é específica: como escalonar N agendamentos sem explodir regras AWS — padrão Ticker + GSI sparse polling que o Argos usa.
- swarch-pull-over-push-orchestration: > **Complementa** `matilha-sysdesign-pack:sysdesign-scalability-horizontal-vs-vertical`. Foco em um failure mode específico: orquestração push-driven via `ecs:RunTask`/`lambda:Invoke` em loop esgota plano de controle AWS. Workers fazem pull de fila.
- swarch-measure-before-scale: > **Complementa** `matilha-sysdesign-pack:sysdesign-scalability-horizontal-vs-vertical` e `matilha-sysdesign-pack:sysdesign-monitoring-4-golden-signals`. Traz o ritual concreto de medição antes de decidir escalar (EXPLAIN, profile, métricas).

### 4. `swarch-lambda-chain-shape` vs `harness-orchestrator-workers`

**Superfície comum**: cadeia de processadores.

**Diferenciação**:
- harness-orchestrator-workers é sobre **agentes LLM**: Planner decide, N
  workers executam em paralelo, Evaluator julga. Substrato: Claude, LangGraph,
  Task tool.
- swarch-lambda-chain-shape é sobre **Lambdas AWS em pipeline**: Cleaner
  → Classifier → Extractor → Router → Notifier. Substrato: Lambda, DynamoDB
  Streams, EventBridge. Acoplamento via estado/evento, não via chamada.

Eles compartilham uma forma abstrata (pipeline com estágios coesos), mas o
trabalho de cada skill é nos detalhes operacionais do substrato.

**Proposed disclosure**:
- swarch-lambda-chain-shape: > **Complementa** `matilha-harness-pack:harness-orchestrator-workers`. Aquela skill arquiteta multi-agente LLM (Planner/Generator/Evaluator). Esta arquiteta cadeia de Lambdas AWS — mesma forma abstrata (pipeline), substrato e operacional diferentes.

### 5. `swarch-context-by-vocabulary` + `swarch-context-without-microservice` vs (nenhum overlap direto)

Sysdesign não tem skill sobre Bounded Contexts / DDD. Harness não tem
skill de modelagem de domínio. **Sem overlap identificado** — esse
território é limpo para swarch.

### 6. `swarch-dependency-direction` + `swarch-handler-as-adapter` vs (nenhum overlap direto)

Sysdesign não tem skill sobre Clean Architecture / Hexagonal / layering.
Harness tem `harness-architecture`, mas é sobre arquitetura de agentes
LLM, não sobre camadas de código. **Sem overlap identificado** —
território limpo.

## Top 3 overlap concerns (prioridade de resolver bem)

1. **swarch-dual-store vs sysdesign-dual-write-event-sourcing** — alto
   risco de usuário acionar o skill errado. O triggering intent "preciso
   dos dois?" dispara ambos. A diferenciação é sutil (anti-padrão vs
   padrão justificado). Recomendação: descrição do swarch precisa ser
   **explícita** sobre "quando dual-store É a resposta", contrastando
   com a descrição do sysdesign (que assume "por que você não deveria").
2. **swarch-event-gateway-boundary vs sysdesign-event-streaming-kafka**
   — overlap médio porque descrições podem parecer sinônimas na
   superfície. Mitigação: incluir "EventBridge / fan-out entre bounded
   contexts" explícito na descrição do swarch para sinalizar substrato
   diferente.
3. **swarch-measure-before-scale vs sysdesign-monitoring-4-golden-signals**
   — overlap pequeno mas real no ritual de medição. Resolução: swarch é
   sobre **decisão precedendo escala**; sysdesign-monitoring é sobre
   **monitoria contínua**. Disclosure cruzada em ambos os skills.

## Recomendação de governança

- Nenhum skill do swarch-pack **substitui** um do sysdesign-pack. Todos
  os overlaps são **complementares** (disclosure "Complementa …").
- Quando os dois packs forem instalados juntos, o usuário deveria
  conseguir invocar explicitamente: `sysdesign-*` para framing genérico
  / decisão de padrão; `swarch-*` para decisão operacional concreta
  com substrato AWS.
- Considerar em Wave futura: adicionar uma "composition skill"
  (`matilha-compose`-style) que, quando ambos packs estão presentes,
  dispara primeiro o sysdesign para framing, depois o swarch para
  execução. Fora do escopo de Wave 5h.
