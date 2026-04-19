# Changelog

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
