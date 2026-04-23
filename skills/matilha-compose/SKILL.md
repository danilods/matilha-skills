---
name: matilha-compose
description: "You MUST use this skill before any software-construction work — planning, designing, researching, building, reviewing, dispatching, merging, or modifying features/systems/products/components/agents/workflows — whenever matilha is installed (this skill is visible in your ambient skill list). Matilha is a methodology wrapper around superpowers:* skills; compose routes user intent to the right matilha phase (scout/plan/design/hunt/gather/review/howl) or dispatches to superpowers:brainstorming with pack-aware preamble. Runs standalone when superpowers is absent. Detects companion packs (matilha-*-pack namespace) as optional enrichment. Lazy-bootstraps matilha project structure on demand."
category: matilha
version: "1.0.0"
optional_companions: ["superpowers:brainstorming", "matilha-plan", "matilha-design"]
---

## When this fires

Fires BEFORE any creative-work or software-construction skill (including `superpowers:brainstorming`, `superpowers:writing-plans`) when BOTH conditions hold:

1. **Matilha is installed** — this skill (`matilha:matilha-compose`) is visible in the ambient skill list. This is implicit: if you are reading this body, matilha is loaded for the current workspace.

2. **Software-construction intent** — the user prompt signals any of:
   - Planning / spec authoring ("plan this", "write a spec", "lay out phases")
   - Designing / UX / UI ("how should this look", "which UI", "what component")
   - Researching / discovery ("what are the options for...", "investigate...")
   - Building / implementing ("I'm building...", "adding...", "construindo...")
   - Reviewing / quality ("review this PR", "check this code")
   - Dispatching waves / parallel work ("split this into SPs", "dispatch waves")
   - Status / next action ("where am I?", "what's next?")
   - General creative exploration ("I'm thinking about...", "exploring...")

Project-context signals (`docs/matilha/` directory, `project-status.md` file, any `matilha-*-pack` skill visible) are **supplementary context for routing decisions**, not activation gates. Matilha methodology applies broadly whenever the plugin is installed — these signals only shift how compose dispatches (to which specific matilha phase skill vs. superpowers skill).

**Positive examples (compose fires):**
- "Estou construindo MVP de 4 semanas... Como estruturo os agents?" → general creative → brainstorming with pack preamble (harness-pack if visible)
- "Quero planejar a feature de export CSV" → planning intent → matilha-plan (may lazy-bootstrap docs/matilha/)
- "What's the current phase?" → status intent → matilha-howl
- "Review my code changes" → quality intent → superpowers:brainstorming or matilha-review depending on what matilha finds

**Negative examples (compose does NOT fire):**
- Compose is NOT installed (different workspace) → this skill is absent from ambient list
- Prompt is pure factual / non-construction ("what's the capital of France?") → no software-construction signal
- User invokes a specific skill directly via slash command (e.g., `/matilha-howl`) → direct invocation bypasses compose

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

**Step 2 — Intent classification (prose semantic, inclusive).**

For each detected pack, decide whether the user prompt touches its domain in ANY way. Use the pack's shipped skill descriptions (visible in the ambient list) to inform the decision. Binary output per pack: `relevant` | `off-topic`.

**Strongly bias toward `relevant`**: if the pack touches ANY aspect of the user's prompt (even a minor one), classify it `relevant`. The preamble serves brainstorming by surfacing the pack's vocabulary — even a tangential pack is more useful than no pack context. Only mark `off-topic` when the pack's domain is clearly unrelated (e.g., growth-pack for a pure-infrastructure prompt with zero product/user-experience dimension).

When in doubt, classify `relevant`. The brainstorming downstream will naturally skip irrelevant skills during exploration — the cost of including a marginal pack is low; the cost of omitting a relevant one is a missed aha moment.

Do NOT use hardcoded keyword maps. Rely on semantic judgment based on skill descriptions.

**Step 3 — Dispatch decision.**

Choose the terminal destination based on intent-to-phase classification. Matilha phase skills handle their own pack-aware enrichment — compose routes without emitting preamble for them. Only the `superpowers:brainstorming` path gets preamble emission.

| Intent signal | Dispatch target | Preamble emitted by compose? | Notes |
|---|---|---|---|
| Planning / spec authoring | `matilha:matilha-plan` | No | matilha-plan runs own pack logic; lazy-bootstraps docs/matilha/specs/ if missing |
| Design / UX / UI | `matilha:matilha-design` | No | matilha-design runs own pack logic |
| Discovery / research | `matilha:matilha-scout` | No | matilha-scout dispatches research subagents; lazy-bootstraps docs/matilha/research/ |
| Status / next action | `matilha:matilha-howl` | No | Read-only; lazy-bootstraps project-status.md stub if missing |
| Dispatch waves / parallel SPs | `matilha:matilha-hunt` | No | Requires existing plan.md — if absent, fall back to matilha-plan first |
| Merge / regression / wave integration | `matilha:matilha-gather` | No | Requires active wave status |
| Quality review | `matilha:matilha-review` | No | (Wave 3c runtime pending — currently stub) |
| Deploy / production gate | `matilha:matilha-den` | No | Phase 60 |
| Teammate onboarding | `matilha:matilha-pack` | No | Phase 70 |
| General creative exploration ("I'm building", "exploring", "thinking about") | `superpowers:brainstorming` | **Yes** (if ≥1 pack classified relevant) | Only terminal-brainstorming path gets enrichment |
| Implementation plan authoring (existing spec in context) | `superpowers:writing-plans` | No | Superpowers handles craft; matilha tracks phase advancement via plan status |
| Ambiguous | `superpowers:brainstorming` with preamble | Yes | Default — brainstorming explores intent, may surface need for phase-specific skill |

**Lazy bootstrap rule**: if the chosen matilha phase skill needs filesystem structure that doesn't yet exist (e.g., matilha-plan writes to `docs/matilha/specs/<slug>-spec.md`), the skill itself creates the directory on first write. Compose does not pre-create — that's delegated to the downstream skill's body. This keeps compose stateless.

**Superpowers fallback**: if the chosen matilha phase skill delegates to a superpowers skill (e.g., matilha-plan delegates to `superpowers:brainstorming` during clarifying questions), that delegation is the matilha phase skill's responsibility, not compose's.

**Step 4 — Build preamble (if terminal is brainstorming AND ≥1 pack classified `relevant`).**

**Default is EMIT.** If any installed pack is relevant (by the bias-inclusive rule from Step 2), build the preamble. Skip only when:
- Zero companion packs installed (ambient list contains no `matilha-*-pack` namespaces), OR
- All installed packs are clearly off-topic (e.g., only growth-pack installed, and prompt is pure DevOps/infrastructure with zero product dimension).

In any other case — especially when the prompt is technical/creative/software-construction-shaped and at least one pack is installed — EMIT the full sigil + atmospheric + pack lines + closing. This is the matilha signature and the user's aha moment; withholding it when a pack is available wastes the harness.

Use this canonical template. The goal combines three purposes at once: (a) signal to the user that matilha's methodology layer activated, (b) make the "aha" moment visible (LLM mirroring domain-specific language proves it *read* the prompt), (c) inject pack context for brainstorming to weave skills naturally.

```text
            ♛
        /\___/\
       ( ◉   ◉ )
        \  v  /
         ‾‾‾‾‾

   /\_/\   /\_/\   /\_/\
  ( ● ● ) ( ● ● ) ( ● ● )
    \/      \/      \/
          matilha

A alcateia farejou território familiar: <specific domain phrase mirroring
the user's prompt — e.g., "orquestração de eventos com Lambda, EventBridge
e DynamoDB" or "fluxo de signup com foco em ativação" or "arquitetura de
agentes com planner/executor">.

<pack-name-1> ao lado → <skill-1>, <skill-2>, <skill-3>, <skill-4>, <skill-5>.
[repeat per pack classified yes, one line per pack]

Brainstorming adiante. Skills entram em cena conforme os tópicos surgirem.
```

**Semiotics of the sigil** (why this matters, not just decoration):
- **♛** (crown) — the user is the alpha; matilha leads them, doesn't replace them. "You lead. Agents hunt."
- **Alpha face with `◉`** eyes — distinct from pack, in focus.
- **3 pack dogs with `●`** eyes — the skills/companion packs mobilizing in formation.
- **`matilha`** label — grounds the glyph to the harness name.

**Language rules for the atmospheric paragraph** (line starting "A alcateia farejou território familiar"):
- The domain phrase MUST mirror concrete language from the user's prompt (technology names, specific nouns). This is the aha-moment trigger — the user sees "oh, it actually understood what I'm asking about, not generic help."
- Keep it to one sentence maximum.
- Do not summarize the prompt — name the *territory* (the domain / problem space).

**Pack lines**:
- One line per pack classified yes.
- Format: `<pack-name> ao lado → <skill>, <skill>, <skill>, <skill>, <skill>` (4-6 most relevant skills per pack).
- Skill names only, no inline descriptions. Brainstorming can invoke skills via Skill tool if it needs detail.

**Closing line** (`Brainstorming adiante. Skills entram em cena conforme os tópicos surgirem.`):
- Signals to user that the conversation flow continues; establishes anticipation without listing all skills upfront.
- In English contexts, use: `Brainstorming ahead. Skills enter as topics surface.`

**If zero packs classified yes**: skip preamble entirely, including the sigil. The pack doesn't howl when there's no territory to hunt (silent pass-through Case C). The user just sees brainstorming running directly.

**Step 5 — Emit + invoke (storytelling mode, not debug mode).**

Emit the preamble with sigil + atmospheric paragraph + pack lines + closing line. Then invoke the target skill via the Skill tool. Then stop — let the target skill take over.

**Do NOT narrate your internal steps** ("Step 1 — Pack detection...", "Step 2 — Intent classification...") in the user-facing output. Those steps happen inside your reasoning; only the preamble and the skill invocation should reach the user. Exception: if the user explicitly asks you to explain what compose did (e.g., `/matilha-compose --debug` or "explain your routing"), then show the steps.

Goal: the user experiences compose as an atmospheric opening — the pack's presence acknowledged with a wink of recognition, then the work begins.

If no preamble (pass-through or routing to plan/design): invoke target skill via Skill tool directly.

## Rules: Do

- Always include the guidance paragraph in the preamble when emitted.
- Always include skill names (backtick-quoted) in per-pack skill lists.
- Prefer false-positive pack inclusion over missing a pack.
- Cite pack origin ("from matilha-harness-pack") only when ambiguity arises about which pack a skill belongs to.
- Trust the ambient skill list as the sole detection signal.

## Rules: Don't

- Don't hardcode pack names or skill prefixes in detection logic. Prefixes like those used by companion packs may appear in this skill body only inside examples or illustrative contexts — never inside detection instructions. Use the `matilha-*-pack` namespace pattern as the sole detection mechanism.
- Don't fire when matilha plugin is not installed (this skill is absent from the ambient list). No self-check needed — if you are reading this body, matilha is loaded.
- Don't duplicate brainstorming's clarifying-questions flow when `superpowers:brainstorming` is available — dispatch to it.
- Don't inject full skill bodies into the preamble — descriptions only.
- Don't emit empty preambles ("no packs detected...") — if pack list is empty, just pass through.
- Don't emit a preamble when routing to matilha-plan or matilha-design — those skills handle their own enrichment.

## Expected Behavior

With matilha-compose in the activation loop, software-construction prompts flow:

1. User writes any software-construction prompt (planning, designing, building, reviewing, exploring).
2. matilha-compose wins activation over `superpowers:brainstorming` and other creative-work skills (description gate + CLAUDE.md ambient priority).
3. Compose classifies intent into a matilha phase (or "general creative") and detects installed companion packs.
4. Compose routes to the appropriate matilha phase skill (no preamble — they run their own enrichment) OR to `superpowers:brainstorming` (with pack preamble if packs are relevant).
5. The terminal skill runs — matilha phase skills persist artifacts to `docs/matilha/` (lazy-bootstrapping as needed); brainstorming explores intent with pack-aware context.
6. User gets methodology-guided output whether the workspace was pre-bootstrapped as a matilha project or not.

The user's experience: methodology guidance everywhere matilha is installed, with pack enrichment where packs are installed, without any need to run matilha-init explicitly. Matilha project structure (docs/matilha/, project-status.md) materializes on demand when matilha phase skills need it.

## Quality Gates

- If ≥1 pack classified `yes`, preamble contains at least one per-pack section when terminal is brainstorming.
- Preamble always contains the final Guidance paragraph when emitted.
- Target skill invoked via the Skill tool (not narrated in prose).
- Detection logic contains no hardcoded pack names or skill prefixes.

## Companion Integration

`matilha-compose` is the methodology orchestrator and companion-pack-aware gateway. Relationships:

**Superpowers (craft layer):**
- **superpowers:brainstorming** — common dispatch target for general creative exploration. Compose emits pack preamble before invoking when packs are relevant.
- **superpowers:writing-plans** — invoked when user has an existing spec and wants an implementation plan; compose routes without preamble (superpowers handles the craft, matilha tracks phase advancement).
- **superpowers:*** other skills — compose generally hands off craft concerns (TDD, debugging, verification) to superpowers without interference.

**Matilha phase skills (methodology layer):**
- **matilha-scout** — research dispatch for discovery-intent prompts. Lazy-bootstraps `docs/matilha/research/`.
- **matilha-plan** — spec + plan authoring for planning-intent prompts. Lazy-bootstraps `docs/matilha/specs/` and `docs/matilha/plans/`.
- **matilha-design** — UX/UI guidance for design-intent prompts.
- **matilha-hunt / matilha-gather / matilha-review / matilha-den / matilha-pack** — later-phase skills (dispatch, merge, quality, deploy, onboarding).
- **matilha-howl** — status reporter for "where am I?" prompts. Lazy-bootstraps `project-status.md`.

**Companion packs (domain knowledge layer):**
- **Any skill with plugin namespace `matilha-*-pack`** (e.g., `matilha-harness-pack:harness-architecture`, `matilha-ux-pack:ux-reservatorio-boa-vontade`) — detected at runtime via ambient skill list; referenced by name in the emitted preamble when compose dispatches to brainstorming; available for direct invocation by the downstream skill via the Skill tool.

**Standalone mode**: when `superpowers:*` skills are absent, compose and matilha phase skills implement inline fallback flows (clarifying questions, spec drafting, etc.) using matilha's own methodology content. Matilha is never hostage to superpowers — it enhances superpowers when present and runs independently when absent.

The detection pattern here is canonical for Matilha. When `matilha-plan` or `matilha-design` perform their own pack-aware enrichment (delegating to brainstorming with preamble), they reference this skill as the template source.

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

Cases are organized along two axes: (a) superpowers availability, (b) pack availability. Applied AFTER intent classification in Step 2 when the dispatch target (Step 3) resolves to `superpowers:brainstorming` specifically — matilha phase skill routes use their own downstream logic.

**Case A — happy path (superpowers present, ≥1 relevant pack)**: Detect → classify → preamble → emit → invoke brainstorming. Terminal skill surfaces pack skills during exploration.

**Case B — matilha standalone with packs (superpowers absent, ≥1 pack)**: Run matilha-internal clarifying flow inline using the built preamble as context guide. Steps:
1. Ask the user ONE clarifying question at a time, drawing on the most-relevant pack skill's domain.
2. After 3–5 clarifying questions, summarize intent and propose 2–3 approaches drawing on pack skills.
3. On approach approval, invoke an appropriate matilha phase skill (matilha-plan if planning-shaped, matilha-design if design-shaped) or output inline guidance.

**Case C — silent pass-through (superpowers present, zero packs)**: Skip preamble construction → invoke `superpowers:brainstorming` directly without any preamble. Output is indistinguishable from brainstorming-without-compose. Do NOT emit "no packs detected" notice. Matilha methodology value still lands via the routing itself (compose fired, observed intent was general creative, correctly handed off).

**Case D — matilha methodology standalone (both absent)**: Run matilha-internal clarifying flow inline using methodology core (phases from `methodology/`, design heuristics from matilha-design, etc.). Equivalent to "matilha works when nothing else is installed".

**Invariants across all cases:**
- Never crash on absent dependencies.
- Empty preamble never emitted.
- Matilha methodology guidance is always accessible — activation gate is plugin-installed, not project-configured.
- Project structure (`docs/matilha/`, `project-status.md`) is created lazily by downstream phase skills when they need to write artifacts — not a prerequisite for compose firing.

**What compose does NOT fallback**: intent-classification logic is always prose-semantic. No alternate keyword-map path. No "simple mode" for quick dispatch. The classification is cheap (LLM already running) and the correctness is worth the consistency.

## Output Artifacts

None. Compose is a dispatcher, not a writer.

Optional: emit a log line to `docs/matilha/compose-log.md` capturing (timestamp, detected packs, classified intent per pack, routing decision). Opt-in, not required for Wave 5d ship.

## Example Constraint Language

- **Must**: detect packs via `matilha-*-pack` namespace inspection (no other detection mechanism permitted); emit guidance paragraph in every emitted preamble; invoke target skill via Skill tool.
- **Should**: err inclusive in classification; cap per-pack skill list at ~8.
- **May**: emit an optional log entry to `docs/matilha/compose-log.md` for observability.

## Troubleshooting

- **"superpowers:brainstorming still wins activation"** → Description strength alone does not reliably win activation. The primary mechanism is the `CRITICAL — activation priority in matilha projects` section in the plugin's CLAUDE.md, which is loaded ambiently. Verify that CLAUDE.md contains the priority instruction and the user's session loaded it. Description gate is a secondary reinforcement.
- **"Preamble too large (> 60 lines)"** → Trim per-pack skill lists to top 5 most intent-relevant. Drop packs classified `partial` if preamble remains over budget.
- **"Pack detected but its skills don't surface in downstream exploration"** → Strengthen the guidance paragraph with a concrete example of how to reference a pack skill during clarifying questions.
- **"Compose fires in a non-matilha project"** → Verify none of the three matilha-project signals present (docs/matilha/, project-status.md, matilha-*-pack namespace in skill list). If all absent, treat this as a description-gate false-positive — immediately invoke `superpowers:brainstorming` without preamble and exit.

## CLI shortcut (optional)

No CLI equivalent in Wave 5d. The matilha CLI has filesystem access and is deterministic by construction — composition logic is redundant in CLI mode. A future `matilha compose --detect-packs` subcommand could expose deterministic detection for power-user introspection, but is out of scope for this wave.
