---
type: methodology
phase: index
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: deep
maturity: v1
created: 2026-04-15
updated: 2026-04-17
tags: [methodology, index]
author: matilha
license: MIT
---

# Matilha — Hub das fases

> *"Humanos lideram. Agentes caçam."*

Metodologia de desenvolvimento de produtos de software com assistência de IA (Claude Code + plugin `superpowers`, e agora agnóstica a ferramenta — ver [materializacoes](./materializacoes.md)), capturada a partir de 8 produtos reais entregues por Danilo Sousa (autor). O brain-dump original está em 2026-04-15-danilo-brain-dump.

> [!info] Como usar
> Agentes e teammates consultam esta página primeiro para identificar a fase do ciclo em que estão e seguir para a página de deep-dive. Páginas com `status: deep` são acionáveis; `skeleton` são direcionais; `stub` são placeholders.

## Ciclo de vida do projeto (8 fases)

| # | Fase | Status | Propósito |
|---|---|---|---|
| 00 | [Mapeamento do problema](./00-mapeamento-problema.md) | `skeleton` | Identificar dor real antes de qualquer código |
| **10** | **[PRD](./10-prd.md)** | **`deep`** | Transformar problema em requisitos densos |
| **20** | **[Stack](./20-stack.md)** | **`deep`** | Decidir tecnologias, validar contra arquétipo |
| **30** | **[Skills / Agents / Hooks](./30-skills-agents.md)** | **`deep`** | Materializar PRD em ambiente acionável |
| 40 | [Execução](./40-execucao.md) | `skeleton` | Orquestração com checkpoint; prevenir estouro de contexto |
| 50 | [Qualidade e testes](./50-qualidade-testes.md) | `skeleton` | Unit, integration, regression, E2E; cobertura e gates |
| 60 | [Deploy e infra](./60-deploy-infra.md) | `skeleton` | Docker-compose + CI/CD; esteira DO/Vercel/Cloudflare ou EKS |
| 70 | [Onboarding do time](./70-onboarding-time.md) | `skeleton` | Replicação da metodologia para teammates |

## Princípios transversais

Aplicam-se a todas as fases. Ver [principios-transversais](./principios-transversais.md).

KISS · DRY · SOLID · Clean Architecture · Coesão × Acoplamento · TDD · Checkpoint Discipline · Type Safety Strict · Error Handling Explícito.

## Cross-cutting: Agentic engineering cluster

Três concepts embasam toda arquitetura agentic da metodologia:

- **[harness-engineering](../concepts/harness-engineering.md)** — orquestração para compensar gaps do modelo (Planner/Generator/Evaluator + sprint contract + context reset vs compactação).
- **[agentic-patterns](../concepts/agentic-patterns.md)** — taxonomia de 5 padrões (augmented LLM → chain → routing → parallelization → orchestrator → evaluator-optimizer → agent autônomo) + princípios ACI (Agent-Computer Interface).
- **[agent-centric-codebase](../concepts/agent-centric-codebase.md)** — repo otimizado para agentes (AGENTS.md como índice, `docs/` como system of record, linters custom com mensagens-instrução, Ralph Wiggum loop, janitor agent contra doc-rot).
- **[context-engineering](../concepts/context-engineering.md)** — curagem do orçamento de atenção (context rot, system prompt altitude, JIT retrieval, 3 técnicas long-horizon: compaction / note-taking / sub-agents).
- **[agent-evaluation](../concepts/agent-evaluation.md)** — medir performance com rigor: graders (code / model / human), capability × regression, pass@k × pass^k, 9-step roadmap, Swiss Cheese Model de 6 camadas complementares.

Fases afetadas: [20-stack](./20-stack.md) (tech chata ganha), [30-skills-agents](./30-skills-agents.md) (padrão + AGENTS.md + ACI), [40-execucao](./40-execucao.md) (Ralph Wiggum + worktree-per-change), [50-qualidade-testes](./50-qualidade-testes.md) (linters como instrução + janitor + evaluator separado).

**Teses convergentes das 3 fontes:**
1. **Humans drive, agents execute** — papel humano = ambiente + intenção + feedback loops. Não código.
2. **Simplicidade primeiro** — start com single LLM + retrieval. Agent autônomo é último recurso, não primeiro.
3. **Legibilidade pelo agente é objetivo** — tudo que o agente não vê não existe. Tooling, docs, observability devem ser agent-readable.

## Agnosticismo de ferramenta

A metodologia descreve **ações e gates determinísticos** em termos agnósticos. Cada fase define: (a) gates de entrada, (b) gates de saída, (c) ações obrigatórias com critérios binários. **Ferramentas** (Claude Code + superpowers, Cursor, Gemini CLI, Codex, etc.) são *materializações* das ações — não são a metodologia.

Para saber como executar uma ação na ferramenta que você está usando agora: [materializacoes](./materializacoes.md).

Se uma página de fase menciona ferramenta específica no bloco denso, é bug. A referência correta é sempre em `materializacoes`.

## Regras de leitura

- **Bloco denso** (checklist + regras + árvore de decisão + defaults + decisões de juízo) é a fonte da verdade. Agente otimiza leitura por aqui.
- **Narrativa** ilustra o racional e traz exemplo real de projeto. Regra que só aparece na narrativa é bug.
- **Decisões de juízo** marca onde o framework **para de prescrever** — pontos que exigem pensamento caso a caso, não checklist.

## Âncoras v1 (projetos reais que calibraram cada fase)

Projetos em `/Users/danilodesousa/Documents/Projetos/` — fora do vault, referenciados por caminho literal:

- Fase 10 → **adedonha** (2 PRDs densos em `adedonha-prd-artifact.md` e `PRD Jogo Adedonha_Stop Inovador.md`; MVP completo com CLAUDE.md limpo)
- Fase 20 → **fluency** (stack complexa: 7 serviços, 26 skills, EKS + Bedrock + ElevenLabs; CLAUDE.md de 11KB como referência de tabela de stack)
- Fase 30 → **fluency** (único projeto com `.superpowers/` integrado, 26 skills + 6 agents + 4 commands + 4 hookify rules)

## Roadmap do subsistema "segundo cérebro" (5 partes)

Esta página é parte do **subsistema 1** apenas. Partes seguintes (plugin, bridge de runtime, portabilidade cross-tool, onboarding) vêm como specs separados.

1. **Captura da metodologia** ← você está aqui (v1)
2. Biblioteca de skills/agents/hooks reutilizáveis (plugin)
3. Runtime consumption bridge (skill consulta-metodologia em projetos novos)
4. Portabilidade cross-tool (Gemini CLI, Cursor, Codex)
5. Onboarding/treino do time

## Compounding

Cada brain-dump novo seu ou artefato de projeto novo que você trouxer para `raw/methodology/` aciona uma operação **ingest de metodologia** (ver schema Karpathy em `/Users/danilodesousa/Documents/Memory/CLAUDE.md`, FORA do vault). Páginas são atualizadas em cascata e `maturity` sobe. A metodologia evolui junto com os projetos.

## Links

- [principios-transversais](./principios-transversais.md) — regras que atravessam todas as fases
- [00-mapeamento-problema](./00-mapeamento-problema.md) — Fase Mapeamento (skeleton, v1)
- [10-prd](./10-prd.md) — Fase PRD (deep, v1)
- [20-stack](./20-stack.md) — Fase Stack (deep, v1)
- [30-skills-agents](./30-skills-agents.md) — Fase Skills/Agents/Hooks (deep, v1)
- [40-execucao](./40-execucao.md) — Fase Execução (skeleton, v1)
- [50-qualidade-testes](./50-qualidade-testes.md) — Fase Qualidade e testes (skeleton, v1)
- [60-deploy-infra](./60-deploy-infra.md) — Fase Deploy e infra (skeleton, v1)
- [70-onboarding-time](./70-onboarding-time.md) — Fase Onboarding do time (skeleton, v1)
- **[materializacoes](./materializacoes.md)** — adapter de ações da metodologia para cada ferramenta (Claude Code ± superpowers, Cursor, Gemini CLI, Codex, genérico)
- log — histórico de ingests e updates
- Relacionado: [leis-de-krug](../concepts/leis-de-krug.md), [jtbd-positioning](../concepts/jtbd-positioning.md), [nfr-system-design](../concepts/nfr-system-design.md), [frameworks-comportamentais](../concepts/frameworks-comportamentais.md)
