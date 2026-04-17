---
name: matilha-plan
description: Guide PRD + Stack + Skills/Agents (phases 10+20+30) with binary gates from methodology pages.
metadata:
  author: matilha
  phase: 10-30
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /plan — Phases 10-30 (PRD / Stack / Skills)

## Mission
Guide the user through PRD creation, stack decisions, and skills/agents identification with binary gates from `methodology/10-prd.md`, `20-stack.md`, and `30-skills-agents.md`. Output: spec+plan artifacts + updated `project-status.md`. Each gate must pass before advancing to the next phase.

## SoR Reference
Content of truth lives in:
- methodology/10-prd.md (PRD gates)
- methodology/20-stack.md (stack decision tree by archetype)
- methodology/30-skills-agents.md (skills/agents identification)

ALWAYS consult these pages for latest gates.

## Preconditions
- `project-status.md` exists in project root
- `CLAUDE.md` exists
- `current_phase` in project-status.md is 0 or 10 (after scout)

## Execution Workflow
1. Load `methodology/10-prd.md` — extract binary gates from its dense block
2. For each gate (problem_defined, target_user_clear, success_metrics_defined, scope_boundaries_locked): ask user yes/no/pending
3. On "judgment decision" checkpoints in methodology, pause and ask the human; log the decision to `project-status.md` `recent_decisions`
4. When all Phase 10 gates = yes: if `superpowers` detected, invoke `superpowers:brainstorming` to produce the spec (in `docs/superpowers/specs/`); else produce Matilha-native spec (in `docs/matilha/specs/`)
5. Update `project-status.md`: set `current_phase: 20`, update `phase_10_gates`, append to `feature_artifacts`
6. Repeat for Phase 20 (Stack): load `methodology/20-stack.md`, validate archetype defaults, ask about exceptions
7. Repeat for Phase 30 (Skills/Agents): load `methodology/30-skills-agents.md`, identify needed skills + agents + hooks
8. Final: prepare for `/hunt` — confirm plan exists; if `superpowers`, invoke `superpowers:writing-plans` to produce the plan; else produce Matilha-native plan

## Rules: Do
- Read methodology page at the START of each phase, even if same session (ensures up-to-date gates)
- Register every gate answer in `project-status.md` frontmatter with timestamp
- For judgment decisions, explicitly pause — do not assume
- If archetype doesn't match any methodology default, flag as "custom" and ask for user rationale

## Rules: Don't
- Don't advance to next phase with `pending` or `no` gates (those must become `yes`)
- Don't edit `methodology/*.md` (read-only SoR)
- Don't duplicate content from methodology into `project-status.md` — use links/references
- Don't batch multiple phases in one prompt — one phase, one pause for review

## Expected Behavior
- Deliberate, gate-driven pace. It's OK to end a session mid-phase; `/howl` resumes.
- When user pushes to skip a gate, respond: "Matilha requires this gate. To override, set `force_skip_gate_X: true` in project-status.md and commit the reason."
- Prefer asking vs guessing on ambiguous requirements

## Quality Gates
- Every `phase_<N>_gates` field in project-status.md is yes|no|pending (no empty)
- No phase has `phase_status: completed` with a `no` gate
- Spec file exists (either `docs/superpowers/specs/` or `docs/matilha/specs/`)
- `feature_artifacts` array in project-status.md references the spec+plan

## Companion Integration
- If `superpowers` detected: delegate spec creation to `superpowers:brainstorming`, plan to `superpowers:writing-plans`. Matilha adds methodology-gate validation on top.
- If `impeccable` + frontend archetype: during Phase 20, pre-configure `design-spec.md` with Impeccable teach commands
- If `shadcn-skills` + frontend archetype: inject shadcn registry context during Phase 30 (skills-agents identification includes UI components)

## Output Artifacts
- Updated `project-status.md` frontmatter: `phase_10_gates`, `phase_20_gates`, `phase_30_gates`, `current_phase`, `recent_decisions`, `feature_artifacts`
- `docs/superpowers/specs/YYYY-MM-DD-<feature>-design.md` OR `docs/matilha/specs/YYYY-MM-DD-<feature>-design.md`
- `docs/superpowers/plans/YYYY-MM-DD-<feature>-plan.md` OR `docs/matilha/plans/YYYY-MM-DD-<feature>-plan.md`
- `design-spec.md` updates (if frontend archetype)

## Example Constraint Language
- Use "must" for: binary gates, frontmatter schema compliance
- Use "should" for: default stack choices, aesthetic commitments
- Use "may" for: custom archetype exceptions, alternative stacks with rationale

## Troubleshooting
- **"Gate is ambiguous"**: Re-read the relevant methodology page dense block. If still unclear, ask the human. If human is also unclear, set gate to `pending` with a note in `blockers` — don't guess.
- **"Archetype seems wrong"**: Offer to revisit scout (Phase 00). Changing archetype late is expensive but clean.
- **"Want to skip Stack phase (already decided)"**: Still run Phase 20 — it validates decisions against methodology defaults. Fast to confirm if already solid.
- **"Methodology page conflicts with my situation"**: Flag as `decisões de juízo` per methodology convention. Log to project-status.md and proceed with explicit justification.

<!-- MATILHA_MANAGED_END -->
