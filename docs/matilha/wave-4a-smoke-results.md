# Wave 4a Smoke Test Results

**Date:** 2026-04-19
**Branch (matilha-skills):** `wave-4a-plugin` at `d8473be` (+ T4.x landing on matilha repo)
**Matilha CLI tests:** 437/437 passing (baseline 398 + 44 new Wave 4a validation tests - 5 obsolete manifest tests = 437)
**Platform:** macOS 24.4.0 (local dev); Claude Code plugin marketplace test deferred to post-ship manual validation by Danilo.

## Structural smoke (automated)

| Artifact | Status | Notes |
|---|---|---|
| `.claude-plugin/plugin.json` | ✅ | parses; name=matilha; version=0.4.0; keywords include `matilha` + `cross-tool` |
| `.claude-plugin/marketplace.json` | ✅ | parses; name=matilha; version=0.4.0 |
| `gemini-extension.json` | ✅ | parses; contextFileName=GEMINI.md |
| `CLAUDE.md` + `GEMINI.md` + `AGENTS.md` | ✅ | slogan "You lead. Agents hunt." present in all 3 |
| 10 skills canonical | ✅ | all 10 have valid frontmatter + 12 required sections (`matilha-design` has 13 with Sources); all descriptions start with "Use when" |
| 9 commands thin wrappers | ✅ | 6 lines each, all delegate to `matilha:matilha-*` skill |
| 2 seed agents | ✅ | `matilha-code-architect` + `matilha-plan-reviewer` in `.claude-plugin/agents/` with valid frontmatter (name/description/tools/color) |
| 5 governance docs | ✅ | `docs/matilha/companions-contract.md` (60 lines), `skill-authoring-guide.md` (128), `naming-conventions.md` (47), `pack-authors.md` (91), `docs/platform-tool-mapping.md` (43) — all > 40 lines |
| Platform tool mapping | ✅ | references all 7 required tools (Task, Skill, Read, Write, Edit, Bash, TodoWrite) |

## Validation suite (matilha CLI repo)

- `npm test` → 437/437 green
- `npx tsc --noEmit` → clean
- 44 new validation tests added: 20 frontmatter schema + 10 description linter + 3 manifests + 3 context files + 2 agents + 5 docs + 1 tool mapping = 44 new

## Deferred: Claude Code plugin marketplace test

Full end-to-end "install from marketplace → /matilha-init → /matilha-plan" test is deferred to user-assisted manual validation by Danilo after merge, because:

1. The Claude Code plugin marketplace `/plugin install` flow requires interactive user action (accepting marketplace metadata).
2. Temporarily removing the matilha CLI from Danilo's PATH for a controlled "zero-CLI" test risks breaking his active development environment.
3. The structural guarantees above (manifests parse, skills validate, agents load) cover the plugin load path; runtime activation of skills follows Claude Code's Skill tool mechanics which are outside Matilha's runtime.

**Manual test plan** (Danilo to execute post-merge):
1. On a clean macOS user (or throwaway tmpdir with `mkdir /tmp/matilha-smoke-wave4a && cd /tmp/matilha-smoke-wave4a`), `/plugin install <local matilha-skills repo>`.
2. Restart Claude Code session.
3. Natural-language prompt: "Initialize Matilha in this empty project."
4. Expect: `matilha-init` skill auto-activates; archetype prompt surfaces; `project-status.md` + `CLAUDE.md` + `AGENTS.md` + `docs/matilha/` scaffolded.
5. Natural-language prompt: "What's the state?"
6. Expect: `matilha-howl` skill auto-activates; phase 0 surfaced; next_action suggested.
7. `which matilha` returns empty.

Document the result by extending this file.

## Risks flagged

- **Claude Code marketplace schema** for `.claude-plugin/marketplace.json` is evolving; the current shape (`name`, `displayName`, `description`, `author`, `category`, `version`, `license`, `repository`) is best-effort per superpowers reference. Pre-submission to marketplace should verify against Claude Code's authoritative docs at that time.
- **Cursor plugin system** is compatible with Claude Code's `.claude-plugin/plugin.json` per common knowledge, but not smoke-tested in this wave. Wave 4b should validate.
- **Codex CLI** requires `multi_agent = true` in `~/.codex/config.toml` for agent features; documented in `docs/platform-tool-mapping.md`. Users without this setting will see subagent-dependent skills fail.
- **Gemini CLI** extension flow (install via `gemini-extension.json`) not smoke-tested in this wave; deferred to Wave 4c or user validation.

## Conclusion

Wave 4a ships the plugin infrastructure. Runtime validation happens on first marketplace install (deferred by design — same pattern as superpowers v5.0.7 iterative release cycle).
