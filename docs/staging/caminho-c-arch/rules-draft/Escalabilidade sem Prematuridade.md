---
title: Escalabilidade sem Prematuridade
date: 2026-04-21
version: 0.1.0
alwaysApply: false
---

## Princípios Fundamentais

**ESCALABILIDADE É DISCIPLINA, NÃO PARANOIA. ESCALE O QUE DÓI, NO MOMENTO QUE DÓI, COM EVIDÊNCIA.**

Sistema que tenta aguentar 10M requests/s desde o dia zero nunca lança.
Sistema que não pensa em escala até a véspera de sangrar morre. O caminho
do meio: desenhe para ordem de grandeza realista do próximo ano, deixe
pontos de corte evidentes para expansão, e **meça antes de escalar**. A
maioria dos "problemas de escala" é query mal escrita, índice faltando, ou
orquestração errada — não limite real de hardware.

### Regras Fundamentais

1. **Plano de controle quebra antes do plano de dados**
   - Nunca orquestre escala via chamada de API síncrona em loop
     (`ecs:RunTask`, `lambda:Invoke`, `dynamodb:PutItem` N vezes).
     As APIs AWS têm TPS limits baixíssimos relativos aos throughputs
     que o runtime aguenta.
   - Regra: workers fazem **pull** de fila/stream. Coordenador só
     distribui trabalho, não despacha individualmente.

2. **Escale o que sofre, um componente por vez**
   - "Vamos escalar o sistema" é frase inválida. Escala-se uma peça
     por vez: um endpoint, um worker, uma fila, um banco.
   - Nomeie o *golden signal* que disparou: latency, traffic, errors,
     saturation. Um componente, um sinal, uma decisão.

3. **Prefira horizontalizar stateless antes de verticalizar stateful**
   - Stateless (API sem sessão, worker idempotente, Lambda) escala
     horizontal de graça. Faça isso primeiro.
   - Stateful com estado local (cache in-memory, sessão sticky) — ou
     verticaliza, ou refatore pra mover estado pra fora.
   - Stateful compartilhado (banco escrita única, write-heavy Redis)
     — read replicas, sharding, ou redesenho do acesso. Nunca é
     "só subir a máquina".

4. **Meça antes de assumir que "não escala"**
   - EXPLAIN ANALYZE no Postgres antes de migrar pra Dynamo.
   - Profile o endpoint lento antes de cachear.
   - Olhe as métricas de saturação dos 4 golden signals antes de
     horizontalizar — pode ser só timeout mal calibrado.
   - "Não escala" sem número ao lado é chute.

### Quando horizontalizar

- CPU/memória de instância única no red zone consistente (>70% em
  carga normal, >90% em pico).
- Latência p99 em crescimento linear com tráfego (e p50 estável).
  Significa contention, não throughput issue.
- Custo por request estável mas tráfego crescendo — é hora de
  barateia via paralelismo.
- Redundância por availability (SLA exige N-1 tolerance).

### Quando ainda NÃO horizontalizar

- Nunca foi medido. "Parece lento" não é sinal.
- Tem query com N+1 óbvio, sem índice, sem cache — essas são
  otimizações baratíssimas que muitas vezes eliminam o "problema
  de escala".
- Tráfego real é 100 req/min e arquitetura já suporta 10k/s. Pára.

## Padrões na Prática

### Argos — GSI-based polling (Ticker) vs EventBridge-rules-per-target

Problema: agendar 200k URLs × 3 checks/dia = 600k "disparos" por dia.
Se cada URL fosse uma regra EventBridge separada, teríamos 200k regras
— limite da conta AWS e pesadelo de manutenção.

**Opção A descartada**: uma regra EventBridge por target.
- Prós: cada target tem seu próprio cron expression.
- Contras: limite de regras por região, operação pesada (criar/atualizar
  regras via API), visibilidade ruim ("quem está ativo?" vira listagem
  paginada).

**Opção B adotada (Ticker Pattern com GSI)**: uma única regra
EventBridge dispara uma Lambda "Ticker" a cada minuto. A Ticker
consulta DynamoDB via GSI (`next_run_at` como sort key, com sparse
index de `active=true`) pra pegar alvos cuja hora chegou. Publica
`TargetDue` eventos na fila SQS de crawl.

```
EventBridge (cron: */1 min)
    ↓ (uma invocação por minuto)
Lambda Ticker
    ↓ (Query GSI: active=true AND next_run_at <= now)
DynamoDB GSI sparse
    ↓ (retorna batch de ~1000 alvos due)
Lambda Ticker (continua)
    ↓ (publica batch em SQS com DelaySeconds aleatório 0-30min pra achatar pico)
SQS Crawl Queue
    ↓ (pull pelos workers Fargate)
Fargate Worker Pool
```

Trade-offs conscientes:
- **Latência de agendamento**: resolução de 1 minuto (vs segundos de
  uma regra EventBridge dedicada). Aceitável pro domínio — ninguém
  notifica sobre edital em menos de 1 min de atraso.
- **Jitter nativo via `DelaySeconds`**: 1000 URLs due às 08:00 não
  são processadas todas às 08:00:01 — são espalhadas em 30 minutos,
  achatando o pico de conexões TCP pros alvos e evitando DDoS
  acidental.
- **Escala para milhões de targets**: GSI sparse scan é barato (só
  lê os ativos com hora due). Limite real é o DynamoDB throughput,
  que é on-demand — sem capacity planning.
- **Adicionar/remover target**: update de linha no DynamoDB. Zero
  operações AWS API custosas. Admin UI faz isso sem friction.

O anti-padrão da v1 (`Lambda → ecs:RunTask` em loop) esgotava o TPS
da API ECS em minutos. O Ticker + pull-by-worker inverte: a AWS API
só é chamada na taxa que o runtime realmente processa, nunca em burst.

### Argos — Quando NÃO escalei prematuramente

Decisão: v2 usa SQS Standard, não FIFO. Poderia ter usado FIFO
"pra garantir ordem de processamento".

Análise antes da decisão:
- A ordem entre alvos **não importa** (URLs de domínios diferentes
  são independentes).
- Dentro do mesmo alvo, a próxima verificação só acontece após a
  anterior terminar (máquina de estados garante).
- FIFO limita throughput: 300 msg/s por message group ID. Standard
  não tem esse limite.
- Se eventualmente precisar de ordem por alvo, Kinesis com
  partition key = target_id resolve, sem reabrir decisão.

Resultado: escolha de Standard poupa problemas que nunca aconteceriam
de qualquer forma. Otimização pela ausência.

### Gravicode — Latência de emergência não escala com tráfego

Requisito de negócio: Red flag detection (parada cardíaca, sepse)
deve retornar em <500ms. Tráfego: ~10 consultas/segundo no pico
imaginado.

Solução: **fast path dedicado** que faz keyword match + heurísticas
determinísticas, ignora o pipeline completo de 14 agentes. Se o
keyword disparar, bypass direto pra resposta de emergência.

Por que isso é "escalabilidade sem prematuridade"? Porque:
- O fast path foi projetado pro requisito de latência, não pro
  volume. Volume atual é baixíssimo.
- Se o volume crescer 100x, o fast path continua válido (é Lambda
  independente). Zero refactor necessário.
- Se tivéssemos "otimizado o pipeline inteiro pra 500ms", teríamos
  comprometido qualidade pra um sub-caso raro.

A lição: otimização em ponto específico > otimização global.

## Sinais de Alerta

### Você está escalando prematuramente se:

- **Usa Kafka pra app que processa 10 msg/s**: Kafka paga aluguel
  pesado (brokers, ZooKeeper/KRaft, schema registry, monitoring
  de lag). Use SQS, Redis Streams, ou direto DB-outbox enquanto
  o volume justifica.
- **Shardeia banco antes de maxar um node**: Postgres moderno
  aguenta milhões de rows com bons índices. Antes de sharding,
  tune índice, particionamento, read replicas.
- **Tem fila, cache, e dead-letter em tudo "por precaução"**: cada
  um desses é surface de bug e monitoria. Adicione quando doer.
- **Microserviços desde a primeira linha**: ver regra
  `Bounded Contexts na Prática.md`. Contextos primeiro; deploy
  separado depois, se/quando.

### Você está postergando escala demais se:

- **Dado crítico sem índice em tabela que cresce**: query que
  era 10ms vira 10s sem aviso. Monitore `pg_stat_statements` ou
  equivalente.
- **Hot path síncrono sem timeout**: em degradação, requests
  empilham, thread pool satura, serviço trava. Timeouts são
  gratuitos.
- **Retry sem backoff exponencial**: em falha transiente, storm
  de retries derruba o que já estava quase voltando. Backoff
  exponencial + jitter é padrão, não feature.
- **Sem DLQ em fila de trabalho**: poison pill entra em loop
  infinito de custo crescente. Argos v1 quase explodiu a conta
  AWS por causa disso.

### Failure modes de controle-plane vazando:

- "ThrottlingException" em logs sob carga → plano de controle
  esgotado, não plano de dados. Reformule arquitetura (pull em
  vez de push).
- Tasks Fargate falham com `CapacityProviderReservation` ou erro
  de ENI → subnet pequena demais ou cota regional; não é bug de
  código.
- Lambda cold starts matando SLA → pre-warm ou migre pra provisioned
  concurrency **só** no hot path; não generalize.

### Teste de fumaça

Para qualquer componente "que escala":
1. Qual é o throughput atual medido (não estimado)?
2. Qual é o throughput alvo do próximo ano (com evidência de
   crescimento)?
3. Qual é o limite teórico da arquitetura atual?
4. Se (2) > (3), qual é o próximo ponto de corte e quanto ele custa?

Se não conseguir responder os quatro com número, você ou está
escalando prematuramente (sem (2)), ou está por ser surpreendido
(sem (3) ou (4)).

## Conexões

- Layering (quem faz pull vs push): regra
  `Layering e Dependency Direction.md`
- Event-driven (ordem vs throughput, Kafka vs queues): regra
  `Event-Driven Decoupling.md`
- Dual-store (quando ganhamos throughput separando cargas): regra
  `Dual-Store Architecture.md`
- Sysdesign-pack: `sysdesign-scalability-horizontal-vs-vertical`
  é genérico; esta regra foca na decisão concreta Ticker/GSI vs
  rules-per-target do Argos.
