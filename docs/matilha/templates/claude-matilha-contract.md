---
type: contract
consumers: [matilha install-plugins --with-claudemd, /matilha-install wizard]
version: v1
related: [claude-matilha-snippet.md]
---

# claude-matilha-contract

**Purpose.** Define the idempotent merge-or-create semantics that both SP-A (CLI `matilha install-plugins --with-claudemd`) and SP-C (`/matilha-install` wizard) MUST honor when writing the matilha activation-priority snippet into a user's `./CLAUDE.md`. This contract guarantees that, regardless of which surface the user invokes, the end-state of `./CLAUDE.md` is deterministic and re-entrant.

The canonical snippet lives in `claude-matilha-snippet.md` (same directory). It is delimited by:

```
<!-- matilha-start v1 -->
... body ...
<!-- matilha-end v1 -->
```

The marker version (`v1`) is the single knob for future migrations.

---

## What this contract guarantees

1. **Determinism.** Given a starting `./CLAUDE.md` state and a fixed snippet version, the merge operation always produces the same file content.
2. **Idempotency.** Running the merge N times (N ≥ 1) produces the same file content as running it once.
3. **Non-destructive.** Existing user content outside the matilha markers is never modified.
4. **Consumer parity.** SP-A (CLI, TypeScript) and SP-C (slash command, natural language) produce byte-identical results for the same starting state.

Any behavior that violates (1)–(4) is a bug in the consumer, not a license to diverge from this contract.

---

## Three merge cases

Each case below shows a BEFORE fixture (starting state of `./CLAUDE.md`), the operation the consumer performs, and the AFTER fixture (final state).

### Case 1 — `./CLAUDE.md` absent

**Trigger:** consumer's existence check (e.g., `fs.existsSync('./CLAUDE.md')` in SP-A, or `Read` tool returning file-not-found in SP-C) reports the file does not exist.

**Operation:** create `./CLAUDE.md` with the snippet as the full file content. No other content, no leading/trailing extra blank lines beyond what the snippet itself ships with.

**BEFORE:**
```
(file does not exist)
```

**AFTER (`./CLAUDE.md`):**
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

### Case 2 — `./CLAUDE.md` present WITHOUT matilha markers

**Trigger:** file exists; regex `/<!-- matilha-start v\d+ -->/` does NOT match any line in file content.

**Operation:** append the snippet to the end of the file, preserving every byte of pre-existing content. Insert a single blank line separator between the existing content and the opening marker, so the user's last paragraph is not glued to the matilha heading.

**BEFORE (`./CLAUDE.md`):**
```markdown
# My Project

Some pre-existing guidance for Claude Code.

- Don't commit secrets.
- Prefer TypeScript over JavaScript.
```

**AFTER (`./CLAUDE.md`):**
```markdown
# My Project

Some pre-existing guidance for Claude Code.

- Don't commit secrets.
- Prefer TypeScript over JavaScript.

<!-- matilha-start v1 -->
## Matilha — activation priority

This project uses the matilha harness. **Before invoking any creative-work skill** (`superpowers:brainstorming`, `superpowers:writing-plans`, etc.), you MUST first invoke `matilha:matilha-compose` via the Skill tool.

`matilha-compose` classifies intent into a matilha phase (scout / plan / design / hunt / gather / review / howl), detects installed companion packs, and dispatches to the right skill with pack-aware enrichment.

If `matilha:matilha-compose` is NOT visible in your skill list, matilha is not installed — proceed with default skills.

**Phases:** 0 (howl) → 10 (scout) → 20-30 (plan) → 40 (hunt/gather) → 50 (review) → 60 (den) → 70 (pack).

**Docs:** https://github.com/danilods/matilha-skills
<!-- matilha-end v1 -->
```

### Case 3 — `./CLAUDE.md` present WITH matilha markers

**Trigger:** file exists; regex `/<!-- matilha-start v\d+ -->[\s\S]*?<!-- matilha-end v\d+ -->/` matches (any marker version — `v1`, `v2`, etc.).

**Operation:** replace the entire matched span (from `<!-- matilha-start vN -->` through `<!-- matilha-end vN -->` inclusive) with the current snippet version. All file content BEFORE the opening marker and AFTER the closing marker is preserved verbatim. This is how idempotency and version migrations both work.

**BEFORE (`./CLAUDE.md`):**
```markdown
# My Project

Custom preamble.

<!-- matilha-start v1 -->
## Matilha — activation priority

(older body — may be current or stale, doesn't matter)
<!-- matilha-end v1 -->

## My other section

Trailing user content that must survive.
```

**AFTER (`./CLAUDE.md`):**
```markdown
# My Project

Custom preamble.

<!-- matilha-start v1 -->
## Matilha — activation priority

This project uses the matilha harness. **Before invoking any creative-work skill** (`superpowers:brainstorming`, `superpowers:writing-plans`, etc.), you MUST first invoke `matilha:matilha-compose` via the Skill tool.

`matilha-compose` classifies intent into a matilha phase (scout / plan / design / hunt / gather / review / howl), detects installed companion packs, and dispatches to the right skill with pack-aware enrichment.

If `matilha:matilha-compose` is NOT visible in your skill list, matilha is not installed — proceed with default skills.

**Phases:** 0 (howl) → 10 (scout) → 20-30 (plan) → 40 (hunt/gather) → 50 (review) → 60 (den) → 70 (pack).

**Docs:** https://github.com/danilods/matilha-skills
<!-- matilha-end v1 -->

## My other section

Trailing user content that must survive.
```

---

## Idempotency invariant

> For any starting state S of `./CLAUDE.md`, `merge(merge(S)) == merge(S)`.

Proof sketch:

- After the first `merge(S)`, the file always ends in Case 3 territory: a matilha-start/end block is present.
- A second `merge(...)` therefore re-enters Case 3, matches the block just written, and replaces it with the same snippet content.
- All bytes outside the block are untouched; all bytes inside the block are rewritten to the same value. ∎

Consumers MUST NOT add timestamps, random IDs, or environment-dependent tokens inside the managed block. Doing so breaks idempotency and should fail CI.

---

## Version migration (v1 → v2)

When the snippet body needs a breaking change (e.g., renamed skills, new phase, dropped capability), bump the marker version:

1. Update `claude-matilha-snippet.md` to emit `<!-- matilha-start v2 -->` / `<!-- matilha-end v2 -->` and the new body.
2. Leave the detection regex matching ANY `v\d+` so Case 3 still triggers on files that carry the old `v1` block. The replacement uses the new `v2` markers, so after migration the old markers are gone.
3. Document the migration in `CHANGELOG.md` under the release that ships the new snippet.
4. Consumers re-compile / re-bundle against the updated template; no code changes required if they follow the contract.

The version tag is the migration knob — never edit snippet content under the same version. A user who re-runs the bootstrap after a matilha upgrade gets the new block for free.

---

## Consumer contract

Both SP-A (CLI, TypeScript) and SP-C (slash command, natural language) MUST honor this contract verbatim. Any divergence is a bug. Specifically:

- **Same detection regex.** Both consumers use the `v\d+` marker pattern to classify Case 1/2/3.
- **Same marker output.** Both emit `<!-- matilha-start vN -->` and `<!-- matilha-end vN -->` with the exact casing and spacing shown in the template.
- **Same body source.** Both read the authoritative body from `claude-matilha-snippet.md`. SP-A bundles the file at build time; SP-C references it via tool-driven read at runtime.
- **No side effects outside the block.** Consumers MUST NOT reorder, reformat, or canonicalize content outside the managed block. If the user's file ends without a trailing newline, that's their choice — preserve it.
- **Single blank-line separator (Case 2 only).** Between pre-existing content and the opening marker, emit exactly one blank line. Never zero; never two.

---

## Implementation hints for consumers

### SP-A (CLI, TypeScript)

```ts
import fs from 'node:fs';

const SNIPPET = /* bundled from claude-matilha-snippet.md at build time */;
const MARKER_RE = /<!-- matilha-start v\d+ -->[\s\S]*?<!-- matilha-end v\d+ -->/;

function mergeClaudeMd(path: string): void {
  if (!fs.existsSync(path)) {
    fs.writeFileSync(path, SNIPPET, 'utf8'); // Case 1
    return;
  }
  const existing = fs.readFileSync(path, 'utf8');
  if (MARKER_RE.test(existing)) {
    const next = existing.replace(MARKER_RE, SNIPPET); // Case 3
    fs.writeFileSync(path, next, 'utf8');
    return;
  }
  const sep = existing.endsWith('\n') ? '\n' : '\n\n';
  fs.writeFileSync(path, existing + sep + SNIPPET, 'utf8'); // Case 2
}
```

Notes:
- Use `fs.existsSync` + `fs.readFileSync` (synchronous is fine; CLI is single-shot).
- The regex is lazy (`[\s\S]*?`) so it only matches the first block — a defensive choice if a future bug accidentally writes two blocks.
- Wrap in try/catch and surface a clear error if the path is not writable.

### SP-C (slash command, natural language)

- Use the **Read** tool to check whether `./CLAUDE.md` exists and (if so) whether it contains a line matching `<!-- matilha-start v`.
- **Case 1** — Read returns file-not-found → use **Write** tool to create `./CLAUDE.md` with the snippet as the full content.
- **Case 2** — file exists but no marker line → use **Edit** tool with `old_string` = the last non-empty line of existing content and `new_string` = that line + `\n\n` + snippet. Alternatively, Read full content, concatenate, Write the whole file.
- **Case 3** — file exists and markers present → use **Edit** tool with `old_string` = the existing block from `<!-- matilha-start vN -->` through `<!-- matilha-end vN -->` and `new_string` = the new snippet. The `old_string` must be unique (markers guarantee this).
- Reference the canonical body from `docs/matilha/templates/claude-matilha-snippet.md` — do not hand-retype it in the slash command.
- After write, read the file back and confirm the block is present; report success to the user.
