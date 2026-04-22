---
title: Wave 5d — Composition Layer
slug: wave-5d-composition-layer
date: 2026-04-21
status: design-approved
repos_touched: [matilha-skills, matilha]
estimated_effort_hours: 10
design_origin: memory/matilha-wave-5d-composition-design.md
---

# Wave 5d — Composition Layer (spec)

> Make matilha core skills become companion-pack-aware orchestrators that detect installed packs, win activation ahead of generic creative-work skills, inject pack-aware preamble when delegating to `superpowers:brainstorming`, and co-exist with (not compete against) superpowers.

## 1. Purpose

Close the composition gap surfaced during Wave 5c live smoke testing. A creative-work prompt ("Estou construindo MVP de 4 semanas que precisa rodar autonomamente. Como estruturo os agents?") was intercepted by `superpowers:brainstorming` (which has a "MUST use before any creative work" trigger). Brainstorming explored intent generically and never surfaced `harness-*` content from the installed `matilha-harness-pack`.

The gap is systemic — it affects all three companion packs (ux, growth, harness) on any prompt framed as creative work rather than phase-scoped planning. Matilha declares Companion Integration passively today but does not actively detect packs and inject their context when another skill is about to run.

Wave 5d introduces a composition layer: a new gateway skill (`matilha-compose`) plus body refactors on `matilha-plan` and `matilha-design`, supported by validator extensions that protect the architectural invariants.

## 2. Context

- Wave 5c shipped `matilha-harness-pack` 0.1.0 (22 skills). All three companion packs are live (ux, growth, harness) with 903 validator tests passing.
- Matilha co-exists with and is enriched by `superpowers:*` skills. Superpowers is the creative-work engine; matilha is the orchestrator that knows about the project's methodology context and installed companion packs.
- `companions-contract.md` already declares `matilha-pack` as the keyword signal for companion packs and documents graceful fallback (core works without packs; packs work without core; failures never cascade).
- The `matilha-compose` skill is a new core skill within the `matilha-skills` registry — same plugin as `matilha-plan`, `matilha-design`, etc.

## 3. Design principles

- **Composition over competition.** Matilha does not replace superpowers. It routes and enriches. When superpowers is absent, matilha is self-sufficient (per companions-contract rule #1).
- **Zero hardcoded pack state.** The ambient skill list (injected by the harness into each turn) is the single source of truth for which packs are installed. No parallel registry, no prefix whitelist inside skill bodies, no filesystem scan as primary path.
- **Plugin namespace as pack signal.** Claude Code exposes installed-plugin skills with a `plugin-name:skill-name` format. The pattern `matilha-*-pack` in the namespace is the authoritative detection signal. Pack added → shows up next turn. Pack removed → disappears next turn. No ceremony.
- **Dynamic detection within the convention; ceremony only when the convention changes.** New skill inside an existing pack: zero friction (shows up via namespace). New pack with a fresh domain: pack author names plugin `matilha-<domain>-pack`, no edit to compose needed.
- **Auditable prose over code.** Detection + classification + injection are prose instructions to the LLM running compose. No Bash dependency, no filesystem assumption. Cross-platform by default where the harness exposes an ambient skill list.
- **Description gate, not code gate.** The activation competition against `superpowers:brainstorming` is won (or lost) in the skill description, not in the body. Body only runs after the description wins activation.

## 4. Target deliverables

### 4.1 New skill: `matilha-compose`

Path: `matilha-skills/skills/matilha-compose/SKILL.md`.

Frontmatter:

```yaml
---
name: matilha-compose
description: You MUST use this skill before invoking superpowers:brainstorming when
  the user prompt signals creative work (building, designing, planning, adding,
  modifying a system/feature/product) AND the current project is a matilha project
  (docs/matilha/ exists, project-status.md exists, OR any skill with plugin
  namespace matching matilha-*-pack is visible in your skill list). Detects
  installed companion packs via plugin-namespace inspection, classifies intent,
  injects pack-aware preamble, then dispatches to brainstorming (or directly to
  matilha-plan/matilha-design for explicit planning/design prompts). If neither
  activation condition holds, defer to superpowers:brainstorming directly.
category: matilha
version: "1.0.0"
optional_companions: ["superpowers:brainstorming", "matilha-plan", "matilha-design"]
---
```

Body — 13 required sections:

1. **When this fires** — activation-gate detail with positive and negative prompt examples.
2. **Preconditions** — ambient skill list available (primary); matilha project context (documented via any one of three signals).
3. **Execution Workflow (5 steps)**:
   - Step 1 — Pack detection. Inspect ambient skill list; identify plugin namespaces matching `matilha-*-pack:*`; group skills by pack; note each pack's name + shipped skills + descriptions. No hardcoded prefix list.
   - Step 2 — Intent classification. Prose semantic: for each installed pack, decide (yes/no/partial) whether the user prompt touches its domain. Use pack skill descriptions (visible in the ambient list) to inform the decision. Err inclusive.
   - Step 3 — Dispatch decision: planning-explicit → matilha-plan; design-explicit → matilha-design; generic creative work → superpowers:brainstorming; ambiguous → default to brainstorming.
   - Step 4 — Build preamble (template below).
   - Step 5 — Invoke target skill via Skill tool with preamble as first message content.
4. **Rules: Do** — always include guidance line; include skill names; prefer false-positive pack inclusion.
5. **Rules: Don't** — no hardcoded pack names or prefixes in detection logic; no firing in non-matilha projects; no duplication of brainstorming's clarifying flow when superpowers present; no injection of full skill bodies (descriptions only).
6. **Expected Behavior** — downstream skill runs enriched; pack skills surface by name during exploration; output includes pack-sourced recommendations.
7. **Quality Gates** — preamble contains ≥1 pack section if any pack classified true; guidance line present; downstream skill invoked via Skill tool (not narrated).
8. **Pack awareness** (compose-specific section) — auditable prose describing detection-via-namespace logic. Validator target.
9. **Fallback semantics** — Cases B/C/D per spec §6.
10. **Output Artifacts** — none (dispatcher). Optionally a log at `docs/matilha/compose-log.md`.
11. **Example Constraint Language** — must/should/may triples.
12. **Troubleshooting** — brainstorming still wins activation, preamble too large, pack detected but no skills surface, activation in non-matilha project.
13. **CLI shortcut (optional)** — note: no CLI equivalent this wave; CLI already has filesystem access and determinism by construction.

Canonical preamble template (Step 4 of the workflow):

```text
Matilha companion packs detected and relevant to this brainstorm:

**<pack-name>** (<one-line pack purpose>) — surface these when user explores
<domain keyword list>:
- `<skill-name>` — <one-line skill purpose from description>
- `<skill-name>` — <...>
  [up to ~8 most relevant per pack]

[repeat for each pack classified true]

**Guidance for the receiving skill (brainstorming/plan/design)**:
During exploration, when the user's answer touches any of the domains above,
reference the relevant skill by name and frame a targeted clarifying question
drawing on its content. Pack skills are available via the Skill tool — invoke
them when the user signals readiness for deep domain guidance. Do not list all
skills upfront; weave them in as topics surface naturally.
```

Body length target: 180–220 lines (within the 150–300 guide from `skill-authoring-guide.md`).

### 4.2 Refactor: `matilha-plan` body

Path: `matilha-skills/skills/matilha-plan/SKILL.md`.

Changes:

- Execution Workflow step 2 expands from the current one-liner ("If `superpowers:brainstorming` available, invoke via Skill tool for the initial clarifying-questions phase") to a five-substep block describing pack-aware preamble injection (detection via plugin-namespace inspection; semantic intent classification; preamble per the canonical template documented in `matilha-compose/SKILL.md`; invocation via Skill tool with preamble as first message content; inline clarifying flow fallback when superpowers absent).
- Companion Integration section replaces the passive "if ux-* skills are available, invoke…" prose with an explicit cross-reference to `matilha-compose` as the canonical template source, and a note that pack-aware preamble injection happens in step 2 of the Execution Workflow.
- Body gains ~15–20 lines. Final body remains within the 150–300 guide.

### 4.3 Refactor: `matilha-design` body

Path: `matilha-skills/skills/matilha-design/SKILL.md`.

Changes:

- Execution Workflow restructured from current 4 steps to 4 steps with explicit pack detection and intent classification as step 1 and step 2 (via the same logic as matilha-plan's step 2 substeps). Step 3 branches: packs classified true → invoke superpowers:brainstorming with preamble OR invoke the most relevant pack skill directly if the intent is narrow. Step 4 is the existing core-heuristics fallback.
- Companion Integration section updated with the same cross-reference pattern as matilha-plan.
- Body gains ~15–20 lines.

### 4.4 Validator extensions

Path: `matilha/tests/registry/content-validation.test.ts`.

Three new describe blocks:

**`matilha-compose (Wave 5d — composition layer)`** — ~10–12 tests:

- `skills/matilha-compose/SKILL.md` exists.
- Frontmatter valid (name, description, category=matilha, version, optional_companions).
- Description contains activation gate: imperative marker ("MUST use") AND matilha-project condition (literal "matilha project" or "docs/matilha/" or "project-status.md" or "plugin namespace matching matilha-*-pack").
- `optional_companions` includes `superpowers:brainstorming`.
- Body contains all 13 required sections.
- Body references `matilha-*-pack` namespace pattern in detection logic (positive).
- Body does NOT hardcode pack prefixes (`harness-*`, `ux-*`, `cog-*`, `growth-*`) as detection instructions (negative; allowed only inside example / illustration / "e.g." contexts).
- Body documents Case B (superpowers absent, packs present) fallback.
- Body documents Case C (packs absent, superpowers present) silent pass-through.
- Body documents Case D (both absent) fallback.
- Body contains preamble template with per-pack section + skill list + guidance line.

**`matilha-plan body (Wave 5d — pack-aware refactor)`** — 3 tests:

- Execution Workflow step 2 references pack-aware preamble injection.
- Body cross-references `matilha-compose` as canonical template source.
- Body contains fallback: inline clarifying flow when superpowers absent.

**`matilha-design body (Wave 5d — pack-aware refactor)`** — 3 tests:

- Execution Workflow references pack detection + intent classification.
- Body cross-references `matilha-compose`.
- Body contains fallback to core heuristics when no packs detected.

Expected test count delta: **+16 to +18**. Post-Wave 5d baseline target: **~920 tests**.

Critical architectural guards (these are the reason the validator exists for this wave):

- **Description strength guard.** If someone weakens `matilha-compose`'s description and removes the "MUST use" imperative or the matilha-project condition, tests fail and activation competition regresses to Wave-5c behavior.
- **No-hardcoded-prefix guard.** If someone reintroduces a parallel registry of pack prefixes inside detection logic, tests fail. The check permits prefixes inside example sections (identified by proximity to keywords like `e.g.`, `example`, `for instance`).
- **Cross-reference guard.** `matilha-plan` and `matilha-design` must reference `matilha-compose` — so a future edit to the canonical template can be propagated by grep.
- **Fallback presence guard.** Cases B/C/D all documented — defends the "matilha works standalone" invariant.

### 4.5 Smoke results + CHANGELOG + memory

- `matilha-skills/docs/matilha/smoke-results/wave-5d-smoke.md` — one header per smoke test with prompt, trace, output analysis, pass/fail/soft-pass rationale.
- `matilha-skills/CHANGELOG.md` — Wave 5d entry describing new compose skill + refactors.
- `matilha/CHANGELOG.md` — validator extensions entry.
- `memory/matilha-wave-5d-shipped.md` + `memory/MEMORY.md` pointer line.

## 5. Architecture

### 5.1 Flow

```
User prompt (creative work in matilha project)
         ↓
  Harness evaluates skill descriptions
  Competing skills: matilha-compose vs superpowers:brainstorming vs others
         ↓
  matilha-compose wins (description gate: creative-work AND matilha-context)
         ↓
  Step 1 — Pack detection via plugin-namespace inspection
         ↓
  Step 2 — Intent classification (semantic, per pack)
         ↓
  Step 3 — Dispatch decision
         ↓
  Step 4 — Preamble built (hybrid format with guidance line)
         ↓
  Step 5 — Skill tool invocation of target skill with preamble
         ↓
  Target skill (superpowers:brainstorming | matilha-plan | matilha-design)
  runs enriched; references pack skills during exploration
         ↓
  Output — user gets pack-aware guidance; can invoke pack skills directly
```

### 5.2 Responsibilities

| Skill | Responsibility | Primary trigger |
|---|---|---|
| `matilha-compose` (new) | Gateway. Detect packs, classify intent, inject preamble, dispatch. | Creative-work prompts in matilha project context. |
| `matilha-plan` (refactored) | Phase 20–30 spec + plan authoring. Pack-aware when delegating to brainstorming. | Explicit planning prompts. |
| `matilha-design` (refactored) | Cross-phase UX/UI guidance. Pack-aware when delegating or invoking pack skills directly. | Design prompts. |
| `matilha-scout` (unchanged) | Phase 10 research subagent dispatch. Different composition pattern — out of scope. | Phase 10 research. |
| `matilha-howl` (unchanged) | Phase 0 read-only state reporter. No composition need. | Status queries. |

### 5.3 Detection — plugin-namespace inspection

Claude Code exposes installed-plugin skills with the format `plugin-name:skill-name` in the ambient skill list (visible to the LLM in every turn's system prompt). Examples: `superpowers:brainstorming`, `pr-review-toolkit:code-reviewer`, `hookify:help`.

`matilha-compose` detects installed companion packs by scanning the ambient list for skills whose namespace matches the literal pattern `matilha-*-pack` (e.g., `matilha-harness-pack:harness-architecture`, `matilha-ux-pack:ux-reservatorio-boa-vontade`).

Self-healing properties:

- Pack uninstalled → namespace disappears → skills no longer detected → no preamble injection for that pack. No stale state.
- Pack installed → namespace appears on next turn → skills detected automatically. No edit required.
- New skills added inside an existing pack → appear under the existing namespace → picked up automatically.
- New pack with fresh domain → author names plugin `matilha-<domain>-pack` → detected automatically. No edit to `matilha-compose` required.

Edge cases:

- Local dev mode (skills in `.claude/skills/` without plugin wrapper): may lack namespace. Detection degrades; secondary instruction in the compose body permits semantic inspection of skill content/domain as fallback. Not a primary concern for shipped usage.
- Non-Claude-Code harnesses that expose skills differently: the detection instructions degrade gracefully (compose proceeds without detected packs → Case C pass-through). Claude Code is the primary target.

### 5.4 Classification — prose semantic

The LLM executing `matilha-compose` classifies user intent against each detected pack's domain via natural-language inspection. Instructions in the compose body:

- For each detected pack, read the descriptions of its shipped skills.
- Decide per pack: does the user prompt touch this pack's domain? (yes / no / partial).
- Err inclusive — a marginally relevant pack is better included than omitted.
- When multiple packs classify true, include all.

No keyword maps, no subagent dispatch. The LLM already does semantic parsing; compose just directs it.

### 5.5 Preamble injection — hybrid format with guidance

Canonical template lives in `matilha-compose/SKILL.md`. `matilha-plan` and `matilha-design` reference it rather than duplicating. The template produces preambles in the 30–40 line range (per-pack mini-synthesis + up to ~8 skills per pack + guidance line). Short enough to not crowd context; rich enough for the receiving skill to weave packs into exploration naturally.

The guidance line is critical — without it, the receiving skill treats the preamble as passive reference material instead of active exploration prompts.

### 5.6 Dispatch decision

Compose routes based on intent signals in the user prompt:

- Planning-explicit ("plan this", "write a spec for", "lay out the phases") → `matilha-plan`.
- Design-explicit ("how should this look", "which UI", "what component") → `matilha-design`.
- General creative work ("I'm building X", "exploring Y", "thinking about Z") → `superpowers:brainstorming`.
- Ambiguous → default to `superpowers:brainstorming` (it explores intent and may surface planning/design needs for a follow-up).

Compose is a router + enricher — it does not replace the destination skills.

## 6. Fallback semantics

|  | superpowers present | superpowers absent |
|---|---|---|
| **≥1 pack installed** | **Case A — happy path**. Compose detects packs, classifies intent, builds preamble, invokes brainstorming with preamble. | **Case B — matilha standalone with packs**. Compose detects packs, builds preamble, runs matilha-internal clarifying flow inline (documented in compose body §9) using the preamble as its own guide. After 3–5 clarifying questions, either invokes `matilha-plan`, invokes `matilha-design`, or outputs inline guidance. |
| **0 packs installed** | **Case C — silent pass-through**. Compose detects zero packs, injects nothing, invokes brainstorming untouched. Output indistinguishable from brainstorming-without-compose. | **Case D — baseline**. Compose runs matilha-internal clarifying flow inline using only core heuristics (Krug, Weinschenk, methodology core). Equivalent to pre-Wave-5d behavior. |

Invariants:

- Never crash on dependency absence.
- Empty preamble never injected (if pack list is empty or classification yields no matches, skip preamble entirely).
- Compose gracefully no-ops if the activation gate was imperfect (body first checks matilha-project signals; if all fail, immediately invokes superpowers:brainstorming without preamble and exits).

Case-C policy decision (explicit): when zero packs are installed, compose is a silent pass-through — no "no packs detected" message, no install suggestion. Install recommendations are a marketplace / announcement concern, not a skill behavior.

## 7. Validation strategy

Static validator (§4.4) does not prove runtime composition. Manual smoke tests cover that axis.

### 7.1 Smoke Test 1 — regression

Prompt (identical to the Wave 5c smoke that failed): **"Estou construindo MVP de 4 semanas que precisa rodar autonomamente. Como estruturo os agents?"**

Expected (pass gate): `matilha-compose` wins activation, detects `matilha-harness-pack`, classifies intent as harness-relevant, injects preamble with harness-architecture / harness-context-rot-budget / harness-workflow-vs-agent-decision (and similar), dispatches to `superpowers:brainstorming`. Brainstorming surfaces these skills during clarifying questions.

### 7.2 Smoke Test 2 — cross-pack

Prompt: **"Quero desenhar o signup flow desse SaaS — precisa ter baixa fricção (UX) mas também maximizar activation rate (growth)."**

Expected: compose detects `matilha-ux-pack` + `matilha-growth-pack`; preamble contains two pack sections; brainstorming references skills from both packs.

### 7.3 Smoke Test 3 — pass-through (Case C)

Prompt: **"Quero planejar uma nova feature de exportação CSV. Por onde começo?"** — in a Claude Code instance with `matilha-skills` installed but zero companion packs.

Expected: compose activates, detects zero packs, invokes brainstorming without preamble. No "no packs detected" noise.

### 7.4 Smoke Test 4 — non-matilha project

Prompt: **"Quero adicionar autenticação OAuth nesse app."** — in a non-matilha directory (no `docs/matilha/`, no `project-status.md`).

Expected: compose does not fire (description gate fails on matilha-project condition); `superpowers:brainstorming` fires normally. Compose does not appear in skill-invocation trace.

### 7.5 Smoke Test 5 — matilha standalone (Case B)

Conceptual test — superpowers uninstalled, matilha-skills + matilha-harness-pack installed. Same prompt as Test 1.

Expected: compose fires; detects packs; detects superpowers absent; runs matilha-internal clarifying flow inline using the preamble as its guide; produces coherent output referencing pack skills.

### 7.6 Blocking policy

- Tests 1, 2, 3, 4 — **blocking** for ship. Failure → iterate and re-run.
- Test 5 — **non-blocking**. If hard to reproduce (requires uninstalling superpowers), documented as "deferred — verified by design review".

Ship gate: Tests 1–4 pass + validator tests green (~920 total) + Test 5 design-verified.

## 8. Exit criteria

- `matilha-skills/skills/matilha-compose/SKILL.md` exists, parses, and passes all new validator checks.
- `matilha-skills/skills/matilha-plan/SKILL.md` and `matilha-skills/skills/matilha-design/SKILL.md` contain the refactor changes and pass new validator checks.
- `matilha` CLI test suite reports ~920 passing tests, zero regressions on the 903 pre-Wave-5d tests.
- `matilha-skills/docs/matilha/smoke-results/wave-5d-smoke.md` exists and documents Tests 1–5 with pass/fail/soft-pass rationale; Tests 1–4 show pass.
- CHANGELOG entries in both repos.
- Memory updates: `matilha-wave-5d-shipped.md` + pointer in `MEMORY.md`.
- `matilha-skills` tagged `wave-5d-composition` and pushed. `matilha` CLI pushed (no tag per current convention).

## 9. Out of scope

- Modifying `superpowers:brainstorming` (third-party, read-only).
- Refactoring `matilha-scout` (different composition pattern; no smoke gap).
- Refactoring `matilha-howl` (read-only state reporter; pack listing does not close the smoke gap).
- Any hardcoded pack list in skill bodies (explicitly prohibited by validator check).
- CLI subcommand `matilha compose` (CLI already deterministic by construction).
- Auto-registration flow for novel pack prefixes.
- Runtime tests simulating activation competition (covered by manual smoke).
- Retroactive marketplace.json schema fix for `matilha-ux-pack` / `matilha-growth-pack` (separate cleanup, documented in `memory/matilha-wave-5c-shipped.md` TODO section).

## 10. Open questions (carry into implementation plan)

None remaining that block planning. All major design decisions are locked. Implementation-detail questions that may surface during SP execution:

- Exact wording of the `matilha-compose` description to maximize activation-gate win probability (tune via Smoke Test 1 iteration).
- Exact implementation of the no-hardcoded-prefix validator check — strict grep vs keyword-windowed detection (start strict; relax if false positives appear).
- Whether to emit a `docs/matilha/compose-log.md` observability trail (opt-in via Section 10 of compose body; not required for Wave 5d pass).

## 11. Known risks

1. **Description gate does not out-trigger brainstorming in runtime.** Mitigation: Smoke Test 1 validates this directly. If it fails, iterate description wording before ship. Backup plan: add instruction in `matilha-init`'s generated CLAUDE.md telling the harness "before invoking superpowers:brainstorming, check matilha-compose first".
2. **LLM running brainstorming ignores the injected preamble.** Mitigation: Smoke Tests 1 and 2 validate pack-skill surfacing. If output does not reference skills, strengthen the guidance line (more imperative; concrete examples).
3. **Plugin namespace not exposed by all harnesses.** Mitigation: Claude Code is the primary target; documented. Other harnesses fall through to Case C (silent pass-through) or Case D.
4. **No-hardcoded-prefix validator check produces false positives.** Mitigation: first implementation strict; tune with keyword windowing if dev friction emerges.

## 12. Implementation plan preview (SP decomposition)

Four SPs, estimated ~10 hours total. Matches Wave 5a/5b/5c pattern: SP1–SP3 parallel-safe; SP4 sequential after.

- **SP1** — Author `matilha-compose/SKILL.md` (frontmatter + 13 body sections + canonical preamble template + fallback Cases B/C/D). ~2.5h.
- **SP2** — Refactor `matilha-plan/SKILL.md` and `matilha-design/SKILL.md` bodies (Execution Workflow updates + Companion Integration updates + cross-reference to matilha-compose). ~2h.
- **SP3** — Validator extensions in `matilha/tests/registry/content-validation.test.ts` (3 new describe blocks; ~16–18 new tests). ~2.5h.
- **SP4** — Smoke tests 1–4 (Test 5 optional) + smoke results doc + CHANGELOG entries + memory updates + merge/tag/push both repos. ~3h.

Detailed SP tasks, file changes, and gates to be produced by `superpowers:writing-plans` following this spec.
