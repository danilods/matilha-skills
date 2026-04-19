---
description: "Phase 50 — 6-agent parallel quality review of a completed wave (Wave 3c)"
argument_hint: "<featureSlug>"
---

Invoke the `matilha:matilha-review` skill. Dispatches 6 reviewer roles (code-quality, UX, security, architecture, performance, docs) via `superpowers:dispatching-parallel-agents` when available; otherwise runs them sequentially. Writes `docs/matilha/reviews/<date>-wave-NN-review.md`.
