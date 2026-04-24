---
description: "Interactive wizard to install the matilha ecosystem — preset packs + optional CLAUDE.md bootstrap. Falls back to static guide if wizard tools are unavailable."
argument_hint: "(none)"
---

Interactive install wizard for the matilha ecosystem. Asks which packs you want, optionally bootstraps CLAUDE.md.

---

You are running the `/matilha-install` wizard. Execute the following steps in order. The goal is to (a) help the user select which matilha packs to install via a persona-based preset, (b) optionally apply the matilha activation priority rule to the project's `CLAUDE.md`, and (c) emit a paste-ready `/plugin install` block for the user to run.

Do NOT execute `/plugin install` commands yourself — only emit the block for the user to paste. You MAY use the Write and Edit tools to modify `./CLAUDE.md` when the user explicitly approves the bootstrap in Step 4.

## Step 1 — Detect project state

Use the Read tool to read `./CLAUDE.md`. Classify the state into one of:

- `no-file` — the Read tool returns an error indicating the file does not exist.
- `no-marker` — the file exists but does NOT contain the literal substring `<!-- matilha-start v` anywhere in its content.
- `has-marker` — the file exists AND contains `<!-- matilha-start v` (any version). Indicates an existing matilha block that will be replaced idempotently.

Remember this state for Steps 4 and 5. Do not surface it to the user yet.

## Step 2 — Preset selection

Invoke the `AskUserQuestion` tool with:

- Question: `Which matilha packs do you want to install?`
- Options (exactly these six, each with a short header and a one-line description):
  1. **Backend** — core + harness + sysdesign + software-eng + software-arch + security (~6 packs)
  2. **UX / Product** — core + ux + growth + software-eng (~4 packs)
  3. **Full-stack** — core + all 7 packs (everything)
  4. **Security-focused** — core + security + software-arch + harness (~4 packs)
  5. **Core only** — just matilha-skills (no companion packs)
  6. **Custom selection** — let me pick individual packs

Record the user's choice as `preset`.

## Step 3 — Custom selection (only if preset == `Custom selection`)

If the user chose Custom selection, invoke `AskUserQuestion` again to let the user pick from the 7 companion packs. Prefer the tool's multi-select / checkbox mode if available; otherwise ask a sequence of yes/no questions, one per pack, using the catalog in Step 7 for skill counts + descriptions.

Always include `matilha-skills` (core) implicitly — the user cannot opt out of core via this wizard.

Record the resulting list as `selected_packs`.

For presets other than Custom, resolve `selected_packs` from the preset map in Step 6.

## Step 4 — CLAUDE.md bootstrap decision

If Step 1 detected `no-file` OR `no-marker`, OR if the user asks on demand, invoke `AskUserQuestion` with:

- Question: `Bootstrap CLAUDE.md with matilha's activation priority rule?`
- Options:
  1. **Yes, apply now** — write or merge the matilha snippet into `./CLAUDE.md`.
  2. **No, skip** — leave CLAUDE.md untouched.
  3. **Show snippet first, then decide** — display the snippet from Step 8, then re-ask Yes / No.

If the user picks "Show snippet first", display the exact snippet block from Step 8 in the chat, then re-ask with a two-option AskUserQuestion (`Yes, apply now` / `No, skip`).

If Step 1 detected `has-marker`, still offer the bootstrap but explain this will replace the existing block between `<!-- matilha-start v1 -->` and `<!-- matilha-end v1 -->` (idempotent re-run).

## Step 5 — Apply CLAUDE.md bootstrap (only if the user chose Yes)

Apply the merge-or-create contract based on the state from Step 1:

- **`no-file`** — Use the Write tool to create `./CLAUDE.md`. Content = the exact snippet block from Step 8 (markers included).
- **`no-marker`** — Use the Read tool to load the current file, then use the Edit tool (or Write with full content) to append two newlines followed by the snippet block from Step 8 to the END of the file. Preserve all existing content verbatim.
- **`has-marker`** — Use the Edit tool to replace the entire region from `<!-- matilha-start v1 -->` through `<!-- matilha-end v1 -->` (inclusive) with the snippet from Step 8. This is idempotent: re-running the wizard produces the same file.

Confirm the write/edit succeeded before proceeding.

## Step 6 — Resolve `selected_packs`

Resolve `selected_packs` from the preset map:

- **Backend** → `matilha-skills`, `matilha-harness-pack`, `matilha-sysdesign-pack`, `matilha-software-eng-pack`, `matilha-software-arch-pack`, `matilha-security-pack`
- **UX / Product** → `matilha-skills`, `matilha-ux-pack`, `matilha-growth-pack`, `matilha-software-eng-pack`
- **Full-stack** → `matilha-skills`, `matilha-ux-pack`, `matilha-growth-pack`, `matilha-harness-pack`, `matilha-sysdesign-pack`, `matilha-software-eng-pack`, `matilha-software-arch-pack`, `matilha-security-pack`
- **Security-focused** → `matilha-skills`, `matilha-security-pack`, `matilha-software-arch-pack`, `matilha-harness-pack`
- **Core only** → `matilha-skills`
- **Custom selection** → whatever the user checked in Step 3, plus `matilha-skills`

## Step 6.5 — Choose install mode

Invoke `AskUserQuestion` with:

- Question: `How do you want to install the selected packs?`
- Options:
  1. **Run it now** — execute `claude plugin install` for each pack via the Bash tool. Zero paste. Requires `claude` CLI on PATH (standard when Claude Code is installed).
  2. **Show paste block** — emit `/plugin install` commands as a code block for me to paste into Claude Code manually.

Record the user's choice as `install_mode`.

## Step 7 — Execute install

### Step 7a — If `install_mode` == `Run it now`

First probe: use the Bash tool to run `command -v matilha || true` (captures whether the matilha CLI is on PATH without failing).

**Best path — matilha CLI present:**

If `command -v matilha` returned a non-empty path, use the Bash tool to run a single command that delegates the whole install to the CLI (which handles detection, idempotency, progress, and CLAUDE.md merge internally). Compose the command from the user's choices in Step 2:

- Preset chosen → `matilha install-plugins --preset <backend|ux|fullstack|security> --deep --no-clipboard` (plus `--with-claudemd` if Step 4's bootstrap decision was Yes)
- `Full-stack` → map to `--preset fullstack`
- `UX / Product` → map to `--preset ux`
- `Security-focused` → map to `--preset security`
- `Backend` → map to `--preset backend`
- `Core only` → `matilha install-plugins --core-only --deep --no-clipboard`
- `Custom selection` → pass `--full --deep` only if ALL 7 packs were selected; otherwise fall through to the "claude CLI only" path below (the CLI does not yet expose a custom pack list via flags)

Note: when you pass `--with-claudemd`, the matilha CLI writes `./CLAUDE.md` itself via the merge-or-create contract. Skip Step 5 above if you take this path AND Step 4 was Yes — the CLI already did it. If Step 5 already wrote CLAUDE.md before reaching Step 7, omit `--with-claudemd` to avoid a redundant re-apply.

Stream the Bash tool's stdout back so the user sees per-pack progress.

**Fallback path — only `claude` CLI present (no matilha CLI):**

If `command -v matilha` was empty, probe `command -v claude || true`. If claude is present, iterate through `selected_packs` with individual Bash calls. For each pack, run:

```
claude plugin marketplace add danilods/<pack-slug>
claude plugin install <plugin-name>@<pack-slug> --scope user
```

Use `matilha-skills`'s plugin-name special case (`matilha@matilha-skills`). Handle failures gracefully — "already installed" exits are success. After the loop completes, proceed to Step 7c.

**Last-resort fallback — neither CLI present:**

If both probes returned empty, tell the user that neither `matilha` nor `claude` CLI is on PATH, and ask them to either install one of them or switch to `Show paste block` mode. Then re-ask Step 6.5 (or just emit the paste block as in Step 7b).

### Step 7b — If `install_mode` == `Show paste block`

Emit the install commands as a fenced code block in the chat. For each pack in `selected_packs`, output two lines:

```
/plugin marketplace add danilods/<pack-slug>
/plugin install <pack-slug>@<pack-slug> --user
```

Special case: for `matilha-skills` the install command is `/plugin install matilha@matilha-skills --user` (the plugin name inside the marketplace is `matilha`, not `matilha-skills`).

Separate consecutive pack blocks with one blank line. Tell the user to copy-paste the block into their Claude Code prompt to actually install the plugins.

### Step 7c — Run `/reload-plugins` (both paths)

After a successful `Run it now` install, tell the user — in plain text, not as an executed command — to run `/reload-plugins` in their current Claude Code session to hot-reload the newly installed plugins without restarting. Alternatively, they can start a new Claude Code session and the plugins auto-load.

Do NOT emit `/reload-plugins` as if you could run it yourself — slash commands are user-invoked.

## Step 8 — Post-install notes

Print a brief summary covering:

- Which preset was chosen and how many packs were installed (or will be, in paste-block mode).
- Whether installation ran directly (Step 7a / `Run it now`) or needs a paste (Step 7b).
- Current CLAUDE.md state after Step 5 or CLI auto-write (created, merged, replaced, or untouched).
- Next action:
  - If `Run it now` succeeded: remind the user to run `/reload-plugins` in this session to activate without restarting, or start a new Claude Code session.
  - If `Show paste block`: user must paste the block into Claude Code.
- After activation, type a creative-work prompt (e.g. `brainstorm a new feature`) and confirm the sigil / matilha-compose preamble appears.
- If the sigil does not appear, run `/plugin list` to verify all selected packs show as **enabled**, and check CLAUDE.md has the `<!-- matilha-start v1 -->` block.

## Step 9 — Fallback

If the `AskUserQuestion` tool is not available in the current session (older Claude Code build, non-Claude-Code platform, etc.), OR the user explicitly asks for the "old guide" / declines the wizard, do NOT attempt the interactive steps above. Instead:

1. Tell the user the wizard is unavailable in this session and you are falling back to the static install guide.
2. Output the full content of the `## Fallback: manual install guide` section (below) verbatim as a formatted chat message.

---

## Canonical snippet (used by Steps 4, 5, and 9)

This is the exact snippet to write between `<!-- matilha-start v1 -->` and `<!-- matilha-end v1 -->`. It must be copied byte-for-byte; do not paraphrase or reformat.

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

## Pack catalog (reference for Step 3 custom selection)

| Pack | Skills | Install when you... |
|---|---|---|
| **matilha-ux-pack** | 22 | Build UIs, forms, error flows, cognitive-load decisions. Weinschenk + Krug + cognitive psych. |
| **matilha-growth-pack** | 20 | Do growth work — signup flows, pricing, activation, retention, positioning. AARRR + JTBD. |
| **matilha-harness-pack** | 22 | Build LLM agents — multi-agent systems, context engineering, evals. Anthropic + OpenAI + Lopopolo. |
| **matilha-sysdesign-pack** | 19 | Scale distributed systems — NFRs, CAP, Kafka, CDN, rate limiting. Zhiyong Tan. |
| **matilha-software-eng-pack** | 15 | Day-to-day engineering discipline — KISS, RORO, commits, docs, task tracking. Danilo-experience. |
| **matilha-software-arch-pack** | 17 | Organize code — layering, Lambda chains, event-driven, dual-store, bounded contexts. Argos + Gravicode. |
| **matilha-security-pack** | 13 | Ship AI software safely — keys, trust boundary, LLM risks, LGPD. NOT a STRIDE/OWASP replacement. |

---

## Fallback: manual install guide

# Matilha Ecosystem — Install Guide

You already have `matilha-skills` installed. Below is the complete guide for adding the 7 companion packs. Each pack is optional — install only the domains that match your work.

## Recommended: user scope (methodology-everywhere)

Install at user scope so each pack is available in every workspace, not just per-project. Copy-paste the block below:

```
/plugin marketplace add danilods/matilha-ux-pack
/plugin install matilha-ux-pack@matilha-ux-pack --user

/plugin marketplace add danilods/matilha-growth-pack
/plugin install matilha-growth-pack@matilha-growth-pack --user

/plugin marketplace add danilods/matilha-harness-pack
/plugin install matilha-harness-pack@matilha-harness-pack --user

/plugin marketplace add danilods/matilha-sysdesign-pack
/plugin install matilha-sysdesign-pack@matilha-sysdesign-pack --user

/plugin marketplace add danilods/matilha-software-eng-pack
/plugin install matilha-software-eng-pack@matilha-software-eng-pack --user

/plugin marketplace add danilods/matilha-software-arch-pack
/plugin install matilha-software-arch-pack@matilha-software-arch-pack --user

/plugin marketplace add danilods/matilha-security-pack
/plugin install matilha-security-pack@matilha-security-pack --user
```

(If `--user` is not recognized, use the interactive `/plugin` menu and select **user scope**.)

## Pick individual packs (à la carte)

If you prefer to install only specific packs, use the table below to decide. Each pack auto-activates via matilha-compose when user intent matches — installing all of them doesn't add noise, so bulk-install is safe.

| Pack | Skills | Install when you... |
|---|---|---|
| **matilha-ux-pack** | 22 | Build UIs, forms, error flows, cognitive-load decisions. Weinschenk + Krug + cognitive psych. |
| **matilha-growth-pack** | 20 | Do growth work — signup flows, pricing, activation, retention, positioning. AARRR + JTBD. |
| **matilha-harness-pack** | 22 | Build LLM agents — multi-agent systems, context engineering, evals. Anthropic + OpenAI + Lopopolo. |
| **matilha-sysdesign-pack** | 19 | Scale distributed systems — NFRs, CAP, Kafka, CDN, rate limiting. Zhiyong Tan. |
| **matilha-software-eng-pack** | 15 | Day-to-day engineering discipline — KISS, RORO, commits, docs, task tracking. Danilo-experience. |
| **matilha-software-arch-pack** | 17 | Organize code — layering, Lambda chains, event-driven, dual-store, bounded contexts. Argos + Gravicode. |
| **matilha-security-pack** | 13 | Ship AI software safely — keys, trust boundary, LLM risks, LGPD. NOT a STRIDE/OWASP replacement. |

## After installing

Verify with:

```
/plugin list
```

You should see `matilha` + the packs you chose, all marked as **enabled**.

Open a fresh session in any directory and type a software-construction prompt. The SessionStart hook fires matilha-bootstrap, then matilha-compose detects installed packs and injects atmospheric preamble before dispatching to brainstorming. The sigil (♛ + pack dogs) confirms the flow is working.

## Tip

You don't need ALL packs to use matilha. Core alone is valuable (11 methodology skills). Each pack adds domain expertise. Start with 1-2 packs matching your current project, add more as you hit new domains.

## Troubleshooting

- **Sigil never appears** → check `/plugin list`. matilha must be enabled at user scope.
- **Compose fires but no packs detected** → pack plugin(s) missing from user-scope install. Re-run the install block above.
- **"Use the /plugin menu" prompt** → your Claude Code version doesn't recognize `--user`. Use the interactive menu and select user scope.

---

**You lead. Agents hunt.** 🐺
