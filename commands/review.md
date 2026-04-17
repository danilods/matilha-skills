---
name: review
description: Phase 50 — Quality gate. Orchestrate review agents (bugs, security, tests, silent-failures, simplifier, methodology).
argument_hint: (none)
---

Execute the `matilha-review` skill to conduct multi-agent review.

If `/code-review` plugin is detected (Claude Code), delegates to it + runs Matilha-native agents in parallel for security, methodology, silent-failures. Output consolidated to `docs/matilha/reviews/YYYY-MM-DD-wave-N-review.md`.
