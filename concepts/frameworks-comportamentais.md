---
type: concept
sources:
  - "user-neuroscience-experience"
created: 2026-04-11
updated: 2026-04-17
tags:
  - behavioral-design
  - frameworks
  - kahneman
  - fogg
  - cialdini
  - gamification
phase: reference
author: matilha
license: MIT
---

# Frameworks de Design Comportamental

15 modelos de design comportamental integrados no meta-framework [neuro-experience-skill](../concepts/neuro-experience-skill.md), organizados por área de aplicação.

---

## Formação de Hábitos

### Hook Model — Nir Eyal (2014)

4 fases cíclicas: **Trigger → Action → Variable Reward → Investment**

**Trigger**
- Externo: notificações, emails, CTAs
- Interno: emoções (tédio, solidão, incerteza, FOMO)
- Meta: transição de triggers externos para **internos** (o usuário pensa no produto por conta própria)

**Action**
- Comportamento mais simples em antecipação de recompensa
- Segue Fogg B=MAP
- 6 elementos de simplicidade: tempo, dinheiro, esforço físico, brain cycles, desvio social, não-rotina

**Variable Reward** (3 tipos)
- **Tribe**: recompensa social — likes, followers, comentários
- **Hunt**: recompensa material — informação, deals, conteúdo novo
- **Self**: recompensa intrínseca — maestria, completion, streaks

A **variabilidade** é o que cria desejo — não a recompensa em si.

**Investment**
- Usuário coloca algo que melhora experiência futura: dados, conteúdo, followers, reputação, skill
- Aumenta switching costs e carrega o próximo trigger

### Fogg Behavior Model — B=MAP (2019)

**Behavior = Motivation x Ability x Prompt** — todos 3 necessários *ao mesmo tempo*.

**Motivation** (3 dimensões):
- Pleasure / Pain
- Hope / Fear
- Acceptance / Rejection

**Ability** (6 fatores — elo mais fraco domina):
- Tempo, dinheiro, esforço físico, brain cycles, desvio social, não-rotina

**Prompt** (3 tipos):
- **Facilitator**: alta motivação + baixa habilidade → simplifica a ação
- **Spark**: baixa motivação + alta habilidade → inspira e motiva
- **Signal**: ambos altos → lembra e direciona

> [!important] Princípio central
> "Foque em ability primeiro — é mais fácil simplificar do que aumentar motivação."

### Atomic Habits — James Clear (2018)

4 Laws (e seus inversos para quebrar hábitos):

| Para criar | Para quebrar |
|---|---|
| Make it **Obvious** | Make it Invisible |
| Make it **Attractive** | Make it Unattractive |
| Make it **Easy** | Make it Difficult |
| Make it **Satisfying** | Make it Unsatisfying |

Conceitos-chave: habit stacking, two-minute rule, identity-based change, environment design.

### Tiny Habits — BJ Fogg (2019)

Recipe: **After I** [ANCHOR], **I will** [TINY BEHAVIOR], **then I** [CELEBRATE].

- Começar com a **menor versão possível** do comportamento
- Ancorar em padrões já existentes do usuário
- Scale up **depois** que o hábito está estabelecido

---

## Decisão e Cognição

### Dual Process Theory — Kahneman (2011)

**System 1** — automático, inconsciente, sem esforço
- Pattern recognition, reações emocionais
- ~95% das decisões diárias
- Ativado por: interfaces familiares, visual cues, emotional triggers

**System 2** — deliberado, consciente, esforçado
- Análise lógica, cálculos complexos
- Sujeito a fadiga (ego depletion)
- Ativado por: interfaces novas, formulários complexos, terminologia desconhecida

**Biases com aplicação a produto:**

| Bias | Aplicação |
|---|---|
| **Anchoring** | Mostrar preço alto primeiro |
| **Availability Heuristic** | Destacar casos de sucesso recentes |
| **Loss Aversion (~2x)** | Frame como "não perca" em vez de "ganhe" |
| **Status Quo Bias** | Defaults inteligentes a favor do usuário |
| **Framing Effect** | "95% satisfação" > "5% insatisfação" |
| **Endowment Effect** | Free trial com features completas → relutância em perder |
| **Sunk Cost** | "Você já investiu X horas/dados aqui" |
| **Bandwagon** | "12,847 equipes já usam" |
| **IKEA Effect** | Usuário que personaliza valoriza mais o produto |

> [!tip] Conexão
> System 1/2 é o mecanismo por trás do que Weinschenk documenta em [processamento-inconsciente](../concepts/processamento-inconsciente.md) e Krug observa empiricamente — satisficing em [leis-de-krug](../concepts/leis-de-krug.md).

### Cognitive Load Theory — Sweller (1988)

3 tipos de carga cognitiva:

| Tipo | Descrição | Ação |
|---|---|---|
| **Intrinsic** | Complexidade inerente da tarefa | Gerenciar (chunking, sequencing) |
| **Extraneous** | Causada por má design | **ELIMINAR** |
| **Germane** | Dedicada a aprendizado | **MAXIMIZAR** |

Leis relacionadas:
- **Miller/Cowan**: 4±1 chunks na working memory
- **Hick's Law**: RT = a + b x log2(n) — tempo de decisão cresce com opções
- **Von Restorff Effect**: item distinto é mais lembrado

### Prospect Theory — Kahneman & Tversky (1979)

- **Loss aversion**: perda pesa ~2x mais que ganho equivalente
- **Reference dependence**: julgamentos são relativos a um ponto de referência
- **Diminishing sensitivity**: diferença entre R$10 e R$20 parece maior que entre R$1010 e R$1020

Aplicação: frame como **evitar perda**, não como ganhar. "Não perca seu streak", "Trial expira em 2 dias", "Seus dados serão deletados".

---

## Engajamento e Experiência

### Flow Theory — Csikszentmihalyi (1990)

3 condições para Flow: **clear goals**, **immediate feedback**, **challenge-skill balance**.

Flow Channel:
- Alto desafio + baixa skill = **ansiedade**
- Baixo desafio + alta skill = **tédio**
- Balance = **FLOW**

8 componentes: concentração, merge de ação/consciência, perda de auto-consciência, senso de controle, distorção temporal, experiência autotélica, metas claras, feedback imediato.

### Peak-End Rule — Kahneman (1993)

Experiências são julgadas pelo **pico** (momento mais intenso) + **final**. Duration neglect — a duração quase não importa.

Implicações:
- Design **deliberate positive peaks** (celebrações, surpresas)
- **Nunca** termine uma sessão em erro
- "Today you accomplished X, Y, Z" como fechamento

### Self-Determination Theory — Deci & Ryan (1985)

3 necessidades psicológicas inatas:
- **Autonomy**: senso de controle e escolha
- **Competence**: senso de eficácia e maestria
- **Relatedness**: senso de conexão e pertencimento

Continuum motivacional: amotivação → extrínseca (4 níveis) → intrínseca. Meta: **mover usuários de motivação externa para interna**.

### Emotional Design — Norman (2004)

3 níveis de processamento:

| Nível | Foco | Exemplo |
|---|---|---|
| **Visceral** | Sensorial, primeira impressão | Visual polish, animações suaves |
| **Behavioral** | Usabilidade, eficiência | Fluxos intuitivos, feedback responsivo |
| **Reflective** | Significado pessoal, auto-imagem | Branding, status, história com o produto |

---

## Persuasão e Social

### Cialdini's 7 Principles (1984, 2021)

| Princípio | Mecanismo | Aplicação |
|---|---|---|
| **Reciprocity** | Dar primeiro → obrigação | Free tools, content, trials generosos |
| **Commitment/Consistency** | Pequeno sim → grande sim | Micro-conversions, progressive profiling |
| **Social Proof** | Seguir a multidão | Números, depoimentos, logos |
| **Authority** | Trust em experts | Certificações, endossos, dados |
| **Liking** | Dizemos sim a quem gostamos | Personalização, tom humano, design agradável |
| **Scarcity** | Menos = mais valioso | "Últimas vagas", "Oferta expira em 2h" |
| **Unity** | Identidade compartilhada | "Para devs como você", comunidade, tribos |

### Dopamine Prediction Error — Schultz (1997)

Dopamina dispara para **UNEXPECTED rewards**, não para recompensas em si.

- **Positive error** (reward > expected) = spike de dopamina
- **No error** (reward = expected) = neutro
- **Negative error** (reward < expected) = dip de dopamina

Princípios:
- **Variable > fixed** — variabilidade sustenta engagement
- **Surprise** é a chave — o inesperado ativa mais
- **Anticipation > receipt** — a expectativa gera mais dopamina que receber
- **Diminishing returns** → precisa de novidade constante

### Octalysis — Yu-kai Chou (2015)

8 core drives:

| # | Core Drive | Tipo |
|---|---|---|
| 1 | Epic Meaning & Calling | White Hat |
| 2 | Development & Accomplishment | White Hat |
| 3 | Empowerment of Creativity & Feedback | White Hat |
| 4 | Ownership & Possession | — |
| 5 | Social Influence & Relatedness | — |
| 6 | Scarcity & Impatience | Black Hat |
| 7 | Unpredictability & Curiosity | Black Hat |
| 8 | Loss & Avoidance | Black Hat |

- **White Hat** (1-3): motivação positiva, mas sem urgência
- **Black Hat** (6-8): cria urgência, mas pode ser manipulativo

Melhores produtos **equilibram ambos**.

> [!warning] Conexão ética
> Todos estes frameworks são ferramentas de influência. Tristan Harris ("Time Well Spent") propõe 4 testes:
> 1. Autonomia mantida?
> 2. Mecanismos transparentes?
> 3. Uso prolongado melhora a vida do usuário?
> 4. Usuário pode desengajar facilmente?
>
> A linha entre persuasão e manipulação é: **a pessoa tomaria a mesma decisão se soubesse dos mecanismos em jogo?**

---

## Links

- [neuro-experience-skill](../concepts/neuro-experience-skill.md)
- [principios-cognitivos-produto](../concepts/principios-cognitivos-produto.md)
- [padroes-implementacao](../concepts/padroes-implementacao.md)
- [hook-model](../concepts/hook-model.md)
- [peak-end-rule](../concepts/peak-end-rule.md)
- [dopamina-comportamento](../concepts/dopamina-comportamento.md)
- [processamento-inconsciente](../concepts/processamento-inconsciente.md)
- [motivacao-comportamento](../concepts/motivacao-comportamento.md)
- [tomada-decisao](../concepts/tomada-decisao.md)
