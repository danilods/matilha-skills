---
title: Wave 5g — Unified Install UX
slug: wave-5g-unified-install
date: 2026-04-24
status: design-approved
repos_touched: [matilha-skills, matilha]
estimated_effort_hours: 6-8
design_origin: memory/matilha-unified-install-options.md
---

# Wave 5g — Unified Install UX (spec)

> Close the "three-surface" gap: CLI, plugin, and the repo-local `CLAUDE.md` that carries matilha's activation priority rule. Reduce 16-line `/plugin install` paste friction, and ensure the priority rule is never invisible on fresh projects.

## 1. Purpose

Post-v1.1.0 smoke test (2026-04-24) surfaced two related problems for new adopters:

1. **Friction** — a user on a fresh machine must paste 16 `/plugin marketplace add` + `/plugin install` lines to get the full ecosystem. No curation, no presets.
2. **Invisible priority rule** — on a zero-ed project (no `CLAUDE.md`), the matilha-compose activation priority rule is not ambient. Even with the plugin installed, `superpowers:brainstorming` wins activation, compose never fires, sigil never appears, user thinks "it didn't work".

The `matilha-init` skill already writes CLAUDE.md correctly — but it's not part of the natural install flow. A user who installs via `/plugin install matilha-skills` does not trigger init. This wave bridges that gap.

## 2. Context

- **Two surfaces become three.** The v1.1.0 README documented CLI vs plugin as the two surfaces. In fact, `CLAUDE.md` in the target repo is a third surface — it carries the ambient priority rule that makes compose win activation.
- **Existing assets** — `/matilha-install` (static guide), `matilha-init` skill (full scaffold with CLAUDE.md), `matilha init` CLI command (twin to the skill). None of them are triggered automatically by `/plugin install`.
- **User decision captured in memory (`matilha-unified-install-options.md`)** — approved A+C implementation. During planning, surfaced SP-B (CLAUDE.md bootstrap) as the prerequisite unblocking the other two.

## 3. Design principles

- **Three-surface honesty.** Install UX must acknowledge CLI + plugin + CLAUDE.md as three independent concerns. Each flow exposes the need for the others without forcing a monolithic path.
- **Idempotent merge-or-create.** CLAUDE.md bootstrap must work on empty files, existing files without matilha block, and existing files with an older matilha block. Markers (`<!-- matilha-start -->` / `<!-- matilha-end -->`) delimit the managed region.
- **Template is shipped in matilha-skills.** Single source of truth at `docs/matilha/templates/claude-matilha-snippet.md`. Both CLI (SP-A) and slash command (SP-C) consume it.
- **Pack selection as presets, not curation.** Users choose by persona (backend, UX, full-stack, security) or all. No per-pack deep-dive before install — that's discoverability friction.
- **Output parity.** CLI `install-plugins` and `/matilha-install` wizard MUST produce identical `/plugin install` blocks for the same pack selection. One templated list; two delivery surfaces.
- **No breaking changes.** `/matilha-install` without-args behavior preserved as "show full guide" fallback when wizard tools unavailable.

## 4. Target deliverables

### 4.1 SP-B — CLAUDE.md snippet + merge-or-create (ships first)

**Path (matilha-skills):** `docs/matilha/templates/claude-matilha-snippet.md`

**Canonical snippet content** (final shape, ~15 lines body between markers):

```markdown
<!-- matilha-start v1 -->
## Matilha — activation priority

This project uses the matilha harness. **Before invoking any creative-work skill** (`superpowers:brainstorming`, `superpowers:writing-plans`, etc.), you MUST first invoke `matilha:matilha-compose` via the Skill tool.

`matilha-compose` classifies intent into a matilha phase (scout / plan / design / hunt / gather / review / howl), detects installed companion packs, and dispatches to the right skill with pack-aware enrichment.

If `matilha:matilha-compose` is NOT visible in your skill list, matilha is not installed — proceed with default skills.

**Phases:** 0 (howl) → 10 (scout) → 20-30 (plan) → 40 (hunt/gather) → 50 (review) → 60 (den) → 70 (pack).

**Docs:** https://github.com/danilods/matilha-skills
<!-- matilha-end v1 -->
```

**Merge-or-create contract** (implemented by SP-A and SP-C consumers):

- If `./CLAUDE.md` absent → create with snippet as full file (no other content).
- If present without `<!-- matilha-start` marker → append snippet to end of file, preserving all existing content.
- If present with existing matilha markers → replace content between markers (idempotent re-run).
- Version marker `v1` allows future migrations.

**SP-B deliverables in matilha-skills:**
- `docs/matilha/templates/claude-matilha-snippet.md` (template file)
- `docs/matilha/templates/claude-matilha-contract.md` (merge-or-create contract doc for SP-A/SP-C)
- No CLI helper, no skill code — pure template + contract.

### 4.2 SP-A — `matilha install-plugins` CLI subcommand

**Path (matilha CLI):** `src/install-plugins/` directory + register in `src/cli.ts`.

**Command shape:**
```
matilha install-plugins [--full | --core-only | --preset <name>] [--with-claudemd] [--no-clipboard]
```

Flags:
- `--full` — non-interactive, all 7 packs + core
- `--core-only` — just matilha-skills core
- `--preset <backend|ux|fullstack|security>` — curated subset
- (no flag) → interactive mode (@clack/prompts checklist)
- `--with-claudemd` — after pack install block, also emit a second block with CLAUDE.md merge-or-create instruction (paste-ready for Claude Code to execute)
- `--no-clipboard` — skip clipboard copy, print to stdout only

Default behavior (no flags): interactive mode + clipboard copy via pbcopy (macOS) / xclip (Linux) / clip (Windows). Graceful fallback when clipboard binary absent — print to stdout with notice.

**Output format (for both `--full` and interactive):**

```
# Paste into Claude Code:

/plugin marketplace add danilods/matilha-ux-pack
/plugin install matilha-ux-pack@matilha-ux-pack --user
... (repeat per selected pack)

# Optional: bootstrap CLAUDE.md (if --with-claudemd)
Create or merge the following into your project's CLAUDE.md
(between matilha-start/end markers — idempotent):

<!-- matilha-start v1 -->
...
<!-- matilha-end v1 -->
```

**Preset definitions (hardcoded in SP-A, documented in spec):**
- `backend` → core + harness-pack + sysdesign-pack + software-eng-pack + software-arch-pack + security-pack
- `ux` → core + ux-pack + growth-pack + software-eng-pack
- `fullstack` → core + all 7 packs
- `security` → core + security-pack + software-arch-pack + harness-pack

**Tests required:**
- `--full` output contains 16 lines (8 marketplace-add + 8 install) covering core + 7 packs
- `--core-only` output contains 2 lines (core only)
- `--preset backend` output covers exactly the backend subset
- `--with-claudemd` appends the snippet block with valid markers
- Clipboard fallback prints to stdout when `pbcopy`/`xclip`/`clip` absent

### 4.3 SP-C — `/matilha-install` wizard upgrade

**Path (matilha-skills):** `commands/matilha-install.md`

**Behavior change:** replace static markdown guide with an instructional prompt that directs Claude to:

1. **Detect project state** — read `./CLAUDE.md` (if exists, note whether matilha markers present).
2. **Present persona preset menu** via AskUserQuestion tool:
   - "Which matilha packs do you want to install?"
   - Options: `Backend` / `UX / Product` / `Full-stack` / `Security-focused` / `Custom selection` / `Core only`
3. If `Custom selection` → secondary AskUserQuestion with checkboxes per pack (7 items + descriptions).
4. **Offer CLAUDE.md bootstrap** via AskUserQuestion — only if marker check in step 1 showed absent/outdated:
   - "Bootstrap CLAUDE.md with matilha activation priority rule?" → Yes / No / Show snippet first
   - If Yes → use Write/Edit tool to apply merge-or-create per contract in `docs/matilha/templates/claude-matilha-contract.md`.
5. **Output `/plugin install` block** matching SP-A's shape (same preset definitions, same marketplace URLs).
6. **Fallback** — if AskUserQuestion tool unavailable in the session, degrade gracefully to the previous static guide (preserved at the bottom of the command file).

**Cross-SP contract with SP-A:**
- Preset definitions must be byte-identical to SP-A's hardcoded presets.
- `/plugin install` block format must match SP-A's output verbatim.
- Both must embed the same snippet content (read from / reference the SP-B template file).

## 5. Architecture

```
┌─────────────────────────┐     ┌──────────────────────────┐
│ npm user (fresh machine)│     │ Claude Code user         │
│                         │     │ (core already installed) │
└──────────┬──────────────┘     └────────────┬─────────────┘
           │                                  │
           ▼                                  ▼
    matilha install-plugins           /matilha-install
    (SP-A — CLI)                      (SP-C — slash cmd)
           │                                  │
           └──────────────┬───────────────────┘
                          │
                          ▼
             ┌────────────────────────┐
             │  Shared contract       │
             │  + template (SP-B)     │
             │                        │
             │ • Preset definitions   │
             │ • /plugin block format │
             │ • CLAUDE.md snippet    │
             │ • merge-or-create rule │
             └────────────────────────┘
```

**Why SP-B ships first (merge_order: 1):** both SP-A and SP-C consume the snippet + contract. Without SP-B, they duplicate content and drift. SP-B is a 1-hour deliverable that unblocks the two parallel streams.

## 6. Data flow

1. User invokes entry point (SP-A or SP-C).
2. Flow collects pack selection (interactive or flag-driven).
3. Flow emits `/plugin install` block (SP-A: stdout + clipboard; SP-C: chat output).
4. Flow optionally bootstraps CLAUDE.md (SP-A: emits paste block; SP-C: uses Write tool directly).
5. User pastes `/plugin install` block into Claude Code session → plugins install.
6. If CLAUDE.md was not bootstrapped in step 4, user's next session misses priority rule → compose doesn't fire → regression.

Step 4 is the critical gate. Both flows must make CLAUDE.md bootstrap unavoidable to skip accidentally (opt-out, not opt-in).

## 7. Open questions (resolved by plan)

- **Where does the snippet template live?** → `docs/matilha/templates/` in matilha-skills. Canonical source; CLI bundles copy at build time.
- **Does SP-A write CLAUDE.md directly or emit a paste block?** → Emits paste instruction. CLI has no idea of user's project cwd semantics; keeping it a paste-able artifact preserves the two-surface boundary (CLI doesn't write into arbitrary repos).
- **SP-C merge-or-create mechanic** → Uses Read to check for marker, then Write (create) or Edit (replace between markers) based on state.
- **Versioning** — matilha CLI → v1.2.0; matilha-skills → v1.2.0; no pack bumps.

## 8. Exit criteria

- `docs/matilha/templates/claude-matilha-snippet.md` ships in matilha-skills (SP-B).
- `docs/matilha/templates/claude-matilha-contract.md` ships in matilha-skills (SP-B).
- `matilha install-plugins --full` emits correct 16-line block + valid CLAUDE.md snippet when `--with-claudemd` (SP-A).
- `matilha install-plugins` interactive mode shows 4 preset options + custom (SP-A).
- `/matilha-install` invokes AskUserQuestion + offers CLAUDE.md bootstrap (SP-C).
- SP-A and SP-C produce byte-identical `/plugin install` blocks for same preset (integration test).
- Smoke: on a zero-ed project, run either flow end-to-end → start new session → type creative-work prompt → sigil appears on first try.
- Tests passing: matilha CLI test suite updated with SP-A tests (≥8 new); matilha-skills CHANGELOG entries for v1.2.0.
- Memory doc saved: `matilha-wave-5g-shipped.md`.

## 9. Non-goals

- **Not** integrating with `matilha init` heavy-scaffold flow (archetype prompt, project-status.md creation). SP-B is a micro-bootstrap for priority rule only.
- **Not** auto-executing `/plugin install` commands from CLI (architectural constraint: only harness can install plugins).
- **Not** adding new packs or new presets beyond the 4 documented in SP-A.
- **Not** revisiting the two-surface README callout (still accurate; gets a follow-up note about CLAUDE.md in v1.2.0 release notes).
