---
name: matilha-gather
description: Post-wave — merge worktrees in merge_order, run regression, tag wave-complete, cleanup.
metadata:
  author: matilha
  phase: "40"
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /gather — Phase 40 (Post-Wave Merge)

## Mission

Close the execution loop opened by `/hunt`. After every SP in a wave has
a filled SP-DONE.md, `/gather` validates the completion gates, merges
each SP branch into the integration branch in the declared `merge_order`,
runs the test suite after every merge to localize regressions, and
updates `wave-NN-status.md` with per-SP + overall state.

Scaffolder only. No auto-`/review`, no phase advancement, no tagging.
HALT on any failure — Matilha never rolls back on the user's behalf.

## SoR Reference

- `methodology/40-execucao.md` — Phase 40 execution including /hunt and
  /gather conventions (merge_order, regression, cleanup, SP-DONE contract).

Consult this page for the canonical SP-DONE shape and merge discipline.

## Preconditions

- `docs/matilha/waves/wave-NN-status.md` exists and parses cleanly
  against `waveSchema`.
- Current branch is an integration branch (not an SP branch `wave-NN-sp-*`).
- No uncommitted changes on the current branch.
- For each SP in `merge_order` whose status is `pending` or `in_progress`:
  `<worktree>/SP-DONE.md` exists and passes strict gates.

### SP-DONE Contract (strict gates)

Each `<worktree>/SP-DONE.md` MUST have frontmatter matching:

```yaml
---
type: sp-done
sp_id: SP<N>                   # must match the expected SP id
feature: <slug>                # must match the gather featureSlug
wave: w<N>                     # must match the target wave id
status: completed              # STRICT: exactly "completed"
completed_at: <ISO8601 UTC>    # non-null
commits: [<sha>, ...]          # non-empty array
tests:
  passed: true                 # STRICT: exactly true
  count: <positive integer>    # >= 1
---
```

Any violation halts pre-flight before any merge runs.

## Execution Workflow

1. **Pre-flight (Swiss Cheese — all-or-nothing)**:
   - Read wave-NN-status.md; validate against `waveSchema`.
   - Refuse on SP branch.
   - Refuse on dirty tree.
   - For each SP not yet merged: validate SP-DONE.md against strict gates.
2. **Dry-run (if --dry-run)**: print merge plan; zero mutation; exit 0.
3. **Per-SP loop (in `merge_order`)**:
   - Skip SPs whose `status: completed` (resume-safe).
   - `git merge --no-ff <branch>` from the integration branch.
   - Conflict → `git merge --abort` + HALT with 5-rule error + mark SP failed.
   - Run test command (default `npm test`) in the integration repo.
   - Test failure → HALT + mark SP failed + recovery info in error.
   - Mark SP `completed` in wave-status.
4. **Finalization**: mark wave `completed`, `regression_status: passed`,
   `ended: <iso-now>`.
5. **Optional cleanup (if --cleanup)**: for each merged SP,
   `git worktree remove --force <path>` + `git branch -d <branch>`.
   Refuses to delete unmerged branches (uses safe `-d`, not `-D`).

## Rules: Do

- Run `matilha gather <slug>` with no flags for the latest wave
  (defaults to --wave 1; pass --wave N for explicit).
- Pass `--dry-run` first when gathering an unfamiliar wave.
- Use `--cleanup` only when you are confident the SPs will not need
  revisiting on the same branches.
- Resolve merge conflicts by editing the plan (move the overlap to a
  later wave, re-run /hunt) rather than force-merging by hand.
- Commit `wave-NN-status.md` after each /gather invocation so the
  working tree stays clean for the next run.

## Rules: Don't

- Don't run `/gather` from an SP branch — it merges INTO the integration
  branch, so you must be on it.
- Don't retry `/gather` on a wave in `status: failed` without first
  resetting the failed SP's entry back to `pending` (human decision).
- Don't expect `/gather` to call `/review` — review is Wave 3c's job.
- Don't expect `/gather` to advance `current_phase` — attest that via
  `matilha attest phase-40-gate` when you're ready.

## Expected Behavior

- A wave that completes cleanly ends with `wave-NN-status.md` at
  `status: completed, regression_status: passed, ended: <iso>`.
- A wave that halts preserves all partial state for inspection.
- Re-running `/gather` on a completed wave is a no-op.
- Per-SP regression makes "which merge broke tests" obvious (the
  failing SP is the one just merged).

## Quality Gates

- All SPs in wave-status have `status: completed` before wave is marked
  completed.
- Test suite passes after every merge (not just at the end).
- `wave-NN-status.md` always round-trips through `waveSchema` between
  updates (file on disk is always valid).
- `.gitignore` unchanged by /gather (hunt owns it).
- `current_phase` unchanged by /gather (attest owns it).

## Companion Integration

- **superpowers detected** → no special behavior in /gather itself;
  review and rollback decisions belong to /review (Wave 3c) and the
  user. If superpowers is present, consider running
  `superpowers:executing-plans` inside each worktree during `/hunt` so
  SP-DONE.md gets filled cleanly — that is /hunt's territory.
- **impeccable + frontend SPs** → audit step belongs to /review.
- **shadcn-skills** → component regression belongs to the per-SP tests.

## Output Artifacts

- Updated `docs/matilha/waves/wave-NN-status.md`:
  `status: completed | failed`, `regression_status: passed | failed`,
  `started`, `ended`, per-SP `status: completed | failed`.
- N merge commits on the integration branch (one per SP, `--no-ff`).
- (Optional, with `--cleanup`) worktrees removed + branches deleted for
  SPs whose status is `completed`.

## Example Constraint Language

- Use "must" for: wave-status validates against `waveSchema` before any
  merge; current branch is not an SP branch; working tree is clean;
  every SP-DONE.md passes strict gates before the per-SP loop starts.
- Use "should" for: running `--dry-run` before the first `/gather` on
  a wave; reviewing the recovery commands in any 5-rule error before
  running them; waiting to pass `--cleanup` until the wave is settled;
  committing `wave-NN-status.md` after each gather.
- Use "may" for: `--cleanup` (opt-in by design); resetting a failed
  SP's status entry back to `pending` after manual recovery to resume
  the wave.

## Troubleshooting

- **"wave-NN-status.md not found"**: run `matilha hunt <slug> --wave N`
  first to dispatch the wave.
- **"SP-DONE.md has status=pending"**: the SP author did not finish or
  did not update the frontmatter. Ask them, or re-dispatch the SP with
  `matilha hunt <slug> --force --wave N`.
- **"merge conflict"**: the plan's intra-wave disjunction check was
  bypassed (via `--allow-overlap`) or the SPs drifted post-hunt. Edit
  the plan to move one SP to a later wave, then re-run `/hunt --force`.
- **"regression failed after merge"**: the SP introduced a regression
  the local tests did not catch. Revert via `git reset --hard <sha>`
  (the SHA is in the error output), fix the regression, and re-run
  `/gather`.
- **"on SP branch"**: `git checkout main` (or your integration branch)
  before retrying.
- **"already gathered — no-op"**: the wave is already at
  `status: completed`. Nothing to do.
- **"uncommitted changes" when trying to resume**: `/gather` leaves
  `wave-NN-status.md` modified after each run. Commit it
  (`git add docs/matilha/waves && git commit -m "chore: wave N status"`)
  before re-running gather.

<!-- MATILHA_MANAGED_END -->
