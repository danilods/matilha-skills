---
name: matilha-compose
description: "You MUST use this skill before any creative work — building, designing, planning, adding, or modifying features, systems, products, components, agents, workflows, or flows — when in a matilha project (docs/matilha/ directory exists, project-status.md file exists, or any matilha-*-pack skill is visible). SUPERSEDES superpowers:brainstorming in matilha projects. Detects installed companion packs via plugin-namespace inspection, injects pack-aware preamble, then dispatches to brainstorming or to matilha-plan/matilha-design."
category: matilha
version: "1.0.0"
optional_companions: ["superpowers:brainstorming", "matilha-plan", "matilha-design"]
---

## When this fires

Fires BEFORE `superpowers:brainstorming` when two conditions both hold:

1. **Creative-work intent** — the user prompt signals building, designing, planning, adding, or modifying a system, feature, product, or component. Examples: "Estou construindo MVP...", "How should I design...", "Want to add a new feature for...", "Planning a refactor of...".

2. **Matilha project context** — at least one of these signals is present:
   - `docs/matilha/` directory exists in the current project.
   - `project-status.md` file exists at the project root.
   - At least one skill with plugin namespace matching `matilha-*-pack` (e.g., `matilha-harness-pack:harness-architecture`) is visible in the ambient skill list.

If EITHER condition fails, do NOT fire. Defer to `superpowers:brainstorming` or other appropriate skills directly.

**Positive examples:**
- "Estou construindo MVP de 4 semanas que precisa rodar autonomamente. Como estruturo os agents?" (matilha project + creative work → fires)
- "Quero desenhar o signup flow desse SaaS — precisa ter baixa fricção e maximizar activation." (matilha project + creative work → fires)

**Negative examples:**
- "What's the current phase?" (not creative work → defer to matilha-howl)
- "Add OAuth to this non-matilha project." (non-matilha project → defer to brainstorming)

## Preconditions

- Ambient skill list available (primary signal source).
- Matilha project context verifiable via one of the three signals above.

## Execution Workflow

Five steps, executed in order:

**Step 1 — Pack detection.**

Inspect the ambient skill list visible in the current session. Identify skills whose plugin namespace matches the literal pattern `matilha-*-pack` (for instance, `matilha-harness-pack:harness-architecture`, `matilha-ux-pack:ux-reservatorio-boa-vontade`, `matilha-growth-pack:growth-aarrr`). Group identified skills by plugin namespace. For each pack, note:

- Plugin name (derived from namespace, e.g., `matilha-harness-pack`).
- Pack-scoped skill names and their descriptions (visible in the ambient list).

Do NOT maintain any hardcoded list of skill prefixes or pack names in this skill body. The ambient skill list is the sole source of truth — packs uninstalled disappear from it; new packs appear automatically. No edits to this skill are required to pick up new packs, new skills within a pack, or skill removals.

If no skills match the `matilha-*-pack` namespace pattern, proceed to Step 3 with zero packs detected.

**Step 2 — Intent classification (prose semantic).**

For each detected pack, decide whether the user prompt touches its domain. Use the pack's shipped skill descriptions (visible in the ambient list) to inform the decision. Output per pack: `yes` | `no` | `partial`.

Prefer false-positive inclusion — a marginally relevant pack is better included than omitted. When multiple packs classify `yes`, include all.

Do NOT use hardcoded keyword maps. Rely on semantic judgment based on skill descriptions.

**Step 3 — Dispatch decision.**

Choose the terminal destination based on intent signals in the user prompt:

- **Planning-explicit** ("plan this", "write a spec for", "lay out the phases") → `matilha-plan`. **Do NOT emit preamble** — matilha-plan runs its own pack-aware preamble logic when it delegates to brainstorming. Compose's job is routing only.
- **Design-explicit** ("how should this look", "which UI", "what component") → `matilha-design`. **Do NOT emit preamble** — matilha-design runs its own pack-aware logic.
- **General creative work** ("I'm building", "I'm exploring", "thinking about") → `superpowers:brainstorming`. **Emit preamble** — this is the only terminal-brainstorming path.
- **Ambiguous** → default to `superpowers:brainstorming` with preamble emitted.

**Step 4 — Build preamble (only if terminal is brainstorming AND ≥1 pack classified yes).**

Use this canonical template:

```text
Matilha companion packs detected and relevant to this brainstorm:

**<pack-name>** (<one-line pack purpose>) — surface these when user explores
<domain keyword list>:
- `<skill-name>` — <one-line skill purpose from description>
- `<skill-name>` — <...>
  [up to ~8 most relevant per pack]

[repeat for each pack classified yes]

**Guidance for the receiving skill (brainstorming)**:
During exploration, when the user's answer touches any of the domains above,
reference the relevant skill by name and frame a targeted clarifying question
drawing on its content. Pack skills are available via the Skill tool — invoke
them when the user signals readiness for deep domain guidance. Do not list all
skills upfront; weave them in as topics surface naturally.
```

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

## Rules: Don't

- Don't hardcode pack names or skill prefixes in detection logic. Prefixes like those used by companion packs may appear in this skill body only inside examples or illustrative contexts — never inside detection instructions. Use the `matilha-*-pack` namespace pattern as the sole detection mechanism.
- Don't fire in non-matilha projects (description gate prevents this; body double-checks via Step 1 of "When this fires").
- Don't duplicate brainstorming's clarifying-questions flow when `superpowers:brainstorming` is available — dispatch to it.
- Don't inject full skill bodies into the preamble — descriptions only.
- Don't emit empty preambles ("no packs detected...") — if pack list is empty, just pass through.
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
- Excluded: hardcoded skill prefixes in any form. Prefixes from companion packs may appear in this skill body only inside examples or illustrative contexts — never inside detection instructions.
- Self-healing: pack uninstalled → disappears from ambient list → not detected. Pack added → appears → detected. New pack with fresh domain → author names plugin `matilha-<domain>-pack` → detected without editing this skill.

**Classification contract:**
- Method: prose semantic classification by the LLM executing this skill.
- Output: per-pack `yes` | `no` | `partial`.
- Bias: err inclusive.
- Do not use hardcoded keyword maps or subagent dispatch.

**Cross-reference guarantee:**
- `matilha-plan` and `matilha-design` reference this skill's preamble template. When the template evolves, propagate via grep and edit.

## Fallback semantics

Four cases based on (a) whether `superpowers:brainstorming` is available, (b) whether ≥1 pack is detected:

**Case A — happy path (superpowers present, ≥1 pack)**: Standard flow. Detect → classify → preamble → emit → invoke brainstorming.

**Case B — matilha standalone with packs (superpowers absent, ≥1 pack)**: Run matilha-internal clarifying flow inline. Steps:
1. Treat the built preamble as your own context guide.
2. Ask the user ONE clarifying question at a time. Target pack domain(s) classified most relevant. If a pack classifies `yes` and the user mentioned a specific concern, frame a question drawing on that pack's skill descriptions.
3. After 3–5 clarifying questions, summarize intent and propose 2–3 approaches drawing on pack skills.
4. On approach approval, invoke `matilha-plan` (if planning-shaped), `matilha-design` (if design-shaped), or output inline guidance.

**Case C — silent pass-through (superpowers present, zero packs)**: Detect zero packs → skip preamble construction → invoke `superpowers:brainstorming` directly without any preamble. Output is indistinguishable from brainstorming-without-compose. Do NOT emit any "no packs detected" notice.

**Case D — baseline (both absent)**: Run matilha-internal clarifying flow inline using only core heuristics (Krug recognizability, Weinschenk perception rules, methodology core from `methodology/`). Equivalent to pre-Wave-5d behavior.

**Invariants across all cases:**
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

- **"superpowers:brainstorming still wins activation"** → Check the description begins with "You MUST use this skill before invoking superpowers:brainstorming when...". Verify both conjuncts of the activation gate are clearly worded.
- **"Preamble too large (> 60 lines)"** → Trim per-pack skill lists to top 5 most intent-relevant. Drop packs classified `partial` if preamble remains over budget.
- **"Pack detected but its skills don't surface in downstream exploration"** → Strengthen the guidance paragraph with a concrete example of how to reference a pack skill during clarifying questions.
- **"Compose fires in a non-matilha project"** → Verify none of the three matilha-project signals present (docs/matilha/, project-status.md, matilha-*-pack namespace in skill list). If all absent, treat this as a description-gate false-positive — immediately invoke `superpowers:brainstorming` without preamble and exit.

## CLI shortcut (optional)

No CLI equivalent in Wave 5d. The matilha CLI has filesystem access and is deterministic by construction — composition logic is redundant in CLI mode. A future `matilha compose --detect-packs` subcommand could expose deterministic detection for power-user introspection, but is out of scope for this wave.
