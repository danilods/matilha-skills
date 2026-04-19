---
type: methodology
phase: "40"
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: skeleton
maturity: v1
created: 2026-04-16
updated: 2026-04-17
tags: [methodology, execution, orchestration, checkpoint]
author: matilha
license: MIT
---

# 40 — Execução com checkpoint

> [!abstract] TL;DR
> Transforma plano em código. Orquestração multi-agente exige **arquivo de controle/status que todos os agentes atualizam** — previne estouro de janela de contexto, permite pausar e retomar em outro dia sem perder trabalho.
>
> **Status: `skeleton`** — regras centrais do brain-dump capturadas; falta calibração contra projetos reais com execução multi-agente (candidato: fluency com `.superpowers/` + `docs/plans/`).

## Quando esta fase se aplica

- PRD aprovado (fase 10), stack definida (fase 20), skills/agents configurados (fase 30).
- Existe plano de execução derivado do PRD com tasks priorizadas.

## Decomposição: PRD → SPs → Waves (o elo entre planejamento e execução)

Antes de executar, o PRD precisa virar plano acionável. Esta decomposição é o **elo que conecta fase 30 à execução**:

1. **RFs do PRD** → agrupados em **SPs** (clusters coesos de funcionalidade, cada uma com critério de "done")
2. **SPs** → mapeadas em **grafo de dependência** (quem depende de quem)
3. **Grafo** → particionado em **waves** (SPs paralelo-safe = arquivos disjuntos)
4. **Cada SP** → **plano detalhado** (tasks atômicas + bundles + done criteria)

Como materializar esta decomposição: ver [materializacoes](./materializacoes.md) — se tem superpowers, use `writing-plans` enriquecido com os critérios abaixo; se não, decomponha manualmente com os mesmos critérios.

**Gates da decomposição:**
- [ ] SPs enumeradas (SP1…SPN), cada uma com escopo claro e critério de done
- [ ] Grafo de dependências entre SPs (qual depende de qual)
- [ ] Waves definidas: Wave 1 = {SPs sem dependências}, Wave 2 = {SPs que dependem só de Wave 1}, etc.
- [ ] Plano por SP salvo em `docs/plans/` (superpowers ou markdown manual)
- [ ] Disjunção de arquivos verificada por wave (SPs na mesma wave NÃO tocam mesmos arquivos)

**Árvore por tamanho do PRD:**

| PRD | SPs | Waves | Plano |
|---|---|---|---|
| <10 RFs (MVP simples) | 1-2 SPs | 1 wave | 1 arquivo, 10-20 tasks |
| 10-30 RFs (médio) | 3-6 SPs | 2-3 waves | 1 plano/SP em docs/plans/ |
| >30 RFs (complexo) | 6-12 SPs | 3-5 waves | 1 plano/SP + wave-status.md obrigatório |

## Gates de entrada (binários)

- [ ] Plano de execução existe com tasks enumeradas (markdown com checkboxes ou equivalente)
- [ ] Decomposição em SPs + waves concluída (seção acima)
- [ ] Cada task tem owner, dependências explícitas e status
- [ ] CLAUDE.md/AGENTS.md/`.cursorrules` do projeto declaram stack + regras + estrutura (slim, ≤150 linhas)
- [ ] Arquivo de controle/status criado e versionado em git

## Gates de saída (binários)

- [ ] Todas as tasks do plano fechadas ou deliberadamente despriorizadas (com razão registrada)
- [ ] Arquivo de status reflete a realidade (não há task "done" sem evidência em código)
- [ ] Nenhuma sessão deixou estado ambíguo — pausar agora e retomar amanhã não exige re-leitura de histórico
- [ ] Agentes paralelos nunca escreveram no mesmo arquivo sem merge explícito
- [ ] Commits seguem convenção (feat/fix/refactor/test/docs/chore)

**Como executar o plano com checkpoint em cada ferramenta:** ver [materializacoes](./materializacoes.md) (ação "Executar plano com checkpoint").

## ═══ BLOCO DENSO ═══

### Checklist operacional

- [ ] Toda task do plano tem ID único, owner, status
- [ ] Status atualizado a cada turno de agente (pending → in_progress → completed)
- [ ] Agente, antes de começar, lê o status e identifica sua próxima task
- [ ] Agente, ao terminar, registra no status o que fez + o que sobrou + bloqueios encontrados
- [ ] Agentes em paralelo trabalham em tasks **independentes** (sem shared state no mesmo arquivo)
- [ ] Código que não tem teste ainda é `in_progress`, não `completed`
- [ ] Commit ao finalizar cada task (ou grupo coeso) — evita trabalho em árvore suja por dias

### Regras invioláveis

1. **Checkpoint não é opcional em projetos multi-agente ou >1 semana.** Sem arquivo de status, perda de contexto é inevitável.
2. **Uma task = uma unidade atômica de valor.** Se você não consegue dizer "essa task está pronta", ela é grande demais — quebre.
3. **Agente que não registra não terminou.** Status não atualizado = trabalho invisível = retrabalho.
4. **Nunca avance com quality gate vermelho.** Lint falha, teste falha, type check falha = task não está `completed`.
5. **Contexto tem orçamento — context reset > compactação.** Quando janela satura, PREFIRA **context reset com handoff estruturado** (janela nova + artefato que carrega estado) em vez de só compactação in-place. Compactação não resolve "context anxiety" (modelo encerra prematuramente achando que vai estourar). Ver [harness-engineering](../concepts/harness-engineering.md) seção "Context reset vs compactação".
6. **Handoff via arquivo, não via mensagem.** Mensagens são efêmeras e se perdem entre sessões. Artefato em arquivo (status + decisões tomadas + próximos passos) é reproduzível.

### Árvore de decisão

```
Quantos agentes envolvidos simultaneamente?
├── 1 agente / 1 sessão curta (<1 semana)
│   └── Status file opcional, mas CLAUDE.md + git log suficientes
│
├── 1 agente / múltiplas sessões (>1 semana)
│   └── Status file OBRIGATÓRIO. Cada sessão nova começa lendo-o.
│
├── 2+ agentes em paralelo (dispatch concorrente)
│   ├── Tasks precisam ser independentes (sem shared state no mesmo arquivo)
│   └── Status file com coluna "owner" por task, updates atomicamente
│
└── Orquestrador + agentes executores
    ├── Orquestrador DEFINE tasks e escreve status inicial
    ├── Executores PEGAM tasks e atualizam status
    └── Orquestrador VERIFICA e re-prioriza ao fim de cada ciclo
```

### Long-horizon context management (3 técnicas canônicas)

Quando a task soma mais tokens que o context window. Ver [context-engineering](../concepts/context-engineering.md) para fundação.

| Característica da task | Técnica primária | Materialização |
|---|---|---|
| Conversational back-and-forth extensivo | **Compaction** (summarize + reinicia) | `/compact` no Claude Code; compaction automática no Agent SDK |
| Iteração com milestones claros | **Structured note-taking** | `NOTES.md` no repo; to-do list do agent; memory tool |
| Research complexo ou exploração paralela | **Sub-agent architectures** | Dispatch de agents especializados com clean context, retornam 1-2K condensados |

**Regra**: comece com a mais simples que funciona (compaction), escale quando precisar (notes → sub-agents).

**Compaction vs context reset** (ver [harness-engineering](../concepts/harness-engineering.md)): compaction mantém continuidade conversacional; reset dá clean slate (necessário para modelos com context anxiety forte como Sonnet 4.5). Opus 4.6 reduziu anxiety → compaction automática frequentemente basta.

### Wave-based parallel execution (dispatch + merge de ondas)

Para ondas de SPs independentes (arquivos disjuntos) que podem executar em paralelo em sessões separadas. Padrão validado em adedonha (3 SPs paralelas em 3 terminais).

**Estrutura de uma wave:**

```
Wave N = {SP-A, SP-B, SP-C}  ← tocam arquivos disjuntos
                ↓
   matilha hunt <slug> --wave N     (Phase 40 dispatch; Wave 3a shipped)
                ↓
   ┌────────────┬────────────┬────────────┐
   │ Terminal 1 │ Terminal 2 │ Terminal 3 │
   │ worktree-A │ worktree-B │ worktree-C │
   │ branch A   │ branch B   │ branch C   │
   │ kickoff.md │ kickoff.md │ kickoff.md │
   └─────┬──────┴─────┬──────┴─────┬──────┘
         │            │            │
         ▼            ▼            ▼
    SP-DONE.md   SP-DONE.md   SP-DONE.md
   (um por worktree; frontmatter com gates strict)
                ↓
   matilha gather <slug> --wave N   (Phase 40 merge; Wave 3b shipped)
                ↓
   merge sequencial (--no-ff) → per-SP regression → wave-status atualizado
                ↓
   (opcional: --cleanup remove worktrees + branches merged)
```

**Gates de entrada do `matilha hunt`** (pre-flight Swiss Cheese):
- [ ] Plano existe em `docs/matilha/plans/<slug>-plan.md`
- [ ] `project-status.md` mostra `current_phase >= 30`
- [ ] Árvore de trabalho limpa
- [ ] Disjunção intra-wave validada (SPs tocam arquivos disjuntos); bypass via `--allow-overlap`

**Gates de entrada do `matilha gather`** (pre-flight Swiss Cheese):
- [ ] `wave-NN-status.md` existe e valida contra `waveSchema`
- [ ] Branch atual é a integração (não um branch SP `wave-NN-sp-*`)
- [ ] Árvore de trabalho limpa
- [ ] Cada SP pendente tem `SP-DONE.md` passando gates strict (status=completed, tests.passed=true, commits não-vazio, completed_at non-null, tests.count>=1)

**Gates de saída de `/gather`** (registrados em `wave-NN-status.md`):
- [ ] Todos os SPs em `status: completed`
- [ ] `regression_status: passed`
- [ ] `ended: <ISO8601 UTC>`
- [ ] `status: completed` (wave-level)

**Tag e phase advance são decisões humanas separadas** (não feitas por /gather):
- Tag `wave-N-complete` é opcional (git tag manual quando a wave se estabilizar).
- `current_phase` avança via `matilha attest phase-40-gate` quando você decidir.

**Artefatos:**
- `kickoff.md` — gerado por `/hunt` em cada worktree com prompt completo (plano + contexto + quality gates); gitignorado no repo principal.
- `docs/matilha/waves/wave-NN-status.md` — wave-level tracking (lido + escrito por /hunt e /gather; conforma `waveSchema`).
- `SP-DONE.md` — sinal de completude escrito pelo agent ao terminar cada SP (frontmatter strict: status, completed_at, commits[], tests.passed/count).

**Templates disponíveis no registry `matilha-skills`:** `templates/kickoff.md.tmpl` + `templates/sp-done.md.tmpl`. Gerados em cada worktree por `matilha hunt`.

**Quando usar sessões separadas vs Agent tool paralelo:**
- SPs de **>1h** cada → sessões separadas (terminais distintos). Cada sessão tem contexto próprio, não compartilha window. Correto.
- SPs de **<30min** cada → `Agent` tool com `run_in_background: true` na mesma sessão. Mais simples, sem cerimônia de worktree. Ver skill `superpowers:dispatching-parallel-agents`.
- **Regra de bolso**: se a SP vai gerar >50K tokens de output, sessão separada. Senão, background agent.

### Ralph Wiggum loop + worktree-per-change

Padrão validado pela OpenAI em 1M linhas agent-written (ver [agent-centric-codebase](../concepts/agent-centric-codebase.md)):

**Ralph Wiggum loop**: agente itera até todos revisores (agents + humanos) estarem satisfeitos.
1. Agente implementa.
2. Agente auto-review local.
3. Agente solicita review de agents especialistas (via subagent dispatch).
4. Agente responde feedback.
5. Repete até aprovação.

Hooks/scripts mantêm o loop em movimento sem intervenção humana.

**Worktree-per-change**: cada mudança roda em Git worktree isolada. App inicializável por worktree. Elimina conflitos em paralelismo. Ver methodology/materializacoes para como ativar em cada ferramenta.

### Defaults e anti-padrões

**Defaults:**
- Status file em `docs/project-status.md` ou `.claude/docs/project-status.md` (ver adedonha).
- Formato: lista de tasks com checkboxes + metadados (owner, status, started, completed).
- Commit do status file a cada turno que ele muda.
- Agentes recebem instrução no CLAUDE.md: "antes de começar, leia project-status.md; antes de encerrar, atualize".

**Anti-padrões:**
- ❌ Status file que vira ata de reunião ("Reunião com X em Y") — status ≠ diário pessoal.
- ❌ Task "Implementar feature X" sem subtasks para projeto complexo — invisibilidade de progresso.
- ❌ Agentes paralelos escrevendo no mesmo arquivo sem coordenação — merge conflict garantido.
- ❌ Continuar em janela >80% cheia — degradação de qualidade.
- ❌ Commit de "WIP" acumulando dias — incapacidade de rollback.

### Decisões de juízo (não-templatizáveis)

- **Quando a janela está "saturada o suficiente" para comprimir.** Sinal: respostas ficam genéricas, agente "esquece" decisões tomadas 30 msgs atrás. Comprima proativamente antes de chegar aqui.
- **Quando quebrar uma task em subtasks.** Heurística: se você não consegue estimar duração (30min, 2h, 1 dia), a task é grande demais.
- **Quando rollback é mais barato que conserto.** Código divergiu tanto que fix é risco alto. Git reset + retry costuma ser mais seguro do que "arrumar depois".

## ═══ NARRATIVA ═══

### Racional

Checkpoint discipline é a regra que o brain-dump marca como **"grande risco que deve ser prontamente atendido"**. Não é burocracia — é defesa contra perda de contexto, que é o modo de falha mais caro em desenvolvimento assistido por IA.

Ver [principios-transversais](./principios-transversais.md) regra 8 — checkpoint discipline nunca é opcional em projetos com >1 agente.

### Exemplo real — placeholder (skeleton)

> [!todo] Calibração pendente
> Candidato a âncora: **fluency** (tem `.superpowers/` + `docs/plans/` com roadmap 8-weeks + test cases + admin-spec). Representa execução multi-agente orquestrada. Upgrade para `status: deep` virá em sessão futura.

### Armadilhas comuns

- **Status file que mente.** Task marcada como `completed` sem commit/teste correspondente. Antídoto: lint periódico (`status diz completed, git log diz o quê?`).
- **Checkpoint esquecido em sessão curta.** "Essa task é rápida" → vira multi-sessão → caos. Default: checkpoint desde a primeira sessão.
- **Agentes paralelos desenhados como serial.** Dispatch de 3 agentes para tarefas que dependem umas das outras = serialização com overhead. Paralelismo exige independência.

## Links

- Fase anterior: [30-skills-agents](./30-skills-agents.md)
- Fase seguinte: [50-qualidade-testes](./50-qualidade-testes.md)
- Princípios: [principios-transversais](./principios-transversais.md)
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- **Harness engineering (context reset, handoff artifacts):** [harness-engineering](../concepts/harness-engineering.md)
- **Agent-centric codebase (Ralph Wiggum, worktree-per-change, observability para agente):** [agent-centric-codebase](../concepts/agent-centric-codebase.md)
- **Context engineering (compaction, note-taking, sub-agents para long-horizon):** [context-engineering](../concepts/context-engineering.md)
- Conceitos embasadores: [nfr-system-design](../concepts/nfr-system-design.md)
- Raw: 2026-04-15-danilo-brain-dump
