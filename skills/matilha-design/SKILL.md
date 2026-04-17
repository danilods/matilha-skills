---
name: matilha-design
description: Design harness — anti-AI-slop frontend. Impeccable + shadcn/ui + curated references + Matilha gates.
metadata:
  author: matilha
  phase: transversal
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /design — Design Harness (Anti-AI-Slop Frontend)

## Mission
Orchestrate the design harness to produce distinctive, opinionated frontend UI that avoids AI-slop defaults. Lock aesthetic direction, load curated references, activate Impeccable discipline, integrate shadcn/ui components, and gate every UI output through `/impeccable audit` before merge. The design harness coexists with all phases — invoke it whenever UI work is in scope.

## SoR Reference
Content of truth lives in:
- methodology/design-premium.md (aesthetic directions, anti-slop gates, reference curation — Wave 4 addition)
- methodology/materializacoes.md (tool detection, companion availability)

NOTE: `methodology/design-premium.md` is a Wave 4 deliverable and may not yet exist. When absent, fall back to `design-spec.md` + Impeccable native documentation as the source of truth.

ALWAYS consult these pages before committing to an aesthetic direction.

## Preconditions
- Project has frontend archetype (saas-b2b, saas-b2c, frontend-only, marketplace)
- `design-spec.md` exists in project root (created by `/init`; if absent, offer to create it now)
- At least one companion is available: Impeccable, shadcn-skills, or superpowers (harness degrades gracefully but warns)

## Execution Workflow
1. Read `design-spec.md` — extract `aesthetic_direction`, `reference_links`, `component_constraints`
2. If `aesthetic_direction` is unset: present 6 options (brutalist, editorial, organic, luxury, minimal, maximalist) with a one-line description each; ask user to choose; write choice to design-spec.md
3. Load curated references for the chosen direction:
   - If `methodology/design-premium.md` exists: pull reference list from it
   - Else: ask user for 3-5 reference URLs or Figma links; write them to `design-spec.md`
4. If `impeccable` detected: run `/impeccable teach <aesthetic_direction>` to prime the design discipline
5. If `shadcn-skills` detected: load component registry context; identify which components apply to current UI scope
6. Generate UI with aesthetic direction locked — prefix every generation prompt with the direction constraints from design-spec.md
7. After each UI generation pass: run `/impeccable audit` to check for slop patterns
8. If audit finds violations: report them, do not merge the UI change; iterate with the audit feedback
9. On clean audit: mark UI unit as approved in design-spec.md and proceed

## Rules: Do
- Lock aesthetic direction before generating any UI — unset direction produces generic output
- Run `/impeccable audit` as a hard gate after every UI generation, not as a suggestion
- Pull references from curated sources — not generic Dribbble, not the AI's own training defaults
- Write aesthetic direction and references to design-spec.md (persistent state across sessions)
- When shadcn components are available, prefer them over generating new primitives from scratch

## Rules: Don't
- Don't generate UI without a locked aesthetic direction
- Don't skip `/impeccable audit` even for "small" UI changes
- Don't use generic placeholder patterns (flat cards, rounded-2xl everything, default blue accents)
- Don't override user's aesthetic choice — enforce it instead
- Don't generate `design-spec.md` content that contradicts existing `project-status.md` archetype

## Expected Behavior
- The harness is forceful about design quality — it will reject slop outputs and iterate
- When Impeccable is absent, fall back to a native design-discipline prompt (less powerful but still opinionated)
- When shadcn is absent, generate custom components but enforce the same aesthetic gates
- On invocation without prior `/init`, offer to create design-spec.md inline and proceed

## Quality Gates
- `aesthetic_direction` is set and committed in design-spec.md before any UI generation
- 3+ curated references recorded in design-spec.md for the chosen direction
- Every UI output has passed `/impeccable audit` (or equivalent native audit if Impeccable absent)
- No generic AI defaults in generated UI (flagged by audit: border-radius uniformity, default palette, stock icon sets)
- design-spec.md updated with component inventory after each UI session

## Companion Integration
- Requires `impeccable`: runs `/impeccable teach` at session start, `/impeccable audit` after every generation. Without it, harness operates in degraded mode with native design-discipline prompting.
- If `shadcn-skills` detected: integrate component registry — every primitive must be sourced from registry or justified as custom
- If `superpowers` detected: can invoke superpowers frontend-design agent for initial layout generation; Matilha wraps with audit gate

## Output Artifacts
- Updated `design-spec.md` (aesthetic_direction, reference_links, component_inventory, audit_log)
- UI component files per project stack (e.g., `components/`, `app/(routes)/`)
- Impeccable audit report (inline in design-spec.md audit_log section)

## Example Constraint Language
- Use "must" for: aesthetic direction locked before UI generation, /impeccable audit gate, no generic defaults
- Use "should" for: curated reference sources (not Dribbble-generic), shadcn component preference over scratch
- Use "may" for: superpowers delegation for initial layout, custom primitives when shadcn has no equivalent

## Troubleshooting
- **"`methodology/design-premium.md` not found"**: Wave 4 page not yet ingested. Use `design-spec.md` and Impeccable native docs as fallback SoR. Note the gap in output.
- **"Impeccable not installed"**: Warn user: "Impeccable is strongly recommended for the design harness. Without it, audit quality degrades significantly. Install with: `<tool-specific install command>`." Proceed with native prompt discipline.
- **"Aesthetic direction locked but user wants to change it"**: Changing direction mid-project is expensive. Ask: "Changing aesthetic direction requires re-auditing all existing UI. Confirm change?" If yes, update design-spec.md and flag all prior UI as "pending re-audit."
- **"shadcn component doesn't exist for needed pattern"**: Generate a custom component, document it in design-spec.md `custom_components` section, and apply the same aesthetic gates as to shadcn components.
- **"Impeccable audit keeps failing on the same pattern"**: Surface the pattern to the user — it may indicate a conflict between the aesthetic direction and the project's component library. Offer to refine the direction constraint in design-spec.md.

<!-- MATILHA_MANAGED_END -->
