---
type: concept
sources:
  - "[demystifying-evals-anthropic](../concepts/demystifying-evals-anthropic.md)"
created: 2026-04-16
updated: 2026-04-17
tags: [concept, agents, evaluation, quality, graders, testing]
phase: reference
author: matilha
license: MIT
---

# Agent Evaluation

Disciplina de medir performance de agentes AI com rigor suficiente para distinguir regressões reais de ruído, acelerar iteração, e validar comportamento antes de impactar usuários. Fecha o loop entre **desenvolvimento** (harness + context engineering + patterns) e **confiança** (o que está entregando valor?).

> [!abstract] Princípio mestre
> Eval é test para AI system: input → grading logic → score de sucesso. Para agents (multi-turn, tool-using, state-modifying), eval é o sistema nervoso que permite iterar sem voar às cegas.

## Terminologia formal

- **Task**: teste único com inputs e critérios de sucesso.
- **Trial**: cada tentativa de uma task (múltiplas por variação do modelo).
- **Grader**: lógica que avalia algum aspecto da performance. Task tem múltiplos graders; grader tem múltiplas checks.
- **Transcript**: registro completo da trial (outputs, tool calls, reasoning, intermediários).
- **Outcome**: estado final do ambiente — NÃO o que o agent disse. "Booked" no transcript ≠ reservation no DB.
- **Evaluation harness**: infra que roda evals end-to-end.
- **Agent harness**: sistema que permite modelo agir como agent — avaliar "um agent" = avaliar harness + model juntos.
- **Suite**: coleção de tasks.

## 3 tipos de graders

| Tipo | Quando usar | Custo | Nuance |
|---|---|---|---|
| **Code-based** (string match, binary tests, static analysis, state check, tool calls) | Outcomes verificáveis | Baixo | Baixa |
| **Model-based** (rubric, natural language assertions, pairwise, multi-judge) | Subjetivo, freeform, open-ended | Médio | Alta |
| **Human** (SME review, crowdsourced, spot-check, A/B, inter-annotator) | Gold standard, calibração | Alto | Máxima |

**Prioridade**: code-based onde possível; model-based onde necessário; human judiciously (validação, calibração do model-based).

## Capability vs Regression — a dualidade

| Pergunta | Pass rate esperado | Propósito |
|---|---|---|
| **Capability / quality eval**: "o que pode fazer bem?" | Baixo (target pontos fracos) | Dá hill to climb |
| **Regression eval**: "ainda faz tudo que fazia?" | ~100% | Detecta drift |

**Graduation path**: capability eval que satura (~100%) "gradua" para virar regression suite. Tasks que mediam "dá pra fazer?" agora medem "ainda faz confiavelmente?".

## pass@k vs pass^k — consistência matters

- **pass@k**: ≥1 sucesso em k tentativas. **Cresce com k**. Use quando um sucesso basta (ex: code search).
- **pass^k**: TODOS os k sucessos. **Cai com k**. Use para customer-facing, consistência é esperada (75% per-trial → (0.75)³ ≈ 42% em 3 trials).

Em k=1, idênticas. Em k=10, opostas. Escolha por requisito do produto.

## Scoring strategies

Dentro de uma task com múltiplos graders:
- **Weighted**: soma pondera cada grader, threshold mínimo.
- **Binary**: todos os graders precisam passar.
- **Hybrid**: alguns críticos binários + outros ponderados.

**Partial credit** é importante para multi-component tasks — falhar no último step é melhor que falhar no primeiro.

## Evals por tipo de agent

### Coding
- Deterministic graders naturais (código roda? testes passam?).
- Plus: transcript analysis (code quality heuristics + LLM rubric para style).
- Benchmarks: SWE-bench Verified, Terminal-Bench.

### Conversacional
- State check (resolveu?) + transcript constraint (max turns) + LLM rubric (tone, empatia, clareza).
- Frequentemente **2º LLM simulando user** (τ-Bench, τ²-Bench).
- Multidimensional — muitas "soluções corretas" possíveis.

### Research
- Groundedness (sources suportam claims) + coverage (fatos-chave) + source quality.
- LLM rubrics calibradas vs expert humano.
- Benchmark: BrowseComp.

### Computer use
- Sandbox/real env + outcome check (backend state, DB, filesystem).
- Trade-off DOM vs screenshot (token-efficiency).
- Benchmarks: WebArena, OSWorld.

## Roadmap 0→1 (9 steps, em cascata)

| Step | Ação | Insight chave |
|---|---|---|
| 0 | Start early | 20-50 tasks de failures reais basta |
| 1 | Start com manual testing + bug tracker | Converte reality em test cases |
| 2 | Tasks sem ambiguidade + reference solutions | Dois SMEs → mesmo verdict. 0% pass@100 = task quebrada |
| 3 | Balanced problem sets | "Deve" × "não deve"; evita one-sided optimization |
| 4 | Harness robusto + clean env | Isolate trials — shared state correlaciona falhas |
| 5 | Graders thoughtfully | Grade output, não path; partial credit; LLM com "Unknown"; rubric por dimensão |
| 6 | **Read the transcripts** | Você não sabe se graders funcionam sem ler |
| 7 | Monitor saturation | 100% = regressão only. Graduate ou evolua |
| 8 | Maintenance + contribuição aberta | Suite viva; eval-driven development |

## Eval-driven development

Construa evals **ANTES** do agent ser capaz. Capability eval partindo de 10% pass rate torna a aposta explícita.

Quando modelo novo sai, rode o suite: quais apostas renderam? Qualitative → quantitative.

## Swiss Cheese Model — 6 camadas complementares

Nenhuma sozinha pega tudo:

1. **Automated evals** — pre-launch + CI/CD. Primeira defesa.
2. **Production monitoring** — post-launch. Distribution drift.
3. **A/B testing** — valida mudanças com traffic.
4. **User feedback** — gaps não-antecipados.
5. **Manual transcript review** — subtle quality, builds intuition.
6. **Systematic human studies** — calibra LLM graders, domínios subjetivos.

**Teams eficazes combinam**.

## Princípios transferíveis

1. **Read the transcripts** — crítico, não opcional.
2. **0% pass@100 = task quebrada**, não agent incapaz. Double-check specs e graders.
3. **Grade output, não path** — agents encontram soluções válidas não-antecipadas.
4. **Partial credit** para multi-component.
5. **LLM como juiz precisa calibração** — SME agreement + rubrics estruturadas por dimensão + "Unknown" como saída.
6. **Capability e regression são duais** — não substituem um ao outro; coexistem.
7. **Env isolado por trial** — shared state contamina.
8. **Eval suite é artefato vivo** — maintenance, ownership clara, contribuição aberta.

## Antipadrões

- ❌ **Esperar "quando tiver tempo"** para escrever evals. Reverse-engineering success criteria de sistema vivo é muito pior.
- ❌ **Graders checando sequência exata de tool calls**. Punem criatividade válida. Grade output.
- ❌ **One-sided problem set** — só cases positivos. Leva a overtriggering.
- ❌ **Eval com shared state entre trials**. Falhas correlacionam por razões não-agent.
- ❌ **Graders ambíguos**. Dois SMEs chegam a verdicts diferentes = ruído em métrica.
- ❌ **Não ler transcripts.** Grader bugs passam invisíveis; valid solutions são penalizadas.
- ❌ **Trust the eval score at face value.** Sempre digest transcripts de sucesso E falha.

## Frameworks

- **Harbor** — containerized, benchmarks em escala.
- **Braintrust** — offline + prod observability + experiment tracking.
- **LangSmith** — integra LangChain.
- **Langfuse** — self-hosted.
- **Arize (Phoenix + AX)** — open-source tracing + eval.

Pegue um que se encaixa, invista energia nas evals em si.

## Ligações com o cluster agentic

- [harness-engineering](../concepts/harness-engineering.md) — evaluator role aqui é formalizada com vocabulário de graders + criteria com hard threshold.
- [agentic-patterns](../concepts/agentic-patterns.md) — "test tools iteratively no workbench" de ACI vira eval harness. Evaluator-optimizer pattern é a versão single-LLM-em-loop deste concept.
- [agent-centric-codebase](../concepts/agent-centric-codebase.md) — janitor agent + linters custom + quality ratings são o equivalente "repo-level" das regression evals.
- [context-engineering](../concepts/context-engineering.md) — eval graders consomem context também; tune para high signal.

## Ligações com a metodologia

- methodology/50-qualidade-testes — consumer primário. Eval framework aqui estende TDD para agent-level measurement.
- methodology/30-skills-agents — escolha de graders casa com escolha de agent pattern.
- methodology/40-execucao — regression suite roda em CI (paralelo com execução).

## Materializações por ferramenta

Ver methodology/materializacoes — ação "Design eval suite + graders".

## Links

- Source: [demystifying-evals-anthropic](../concepts/demystifying-evals-anthropic.md)
- Cluster agentic: [harness-engineering](../concepts/harness-engineering.md), [agentic-patterns](../concepts/agentic-patterns.md), [agent-centric-codebase](../concepts/agent-centric-codebase.md), [context-engineering](../concepts/context-engineering.md)
- Methodology consumers: methodology/50-qualidade-testes, methodology/30-skills-agents, methodology/40-execucao
