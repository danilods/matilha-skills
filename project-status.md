---
schema_version: 1
name: matilha-skills
archetype: library
created: 2026-04-24T00:00:00Z
last_update: 2026-04-24T00:00:00Z
current_phase: 30
phase_status: complete
next_action: "Run /matilha-hunt wave-5h-max-activation — spec + plan ready, 2 SPs (SP-A routing table + SP-B 7 trigger skills) ready to dispatch."
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
  - docs/matilha/specs/wave-5h-max-activation-spec.md
  - docs/matilha/plans/wave-5h-max-activation-plan.md
recent_decisions:
  - "2026-04-24: Wave 5h approved — maximum deterministic pack activation via routing table (SP-A) + trigger skills (SP-B). Root causes: no CLAUDE.md on fresh install + non-deterministic LLM classification."
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

**Current phase:** 30 (Spec + plan ready — Wave 5h)

## Wave 5h — Maximum Deterministic Pack Activation (in planning)

Spec + plan artifacts written. Ready to hunt.

- **SP-A** — `skills/matilha-compose/routing-table.md` + compose Step 2 update (keyword lookup before LLM classification)
- **SP-B** — 7 trigger skills (one per pack, keyword-rich description, fires independently of compose)

Target version: matilha-skills `1.3.0`

---

## Wave 5g — Unified Install UX (shipped)

All 5 SPs merged to main. Ready to tag matilha-skills v1.2.0 + matilha CLI v1.2.0 and run end-to-end zero-paste smoke.

- **SP-B** — CLAUDE.md snippet + merge-or-create contract in `docs/matilha/templates/` ✅
- **SP-A** — `matilha install-plugins` CLI subcommand with 4 presets + clipboard + `--with-claudemd` flag (+16 SP-A tests) ✅
- **SP-C** — `/matilha-install` wizard with AskUserQuestion presets + CLAUDE.md bootstrap step ✅
- **SP-D** — compose Step 0 preflight dep-check (detects missing CLAUDE.md / priority rule, emits advisory notice) ✅
- **SP-E** — `--deep` zero-paste install: CLI runs `claude plugin install` per pack (execFile, idempotent, merge-or-create CLAUDE.md); wizard gains "Run it now" mode delegating to matilha CLI via Bash (+14 tests → 1496 total) ✅

Artifacts: `docs/matilha/specs/wave-5g-unified-install-spec.md`, `docs/matilha/plans/wave-5g-unified-install-plan.md`, `docs/matilha/waves/wave-5g-status.md`.
