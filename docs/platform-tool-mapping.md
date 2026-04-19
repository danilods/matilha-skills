# Platform Tool Mapping

> Skills reference Claude Code tool names. Use this mapping for other platforms.

## Master table

| Skill references              | Claude Code | Cursor   | Codex CLI                                           | Gemini CLI                    |
|------------------------------|-------------|----------|-----------------------------------------------------|-------------------------------|
| `Task` tool (dispatch agent) | `Task`      | `Task`   | `spawn_agent` + `wait` + `close_agent`              | subagent via natural prompt   |
| `Skill` tool (invoke skill)  | `Skill`     | `Skill`  | skills load natively — follow instructions         | `activate_skill`              |
| `Read`                       | `Read`      | `Read`   | native file tools                                   | native file tools             |
| `Write`                      | `Write`     | `Write`  | native file tools                                   | native file tools             |
| `Edit`                       | `Edit`      | `Edit`   | native file tools                                   | native file tools             |
| `Bash`                       | `Bash`      | `Bash`   | native shell                                        | native shell                  |
| `TodoWrite` (task tracking)  | `TodoWrite` | (varies) | `update_plan`                                       | (platform-specific)           |
| `WebFetch`                   | `WebFetch`  | `WebFetch` | native fetch tool                                 | native fetch tool             |

## Codex CLI: enabling subagent dispatch

Skills that use the Task tool (e.g., `matilha-code-architect`, `subagent-driven-development`) require multi-agent support. Add to `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
```

This enables `spawn_agent`, `wait`, and `close_agent`.

## Gemini CLI: skill activation

Gemini CLI loads skills metadata at session start via the extension's context file (`GEMINI.md`). Activation is explicit via `activate_skill` or by following skill instructions directly from the SKILL.md body.

## Cursor: plugin compatibility

Cursor's plugin system is compatible with the Claude Code plugin format (`.claude-plugin/plugin.json`). Hooks may need a Cursor-specific variant (`hooks/hooks-cursor.json` alongside `hooks/hooks.json`) if the formats diverge — Wave 4a does not ship hooks.

## When a skill mentions a tool not in this table

Skills use common-denominator Claude Code tool names. If a skill mentions something platform-specific (rare), the skill should explicitly cite `docs/platform-tool-mapping.md` and provide the fallback.

## Contributing

If your platform is not covered or a mapping is wrong, PR this file. The mapping is SoT for cross-platform behavior.
