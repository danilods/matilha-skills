---
name: matilha-scout
description: Phase 00 — Map the problem. Discovery via user research, PDF/transcript import, or from-scratch brainstorm.
metadata:
  author: matilha
  phase: "00"
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /scout — Phase 00 (Problem Mapping)

## Mission
Map the problem before writing a single line of code. Conduct discovery via user research, document import (PDFs, interview transcripts), or from-scratch brainstorm. Produce discovery notes that anchor all downstream decisions. Advance `current_phase` to 10 only when all Phase 00 gates pass.

## SoR Reference
Content of truth lives in:
- methodology/00-mapeamento-problema.md (discovery gates, user research heuristics)
- methodology/index.md (phase overview)

ALWAYS consult these pages for latest gates before starting discovery.

## Preconditions
- Project directory exists (git repo recommended)
- `project-status.md` may or may not exist — if missing, offer to run `/init` first
- User has a rough problem statement or domain in mind

## Execution Workflow
1. Check for `project-status.md`; if missing, ask: "Run `/init` first to bootstrap Matilha scaffolding, or continue without it?"
2. Load `methodology/00-mapeamento-problema.md` — extract Phase 00 binary gates
3. Ask user which discovery entrypoint applies:
   - **from-scratch**: guided brainstorm (problem, target user, pains, existing solutions)
   - **import-docs**: user pastes PDF/transcripts/notes — extract key signals
   - **resume**: `current_phase` is already 00 in project-status.md — continue from last checkpoint
4. Execute discovery interview: ask "Who is the user?" before "What are the features?" Document pains in the user's own words
5. Capture assumptions explicitly in a numbered list; flag each as validated or unvalidated
6. Produce `docs/matilha/discovery-notes.md` with: problem statement, target user profile, pain inventory, assumption log, "what we are NOT building" section
7. Walk Phase 00 gates with user: problem_mapped, user_identified, pains_documented, scope_boundary_exists
8. When all gates = yes: update `project-status.md` (`phase_00_gates`, `current_phase: 10`); suggest running `/plan`

## Rules: Do
- Ask "who is the user?" before asking about features
- Document user pains in their own words, not sanitized product language
- Capture assumptions explicitly — validated and unvalidated separately
- Re-read `methodology/00-mapeamento-problema.md` at session start to pick up gate changes
- If importing documents, extract verbatim quotes that support pain claims

## Rules: Don't
- Don't skip user research even if the user "already knows" the problem
- Don't assume archetype before completing discovery (let pains inform it)
- Don't rush to solutions — scout is for understanding, not designing
- Don't advance to Phase 10 with any gate at `pending` or `no`
- Don't modify `methodology/*.md` (read-only SoR)

## Expected Behavior
- Discovery can span multiple sessions; `/howl` shows resumption point
- When user resists structured discovery ("just let me build"), acknowledge and ask for the minimum: who is the user and what is the top pain
- Treat imported documents as raw signal — summarize, don't fabricate
- Flag gaps ("we don't know how users currently solve X") explicitly in discovery notes

## Quality Gates
- `docs/matilha/discovery-notes.md` exists and has: problem statement, target user, pain inventory, assumption log, out-of-scope section
- All `phase_00_gates` in project-status.md are `yes`
- `current_phase` updated to 10
- No assumption is unmarked (every assumption is either validated or explicitly flagged as unvalidated)

## Companion Integration
- If `superpowers` detected: invoke `superpowers:brainstorming` to structure the discovery session (generates brainstorm document); Matilha wraps with gate validation on top
- If `impeccable` detected and archetype has frontend: flag aesthetic direction as an open question in discovery-notes.md for Phase 20
- If `shadcn-skills` detected: note UI component scope boundaries in discovery-notes.md out-of-scope section

## Output Artifacts
- `docs/matilha/discovery-notes.md` (problem statement, user profile, pain inventory, assumption log, out-of-scope)
- Updated `project-status.md` (`phase_00_gates`, `current_phase: 10`, `recent_decisions` if any)

## Example Constraint Language
- Use "must" for: discovery-notes.md existence, gate completion before advancing
- Use "should" for: verbatim pain quotes, assumption logging conventions
- Use "may" for: additional discovery formats (personas, journey maps) beyond the minimum

## Troubleshooting
- **"User has no project-status.md"**: Offer `/init` to bootstrap. If user declines, continue scout and remind that `/init` can run after.
- **"User imports a large PDF"**: Extract key sections relevant to pains and user identity; do not paste entire PDF into discovery notes. Summarize with citations.
- **"Gate 'scope_boundary_exists' is unclear"**: Read the `methodology/00-mapeamento-problema.md` definition. If still unclear, draft a scope boundary statement and ask user to confirm or revise.
- **"User keeps expanding scope during discovery"**: Log each expansion in the assumption log as unvalidated. Flag at gate review: "scope is still expanding — lock before advancing to Phase 10."
- **"resume entrypoint — can't find prior notes"**: Check `docs/matilha/discovery-notes.md` and project-status.md. If neither exists, treat as from-scratch.

<!-- MATILHA_MANAGED_END -->
