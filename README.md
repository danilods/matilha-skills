# Matilha

> **You lead. Agents hunt.**
> A harness for building complex projects with AI.

Matilha is a cross-platform plugin for Claude Code, Cursor, Codex CLI, and Gemini CLI. It preserves discipline across multi-week projects by activating phase-appropriate skills automatically. The human stays in the decision seat (intent, gates, judgment); the agents execute (parallel worktrees, per-SP focus, gated output).

## Install

### Claude Code

Via the plugin marketplace (when published):

```
/plugin install matilha
```

Or locally during development:

```
/plugin install /path/to/matilha-skills
```

### Cursor

Same `/plugin install` flow — Cursor's plugin system is compatible with Claude Code's `.claude-plugin/plugin.json` format.

### Codex CLI

Codex loads skills natively from the plugin directory. Enable subagent features:

```toml
# ~/.codex/config.toml
[features]
multi_agent = true
```

Then point Codex at this repo as a skills source.

### Gemini CLI

Install as a Gemini extension using `gemini-extension.json` (this repo).

### Optional: TypeScript CLI

For CI, automation, or power-user determinism:

```bash
npm install -g matilha
```

The CLI and the plugin are in full parity. The plugin path is self-sufficient — no `npm install` required.

## Phases

| Phase | Purpose                      | Entry skill         | Slash command    |
|-------|------------------------------|---------------------|------------------|
| init  | Bootstrap new project        | `matilha-init`      | `/init`          |
| 0     | Project state + next action  | `matilha-howl`      | `/howl`          |
| 10    | Discovery / research         | `matilha-scout`     | `/scout`         |
| 20-30 | Spec + plan authoring        | `matilha-plan`      | `/plan`          |
| 40    | Wave dispatch                | `matilha-hunt`      | `/hunt`          |
| 40    | Wave merge                   | `matilha-gather`    | `/gather`        |
| 50    | Quality review (Wave 3c)     | `matilha-review`    | `/review`        |
| 60    | Knowledge capture            | `matilha-den`       | `/den`           |
| 70    | Reusable artifacts           | `matilha-pack`      | `/pack`          |
| any   | UX/UI design guidance        | `matilha-design`    | `/matilha-design`|

## Companion packs

Matilha core stays lean (10 skills, 2 agents). Domain expertise lives in companion packs the user installs separately:

- **[matilha-ux-pack](https://github.com/danilods/matilha-ux-pack)** (shipped 2026-04-19 v0.1.0) — 22 UX + cognitive skills from Weinschenk, Krug, and neuroscience research. The first shipped companion pack and reference implementation for future packs.
- **[matilha-growth-pack](https://github.com/danilods/matilha-growth-pack)** (shipped 2026-04-19 v0.1.0) — 20 growth + product-strategy skills from AARRR, JTBD, positioning, behavioral frameworks, pricing, and retention canon. Second shipped pack; complements matilha-ux-pack at product/business strategy level.
- **[matilha-harness-pack](https://github.com/danilods/matilha-harness-pack)** (shipped 2026-04-21 v0.1.0) — 22 harness-engineering skills from Anthropic harness/agentic/context/evals + OpenAI Codex agent-centric + Lopopolo operational rituals. Third shipped pack; complements ux + growth at agent architecture and team operations level.
- **[matilha-sysdesign-pack](https://github.com/danilods/matilha-sysdesign-pack)** (shipped 2026-04-23 v0.1.0) — 19 system-design skills from Zhiyong Tan's *Acing the System Design Interview* (NFRs, scalability, CDN, Kafka, design cases, 50-min interview flow, tradeoff framing). Fourth shipped pack; complements ux + growth + harness at distributed-systems and infrastructure level.
- **[matilha-software-eng-pack](https://github.com/danilods/matilha-software-eng-pack)** (shipped 2026-04-23 v0.1.0) — 15 software-engineering skills distilled from Danilo-experience rules (KISS anti-overengineering, RORO pattern, Pythonic idioms, README/CHANGELOG discipline, commits + session checklists, @TODO + progresso tracking, critical analysis structure). Fifth shipped pack and first Caminho C (opinions-from-practice) pack; complements ux + growth + harness + sysdesign at day-to-day coding discipline level.
- `matilha-software-arch-pack` (Wave 5h+, deferred) — hexagonal, clean architecture, DDD, layering (requires wiki ingestion of Uncle Bob + Evans + Cockburn).
- `matilha-security-pack` (deferred) — threat modeling, OWASP, secrets, dependency audit (requires OWASP + Shostack wiki ingestion).

Packs are detected automatically — Matilha core skills delegate when available, fall back to core heuristics when absent. Write your own pack via [`docs/matilha/pack-authors.md`](docs/matilha/pack-authors.md).

## Interop with superpowers

If [`obra/superpowers`](https://github.com/obra/superpowers) is installed, Matilha delegates to:

- `superpowers:brainstorming` during spec authoring.
- `superpowers:writing-plans` during plan generation.
- `superpowers:executing-plans` inside each wave worktree.
- `superpowers:dispatching-parallel-agents` for the quality review step (Wave 3c).

Matilha provides the harness (phases, worktree isolation, disjunction gates, wave-status bookkeeping); superpowers drives the actual execution.

## Docs

- [`docs/matilha/skill-authoring-guide.md`](docs/matilha/skill-authoring-guide.md) — how to write a Matilha-compatible skill.
- [`docs/matilha/naming-conventions.md`](docs/matilha/naming-conventions.md) — prefix rules for skills, agents, commands.
- [`docs/matilha/companions-contract.md`](docs/matilha/companions-contract.md) — how pack detection + delegation works.
- [`docs/matilha/pack-authors.md`](docs/matilha/pack-authors.md) — ship your own pack.
- [`docs/platform-tool-mapping.md`](docs/platform-tool-mapping.md) — Claude Code ↔ Cursor ↔ Codex ↔ Gemini tool equivalents.
- [`methodology/`](methodology/) — source of record for Matilha's 0-70 phase methodology.

## Version

0.4.0 (2026-04-19). Tagged `wave-4a-plugin`. Paired with `matilha` CLI 0.4.0.

## License

MIT © Danilo de Sousa
