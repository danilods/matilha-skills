---
wave: 5g
slug: wave-5g-unified-install
spec: docs/matilha/specs/wave-5g-unified-install-spec.md
repos_touched: [matilha-skills, matilha]
merge_order: [SP-B, SP-A, SP-C]
estimated_hours: 6-8
date: 2026-04-24
---

# Wave 5g — Unified Install UX (plan)

**Goal:** Ship CLAUDE.md snippet + CLI `install-plugins` subcommand + `/matilha-install` wizard upgrade. Close friction + invisible-priority-rule gaps surfaced in v1.1.0 smoke.

**Spec:** `docs/matilha/specs/wave-5g-unified-install-spec.md`

## Parallelism strategy

SP-B ships first (template file in matilha-skills). SP-A and SP-C run in parallel, both consuming the contract+snippet defined in SP-B. SP-B is a ~1h deliverable; SP-A and SP-C (~3-4h and ~2h) can dispatch simultaneously since:
- Different files, different repos, zero write conflicts.
- Contract is fully locked in spec §4.1 — no runtime coordination needed.
- Integration test validates byte-parity at merge time.

Dispatch order in practice: all 3 agents start in parallel. SP-B finishes fastest and is first to merge. SP-A and SP-C complete, then merge in any order (no mutual dependency after spec is locked).

## SP-B — CLAUDE.md snippet + merge-or-create contract

**Repo:** matilha-skills at `/Users/danilodesousa/Documents/Projetos/matilha-skills`
**Branch:** `wave-5g/sp-b-claudemd-snippet`
**Estimated:** 1h
**Merge order:** 1 (first)

### Files to create

- `docs/matilha/templates/claude-matilha-snippet.md` — canonical snippet with markers, exact content per spec §4.1
- `docs/matilha/templates/claude-matilha-contract.md` — merge-or-create rules (create / append / replace between markers), version migration notes, example fixtures

### Tasks

- [ ] Create `docs/matilha/templates/` directory
- [ ] Write `claude-matilha-snippet.md` with exact content from spec §4.1 (copy-paste verbatim; the snippet body is the deliverable)
- [ ] Write `claude-matilha-contract.md` with:
  - Merge-or-create algorithm (3 cases: absent file / present without marker / present with marker)
  - Example before/after fixtures for each case
  - Version migration guidance (how v2 would supersede v1)
  - Consumer contract: both SP-A (CLI) and SP-C (slash command) must honor this contract verbatim
- [ ] Update `CHANGELOG.md` in matilha-skills with Wave 5g entry (under Unreleased / v1.2.0 section)

### Exit gates

- Both template files exist at `docs/matilha/templates/`
- Snippet contains `<!-- matilha-start v1 -->` / `<!-- matilha-end v1 -->` markers
- Contract doc enumerates all 3 merge cases with example fixtures
- No skill code, no CLI code, no command changes — this SP is pure template + contract documentation

## SP-A — `matilha install-plugins` CLI subcommand

**Repo:** matilha CLI at `/Users/danilodesousa/Documents/Projetos/matilha`
**Branch:** `wave-5g/sp-a-install-plugins`
**Estimated:** 3-4h
**Merge order:** 2 (parallel with SP-C)

### Files to create

- `src/install-plugins/installPluginsCommand.ts` — main command handler
- `src/install-plugins/presets.ts` — hardcoded preset definitions (backend / ux / fullstack / security)
- `src/install-plugins/packCatalog.ts` — pack metadata (name, marketplace slug, skill count, description)
- `src/install-plugins/renderBlock.ts` — pure function: selection → formatted `/plugin install` block
- `src/install-plugins/claudeMdSnippet.ts` — bundled copy of SP-B snippet (copy-pasted at dev time, not runtime-fetched for v1.2.0)
- `src/install-plugins/copyToClipboard.ts` — OS-detected pbcopy/xclip/clip invocation with graceful fallback
- `src/install-plugins/interactivePrompt.ts` — @clack/prompts checklist + preset selector
- `tests/install-plugins/renderBlock.test.ts` — pure renderer tests
- `tests/install-plugins/presets.test.ts` — preset correctness tests
- `tests/install-plugins/claudeMdSnippet.test.ts` — snippet integrity (marker presence, content match)

### Files to modify

- `src/cli.ts` — register new command: `matilha install-plugins [...flags]`
- `CHANGELOG.md` — v1.2.0 entry
- `package.json` — bump to 1.2.0

### Tasks

- [ ] Define pack catalog (7 packs + core) with marketplace slugs matching current v1.1.0 `/matilha-install` command
- [ ] Define presets: backend / ux / fullstack / security per spec §4.2 (4 presets)
- [ ] Implement `renderBlock(selection)` pure function returning `/plugin install` text block
- [ ] Implement `renderClaudeMdBlock()` returning the snippet + merge-or-create paste instructions
- [ ] Implement `copyToClipboard(text)` with pbcopy / xclip / clip detection + graceful fallback
- [ ] Implement interactive flow via @clack/prompts: preset picker → optional custom checklist
- [ ] Wire command registration in `src/cli.ts` using Commander API (match existing command shape)
- [ ] Flag handling: `--full | --core-only | --preset <name>` (mutually exclusive); `--with-claudemd` (additive); `--no-clipboard`
- [ ] Write unit tests: renderBlock, presets, claudeMdSnippet integrity (≥8 tests)
- [ ] Integration test: `matilha install-plugins --full` output snapshot
- [ ] Update CHANGELOG + bump version
- [ ] Verify `npm run build` + `npm test` pass

### Exit gates

- `matilha install-plugins --full` prints 16-line block (8 marketplace-add + 8 install) covering core + 7 packs
- `matilha install-plugins --core-only` prints 2 lines (core only)
- `matilha install-plugins --preset backend` prints block covering exactly: core + harness + sysdesign + software-eng + software-arch + security
- `matilha install-plugins --with-claudemd` appends CLAUDE.md paste instruction with valid markers
- Interactive mode works (manual smoke OK in plan)
- Clipboard copy works on macOS (pbcopy path); stdout-only fallback verified
- All tests green; build passes; CHANGELOG updated; package.json at 1.2.0

### Contract with SP-C (byte-parity)

- Pack marketplace slugs in `packCatalog.ts` MUST match the ones in `/matilha-install` command
- Preset definitions MUST match SP-C's presets exactly
- `/plugin install` line format: two lines per pack (marketplace add + install) with `--user` flag

## SP-C — `/matilha-install` wizard upgrade

**Repo:** matilha-skills at `/Users/danilodesousa/Documents/Projetos/matilha-skills`
**Branch:** `wave-5g/sp-c-matilha-install-wizard`
**Estimated:** 2h
**Merge order:** 2 (parallel with SP-A)

### Files to modify

- `commands/matilha-install.md` — replace static guide body with wizard instructions; preserve static guide at bottom as fallback
- `CHANGELOG.md` — v1.2.0 entry (shared with SP-B if they land in same merge)

### Tasks

- [ ] Rewrite `commands/matilha-install.md` body as instructions to Claude:
  - Step 1: Read `./CLAUDE.md` (if present) to detect matilha markers
  - Step 2: Invoke AskUserQuestion with preset options (Backend / UX / Full-stack / Security / Custom / Core only)
  - Step 3: If Custom, invoke secondary AskUserQuestion with per-pack checkboxes (7 items)
  - Step 4: If CLAUDE.md missing markers, offer bootstrap via AskUserQuestion (Yes / No / Show snippet)
  - Step 5: If Yes, apply merge-or-create per contract (Write for create, Edit for replace-between-markers)
  - Step 6: Output `/plugin install` block matching SP-A's format
  - Step 7: Fallback to static guide if AskUserQuestion tool unavailable
- [ ] Include snippet content inline (referenced from `docs/matilha/templates/claude-matilha-snippet.md` for SSOT, but embedded in command file for self-contained execution)
- [ ] Include all 4 preset definitions inline
- [ ] Preserve original static guide at bottom of command file under `## Fallback: manual install guide`
- [ ] Smoke check: re-read the command file start-to-finish to validate instructions are unambiguous
- [ ] Update CHANGELOG

### Exit gates

- `/matilha-install` runs wizard flow (confirmed via manual smoke)
- Presets match SP-A byte-for-byte
- Snippet content matches SP-B byte-for-byte
- CLAUDE.md bootstrap works: empty file → creates; existing file no-marker → appends; existing file with marker → replaces
- Static fallback preserved for environments without AskUserQuestion

### Contract with SP-A (byte-parity)

- Pack marketplace slugs, preset definitions, `/plugin install` line format all align with SP-A. Any drift is a bug — caught at integration by manual diff.

## Merge sequence

1. **SP-B merge** (first) — trivial, no conflict possible.
2. **SP-A merge** — into matilha CLI main; tag `v1.2.0`, publish npm.
3. **SP-C merge** — into matilha-skills main; tag `v1.2.0` for matilha-skills.
4. **Integration smoke** — on a fresh dir: `npm i -g matilha@1.2.0` → `matilha install-plugins --full --with-claudemd` → paste in Claude Code → open new session → creative-work prompt → sigil appears first try.
5. **Memory doc** — save `matilha-wave-5g-shipped.md` with ecosystem snapshot.

## Rollback plan

- SP-B: delete `docs/matilha/templates/` — no runtime effect.
- SP-A: revert CLI branch; keep v1.1.0 published.
- SP-C: restore static `/matilha-install` (git revert one commit).
- No pack version changes, no marketplace changes — clean rollback always possible.

## Risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| AskUserQuestion not available in user's Claude Code version | Low | Med | SP-C static fallback preserved |
| Clipboard binary missing on Linux (no xclip) | Med | Low | SP-A graceful stdout fallback |
| Preset drift between SP-A and SP-C | Med | High | Spec §4.2 locks both; integration test at merge |
| User's existing CLAUDE.md has conflicting content | Low | Med | Merge-or-create preserves pre-existing content outside markers |
| Snippet content change in future (v2) | N/A | Low | Markers are versioned (`v1`); future migration path documented in SP-B contract |
