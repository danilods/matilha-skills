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
Map the problem before writing a single line of code. The CLI drives a structured 6-question discovery interview, writes `docs/matilha/discovery-notes.md`, auto-passes all Phase 00 gates, and advances `current_phase` to 10 in one atomic step. Discovery is always guided — not free-form or import-based.

## SoR Reference
Content of truth lives in:
- methodology/00-mapeamento-problema.md (discovery gates, user research heuristics)
- methodology/index.md (phase overview)

Consult `methodology/00-mapeamento-problema.md` before the session to understand what each gate is checking.

## Preconditions
- `project-status.md` exists (user ran `matilha init` first)
- `current_phase === 0` — CLI throws if Phase 00 is already complete

## Execution Workflow
1. User runs `matilha scout` from the project root
2. CLI reads `project-status.md` and confirms `current_phase === 0`; aborts with a message if already past Phase 00
3. CLI launches the interactive discovery session via `@clack/prompts` — 6 sequential questions:
   1. **Target user** — "Who is the target user?"
   2. **Primary pain** — "What is their top pain point?"
   3. **Secondary pain** — "What's a secondary pain point?" (optional, blank OK)
   4. **Existing solutions** — "What existing solutions/workarounds do they use today?"
   5. **Success metric** — "How would you measure success?"
   6. **Out of scope** — "What's explicitly OUT of scope?"
4. CLI writes `docs/matilha/discovery-notes.md` with sections: Target user, Pain points (primary + secondary), Existing solutions / workarounds, Success metric, Out of scope
5. CLI auto-advances project state in `project-status.md`:
   - `phase_00_gates`: all 4 gates set to `yes` (`problem_defined`, `target_user_clear`, `success_metrics_defined`, `scope_boundaries_locked`)
   - `current_phase`: `0 → 10`
   - `phase_status`: `"not_started"`
   - `next_action`: `"Run /plan to begin Phases 10-30 (PRD + Stack + Skills)"`
   - `last_update`: current ISO timestamp
6. CLI prints summary note and suggests `matilha plan` as next step

## Rules: Do
- Ask "who is the target user?" as the first question — user identity before features, always
- Document pains in the user's own words from the scout interview answers
- If the user blanks the secondary pain, record `_(none specified)_` — don't infer a second pain
- Re-read `methodology/00-mapeamento-problema.md` at session start to understand what the 4 gates represent

## Rules: Don't
- Don't skip the discovery interview even if the user "already knows" the problem — the interview produces the discovery-notes.md artifact
- Don't assume archetype before completing discovery (let pains inform it; archetype is set during `matilha init` but can be revised)
- Don't rush to solutions — scout is for understanding, not designing
- Don't modify `methodology/*.md` (read-only SoR)

## Expected Behavior
- Scout completes in a single session — there is no resume or partial-progress mode for Phase 00
- When user resists the interview ("just let me build"), acknowledge and remind them that the 6 questions take under 2 minutes and unlock `/plan`
- If user presses Ctrl+C mid-interview, CLI cancels gracefully ("Scout cancelled. Run again when ready.") without writing any files or mutating project-status.md

## Quality Gates
- `docs/matilha/discovery-notes.md` exists and has all 5 sections: Target user, Pain points, Existing solutions, Success metric, Out of scope
- All 4 `phase_00_gates` in `project-status.md` are `yes`: `problem_defined`, `target_user_clear`, `success_metrics_defined`, `scope_boundaries_locked`
- `current_phase` is `10`
- `next_action` points to `/plan`

## Companion Integration
- If `superpowers` detected: after `matilha scout` completes, optionally invoke `superpowers:brainstorming` with the discovery-notes.md as context to enrich the problem framing before running `/plan`
- If `impeccable` detected and archetype has frontend: flag aesthetic direction as an open question in discovery-notes.md for Phase 20 (manual step — CLI does not do this automatically)
- If `shadcn-skills` detected: note UI component scope boundaries in the out-of-scope section of discovery-notes.md (manual step)

## Output Artifacts
- `docs/matilha/discovery-notes.md` — target user, primary pain, secondary pain, existing solutions, success metric, out of scope
- Updated `project-status.md` — `phase_00_gates` (all `yes`), `current_phase: 10`, `phase_status: "not_started"`, `next_action`, `last_update`

## Example Constraint Language
- Use "must" for: discovery-notes.md existence, `current_phase === 0` precondition, 6-question sequence
- Use "should" for: phrasing questions in user's own words, acknowledging blank secondary pain explicitly
- Use "may" for: optional post-scout enrichment with superpowers:brainstorming

## Troubleshooting
- **"CLI throws: Phase 00 already complete"**: Phase 00 is already done. Check `current_phase` in `project-status.md` — if it's `10` or higher, proceed directly to `matilha plan`.
- **"project-status.md not found"**: Run `matilha init` first to bootstrap project scaffolding, then re-run `matilha scout`.
- **"User cancelled mid-interview"**: No files were written. Re-run `matilha scout` from the start — answers are not persisted between interrupted runs.
- **"discovery-notes.md already exists"**: CLI overwrites it on every run. If you want to preserve a previous version, copy it before re-running `matilha scout`.
- **"Phase 00 gates are all yes but current_phase is still 0"**: Manually set `current_phase: 10` in `project-status.md` — this indicates a partial write during a prior interrupted run.

<!-- MATILHA_MANAGED_END -->
