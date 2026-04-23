---
title: Matilha — Marketplace Submission Materials
date: 2026-04-21
status: draft
targets: Claude Code plugin marketplace · cross-tool plugin directories · general discoverability
---

# Matilha — Marketplace Submission Materials

Polished copy + metadata for submitting the 6 Matilha plugins to any marketplace that discovers `.claude-plugin/marketplace.json`. Aligned to the v1.0.0 release (pending pre-release blockers in `v1.0.0-checklist.md`).

---

## 1. Plugin descriptions (marketplace-ready)

All descriptions derive from `plugin.json` + `marketplace.json` but polished for marketplace readability (no wave references, no internal terminology).

### 1.1 `matilha` (core)

**Short tagline** (≤140 chars):
> You lead. Agents hunt. A methodology harness for multi-week AI-assisted development — phase-gated skills + pluggable companion packs.

**Full description** (~300 words):
> **Matilha** is a cognitive and methodological harness for AI-assisted software projects. It wraps your existing AI tooling with phase-gated discipline (scout, plan, design, hunt, gather, review, den, pack) and a companion-pack composition layer that enriches brainstorming with domain expertise.
>
> **What it does**:
> - **Session start** — injects activation priority so matilha-compose fires before creative-work skills.
> - **Phase awareness** — 11 orchestration skills cover discovery through knowledge capture. Lazy-bootstraps project scaffolding on demand (no mandatory `matilha-init`).
> - **Composition** — detects installed companion packs (`matilha-*-pack` namespace) and enriches brainstorming automatically. No hardcoded pack list.
> - **Storytelling mode** — when a relevant pack is installed, compose emits a canonical sigil (alpha wolf + pack dogs) plus an atmospheric line that mirrors the user's domain vocabulary.
> - **Runs standalone** — methodology works without `superpowers:*`; enriches when present.
>
> **Cross-tool**: Claude Code, Cursor, Codex, Gemini. Same plugin format, same SessionStart hook.
>
> **Install**: `/plugin install matilha@matilha-skills --user` (user scope recommended).

**Keywords / tags**: `matilha`, `methodology`, `agentic`, `ai`, `cognitive-harness`, `workflow`, `cross-tool`, `claude-code`, `cursor`, `codex`, `gemini`.

---

### 1.2 `matilha-ux-pack`

**Short tagline**:
> 22 UX + cognitive-psychology skills synthesized from Weinschenk, Krug, and neuroscience research. Matilha companion pack.

**Full description**:
> **Matilha UX Pack** extends Matilha with 22 skills covering visual design, cognitive load, typography, color meaning, flow-state design, motivation (goal gradient, variable rewards, intrinsic motivation, dopamine), trust signals, error presentation, and usability testing.
>
> Each skill auto-activates when user intent matches — designing a form triggers cognitive-load guidance; making a tonal decision triggers emotion-in-UI principles; auditing trust surfaces the "reservatório de boa vontade" check.
>
> Sources paraphrased through three layers of remove from: Susan Weinschenk's *100 Things Every Designer Needs to Know About People*, Steve Krug's *Don't Make Me Think*, and behavioral-science / neuroscience literature on attention, decision-making, and motivation.
>
> **Works standalone** (skills activate by their own descriptions) or **enriched by matilha core** (compose detects the pack and injects pack-aware preamble into brainstorming).

**Keywords / tags**: `matilha-pack`, `ux`, `cognitive`, `weinschenk`, `krug`, `neuroscience`, `design`.

---

### 1.3 `matilha-growth-pack`

**Short tagline**:
> 20 growth + product-strategy skills — AARRR, JTBD, positioning, pricing, retention. Matilha companion pack.

**Full description**:
> **Matilha Growth Pack** extends Matilha with 20 skills across the product-growth stack: acquisition funnel (AARRR, north-star metrics, instrumentation), product-led growth (PLG strategy, activation aha-moments, viral loops), JTBD + positioning (forces diagram, category creation, ICP definition), behavioral frameworks (Hook Model product-angle, Fogg B-MAP feasibility, Octalysis drives, peak-end journey mapping), pricing + monetization (pricing psychology, freemium strategy, value metrics), and retention + moat (retention curves, churn diagnostics, network effects).
>
> Skills activate when user intent touches any of those surfaces — pricing decisions trigger pricing-psychology + value-metric; onboarding designs trigger activation-aha-moment + JTBD-forces; retention audits trigger retention-curves + churn-diagnostics.

**Keywords / tags**: `matilha-pack`, `growth`, `product-strategy`, `aarrr`, `jtbd`, `positioning`, `pricing`, `retention`.

---

### 1.4 `matilha-harness-pack`

**Short tagline**:
> 22 harness-engineering skills — Anthropic agents + OpenAI Codex + Lopopolo. Matilha companion pack.

**Full description**:
> **Matilha Harness Pack** codifies discipline for teams running AI-assisted development at scale. Synthesized from Anthropic Engineering (Harness Design, Building Effective Agents, Context Engineering for AI Agents, Demystifying Evals), OpenAI's "Agent-Centric World" Codex blog, and Ryan Lopopolo's Harness Engineering talk (AI Engineer London 2026).
>
> **Coverage**: harness architecture evolution · NFRs-as-prompts (lint, test structure, review agents by persona, Garbage Collection Day) · agentic patterns (workflow vs agent, routing, parallelization, orchestrator-workers, evaluator-optimizer, ACI design) · agent-centric codebase (AGENTS.md as index, docs/ as system of record, Ralph Wiggum loop) · context engineering (context rot, JIT retrieval, long-horizon strategies) · agent evaluation (graders taxonomy, capability vs regression evals, 0-to-1 eval roadmap) · foundational axioms ("code is free" in token-billionaire economics).

**Keywords / tags**: `matilha-pack`, `harness`, `agents`, `agentic-patterns`, `context-engineering`, `evals`, `anthropic`, `openai-codex`.

---

### 1.5 `matilha-sysdesign-pack`

**Short tagline**:
> 19 system-design skills — Zhiyong Tan's *Acing the System Design Interview* + NFRs + 11 case studies. Matilha companion pack.

**Full description**:
> **Matilha Sysdesign Pack** extends Matilha with 19 distributed-systems skills covering NFR clarification (before diving into design), scalability (horizontal vs vertical), availability SLA tiers, fault tolerance, latency targets, consistency + CAP, common services (load balancers L4/L7, rate limiting strategies, 4 golden signals), design patterns (idempotency, CDN + object store, Kafka event streaming, dead letter queue, dual-write + event sourcing), case-specific patterns (news feed fan-out, autocomplete trie, top-K with count-min sketch), and interview methodology (50-minute flow, explicit tradeoff framing).
>
> Synthesized from Zhiyong Tan's *Acing the System Design Interview* (Manning) plus 11 design case studies.

**Keywords / tags**: `matilha-pack`, `sysdesign`, `distributed-systems`, `scalability`, `nfr`, `architecture`, `tan`.

---

### 1.6 `matilha-software-eng-pack`

**Short tagline**:
> 15 software-engineering skills distilled from day-to-day practice — KISS, commits, documentation, task tracking, critical analysis. Matilha companion pack.

**Full description**:
> **Matilha Software Engineering Pack** is different from the other Matilha packs: it is **opinions from practice**, not a literature summary. Source is the author's own curated engineering rules, refined across multi-week AI-assisted projects.
>
> **Five families of skills**:
> - *Princípios de código* (4) — KISS anti-overengineering, RORO pattern (Return Object / Receive Object), Pythonic idioms, naming that reveals intent.
> - *Documentação viva* (3) — README that doesn't rot, CHANGELOG discipline, a `@documentation/` directory pattern for context preservation.
> - *Rastreabilidade* (2) — atomic + semantic commits, session checklists.
> - *Gestão de tarefas* (3) — `@TODO.md` structure + prioritization, `progresso/atual.md`, task definition + estimation anti-patterns.
> - *Análise crítica* (3) — technical analysis structure, pre-analysis clarifying, technical responsibility (objectivity + critical thinking + what NOT to do).
>
> Install this pack to get the author's way of working, not a textbook.

**Keywords / tags**: `matilha-pack`, `sweng`, `software-engineering`, `kiss`, `code-quality`, `python`, `commits`, `documentation`.

---

## 2. Category tags (marketplace taxonomy)

Suggested canonical categories per plugin:

| Plugin | Primary category | Secondary categories |
|---|---|---|
| `matilha` | `workflow` / `methodology` | `agentic`, `cross-tool` |
| `matilha-ux-pack` | `ux` / `design` | `cognitive-psychology`, `matilha-pack` |
| `matilha-growth-pack` | `growth` / `product-strategy` | `business`, `matilha-pack` |
| `matilha-harness-pack` | `harness` / `agents` | `evals`, `context-engineering`, `matilha-pack` |
| `matilha-sysdesign-pack` | `sysdesign` / `architecture` | `distributed-systems`, `matilha-pack` |
| `matilha-software-eng-pack` | `software-engineering` | `code-quality`, `discipline`, `matilha-pack` |

---

## 3. Search keywords (discoverability)

Deduplicated list to seed any fulltext search index:

```
methodology, cognitive-harness, agentic, multi-week projects, phase-gated, AARRR, JTBD,
positioning, pricing, retention, viral-loops, UX, cognitive-load, Weinschenk, Krug,
neuroscience, visual-hierarchy, trust, usability-testing, agents, harness-engineering,
context-engineering, evals, Anthropic, OpenAI Codex, Lopopolo, agent-centric, NFRs,
Ralph Wiggum loop, distributed-systems, scalability, availability, CAP, consistency,
Zhiyong Tan, system-design-interview, KISS, RORO, Pythonic, commits, changelog,
session-checklists, pre-analysis, technical-responsibility, cross-tool, Claude Code,
Cursor, Codex, Gemini, superpowers, composition
```

---

## 4. Screenshot suggestions

Priority order for submission assets (2-5 images typically accepted):

1. **Sigil + pack preamble in action** — screenshot of a Claude Code session showing the matilha sigil + atmospheric line + pack lines after compose dispatch. This is the single most recognizable asset.
2. **Plugin list after install** — terminal/UI showing `/plugin list` with `matilha` + 2-3 packs installed at `user` scope. Proves the composition layer is real.
3. **Wave 5d smoke trace** — redacted excerpt from `docs/matilha/smoke-results/wave-5d-smoke.md` showing compose's routing steps (good for the harness-pack + methodology crowd who wants to see mechanism).
4. **Dispatch flow diagram** — ASCII or rendered diagram showing `prompt → matilha-compose → {matilha-phase-skill | superpowers:brainstorming with preamble} → pack skills activate on topic surface`.
5. **Packs list visual** — a single image listing all 5 packs with their skill counts + one-line descriptions. Works as social share card.

Optional (for HN / blog): terminal cast (asciinema) of `/plugin install` + first prompt + sigil emission.

---

## 5. FAQ (anticipated submission + community questions)

**Q: How is this different from "a skills marketplace"?**
A: Marketplace skills are independent. Matilha packs compose: core skills delegate to packs via plugin-namespace detection, and brainstorming runs enriched with pack-aware preamble automatically. No hardcoded pack list — new packs are picked up the moment they're installed.

**Q: Why install at user scope instead of per-project?**
A: Claude Code records plugins per-project by default. User-scope install makes the methodology available in every workspace you open, which is the intended usage pattern. A methodology you have to re-install per project is a methodology you stop using.

**Q: Do I need `superpowers:*` installed?**
A: No. Matilha runs standalone with its own methodology core. If superpowers is installed, matilha enriches it (compose routes through superpowers:brainstorming / writing-plans). If superpowers is absent, matilha uses inline clarifying flows. Three-tier model: craft (superpowers) · methodology (matilha) · domain (packs).

**Q: Does it work outside Claude Code?**
A: Yes. Same `.claude-plugin/plugin.json` + `marketplace.json` format works in Cursor and Codex. Gemini compatibility via the same skill discovery pattern. SessionStart hook has branches for Cursor (`CURSOR_PLUGIN_ROOT`) and Copilot CLI.

**Q: Is the CLI on npm?**
A: The `matilha` CLI package exists at v0.4.0 but has not been npm-published at v1.0.0 cut. Plugin install is the recommended path; npm publish sequences post v1.0.0.

**Q: Are the packs paraphrased from source books, or copied?**
A: Paraphrased through three layers of remove: source book → Obsidian wiki concept page → skill body. The validator enforces frontmatter shape, activation-uniqueness heuristics, and (as of Wave 5b) overlap disclosure discipline. Paraphrase-voice is human-enforced during authoring.

**Q: Can I write my own companion pack?**
A: Yes. The contract is documented in `matilha-skills/docs/matilha/companions-contract.md` + `docs/matilha/pack-authors.md`. Declare `matilha-pack` keyword in plugin.json, use the canonical marketplace.json schema, follow the skill authoring guide. Matilha core will discover your pack via plugin-namespace inspection.

**Q: What's the license?**
A: MIT across all 6 repos.

**Q: How mature is the methodology?**
A: 7 waves shipped across the core + packs (Wave 3a through Wave 5f). 1211 validator tests. Smoke-validated in-session in Wave 5d. Methodology core has been in daily use on multi-week real projects since Wave 3a (2026-04-18).

---

## 6. Trust signals (to surface in submission)

- **Test count**: 1211 validation tests covering plugin manifests, skill frontmatter, skill body structure, activation-uniqueness heuristics, overlap disclosures. Green across all 5 packs.
- **Wave iteration evidence**: 7 waves shipped (3a, 3b, 4a, 5a, 5b, 5c, 5d, 5d.1, 5e, 5f) — public commit history + memory docs per wave.
- **Live smoke results**: `docs/matilha/smoke-results/wave-5d-smoke.md` captures real runtime traces showing compose routing + sigil emission + pack detection.
- **Paraphrase discipline documented**: `wiki-ingestion-workflow.md` (packs 5a-5c, 5e) + `source-distillation-workflow.md` (pack 5f).
- **Cross-tool verified**: SessionStart hook has explicit branches for Claude Code, Cursor, and Copilot CLI; code-reviewed, not just claimed.
- **MIT license** across all 6 repos.
- **Author**: Danilo de Sousa (`github.com/danilods`).

---

## 7. Submission order recommendation

When cutting v1.0.0 + submitting to marketplaces:

1. **Resolve pre-release blockers in `v1.0.0-checklist.md`** first. Specifically the overlap-disclosure + README consistency items — those are the questions a reviewer will raise.
2. **Submit `matilha` core first.** It is the anchor. Packs without the core have weaker positioning ("skill bundles").
3. **Submit packs in skill-count order** (biggest first): harness (22), ux (22), growth (20), sysdesign (19), software-eng (15). Reviewer-facing narrative benefits from the biggest anchor packs appearing first in any listing.
4. **Submit the core README excerpt + sigil screenshot as the social card.**

---

## 8. Top submission concerns

Three things most likely to surface from a marketplace reviewer or community reader:

1. **"Why is the core plugin at 0.4.0 while packs are at 0.1.0? And is this v1.0.0?"** — version-bump-strategy.md addresses this; submission materials should reference the strategy explicitly so the numbering doesn't look accidental.
2. **"The ux-pack and growth-pack READMEs don't mention matilha-compose — are they really matilha packs?"** — this is the #1 consistency gap in the audit. Resolve before submission.
3. **"How do I know the skills aren't just copy-pasted from Weinschenk/Krug/Tan?"** — link to the paraphrase-discipline docs + the validator tests + the source distillation workflow explicitly in the submission.

These are all addressable before tag.
