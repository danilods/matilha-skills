---
schema_version: 1
name: matilha-skills
archetype: library
created: 2026-04-24T00:00:00Z
last_update: 2026-04-24T00:00:00Z
current_phase: 60
phase_status: released
next_action: "v1.2.0 shipped end-to-end (tags + GitHub releases + npm publish). Optional next: post-release smoke on fresh dir (Phase 2 of test plan), then plan Wave 5h or next deliverable."
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
  - "2026-04-24: SP-E added mid-wave — --deep zero-paste install — after research surfaced documented `claude plugin install` shell API + `/reload-plugins` hot-reload"
  - "2026-04-25: v1.2.0 released — matilha-skills + matilha CLI tagged + GitHub-released; matilha@1.2.0 published to npm registry"
pending_decisions:
  - "Optional: extend SP-D to actively offer bootstrap via AskUserQuestion instead of advisory notice (currently passive — user sees notice, must run /matilha-install manually)"
  - "Post-release smoke (Phase 2 of test plan): validate end-to-end on fresh dir + matilha@1.2.0 from npm"
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
