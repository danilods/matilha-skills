---
type: concept
sources:
  - "user-neuroscience-experience"
created: 2026-04-11
updated: 2026-04-17
tags:
  - peak-end-rule
  - kahneman
  - emotional-design
  - wow-moments
  - user-experience
phase: reference
author: matilha
license: MIT
---

# Peak-End Rule e WOW Moments

Kahneman et al. (1993) — "When More Pain Is Preferred to Less"

---

## A Regra

Pessoas julgam experiencias por:

1. **O Pico** — momento mais intenso (positivo ou negativo)
2. **O Final** — como terminou

**Duration neglect**: duracao tem pouco impacto na memoria. Uma experiencia mediocre com final excelente e lembrada melhor que uma boa experiencia com final ruim.

---

## Aplicacao a Produto

### Design do Pico

- Identificar o **WOW moment / Aha! moment** do produto — o momento em que o usuario percebe o core value
- Mapear todo caminho de signup → Aha! moment
- Eliminar passos desnecessarios
- Reduzir friccao nos restantes

**Benchmarks de Aha! Moments**:
- **Facebook**: 7 friends in 10 days
- **Slack**: 2,000 messages
- **Dropbox**: 1 file in 1 folder
- **Twitter**: following 30 users
- **Pinterest**: first repin na primeira sessao

### Design do Final

**NUNCA** terminar sessao com erro, loading screen, ou nada.

Padrao **"Emotional Bookend"**:
1. **Session summary**: "Hoje voce fez X, Y, Z"
2. **Encouragement**: "Otimo trabalho! 3 dias de streak"
3. **Teaser**: "Amanha, confira o novo recurso"
4. **Gratitude**: agradecimento genuino

**Metrica**: last-action-in-session distribution, next-session return rate por tipo de final

### Signature Moments

- UMA experiencia unica, multi-sensorial (visual + motion + sound + copy), que o usuario lembra e conta para outros
- Deve ser distinta — algo que so o seu produto faz

**Exemplos**:
- Mailchimp high-five ao enviar campanha
- Slack loading messages
- Stripe docs (developer experience como peak moment)
- Duolingo owl

**Metrica**: mencoes organicas, NPS, word-of-mouth attribution

### Emotional Design Layers (Norman)

- **Visceral**: beleza sensorial, primeira impressao — "parece bom?"
  - Conecta com trust visual em emocoes-sentimentos
- **Behavioral**: usabilidade, eficiencia — "funciona como espero?"
  - Conecta com [leis-de-krug](../concepts/leis-de-krug.md)
- **Reflective**: significado pessoal, auto-imagem — "o que usar isso diz sobre mim?"

---

> [!tip] Padrao pratico
> Para cada sessao do usuario:
> 1. Qual e o peak moment atual — e positivo ou negativo?
> 2. Como a sessao termina?
> 3. Design um peak positivo deliberado (surprise, achievement, delight)
> 4. Garanta que toda sessao termine bem
>
> A pior experiencia do flow dominara a memoria — elimine negative peaks.

---

## Conexoes Teoricas

- **Mitchell (1997)** em emocoes-sentimentos: antes e depois > durante. Anticipacao e recordacao sao mais intensas que a experiencia em si
- **Reservatorio de boa vontade** (reservatorio-boa-vontade): cada problema e um negative peak que drena a reserva. Cada WOW moment recarrega

---

## Links

- [frameworks-comportamentais](../concepts/frameworks-comportamentais.md) — frameworks comportamentais relacionados
- [padroes-implementacao](../concepts/padroes-implementacao.md) — padroes praticos de implementacao
- neuro-experience-skill — skill completa de Neuro-Experience Design
- emocoes-sentimentos — emocoes e design emocional
- reservatorio-boa-vontade — reservatorio de boa vontade do usuario
