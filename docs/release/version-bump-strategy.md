---
title: Matilha v1.0.0 — Version Bump Strategy
date: 2026-04-21
status: recommendation (pending Danilo's call)
scope: 6 repos (core plugin + CLI + 5 packs)
---

# Matilha v1.0.0 — Version Bump Strategy

v1.0.0 is a narrative moment (first official ecosystem release) AND a semver event (breaking-change contract established). This doc reconciles the two and recommends a concrete versioning plan.

---

## 1. Current state (as of 2026-04-21)

| Repo | Current version | Latest tag | Shipped once? |
|---|---|---|---|
| `matilha-skills` (core plugin) | `0.4.0` | `wave-5d1-storytelling` | yes — continuous since Wave 4a |
| `matilha` (CLI) | `0.4.0` | `wave-3b-complete` | locally yes; npm: no |
| `matilha-ux-pack` | `0.1.0` | `wave-5a-ux-pack-0.1.0` | yes (Wave 5a) |
| `matilha-growth-pack` | `0.1.0` | `wave-5b-growth-pack-0.1.0` | yes (Wave 5b) |
| `matilha-harness-pack` | `0.1.0` | `wave-5c-harness-pack-0.1.0` | yes (Wave 5c) |
| `matilha-sysdesign-pack` | `0.1.0` | `wave-5e-sysdesign-pack-0.1.0` | yes (Wave 5e) |
| `matilha-software-eng-pack` | `0.1.0` | `wave-5f-software-eng-pack-0.1.0` | yes (Wave 5f) |

**Observation**: each companion pack has shipped **exactly once** (its 0.1.0 cut). Core + CLI have shipped continuously across 6+ waves.

---

## 2. The semver question

> Under semver, `1.0.0` signals "the public API is now stable; breaking changes require a major bump". Should v1.0.0 apply only to core, or to every repo?

There are three positions. I'll argue each then recommend.

### Position 1 — Synchronize everything to `1.0.0`

**Pro**:
- Narrative coherence. "Matilha v1.0.0" reads cleanly when every repo tags `v1.0.0` on the same day.
- Marketing-friendly for the announcement. One version number, one announcement.
- Zero user confusion at install time.

**Con**:
- **Dishonest semver.** A pack that has shipped exactly once does not have a stable public API — users have had no opportunity to depend on its skill names, descriptions, or body shapes through breaking changes. `1.0.0` implies "we've been at `0.x` long enough that patterns have settled". The packs haven't.
- Forces every pack into a major bump for any future skill rename (semver: renames = breaking). Overhead for a pack that's still iterating.
- Sets a precedent: when pack #6 ships at `0.1.0`, does it also bump to `1.0.0` immediately? Awkward.

### Position 2 — Core `1.0.0`, packs stay `0.1.x`

**Pro**:
- **Honest semver.** Core has shipped across 7 waves; patterns (skill authoring, composition contract, SessionStart hook) have stabilized. Packs haven't iterated enough to claim stability.
- Future pack changes (new skills, renames) can be minor/patch within `0.x` without fanfare.
- Aligns with how many ecosystem tools version (core stable, plugins own their cadence).

**Con**:
- Narrative cost: "Matilha v1.0.0" is real for core but the packs look pre-release. Some users hesitate to install `0.1.0`.
- Announcement needs a paragraph explaining the versioning asymmetry.

### Position 3 — Core `1.0.0`, packs bump to `0.2.0` (minor, not major)

**Pro**:
- Signals movement without overclaiming stability.
- Allows packs to add a "v1.0.0 compatibility" milestone in their CHANGELOG without claiming API stability.
- Lower semver risk than Position 1.

**Con**:
- Still requires a reason to bump. If nothing functionally changed in a pack since its 0.1.0, a 0.2.0 bump for "v1.0.0 alignment" is cosmetic.
- Adds noise to the ecosystem version grid.

---

## 3. Recommendation

**Primary recommendation: Position 2 (honest semver).**

Core `matilha-skills` + `matilha` CLI → `1.0.0`.
Packs stay at `0.1.0` (possibly `0.1.1` if cleanup commits land between now and the tag — see checklist blockers).

Rationale:
- Semver is a technical contract. `1.0.0` on a pack that shipped 5 days ago is misleading.
- The announcement carries the narrative work. The packs don't need to bump to participate.
- Future pack iteration (Wave 5g B-packs, potential 5h/5i) can land naturally at `0.2.0+` without forced major bumps.

**Alternative if Danilo prefers narrative synchronicity: Position 3.** Packs bump to `0.2.0` with a CHANGELOG entry that says "v1.0.0 ecosystem alignment; no functional changes to skills". Not semver-ideal but not dishonest. Avoid Position 1 unless Danilo is comfortable calling skill renames "major bumps" forever.

---

## 4. Concrete bump plan (Position 2)

### matilha-skills (core)

- `.claude-plugin/plugin.json` `version`: `0.4.0` → `1.0.0`
- `.claude-plugin/marketplace.json` `metadata.version` + `plugins[0].version`: `0.4.0` → `1.0.0`
- `CHANGELOG.md`: add `## [1.0.0] — 2026-XX-XX — First official release` entry (see §7 template)
- Tag: `v1.0.0` on the bump commit

### matilha (CLI)

- `package.json` `version`: `0.4.0` → `1.0.0`
- CHANGELOG: add `## [1.0.0]` entry
- Tag: `v1.0.0`
- `npm publish` **after** the tag lands + advisor sanity-check

### Companion packs (no version change unless Position 3 chosen)

If any cleanup commits land (overlap disclosures, README consistency) before the v1.0.0 cut:
- Patch-bump the affected pack: `0.1.0` → `0.1.1`
- Update marketplace.json + plugin.json + CHANGELOG
- New tag: `vX.Y.Z` (e.g., `v0.1.1`) OR continue the wave-indexed pattern (`wave-5a-ux-pack-0.1.1`) — recommendation: move to pure semver tags post v1.0.0.

If no cleanup lands, packs stay at `0.1.0` with their existing wave tags.

---

## 5. Future pack-update cadence (post v1.0.0)

After v1.0.0, how should packs + core version going forward?

### Core (matilha-skills + matilha CLI)

Follow standard semver:
- **Patch** (`1.0.x`) — bug fixes, non-breaking internal changes, docs.
- **Minor** (`1.x.0`) — new skills (backward-compatible), new methodology phases, new opt-in features.
- **Major** (`x.0.0`) — renames of skills users depend on, removal of skills, breaking companion-contract changes.

### Companion packs

Once any pack crosses `1.0.0` (i.e., when Danilo decides its skill set is stable):
- **Patch** — body edits, typo fixes, minor paraphrase tightening.
- **Minor** — new skills added (no renames / removals).
- **Major** — renaming or removing skills (breaks user muscle memory + invalidates `Complementa` cross-pack refs).

While packs remain `0.x`:
- Anything goes; increment minor for visible changes, patch for fixes.
- The Wave 5b discipline for cross-pack overlap disclosure is itself a de-facto contract — if a renamed skill breaks another pack's `Complementa` reference, that's a patch on both packs in the same release.

### Suggested cadence

- **Monthly** — patch releases per repo where active work happens.
- **Per wave** — minor bumps (new skills).
- **Pre-announced** — major bumps. Deprecation warning → one minor later → major.

---

## 6. Release notes format going forward

Adopt a consistent CHANGELOG section header across all 6 repos:

```markdown
## [X.Y.Z] — YYYY-MM-DD — <concise title>

<1-2 sentence framing>

### Added

- ...

### Changed

- ...

### Fixed

- ...

### Deprecated

- ...

### Removed

- ...

### Cross-repo references

- If this release pairs with core `X.Y.Z` — note it.
- If this release requires a matilha-core minimum version — state it.
```

Wave labels (e.g., "Wave 5f — matilha-software-eng-pack shipped") remain valuable as narrative context but should live inside the section body, not in the section title. The section title uses pure semver `[X.Y.Z]` for programmatic parsing.

---

## 7. v1.0.0 CHANGELOG template (for matilha-skills)

```markdown
## [1.0.0] — 2026-XX-XX — First official ecosystem release

Matilha v1.0.0 marks the first official release of the methodology harness + its companion-pack composition layer. 109 skills across 6 plugins (11 core + 98 pack). Cross-tool: Claude Code, Cursor, Codex, Gemini.

### Ecosystem shipped

- **`matilha-skills` core plugin** (this repo) — 11 orchestration skills, SessionStart hook, composition layer via `matilha-compose`. v1.0.0.
- **`matilha` CLI** — deterministic engine, 1211 validation tests, shared registry. v1.0.0. npm publish pending.
- **Companion packs (5)**:
  - `matilha-ux-pack` v0.1.0 — 22 skills (Weinschenk + Krug + neuroscience)
  - `matilha-growth-pack` v0.1.0 — 20 skills (AARRR + JTBD + positioning + pricing)
  - `matilha-harness-pack` v0.1.0 — 22 skills (Anthropic + OpenAI Codex + Lopopolo)
  - `matilha-sysdesign-pack` v0.1.0 — 19 skills (Zhiyong Tan + NFRs)
  - `matilha-software-eng-pack` v0.1.0 — 15 skills (Danilo-experience rules)

### Composition layer (Wave 5d + 5d.1)

- `matilha-compose` gateway detects installed companion packs via plugin-namespace (`matilha-*-pack`) and routes brainstorming through pack-aware preamble.
- SessionStart hook injects activation priority into every matilha-installed workspace (cross-workspace availability).
- Storytelling-mode sigil (alpha wolf + pack dogs) + atmospheric line mirroring user's domain vocabulary when a relevant pack is installed.
- Default-EMIT rule: at least one relevant pack installed → emit sigil.

### Activation

- Install at user scope: `/plugin install matilha@matilha-skills --user`.
- SessionStart hook handles Claude Code, Cursor, and Copilot CLI environment branches.
- Skill activation is description-driven + bootstrap-primed; no slash commands required for routine use.

### Known gaps

- `matilha-review` runtime (Wave 3c) — skill stub exists; the six-agent parallel quality-review loop is not yet shipped.
- CLI is not yet npm-published (tagged locally at v1.0.0 post-release-cut).

### Versioning note

Core plugins (`matilha-skills`, `matilha` CLI) bump to 1.0.0 with this release. Companion packs remain at 0.1.0 to honestly reflect their iteration stage (each pack has shipped exactly once); future pack updates will follow their own semver cadence. See `docs/release/version-bump-strategy.md`.
```

---

## 8. One-sentence summary (for quick share)

**Recommendation**: core `matilha-skills` + `matilha` CLI bump to `1.0.0`; companion packs stay at `0.1.0` (or patch-bump if cleanup commits land) — honest semver over narrative symmetry, with the announcement carrying the "v1.0.0 ecosystem" framing.
