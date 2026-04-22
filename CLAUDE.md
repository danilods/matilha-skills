# Matilha — Cognitive + Methodological Harness

> **You lead. Agents hunt.**
> A harness for building complex projects with AI.

Matilha preserves discipline across multi-week projects by activating phase-appropriate skills automatically. The human stays in the decision seat (intent, gates, judgment); the agents execute (parallel worktrees, per-SP focus, gated output).

## How this loads in Claude Code

You are reading this because Matilha is installed as a plugin. The Skill tool will auto-invoke Matilha skills when their description matches user intent. If a skill's description says "Use when planning a feature", it fires when you detect that intent — you don't need to type anything special.

## CRITICAL — activation priority whenever matilha is installed

**In any workspace where matilha is installed (this skill `matilha:matilha-compose` is visible in your ambient skill list), before invoking `superpowers:brainstorming`, `superpowers:writing-plans`, or any other software-construction skill, you MUST first invoke `matilha:matilha-compose`.**

Matilha is a methodology wrapper around `superpowers:*` skills. It routes user intent through matilha phases (scout/plan/design/hunt/gather/review/howl) or dispatches to superpowers with pack-aware enrichment. Matilha runs standalone when superpowers is absent.

`matilha:matilha-compose` is the gateway — it classifies intent, detects installed companion packs, and dispatches to:
- **A matilha phase skill** (`matilha:matilha-plan`, `matilha:matilha-scout`, `matilha:matilha-design`, etc.) when the intent maps to a specific phase. No preamble — phase skills run their own pack-aware enrichment.
- **`superpowers:brainstorming`** for general creative exploration — with pack preamble when relevant packs are installed.
- **`superpowers:writing-plans`** when user has a spec and wants an implementation plan.

This priority exists because `superpowers:brainstorming` and similar skills have strong "MUST use before any creative work" triggers that win activation competition by default. In matilha-installed workspaces, composition (phase routing + pack enrichment) must run first. Compose then hands off — it never replaces the downstream craft work.

**Matilha does NOT require project bootstrap** — phase skills (matilha-plan, matilha-scout, etc.) lazy-create `docs/matilha/` structure and `project-status.md` on first write. You do not need to run matilha-init explicitly.

If `matilha:matilha-compose` is NOT visible in your skill list, matilha is not installed for this workspace — proceed with `superpowers:brainstorming` or other default skills directly.

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
