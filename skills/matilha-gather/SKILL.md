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

# /gather — Post-Wave Merge

## Mission
After wave completion, merge SP worktrees in the defined `merge_order`, run the test suite to confirm no regressions, tag the wave, invoke `/review`, and clean up worktrees. Update project-status.md to record the completed wave.

## SoR Reference
Content of truth lives in:
- methodology/40-execucao.md (merge_order conventions, regression requirements, tagging format)

ALWAYS consult this page for latest merge and tag conventions.

## Preconditions
- `docs/matilha/waves/wave-NN-status.md` exists with all SPs at `status: completed`
- Current branch is the integration/wave branch (not an SP branch)
- No uncommitted changes on the current branch
- `merge_order` is defined in wave-NN-status.md

## Execution Workflow
1. Load wave-NN-status.md — confirm all SPs are `status: completed`; halt if any SP is `pending` or `in-progress`
2. Read `merge_order` from wave-NN-status.md; present merge sequence to user for confirmation
3. For each SP in merge_order: `git merge --no-ff wave-NN-sp-<name>` from integration branch; resolve conflicts if any (pause and ask user)
4. After all merges complete: run full test suite (`npm test` / `pytest` / per project convention); report pass/fail
5. If tests pass: create tag `wN-merged-YYYYMMDD` with annotation referencing wave-NN-status.md
6. Invoke `/review` with scope = wave branch; link resulting review report in project-status.md
7. Remove worktrees: `git worktree remove ../<project>-sp-<name>` for each SP
8. Update project-status.md: move wave from `active_waves` to `completed_waves`, set `current_phase: 50`

## Rules: Do
- Verify all SP statuses before starting any merge (fail early)
- Merge in `merge_order` exactly — do not reorder
- Run tests after every SP merge when possible (surface conflicts early rather than at the end)
- Tag before removing worktrees (tag is the permanent record)
- Record the review report path in project-status.md `feature_artifacts`

## Rules: Don't
- Don't merge an SP that is not `status: completed` in wave-NN-status.md
- Don't force-merge (`--no-verify`) without explicit user request and documented reason
- Don't remove worktrees before tagging
- Don't skip `/review` after merge — quality gate is non-negotiable
- Don't modify `methodology/*.md` (read-only SoR)

## Expected Behavior
- When a merge conflict occurs: pause, present the conflicting files, ask user for resolution strategy (accept-ours, accept-theirs, manual). Do not auto-resolve.
- If tests fail after a merge: report the failing tests, identify which SP introduced the failure, ask user how to proceed (revert SP, fix inline, or open blocker issue)
- When all SPs merged cleanly and tests pass, proceed with tag + cleanup without further prompts

## Quality Gates
- All SPs in wave-NN-status.md are `status: completed` before any merge begins
- Test suite passes after final merge
- Git tag `wN-merged-YYYYMMDD` exists and is annotated
- Review report exists at `docs/matilha/reviews/YYYY-MM-DD-wave-NN.md`
- Wave moved from `active_waves` to `completed_waves` in project-status.md
- All worktrees removed (verify with `git worktree list`)

## Companion Integration
- If `superpowers` detected: the `/review` step can delegate to `superpowers`-powered review agents for richer output; Matilha still requires the review report to be written to `docs/matilha/reviews/`
- If `impeccable` + frontend wave: run `/impeccable audit` before tagging; audit result links into review report
- If `shadcn-skills` + UI SPs: include component regression check in test suite requirements

## Output Artifacts
- Git tag `wN-merged-YYYYMMDD` (annotated, references wave-NN-status.md)
- `docs/matilha/reviews/YYYY-MM-DD-wave-NN.md` (review report from `/review`)
- Updated `project-status.md` (`completed_waves`, `current_phase: 50`, `feature_artifacts` with review link)
- Cleaned worktrees (all `../<project>-sp-<name>/` directories removed)

## Example Constraint Language
- Use "must" for: all-SPs-completed check, test suite run, tag creation before worktree removal
- Use "should" for: per-SP test runs during merge sequence, review before tag
- Use "may" for: squash merge strategy per SP if project prefers cleaner history

## Troubleshooting
- **"SP is not status: completed but developer says it's done"**: Ask developer to update wave-NN-status.md manually and confirm. Matilha won't merge until the file reflects completion.
- **"Merge conflict on every SP"**: SPs likely shared ownership of the same files. Revisit SP decomposition for Wave N+1. For now, resolve manually in merge_order sequence.
- **"Test suite command unknown"**: Ask user for the test command; persist it in `project-status.md` under `test_command` for future use.
- **"Tag already exists for today"**: Append a counter suffix: `wN-merged-YYYYMMDD-2`. Note the collision in project-status.md.
- **"Worktree removal fails"**: Check if the worktree path still has uncommitted changes. Ask user to commit or stash before removal.

<!-- MATILHA_MANAGED_END -->
