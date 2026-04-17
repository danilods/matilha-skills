# matilha-skills

> Registry for [Matilha](https://github.com/danilods/matilha) — methodology pages, slash commands, and skills.

Content-only repo. Consumed by `matilha-cli` via `RegistryClient` that fetches `https://raw.githubusercontent.com/danilods/matilha-skills/main/index.json`.

**Status:** v0.1 — Wave 2a initial population.

## Structure

- `methodology/` — 11 pages describing the 8-phase methodology + transversal principles
- `commands/` — 9 slash commands (`/scout`, `/plan`, etc) for Claude Code / Codex / Cursor / Gemini CLI
- `skills/` — 10 skills following the 12-section blueprint (see [matilha](https://github.com/danilods/matilha)/DESIGN.md)
- `index.json` — master registry mapping slugs → file paths

## How content here is consumed

```
$ npx matilha list            # fetches index.json, shows available skills
$ npx matilha pull matilha-scout  # fetches skills/matilha-scout/SKILL.md
```

## Contributing

See `CONTRIBUTING.md`. TL;DR: skill changes must follow the 12-section blueprint; methodology changes must preserve frontmatter schema.

## License

MIT © Danilo de Sousa
