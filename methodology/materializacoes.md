---
type: methodology
phase: cross-tool
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: deep
maturity: v1
created: 2026-04-16
updated: 2026-04-17
tags: [methodology, tools, cross-tool, portability]
author: matilha
license: MIT
---

# Materializações — como executar ações da metodologia por ferramenta

> [!abstract] TL;DR
> A metodologia descreve **ações e gates determinísticos** em termos agnósticos de ferramenta. Esta página é o adaptador: para cada ação genérica, mostra como materializá-la em Claude Code (com e sem superpowers), Cursor, Gemini CLI, Codex e protocolo genérico.

## Princípio de agnosticismo

A Matilha descreve **ações e gates determinísticos** em termos agnósticos de ferramenta. Ferramentas dizem **como executar**. Se uma página de fase menciona ferramenta específica no bloco denso, é bug — migre para cá.

## Superpowers como engine preferida (cross-tool, não Claude-Code-only)

O plugin `superpowers` é compatível com múltiplas ferramentas (Claude Code, Cursor, Codex, Gemini CLI). Quando disponível, é a **materialização preferida** (motor mais maduro). Quando não disponível, cada ferramenta tem alternativa.

```
Tem superpowers instalado? (em qualquer ferramenta)
├── SIM → usar superpowers como engine
│   ├── brainstorming → superpowers:brainstorming (enriquecido pelos gates da Matilha)
│   ├── writing-plans → superpowers:writing-plans (enriquecido por critérios de decomposição)
│   └── executing-plans → superpowers:executing-plans + wave dispatch da Matilha
└── NÃO → alternativa agnóstica listada nas tabelas abaixo
```

**Relação Matilha ↔ Superpowers:** Matilha = GPS (destino + rota + waypoints + regras). Superpowers = motor (executa a rota). Matilha alimenta superpowers com gates, critérios, waves. Superpowers é enriquecido, não substituído.

## Tabela de adaptadores

### Ação: Brainstorm estruturado (fase 10-PRD e antes de decisões críticas)

**Gates de saída da ação:**
- [ ] Problema reescrito em 1 parágrafo sem jargão
- [ ] Persona validada com ≥1 fonte externa (entrevista, transcrição, forum, analytics)
- [ ] ≥3 abordagens comparadas com trade-offs
- [ ] 1 abordagem recomendada com justificativa
- [ ] RFs críticos enumerados preliminarmente

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + superpowers** | `Skill superpowers:brainstorming` — skill rígida que conduz o brainstorm até gates serem atendidos. |
| **Claude Code puro** | Prompt template: "Conduza um brainstorm estruturado para o problema X. Não encerre até ter: problema em 1 paragrafo, persona validada, 3+ abordagens, recomendação, RFs preliminares." |
| **Cursor** | Workspace rule que força brainstorm antes de código + chat livre com template de prompt acima. |
| **Gemini CLI** | `activate_skill` da skill equivalente (se instalada) ou prompt template. |
| **Codex** | Skill file local com mesmo conteúdo do prompt template. |
| **Genérico (qualquer LLM chat)** | Copiar manualmente o prompt template acima + iterar até gates atendidos. |

### Ação: Escrever spec/PRD (saída da fase 10)

**Gates de saída:**
- [ ] SSoT em markdown único, versionado em git
- [ ] RFs enumerados (RF-001…) com critério de aceitação binário cada
- [ ] RNFs cobrem: performance, segurança, disponibilidade, latência, escala, acessibilidade
- [ ] Persona, JTBD, AHA moment, riscos, premissas, métricas de sucesso declarados
- [ ] ≥1 revisor não-autor leu e fez só perguntas de "como" (não de "o quê")

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + superpowers** | `Skill superpowers:writing-plans` (se for plano) ou spec manual em `docs/superpowers/specs/YYYY-MM-DD-<topic>.md`. |
| **Claude Code puro** | Template markdown em `docs/PRD-<produto>.md` com as seções: Contexto, Personas, RFs, RNFs, Riscos, Métricas, Stack candidata. |
| **Cursor** | Composer com context de repo + template markdown acima. |
| **Gemini CLI** | Prompt de geração + revisão humana. |
| **Codex** | Skill de geração de PRD + template local. |
| **Genérico** | Template markdown + preenchimento manual (LLM como escrivão). |

### Ação: Executar plano com checkpoint (fase 40 e além)

**Gates de saída:**
- [ ] Arquivo `project-status.md` (ou equivalente) existe e é atualizado a cada tarefa concluída
- [ ] Toda task tem owner, status (pending/in_progress/completed), e dependência explícita
- [ ] Retomada após pausa de 24h não exige re-leitura do histórico (o status é auto-suficiente)
- [ ] Agentes paralelos nunca escrevem no mesmo arquivo sem lock

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + superpowers** | `Skill superpowers:executing-plans` + `TaskCreate`/`TaskUpdate` nativas. |
| **Claude Code puro** | `TaskCreate`/`TaskUpdate` nativas + `docs/plans/<plan>.md` com checkboxes. |
| **Cursor** | Composer com tarefas em markdown + memory do Cursor. |
| **Gemini CLI** | `TodoWrite` equivalente + arquivo de status manual. |
| **Codex** | Arquivo de status manual com template. |
| **Genérico** | `docs/status.md` com checkboxes atualizado pelo humano a cada turno. |

### Ação: Code review e qualidade

**Gates de saída:**
- [ ] Lint + typecheck + testes passaram
- [ ] Coverage ≥ threshold do projeto (80% global, 90% em core/domain)
- [ ] ≥1 review humano ou de agente especializado antes de merge
- [ ] Zero silent failure detectado

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + superpowers** | `Agent pr-review-toolkit:code-reviewer` + hooks de bloqueio (`hookify.stop-quality-check`). |
| **Claude Code puro** | Custom agent `.claude/agents/code-reviewer.md` + `/quality` slash command. |
| **Cursor** | Cursor rules + built-in review. |
| **Gemini CLI** | Agente de review customizado. |
| **Codex** | Skill de review. |
| **Genérico** | Checklist manual rodado pelo humano. |

### Ação: Criar skills/agents/hooks (fase 30)

**Gates de saída:**
- [ ] CLAUDE.md ou equivalente do projeto declara stack + regras + estrutura
- [ ] Skills criadas por domínio (RFs agrupados) e por tecnologia-chave
- [ ] Agents por disciplina com modelo declarado
- [ ] Pelo menos 1 hook bloqueante para violação arquitetural mais comum do projeto
- [ ] Slash commands para tarefas repetidas >3×

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + superpowers** | `.claude/skills/` + `.claude/agents/` + `.claude/commands/` + hookify rules + `.superpowers/` para worktrees. |
| **Claude Code puro** | Mesmo de cima sem `.superpowers/`. Hooks via `settings.json` ou hookify. |
| **Cursor** | `.cursorrules` + workspace rules + custom modes. |
| **Gemini CLI** | `GEMINI.md` + skills instaláveis via CLI. |
| **Codex** | `AGENTS.md` + skills locais em formato Codex. |
| **Genérico** | Arquivo de referência em `docs/` + disciplina manual. |

### Ação: Arquitetura de harness multi-agente (Planner / Generator / Evaluator)

Para tarefas autônomas longas ou com self-evaluation bias (design, UX, escrita criativa). Ver [harness-engineering](../concepts/harness-engineering.md) para o padrão completo.

**Gates de saída:**
- [ ] Planner produziu spec completo (não técnico granular)
- [ ] Generator e Evaluator são processos SEPARADOS (subagents, sessions ou scripts distintos)
- [ ] Sprint contract negociado ANTES de qualquer código
- [ ] Evaluator usa produto vivo (Playwright ou equivalente), não screenshot
- [ ] Criteria têm hard threshold por item (não só média)
- [ ] Comunicação entre agentes via arquivos (não mensagens efêmeras)
- [ ] Context reset habilitado para modelos com context anxiety (Sonnet 4.5); compactação automática aceita para Opus 4.6+

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + superpowers** | `Agent`s separados (`Planner`, `Generator`, `Evaluator`) + `Skill superpowers:writing-plans` para spec + arquivos de handoff em `docs/plans/` + Playwright MCP no evaluator. |
| **Claude Code puro** | `.claude/agents/planner.md`, `generator.md`, `evaluator.md` com prompts distintos + Playwright MCP no evaluator + arquivos de handoff. |
| **Claude Agent SDK** | Três agentes tipados com SDK, arquivos como canal, rodando em sessão(ões) longas. Padrão do artigo original. |
| **Cursor** | Composer com 3 modos (planner/generator/evaluator) ou 3 chats separados + workspace rules por papel. |
| **Gemini CLI** | Três skills/agents distintos invocados em sequência; arquivos como canal. |
| **Codex** | Três AGENTS.md em escopos (ou skill files) distintos; script de orquestração. |
| **Genérico** | Três chats/sessões separados com humano orquestrando handoff manual. Lento mas reproduz o padrão. |

### Ação: Dispatch + merge de wave paralela

Para ondas de SPs independentes rodando em sessões paralelas. Ver methodology/40-execucao seção "Wave-based parallel execution".

**Gates de saída do dispatch:**
- [ ] Worktrees criados (1 por SP, partindo de main)
- [ ] `kickoff.md` gerado em cada worktree (plano + contexto + quality gates)
- [ ] `wave-status.md` atualizado no repo principal
- [ ] Terminais abertos (auto ou manual)

**Gates de saída do merge:**
- [ ] `SP-DONE.md` em cada worktree confirmado
- [ ] Merge sequencial em main sem conflitos críticos
- [ ] Regression suite passa pós-merge
- [ ] Tag criada
- [ ] Worktrees removidos

| Ferramenta | Dispatch | Merge |
|---|---|---|
| **Claude Code** | `/dispatch-wave <id>` (slash command template em `docs/templates/dispatch-wave-command-template.md`). Cria worktrees + kickoff + abre terminais via osascript. | `/merge-wave <id>` (template em `docs/templates/merge-wave-command-template.md`). Verifica DONE, merge, tag, cleanup. |
| **Bash agnóstico** | `./scripts/dispatch-wave.sh <id> sp1 sp2 sp3` (ver `docs/templates/scripts/dispatch-wave.sh`). Funciona em qualquer tool. | `./scripts/merge-wave.sh <id> sp1 sp2 sp3` (ver `docs/templates/scripts/merge-wave.sh`). |
| **Cursor** | Script bash. Cursor não tem slash commands nativos que criam worktrees. |  Script bash. |
| **Gemini CLI** | Script bash. | Script bash. |
| **Codex** | Script bash (Codex usa worktrees nativamente via exec-plans). | Script bash. |
| **Genérico** | Criação manual de worktrees + copy-paste de prompts. Status tracking via `wave-status.md` manual. | Merge manual via git CLI. |

### Ação: Design eval suite + graders (capability + regression)

Para qualquer componente com agent, montar eval suite com graders apropriados. Ver [agent-evaluation](../concepts/agent-evaluation.md) para framework completo.

**Gates de saída:**
- [ ] 20-50 tasks iniciais existem, drawn from manual testing + bug tracker
- [ ] Cada task passa teste-de-dois-SMEs (dois experts independentes chegam ao mesmo verdict)
- [ ] Balanced: cobre "deve ocorrer" E "não deve ocorrer"
- [ ] Reference solution existe para cada task (prova que é solvable + graders corretos)
- [ ] Graders escolhidos por tipo: code-based (outcome deterministic), model-based (subjetivo), human (gold standard/calibração)
- [ ] Capability eval (pass rate baixo) vs regression eval (~100%) distinguidas
- [ ] Métrica escolhida: pass@k (um sucesso basta) ou pass^k (consistência)
- [ ] Env isolado por trial (clean state, sem shared state contaminando)
- [ ] Transcripts são lidos regularmente (skill mandatória)

| Ferramenta / Framework | Como materializar |
|---|---|
| **Claude Code + Claude Agent SDK** | Agent SDK para orquestrar evals; `TaskCreate`/`TaskUpdate` como harness leve; custom eval scripts em `tests/evals/`. |
| **Harbor** | Containerized, bom para benchmarks em escala. Registry inclui Terminal-Bench 2.0. |
| **Braintrust** | Offline + prod observability + experiment tracking; `autoevals` com scorers pré-built. |
| **LangSmith** | Tracing + offline/online eval + dataset mgmt. Integra LangChain. |
| **Langfuse** | Self-hosted open-source, similar ao LangSmith. |
| **Arize (Phoenix + AX)** | Open-source tracing + offline/online eval. |
| **Genérico / DIY** | Simple scripts que rodam tasks + aplicam graders + agregam scores. Muitas vezes é o suficiente para começar. |

### Ação: Long-horizon context management (compaction / note-taking / sub-agents)

Para tasks que somam mais tokens que o context window. Ver [context-engineering](../concepts/context-engineering.md) para fundação.

**Gates de saída:**
- [ ] Escolha feita: qual das 3 técnicas (compaction / note-taking / sub-agents) se aplica à task
- [ ] Se compaction: prompt tunado para maximize recall primeiro, precision depois; tool result clearing habilitado quando possível
- [ ] Se note-taking: `NOTES.md` (ou equivalente) criado, convenção de update declarada
- [ ] Se sub-agents: cada sub-agent tem papel claro e retorna output condensado (não raw exploration)

| Ferramenta | Como materializar |
|---|---|
| **Claude Code** | `/compact` para compaction manual; auto-compaction em Agent SDK; `NOTES.md` no repo; `Agent` tool para sub-agents. |
| **Claude Agent SDK** | Auto-compaction configurável; memory tool do Claude Developer Platform. |
| **Cursor** | Composer com history management manual; custom memory via `.cursor/` files. |
| **Gemini CLI** | Scripts de summarization + arquivo de notes + skill de sub-agent dispatch. |
| **Codex** | Mesma lógica via skill files + exec-plans/ como note-taking estruturado. |
| **Genérico** | Compaction manual pelo humano; NOTES.md editado; chats separados para sub-tasks. |

### Ação: Bootstrap de repo agent-centric (AGENTS.md como índice + docs/ como system of record)

Aplicar o padrão de [agent-centric-codebase](../concepts/agent-centric-codebase.md): CLAUDE.md/AGENTS.md pequeno (~100 linhas) apontando para `docs/` estruturado; progressive disclosure; linters + janitor agent.

**Gates de saída:**
- [ ] CLAUDE.md/AGENTS.md tem ≤150 linhas e é puro índice (sem regras detalhadas embutidas)
- [ ] `docs/` existe com subpastas: `design-docs/`, `exec-plans/`, `product-specs/`, `references/`, `generated/`
- [ ] ≥1 linter custom validando frescor ou interlinkagem de `docs/`
- [ ] Janitor agent ou script recorrente para detectar doc-rot (pode ser manual inicialmente)

| Ferramenta | Como materializar |
|---|---|
| **Claude Code** | `CLAUDE.md` como índice + `docs/` + hooks custom para `doc-rot-check` em `PreToolUse` (Write/Edit em docs). |
| **Claude Agent SDK** | Mesma estrutura de arquivo + agent de janitor rodando em CI ou cron. |
| **Cursor** | `.cursorrules` como índice + `docs/` + workspace rules para forçar consulta. |
| **Gemini CLI** | `GEMINI.md` como índice + `docs/`. |
| **Codex** | `AGENTS.md` como índice (padrão original do artigo OpenAI) + `docs/`. |
| **Genérico** | `README.md` como índice + `docs/` + disciplina manual de update. |

### Ação: Ralph Wiggum loop (auto-review iterativo)

Agente itera até todos revisores (agents + humanos) satisfeitos. Ver [agent-centric-codebase](../concepts/agent-centric-codebase.md) seção Ralph Wiggum.

**Gates de saída:**
- [ ] Implementação + auto-review local + review por agents especialistas + resposta a feedback rodam em loop fechado
- [ ] Hook/script mantém o loop em movimento sem intervenção humana a cada iteração
- [ ] Loop tem stopping condition (max iterations ou aprovação formal)

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + superpowers** | Agent dispatch paralelo (`code-reviewer`, `silent-failure-hunter`, `type-design-analyzer`) + hook `stop-quality-check` forçando re-run. |
| **Claude Code puro** | `.claude/agents/` com review agents + `Stop` hook disparando review cycle. |
| **Claude Agent SDK** | SDK orchestration com stopping condition. |
| **Cursor** | Composer multi-modo com loop manual inicialmente. |
| **Gemini CLI** | Scripts encadeando `activate_skill` de reviewers. |
| **Codex** | Padrão nativo do artigo original (Ralph Wiggum). |
| **Genérico** | Loop humano rodando prompts de review. |

### Ação: Escolher padrão agentic (prompt chain vs routing vs agent autônomo)

Antes de implementar, escolha o padrão. Ver [agentic-patterns](../concepts/agentic-patterns.md) árvore de decisão.

**Gates de saída:**
- [ ] Task classificada: workflow OU agent?
- [ ] Se workflow, qual sub-padrão: chain, routing, parallelization, orchestrator-workers, evaluator-optimizer?
- [ ] Se agent, sandbox + guardrails + stopping condition definidos
- [ ] Escolha justificada contra "single LLM + retrieval" (o padrão mais simples)

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + superpowers** | `superpowers:brainstorming` com critérios do padrão + agent ou skill materializando a escolha. |
| **Claude Agent SDK** | Tipagem de padrões (ChainedLLM, RouterLLM, AgentLoop) no SDK. |
| **LLM API direta** | Implementação em poucas linhas — Anthropic recomenda este path para produção. |
| **Cursor** | Workspace rules guiando o padrão escolhido. |
| **Gemini CLI** | Skill orquestrando o padrão. |
| **Codex** | Skill file materializando o padrão. |
| **Genérico** | Humano orquestrando. |

### Ação: Consultar a metodologia (esta própria)

| Ferramenta | Como materializar |
|---|---|
| **Claude Code + MCP Obsidian** | Slash command `/metodologia <fase>` (ver docs/templates/metodologia-command-template) |
| **Claude Code sem MCP** | `Read` direto em `/Users/danilodesousa/Documents/Memory/Memory/wiki/methodology/<fase>.md`. |
| **Cursor com Obsidian plugin** | Cursor rule para leitura do path absoluto. |
| **Gemini CLI** | Tool `read_file` no path absoluto. |
| **Codex** | Tool de leitura de arquivo. |
| **Genérico** | Abrir no Obsidian e copiar manualmente. |

## Regra de manutenção

Quando uma ferramenta nova aparecer:
1. Adicionar uma coluna (ou linha, dependendo do layout) em cada tabela.
2. Não tocar em nenhuma página de fase.

Quando uma ferramenta existente ganhar capability nova:
1. Atualizar apenas a célula correspondente.
2. Se a capability muda fundamentalmente o padrão (ex: Cursor ganha skills nativas tipo Claude Code), considere criar uma nova ação genérica — mas isso é raro.

## Fallback genérico

Para qualquer ferramenta/LLM que não esteja tabelada:
1. Leia a página da fase (ex: `wiki/methodology/10-prd.md`).
2. Extraia o bloco denso (checklist + regras + decisões de juízo).
3. Para cada ação com gate, execute manualmente até os critérios estarem marcados.
4. O bloco denso é autocontido — funciona em qualquer LLM com janela de contexto minimamente grande.

## Anti-padrões

- ❌ Página de fase mencionando ferramenta específica no bloco denso. Migrar para cá.
- ❌ Esta página virando tutorial da ferramenta. Aqui só o **adapter** — tutorial vive na doc da ferramenta.
- ❌ Duplicar informação da página de fase aqui. Mantenha esta página como pura mapping table.

## Links

- [index](./index.md) — hub da metodologia
- [principios-transversais](./principios-transversais.md) — princípios aplicados em qualquer ferramenta
- [10-prd](./10-prd.md), [20-stack](./20-stack.md), [30-skills-agents](./30-skills-agents.md) — fases com ações que esta página mapeia
- docs/templates/metodologia-command-template — materialização concreta da ação "Consultar a metodologia" para Claude Code + MCP Obsidian
- Raw: 2026-04-15-danilo-brain-dump
