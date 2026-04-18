---
type: concept
sources:
  - "context-engineering-anthropic"
created: 2026-04-16
updated: 2026-04-17
tags: [concept, agents, context, attention, memory]
phase: reference
author: matilha
license: MIT
---

# Context engineering

Disciplina de curar o conjunto mínimo de tokens de alto sinal que maximiza o outcome desejado de um LLM, dentro de um orçamento de atenção finito. Evolução do prompt engineering — não é mais sobre o prompt perfeito, é sobre a **configuração inteira de contexto** a cada turno.

> [!abstract] Princípio mestre
> Context é recurso finito com diminishing marginal returns. Cada token novo consome attention budget. **Smallest high-signal set** > maior volume de informação.

## Context rot — a realidade que impõe a disciplina

Fenômeno observado em benchmarks de retrieval (needle-in-a-haystack):

- Conforme tokens crescem, recall cai. Degradation gradient, não cliff.
- **Por quê**: transformer = n² pairwise relationships; training data tem mais sequências curtas; position encoding interpolation para contextos maiores degrada understanding de posição.
- **Resultado operacional**: context window grande ≠ usar o máximo. É orçamento.

## Anatomia do context efetivo

### System prompt — "right altitude"

Goldilocks zone entre dois failure modes:

- **Brittle**: if-else hardcoded, regras rígidas que quebram com edge cases.
- **Vague**: guidance de alto-nível sem sinais concretos.

**Optimal**: específico o bastante para guiar, flexível o bastante para heurísticas do modelo funcionarem.

**Estrutura**: seções via XML tags (`<background>`, `<instructions>`) ou Markdown headers. Formato menos crítico conforme modelos evoluem.

**Minimal ≠ curto**. Minimal = suficiente para guardrails + exemplos canônicos + expectativa de saída. Teste com mínimo + modelo melhor → adicione sob demanda baseado em failure modes reais.

### Tools — contrato agent↔ambiente

- Self-contained, robustos a erro, uso intencional claro.
- Parâmetros descritivos, não-ambíguos.
- **Regra**: se humano engineer não diz com certeza qual tool usar, agent não vai conseguir.
- **Anti-padrão**: tool sets inchados, sobreposição funcional, decision points ambíguos.
- **Minimal viable set** → maintenance + pruning de context mais fáceis.

### Examples — few-shot curado, não exhaustivo

- Não liste todas edge cases no prompt.
- Cure conjunto diverso, canônico, representativo.
- "For an LLM, examples are the 'pictures' worth a thousand words."

## Estratégias de retrieval

### Pre-inference (RAG clássico)

Embedding-based search upfront, chunks injetados.
- Viável para static content.
- Limitação: índice fica stale; syntax trees ficam complexos.

### Just-in-time (JIT, agentic search)

Agent mantém identifiers leves (file paths, stored queries, links). Carrega on-demand via tools.

- Claude Code: queries targeted + `head`/`tail` analisam sem carregar tudo.
- **Analogia humana**: file systems + inboxes + bookmarks em vez de memória de corpus inteiro.
- **Metadata como sinal**: folder hierarchy, naming conventions, timestamps.
- **Progressive disclosure**: understanding layer-by-layer; working memory focada.
- **Custo**: runtime exploration é mais lenta. Exige tools bem-desenhadas (senão agent perde tokens em becos).

### Hybrid (default recomendado)

Upfront + JIT combinados. Padrão canônico Claude Code:
- CLAUDE.md dropped upfront (static, always-relevant).
- `glob`/`grep` como tools para JIT (dynamic lookup).
- Bypass issues de stale indexing + syntax tree complexity.

**Guidance forte da Anthropic**: "do the simplest thing that works."

## Long-horizon tasks — 3 técnicas canônicas

Para tarefas que somam mais tokens que o context window (large migrations, research deep, multi-hour coding). **Context windows maiores não resolvem** — pollution e relevance persistem.

### 1. Compaction (first lever)

Conversation perto do limite → summarize → reinicia com summary.

- Preserva: architectural decisions, unresolved bugs, implementation details.
- Descarta: redundant tool outputs, messages verbosas.
- Tuning: **maximize recall primeiro** (tudo relevante capturado), depois precision.
- Light-touch: "tool result clearing" após uso deep (tool já usado, raw output não mais necessário).

### 2. Structured note-taking (agentic memory)

Agent escreve notas fora do context window; pull back quando necessário.

- Padrões: to-do list pelo próprio agent, NOTES.md, Claude Dev Platform memory tool.
- Persistência **entre context resets**.
- Caso canônico: Claude Plays Pokémon manteve tallies precisos em milhares de steps sem prompt especial — emergência natural do padrão.

### 3. Sub-agent architectures

Especialistas com clean context; main agent coordena.

- Sub-agent usa 10K+ tokens explorando; retorna 1-2K condensados.
- Separation of concerns: detailed search fica isolado.
- **Diferente de** [harness-engineering](../concepts/harness-engineering.md) Planner/Generator/Evaluator: lá os agents têm papéis fixos e sequenciais; aqui são spawn dinâmico para task isolada.

### Quando usar cada

| Task característica | Técnica |
|---|---|
| Conversational extensivo | Compaction |
| Iteração com milestones | Note-taking (NOTES.md) |
| Research complexo / paralelo | Multi-agent / sub-agents |

Combinar é OK — mas comece com a mais simples que funciona.

## Compaction vs Context reset (conexão com [harness-engineering](../concepts/harness-engineering.md))

Ambos endereçam context window cheio, mas diferentes:

| Aspecto | Compaction | Context reset |
|---|---|---|
| Mesmo agent continua? | Sim, em window nova | Não — novo agent, clean slate |
| Preserva continuidade conversacional? | Sim | Não |
| Resolve context anxiety? | Parcialmente | Sim (clean slate elimina) |
| Custo | Low | Higher (orquestração + handoff) |
| Quando usar | Default first lever; modelos com menos anxiety | Modelos com context anxiety forte (Sonnet 4.5); tasks onde continuidade não é crítica |

Opus 4.6 reduziu context anxiety → compaction automática frequentemente basta. Sonnet 4.5 ainda pede context reset.

## Antipadrões

- ❌ **Prompt gigantesco cobrindo toda edge case.** Context rot kick in. Curate examples + heurísticas.
- ❌ **"Context window é grande, manda tudo."** Performance degrada mesmo dentro do limite.
- ❌ **RAG puro para agents autônomos.** Stale indexing. JIT via tools é mais robusto.
- ❌ **Compaction agressiva sem tuning.** Perde contexto crítico cuja importância só aparece depois.
- ❌ **Tools redundantes ou com overlap.** Decision points ambíguos → agent escolhe mal.
- ❌ **System prompt vago + examples ausentes.** Modelo vai para "safe/generic" output.
- ❌ **System prompt cheio de if-else hardcoded.** Brittle, caro de manter, menos capacidade do modelo.

## Ligações com o cluster agentic

- [harness-engineering](../concepts/harness-engineering.md) — context reset é técnica de harness; compaction é complementar dentro ou entre resets.
- [agentic-patterns](../concepts/agentic-patterns.md) — ACI (tool design) daqui é a base para os padrões lá. Context engineering é prérequisito.
- [agent-centric-codebase](../concepts/agent-centric-codebase.md) — AGENTS.md como índice + `docs/` estruturado é a materialização de hybrid retrieval em repo.

## Ligações com a metodologia

- methodology/30-skills-agents — escolha de tools, ACI, system prompts no CLAUDE.md seguem princípios aqui.
- methodology/40-execucao — 3 técnicas long-horizon (compaction / note-taking / sub-agents) são opções táticas.
- methodology/50-qualidade-testes — evaluator agent consome context também; tune para alto sinal.

## Materializações por ferramenta

Ver methodology/materializacoes — ações "Long-horizon context management" e "Escolher padrão agentic".

## Links

- Source: context-engineering-anthropic
- Cluster agentic: [harness-engineering](../concepts/harness-engineering.md), [agentic-patterns](../concepts/agentic-patterns.md), [agent-centric-codebase](../concepts/agent-centric-codebase.md)
- Methodology consumers: methodology/30-skills-agents, methodology/40-execucao, methodology/50-qualidade-testes
