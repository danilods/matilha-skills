---
schema_version: 1
name: matilha-skills
archetype: library
created: 2026-04-24T00:00:00Z
last_update: 2026-04-24T00:00:00Z
current_phase: 40
phase_status: in_progress
next_action: "Wave 5g in parallel dispatch (SP-B, SP-A, SP-C)"
tools_detected: [node, pnpm, git]
companion_skills:
  impeccable: not_installed
  shadcn: not_installed
  superpowers: installed
  typeui: not_installed
active_waves:
  - slug: wave-5g-unified-install
    status: dispatched
    started: 2026-04-24T00:00:00Z
    sps: [SP-B, SP-A, SP-C]
completed_waves:
  - wave-3a-hunt-runtime
  - wave-3b-gather-runtime
  - wave-4a-plugin-activation
  - wave-5a-ux-pack
  - wave-5b-growth-pack
  - wave-5c-harness-pack
  - wave-5d-composition-layer
  - wave-5d1-pivot-methodology-first
  - wave-5e-sysdesign-pack
  - wave-5f-software-eng-pack
  - v1.0.0-release
  - v1.1.0-polish-release
feature_artifacts:
  - docs/matilha/specs/wave-5g-unified-install-spec.md
  - docs/matilha/plans/wave-5g-unified-install-plan.md
recent_decisions:
  - "2026-04-24: A+C approved for unified install, option 3 (SP-B first) to address CLAUDE.md bootstrap gap"
pending_decisions: []
blockers: []
aesthetic_direction: null
design_locked: true
---

# matilha-skills — project status

**Current phase:** 40 (Hunt — parallel dispatch for Wave 5g)

## Wave 5g — Unified Install UX

3 SPs dispatched in parallel:

- **SP-B** — CLAUDE.md snippet + merge-or-create contract (matilha-skills, ~1h, merges first)
- **SP-A** — `matilha install-plugins` CLI subcommand (matilha CLI, ~3-4h)
- **SP-C** — `/matilha-install` wizard upgrade (matilha-skills, ~2h)

See `docs/matilha/plans/wave-5g-unified-install-plan.md` and `docs/matilha/waves/wave-5g-status.md`.
