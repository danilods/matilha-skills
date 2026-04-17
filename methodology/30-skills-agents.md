---
type: methodology
phase: "30"
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: deep
maturity: v1
created: 2026-04-15
updated: 2026-04-17
tags: [methodology, skills, agents, hooks, commands, claude-code]
author: matilha
license: MIT
---

# 30 — Skills, Agents, Hooks e Commands

> [!abstract] TL;DR
> Transforma o PRD aprovado + stack definida em um ambiente Claude Code acionável: skills especializadas por domínio, agents por disciplina, hooks que bloqueiam violações, e slash commands para tarefas repetitivas. É o que transforma "regras escritas" em "regras enforced".

## Quando esta fase se aplica

- PRD aprovado (fase 10) e stack definida (fase 20).
- `CLAUDE.md` do projeto já existe com stack declarada e regras de engenharia.
- Sem CLAUDE.md → crie um antes. Skills sem CLAUDE.md são skills sem contexto.

## Gates de entrada (binários — não avance sem atender)

- [ ] PRD aprovado (fase 10) com RFs enumerados e RNFs definidos
- [ ] Tabela de stack declarada (fase 20) no CLAUDE.md/AGENTS.md/equivalente
- [ ] Regras de engenharia declaradas (tipicamente vindas de [principios-transversais](./principios-transversais.md))
- [ ] Áreas de domínio identificadas a partir dos RFs (ex: game-engine, voice-ai, whatsapp, pedagogy)

Sem CLAUDE.md ou equivalente com stack + regras, skills serão genéricas. Crie antes.

## Gates de saída (binários — só passe adiante quando todos estiverem atendidos)

- [ ] CLAUDE.md (ou AGENTS.md/`.cursorrules`/equivalente) do projeto declara stack + regras + estrutura
- [ ] Skills criadas por área de domínio (cluster de RFs coeso), não 1 skill por RF
- [ ] Skills criadas por tecnologia-chave (cada componente não-trivial da stack)
- [ ] Agents criados por disciplina com modelo declarado (opus/sonnet/haiku), não agents genéricos
- [ ] ≥1 hook bloqueante para a violação arquitetural mais comum do projeto (ex: Clean Arch boundary, large files)
- [ ] Slash commands criados para tarefas executadas >3× (ex: `/test`, `/quality`, `/review-module`)
- [ ] README em `.claude/skills/` (ou equivalente) lista skills e propósito de cada uma
- [ ] Estrutura de checkpoint/status criada se projeto tem >1 agente ou duração >1 semana

**Como materializar cada um desses artefatos em cada ferramenta:** ver [materializacoes](./materializacoes.md) (ação "Criar skills/agents/hooks").

## ═══ BLOCO DENSO (acionável) ═══

### Checklist operacional

- [ ] CLAUDE.md do projeto escrito (stack, regras, structure overview)
- [ ] Áreas de domínio mapeadas a partir dos RFs (agrupar por responsabilidade)
- [ ] 1 skill criada por área de domínio + 1 skill por tecnologia-chave
- [ ] Skills de qualidade e engenharia: ao menos `engineering-standards`, `design-patterns-do-domínio`
- [ ] Agents criados para disciplinas que precisam de perspectiva própria (product, tech, QA, voice, etc.)
- [ ] Slash commands para: rodar testes, lint/quality check, review de módulo, architecture check
- [ ] Hooks configurados: test-reminder, architecture-violation, no-large-files, stop-quality-check
- [ ] Estrutura de controle/checkpoint do projeto criada (se >1 agente envolvido)
- [ ] README em `.claude/skills/` listando skills e propósito de cada uma

### Regras invioláveis

1. **Skill ≠ tutorial.** Skill não ensina uma tecnologia ao agente. Skill diz COMO USAR aquela tecnologia NESTE PROJETO, dentro destas regras. "Use Cognee com FalkorDB, NOT Graphiti" — não "o que é Cognee".
2. **Agent tem modelo e domínio declarados.** Cada agent define `model: opus|sonnet|haiku` e escopo claro. Agent genérico ("general helper") não vale — use o agente padrão do Claude Code.
3. **Hook que não bloqueia não serve.** Hook como "lembrete" é ignorado em 2 sessões. Hook que bloqueia a ação (`PreToolUse` com `decision: block`) cria disciplina real. Prefira bloqueio a aviso.
4. **Slash command para tudo que se repete >3×.** Se você roda `pytest --cov` 5 vezes por dia, crie `/test`. Se faz review de módulo manualmente, crie `/review-module`.
5. **Checkpoint discipline desde o dia 1.** Crie um arquivo de status (`docs/project-status.md` ou `.claude/docs/project-status.md`) que orquestrador/agente atualiza. Todo agente lê antes de começar.

### Taxonomia de skills (framework)

Organize skills em camadas, da mais específica para a mais geral:

```
Skills de domínio do produto          ← 1 por área funcional do PRD
├── fluency-product-requirements      (regras de negócio fluency-specific)
├── game-engine                       (regras de engine para adedonha)
├── voice-ai-pipeline                 (STT/TTS/VAD/latency budget)
└── whatsapp-flows-patterns           (menus, webview, business API)

Skills de tecnologia-chave            ← 1 por tech não-trivial da stack
├── cognee-memory                     (como usar Cognee neste projeto)
├── langgraph-workflows               (orchestration patterns, checkpoints)
├── neo4j-cypher / falkordb           (graph queries, ontology)
└── voice-ai-pipeline                 (pode overlap com domínio)

Skills de metodologia/qualidade       ← reutilizáveis entre projetos
├── engineering-standards             (KISS, DRY, SOLID, limites)
├── system-design-patterns            (scaling, caching, messaging)
├── web-usability-krug                (usabilidade Krug applied)
├── design-psychology-100-principles  (Weinschenk applied)
└── neuroscience-ux                   (neuro-experience applied)
```

### Taxonomia de agents (framework)

Agentes por disciplina, não por feature:

| Agent | Model | Quando usar |
|---|---|---|
| Product strategist | opus | Personas, jornadas, UX, apresentação a stakeholders |
| Code reviewer | sonnet | Code review, SOLID, testes, architecture compliance |
| Domain architect | opus | Decisões de stack, ADRs, refatoração de arquitetura |
| QA engineer | sonnet | Criação de test plans, edge cases, regression |
| Voice AI specialist | sonnet | STT/TTS, latência, pronunciation, voice UX |
| Growth engineer | sonnet | Aquisição, retenção, viralidade, pricing |

Nem todo projeto precisa de todos. MVP com 1 pessoa precisa no máximo de code-reviewer. Projeto multi-agent com voz precisa de voice-ai-specialist.

### Arquitetura de harness (para projetos longos/autônomos)

Para tarefas que ultrapassam a capability solo do modelo, a arquitetura padrão é o triângulo **Planner → Generator → Evaluator** (ver [harness-engineering](../concepts/harness-engineering.md)):

- **Planner**: expande prompt breve em spec ambicioso (alto-nível, não granular).
- **Generator**: trabalha feature-by-feature, commita, self-eval leve.
- **Evaluator**: SEPARADO do generator. Usa Playwright/browser-use MCP para atacar a aplicação viva como usuário. Testa criteria com **hard threshold** por critério.
- **Sprint contract** obrigatório: generator e evaluator negociam "o que é done" ANTES de qualquer código. Iteram até acordar, comunicando via arquivos (não mensagens efêmeras).

Decisão de quando usar harness pesado vs solo: tabela em [harness-engineering](../concepts/harness-engineering.md) seção "Quando aplicar".

### Escolha de padrão agentic (taxonomia)

Antes de criar skills/agents, escolha o padrão para a tarefa. Ver [agentic-patterns](../concepts/agentic-patterns.md) para a árvore completa de decisão.

| Situação | Padrão |
|---|---|
| Task simples + passos fixos | Single LLM + retrieval; sem agent |
| Decomposição sequencial fixa | Prompt Chaining |
| Categorias de input → especialistas | Routing (incluindo routing por custo: Haiku fácil → Opus difícil) |
| Sub-tasks independentes + paralelismo | Parallelization (sectioning) |
| Precisa múltiplas opiniões | Parallelization (voting) |
| Sub-tasks imprevisíveis a priori | Orchestrator-Workers |
| Refinamento iterativo + critério claro | Evaluator-Optimizer |
| Problema aberto + passos imprevisíveis | Agent autônomo (com sandbox + guardrails) |

**Regra de ouro** (do [building-effective-agents-anthropic](../concepts/building-effective-agents-anthropic.md)): "Start simples, aumente complexidade só quando demonstravelmente agrega". Agent autônomo é o ÚLTIMO recurso, não o primeiro.

### CLAUDE.md / AGENTS.md como ÍNDICE (≠ enciclopédia)

Padrão validado pela OpenAI em 1M+ linhas de código agent-written (ver [codex-agent-centric-world-openai](../concepts/codex-agent-centric-world-openai.md)):

- **AGENTS.md / CLAUDE.md**: ~100 linhas. Mapa. Aponta para `docs/`.
- **`docs/` estruturado** = system of record: `design-docs/`, `exec-plans/`, `product-specs/`, `references/`, `generated/`.
- **Progressive disclosure**: agente entra por ponto pequeno e estável, segue ponteiros.

**Comparação com seus projetos existentes**:
- `adedonha` (5.6KB CLAUDE.md + 6 docs auxiliares) → já segue esse padrão.
- `fluency` (11KB CLAUDE.md + 22 docs/) → beira o limite; considerar slim do CLAUDE.md movendo detalhes para docs específicos indexados.

### System prompt — "right altitude"

Ver [context-engineering](../concepts/context-engineering.md) para fundação completa.

Goldilocks zone entre:
- **Brittle**: if-else hardcoded, regras rígidas.
- **Vague**: guidance de alto-nível, sinais concretos ausentes.

**Optimal**: específico o bastante para guiar, flexível o bastante para heurísticas funcionarem. Estrutura via XML tags ou Markdown headers. **Minimal ≠ curto** — minimal = suficiente. Comece mínimo com modelo melhor; adicione sob demanda baseado em failure modes reais.

### ACI (Agent-Computer Interface) — design de tools

Tools são a ponte agent↔ambiente. Ver [agentic-patterns](../concepts/agentic-patterns.md) seção ACI para princípios; ver [context-engineering](../concepts/context-engineering.md) para ACI como mecanismo de retrieval (JIT).

**Checklist ACI ao criar uma tool custom:**
- [ ] Formato próximo ao que o modelo viu em texto natural (markdown > JSON-com-escape)
- [ ] Tokens para o modelo "pensar" antes de output definitivo
- [ ] Poka-yoke — argumentos que tornam erros difíceis (abs paths vs relative, IDs opacos vs significativos)
- [ ] Tool description como docstring para junior dev: exemplo, edge cases, formato claro
- [ ] Sem overhead de formatação (contagem de linhas, escape de aspas)

**Observação SWE-bench**: otimização de tools deu mais lift do que otimização do prompt principal. Invista em ACI.

### Taxonomia de hooks (framework)

| Hook | Tipo | Ação | Propósito |
|---|---|---|---|
| architecture-violation | PreToolUse (Write/Edit) | block | Impedir import de `infrastructure/` dentro de `domain/` |
| no-large-files | PreToolUse (Write/Edit) | block | Bloquear arquivo >300 linhas (ou limite do projeto) |
| test-reminder | PostToolUse (Write/Edit) | warn | Avisar quando código novo chega sem teste correspondente |
| stop-quality-check | Stop | block | Rodar lint+type+test antes de encerrar sessão |
| commit-quality | PreToolUse (Bash: git commit) | warn | Verificar lint+tests antes do commit |

### Taxonomia de slash commands (framework)

| Command | Ação |
|---|---|
| `/test` | Rodar pytest (ou equivalente) com coverage |
| `/quality` | Lint (ruff) + typecheck (mypy) + test |
| `/review-module <path>` | Code review focado num módulo |
| `/architecture-check` | Verificar Clean Arch boundaries |
| `/status` | Mostrar project-status.md |

### Árvore de decisão — quantas skills/agents criar

```
Quantos RFs tem o PRD?
├── < 10 RFs (MVP simples)
│   ├── 2-4 skills de domínio
│   ├── 1-2 skills de tecnologia
│   ├── 0-1 agent (code-reviewer basta)
│   ├── 2 commands (/test, /quality)
│   └── 2 hooks (no-large-files, test-reminder)
│
├── 10-30 RFs (produto médio)
│   ├── 4-8 skills de domínio
│   ├── 2-4 skills de tecnologia
│   ├── 2-3 agents (product, code-reviewer, domain-specific)
│   ├── 3-4 commands
│   └── 3-4 hooks
│
└── > 30 RFs (produto complexo, multi-agent)
    ├── 8-15 skills de domínio + tecnologia
    ├── 4-6 agents por disciplina
    ├── 4-6 commands
    ├── 4-5 hooks (incluindo architecture-violation e stop-quality-check)
    └── Checkpoint discipline OBRIGATÓRIA
```

### Defaults e anti-padrões

**Defaults:**
- Skill como markdown com frontmatter YAML. Sem código executável dentro.
- Agent com `model` explícito (opus para estratégia, sonnet para execução/review).
- Hooks via hookify quando possível (declarativo) ou `settings.json` para hooks simples.
- README.md em `.claude/skills/` como índice navegável.

**Anti-padrões:**
- ❌ Skill que é cópia da documentação oficial. Skill é "como usar AQUI, com ESTAS regras".
- ❌ Agent sem escopo. "Ajude no que for necessário" = agente padrão do Claude Code. Não crie agent sem domínio claro.
- ❌ Hook como warning eterno que ninguém lê. Prefira block. Se não vale bloquear, não vale hookar.
- ❌ 30 skills no dia 1. Comece com 4-6, cresça conforme o projeto pede. Skill sem uso é dívida de manutenção.
- ❌ Skills e agents sem versionamento. Coloque em `.claude/` no repo — versionado com o código.

### Decisões de juízo (não-templatizáveis)

- **Quando um domínio merece um agent vs uma skill.** Agent = perspectiva própria, modelo diferente, prompt de sistema dedicado. Skill = referência consultável pelo agente principal. Regra de bolso: se o domínio exige "pensar como X" (product strategist, pedagogical expert), é agent. Se é "seguir estas regras ao usar X" (cognee, langgraph), é skill.
- **Quando bloquear vs avisar via hook.** Bloqueie violações que causam dano silencioso difícil de detectar depois (Clean Arch boundary, arquivo gigante). Avise coisas que podem ter exceção legítima (teste ausente para utility trivial).
- **Quanto contexto colocar no CLAUDE.md vs em skills auxiliares.** CLAUDE.md deve caber na janela de contexto sem compressão prematura. Se passa de ~8-10KB, mova detalhes para skills e referencie do CLAUDE.md. O adedonha faz isso com 5.6KB no CLAUDE.md + 12 skills + 6 docs auxiliares. O fluency tem 11KB no CLAUDE.md + 26 skills.
- **Quando criar um checkpoint discipline formal vs informal.** Formal (arquivo de status + orquestrador): projetos >1 semana ou >1 agente paralelo. Informal (CLAUDE.md + git log): projetos curtos de 1 agente.
- **Quando adotar plugin/framework de ciclo (spec→plan→implement→review) vs workflow manual.** Plugins formais (superpowers no Claude Code, cycle templates no Cursor/Gemini) valem quando o ciclo é explícito e repetido. Para projetos ad-hoc, workflow manual (brainstorm na conversa + plan em `docs/`) basta. Ver [materializacoes](./materializacoes.md) para o adaptador por ferramenta.

## ═══ NARRATIVA ═══

### Racional

Esta fase é onde a metodologia deixa de ser documento e vira **infraestrutura de execução**. Skills, agents, hooks e commands são o "continuous delivery da metodologia": em vez de dizer "lembre de seguir KISS", o hook bloqueia a violação automaticamente.

A taxonomia em camadas (domínio → tecnologia → metodologia) evita o anti-padrão "skill por feature" que infla o número e reduz a qualidade. Cada skill deve cobrir um cluster coeso de conhecimento, não um RF individual.

A conexão com [frameworks-comportamentais](../concepts/frameworks-comportamentais.md) é relevante para skills de product/UX: se o projeto tem persona definida e jornada mapeada, as skills de product precisam incorporar o framework de engajamento (Hook Model, Peak-End, Octalysis) para que agentes que trabalham em UX/growth tenham esses modelos acessíveis sem precisar ir ao wiki.

### Exemplo real — fluency (referência máxima)

O fluency é o projeto mais instrumentado de todos:

**26 skills** organizadas em:
- Domínio (9): `fluency-product-requirements`, `fluency-competitive-intelligence`, `fluency-architecture-strategy`, `fluency-spiral-curriculum`, `fluency-engineering-standards`, `whatsapp-flows-patterns`, `language-learning-pedagogy`, `voice-ai-pipeline`, `user-persona-methodology`.
- Tecnologia: `cognee-memory`, `langgraph-workflows`, `neo4j-cypher`, `mem0-persistence`, `hybrid-rag`, `persistent-conversations`, `hitl-patterns`.
- Metodologia/qualidade: `system-design-patterns`, `web-usability-krug`, `design-psychology-100-principles`, `neuroscience-ux`, `lead-generation-conversion`, `landing-page-ux`, `sales-strategy-enterprise`, `product-strategy`.

**6 agents** por disciplina:
- `fluency-product-strategist` (opus) — personas, jornadas, stakeholders.
- `fluency-pedagogical-expert` (opus) — currículo, pedagogia, assessment.
- `fluency-whatsapp-architect` (sonnet) — API, flows, conversational UX.
- `fluency-growth-engineer` (sonnet) — aquisição, retenção, viralidade.
- `fluency-voice-ai-specialist` (sonnet) — STT/TTS, latência, pronunciação.
- `fluency-code-reviewer` (sonnet) — qualidade, SOLID, testes.

**4 slash commands**: `/test`, `/quality`, `/review-module`, `/architecture-check`.

**4 hookify rules**: `architecture-violation` (block), `no-large-files` (block), `test-reminder` (warn), `stop-quality-check` (block).

**Checkpoint discipline**: `docs/plans/` com roadmap, test-cases, admin-spec. CLAUDE.md de 11KB como hub navegável.

Essa instrumentação é COERENTE com a complexidade do projeto (>30 RFs, 7 serviços, 42 memory pipelines). Um MVP não precisaria de 1/4 disso.

### Exemplo real — adedonha (contraste calibrado)

**12 skills** de domínio: `game-engine`, `realtime-architecture`, `word-validation`, `matchmaking-system`, `anti-toxicity`, `monetization`, `growth-viral-loops`, `design-system-adedonha`, `gamification-progression`, `flutter-mobile`, `react-web`, `fastapi-backend`.

**6 agents**: `backend-architect`, `frontend-web`, `frontend-mobile`, `game-designer`, `qa-engineer`, `devops`.

**Docs auxiliares (6)**: `engineering-standards`, `project-status`, `roadmap`, `architecture-decisions`, `api-contracts`, `claude-code-best-practices`.

Proporção calibrada: projeto médio (~15-20 RFs), 12 skills, 6 agents, docs auxiliares no lugar de hooks formais. Nota: adedonha não tem hookify — a disciplina vem de `.claude/docs/engineering-standards.md` como referência soft. Isso funciona para 1 developer mas pode ser frágil com time. **Na metodologia para times, hooks (block) > docs (reference).**

### Armadilhas comuns

- **Skills escritas no brainstorm e nunca atualizadas.** Skills envelhecem com o código. Se a stack muda (ex: trocar Graphiti por Cognee), a skill precisa refletir. Inclua atualização de skills no checklist de mudança de stack.
- **Agent proliferation.** 10 agents em projeto de 2 pessoas = nenhum é usado direito. Comece com 2 (product + code-reviewer), adicione sob demanda.
- **Hooks que bloqueiam demais.** Hook que bloqueia QUALQUER arquivo >300 linhas vai travar migrations SQL, fixtures de teste, arquivos gerados. Configure exceções (glob patterns).
- **CLAUDE.md que vira enciclopédia.** >15KB no CLAUDE.md causa compressão prematura na janela de contexto. Mova para skills e referencie.
- **Confundir skill com prompt.** Skill é referência persistente. Prompt é instrução one-shot. Se a informação é útil em todas as sessões, é skill. Se é só esta tarefa, é prompt.

## Links

- Fase anterior: [20-stack](./20-stack.md)
- Fase seguinte: [40-execucao](./40-execucao.md)
- Princípios: [principios-transversais](./principios-transversais.md)
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- **Harness engineering (arquitetura de agentes para tarefas longas):** [harness-engineering](../concepts/harness-engineering.md)
- **Agentic patterns (taxonomia + ACI):** [agentic-patterns](../concepts/agentic-patterns.md)
- **Agent-centric codebase (AGENTS.md como índice, docs/ como system of record):** [agent-centric-codebase](../concepts/agent-centric-codebase.md)
- **Context engineering (system prompt altitude, ACI para retrieval):** [context-engineering](../concepts/context-engineering.md)
- **Agent evaluation (testar que o agent/skill faz o que espera):** [agent-evaluation](../concepts/agent-evaluation.md)
- Conceitos embasadores: [frameworks-comportamentais](../concepts/frameworks-comportamentais.md), [padroes-implementacao](../concepts/padroes-implementacao.md), [leis-de-krug](../concepts/leis-de-krug.md)
- Análise relacionada: 2026-04-14-adedonha-engagement-blueprint
- Raw: 2026-04-15-danilo-brain-dump
