---
description: "Phase 40 — merge completed SPs in wave order, run per-SP regression, update wave-status"
argument_hint: "<featureSlug>"
---

Invoke the `matilha:matilha-gather` skill. The skill handles Swiss Cheese pre-flight (SP-DONE gates, clean tree, integration branch check), per-SP merge `--no-ff`, regression, and wave-status bookkeeping. Flags: --wave <N>, --dry-run, --cleanup.
