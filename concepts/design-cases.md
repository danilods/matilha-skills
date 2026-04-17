---
type: concept
sources:
  - "acing-system-design-interview"
created: 2026-04-11
updated: 2026-04-17
tags:
  - system-design
  - case-studies
  - architecture-patterns
  - distributed-systems
phase: reference
author: matilha
license: MIT
---

# Design Cases — Casos Práticos de System Design

## Visão Geral

11 casos práticos que aplicam os fundamentos de [nfr-system-design](../concepts/nfr-system-design.md) e [scaling-databases](../concepts/scaling-databases.md). Cada caso segue o fluxo: requirements → API → data model → architecture → deep dive → monitoring.

## Casos por Categoria

### Plataformas / Marketplaces

- **Design Craigslist** (Cap 7): Marketplace de classificados. Posts, search (Elasticsearch), email notifications, CDN para assets. Endpoints idempotentes para evitar duplicatas. SQL scaling para reads pesados.
- **Design Airbnb** (Cap 15): Plataforma de reservas. Listings, bookings, availability check, overlapping bookings prevention, approval workflow. Desafio: consistência em bookings simultâneos (precisa de lock ou atomic operations).

### Serviços de Infraestrutura

- **Design Rate Limiting** (Cap 8): Algoritmos: token bucket (burst-friendly), leaky bucket (steady rate), fixed window (simples), sliding window (preciso). Stateful (Redis counter) vs stateless (sidecar). "Em caso de dúvida, não limite o usuário."
- **Design CDN** (Cap 13): Content Distribution Network. Autenticação, cache invalidation, storage in-cluster vs out-cluster. Edge servers globais. Cache miss → origin server.
- **Design Batch Auditing** (Cap 10): Auditoria de qualidade de dados em batch. SQL validations, alerting para silent errors, cross-data-center consistency. Checkpointing para recovery.

### Comunicação e Notificações

- **Design Notifications** (Cap 9): Multi-canal (email, push, SMS). Templates, scheduling, grupos de destinatários, deduplicação, retry com dead letter queue. Desafio: grupos enormes — event creation precisa de limites.
- **Design Messaging** (Cap 14): App de texto. WebSocket para real-time, exactly-once delivery, sender/message services separados. Encryption para privacidade. Buffer para traffic surges.

### Search e Discovery

- **Design Autocomplete** (Cap 11): Weighted trie, sampling de queries, fuzzy matching, content moderation (filtrar termos inapropriados). Ingestion aceita e loga requests, deve aguentar spikes. Elasticsearch como backend.

### Mídia e Conteúdo

- **Design Flickr** (Cap 12): Photo-sharing. Upload/download, thumbnail generation (client vs server), CDN para distribuição, object store (S3). Escala de reads >> writes.
- **Design News Feed** (Cap 16): Feed tipo Facebook/Twitter. Pre-computed feeds, content moderation, personalização, fan-out (push to followers). Desafio: celebridades com milhões de followers (fan-out on read vs fan-out on write).

### Analytics e Dashboards

- **Design Dashboard Top 10** (Cap 17): Dashboard real-time. Aggregation service, batch vs streaming (Lambda/Kappa architecture). Count-min sketch para top-K eficiente. Batch jobs falham inevitavelmente — checkpointing obrigatório.

## Padrões Recorrentes nos Casos

| Padrão | Aparece em | Descrição |
|--------|-----------|-----------|
| **Idempotência** | Craigslist, Messaging | Write endpoints idempotentes para evitar duplicatas |
| **CDN + Object Store** | Craigslist, Flickr, CDN | Conteúdo estático em CDN, mídia em S3/object store |
| **Elasticsearch** | Craigslist, Autocomplete | Full-text search e search de alta performance |
| **Kafka** | Notifications, Auditing, Feed, Dashboard | Event streaming e desacoplamento |
| **Dead Letter Queue** | Notifications, Messaging | Retry de mensagens falhas |
| **Content Moderation** | Autocomplete, Feed, Flickr | Filtrar conteúdo inapropriado antes de servir |
| **Rate Limiting** | Rate Limiting (dedicado), todos os casos | Proteção contra abuso |
| **Circuit Breaker** | Implícito em todos | Proteção contra cascade failure |

## Apêndices Relevantes

### Monoliths vs Microservices (Appendix A)

- Monolith: simples para começar, deployment único, sem overhead de rede entre serviços. Limitações: scaling, ownership, blast radius
- Microservices: scaling independente, ownership por equipe, deploy independente. Custo: complexidade de rede, duplicação de componentes (auth, logging em cada service), debugging distribuído

### OAuth 2.0 / OpenID Connect (Appendix B)

- OAuth 2.0: authorization (permissão para recursos). Flows: authorization code, client credentials
- OpenID Connect: authentication (identidade) construído sobre OAuth. SSO. JWT tokens

### C4 Model (Appendix C)

- 4 níveis de diagramas: Context (sistema no ambiente), Container (apps/DBs), Component (módulos dentro de container), Code (classes). Útil para comunicar arquitetura em diferentes níveis de detalhe

### 2PC — Two-Phase Commit (Appendix D)

- Prepare phase → Commit phase. Coordinator + participants
- Não recomendado para serviços distribuídos — preferir Saga/Event Sourcing

> [!warning] Conexão com UX
> Cada decisão de arquitetura impacta o usuário final. Fan-out on write no news feed = latência menor para leitura = experiência mais fluida ([leis-de-krug](../concepts/leis-de-krug.md) — "não me faça pensar/esperar"). Rate limiting agressivo pode frustrar usuários legítimos ([reservatorio-boa-vontade](../concepts/reservatorio-boa-vontade.md)). Content moderation inadequada destrói trust ([emocoes-sentimentos](../concepts/emocoes-sentimentos.md)).

---

[acing-system-design](../concepts/acing-system-design.md) | [nfr-system-design](../concepts/nfr-system-design.md) | [scaling-databases](../concepts/scaling-databases.md) | [zhiyong-tan](../concepts/zhiyong-tan.md)
