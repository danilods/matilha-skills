---
type: concept
sources:
  - "user-neuroscience-experience"
created: 2026-04-11
updated: 2026-04-17
tags:
  - hook-model
  - habit-formation
  - nir-eyal
  - engagement
  - variable-rewards
phase: reference
author: matilha
license: MIT
---

# Hook Model — Nir Eyal

"Hooked: How to Build Habit-Forming Products" (2014)

Conceito dedicado porque e referenciado em multiplos contextos na wiki — onboarding, engagement loops, retencao, metricas.

---

## O Ciclo

```
Trigger → Action → Variable Reward → Investment
   ↑                                      |
   └──────────────────────────────────────┘
```

Cada volta do ciclo fortalece o habito. O objetivo e transicionar o usuario de triggers externos para triggers internos.

---

## 1. Trigger (Gatilho)

- **Externo**: notificacoes, emails, ads, word-of-mouth, icone do app
- **Interno**: emocoes (tedio → Instagram, solidao → Facebook, incerteza → Google, ansiedade → Twitter)

**Meta**: transicao de externo → interno. Quando o usuario sente a emocao, ja pensa no produto sem prompt externo.

**Pergunta-chave**: "Que trigger interno seu produto endereca?"

---

## 2. Action (Acao)

- O comportamento mais simples em antecipacao de recompensa
- Segue Fogg B=MAP: ocorre quando **Motivation + Ability + Prompt** convergem
- 6 elementos de simplicidade:
  1. Tempo
  2. Dinheiro
  3. Esforco fisico
  4. Brain cycles
  5. Desvio social
  6. Nao-rotina

**Design**: reduzir friccao ao minimo absoluto. A acao deve ser mais simples que pensar sobre ela.

---

## 3. Variable Reward (Recompensa Variavel)

- **Tribe** (social): validacao, aceitacao, pertencimento — likes, comments, followers
- **Hunt** (material): recursos, informacao, deals — scrolling feeds, resultados de busca
- **Self** (intrinseco): maestria, competencia, conclusao — leveling up, streaks, completar tarefas

**VARIABILIDADE** e o que cria desejo. Recompensas previsiveis perdem potencia (Schultz prediction error).

Conexao direta com dopamina-comportamento: dopamina = wanting, nao liking. Variable ratio > fixed ratio ([motivacao-comportamento](../concepts/motivacao-comportamento.md)).

---

## 4. Investment (Investimento)

- Usuario deposita algo que melhora a experiencia futura:
  - Dados
  - Conteudo
  - Followers
  - Reputacao
  - Skill
- Aumenta switching costs e carrega o proximo trigger
- **NAO** e gratificacao imediata — e armazenar valor futuro

Conexao: tomada-decisao — endowment effect, sunk cost.

---

## Template de Analise

Para cada user flow chave, responder:

1. **Trigger**: Qual e o trigger interno? (emocao ou situacao)
2. **Action**: Qual e a acao mais simples que o usuario toma?
3. **Variable Reward**: Que recompensa variavel recebe?
4. **Investment**: Que investimento faz que carrega o proximo trigger?

---

## Filtro Etico

Nir Eyal depois escreveu "Indistractable" (2019) como contrapeso etico a "Hooked".

Pergunta fundamental: **o produto melhora a vida do usuario ou explora vulnerabilidades?**

O Hook Model e uma ferramenta — a intencao determina se cria valor ou dependencia.

> [!warning] Conexao com Weinschenk
> Cada fase do Hook Model tem base neurocientifica documentada na wiki:
>
> - **Trigger interno** = processamento-inconsciente — decisoes emocionais precedem conscientes
> - **Action** = cognicao-pensamento — cognitive load, Fitt's Law
> - **Variable Reward** = dopamina-comportamento — wanting system, variable ratio
> - **Investment** = tomada-decisao — endowment effect, sunk cost

---

## Links

- [frameworks-comportamentais](../concepts/frameworks-comportamentais.md) — outros frameworks comportamentais
- [padroes-implementacao](../concepts/padroes-implementacao.md) — padroes praticos baseados no Hook Model
- neuro-experience-skill — skill completa de Neuro-Experience Design
- dopamina-comportamento — sistema dopaminergico e wanting
- [motivacao-comportamento](../concepts/motivacao-comportamento.md) — motivacao intrinseca vs extrinseca
