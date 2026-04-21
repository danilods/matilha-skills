# Matilha Naming Conventions

> Prefix rules for skills, agents, commands, and companion packs.

## Skill prefixes

| Prefix        | Owner                       | Example                              |
|---------------|-----------------------------|--------------------------------------|
| `matilha-*`   | Matilha core                | `matilha-plan`, `matilha-hunt`       |
| `ux-*`        | `matilha-ux-pack`           | `ux-percepcao-visual`, `ux-krug`     |
| `growth-*`    | `matilha-growth-pack`       | `growth-aarrr`, `growth-jtbd-forces` |
| `design-*`    | `matilha-design-pack`       | `design-typography`, `design-color`  |
| `security-*`  | `matilha-security-pack`     | `security-threat-modeling`           |
| `harness-*`   | `matilha-harness-pack` (shipped 2026-04-21 v0.1.0) | `harness-architecture`, `harness-code-is-free` |
| `cog-*`       | `matilha-ux-pack` (shared)  | `cog-memoria-trabalho`               |
| `<author>-*`  | Community pack              | `acme-fintech-*`                     |

## Collision rules

- **One domain prefix per pack.** `matilha-ux-pack` owns `ux-*` and `cog-*`; no other pack claims those.
- Community pack authors pick an unclaimed prefix.
- Collisions resolved first-come-first-served; Matilha maintainers arbitrate disputes.

## Directory name must match skill name

`skills/matilha-plan/SKILL.md` must have `name: matilha-plan` in frontmatter. Strict match. Validator enforces.

## Agent names

Agents in `.claude-plugin/agents/` follow the same prefix rules:
- Matilha core agents: `matilha-*` (e.g., `matilha-code-architect`, `matilha-plan-reviewer`).
- Pack agents: `<domain>-*` (e.g., `ux-heuristic-auditor`, `growth-positioning-analyzer`).

## Command names

Slash commands in `commands/<name>.md` use bare names (no prefix) because the user types them directly:
- `/init`, `/scout`, `/plan`, `/hunt`, `/gather`, `/howl`, `/review`, `/den`, `/pack`, `/matilha-design`.

The body invokes the corresponding `matilha-*` skill. Commands with the `matilha-` prefix (e.g., `matilha-design`) follow the skill's own prefix for disambiguation when multiple plugins install commands with similar names.

## Reserved prefixes

These are reserved and community packs may NOT claim them:
- `matilha-*` (core)
- Matilha-owned domain prefixes listed in the table above

If you are writing a companion pack and need a prefix not on the reserved list, it is yours. Register it in this file via PR to keep the convention up-to-date.
