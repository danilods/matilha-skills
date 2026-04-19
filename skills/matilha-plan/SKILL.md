---
name: matilha-plan
description: Use when user wants to plan a feature with multiple subprojects or parallel work — generates phase-gated spec.md and plan.md with waves, SPs, merge_order, and exit gates.
category: matilha
version: "1.0.0"
optional_companions: ["superpowers:brainstorming", "superpowers:writing-plans"]
---

## When this fires

User has Phase 10 research (or skips scout) and wants spec + plan artifacts before dispatching work. Produces `docs/matilha/specs/<slug>-spec.md` + `docs/matilha/plans/<slug>-plan.md`.

## Preconditions

- `project-status.md` exists.
- `current_phase ≥ 10`.

## Execution Workflow

1. Read research (if exists) + project-status.md.
2. If `superpowers:brainstorming` available, invoke via Skill tool for the initial clarifying-questions phase. Otherwise, run a condensed clarifying inline via chat.
3. Write `docs/matilha/specs/<slug>-spec.md` with: purpose, context, design principles, target deliverables, architecture, data flow, open questions, exit criteria.
4. If `superpowers:writing-plans` available, invoke via Skill tool to generate the task-by-task plan. Otherwise, write the plan inline following `methodology/40-execucao.md` conventions.
5. Plan output lands at `docs/matilha/plans/<slug>-plan.md` with: goal, architecture, SPs, per-task steps, exit gates.
6. Update project-status.md: `current_phase: 30`, `phase_status: complete`, `feature_artifacts` appended, `next_action: "Run /matilha-hunt <slug>"`.

## Rules: Do

- Delegate to superpowers when present (their brainstorming + writing-plans are battle-tested).
- Validate plan against `planSchema` before writing.

## Rules: Don't

- Skip the spec (even for small features — the spec is the contract).
- Advance `current_phase` past 30 without user approval.

## Expected Behavior

User gets two artifacts ready for hunt/gather. Plan must be directly executable via subagent-driven-development or manual hunt.

## Quality Gates

- Spec exists at `docs/matilha/specs/<slug>-spec.md`.
- Plan exists at `docs/matilha/plans/<slug>-plan.md` and parses against `planSchema`.
- `current_phase: 30` in project-status.md.
- `feature_artifacts` entry added.

## Companion Integration

- If **superpowers:brainstorming** is available: invoke via Skill tool for the initial clarifying-questions phase.
- If **superpowers:writing-plans** is available: invoke via Skill tool for the task-by-task plan generation.
- If **ux-*** skills from matilha-ux-pack are available: invoke an ux-design-constraints skill during spec authoring.
- Otherwise: run the clarifying + drafting inline.

## Output Artifacts

- `docs/matilha/specs/<slug>-spec.md`
- `docs/matilha/plans/<slug>-plan.md`
- Updated `project-status.md`

## Example Constraint Language

- Use "must" for: spec and plan both exist; plan conforms to `planSchema`.
- Use "should" for: invoke superpowers when available; validate disjunction across intra-wave SPs.
- Use "may" for: skip research if user has a clear mental model.

## Troubleshooting

- **"planSchema fails"**: Check frontmatter shape vs `methodology/40-execucao.md`.
- **"research missing"**: Run matilha-scout first, or acknowledge the skip explicitly.

## CLI shortcut (optional)

> If matilha CLI is installed (`matilha --version` succeeds), you can run
> `matilha plan <slug>` to execute this deterministically. The plugin path
> above works without any CLI installation.
