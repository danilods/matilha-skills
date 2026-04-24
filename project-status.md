---
schema_version: 1
name: matilha-skills
archetype: library
created: 2026-04-24T00:00:00Z
last_update: 2026-04-24T00:00:00Z
current_phase: 60
phase_status: ready_for_release
next_action: "Wave 5g shipped (SP-B + SP-A + SP-C + SP-D + SP-E). Tag matilha-skills v1.2.0 + matilha CLI v1.2.0, publish npm, run end-to-end zero-paste smoke on fresh dir."
tools_detected: [node, pnpm, git]
companion_skills:
  impeccable: not_installed
  shadcn: not_installed
  superpowers: installed
  typeui: not_installed
active_waves: []
completed_waves:
  - wave-5g-unified-install
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
  - "2026-04-24: SP-D added mid-wave — compose Step 0 preflight dep-check — after user flagged that installs on fresh projects leave CLAUDE.md empty and priority rule invisible"
pending_decisions:
  - "npm publish of matilha@1.2.0 requires 2FA OTP from user"
  - "Optional: extend SP-D to actively offer bootstrap via AskUserQuestion instead of advisory notice (currently passive — user sees notice, must run /matilha-install manually)"
blockers: []
aesthetic_direction: null
design_locked: true
---

# matilha-skills — project status

**Current phase:** 60 (Den — Wave 5g shipped, release prep pending)

## Wave 5g — Unified Install UX (shipped)

All 5 SPs merged to main. Ready to tag matilha-skills v1.2.0 + matilha CLI v1.2.0 and run end-to-end zero-paste smoke.

- **SP-B** — CLAUDE.md snippet + merge-or-create contract in `docs/matilha/templates/` ✅
- **SP-A** — `matilha install-plugins` CLI subcommand with 4 presets + clipboard + `--with-claudemd` flag (+16 SP-A tests) ✅
- **SP-C** — `/matilha-install` wizard with AskUserQuestion presets + CLAUDE.md bootstrap step ✅
- **SP-D** — compose Step 0 preflight dep-check (detects missing CLAUDE.md / priority rule, emits advisory notice) ✅
- **SP-E** — `--deep` zero-paste install: CLI runs `claude plugin install` per pack (execFile, idempotent, merge-or-create CLAUDE.md); wizard gains "Run it now" mode delegating to matilha CLI via Bash (+14 tests → 1496 total) ✅

Artifacts: `docs/matilha/specs/wave-5g-unified-install-spec.md`, `docs/matilha/plans/wave-5g-unified-install-plan.md`, `docs/matilha/waves/wave-5g-status.md`.
