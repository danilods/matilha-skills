---
type: concept
sources:
  - "acing-system-design-interview"
created: 2026-04-11
updated: 2026-04-17
tags:
  - api-gateway
  - service-mesh
  - api-design
  - microservices
  - architecture-patterns
phase: reference
author: matilha
license: MIT
---

# Common Services e API Design

## Functional Partitioning

- Separar funções em serviços dedicados. Centralizar cross-cutting concerns
- Reduz complexidade de cada serviço individual, mas adiciona complexidade de rede/deployment

## API Gateway

Centraliza:

1. Authentication / Authorization
2. SSL Termination
3. Rate Limiting
4. Request Validation / Deduplication
5. Caching
6. Logging / Analytics

Exemplo: Kong, AWS API Gateway, Apigee

## Service Mesh (Sidecar Pattern)

- Alternativa ao API Gateway: proxy local (sidecar) em cada serviço
- Cada serviço tem um proxy adjacente que gerencia cross-cutting concerns
- Exemplo: Istio, Linkerd
- Trade-off: mais distribuído (sem SPOF do gateway), mais complexo de operar

## Library vs Service

| Aspecto | Library | Service |
|---------|---------|---------|
| Performance | Melhor (in-process) | Network hop |
| Language | Específica | Agnóstico |
| Deploy | Com a app | Independente |
| Scaling | Com a app | Independente |

## Paradigmas de API

### REST

- Stateless, HTTP methods, JSON. Amplamente usado, baixa curva de aprendizado
- OpenAPI/Swagger para documentação
- Best for: APIs públicas, CRUD simples

### RPC / gRPC

- Protocolo binário (protobuf). Eficiente, fortemente tipado, schema built-in
- Best for: comunicação interna entre serviços, alta performance

### GraphQL

- Client especifica exatamente os dados que precisa. Flexível
- "Cuidado ao usar GraphQL para APIs externas"
- Best for: queries complexas, mobile apps (minimiza over/under-fetching)

| Feature | REST | RPC | GraphQL |
|---------|------|-----|---------|
| Formato | JSON | Binary (protobuf) | JSON |
| Docs | OpenAPI | Built-in schema | Built-in |
| Flexibilidade | Baixa | Baixa | Alta |
| Performance | Boa | Melhor | Boa |
| Curva | Baixa | Média | Alta |

## Metadata Service

- Armazena informação comum usada por múltiplos componentes
- Evita duplicação e inconsistência
- Exemplo: configurações de feature flags, settings de serviços

## ELK Stack (Logging)

- **Elasticsearch**: search engine distribuído
- **Logstash**: ingestão e transformação de logs
- **Kibana**: visualização e dashboards
- **Beats**: agentes leves de coleta

## Observability

- **Logging**: o que aconteceu
- **Monitoring**: métricas agregadas (4 golden signals)
- **Tracing**: caminho de uma request entre serviços (Jaeger, Zipkin)
- **Alerting**: notificação quando métricas violam thresholds. Runbook para resposta

> [!tip] Padrão recorrente
> O API Gateway é para microservices o que a navegação é para websites (navegacao-web): centraliza o ponto de entrada, orienta o tráfego, e garante que cross-cutting concerns (auth, rate limiting) sejam tratados consistentemente — da mesma forma que a navegação persistente garante que o usuário sempre saiba onde está.

---

acing-system-design | [nfr-system-design](../concepts/nfr-system-design.md) | [design-cases](../concepts/design-cases.md) | [scaling-databases](../concepts/scaling-databases.md)
