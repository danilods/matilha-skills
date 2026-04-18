---
type: concept
sources:
  - "acing-system-design-interview"
created: 2026-04-11
updated: 2026-04-17
tags:
  - databases
  - replication
  - sharding
  - caching
  - distributed-transactions
  - event-sourcing
phase: reference
author: matilha
license: MIT
---

# Scaling Databases e Transações Distribuídas

## Replicação

- **Single-Leader**: todas writes no leader, replicas para reads. Simples, mas leader é bottleneck
- **Multi-Leader**: múltiplos leaders, requer handling de race conditions e conflitos
- **Leaderless**: quorum-based (Cassandra/Dynamo), sem SPOF

## Sharding

- Divide dados em subsets distribuídos. Shard key crítico — má escolha = hot spots
- Range-based vs hash-based sharding

## Tipos de Storage

| Tipo | Exemplos | Use Case |
|------|----------|----------|
| SQL | MySQL, Postgres | ACID, relações |
| Key-Value | Redis, Memcached | Caching, sessions |
| Column | Cassandra, HBase | Time-series, analytics |
| Document | MongoDB | Schema flexível |
| Graph | Neo4j | Relacionamentos complexos |

## Caching Strategies

- **Cache-Aside**: App consulta cache primeiro, DB em cache miss, armazena resultado
- **Write-Through**: todo write passa pelo cache → garante consistência, mais latência em writes
- **Write-Around**: write direto no DB, cache atualizado só em read miss — risco de stale data

## Message Queues: Kafka vs RabbitMQ

| Feature | Kafka | RabbitMQ |
|---------|-------|----------|
| Durabilidade | Built-in, configurable retention | Lazy queue |
| Escalabilidade | Nativa (partitions) | Manual |
| Retenção | Configurável (dias/semanas) | Remove ao dequeue |
| Use case | Event streaming, CDC | Task queues, RPC |

## Transações Distribuídas

- **Problema**: manter consistência ao escrever em múltiplos serviços
- **Event Sourcing**: log de eventos como source of truth. Estado atual = replay de todos eventos. Audit trail completo
- **CDC (Change Data Capture)**: propaga mudanças do DB para downstream via log mining → Kafka
- **Saga**: sequência de transações locais com compensating transactions para rollback
  - **Choreography**: serviços comunicam diretamente via Kafka (paralelo, menor latência, mais acoplamento)
  - **Orchestration**: orchestrator central controla sequência (linear, mais latência, menor acoplamento, mais legível)
- **2PC (Two-Phase Commit)**: prepare → commit. Não recomendado para serviços — "podemos mencionar brevemente e explicar por que não usar"

## Lambda / Kappa Architecture

- **Lambda**: batch + streaming em paralelo. Batch para correção, streaming para velocidade
- **Kappa**: só streaming. Mais simples, mas nem sempre viável

> [!tip] Decisão prática
> "Se puder usar Kafka para distribuir writes e permitir que downstream services façam pull em vez de push, faça isso." Event-driven > sincronismo para a maioria dos casos.

Link to [nfr-system-design](../concepts/nfr-system-design.md), acing-system-design, [design-cases](../concepts/design-cases.md), distributed-transactions
