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
Decompose a plan artifact into waves and sub-projects (SPs), create git worktrees per SP, and dispatch parallel agent sessions. Matilha wraps wave-status bookkeeping around the dispatch mechanic, ensuring every SP has a tracked branch, a defined dependency order, and a completion criterion.

## SoR Reference
Content of truth lives in:
- methodology/40-execucao.md (wave decomposition rules, SP dependencies, worktree conventions)

ALWAYS consult this page for latest SP sizing and merge_order conventions.

## Preconditions
- Plan artifact exists: `docs/matilha/plans/*.md` or `docs/superpowers/plans/*.md`
- Git repo with worktree capability (`git worktree` available)
- `current_phase` in project-status.md is ≥ 30
- No uncommitted changes on current branch

## Execution Workflow
1. Load `methodology/40-execucao.md` — extract wave decomposition rules and SP sizing heuristics
2. Parse the plan artifact: identify waves, SPs per wave, inter-SP dependencies
3. Present wave breakdown to user for confirmation; adjust SP boundaries if user objects
4. Validate SP dependencies: detect circular deps, flag ambiguous ordering as blockers
5. For each SP in wave N: create branch `wave-NN-sp-<name>` and worktree at `../<project>-sp-<name>/`
6. Write `docs/matilha/waves/wave-NN-status.md` with: SP list, branch names, merge_order, status=pending for each
7. Invoke dispatch: if `superpowers` detected, delegate to `superpowers:dispatching-parallel-agents` for agent session creation; else print session-start instructions per SP
8. Update `project-status.md`: set `current_phase: 40`, append wave entry to `active_waves`

## Rules: Do
- Confirm wave breakdown with user before creating worktrees (worktree creation is hard to undo cleanly)
- Size SPs to ≤1 day of focused work per `methodology/40-execucao.md` heuristics
- Write wave-NN-status.md before dispatching (ensures bookkeeping survives partial failures)
- Record merge_order explicitly — it drives `/gather` later
- Keep one wave active at a time unless user explicitly enables parallel waves

## Rules: Don't
- Don't create worktrees without confirming branch names with user
- Don't dispatch if any SP has an unresolved dependency cycle
- Don't advance current_phase to 40 before plan artifact exists and is confirmed
- Don't modify `methodology/*.md` (read-only SoR)
- Don't hardcode paths — derive worktree location from `git rev-parse --show-toplevel`

## Expected Behavior
- If plan has a single wave, skip wave numbering ceremony but still write wave-01-status.md
- When user wants fewer SPs ("just one big task"), respect it — Matilha's role is to enable parallelism, not enforce it
- If worktree creation fails (branch exists, path conflict), report precisely and offer resolution options

## Quality Gates
- `docs/matilha/waves/wave-NN-status.md` exists for each active wave
- Every SP in wave-NN-status.md has: branch name, worktree path, status (pending/in-progress/completed), merge_order index
- `active_waves` in project-status.md references wave-NN-status.md
- No circular SP dependencies in merge_order
- `current_phase` is 40 in project-status.md

## Companion Integration
- If `superpowers` detected: delegate parallel agent dispatch to `superpowers:dispatching-parallel-agents`; Matilha provides wave-status.md as the shared state artifact between sessions
- If `impeccable` + frontend SPs: add Impeccable audit step as the final gate in relevant SP completion criteria
- If `shadcn-skills` + UI SPs: inject shadcn component list from registry into SP context before dispatch

## Output Artifacts
- `docs/matilha/waves/wave-NN-status.md` (SP list, branch names, merge_order, status per SP)
- N git worktrees at `../<project>-sp-<name>/` (one per SP)
- N git branches `wave-NN-sp-<name>` (one per SP)
- Updated `project-status.md` (`current_phase: 40`, `active_waves`)

## Example Constraint Language
- Use "must" for: wave-NN-status.md existence before dispatch, circular dep validation
- Use "should" for: SP sizing ≤1 day, single active wave default
- Use "may" for: parallel waves when user explicitly enables, custom worktree paths

## Troubleshooting
- **"Branch already exists"**: Check if it's a leftover from a prior attempt. Offer: delete+recreate, rename, or attach existing branch to new worktree.
- **"Plan has no clear wave structure"**: Ask user to identify a natural first deliverable (vertical slice). That becomes Wave 01. Remaining work is Wave 02+.
- **"Git worktree not supported"**: Confirm `git version` ≥ 2.15. If unsupported environment, fall back to sequential branches without worktrees; document limitation in wave-NN-status.md.
- **"User wants to skip decomposition and code directly"**: Respect choice. Create a single SP for the entire plan, write minimal wave-01-status.md, dispatch as one session.
- **"Circular dependency detected"**: Present the cycle graph to user. Ask which dependency to break; log the decision in project-status.md `recent_decisions`.

<!-- MATILHA_MANAGED_END -->
