---
name: matilha-design
description: Use when user is making UX, UI, or visual-design decisions in any phase — guides via core design heuristics and delegates to matilha-design-pack or matilha-ux-pack if installed.
category: matilha
version: "1.0.0"
optional_companions: ["matilha-design-pack", "matilha-ux-pack"]
---

## When this fires

User asks "how should this look?", "is this UX good?", "what component to use?", or is about to commit design-level changes. Cross-phase; most useful in Phase 20/30 spec authoring and Phase 40 execution.

## Preconditions

- None (works at any phase).

## Execution Workflow

1. If `matilha-design-pack:*` skills available, invoke the most relevant via Skill tool.
2. Else if `matilha-ux-pack:ux-*` or `cog-*` skills available, invoke them via Skill tool.
3. Else proceed with core heuristics: simplicity (Krug Fato 1), recognition > recall (Weinschenk), progressive disclosure, consistent navigation, 5-rule error format.
4. Emit design guidance linked to the user's current task.

## Rules: Do

- Prefer companion-pack skills when available (they carry neuroscience-backed depth).
- Cite sources in core heuristics (Weinschenk, Krug, wiki concept pages).
- Keep advice specific to the user's artifact.

## Rules: Don't

- Make subjective "good/bad" claims without evidence.
- Override user's explicit `aesthetic_direction` in project-status.md.

## Expected Behavior

Actionable design guidance. With companion pack installed, output quality is deeper; without companions, output is solid-core but less specialized.

## Quality Gates

- Output references at least one heuristic (source cited).
- If companion pack invoked, mentions which one and why.

## Companion Integration

THIS skill is the companion-delegation exemplar.
- If **matilha-design-pack:*** is available: invoke via Skill tool for deep design patterns (typography, color, spacing, components).
- If **matilha-ux-pack:ux-*** or **cog-*** skills are available: invoke for cognitive/perception-level guidance (Weinschenk, Krug).
- Otherwise: apply the core heuristics documented below (simplicity, recognition > recall, progressive disclosure, consistency, 5-rule errors).

## Output Artifacts

Usually chat output only; occasionally a commit to `docs/matilha/design-decisions.md` logging the decision with rationale.

## Example Constraint Language

- Use "must" for: cite source for any design claim.
- Use "should" for: delegate to pack when available.
- Use "may" for: log decision in `design-decisions.md` if impactful.

## Troubleshooting

- **"no pack installed and user wants deep guidance"**: Recommend installing `matilha-ux-pack` or `matilha-design-pack`.
- **"aesthetic_direction set but user wants to deviate"**: Log the deviation decision in `recent_decisions` via Edit.

## CLI shortcut (optional)

> No CLI equivalent (design guidance is inherently AI-conversational).

## Sources

- [[concepts/leis-de-krug]]
- [[concepts/reservatorio-boa-vontade]]
- [[concepts/memoria-cognicao]]
- [[sources/100-things-every-designer]]
