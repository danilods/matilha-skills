---
type: concept
sources:
  - "user-neuroscience-experience"
created: 2026-04-11
updated: 2026-04-17
tags:
  - implementation-patterns
  - onboarding
  - engagement
  - retention
  - metrics
  - anti-patterns
phase: reference
author: matilha
license: MIT
---

# Padroes de Implementacao para Neuro-Experience Design

Padroes praticos organizados por categoria — cada um conecta principios neurocientificos a implementacao concreta em produto.

---

## 1. Padroes de Onboarding

### Quick Win (Self-Efficacy + Endowed Progress)

- Primeiro valor em <60 segundos
- Pre-popular dados sempre que possivel
- "Voce ja esta 40% configurado!" — endowed progress em acao
- Celebrar primeira acao com feedback visual e emocional

**Exemplo**: Canva — design com template em <30s.
**Metrica**: Time-to-first-value (TTFV)

### Progressive Disclosure (Cognitive Load + Spacing Effect)

- **Layer 1 (Dia 1)**: so feature core — o minimo para entregar valor
- **Layer 2 (Semana 1)**: features secundarias com tooltips contextuais
- **Layer 3 (Mes 1)**: features avancadas baseadas em uso real

**Exemplo**: Slack — messaging primeiro, channels/threads/integrations depois.
**Metrica**: feature discovery rate

### Guided Exploration (Testing Effect + Schema Theory)

- Aprender fazendo, nao lendo
- Checklists interativos > modals tutorial
- "Try it now" contextual em vez de documentacao passiva
- Sandbox com dados sample para experimentacao segura

**Metrica**: tutorial completion rate, drop-off por step

### Social Proof Onboarding (Cialdini + SDT Belonging)

- "12,000 marketers ja usam este template"
- Exemplos de usuarios similares ao perfil do novo usuario
- "Teams do seu tamanho configuram 3 projetos na primeira semana"

**Metrica**: onboarding conversion rate

---

## 2. Padroes de Engagement Loop

### Variable Reward Feed (Schultz + Skinner)

- Misturar tipos de conteudo e magnitudes de recompensa
- Achievements inesperados entre acoes rotineiras
- Variar conteudo de notificacoes para manter novelty
- Curadoria algoritmica com novidade controlada

> [!warning] CUIDADO
> Variable rewards amplificam bom conteudo — nao consertam conteudo ruim.

**Metrica**: session frequency, pull-to-refresh rate

### Streak (Loss Aversion + Commitment)

- Contador visual proeminente
- Lembrete antes de quebrar ("Seu streak de 14 dias acaba hoje!")
- "Freeze" como feature premium — monetiza loss aversion
- Milestones celebrados: 7, 30, 100, 365 dias

> [!warning] CUIDADO
> Streaks podem ser estressantes. Implementar grace periods. Nunca usar linguagem punitiva.

**Metrica**: streak length distribution, churn pos-quebra

### Open Loop (Zeigarnik Effect + Anticipation)

- Sessao termina com "2 respostas nao lidas", "Relatorio 80% pronto"
- Previews de conteudo futuro
- Cliffhangers deliberados
- Progress bars deliberadamente incompletas

**Metrica**: return rate from notifications

### Social Investment Loop (IKEA Effect + Reciprocity + Network Effects)

- Follow/connect cria obrigacao mutua
- Features colaborativas aumentam switching costs
- Likes/comments criam reciprocity pressure
- Portfolio/perfil acumula valor ao longo do tempo

**Metrica**: connections/user, UGC volume

---

## 3. Padroes de Retencao

### Competence Loop (SDT + Flow)

- Manter challenge-skill balance conforme usuario cresce
- Dificuldade adaptativa baseada em performance
- Progressao visivel (levels, badges, milestones)
- Novos desafios desbloqueiam com maestria
- Mentorship para usuarios avancados — papel de expert

**Metrica**: time-in-flow (session sem idle), advanced feature adoption

### Stored Value Moat (Endowment + Sunk Cost + Investment)

- **Dados acumulados**: historico, analytics, logs
- **Customizacao**: settings, workflows, templates pessoais
- **Reputacao**: ratings, followers, contribuicoes
- **Integracoes**: conexoes com outros servicos
- **Dashboard "Seus dados"**: tornar stored value visivel

**Metrica**: stored value per user, churn rate por nivel de stored value

### Re-engagement Trigger (External → Internal transition + Loss Aversion)

- **Event-based**: "Um colega te mencionou"
- **Time-based**: horario personalizado por padrao de uso
- **Loss-based**: "Seu streak acaba hoje"
- **Social**: "3 pessoas viram seu perfil"

> [!danger] CRITICO
> Frequency caps sao obrigatorios. Muitos triggers → unsubscribe → churn permanente.

**Metrica**: notification CTR, unsubscribe rate

### Habit Bridge (Tiny Habits + Habit Stacking)

- Ancorar uso no ritual existente do usuario:
  - Morning digest
  - Post-meeting summary
  - End-of-day review
- Formula: **After I [ANCHOR], I will [TINY BEHAVIOR], then I [CELEBRATE]**

**Metrica**: consistent time-of-day usage

---

## 4. Padroes de Dopamina e Recompensa

### Surprise & Delight (Positive Prediction Error)

- Easter eggs escondidos no produto
- Milestones inesperados ("Voce ja ajudou 100 pessoas!")
- Mensagens personalizadas em momentos aleatorios
- Surpresas sazonais
- Micro-animations: confetti, sparkles, high-fives

> [!important] CHAVE
> DEVE ser inesperado. Rewards agendados se tornam esperados e perdem potencia (Schultz prediction error).

**Exemplos**: Mailchimp high-five ao enviar campanha, Slack loading messages, Duolingo owl

### Anticipation Builder (Dopamina na antecipacao + Scarcity)

- "Coming soon" teasers que geram expectativa
- Countdown timers para lancamentos
- Preview access para usuarios engajados
- Filas "you're next" — scarcity + anticipation
- "Seus stats estao sendo calculados..." — delay deliberado

**Metrica**: pre-event engagement, waitlist conversion

### Progress Architecture (Goal Gradient + Endowed Progress + Zeigarnik)

- **Micro** (per-task): checkmarks, conclusao individual
- **Meso** (per-project): progress bars, % completo
- **Macro** (journey): levels, lifetime stats, marcos de carreira

> [!tip] Principio
> Comecar em 20% (nao 0%). Acelerar visual perto da conclusao — goal gradient effect.

---

## 5. Anti-Patterns

### Dark Patterns (evitar)

- **Roach Motel**: facil entrar, impossivel sair
- **Confirmshaming**: "Nao, eu nao quero economizar dinheiro"
- **Hidden Costs**: custos revelados so no checkout
- **Forced Continuity**: cobranca silenciosa apos trial
- **Bait and Switch**: prometido ≠ entregue
- **Privacy Zuckering**: compartilhar mais dados do que o usuario pretende
- **Infinite Scroll sem proposito**: engagement vazio sem valor

### Cognitive Overload

| Problema | Solucao |
|----------|---------|
| Feature Bloat | Progressive disclosure |
| Wall of Text | Chunking |
| Decision Avalanche | Smart defaults |
| Context Switching | Reduzir profundidade de navegacao |
| Notification Fatigue | Frequency caps |

### Motivation Killers

| Problema | Solucao |
|----------|---------|
| Empty State | Templates e samples pre-populados |
| Punishment for Inactivity | Re-engagement gentil, sem culpa |
| Invisible Progress | Indicadores visuais de avanco |
| Unreachable Goals | Milestones intermediarios |
| Extrinsic Overkill | Reservar rewards para acoes significativas |

---

## 6. Metricas e Instrumentacao

### Por Framework

- **Hooked** ([hook-model](../concepts/hook-model.md)): trigger CTR, task completion, satisfaction post-reward, data stored
- **Flow proxies**: session duration sem idle, task switching frequency, help-seeking rate
- **Cognitive Load**: time-on-task vs expected, error rate, abandonment by step, doc views/session
- **Engagement**: DAU/MAU, session frequency, time-between-sessions
- **WOW** ([peak-end-rule](../concepts/peak-end-rule.md)): time-to-Aha!, D1/D7/D30 retention, NPS, referral rate

### A/B Testing

- 1 variavel por vez
- Minimo 2-4 semanas de duracao
- Medir LONG-TERM (nao so conversao imediata)
- Incluir well-being metrics
- Cuidado com novelty effects — esperar estabilizar

### Benchmarks

| Metrica | Good | Great | World-Class |
|---------|------|-------|-------------|
| DAU/MAU | 20% | 40% | 60%+ |
| D1 Retention | 40% | 55% | 70%+ |
| D7 Retention | 20% | 30% | 45%+ |
| D30 Retention | 10% | 15% | 25%+ |
| Time-to-Value | <5min | <2min | <30s |
| Onboarding Completion | 40% | 60% | 80%+ |

> [!important] Aha! Moments — Benchmarks de Produto
> - **Facebook**: 7 friends in 10 days
> - **Slack**: 2,000 messages
> - **Dropbox**: 1 file in 1 folder
> - **Twitter**: following 30 users
> - **Pinterest**: first repin na primeira sessao

---

## Links

- neuro-experience-skill — skill completa de Neuro-Experience Design
- [frameworks-comportamentais](../concepts/frameworks-comportamentais.md) — frameworks teoricos que fundamentam estes padroes
- principios-cognitivos-produto — principios cognitivos aplicados a produto
- [hook-model](../concepts/hook-model.md) — modelo Hooked detalhado
- [peak-end-rule](../concepts/peak-end-rule.md) — Peak-End Rule e WOW moments
