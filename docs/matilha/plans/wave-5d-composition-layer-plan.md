# Wave 5d — Composition Layer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Introduce `matilha-compose` as a gateway skill plus pack-aware body refactors on `matilha-plan` and `matilha-design`, backed by validator extensions, so Matilha wins activation on creative-work prompts in matilha projects and enriches brainstorming with companion-pack context without competing against `superpowers:brainstorming`.

**Architecture:** New skill `matilha-compose` detects installed companion packs by scanning the ambient skill list for plugin-namespace pattern `matilha-*-pack`, classifies user intent semantically, injects a pack-aware preamble only when the terminal destination is `superpowers:brainstorming`, and routes to `matilha-plan` or `matilha-design` (without preamble emission — those skills run their own pack-aware logic). Existing `matilha-plan` and `matilha-design` bodies gain the same pack-detection / preamble-injection pattern for when they delegate directly to brainstorming. Validator tests protect description strength, no-hardcoded-prefix, cross-reference, and fallback presence invariants.

**Tech Stack:** Skill definitions are Markdown with YAML frontmatter. Validator is TypeScript + Vitest + Zod in the `matilha` CLI repo. Detection logic is prose-only (LLM-interpreted); no Bash, no filesystem dependency.

**Spec:** `matilha-skills/docs/matilha/specs/wave-5d-composition-layer-spec.md`

---

## Repos touched

- **`matilha-skills`** at `/Users/danilodesousa/Documents/Projetos/matilha-skills` — creates `matilha-compose` skill, refactors `matilha-plan` and `matilha-design` bodies, adds smoke results doc + CHANGELOG.
- **`matilha`** (CLI) at `/Users/danilodesousa/Documents/Projetos/matilha` — extends `tests/registry/content-validation.test.ts` with Wave-5d describe blocks.

## File structure

### matilha-skills

Files to create:
- `skills/matilha-compose/SKILL.md` — new gateway skill (~180–220 body lines).
- `docs/matilha/smoke-results/wave-5d-smoke.md` — smoke test results.

Files to modify:
- `skills/matilha-plan/SKILL.md` — expand Execution Workflow step 2 + update Companion Integration.
- `skills/matilha-design/SKILL.md` — restructure Execution Workflow + update Companion Integration.
- `index.json` — register `matilha-compose` entry.
- `CHANGELOG.md` — Wave 5d entry.

### matilha (CLI)

Files to modify:
- `tests/registry/content-validation.test.ts` — append three new describe blocks (~16–18 tests).
- `CHANGELOG.md` — Wave 5d validator entry.

## Invariant decisions locked from spec

1. **13-section body for `matilha-compose`**: 12 canonical sections (enforced by existing validator line 50-74) + 2 extra compose-specific sections (`Pack awareness`, `Fallback semantics`). The spec § 4.1 listed 13 but omitted `Companion Integration` — the plan adds it back to pass the existing 12-section validator. Final body section count: **14**.
2. **Description starts with "You MUST"** — new form deviating from the existing "Use when" / "When" linter check. See SP3 Task 3.4 for how the validator accommodates this.
3. **Compose's `category` = `matilha`** — consistent with other core skills (enforced by existing Zod enum).
4. **Preamble emitted only when terminal destination is `superpowers:brainstorming` directly**. When routing to matilha-plan or matilha-design, compose does NOT emit a preamble — those skills run their own pack-aware logic per SP2.

---

## SP1 — Author `matilha-compose/SKILL.md`

**Estimated effort:** 2.5h. **Parallel-safe** with SP2, SP3.

### Task 1.1: Create directory + empty SKILL.md + register in index.json

**Files:**
- Create: `skills/matilha-compose/SKILL.md`
- Modify: `index.json`

- [ ] **Step 1: Create skill directory**

Run: `mkdir -p /Users/danilodesousa/Documents/Projetos/matilha-skills/skills/matilha-compose`
Expected: directory created.

- [ ] **Step 2: Write initial frontmatter-only file**

File: `skills/matilha-compose/SKILL.md`

```markdown
---
name: matilha-compose
description: "You MUST use this skill before invoking superpowers:brainstorming when the user prompt signals creative work (building, designing, planning, adding, modifying a system/feature/product) AND the current project is a matilha project (docs/matilha/ exists, project-status.md exists, OR any skill with plugin namespace matching matilha-*-pack is visible in your skill list). Detects installed companion packs via plugin-namespace inspection, classifies intent, injects pack-aware preamble, then dispatches to brainstorming (or directly to matilha-plan/matilha-design for explicit planning/design prompts). If neither activation condition holds, defer to superpowers:brainstorming directly."
category: matilha
version: "1.0.0"
optional_companions: ["superpowers:brainstorming", "matilha-plan", "matilha-design"]
---

```

Note: description is wrapped in double quotes because it contains `:` characters which would otherwise break YAML unquoted-scalar parsing (known gotcha per project-handoff §7).

- [ ] **Step 3: Register in index.json**

File: `index.json`, add entry after `matilha-design`:

```json
  "matilha-compose": {
    "slug": "matilha-compose",
    "name": "Compose — Companion-pack-aware gateway",
    "skillPath": "skills/matilha-compose/SKILL.md"
  }
```

Preserve trailing comma discipline; `matilha-design` entry needs a trailing comma added since `matilha-compose` is now appended.

- [ ] **Step 4: Verify index.json parses**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha-skills && node -e "JSON.parse(require('fs').readFileSync('index.json', 'utf-8'))" && echo "OK"`
Expected: `OK`

- [ ] **Step 5: Commit**

```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills
git add skills/matilha-compose/SKILL.md index.json
git commit -m "feat(wave-5d): scaffold matilha-compose skill with frontmatter

Registers new gateway skill in the matilha-skills registry. Body sections to follow in subsequent commits."
```

### Task 1.2: Write body sections 1-4 (When fires / Preconditions / Execution Workflow / Rules: Do)

**Files:**
- Modify: `skills/matilha-compose/SKILL.md`

- [ ] **Step 1: Append sections 1-4 after frontmatter**

Append to `skills/matilha-compose/SKILL.md`:

```markdown
## When this fires

Fires BEFORE `superpowers:brainstorming` when two conditions both hold:

1. **Creative-work intent** — the user prompt signals building, designing, planning, adding, or modifying a system, feature, product, or component. Examples: "Estou construindo MVP…", "How should I design…", "Want to add a new feature for…", "Planning a refactor of…".

2. **Matilha project context** — at least one of these signals is present:
   - `docs/matilha/` directory exists in the current project.
   - `project-status.md` file exists at the project root.
   - At least one skill with plugin namespace matching `matilha-*-pack` (e.g., `matilha-harness-pack:harness-architecture`) is visible in the ambient skill list.

If EITHER condition fails, do NOT fire. Defer to `superpowers:brainstorming` or other appropriate skills directly.

Positive examples:
- "Estou construindo MVP de 4 semanas que precisa rodar autonomamente. Como estruturo os agents?" (matilha project + creative work → fires)
- "Quero desenhar o signup flow desse SaaS — precisa ter baixa fricção e maximizar activation." (matilha project + creative work → fires)

Negative examples:
- "What's the current phase?" (not creative work → defer to matilha-howl)
- "Add OAuth to this non-matilha project." (non-matilha project → defer to brainstorming)

## Preconditions

- Ambient skill list available (primary signal source).
- Matilha project context verifiable via one of the three signals above.

## Execution Workflow

Five steps, executed in order:

**Step 1 — Pack detection.**

Inspect the ambient skill list visible in the current session. Identify skills whose plugin namespace matches the literal pattern `matilha-*-pack` (e.g., `matilha-harness-pack:*`, `matilha-ux-pack:*`, `matilha-growth-pack:*`). Group identified skills by plugin namespace. For each pack, note:

- Plugin name (derived from namespace, e.g., `matilha-harness-pack`).
- Pack-scoped skill names and their descriptions (visible in the ambient list).

Do NOT maintain any hardcoded list of skill prefixes or pack names in this skill body. The ambient skill list is the sole source of truth — packs removed disappear; new packs appear automatically. No edits to this skill are required to pick up new packs, new skills within a pack, or skill removals.

If no skills match the `matilha-*-pack` namespace pattern, proceed to Step 3 with zero packs detected.

**Step 2 — Intent classification (prose semantic).**

For each detected pack, decide whether the user prompt touches its domain. Use the pack's shipped skill descriptions (visible in the ambient list) to inform the decision. Output per pack: `yes` | `no` | `partial`.

Prefer false-positive inclusion — a marginally relevant pack is better included than omitted. When multiple packs classify `yes`, include all.

Do NOT use hardcoded keyword lists. Rely on semantic judgment based on skill descriptions.

**Step 3 — Dispatch decision.**

Choose the terminal destination based on intent signals in the user prompt:

- **Planning-explicit** ("plan this", "write a spec for", "lay out the phases") → `matilha-plan`. **Do NOT emit preamble** — matilha-plan runs its own pack-aware preamble logic when it delegates to brainstorming. Compose's job is routing only.
- **Design-explicit** ("how should this look", "which UI", "what component") → `matilha-design`. **Do NOT emit preamble** — matilha-design runs its own pack-aware logic.
- **General creative work** ("I'm building", "I'm exploring", "thinking about") → `superpowers:brainstorming`. **Emit preamble** — this is the only terminal-brainstorming path.
- **Ambiguous** → default to `superpowers:brainstorming` with preamble emitted.

**Step 4 — Build preamble (only if terminal is brainstorming AND ≥1 pack classified yes).**

Use this canonical template:

\`\`\`text
Matilha companion packs detected and relevant to this brainstorm:

**<pack-name>** (<one-line pack purpose>) — surface these when user explores
<domain keyword list>:
- \`<skill-name>\` — <one-line skill purpose from description>
- \`<skill-name>\` — <...>
  [up to ~8 most relevant per pack]

[repeat for each pack classified yes]

**Guidance for the receiving skill (brainstorming)**:
During exploration, when the user's answer touches any of the domains above,
reference the relevant skill by name and frame a targeted clarifying question
drawing on its content. Pack skills are available via the Skill tool — invoke
them when the user signals readiness for deep domain guidance. Do not list all
skills upfront; weave them in as topics surface naturally.
\`\`\`

Guidelines:
- Cap at ~8 skills per pack to keep preamble compact (~30–40 lines total).
- Always include the final "Guidance" paragraph — without it, brainstorming treats the preamble as passive reference material.
- If zero packs classified yes, skip preamble entirely. Do NOT emit "no packs detected" or similar noise.

**Step 5 — Emit + invoke.**

If preamble built in Step 4: emit it in the current turn output so it enters the conversation context. Then invoke the chosen target skill via the Skill tool.

If no preamble (pass-through or routing to plan/design): invoke target skill via Skill tool directly.

## Rules: Do

- Always include the guidance paragraph in the preamble when emitted.
- Always include skill names (backtick-quoted) in per-pack skill lists.
- Prefer false-positive pack inclusion over missing a pack.
- Cite pack origin ("from matilha-harness-pack") only when ambiguity arises about which pack a skill belongs to.
- Trust the ambient skill list as the sole detection signal.

```

- [ ] **Step 2: Commit**

```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills
git add skills/matilha-compose/SKILL.md
git commit -m "feat(wave-5d): compose body sections 1-4 (when fires, preconditions, workflow, do rules)"
```

### Task 1.3: Write body sections 5-9 (Rules Don't / Expected Behavior / Quality Gates / Companion Integration / Pack awareness)

**Files:**
- Modify: `skills/matilha-compose/SKILL.md`

- [ ] **Step 1: Append sections 5-9**

Append to `skills/matilha-compose/SKILL.md`:

```markdown
## Rules: Don't

- Don't hardcode pack names or skill prefixes (e.g., `harness-*`, `ux-*`, `cog-*`, `growth-*`) in detection logic. Those are examples of what detection may discover, not instructions for detection. Use the `matilha-*-pack` namespace pattern as the sole detection mechanism.
- Don't fire in non-matilha projects (description gate prevents this; body double-checks via Step 1 of "When this fires").
- Don't duplicate brainstorming's clarifying-questions flow when `superpowers:brainstorming` is available — dispatch to it.
- Don't inject full skill bodies into the preamble — descriptions only.
- Don't emit empty preambles ("no packs detected…") — if pack list is empty, just pass through.
- Don't emit a preamble when routing to matilha-plan or matilha-design — those skills handle their own enrichment.

## Expected Behavior

With matilha-compose in the activation loop, creative-work prompts in matilha projects flow:

1. User writes a creative-work prompt.
2. matilha-compose wins activation over `superpowers:brainstorming` (description gate).
3. Compose detects installed packs via ambient skill list inspection.
4. Compose classifies user intent semantically against each pack's domain.
5. Compose routes: either to brainstorming (with preamble) or to matilha-plan / matilha-design (without preamble).
6. The terminal skill runs, surfaces relevant pack skills during exploration, and produces output enriched with pack-sourced recommendations.

The user experiences brainstorming (or planning/design) as more informed about the methodology's installed context, without any explicit invocation of pack skills on their part.

## Quality Gates

- If ≥1 pack classified `yes`, preamble contains at least one per-pack section when terminal is brainstorming.
- Preamble always contains the final Guidance paragraph when emitted.
- Target skill invoked via the Skill tool (not narrated in prose).
- Detection logic contains no hardcoded pack names or skill prefixes.

## Companion Integration

`matilha-compose` is the companion-pack-aware gateway. Its entire purpose is companion integration. Relationships:

- **superpowers:brainstorming** — the most common dispatch target. Compose emits preamble before invoking it.
- **matilha-plan** — dispatch target for planning-explicit prompts. matilha-plan runs its own pack-aware preamble logic downstream.
- **matilha-design** — dispatch target for design-explicit prompts. matilha-design runs its own pack-aware logic.
- **Any skill with plugin namespace `matilha-*-pack`** — detected at runtime via ambient skill list; referenced by name in the emitted preamble; available for direct invocation by the downstream skill via the Skill tool.

The detection pattern here is canonical for Matilha. When `matilha-plan` or `matilha-design` perform their own pack-aware logic, they reference this skill as the template source.

## Pack awareness

This section documents the detection + classification contract in auditable prose. Validator enforces the invariants below.

**Detection contract:**
- Signal: ambient skill list, inspected for plugin namespaces matching the literal pattern `matilha-*-pack`.
- Excluded: hardcoded skill prefixes in any form. Prefixes like `harness-`, `ux-`, `cog-`, `growth-` may appear in this skill body only inside examples or illustrative contexts — never inside detection instructions.
- Self-healing: pack uninstalled → disappears from ambient list → not detected. Pack added → appears → detected. New pack with fresh domain → author names plugin `matilha-<domain>-pack` → detected without editing this skill.

**Classification contract:**
- Method: prose semantic classification by the LLM executing this skill.
- Output: per-pack `yes` | `no` | `partial`.
- Bias: err inclusive.
- Do not use hardcoded keyword maps or subagent dispatch.

**Cross-reference guarantee:**
- `matilha-plan` and `matilha-design` reference this skill's preamble template. When the template evolves, propagate via grep and edit.

```

- [ ] **Step 2: Commit**

```bash
git add skills/matilha-compose/SKILL.md
git commit -m "feat(wave-5d): compose body sections 5-9 (don't, behavior, gates, companion, pack awareness)"
```

### Task 1.4: Write body sections 10-14 (Fallback / Output / Example Constraints / Troubleshooting / CLI shortcut)

**Files:**
- Modify: `skills/matilha-compose/SKILL.md`

- [ ] **Step 1: Append sections 10-14**

Append to `skills/matilha-compose/SKILL.md`:

```markdown
## Fallback semantics

Four cases based on (a) whether `superpowers:brainstorming` is available, (b) whether ≥1 pack is detected:

**Case A — happy path (superpowers present, ≥1 pack)**: Standard flow. Detect → classify → preamble → emit → invoke brainstorming.

**Case B — matilha standalone with packs (superpowers absent, ≥1 pack)**: Run matilha-internal clarifying flow inline. Steps:
1. Treat the built preamble as your own context guide.
2. Ask the user ONE clarifying question at a time. Target pack domain(s) classified most relevant. Example: if harness-pack classified `yes` and user mentioned "building agents", ask: "Are these agents long-running with persistent state, or short-burst task executors?" — referencing domain from harness skills.
3. After 3–5 clarifying questions, summarize intent and propose 2–3 approaches drawing on pack skills.
4. On approach approval, invoke `matilha-plan` (if planning-shaped), `matilha-design` (if design-shaped), or output inline guidance.

**Case C — silent pass-through (superpowers present, zero packs)**: Detect zero packs → skip preamble construction → invoke `superpowers:brainstorming` directly without any preamble. Output is indistinguishable from brainstorming-without-compose. Do NOT emit any "no packs detected" notice.

**Case D — baseline (both absent)**: Run matilha-internal clarifying flow inline using only core heuristics (Krug recognizability, Weinschenk perception rules, methodology core from `methodology/`). Equivalent to pre-Wave-5d behavior.

Invariants across all cases:
- Never crash on absent dependencies.
- Empty preamble never emitted.
- If activation gate let through a non-matilha-project prompt by mistake, body re-checks at Step 1; if all three matilha-project signals fail, immediately invoke `superpowers:brainstorming` without preamble and exit.

## Output Artifacts

None. Compose is a dispatcher, not a writer.

Optional: emit a log line to `docs/matilha/compose-log.md` capturing (timestamp, detected packs, classified intent per pack, routing decision). Opt-in, not required for Wave 5d ship.

## Example Constraint Language

- **Must**: detect packs via `matilha-*-pack` namespace inspection (no other detection mechanism permitted); emit guidance paragraph in every emitted preamble; invoke target skill via Skill tool.
- **Should**: err inclusive in classification; cap per-pack skill list at ~8.
- **May**: emit an optional log entry to `docs/matilha/compose-log.md` for observability.

## Troubleshooting

- **"superpowers:brainstorming still wins activation"** → Check the description begins with "You MUST use this skill before invoking superpowers:brainstorming when…". Verify both conjuncts of the activation gate are clearly worded.
- **"Preamble too large (> 60 lines)"** → Trim per-pack skill lists to top 5 most intent-relevant. Drop packs classified `partial` if preamble remains over budget.
- **"Pack detected but its skills don't surface in downstream exploration"** → Strengthen the guidance paragraph with a concrete example of how to reference a pack skill during clarifying questions.
- **"Compose fires in a non-matilha project"** → Verify none of the three matilha-project signals present (docs/matilha/, project-status.md, matilha-*-pack namespace in skill list). If all absent, treat this as a description-gate false-positive — immediately invoke `superpowers:brainstorming` without preamble and exit.

## CLI shortcut (optional)

No CLI equivalent in Wave 5d. The matilha CLI has filesystem access and is deterministic by construction — composition logic is redundant in CLI mode. A future `matilha compose --detect-packs` subcommand could expose deterministic detection for power-user introspection, but is out of scope for this wave.
```

- [ ] **Step 2: Verify body length is within 180–220 lines**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha-skills && awk 'NR > 1 && /^---$/ {found=1; next} found' skills/matilha-compose/SKILL.md | wc -l`
Expected: value between 180 and 250 (slightly above 220 acceptable given the breadth of fallback semantics).

- [ ] **Step 3: Verify all 12 canonical sections + 2 extras are present**

Run:
```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills
for s in "## When this fires" "## Preconditions" "## Execution Workflow" "## Rules: Do" "## Rules: Don't" "## Expected Behavior" "## Quality Gates" "## Companion Integration" "## Pack awareness" "## Fallback semantics" "## Output Artifacts" "## Example Constraint Language" "## Troubleshooting" "## CLI shortcut (optional)"; do
  if ! grep -qF "$s" skills/matilha-compose/SKILL.md; then
    echo "MISSING: $s"
  fi
done
echo "Check complete."
```

Expected: "Check complete." with no "MISSING" lines above.

- [ ] **Step 4: Commit**

```bash
git add skills/matilha-compose/SKILL.md
git commit -m "feat(wave-5d): compose body sections 10-14 (fallback, output, examples, troubleshooting, cli)

matilha-compose SKILL.md is now complete: 14 body sections covering when-fires activation gate, pack detection via plugin-namespace inspection, prose semantic intent classification, hybrid preamble with guidance line, full fallback matrix (cases A/B/C/D), and troubleshooting for the known activation and enrichment failure modes."
```

---

## SP2 — Refactor `matilha-plan` and `matilha-design` bodies

**Estimated effort:** 2h. **Parallel-safe** with SP1, SP3.

### Task 2.1: Refactor `matilha-plan` Execution Workflow step 2

**Files:**
- Modify: `skills/matilha-plan/SKILL.md:22` (Execution Workflow step 2)

- [ ] **Step 1: Replace the one-line step 2 with the expanded pack-aware block**

In `skills/matilha-plan/SKILL.md`, locate the existing step 2:

```markdown
2. If `superpowers:brainstorming` available, invoke via Skill tool for the initial clarifying-questions phase. Otherwise, run a condensed clarifying inline via chat.
```

Replace with:

```markdown
2. **Pack-aware brainstorming delegation** (see `matilha-compose` for canonical template):
   - (a) If `superpowers:brainstorming` is available, inspect the ambient skill list for skills with plugin namespace matching `matilha-*-pack` (installed companion packs). Group by plugin namespace.
   - (b) Classify user intent semantically against each installed pack's domain using the pack skills' descriptions visible in the ambient list. Err inclusive — prefer injecting a marginally-relevant pack over omitting it.
   - (c) Build preamble using the canonical template documented in `skills/matilha-compose/SKILL.md` Step 4 (per-pack mini-synthesis + skill list + guidance paragraph for the receiving skill).
   - (d) Emit the preamble in the current turn output, then invoke `superpowers:brainstorming` via the Skill tool.
   - (e) Fallback: if `superpowers:brainstorming` is absent OR zero packs are detected, run the condensed clarifying flow inline (existing behavior — ask 3–5 questions drawing on detected pack skills if any, else use methodology-core heuristics).
```

- [ ] **Step 2: Commit**

```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills
git add skills/matilha-plan/SKILL.md
git commit -m "refactor(wave-5d): matilha-plan step 2 becomes pack-aware brainstorming delegation"
```

### Task 2.2: Refactor `matilha-plan` Companion Integration

**Files:**
- Modify: `skills/matilha-plan/SKILL.md:48-54` (Companion Integration section)

- [ ] **Step 1: Replace Companion Integration body**

In `skills/matilha-plan/SKILL.md`, locate the existing Companion Integration section:

```markdown
## Companion Integration

- If **superpowers:brainstorming** is available: invoke via Skill tool for the initial clarifying-questions phase.
- If **superpowers:writing-plans** is available: invoke via Skill tool for the task-by-task plan generation.
- If **ux-*** skills from matilha-ux-pack are available: invoke an ux-design-constraints skill during spec authoring.
- Otherwise: run the clarifying + drafting inline.
```

Replace with:

```markdown
## Companion Integration

Companion-pack awareness is handled via the pack-aware preamble-injection logic in Step 2 of the Execution Workflow. See `skills/matilha-compose/SKILL.md` for the canonical pack detection, intent classification, and preamble template.

- **superpowers:brainstorming** — invoked in step 2 with pack-aware preamble emitted in the current turn output (when installed companion packs classify as intent-relevant).
- **superpowers:writing-plans** — invoked in step 4 for task-by-task plan generation. No preamble needed here (plan-generation is post-spec; pack context is already embedded in the spec).
- **Any skill with plugin namespace `matilha-*-pack`** (e.g., `matilha-harness-pack:*`, `matilha-ux-pack:*`, `matilha-growth-pack:*`) — detected at runtime via ambient skill list, referenced by name in the preamble, available for direct invocation downstream.
- Otherwise: run the clarifying + drafting inline using methodology-core heuristics.
```

- [ ] **Step 2: Commit**

```bash
git add skills/matilha-plan/SKILL.md
git commit -m "refactor(wave-5d): matilha-plan Companion Integration cross-references matilha-compose"
```

### Task 2.3: Refactor `matilha-design` Execution Workflow

**Files:**
- Modify: `skills/matilha-design/SKILL.md:19-23` (Execution Workflow section)

- [ ] **Step 1: Replace the 4-step Execution Workflow with the pack-aware version**

In `skills/matilha-design/SKILL.md`, locate the existing Execution Workflow:

```markdown
## Execution Workflow

1. If `matilha-design-pack:*` skills available, invoke the most relevant via Skill tool.
2. Else if `matilha-ux-pack:ux-*` or `cog-*` skills available, invoke them via Skill tool.
3. Else proceed with core heuristics: simplicity (Krug Fato 1), recognition > recall (Weinschenk), progressive disclosure, consistent navigation, 5-rule error format.
4. Emit design guidance linked to the user's current task.
```

Replace with:

```markdown
## Execution Workflow

1. **Pack detection**: Inspect the ambient skill list for skills with plugin namespace matching `matilha-*-pack` (e.g., `matilha-ux-pack:*`, `matilha-growth-pack:*`, `matilha-design-pack:*` if installed). Group by plugin namespace. See `skills/matilha-compose/SKILL.md` for the canonical detection logic.

2. **Intent classification**: Does the user's design question touch cognitive load, error presentation, forms, accessibility, visual perception, growth-relevant moments (signup, paywall, activation), or broader design-system concerns? Use pack skill descriptions to inform the decision. Classify per pack: yes / no / partial.

3. **Route based on intent**:
   - **Narrow intent** (e.g., "which form component?", "what error format?"): invoke the single most relevant pack skill directly via the Skill tool. No preamble needed.
   - **Exploratory intent** (e.g., "how should this flow feel?", "is this UX good?"): if `superpowers:brainstorming` available AND ≥1 pack classified yes, build preamble per `matilha-compose` Step 4 template, emit it, then invoke brainstorming via Skill tool.
   - **No packs installed OR packs irrelevant**: apply core heuristics inline — simplicity (Krug Fato 1), recognition > recall (Weinschenk), progressive disclosure, consistent navigation, 5-rule error format.

4. Emit design guidance linked to the user's current task.
```

- [ ] **Step 2: Commit**

```bash
git add skills/matilha-design/SKILL.md
git commit -m "refactor(wave-5d): matilha-design Execution Workflow becomes pack-aware with intent-based routing"
```

### Task 2.4: Refactor `matilha-design` Companion Integration

**Files:**
- Modify: `skills/matilha-design/SKILL.md:46-49` (Companion Integration section)

- [ ] **Step 1: Replace Companion Integration body**

In `skills/matilha-design/SKILL.md`, locate the existing Companion Integration section:

```markdown
## Companion Integration

THIS skill is the companion-delegation exemplar.
- If **matilha-design-pack:*** is available: invoke via Skill tool for deep design patterns (typography, color, spacing, components).
- If **matilha-ux-pack:ux-*** or **cog-*** skills are available: invoke for cognitive/perception-level guidance (Weinschenk, Krug).
- Otherwise: apply the core heuristics documented below (simplicity, recognition > recall, progressive disclosure, consistency, 5-rule errors).
```

Replace with:

```markdown
## Companion Integration

Companion-pack awareness is handled via the pack detection + intent classification in steps 1–3 of the Execution Workflow. See `skills/matilha-compose/SKILL.md` for the canonical pack detection and preamble template.

- **Any skill with plugin namespace `matilha-*-pack`** (e.g., `matilha-ux-pack:ux-*`, `matilha-ux-pack:cog-*`, `matilha-growth-pack:*`, `matilha-design-pack:*` when installed) — detected at runtime via ambient skill list. Narrow-intent design questions invoke the most relevant pack skill directly; exploratory-intent questions emit a pack-aware preamble to `superpowers:brainstorming`.
- **superpowers:brainstorming** — invoked for exploratory-intent design questions (with pack-aware preamble emitted when ≥1 pack classifies yes).
- Otherwise: apply the core heuristics documented in Step 3 (simplicity, recognition > recall, progressive disclosure, consistency, 5-rule errors).
```

- [ ] **Step 2: Commit**

```bash
git add skills/matilha-design/SKILL.md
git commit -m "refactor(wave-5d): matilha-design Companion Integration cross-references matilha-compose"
```

---

## SP3 — Validator extensions in matilha CLI

**Estimated effort:** 2.5h. **Parallel-safe** with SP1, SP2.

### Task 3.1: Verify baseline test count

**Files:**
- Read: `matilha/tests/registry/content-validation.test.ts`

- [ ] **Step 1: Run existing test suite and capture baseline**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha && npm test 2>&1 | tail -10`
Expected: `Tests  903 passed (903)` (per Wave 5c shipped memory).

Record exact count for final comparison.

### Task 3.2: Add matilha-compose frontmatter + description tests

**Files:**
- Modify: `matilha/tests/registry/content-validation.test.ts`

- [ ] **Step 1: Append describe block at end of file**

Append to `matilha/tests/registry/content-validation.test.ts`:

```typescript
// Wave 5d additions — composition layer validation

describe.skipIf(!skillsRepoExists)("matilha-compose skill (Wave 5d)", () => {
  const composePath = resolve(SKILLS_REPO, "skills/matilha-compose/SKILL.md");
  const composeExists = existsSync(composePath);

  it("skills/matilha-compose/SKILL.md exists", () => {
    expect(composeExists).toBe(true);
  });

  it("frontmatter validates against skillFrontmatterSchema", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    const match = content.match(/^---\n([\s\S]*?)\n---/);
    expect(match).not.toBeNull();
    const fm = parseYaml(match![1]!);
    const result = skillFrontmatterSchema.safeParse(fm);
    if (!result.success) {
      const issues = result.error.issues.map((i) => `${i.path.join(".")}: ${i.message}`).join("; ");
      throw new Error(`matilha-compose frontmatter invalid: ${issues}`);
    }
  });

  it("description contains activation gate: MUST + matilha-project condition", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    const match = content.match(/^---\n([\s\S]*?)\n---/);
    const fm = parseYaml(match![1]!) as { description: string };

    // Must-clause present (imperative marker)
    expect(fm.description, "description missing 'MUST use' imperative").toMatch(/MUST use/i);

    // Matilha-project condition present (any of three signals)
    const hasMatilhaSignal =
      /matilha project/i.test(fm.description) ||
      /docs\/matilha\//i.test(fm.description) ||
      /project-status\.md/i.test(fm.description) ||
      /matilha-\*-pack/i.test(fm.description);
    expect(hasMatilhaSignal, "description missing matilha-project condition").toBe(true);
  });

  it("optional_companions includes superpowers:brainstorming", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    const match = content.match(/^---\n([\s\S]*?)\n---/);
    const fm = parseYaml(match![1]!) as { optional_companions?: string[] };
    expect(fm.optional_companions).toContain("superpowers:brainstorming");
  });
});
```

- [ ] **Step 2: Run new tests**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha && npm test 2>&1 | grep -E "(matilha-compose|passed|failed)" | tail -10`
Expected: all 4 new compose-specific tests pass (existence, frontmatter schema, description gate, optional_companions).

- [ ] **Step 3: Commit**

```bash
cd /Users/danilodesousa/Documents/Projetos/matilha
git add tests/registry/content-validation.test.ts
git commit -m "test(wave-5d): add matilha-compose frontmatter + description validation"
```

### Task 3.3: Add matilha-compose body structure tests

**Files:**
- Modify: `matilha/tests/registry/content-validation.test.ts`

- [ ] **Step 1: Append body structure describe block**

Append after the previous describe block:

```typescript
describe.skipIf(!skillsRepoExists)("matilha-compose body (Wave 5d)", () => {
  const composePath = resolve(SKILLS_REPO, "skills/matilha-compose/SKILL.md");
  const composeExists = existsSync(composePath);

  it("body contains Pack awareness section", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    expect(content).toContain("## Pack awareness");
  });

  it("body contains Fallback semantics section", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    expect(content).toContain("## Fallback semantics");
  });

  it("body references matilha-*-pack namespace pattern as detection signal", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    expect(content).toMatch(/matilha-\*-pack/);
  });

  it("body does NOT hardcode pack-specific prefixes in detection instructions", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");

    // Scan lines containing hardcoded prefix-like patterns in detection contexts
    const lines = content.split("\n");
    const violations: string[] = [];
    const prefixPatterns = [/\bharness-\*/, /\bux-\*/, /\bcog-\*/, /\bgrowth-\*/, /\bsecurity-\*/, /\bdesign-\*/];
    const detectionKeywords = /\b(detect|inspect|match|look for|check for|filter for|scan for)\b/i;
    const exampleMarkers = /\b(e\.g\.|example|for instance|such as|like|illustration|illustrative)\b/i;

    for (const line of lines) {
      const hasPrefix = prefixPatterns.some((rx) => rx.test(line));
      if (!hasPrefix) continue;
      if (detectionKeywords.test(line) && !exampleMarkers.test(line)) {
        violations.push(line.trim());
      }
    }

    expect(violations, `hardcoded prefix in detection context: ${violations.join(" | ")}`).toHaveLength(0);
  });

  it("documents Case B (superpowers absent, packs present) fallback", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    expect(content).toMatch(/Case B/);
    expect(content).toMatch(/superpowers absent/i);
  });

  it("documents Case C (silent pass-through when zero packs)", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    expect(content).toMatch(/Case C/);
    expect(content).toMatch(/pass-through|pass through/i);
  });

  it("documents Case D (both absent) fallback", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    expect(content).toMatch(/Case D/);
  });

  it("preamble template contains guidance paragraph marker", () => {
    if (!composeExists) return;
    const content = readFileSync(composePath, "utf-8");
    expect(content).toMatch(/Guidance for the receiving skill/i);
  });
});
```

- [ ] **Step 2: Run new tests**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha && npm test 2>&1 | grep -E "(matilha-compose body|passed|failed)" | tail -15`
Expected: all 8 new body-structure tests pass.

- [ ] **Step 3: Commit**

```bash
git add tests/registry/content-validation.test.ts
git commit -m "test(wave-5d): add matilha-compose body structure + no-hardcoded-prefix guards"
```

### Task 3.4: Accommodate compose's "You MUST" description in existing linter

**Files:**
- Modify: `matilha/tests/registry/content-validation.test.ts:139-147`

The existing Wave 4a description linter enforces descriptions start with `Use when` or `When`. `matilha-compose` uses `You MUST use this skill…` and will fail this check. Add `You MUST` as an accepted opener.

- [ ] **Step 1: Modify the existing linter regex**

Locate the existing test in `content-validation.test.ts`:

```typescript
describe.skipIf(!skillsRepoExists)("skill description linter (Wave 4a)", () => {
  for (const skillDir of listSkills()) {
    it(`${skillDir}: description starts with "Use when" or "When"`, () => {
      const fm = loadSkillFrontmatter(skillDir) as { description: string };
      const ok = /^Use when |^When /.test(fm.description);
      expect(ok, `${skillDir} description does not start with "Use when" or "When": ${fm.description}`).toBe(true);
    });
  }
});
```

Replace with:

```typescript
describe.skipIf(!skillsRepoExists)("skill description linter (Wave 4a + 5d)", () => {
  for (const skillDir of listSkills()) {
    it(`${skillDir}: description starts with "Use when", "When", or "You MUST"`, () => {
      const fm = loadSkillFrontmatter(skillDir) as { description: string };
      // Wave 5d: "You MUST use" accepted for orchestrator skills (e.g., matilha-compose)
      // where activation gate must out-trigger competing third-party skills with MUST-clauses.
      const ok = /^Use when |^When |^You MUST /.test(fm.description);
      expect(ok, `${skillDir} description does not start with "Use when", "When", or "You MUST": ${fm.description}`).toBe(true);
    });
  }
});
```

- [ ] **Step 2: Run full test suite**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha && npm test 2>&1 | tail -5`
Expected: all tests pass; matilha-compose description-linter test passes because it starts with "You MUST".

- [ ] **Step 3: Commit**

```bash
git add tests/registry/content-validation.test.ts
git commit -m "test(wave-5d): accept 'You MUST' opener in description linter for orchestrator skills"
```

### Task 3.5: Add matilha-plan + matilha-design refactor guards

**Files:**
- Modify: `matilha/tests/registry/content-validation.test.ts`

- [ ] **Step 1: Append two more describe blocks**

Append after the previous describe blocks:

```typescript
describe.skipIf(!skillsRepoExists)("matilha-plan body (Wave 5d refactor)", () => {
  const planPath = resolve(SKILLS_REPO, "skills/matilha-plan/SKILL.md");

  it("Execution Workflow step 2 references pack-aware preamble injection", () => {
    const content = readFileSync(planPath, "utf-8");
    expect(content).toMatch(/pack-aware/i);
    expect(content).toMatch(/preamble/i);
  });

  it("cross-references matilha-compose as canonical template source", () => {
    const content = readFileSync(planPath, "utf-8");
    expect(content).toMatch(/matilha-compose/);
  });

  it("documents fallback: inline clarifying flow when superpowers absent", () => {
    const content = readFileSync(planPath, "utf-8");
    expect(content).toMatch(/superpowers.*absent|absent.*superpowers/i);
  });
});

describe.skipIf(!skillsRepoExists)("matilha-design body (Wave 5d refactor)", () => {
  const designPath = resolve(SKILLS_REPO, "skills/matilha-design/SKILL.md");

  it("Execution Workflow contains pack detection step", () => {
    const content = readFileSync(designPath, "utf-8");
    expect(content).toMatch(/Pack detection/i);
    expect(content).toMatch(/matilha-\*-pack/);
  });

  it("cross-references matilha-compose", () => {
    const content = readFileSync(designPath, "utf-8");
    expect(content).toMatch(/matilha-compose/);
  });

  it("documents fallback: core heuristics when no packs detected", () => {
    const content = readFileSync(designPath, "utf-8");
    expect(content).toMatch(/core heuristics/i);
    // Ensure named canonical heuristics present
    expect(content).toMatch(/Krug|recognition|progressive disclosure/i);
  });
});
```

- [ ] **Step 2: Run full test suite**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha && npm test 2>&1 | tail -5`
Expected: all tests pass (assuming SP2 is already merged; if SP2 is in progress, these tests will fail until SP2 commits land — that's acceptable since SPs are parallel-safe per plan design).

- [ ] **Step 3: Commit**

```bash
git add tests/registry/content-validation.test.ts
git commit -m "test(wave-5d): add matilha-plan + matilha-design refactor guards

Protects the cross-reference invariant (plan/design body must reference matilha-compose), the pack-aware preamble injection language in plan's Execution Workflow, the pack detection step in design's workflow, and the fallback documentation for both skills."
```

### Task 3.6: Verify final test count

**Files:**
- None (diagnostic only)

- [ ] **Step 1: Run full test suite and capture final count**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha && npm test 2>&1 | tail -5`
Expected: `Tests  ~920 passed` (903 baseline + 16–18 new). Zero failures.

- [ ] **Step 2: Record count in SP4 smoke doc preparation**

Capture the exact count for the smoke results doc (SP4 Task 4.1).

---

## SP4 — Smoke + ship

**Estimated effort:** 3h. **Sequential** — requires SP1, SP2, SP3 complete and merged.

### Task 4.1: Prepare smoke test environment

**Files:**
- None (environment setup)

- [ ] **Step 1: Verify all companion packs installed in Claude Code**

Run the slash command in the user's Claude Code instance: `/plugin list`
Expected: output includes `matilha-skills`, `matilha-ux-pack`, `matilha-growth-pack`, `matilha-harness-pack`.

If a pack is missing, install via `/plugin marketplace add danilods/<pack>` followed by `/plugin install <pack>@<pack>`.

- [ ] **Step 2: Verify matilha-skills includes matilha-compose after SP1 merge**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha-skills && git log --oneline -5 | grep -i compose`
Expected: commits from SP1 visible on main.

### Task 4.2: Execute Smoke Test 1 (regression)

**Files:**
- None (smoke test)

- [ ] **Step 1: Open fresh Claude Code session in a matilha project directory**

Ensure `docs/matilha/` exists in the cwd so matilha-project signal is present. Use the matilha-skills repo itself as the matilha project for smoke testing.

- [ ] **Step 2: Enter exact prompt**

Prompt: **"Estou construindo MVP de 4 semanas que precisa rodar autonomamente. Como estruturo os agents?"**

- [ ] **Step 3: Observe and record**

Record:
- First skill invoked (trace via the skill-tool invocation line in output).
- Whether matilha-compose appears in the trace.
- Whether harness-pack skills are referenced by name during the subsequent exploration/clarifying questions.

Pass criteria (blocking): matilha-compose OR superpowers:brainstorming-with-preamble wins activation. Downstream exploration references ≥1 harness-* skill by name.

### Task 4.3: Execute Smoke Test 2 (cross-pack)

**Files:**
- None (smoke test)

- [ ] **Step 1: Fresh session in matilha project directory**

- [ ] **Step 2: Enter exact prompt**

Prompt: **"Quero desenhar o signup flow desse SaaS — precisa ter baixa fricção (UX) mas também maximizar activation rate (growth)."**

- [ ] **Step 3: Observe and record**

Record:
- Skills invoked.
- Whether preamble contains both matilha-ux-pack AND matilha-growth-pack sections.
- Whether ≥1 skill from each pack is referenced during clarifying questions.

Pass criteria (blocking): preamble has 2 pack sections; clarifying questions pull from both domains.

### Task 4.4: Execute Smoke Test 3 (pass-through)

**Files:**
- None (smoke test)

- [ ] **Step 1: Disable companion packs via `/plugin` command**

Before the test: `/plugin disable matilha-ux-pack`, `/plugin disable matilha-growth-pack`, `/plugin disable matilha-harness-pack`.

Keep matilha-skills and superpowers enabled.

- [ ] **Step 2: Fresh session in matilha project directory**

- [ ] **Step 3: Enter exact prompt**

Prompt: **"Quero planejar uma nova feature de exportação CSV. Por onde começo?"**

- [ ] **Step 4: Observe and record**

Record:
- Whether compose fired (may or may not — description gate still matches).
- Whether any "no packs detected" noise appears in the output.
- Whether brainstorming/plan flow proceeds normally.

Pass criteria (blocking): no "no packs detected" or similar noise in user-visible output. Flow is indistinguishable from pre-Wave-5d experience.

- [ ] **Step 5: Re-enable packs after the test**

`/plugin enable matilha-ux-pack`, `/plugin enable matilha-growth-pack`, `/plugin enable matilha-harness-pack`.

### Task 4.5: Execute Smoke Test 4 (non-matilha project)

**Files:**
- None (smoke test)

- [ ] **Step 1: Open Claude Code session in a non-matilha directory**

Use any personal/generic project directory that does NOT have `docs/matilha/` or `project-status.md`.

- [ ] **Step 2: Enter exact prompt**

Prompt: **"Quero adicionar autenticação OAuth nesse app."**

- [ ] **Step 3: Observe and record**

Record:
- Whether matilha-compose appears in skill-invocation trace.
- Which skill handled the prompt.

Pass criteria (blocking): matilha-compose does NOT appear in the trace. superpowers:brainstorming or other non-matilha skill fires normally.

### Task 4.6: Document Smoke Test 5 (Case B — design-verify only)

**Files:**
- None (design review)

- [ ] **Step 1: Review compose body Section 9 (Fallback semantics) for Case B coherence**

Re-read the Case B block in `skills/matilha-compose/SKILL.md`:
- Does it describe a 4-step inline clarifying flow?
- Does it reference preamble as context guide?
- Does it include guidance on invoking matilha-plan / matilha-design / inline output after clarifying?

- [ ] **Step 2: Mark test 5 as "design-verified — non-blocking"**

Record in smoke results doc: "Test 5 (Case B — superpowers absent) — design-verified only; runtime reproduction deferred (requires uninstalling superpowers plugin)."

### Task 4.7: Write smoke results doc

**Files:**
- Create: `matilha-skills/docs/matilha/smoke-results/wave-5d-smoke.md`

- [ ] **Step 1: Create smoke-results directory if missing**

Run: `mkdir -p /Users/danilodesousa/Documents/Projetos/matilha-skills/docs/matilha/smoke-results`

- [ ] **Step 2: Write smoke results doc**

File: `matilha-skills/docs/matilha/smoke-results/wave-5d-smoke.md`

```markdown
---
title: Wave 5d — Composition Layer Smoke Results
date: 2026-04-21
wave: 5d
spec: docs/matilha/specs/wave-5d-composition-layer-spec.md
---

# Wave 5d — Composition Layer Smoke Results

## Environment

- Claude Code instance: (version from `/help`)
- Plugins installed: matilha-skills, matilha-ux-pack@0.1.0, matilha-growth-pack@0.1.0, matilha-harness-pack@0.1.0, superpowers
- matilha CLI tests: <final test count> passing

## Test 1 — Regression (Wave 5c failure re-run)

**Prompt**: "Estou construindo MVP de 4 semanas que precisa rodar autonomamente. Como estruturo os agents?"

**Skill-invocation trace**: <fill in>

**Preamble emitted**: <yes/no + excerpt if yes>

**Pack skills referenced during exploration**: <list>

**Pass/Fail**: <result>

**Notes**: <commentary>

## Test 2 — Cross-pack intent

**Prompt**: "Quero desenhar o signup flow desse SaaS — precisa ter baixa fricção (UX) mas também maximizar activation rate (growth)."

**Skill-invocation trace**: <fill in>

**Preamble pack sections**: <count + names>

**Pack skills referenced during exploration**: <list per pack>

**Pass/Fail**: <result>

**Notes**: <commentary>

## Test 3 — Silent pass-through (Case C)

**Prompt**: "Quero planejar uma nova feature de exportação CSV. Por onde começo?" (with companion packs disabled)

**Skill-invocation trace**: <fill in>

**Noise emitted (e.g., 'no packs detected')**: <yes/no>

**Pass/Fail**: <result>

**Notes**: <commentary>

## Test 4 — Non-matilha project

**Prompt**: "Quero adicionar autenticação OAuth nesse app." (in non-matilha directory)

**Skill-invocation trace**: <fill in>

**matilha-compose appeared in trace**: <yes/no>

**Pass/Fail**: <result>

**Notes**: <commentary>

## Test 5 — Case B (design-verified)

Runtime reproduction deferred (requires uninstalling superpowers plugin).

**Design review of `matilha-compose` Section 9 (Case B)**:
- 4-step inline clarifying flow: <present/absent>
- Preamble as context guide reference: <present/absent>
- Downstream invocation guidance: <present/absent>

**Design-verified**: <pass/fail>

## Aggregate result

- Blocking tests (1, 2, 3, 4): <pass count> / 4
- Non-blocking test (5): <design-verified/skipped>

**Ship gate**: <pass/fail>
```

- [ ] **Step 3: Commit smoke doc**

```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills
git add docs/matilha/smoke-results/wave-5d-smoke.md
git commit -m "docs(wave-5d): smoke test results"
```

### Task 4.8: CHANGELOG entries

**Files:**
- Modify: `matilha-skills/CHANGELOG.md`
- Modify: `matilha/CHANGELOG.md`

- [ ] **Step 1: Add Wave 5d entry to matilha-skills CHANGELOG**

Prepend (after the top header) in `matilha-skills/CHANGELOG.md`:

```markdown
## Wave 5d — Composition Layer (2026-04-21)

### Added
- New skill `matilha-compose` — companion-pack-aware gateway. Detects installed packs via plugin-namespace inspection (`matilha-*-pack`), classifies intent semantically, injects pack-aware preamble into `superpowers:brainstorming` when the terminal destination is brainstorming, and routes to `matilha-plan` / `matilha-design` (without preamble) for explicit planning/design prompts.
- Smoke results doc `docs/matilha/smoke-results/wave-5d-smoke.md`.

### Changed
- `matilha-plan/SKILL.md` — Execution Workflow step 2 expanded to pack-aware brainstorming delegation; Companion Integration cross-references `matilha-compose`.
- `matilha-design/SKILL.md` — Execution Workflow restructured with pack detection + intent classification + intent-based routing; Companion Integration cross-references `matilha-compose`.

### Fixed
- Composition gap surfaced during Wave 5c smoke: `superpowers:brainstorming` intercepting creative-work prompts in matilha projects without companion-pack awareness.
```

- [ ] **Step 2: Add Wave 5d entry to matilha CHANGELOG**

Prepend in `matilha/CHANGELOG.md`:

```markdown
## Wave 5d — Composition Layer Validator (2026-04-21)

### Added
- `tests/registry/content-validation.test.ts` — 3 new describe blocks (~16–18 tests) protecting matilha-compose activation gate, no-hardcoded-prefix invariant, cross-reference invariant (matilha-plan / matilha-design → matilha-compose), and fallback presence (Cases B/C/D).

### Changed
- Description linter now accepts `You MUST` opener (in addition to `Use when` / `When`) for orchestrator skills whose activation gate must out-trigger third-party MUST-clauses.
```

- [ ] **Step 3: Commit both CHANGELOGs**

```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills
git add CHANGELOG.md
git commit -m "docs(wave-5d): CHANGELOG entry for composition layer"

cd /Users/danilodesousa/Documents/Projetos/matilha
git add CHANGELOG.md
git commit -m "docs(wave-5d): CHANGELOG entry for validator extensions"
```

### Task 4.9: Memory updates

**Files:**
- Create: `~/.claude/projects/-Users-danilodesousa-Documents-Projetos-matilha-skills/memory/matilha-wave-5d-shipped.md`
- Modify: `~/.claude/projects/-Users-danilodesousa-Documents-Projetos-matilha-skills/memory/MEMORY.md`

- [ ] **Step 1: Write shipped memory**

File: `~/.claude/projects/-Users-danilodesousa-Documents-Projetos-matilha-skills/memory/matilha-wave-5d-shipped.md`

```markdown
---
name: Matilha Wave 5d — shipped 2026-04-21
description: Composition layer shipped. matilha-compose (new gateway skill) + matilha-plan/matilha-design body refactors + validator extensions. Closes the Wave 5c smoke gap. ~920 tests.
type: project
---
Wave 5d (composition layer) shipped 2026-04-21.

**Tags pushed:**
- `matilha-skills`: `wave-5d-composition` at <commit-hash>
- `matilha` CLI: no tag (pattern continues from Wave 5c; main at <commit-hash>)

**Versions:** matilha-skills unversioned. matilha CLI stays at 0.4.0 (validator changes non-breaking).

**Test baseline post-Wave 5d:** <final count> tests (+<delta> new Wave 5d validation).

**Skills inventory delta:**
- NEW: `matilha-compose` (14-section body — 12 canonical + Pack awareness + Fallback semantics)
- REFACTORED: `matilha-plan` (pack-aware step 2 + compose cross-reference)
- REFACTORED: `matilha-design` (pack detection + intent routing + compose cross-reference)

**Validator delta:**
- 3 new describe blocks: compose frontmatter (4 tests), compose body (8 tests), plan + design refactor guards (6 tests)
- Existing description linter broadened to accept `You MUST` opener

**Smoke results:**
- Test 1 (regression): <pass/fail>
- Test 2 (cross-pack): <pass/fail>
- Test 3 (pass-through): <pass/fail>
- Test 4 (non-matilha): <pass/fail>
- Test 5 (Case B): design-verified (runtime deferred)

**Composition moat validated:** matilha as an orchestration layer over superpowers now functions end-to-end. Packs are detected dynamically via ambient skill list; zero hardcoded pack state; cross-platform-ready; matilha works standalone when superpowers absent.

**Next milestones:**
- Marketplace submission (3 packs + core now form competitive lineup with working composition)
- Wave 3c `/review` runtime (still deferred)
- matilha-software-eng-pack (Caminho C)
```

- [ ] **Step 2: Add pointer in MEMORY.md**

Append to the bullet list in `~/.claude/projects/-Users-danilodesousa-Documents-Projetos-matilha-skills/memory/MEMORY.md`:

```markdown
- [**Matilha Wave 5d shipped**](matilha-wave-5d-shipped.md) — composition layer: matilha-compose gateway + plan/design refactors, ~920 tests
```

Place this line immediately after the Wave 5c shipped entry.

### Task 4.10: Final tag + push

**Files:**
- None (git operations)

- [ ] **Step 1: Run full test suite one last time**

Run: `cd /Users/danilodesousa/Documents/Projetos/matilha && npm test 2>&1 | tail -5`
Expected: all tests pass.

- [ ] **Step 2: Verify both repos clean**

Run:
```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills && git status
cd /Users/danilodesousa/Documents/Projetos/matilha && git status
```
Expected: both `nothing to commit, working tree clean`.

- [ ] **Step 3: Tag matilha-skills**

```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills
git tag wave-5d-composition
git push origin main --tags
```

- [ ] **Step 4: Push matilha CLI**

```bash
cd /Users/danilodesousa/Documents/Projetos/matilha
git push origin main
```

No tag per current convention (matilha CLI last tag is `wave-3b-complete`; validator changes don't warrant a new tag).

- [ ] **Step 5: Verify push**

Run:
```bash
cd /Users/danilodesousa/Documents/Projetos/matilha-skills && git log --oneline -3 && git tag | tail -3
cd /Users/danilodesousa/Documents/Projetos/matilha && git log --oneline -3
```
Expected: `wave-5d-composition` tag visible; both repos match origin main.

---

## Final ship checklist

- [ ] `matilha-skills/skills/matilha-compose/SKILL.md` exists, 14 sections, all validator checks green.
- [ ] `matilha-skills/skills/matilha-plan/SKILL.md` refactored (step 2 + Companion Integration).
- [ ] `matilha-skills/skills/matilha-design/SKILL.md` refactored (Execution Workflow + Companion Integration).
- [ ] `matilha-skills/index.json` includes matilha-compose entry.
- [ ] `matilha/tests/registry/content-validation.test.ts` has 3 new describe blocks.
- [ ] matilha CLI full suite: ~920 passing tests, zero failures.
- [ ] Smoke Tests 1–4 pass per blocking policy; Test 5 design-verified.
- [ ] Smoke results doc at `matilha-skills/docs/matilha/smoke-results/wave-5d-smoke.md` populated with real traces.
- [ ] CHANGELOG entries in both repos.
- [ ] Memory `matilha-wave-5d-shipped.md` written; MEMORY.md pointer added.
- [ ] `matilha-skills` tagged `wave-5d-composition` and pushed.
- [ ] matilha CLI pushed (no tag).
