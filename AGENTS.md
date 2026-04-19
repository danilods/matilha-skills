# Matilha — Cognitive + Methodological Harness

> **You lead. Agents hunt.**
> A harness for building complex projects with AI.

Matilha preserves discipline across multi-week projects by activating phase-appropriate skills automatically. The human stays in the decision seat (intent, gates, judgment); the agents execute (parallel worktrees, per-SP focus, gated output).

## How this loads in Codex (and for contributors)

You are reading this because Matilha is available. On Codex CLI, skills load natively — when a skill's description matches user intent, follow its instructions. Some skills dispatch subagents; Codex requires `multi_agent = true` in `~/.codex/config.toml` for subagent features. See `docs/platform-tool-mapping.md` for exact Codex tool equivalents (spawn_agent / wait / close_agent, etc.).

For contributors authoring new skills: read `docs/matilha/skill-authoring-guide.md` before writing. Strict frontmatter is load-bearing — sloppy descriptions produce invisible skills.

## Phases (0-70)

Matilha organizes work across 8 phases. Each has a skill entry point.

| Phase | Purpose                          | Entry skill             |
|-------|----------------------------------|-------------------------|
| 0     | Project state + next action      | `matilha-howl`          |
| 10    | Discovery / research             | `matilha-scout`         |
| 20-30 | Spec + plan authoring            | `matilha-plan`          |
| 40    | Dispatch + merge (waves, SPs)    | `matilha-hunt`, `matilha-gather` |
| 50    | Quality review                   | `matilha-review` (Wave 3c planned) |
| 60    | Knowledge capture                | `matilha-den`           |
| 70    | Reusable artifacts               | `matilha-pack`          |
| init  | Bootstrap new project            | `matilha-init`          |
| design| UX/UI guidance (cross-phase)     | `matilha-design`        |

See `docs/matilha/naming-conventions.md` for skill prefix rules and `docs/matilha/companions-contract.md` for how companion packs (UX, growth, design, security, harness) plug in.

## Companion detection

If companion packs are installed (e.g., `matilha-ux-pack`, `matilha-growth-pack`), their skills auto-register via the Skill tool. Core Matilha skills delegate when a matching companion skill is available, with graceful fallback when absent. No package installation happens at runtime — packs are chosen by the user via their plugin marketplace.

## Tool mapping

Skills reference Claude Code tool names (Task, Skill, Read, Write, Edit, Bash, TodoWrite). Other platforms: see `docs/platform-tool-mapping.md`.

## Deterministic engine (optional)

Matilha also ships as a TypeScript CLI (`matilha` via npm). Skills mention `matilha <command>` as an optional shortcut when the CLI is on PATH. The plugin path is self-sufficient — no CLI required.

## Links

- `README.md` — project overview
- `CHANGELOG.md` — recent changes
- `docs/matilha/` — companion contract, style guide, naming conventions, pack-author guide
- `methodology/` — methodology source of record (phases 0-70)
- `skills/` — skill definitions (auto-discovered by Claude Code)
- `commands/` — slash-command entry points
- `.claude-plugin/agents/` — named agents (matilha-code-architect, matilha-plan-reviewer)
