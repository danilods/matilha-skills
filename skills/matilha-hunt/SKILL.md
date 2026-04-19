---
name: matilha-hunt
description: Phase 40 — Decompose plan into sub-projects + waves, create worktrees, dispatch parallel sessions.
metadata:
  author: matilha
  phase: "40"
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /hunt — Phase 40 (Wave Dispatch)

## Mission

Decompose a plan artifact into waves and sub-projects (SPs), create git
worktrees per SP, and render kickoff.md + SP-DONE.md templates into each.
Matilha wraps wave-status bookkeeping around this so every SP has a tracked
branch, a defined dependency order (merge_order), and a completion criterion.

## SoR Reference

- `methodology/40-execucao.md` — wave decomposition rules, SP sizing, worktree
  conventions, kickoff/SP-DONE artifacts

Consult this page for latest sizing heuristics and merge_order conventions.

## Preconditions

- Plan artifact exists: `docs/matilha/plans/<slug>-plan.md` (or superpowers variant)
- Git repo with worktree capability (`git worktree add`, requires git ≥ 2.15)
- `project-status.md` shows `current_phase` ≥ 30
- No uncommitted changes on current branch

## Execution Workflow

1. **Pre-flight (Swiss Cheese)**: plan exists, current_phase ≥ 30, working
   tree clean, git repo valid.
2. **Parse plan**: frontmatter + body SP headings (soft-strict: accepts
   em-dash, colon, or single-hyphen with warnings). Extracts touches,
   acceptance, tests per SP.
3. **Validate disjunction**: intra-wave SPs must touch disjoint files. Violation → hard error unless `--allow-overlap`.
4. **Detect companions**: read `companion_skills.superpowers` from
   project-status. Kickoff.md adapts (recommends `superpowers:executing-plans`
   when present).
5. **Idempotency guard**: if `wave-NN-status.md` already exists, refuse
   unless `--force`. `--force` logs recovery info (branch commits) before
   destroying.
6. **For each SP in target wave**:
   - `git branch wave-NN-sp-<slug>`
   - `git worktree add ../<project>-sp-<slug> wave-NN-sp-<slug>`
   - Render kickoff.md from `templates/kickoff.md.tmpl`; write to worktree root
   - Render SP-DONE.md from `templates/sp-done.md.tmpl`; write to worktree root
7. **Update .gitignore**: ensure `kickoff.md` is ignored at main repo root.
8. **Write `docs/matilha/waves/wave-NN-status.md`** using the `Wave` schema.
9. **Dispatch**: `PrintDispatcher` emits a cd + editor command per SP.
   User pastes each in a new terminal.

## Rules: Do

- Run `matilha hunt <slug>` with no args for the first pending wave.
- Pass `--wave N` for explicit wave selection.
- Pass `--dry-run` to preview without mutation.
- Respect the disjunction gate — edit plan.md to fix overlaps rather than
  bypassing with `--allow-overlap` (which accepts merge conflict risk).

## Rules: Don't

- Don't run `/hunt` if uncommitted changes exist — worktrees will not
  reflect them.
- Don't use `--force` if any worktree has a filled SP-DONE.md (that signals
  completed work).
- Don't modify `kickoff.md` after dispatch — it's regenerated on `--force`.

## Expected Behavior

- If plan has a single wave, still writes `wave-01-status.md` for uniformity.
- If the user wants fewer SPs ("one big task"), respect it — Matilha enables
  parallelism, doesn't enforce it.
- Worktree creation failures report precisely with recovery options.

## Quality Gates

- `docs/matilha/waves/wave-NN-status.md` exists and conforms to waveSchema
- Every SP in wave-status has `branch`, `worktree`, `status` fields
- `.gitignore` contains `kickoff.md` (idempotent)
- No circular SP dependencies in merge_order (wave 1 is Rendered linearly)
- `current_phase` is ≥ 30 in project-status.md

## Companion Integration

- **superpowers detected** → kickoff.md recommends `superpowers:executing-plans`
  as the preferred task-control engine. Matilha provides the harness
  (worktree isolation, disjunction gates, wave-status); superpowers drives
  execution with TDD + review checkpoints.
- **impeccable + frontend SPs** → audit step added to SP exit gates (future).
- **shadcn-skills + UI SPs** → shadcn component list injected into SP
  context (future).

## Output Artifacts

- `docs/matilha/waves/wave-NN-status.md` — wave-level tracking
- N `kickoff.md` files (one per worktree, gitignored)
- N `SP-DONE.md` templates (one per worktree, committed on SP branch)
- N git branches `wave-NN-sp-<slug>`
- N worktrees at `../<project>-sp-<slug>/`

## Example Constraint Language

- Use "must" for: `wave-NN-status.md` existing before dispatch completes;
  disjunction validated before any worktree is created; `current_phase ≥ 30`
  before `/hunt` proceeds.
- Use "should" for: running `--dry-run` before the first `/hunt` on a plan;
  reviewing the `--force` recovery log before confirming destruction; sizing
  SPs to ≤1 day of focused work per `methodology/40-execucao.md`.
- Use "may" for: `--allow-overlap` when the overlap is benign and understood;
  custom `Dispatcher` implementations (future Wave 3a.1 adds
  `MacTerminalDispatcher` behind the same interface).

## Troubleshooting

- **"branch already exists"**: leftover from prior attempt. Options:
  `git branch -D <branch>` + retry, or `--force` (destructive, logs recovery).
- **"worktree path already exists"**: similar. `git worktree remove <path>`
  or `--force`.
- **"disjunction violated"**: plan has intra-wave SPs touching same files.
  Edit plan.md to move one SP to a later wave, OR `--allow-overlap`
  (not recommended).
- **"current_phase < 30"**: finish Phase 10/20/30 gates via
  `matilha attest` first. Run `matilha howl` to see what's pending.
- **"uncommitted changes"**: commit or stash before running hunt.

<!-- MATILHA_MANAGED_END -->
