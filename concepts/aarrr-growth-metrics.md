---
type: concept
sources:
  - "product-growth-hacking"
created: 2026-04-11
updated: 2026-04-17
tags:
  - aarrr
  - pirate-metrics
  - north-star
  - ice-scoring
  - pmf
  - growth-metrics
phase: reference
author: matilha
license: MIT
---

# AARRR, North Star Metric e Growth Metrics

## AARRR — Pirate Metrics (Dave McClure, 2007)

5 estágios mensuráveis do user journey:

### 1. Acquisition — Como usuários encontram o produto

- **Métricas**: visitor count, CPA, channel performance
- **Foco**: channel/product fit — encontrar canais que naturalmente alcançam o público-alvo

### 2. Activation — Primeira experiência positiva

- **Métricas**: activation rate, time to value (TTV), onboarding completion rate
- **Foco**: levar ao "Aha moment" o mais rápido possível
- **Benchmarks famosos**:
  - Facebook: 7 friends em 10 dias
  - Slack: 2,000 messages
  - Twitter: follow 30 pessoas
  - Dropbox: 1 file em 1 folder
  - Pinterest: save weekly por 4 semanas
  - LinkedIn: 5 connections na primeira semana
  - Zoom: host first meeting
- **Conexão**: [padroes-implementacao](../concepts/padroes-implementacao.md) — Quick Win, Progressive Disclosure, Guided Exploration patterns

### 3. Retention — Usuários retornando repetidamente

- 3 fases: Initial (D1-D7), Medium-term (W1-W4), Long-term (M1+)
- **Métricas**: D1/D7/D30 retention, DAU/MAU, churn, cohort analysis
- **Conexão**: [hook-model](../concepts/hook-model.md) (ciclo completo), [padroes-implementacao](../concepts/padroes-implementacao.md) (engagement loops, streaks, stored value moat)

### 4. Revenue — Monetização

- **Métricas**: ARPU, LTV, free-to-paid conversion, expansion revenue
- **Foco**: alinhar pricing com value delivery
- **Conexão**: [plg-estrategias-growth](../concepts/plg-estrategias-growth.md) — pricing psychology

### 5. Referral — Usuários como advocates

- **Métricas**: K-factor (viral coefficient), NPS, referral rate
- **Foco**: referral mechanisms no fluxo natural, não como afterthought
- **Conexão**: [plg-estrategias-growth](../concepts/plg-estrategias-growth.md) — viral loops, network effects

### Princípio de Uso

1. Identificar estágio mais fraco ("leaky bucket")
2. Consertar o mais fraco ANTES de otimizar outros — não adianta adquirir se retention está quebrada
3. Cohort analysis para acompanhar melhorias

## North Star Metric — Sean Ellis (2017)

O ÚNICO KPI que captura o core value entregue ao cliente.

**Características**: reflete valor ao cliente, acionável, escala no tempo, correlaciona com receita (mas NÃO É receita), dá direção clara.

**Exemplos**:

| Produto | North Star Metric |
|---------|-------------------|
| Airbnb | Nights booked |
| Slack | Messages in active teams |
| Facebook | DAU |
| Spotify | Time listening |
| Shopify | Merchants making sales |
| HubSpot | Weekly active teams |
| Zoom | Weekly hosted meetings |
| Netflix | Hours watched |
| Uber | Rides/week |

**Growth Equation**: NSM = f(acquisition x activation x retention x monetization)

**Exemplo Airbnb**: Nights Booked = New Hosts x Listing Quality x Search→Book Conversion x Repeat Booking Rate

## ICE Scoring — Sean Ellis (2017)

Para priorizar experimentos de growth.

**ICE = (Impact + Confidence + Ease) / 3** — cada fator 1-10

- **Impact**: quanto vai mover a métrica-alvo
- **Confidence**: quão certo estamos (maior se data-backed)
- **Ease**: quão fácil de implementar

| Score | Prioridade | Ação |
|-------|-----------|------|
| 8-10 | P0 | Executar imediatamente |
| 6-8 | P1 | Próximo sprint |
| 4-6 | P2 | Backlog |
| <4 | P3 | Reconsiderar |

## Sean Ellis PMF Test (2010)

Pergunta: "Como você se sentiria se não pudesse mais usar [produto]?"

- A) Muito desapontado
- B) Um pouco desapontado
- C) Não desapontado
- D) N/A (não uso mais)

**40%+ "Muito desapontado" = Product-Market Fit forte.**

Abaixo de 40%: prioridade é melhorar o produto antes de investir em growth. Foco em entender o que os "muito desapontados" amam e entregar mais disso.

## Benchmarks SaaS

| Métrica | Poor | Average | Good | Great |
|---------|------|---------|------|-------|
| Activation Rate | <20% | 20-35% | 35-50% | >50% |
| D1 Retention | <25% | 25-40% | 40-55% | >55% |
| D7 Retention | <10% | 10-20% | 20-35% | >35% |
| D30 Retention | <5% | 5-10% | 10-20% | >20% |
| DAU/MAU | <10% | 10-20% | 20-30% | >30% |
| Free-to-Paid | <2% | 2-5% | 5-10% | >10% |
| Monthly Churn | >10% | 5-10% | 3-5% | <3% |
| NPS | <0 | 0-30 | 30-50 | >50 |
| K-factor | <0.2 | 0.2-0.5 | 0.5-0.8 | >1.0 |
| PMF (Very Disappointed) | <20% | 20-30% | 30-40% | >40% |

> [!important] Princípio fundamental
> "Não adianta otimizar acquisition se retention está quebrada. Conserte o leaky bucket primeiro." AARRR é diagnóstico — North Star é direção — ICE é priorização — PMF Test é validação.

## Links

- [product-growth-hacking](../concepts/product-growth-hacking.md) — Resumo da fonte
- [plg-estrategias-growth](../concepts/plg-estrategias-growth.md) — PLG Flywheel, JTBD, estratégias por lever
- [hook-model](../concepts/hook-model.md) — Ciclo de formação de hábito (Trigger → Action → Variable Reward → Investment)
- [padroes-implementacao](../concepts/padroes-implementacao.md) — Padrões de onboarding, engagement, retenção
