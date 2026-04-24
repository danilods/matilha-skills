---
wave: 5g
slug: wave-5g-unified-install
dispatched: 2026-04-24T00:00:00Z
sps: [SP-B, SP-A, SP-C]
merge_order: [SP-B, SP-A, SP-C]
---

# Wave 5g — status tracking

## Dispatch manifest

| SP | Description | Repo | Branch | Hours | Status |
|---|---|---|---|---|---|
| SP-B | CLAUDE.md snippet + contract | matilha-skills | wave-5g/sp-b-claudemd-snippet | 1 | merged |
| SP-A | `matilha install-plugins` CLI | matilha (CLI) | wave-5g/sp-a-install-plugins | 3-4 | merged |
| SP-C | `/matilha-install` wizard | matilha-skills | wave-5g/sp-c-matilha-install-wizard | 2 | merged |
| SP-D | compose Step 0 preflight dep-check | matilha-skills | (direct on main) | 0.5 | merged |

## Cross-SP contracts (locked in spec)

- Snippet content: `docs/matilha/templates/claude-matilha-snippet.md` (SP-B ships; SP-A bundles; SP-C embeds)
- Preset definitions: 4 presets (backend / ux / fullstack / security) — byte-identical across SP-A and SP-C
- `/plugin install` line format: 2 lines per pack (marketplace add + install with `--user`)
- Merge-or-create algorithm: 3 cases (absent / present-no-marker / present-with-marker); idempotent on re-run

## Exit gate

End-to-end smoke on fresh dir: `npm i -g matilha@1.2.0` → `matilha install-plugins --full --with-claudemd` → paste in Claude Code → new session → creative-work prompt → sigil first try.

## Progress log

- 2026-04-24 — Wave dispatched with 3 parallel agents.
- 2026-04-24 — All 3 parallel agents reported clean. SP-B (e019afb), SP-A (548942f on CLI), SP-C (19db62a).
- 2026-04-24 — Merges landed: matilha-skills main = 18ab7f0 (SP-B) → b35c107 (SP-C); matilha CLI main = 0104fa4 (SP-A). One CHANGELOG conflict resolved during SP-C merge (both SPs branched from main, not stacked).
- 2026-04-24 — SP-D added mid-wave per user insight: compose Step 0 preflight dep-check. Detects missing CLAUDE.md / priority-rule block, emits advisory notice pointing at /matilha-install. Committed a7d013b on matilha-skills main.
- 2026-04-24 — Validator suite 1482 tests green post-merge + post-compose-edit.
