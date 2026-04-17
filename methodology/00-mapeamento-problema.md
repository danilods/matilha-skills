---
type: methodology
phase: "00"
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: skeleton
maturity: v1
created: 2026-04-16
updated: 2026-04-17
tags: [methodology, discovery, problem-mapping]
author: matilha
license: MIT
---

# 00 — Mapeamento do problema

> [!abstract] TL;DR
> Antes de qualquer código ou PRD, identifique claramente a dor que software pode resolver. Produto próprio → deep research web. Produto institucional → coleta de documentação interna.
>
> **Status: `skeleton`** — bloco denso capturado do brain-dump; falta calibração contra projeto-âncora (candidato: PCD-AI ou Passa Plantão, ambos têm discovery bem documentado).

## Quando esta fase se aplica

- Antes de qualquer PRD. Sempre.
- Também quando você "já sabe o problema" — a disciplina é escrever o que você acha que sabe e confrontar com evidência.

## Gates de entrada (binários)

- [ ] Existe um estímulo inicial (dor relatada, oportunidade identificada, brief de stakeholder, insight pessoal)
- [ ] Você declarou o tipo do produto: **próprio** (você escolhe o problema) ou **institucional** (problema vem do cliente/empresa)

## Gates de saída (binários)

- [ ] Problema reescrito em 1 parágrafo sem jargão (alguém de fora entende?)
- [ ] ≥3 fontes externas de evidência consultadas (entrevistas, fóruns, analytics, concorrentes, documentação)
- [ ] Persona(s) rascunhada(s) — perfil + dor principal (detalhe vem na fase 10)
- [ ] Alternativas não-software consideradas e descartadas com justificativa
- [ ] Decisão go / no-go / pivot registrada (se no-go ou pivot, o ciclo termina ou reinicia — não avance)
- [ ] Hipóteses explícitas listadas (o que você assume sem evidência firme)

**Como executar a investigação em cada ferramenta:** ver [materializacoes](./materializacoes.md) (ação "Brainstorm estruturado" aplicada a discovery).

## ═══ BLOCO DENSO ═══

### Checklist operacional

- [ ] Estímulo inicial escrito em 1 frase curta
- [ ] Tipo do produto declarado (próprio / institucional)
- [ ] Deep research executado (se produto próprio) — timebox 4h
- [ ] Documentação coletada (se produto institucional) — ou entrevista com stakeholder gravada + transcrita
- [ ] Concorrentes / alternativas indiretas mapeados (planilha, manual, nada)
- [ ] Quem sente a dor e com que frequência?
- [ ] Quanto essa dor custa hoje (tempo, dinheiro, risco)?
- [ ] O que fazem quando a dor aparece? (workaround atual)
- [ ] Por que esse workaround é insuficiente?
- [ ] Problema passou no "teste do estranho" (alguém sem contexto entende a partir do 1 parágrafo)?

### Regras invioláveis

1. **Evidência externa obrigatória.** Se o único input é sua intuição, o problema é hipótese — não avance para PRD antes de confirmar.
2. **Produto próprio exige deep research formal.** Não é opcional. Concorrentes, fóruns, tendências, posicionamento. Timebox 4h para evitar procrastinação disfarçada.
3. **Produto institucional exige documentação.** Se não existir, você produz a partir de entrevista + transcrição + LLM expand. Não comece sem base documental.
4. **Distinguir dor real de incômodo.** Dor real: gente paga, workaround é doloroso, frequência alta. Incômodo: "seria legal ter". Incômodo ≠ problema.
5. **Pivot cedo é barato.** Descobrir no mapeamento que o problema é outro custa 4h. Descobrir depois do PRD custa semanas. Saia do sunk-cost.

### Árvore de decisão

```
Tipo do produto?
├── Próprio
│   ├── Dor confirmada em fóruns / comunidades / concorrência? → Sim → Avance para 1-paragraph
│   │                                                          → Não → Entrevistar 3-5 pessoas do target antes
│   ├── Existe concorrente direto com solução? → Sim → Diferenciação é explícita no problema?
│   │                                          → Não → Por que ninguém atacou antes? (risco ou oportunidade real?)
│   └── Você tem expertise no domínio? → Sim → Bias check: evite resolver seu problema e achar que é do mercado
│                                      → Não → Entrevista obrigatória com ≥3 especialistas
│
└── Institucional
    ├── Setor tem documentação? → Sim → Ingest + consolidação + LLM expand
    │                           → Não → Entrevista gravada com stakeholder → transcrição → consolidação
    ├── Sistemas legados no domínio? → Sim → Mapear interfaces (vão virar RNFs críticos)
    │                                → Não → Campo aberto — foco em JTBD puro
    └── Stakeholder tem solução pré-escolhida? → Sim → ALERTA. Volte ao problema. Sua função é mapear dor, não implementar preferência.
```

### Defaults e anti-padrões

**Defaults:**
- Timebox deep research: 4h (produto próprio) ou até entrevistas não trazerem insight novo (institucional).
- Registro em markdown em `docs/discovery/` do projeto (ou similar).
- Deep research usando Gemini Deep Research + Claude web search em paralelo — triangular fontes.

**Anti-padrões:**
- ❌ "Já sei a dor" sem evidência → é hipótese, não é fato.
- ❌ Discovery infinito → timebox, aceite o que tiver.
- ❌ Persona retrospectiva (sua intuição virando evidência) → não conta.
- ❌ Solução pronta antes do problema mapeado → produto em busca de dor.

### Decisões de juízo (não-templatizáveis)

- **Quando o deep research é "suficiente".** Sinal: você consegue resumir o mercado, concorrentes, posicionamento em 1 página sem esforço. Se ainda precisa inventar, falta evidência.
- **Quando pivotar vs. persistir.** Se a evidência contradiz a hipótese central, pivote. Se contradiz periférica, ajuste escopo. A diferença requer julgamento.
- **Quando entrevistar vs. confiar em dados.** Dados mostram comportamento, não motivação. Se a pergunta é "POR QUE eles não usam X?", entrevista. Se é "quantos usam X?", dados.

## ═══ NARRATIVA ═══

### Racional

Mapeamento é a fase mais barata e a mais pulada. O custo de pular é invisível até a fase 10 (PRD sobre problema falso), fase 20 (stack para problema falso), ou pior: launch (solução sem dor).

Ver [jtbd-positioning](../concepts/jtbd-positioning.md) — Forces of Progress (Push/Pull/Anxiety/Habit) dão vocabulário preciso para articular dores. Use isso aqui, não no PRD (o PRD herda).

### Exemplo real — placeholder (skeleton)

> [!todo] Calibração pendente
> Candidato a âncora: **PCD-AI** (2 PRDs grandes + STRATEGY.md sugerem discovery estruturado). Alternativa: **Passa Plantão** (validado com intensivista 19y — discovery radical). A upgrade para `status: deep` virá em sessão futura.

### Armadilhas comuns

- **Confirmation bias.** Você ouve o que já acreditava. Antídoto: busque evidência que contradiga sua hipótese.
- **Deep research feito pelo LLM sem curadoria.** LLM gera plausível, não necessariamente verdadeiro. Fontes precisam ser conferidas.
- **"Stakeholder sabe o que quer."** Em projeto institucional, o stakeholder geralmente sabe *a solução que imaginou* — não *o problema que tem*. Seu trabalho é voltar ao problema.

## Links

- Fase seguinte: [10-prd](./10-prd.md)
- Princípios: [principios-transversais](./principios-transversais.md)
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- Conceitos embasadores: [jtbd-positioning](../concepts/jtbd-positioning.md), [leis-de-krug](../concepts/leis-de-krug.md)
- Raw: 2026-04-15-danilo-brain-dump
