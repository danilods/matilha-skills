# Wave 5h — matilha-software-arch-pack execution plan (draft)

Pattern-matched against Wave 5e/5f/5g (software-eng-pack shipping) and
Wave 5d (composition) plans. Caminho C source distillation — no wiki
ingestion needed.

**Goal**: ship `matilha-software-arch-pack@0.1.0` with 17 skills
across 5 families, grounded in Danilo's Argos + Gravicode architectural
practice. Integrate with existing sysdesign-pack and harness-pack via
"Complementa" disclosures.

**Repos touched**:
- `matilha-software-arch-pack` (new) at `/Users/danilodesousa/Documents/Projetos/matilha-software-arch-pack` — created in SP1.
- `matilha` (CLI) at `/Users/danilodesousa/Documents/Projetos/matilha` — validator extension in SP3.
- `matilha-skills` at `/Users/danilodesousa/Documents/Projetos/matilha-skills` — README reference + memory wiki update in SP4.

**Source of truth for rules**: `matilha-skills/docs/staging/caminho-c-arch/rules-draft/`
(5 rules files drafted this wave). These get moved to
`matilha-software-arch-pack/docs/rules/` in SP1.

---

## SP1 — Pack scaffold + rules migration (3h)

**Estimated effort**: 3h (1 dev).

### Deliverables

- New repo scaffold: `matilha-software-arch-pack/`
  - `.claude-plugin/plugin.json` (name: `matilha-software-arch-pack`,
    version: `0.1.0-rc.1`, category: `swarch`)
  - `README.md` (1 page — pack purpose, skill families, install)
  - `CHANGELOG.md` (0.1.0-rc.1 entry)
  - `docs/rules/` — migrated from `matilha-skills/docs/staging/caminho-c-arch/rules-draft/` (5 files, final naming convention)
  - `docs/skills-inventory.md` — migrated from
    `matilha-skills/docs/staging/caminho-c-arch/skill-inventory.md`
  - `docs/overlap-analysis.md` — migrated from
    `matilha-skills/docs/staging/caminho-c-arch/overlap-analysis.md`
  - `docs/source-distillation-workflow.md` (copy of software-eng-pack's,
    adjusted — Caminho C procedure for turning rules into skills)
  - `skills/.gitkeep` (SP2 fills in)
  - `index.json` stub (SP2 populates)

### Tasks

- [ ] Initialize repo layout (mirror matilha-software-eng-pack directory structure)
- [ ] Write plugin.json with correct manifest
- [ ] Write README (pack positioning, link to rules + inventory)
- [ ] Copy `rules-draft/*` → `docs/rules/` with final filenames
- [ ] Copy skill-inventory.md, overlap-analysis.md to `docs/`
- [ ] CHANGELOG entry
- [ ] Commit: `chore(scaffold): initialize matilha-software-arch-pack 0.1.0-rc.1`

---

## SP2 — Skill authoring (3 parallel dispatches, 6h each → 6h wall-clock)

**Estimated effort**: 18h worker-hours, 6h wall-clock with 3 parallel workers.

### SP2.A — Dependency/layering + Data architecture (7 skills)

Worker dispatched with: `rules-draft/Layering e Dependency Direction.md`
and `rules-draft/Dual-Store Architecture.md`. Writes:
- `skills/swarch-dependency-direction/SKILL.md`
- `skills/swarch-lambda-chain-shape/SKILL.md`
- `skills/swarch-handler-as-adapter/SKILL.md`
- `skills/swarch-dual-store-source-of-truth/SKILL.md`
- `skills/swarch-cdc-over-dual-write/SKILL.md`
- `skills/swarch-hot-state-via-status-machine/SKILL.md`
- `skills/swarch-projection-rebuild-discipline/SKILL.md`

Mandatory sections per skill (12 canonical, matching existing pack
validator): When this fires, Preconditions, Execution Workflow, …, Companion Integration.

### SP2.B — Event-driven + Bounded contexts (7 skills)

Worker dispatched with: `rules-draft/Event-Driven Decoupling.md` and
`rules-draft/Bounded Contexts na Prática.md`. Writes:
- `skills/swarch-fact-vs-command-events/SKILL.md`
- `skills/swarch-event-gateway-boundary/SKILL.md`
- `skills/swarch-ordering-decision/SKILL.md`
- `skills/swarch-event-schema-contract/SKILL.md`
- `skills/swarch-context-by-vocabulary/SKILL.md`
- `skills/swarch-context-without-microservice/SKILL.md`
- `skills/swarch-acl-between-contexts/SKILL.md`

### SP2.C — Escalabilidade + index.json integration (3 skills + glue)

Worker dispatched with `rules-draft/Escalabilidade sem Prematuridade.md`.
Writes:
- `skills/swarch-ticker-vs-rule-per-entity/SKILL.md`
- `skills/swarch-pull-over-push-orchestration/SKILL.md`
- `skills/swarch-measure-before-scale/SKILL.md`
- Updates `index.json` with all 17 skills registered (depends on
  SP2.A and SP2.B slug list — dispatched with full inventory to pre-populate).

### Quality gates per SP2 worker

- Each skill 180-280 body lines (aligns with software-eng-pack and
  sysdesign-pack norms).
- Each skill invokes `Complementa` disclosure when listed in
  `overlap-analysis.md`.
- Each skill uses the 12-section canonical body.
- Integration check at end of SP2: 17 SKILL.md files exist; index.json
  lists 17; no merge conflicts.

---

## SP3 — Validator extension (4h)

**Estimated effort**: 4h.

### Deliverables

- `tests/registry/content-validation.test.ts` in `matilha` CLI —
  extend with `describe("matilha-software-arch-pack")` block.
- Tests to add (follow pattern from sysdesign/harness/software-eng blocks):
  - 17 skill files exist at expected paths
  - All 17 have valid frontmatter (Zod schema)
  - All 17 have the 12 canonical body sections
  - Skills listed as overlap-complements have the "Complementa" marker
    in body (~6 skills)
  - No hardcoded absolute paths in bodies
  - `index.json` of pack matches on-disk skills (no ghosts, no missing)
  - Description linter rules (starts with "Use when" or "You MUST", under 500 chars)

Estimated test count: ~25-30 new tests.

### Tasks

- [ ] Read existing pack test blocks to match pattern
- [ ] Author swarch-pack describe block
- [ ] Run full suite — expect total near 903 + 30 = ~933 tests
- [ ] CHANGELOG entry in `matilha` CLI repo
- [ ] Commit and push

---

## SP4 — Ship (3h)

**Estimated effort**: 3h.

### Deliverables

- `matilha-software-arch-pack` v0.1.0 tag + GitHub release
- `matilha` CLI new release with validator covering swarch-pack
- `matilha-skills/README.md` updated to reference swarch-pack as fourth
  shipped companion
- `matilha-skills` memory note: `matilha-wave-5h-shipped.md` in `/Users/danilodesousa/.claude/projects/.../memory/`

### Tasks

- [ ] Runtime smoke test: enable swarch-pack in a fresh session, invoke
  ~5 diverse triggering intents; confirm activation works.
- [ ] Tag v0.1.0 on matilha-software-arch-pack
- [ ] Create GitHub release with release notes
- [ ] Update matilha-skills README (reference pattern of waves 5a/5b/5c)
- [ ] Write Wave 5h shipped memory note
- [ ] Update Obsidian index.md + log.md (optional — user choice)

---

## Wave 5h total estimate

| SP | Description | Wall-clock |
|---|---|---|
| SP1 | Pack scaffold + rules migration | 3h |
| SP2 | Skill authoring (3 parallel workers) | 6h |
| SP3 | Validator extension | 4h |
| SP4 | Ship | 3h |
| **Total** | | **16h wall-clock** |

Worker-hours (if sequential): 3 + 18 + 4 + 3 = **28h worker-hours**.

Parallelization is the same pattern used in Wave 5a/5b/5c for the other
three companion packs. No new risk vectors expected.

---

## Recomendação: security-pack — Caminho C agora ou esperar wiki?

### Fatos

Danilo **tem opinião de prática substancial** em segurança, extraída
dos projetos atuais (já presentes na wiki + notes):

- **Argos**: AWS Secrets Manager (nunca env vars hardcoded), rate
  limiting distribuído via Redis + Lua Token Bucket, failsafe em IA
  para não bloquear notificação, NAT Gateway vs subnet pública
  (decisão de segurança + custo), DLQ como proteção contra poison
  pill.
- **Gravicode**: LGPD/HIPAA compliance, AES-256-GCM encryption para
  PHI, OAuth 2.0, PII nunca persiste no server (Chrome Extension),
  Guardian emergency bypass com confidence threshold, HITL para
  decisões críticas.

Isso já é material para **~12-15 skills Caminho C** cobrindo: AWS
auth patterns, LGPD-compliant logging, secrets management, rate
limiting como defesa, encryption at rest/transit, fail-safe vs
fail-open decisions, PII redaction, circuit breakers como proteção.

### O que OWASP + Shostack adicionam

- **OWASP Top 10 / ASVS**: vocabulário canônico, checklist
  estruturado (injection, auth, XSS, SSRF, etc.). Forte em web
  app security, mais leve em cloud/eventing.
- **Shostack (Threat Modeling)**: STRIDE, DFD, attack trees —
  framework estruturado de **antecipação** de ameaças, não só
  mitigação. Muito valioso pra design de sistemas novos.

Esses dois trariam ~8-12 skills adicionais com um viés
complementar (metodologia de threat modeling + checklist
canônico de web security) que o material de prática do Danilo
naturalmente não cobre (ele não fez threat modeling formalizado
no Argos; fez controles reativos).

### Tradeoff

| Opção | Prós | Contras |
|---|---|---|
| **Caminho C agora** (Wave 5i, ~16h) | Ship rápido; padrão já estabelecido com software-eng e swarch; substrato AWS-concreto | Sem framework de threat modeling; limitada à web app security |
| **Esperar wiki ingestion** (Wave 5i + 5j, ~40h) | Cobertura canônica OWASP + STRIDE; vocabulário amplo | Dobra de tempo; atrasa close do naipe "security"; ingestion OWASP/Shostack é investimento de ingestão sério |
| **Híbrido**: Caminho C agora + wiki-augmented depois | Aplica rápido a practitioners AWS/LGPD; deixa teto alto pra expansão | Precisa garantir extensibilidade de namespace (decisão agora: `sec-*` ou `swsec-*`?) |

### Recomendação

**Híbrido: Caminho C primeiro (Wave 5i imediatamente após 5h)**, com
escopo declarado:

- Prefix: `swsec-*` (paralelo a `swarch-*` e `sweng-*`; deixa `sec-*`
  livre para literature-based se vier).
- Escopo: **segurança operacional AWS-centric + LGPD** (Argos/Gravicode
  practice). Não promete cobrir OWASP Top 10 ou STRIDE — isso fica
  explicitamente fora do v0.1.0, com nota no README "complementa,
  não substitui, OWASP/threat modeling formais".
- Wave futuro (5k ou 6a) ingere OWASP + Shostack e publica
  **sysdesign-security-pack** ou **threatmodel-pack** — packs separados,
  não merge.

Razão: ritmo de shipping importa. Danilo já tem 5 packs shipped com
pattern Caminho C provado; sexto pack segue mesmo molde. Ingestion
de OWASP (~30h) bloqueia meses de entrega de valor prático.
Caminho C em 16h desbloqueia uso imediato pros projetos em mão
(Argos v3 + Gravicode evolução). Literature-augmented vem depois,
quando sobrar tempo pra ingestão de qualidade.

**Sinalizar no momento do ship**: adicionar bullet no README do
swsec-pack explicitando o escopo limitado e os packs futuros
planejados. Transparência evita dúvida "esses skills cobrem OWASP?".

---

## Riscos e mitigações

| Risco | Mitigação |
|---|---|
| Overlap com sysdesign-pack confunde usuário | `overlap-analysis.md` drafted; "Complementa" disclosure em ~6 skills; descrições sharp com substrato AWS explícito |
| Caminho C pode soar genérico se não aterrado o suficiente | Todos os 17 skills referenciam Argos ou Gravicode no body ("Padrões na Prática" section); rules-draft já está rico |
| Validator regressions com 30 novos tests | SP3 roda full suite antes de merge; pattern igual aos waves anteriores |
| Runtime smoke falha | SP4 reserva 1h pra debug; fallback: ship com nota de "beta — feedback appreciated" |
