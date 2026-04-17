---
type: concept
sources:
  - "[codex-agent-centric-world-openai](../concepts/codex-agent-centric-world-openai.md)"
created: 2026-04-16
updated: 2026-04-17
tags: [concept, agents, codebase, repo-structure, openai]
phase: reference
author: matilha
license: MIT
---

# Agent-Centric Codebase

Padrão de arquitetura de repositório otimizado para **legibilidade e operação por agentes**, em vez de (ou além de) humanos. Quando agentes escrevem a maioria do código, o repo precisa ser navegável e verificável por agentes — senão, gargalo é atenção humana.

> [!abstract] Princípio mestre
> "Do ponto de vista do agente, qualquer coisa que ele não consiga acessar no contexto enquanto está em execução, efetivamente não existe."

Corolário operacional: **conhecimento em Slack, Google Docs, ou cabeças humanas é invisível ao sistema**. Se você quer que o agente aja sobre ele, move para artefato versionado local.

## Os 6 pilares

### 1. AGENTS.md (ou CLAUDE.md) como ÍNDICE, não enciclopédia

~100 linhas, pura navegação. Aponta para `docs/` estruturado.

**Por que não monolito grande:**
- Contexto é escasso. Arquivo gigante ofusca task + código relevante.
- Excesso de orientação = não-orientação. Tudo "importante" = nada importante.
- Apodrece rápido. Monolito vira cemitério de regras obsoletas.
- Difícil verificar mecanicamente (cobertura, frescor, propriedade).

### 2. `docs/` como system of record

Estrutura referência:

```
docs/
├── design-docs/            ← decisões de design por tópico
│   ├── index.md
│   ├── core-beliefs.md     ← princípios operacionais
│   └── ...
├── exec-plans/             ← planos efêmeros ou completos
│   ├── active/
│   ├── completed/
│   └── tech-debt-tracker.md
├── product-specs/          ← specs product-level
├── references/             ← llms.txt de deps principais
├── generated/              ← docs geradas automaticamente (schema, etc.)
├── DESIGN.md
├── FRONTEND.md
├── PRODUCT_SENSE.md
├── QUALITY_SCORE.md
├── RELIABILITY.md
└── SECURITY.md
```

**Progressive disclosure**: agente começa em ponto de entrada pequeno, segue ponteiros. Não é afogado em primeiro turn.

**Tudo auto-validado**: linters custom + CI verificam frescor, interlinkagem, propriedade. Um "janitor agent" recorrente detecta docs obsoletos e abre PRs de correção.

### 3. Tudo agent-readable — tooling como ACI

Aquilo que o agente não consegue inspecionar, não existe. Reforma:
- **App controllable via Chrome DevTools MCP**: agente roda instância, clica, screenshot, testa, corrige, repete. Ciclo completo sem humano.
- **Observability stack local** (logs/metrics/traces via Victoria + Vector). Acessível ao agente via LogQL/PromQL/TraceQL. Viabiliza instruções concretas: "garanta startup <800ms".
- **Worktree-per-change**: app inicializável por Git worktree. Agente roda instância isolada por alteração, evita conflitos.
- **Run autônomo de 6+ horas**: recorrente quando scaffolding é completo.

### 4. Arquitetura rígida, imposta por linters

Padrão ilustrativo do Codex: cada domínio tem camadas fixas com direções de dependência estritas.

```
Types → Config → Repo → Service → Runtime → UI
                 ↑
              Providers   (cross-cutting: auth, conectores, telemetria, feature flags)
```

- Linters custom (gerados pelo próprio agente) validam dependency edges.
- Testes estruturais enforcement.
- "Invariantes de gosto" codificados mecanicamente: structured logging, naming, file size limits, reliability per platform.

**Inversão não-óbvia**: arquitetura rígida ACELERA com agentes. Com humanos, arquitetura rígida pode virar burocracia. Com agents, restrição previne drift e permite velocidade sem deterioração.

### 5. Mensagens de erro de lint como canal de instrução

Lints custom têm mensagens escritas para **inserir instruções de correção no contexto do agente**.

- Lint ruim: "Arquivo muito grande (max 300 linhas)."
- Lint bom: "Arquivo excede 300 linhas. Split em módulos por responsabilidade. Ver `docs/DESIGN.md` section 'file size'. Sugestão: extrair `<X>` para novo módulo."

Próxima iteração do agente sabe como consertar, não só o que quebrou.

### 6. Gestão de entropia: "Golden Principles" + background GC

**Problema**: agentes replicam padrões existentes (inclusive ruins). Drift acumula.

**Solução**:
- "Princípios de ouro" codificados no repo: regras mecânicas opinativas.
  - Ex: "prefira utility packages compartilhados vs helpers custom".
  - Ex: "não faça polling YOLO — valide boundaries ou confie em SDKs tipados".
- **Background Codex tasks recorrentes** verificam drift, atualizam quality ratings, abrem PRs de refactor específicos.
- Maioria dessas PRs revisáveis em <1 min; merge automático quando possíveis.

**Analogia**: tech debt como empréstimo com juros altos. Pagamentos contínuos pequenos > acumular e pagar em rajada.

## Filosofia de merge em alta throughput

- PRs curtos, low-lock merge.
- Instabilidades de teste → re-runs, não blockers.
- Em baixa throughput seria irresponsável. Em alta throughput (agents geram muito, humanos atenção scarce), correções são baratas, esperar é caro.

## Ralph Wiggum loop

Nome cunhado pela comunidade, referenciado pelo artigo: agente itera em loop até todos revisores (agents + humanos) estarem satisfeitos. Hooks/scripts mantêm o loop em movimento.

Materialização canônica:
1. Agente implementa.
2. Agente auto-review local.
3. Agente solicita review de agents especialistas.
4. Agente responde feedback.
5. Repete até aprovação.

## Quando aplicar este pattern

| Perfil | Adoção recomendada |
|---|---|
| Projeto solo, ciclo curto | Pegar 1 pilar por vez (AGENTS.md como índice é o de maior leverage) |
| Time pequeno, ciclo médio | Pilares 1, 2, 4 (índice + docs + arquitetura rígida) |
| Time médio com autonomia agent forte | Todos os 6. Janitor agent + background GC ganham ROI rápido |
| Zero-hand-written-code aspiracional | Todos + SDK de agents + linters custom + observability completa |

## Antipadrões

- ❌ **AGENTS.md/CLAUDE.md >10KB** com tudo misturado.
- ❌ **Docs críticas em Google Docs/Slack** — invisíveis ao agente.
- ❌ **Arquitetura "flexível" quando há agents** — agente adota padrão encontrado (mesmo ruim), drift explode.
- ❌ **Lint messages apenas "o que quebrou"** — perde oportunidade de instruir.
- ❌ **Tech debt em rajadas trimestrais** — tech debt contínuo + background GC é 10× mais barato.
- ❌ **App não controllable pelo agente** (sem Chrome DevTools MCP, sem observability) — agente não fecha feedback loop, depende de humano.

## Ligações com o resto do vault

- [harness-engineering](../concepts/harness-engineering.md) — executa em CIMA de repo agent-centric. Harness sem repo agent-centric funciona, mas perde throughput.
- [agentic-patterns](../concepts/agentic-patterns.md) — escolha de padrão (workflow vs agent) acontece no contexto definido por este repo.
- methodology/20-stack — "tecnologias chatas" (APIs estáveis, reutilizadas no training set) são mais agent-friendly. Afeta decisão de stack.
- methodology/30-skills-agents — taxonomia de skills/agents/hooks precisa ser redesenhada sob lente agent-centric: AGENTS.md como índice, linters como mensagens, janitor agents.
- methodology/40-execucao — Ralph Wiggum loop + worktree-per-change são patterns de execução.
- methodology/50-qualidade-testes — linters custom + quality ratings auto-computadas + background GC.

## Links

- Source: [codex-agent-centric-world-openai](../concepts/codex-agent-centric-world-openai.md)
- Concepts relacionados: [harness-engineering](../concepts/harness-engineering.md), [agentic-patterns](../concepts/agentic-patterns.md)
- Methodology consumers: methodology/20-stack, methodology/30-skills-agents, methodology/40-execucao, methodology/50-qualidade-testes
