---
type: concept
sources:
  - "acing-system-design-interview"
created: 2026-04-11
updated: 2026-04-17
tags:
  - nfr
  - scalability
  - availability
  - fault-tolerance
  - latency
  - consistency
phase: reference
author: matilha
license: MIT
---

# Non-Functional Requirements em System Design

## Princípio: NFRs Primeiro

- Clientes raramente especificam NFRs explicitamente — assumem que o sistema os satisfará. "Requisitos declarados serão quase sempre incompletos, incorretos e às vezes excessivos"
- Sempre clarificar NFRs ANTES de desenhar arquitetura
- Template: "Antes de desenhar, gostaria de clarificar: Scalability (QPS?), Availability (SLA?), Latency (P99?), Consistency (strong ou eventual?), Cost (restrições?)"

## Os 10 NFRs

1. **Scalability** — Vertical (upgrade host) vs Horizontal (mais hosts). Horizontal = "true" scalability. Stateless services escalam facilmente; writes em shared storage são difíceis
2. **Availability** — % de tempo operacional. 99.9% = 8.77h downtime/ano, 99.99% = 52.6min, 99.999% = 5.26min. Estratégias: replicação, monitoring, tradeoff CAP, comunicação assíncrona. MTTR/MTBF
3. **Fault-tolerance** — Replicação (3 instâncias: 1 leader + 2 followers), Circuit Breaker (Resilience4j), Exponential Backoff + Jitter, Caching responses, Checkpointing, Dead letter queue, Bulkhead, Fallback
4. **Performance/Latency** — Latency = tempo total request-response. Throughput vs Bandwidth. Targets: consumer apps 10ms-seconds, HFT < ms. Técnicas: GeoDNS, CDN, caching, RPC > REST
5. **Consistency** — ACID (foreign keys, uniqueness) vs CAP (linearizability). Favor linearizability: HBase, MongoDB, Redis. Favor availability: Cassandra, CouchDB, Dynamo. Técnicas: Full Mesh (não escala), Coordination Service (ZooKeeper/Raft), Distributed Cache (Redis), Gossip Protocol (Cassandra)
6. **Accuracy** — HyperLogLog para COUNT DISTINCT, Count-min sketch para frequências. Cache staleness
7. **Security** — TLS termination, encryption at rest, OAuth 2.0 / OpenID Connect, rate limiting contra DDoS
8. **Privacy** — GDPR, CCPA. PII protection. LDAP access control. Encryption in transit + at rest
9. **Cost** — Tradeoffs: vertical > horizontal (mais caro, menos complexo), menor redundância (menor custo, menor availability), DC mais distante (menor custo, maior latency)
10. **Complexity** — Common services reduzem (LB, rate limiting, auth, logging, caching, CI/CD)

## Load Balancers

- Hardware ($1K-$100K+) vs LBaaS vs Software (HAProxy, NGINX)
- L4 (TCP, mais rápido, routing por endereço) vs L7 (HTTP, mais features, auth, TLS termination)
- Sticky sessions: duration-based ou application-controlled cookies

## 4 Golden Signals (Monitoring)

1. **Latency** — tempo de resposta (P99)
2. **Traffic** — requests/segundo
3. **Errors** — 4xx/5xx rates
4. **Saturation** — CPU/Memory/Disk usage

## Fluxo de Entrevista (50 min)

```
0-10min:  Clarificar requirements (func + non-func)
10-15min: Draft API specification (REST endpoints)
15-25min: Data model + high-level architecture
25-40min: Deep dive em componentes críticos
40-50min: Logging, monitoring, edge cases
```

> [!important] Conexão com UX
> NFRs não são abstrações técnicas — impactam diretamente a experiência do usuário. Latency alta = reservatorio-boa-vontade esvazia (Krug). Downtime = trust destruído (emocoes-sentimentos — trust é visual primeiro mas availability é o que sustenta). Rate limiting protege o sistema mas rate limit agressivo demais frustra o usuário (erros-usabilidade — stress aumenta erros).

Link to acing-system-design, [scaling-databases](../concepts/scaling-databases.md), distributed-transactions, [design-cases](../concepts/design-cases.md), zhiyong-tan
