---
name: gather
description: Post-wave — merge worktrees, run regression, tag, cleanup.
argument_hint: (none)
---

Execute the `matilha-gather` skill to consolidate a completed wave.

Reads the most recent `docs/matilha/waves/wave-*-status.md` and processes all SPs in `merge_order`. Triggers `/review` after merge.
