# Changelog

## [Wave 5d] — 2026-04-22 — Composition Layer

Make matilha core skills pack-aware orchestrators. Closes the Wave 5c smoke gap where `superpowers:brainstorming` intercepted creative-work prompts in matilha projects without companion-pack awareness.

### Added

- `skills/matilha-compose/SKILL.md` — new gateway skill (14 sections: 12 canonical + Pack awareness + Fallback semantics). Detects installed companion packs via plugin-namespace inspection (`matilha-*-pack` pattern), classifies user intent semantically, injects pack-aware preamble when dispatching to `superpowers:brainstorming`, routes to `matilha:matilha-plan` / `matilha:matilha-design` for explicit planning/design prompts.
- `CLAUDE.md` — new "CRITICAL — activation priority in matilha projects" section instructing the harness to invoke `matilha:matilha-compose` BEFORE `superpowers:brainstorming` in matilha projects. Backup plan per spec §11 risk #1 — was the final mechanism needed to win activation after skill-description strength alone proved insufficient.
- `docs/matilha/specs/wave-5d-composition-layer-spec.md` — design spec.
- `docs/matilha/plans/wave-5d-composition-layer-plan.md` — implementation plan (4 SPs + SP0 activation-gate spike).
- `docs/matilha/smoke-results/wave-5d-smoke.md` — smoke results and iteration history.

### Changed

- `skills/matilha-plan/SKILL.md` — Execution Workflow step 2 expanded from one-line brainstorming delegation to five-substep pack-aware block (detection + classification + preamble build + emit + fallback). Companion Integration cross-references `matilha-compose` as canonical template source.
- `skills/matilha-design/SKILL.md` — Execution Workflow restructured with explicit Pack detection (step 1) + Intent classification (step 2) + intent-based routing (step 3) + core-heuristics fallback (step 4). Companion Integration cross-references `matilha-compose`.
- `.claude-plugin/marketplace.json` — switched from flat schema to canonical `owner` + `metadata` + `plugins[]` shape matching `matilha-harness-pack`. Previous schema failed Claude Code's marketplace validator and blocked live install. `plugins[0].name` now `matilha` (matching `plugin.json`); install command: `/plugin install matilha@matilha-skills`.
- `index.json` — registered `matilha-compose` entry.

### Fixed

- Composition gap surfaced during Wave 5c smoke: `superpowers:brainstorming` intercepting creative-work prompts in matilha projects without companion-pack awareness. End-to-end flow now: compose wins activation (via CLAUDE.md priority) → detects packs dynamically via plugin-namespace inspection → classifies intent → dispatches enriched.

### Design decisions locked

- **Detection**: plugin-namespace pattern `matilha-*-pack` as sole signal. Zero hardcoded pack list in skill body. Self-healing — packs uninstalled disappear, new packs appear automatically.
- **Classification**: prose-semantic inline, no subagent dispatch, no keyword maps.
- **Preamble format**: per-pack synthesis + skill list + guidance paragraph (~30-40 lines). Emitted only when terminal destination is `superpowers:brainstorming`; compose routes to plan/design without preamble (those skills handle their own enrichment).
- **Activation priority**: dual-layer — skill description (competitive) + CLAUDE.md instruction (ambient, higher priority).

## [0.4.0] — 2026-04-19 — Wave 4a: Plugin Activation + Companion Contract

### Added

- `.claude-plugin/plugin.json` + `marketplace.json` — Claude Code and Cursor plugin manifests.
- `gemini-extension.json` — Gemini CLI extension.
- `CLAUDE.md` + `GEMINI.md` + `AGENTS.md` — context primers with the slogan "You lead. Agents hunt."
- `docs/matilha/companions-contract.md` — formal companion-pack detection + delegation contract.
- `docs/matilha/skill-authoring-guide.md` — strict frontmatter schema, description activation phrasing, 12-section body structure.
- `docs/matilha/naming-conventions.md` — skill/agent/command/pack prefix rules.
- `docs/matilha/pack-authors.md` — how to ship a companion pack.
- `docs/matilha/wave-4a-smoke-results.md` — structural smoke + deferred manual validation plan.
- `docs/platform-tool-mapping.md` — Claude Code ↔ Cursor ↔ Codex ↔ Gemini tool equivalents.
- `.claude-plugin/agents/matilha-code-architect.md` — seed agent; routes features through phases 10/20/30/40.
- `.claude-plugin/agents/matilha-plan-reviewer.md` — seed agent; audits draft plans against 7 quality gates.

### Changed

- All 10 core skills (`skills/matilha-*/SKILL.md`) rewritten with canonical frontmatter (name, description starting with "Use when", category, version) and 12-section body structure. Wave 2a/2f-era `MATILHA_MANAGED` markers and `## Mission` / `## SoR Reference` sections replaced with the new structure documented in `docs/matilha/skill-authoring-guide.md`.
- All 9 slash commands (`commands/*.md`) reduced to thin wrappers invoking their corresponding `matilha-*` skill. Each command body is ≤ 5 lines.
- README.md rewritten with Matilha-as-platform framing (companion packs, cross-platform install, interop with superpowers).

### Notes

- Zero changes to `matilha` CLI logic. The CLI repo drops 4 vestigial plugin stubs (`.claude-plugin/`, `.cursor-plugin/`, `.codex/`, `gemini-extension.json`) and 4 obsolete manifest tests as part of cleanup. CLI stays at 0.4.0.
- The plugin path is self-sufficient — no `npm install` required to use `/matilha-init`, `/matilha-plan`, `/matilha-hunt`, etc.
- Companion pack implementations (UX, growth, design, security, harness) deferred to Wave 5+.
- Matilha CLI test suite extended with 44 new validation tests (skill frontmatter schema, description linter, plugin manifests, context files, agent frontmatter, governance docs, tool mapping completeness). Final count: 437/437 green.
