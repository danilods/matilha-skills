---
title: Matilha v1.0.0 — Announcement Drafts
date: 2026-04-21
status: draft (3 versions: short / medium / long)
audience: Twitter/X · LinkedIn · Hacker News Show HN · r/ClaudeAI · GitHub README
---

# Matilha v1.0.0 — Announcement Drafts

Three polished drafts, short → long. Pick the channel, drop the text. All three carry the same hook (**"You lead. Agents hunt."**), the same sigil (ASCII), and the same CTA (`/plugin install matilha@matilha-skills --user`).

> **Counting note for all drafts**: *109 skills* = 98 skills across 5 companion packs (22 UX + 20 growth + 22 harness + 19 sysdesign + 15 software-eng) + 11 core methodology skills in `matilha-skills`. Use consistently — avoid drift to "109 across 5 packs" (wrong — that count excludes core).

---

## Draft A — Short (Twitter/X, ≤280 chars)

Variant 1 (260 chars):

```
matilha v1.0.0 shipped.

You lead. Agents hunt.

A methodology harness for AI-assisted dev — 109 skills across 6 plugins (UX, growth, agents, sysdesign, engineering discipline + composition core). Works in Claude Code, Cursor, Codex, Gemini.

/plugin install matilha@matilha-skills --user
```

Variant 2 (238 chars, sigil-first):

```
♛
matilha v1.0.0

You lead. Agents hunt.

Methodology harness for multi-week AI-assisted projects. 109 skills, 5 companion packs, cross-tool (Claude Code / Cursor / Codex / Gemini).

/plugin install matilha@matilha-skills --user
github.com/danilods/matilha-skills
```

---

## Draft B — Medium (LinkedIn, ~500 words)

### Title

**Matilha v1.0.0 — A methodology harness for AI-assisted development. You lead. Agents hunt.**

### Body

Multi-week AI-assisted software projects fail in predictable ways. Context leaks between sessions. Methodology erodes under time pressure. Domain knowledge — UX heuristics, scaling patterns, growth frameworks, engineering discipline — stays scattered across books nobody re-reads.

Today I'm releasing **Matilha v1.0.0**, a cognitive and methodological harness that wraps your existing AI tooling with phase-gated discipline and pluggable intelligence packs.

```
            ♛
        /\___/\
       ( ◉   ◉ )
        \  v  /
         ‾‾‾‾‾

   /\_/\   /\_/\   /\_/\
  ( ● ● ) ( ● ● ) ( ● ● )
    \/      \/      \/
          matilha
```

**You are the alpha.** The pack hunts at your side.

### What v1.0.0 ships

- **Matilha core (`matilha-skills`)** — 11 methodology orchestration skills covering 8 project phases: `scout` (discovery), `plan` (spec + plan authoring), `design` (UX), `hunt` + `gather` (parallel dispatch + merge), `review` (quality gates), `howl` (state), `den` + `pack` (knowledge capture). Plus `matilha-compose`, a companion-pack-aware gateway that detects installed packs and enriches brainstorming automatically.

- **Five companion packs — 98 skills total:**
  - `matilha-ux-pack` (22 skills) — Weinschenk + Krug + neuroscience for visual design, cognitive load, and trust.
  - `matilha-growth-pack` (20 skills) — AARRR, JTBD, positioning, pricing, retention.
  - `matilha-harness-pack` (22 skills) — Anthropic agent patterns, OpenAI Codex, harness engineering.
  - `matilha-sysdesign-pack` (19 skills) — Zhiyong Tan distributed systems + NFRs.
  - `matilha-software-eng-pack` (15 skills) — day-to-day engineering discipline (KISS, commits, documentation, critical analysis).

- **Cross-tool** — Claude Code, Cursor, Codex, Gemini. Same plugin format, same SessionStart hook that injects activation priority into every workspace.

- **Composition, not competition** — core skills delegate to packs via plugin-namespace detection. No hardcoded list. Install new packs, they are picked up automatically.

### Install (recommended: user scope)

```
/plugin marketplace add danilods/matilha-skills
/plugin install matilha@matilha-skills --user
```

Then add the packs that match your work.

### Why this exists

I built Matilha while running multi-week AI-coded projects. The harness is what I reached for every day to keep discipline: phase awareness, state tracking, wave dispatch, knowledge capture. The packs are what I reached for when I needed domain expertise I hadn't re-read in months. Now the harness + packs are one install.

**Matilha v1.0.0 — GitHub: github.com/danilods/matilha-skills**

#AI #Claude #DeveloperTools #Methodology #AgenticAI

---

## Draft C — Long (Show HN / Blog, ~1200 words)

### Title options

- **Show HN: Matilha v1.0.0 — a methodology harness for multi-week AI-assisted dev (109 skills, 6 plugins, cross-tool)**
- **Matilha v1.0.0: The pack hunts at your side**
- **You lead. Agents hunt. — Shipping Matilha v1.0.0**

### Body

#### The problem

Multi-week AI-assisted software projects fail in ways that pre-AI projects didn't.

Three failure modes I kept hitting:

1. **Context erosion.** Session N doesn't remember what session N−1 decided. You re-explain the project every morning, and the model drifts from the decisions you made.
2. **Methodology under pressure.** Under deadline, you skip scout, skip plan, and go straight to "hunt". You ship faster for a week, then spend three debugging.
3. **Scattered domain knowledge.** The Weinschenk UX principle. The JTBD framing. The Anthropic agent pattern. The Tan capacity check. All of these live in books you read once. The model doesn't reach for them on your behalf because no one wired them in.

These are not "prompt engineering" problems. They are **harness problems** — problems of how the scaffold around the model is structured, how phases gate each other, how domain knowledge is activated just-in-time without the user typing slash commands.

#### What Matilha is

Matilha is a cognitive and methodological harness for AI-assisted development.

**Two first-class incarnations:**

- **Plugin** — cross-tool across Claude Code, Cursor, Codex, and Gemini. Install at user scope, and the methodology is available in every workspace.
- **CLI** — `matilha` on npm for CI and power users. Deterministic engine, shared registry with the plugin.

**Three architectural layers** (the "Option D" framing):

1. **Craft engine** — `superpowers:*` (brainstorming, writing-plans, TDD, systematic-debugging). If you have superpowers installed, it's the base layer. If you don't, matilha runs standalone inline-flows with its own methodology core.
2. **Methodology wrapper** — matilha itself. Phase awareness (scout → plan → hunt → gather → review → den → pack), state tracking (`project-status.md`, `wave-NN-status.md`), lazy-bootstrap of project scaffolding, and routing through `matilha-compose`.
3. **Domain enrichment** — companion packs. UX, growth, agents, system design, engineering discipline. Optional. Only surface when the pack is installed AND the user intent matches.

#### The sigil

```
            ♛
        /\___/\
       ( ◉   ◉ )
        \  v  /
         ‾‾‾‾‾

   /\_/\   /\_/\   /\_/\
  ( ● ● ) ( ● ● ) ( ● ● )
    \/      \/      \/
          matilha
```

This is the matilha signature. When compose dispatches to brainstorming with a relevant pack installed, the model emits this sigil plus an atmospheric line that mirrors the domain vocabulary of the user's prompt. It's not decoration. It's recognition. The mirror proves the model read you. The pack lines name the skills that will be in-context. The closing transition hands control back.

#### Live example

Prompt I ran during Wave 5d smoke:

> "Ando estudando governança de IA em contextos regulatórios, especialmente como traduzir requisitos compliance em controles técnicos mapeáveis para agentes que modificam código de produção."

With matilha installed at user scope + growth-pack + harness-pack installed, matilha-compose emits:

```
            ♛
        /\___/\
       ( ◉   ◉ )
        \  v  /
         ‾‾‾‾‾

   /\_/\   /\_/\   /\_/\
  ( ● ● ) ( ● ● ) ( ● ● )
    \/      \/      \/
          matilha

A alcateia farejou território familiar: governança regulatória + controles técnicos para agentes que modificam código de produção.

matilha-harness-pack ao lado → harness-review-agents-by-persona, harness-nfrs-as-prompts, harness-lint-as-prompt, harness-test-source-code-structure, harness-agents-md-as-index.

Brainstorming adiante. Skills entram em cena conforme os tópicos surgirem.
```

Brainstorming then runs enriched. Each relevant pack skill activates as the conversation touches its trigger surface — no slash commands, no lookups.

#### What v1.0.0 ships

- **`matilha-skills`** — core plugin + methodology registry.
  - 11 orchestration skills: `matilha-bootstrap`, `matilha-compose`, `matilha-scout`, `matilha-plan`, `matilha-design`, `matilha-hunt`, `matilha-gather`, `matilha-review`, `matilha-howl`, `matilha-den`, `matilha-pack`.
  - SessionStart hook injects activation priority into every matilha-installed session — cross-workspace.
  - Storytelling-mode sigil + atmospheric line + pack lines when compose dispatches to brainstorming.

- **Five companion packs — 98 skills total:**

| Pack | Skills | Source |
|---|---|---|
| `matilha-ux-pack` | 22 | Weinschenk + Krug + neuroscience |
| `matilha-growth-pack` | 20 | AARRR + JTBD + positioning + pricing + retention |
| `matilha-harness-pack` | 22 | Anthropic + OpenAI Codex + Lopopolo |
| `matilha-sysdesign-pack` | 19 | Zhiyong Tan + NFRs + 11 case studies |
| `matilha-software-eng-pack` | 15 | Danilo-experience rules (opinions from practice) |

- **Cross-tool compatibility** — Claude Code, Cursor, Codex, Gemini all consume the same `.claude-plugin/plugin.json` + `marketplace.json` format.

- **Validator** — 1211 tests covering plugin manifests, skill frontmatter, skill body structure, activation-uniqueness heuristics, overlap disclosures. Ships in the CLI repo; runs on every wave.

#### Install

```
# Core
/plugin marketplace add danilods/matilha-skills
/plugin install matilha@matilha-skills --user

# Pick the packs that match your work
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
```

**Why `--user` scope**: Claude Code records plugins per-project by default. User-scope install makes the methodology available in every workspace you open. That is the intended usage pattern.

#### What's next

- **Wave 3c — `matilha-review` runtime.** Stub exists; the six-agent parallel quality-review loop is the next methodology-core deliverable.
- **B packs** — Danilo's next wave of pack ideas (see `docs/release/b-packs-brainstorm-prompts.md`).
- **CLI on npm.** v0.4.0 is tagged locally; npm publish sequences after the v1.0.0 cut.

#### Repo + links

- GitHub org: `github.com/danilods`
- Core: `github.com/danilods/matilha-skills`
- Packs: `github.com/danilods/matilha-{ux,growth,harness,sysdesign,software-eng}-pack`
- Methodology docs: `matilha-skills/docs/matilha/`

**Matilha v1.0.0. You lead. Agents hunt.**

Feedback welcome — HN thread, GitHub Issues, Twitter DMs.

---

## Short excerpt for GitHub README v1.0.0 badge

```
matilha v1.0.0 — You lead. Agents hunt.
A methodology harness for AI-assisted development.
109 skills · 5 companion packs · Claude Code / Cursor / Codex / Gemini.
/plugin install matilha@matilha-skills --user
```
