# Changelog

## [1.2.0] — Unreleased — Unified install UX (Wave 5g)

### Added
- feat(templates): canonical CLAUDE.md snippet + merge-or-create contract at docs/matilha/templates/ (Wave 5g SP-B)
- feat(commands): /matilha-install upgraded to interactive wizard with preset selection + CLAUDE.md bootstrap (Wave 5g SP-C)

## [1.1.0] — 2026-04-24 — Polish release (sigil + README + CI)

Incremental post-1.0.0 improvements. No breaking changes; all packs retain identical activation semantics. Users on 1.0.0 can upgrade freely.

### Added
- **`/matilha-install` slash command** — formatted install guide rendered inside Claude Code. Reduces friction for users adding companion packs after the core install. Per-pack table with triggering-intent descriptions.
- **Deterministic sigil rendering** — new `hooks/print-sigil.sh` + `assets/sigil.txt` (+ `sigil-w50.txt`, `sigil-w60.txt`, `sigil-w80.txt` variants). Replaces LLM-reproduced sigil with a Bash-invoked renderer. Eliminates character-drift; unlocks richer ASCII/braille output without reproduction fragility. Default is braille 60×30 for maximum visual fidelity; ASCII fallbacks shipped for terminals without UTF-8 braille font support.
- **Ecosystem map in README** — table listing all 9 matilha repos with roles (hub / CLI / 7 packs), enabling new visitors to understand the surface area within seconds.
- **"Born from the field" section in README** — attribution to Gravicode, CNH Pass, Sinapise, Speechia, Argos as the real agentic-coding projects that shaped matilha's Caminho C packs. Establishes lineage and authority without oversell.
- **"Inspired by" section in README** — Karpathy's LLM-OS, Anthropic harness engineering, OpenAI Codex agent-centric, Zhiyong Tan, Weinschenk, Krug, Eyal, Lopopolo. Intellectual transparency.
- **20 GitHub repository topics** configured via `gh repo edit`: matilha, claude-code, claude-code-plugin, ai-assisted-development, llm-methodology, agent-orchestration, multi-agent, context-engineering, agentic-patterns, cognitive-harness, prompt-engineering, cursor, gemini-cli, codex, anthropic, skills, harness-engineering, composition-layer, software-methodology, llm-ops.
- **`docs/rules/`** — 9 canonical Caminho C rules shipped with the core plugin for transparency (5 architecture + 4 security).
- **`docs/staging/caminho-c-arch/`** + **`docs/staging/caminho-c-security/`** — historical drafting artifacts for Waves 5h and 5i.
- **`assets/` directory** with banner placeholder + sigil variants.

### Changed
- **README.md — v2 redesign** applying matilha's own pack principles (Weinschenk attention, Krug 5-second test, cognitive-load ≤7-item chunking, progressive disclosure, anticipation + aha moments, social proof). 109 → 312+ lines. English examples throughout; all atmospheric preambles translated (sigil text adapts to prompt language at runtime).
- **GitHub repository description** — "You lead. Agents hunt. Cognitive + methodological harness for AI-assisted software — 139 skills across 7 companion packs + composition layer. Cross-tool (Claude Code, Cursor, Codex, Gemini CLI)."
- **All 7 companion pack READMEs** updated with "🏠 This is a companion pack" call-out pointing back to `danilods/matilha-skills` as canonical entry point. Canonical hub + satellites navigation pattern.
- **ux-pack + growth-pack + harness-pack READMEs** — added user-scope install recommendation + matilha-compose reference (resolves pre-v1.0.0 audit blocker).

### Fixed
- **CI workflow** — removed obsolete MATILHA_MANAGED marker check (Wave 4a eliminated these markers; CI was never updated). Replaced with canonical 11-section check aligned with the matilha CLI validator. Unblocks every skill-added push since Wave 4a (matilha-bootstrap, matilha-compose, matilha-review).
- **marketplace.json schema** for matilha-ux-pack + matilha-growth-pack — flat schema replaced with canonical `owner + metadata + plugins[]` shape (resolves the Wave 5c cleanup TODO). Both packs now live-installable via `/plugin install`.

## [1.0.0] — 2026-04-23 — First official release

Matilha ecosystem reaches v1.0.0. Core plugin (matilha-skills) + 7 companion packs shipped.

**You lead. Agents hunt.**

### Ecosystem summary

- **Core**: 11 methodology skills + matilha-compose gateway + matilha-bootstrap SessionStart hook + matilha-design UX router + matilha-init bootstrap.
- **7 companion packs**: 128 domain skills across ux, growth, harness, sysdesign, software-eng, software-arch, security.
- **Total**: 139 skills + full composition architecture (plugin-namespace detection + storytelling sigil preamble + lazy-bootstrap).
- **Cross-tool**: Claude Code, Cursor, Codex, Gemini CLI.
- **Twin identity**: npm CLI (`matilha@1.0.0`) + plugin ecosystem, both shipped.

### What the 1.0.0 tag signifies

- All 6 live-installable companion-pack marketplace.json schemas pass Claude Code validator (cleanup completed for ux + growth in Wave 5d.1 + 5h/5i cycle).
- SessionStart hook validated in runtime smoke (Wave 5d.1 storytelling mode — see `docs/matilha/smoke-results/wave-5d-smoke.md` sub-result 1d).
- 1466 validator tests passing in the matilha CLI, zero regressions across the arc 3a → 5i.
- Paraphrase + distillation discipline enforced (3-layer for literature packs, 2-layer for Caminho C packs).
- Honest scope framing — each pack declares what it does NOT cover.

### Install (recommended: user scope)

```
/plugin marketplace add danilods/matilha-skills
/plugin install matilha@matilha-skills --user
```

Then install companion packs à la carte (all user-scope recommended):

```
/plugin install matilha-ux-pack@matilha-ux-pack --user
/plugin install matilha-growth-pack@matilha-growth-pack --user
/plugin install matilha-harness-pack@matilha-harness-pack --user
/plugin install matilha-sysdesign-pack@matilha-sysdesign-pack --user
/plugin install matilha-software-eng-pack@matilha-software-eng-pack --user
/plugin install matilha-software-arch-pack@matilha-software-arch-pack --user
/plugin install matilha-security-pack@matilha-security-pack --user
```

Or via npm for CLI-only:

```
npm install -g matilha
```

### Post-1.0.0 roadmap (teaser)

- Additional companion packs from Danilo's B-pack queue (TBD domains)
- Wave 3c `matilha-review` runtime (6-agent parallel quality review)
- Formal `sec-*` literature-based security pack (STRIDE + OWASP + Shostack) as complement to the AI-ops `swsec-*` baseline

### Source-of-record for 1.0.0 content

- See below (Wave 5i, 5h, 5f, 5e, 5d.1, 5d, 5c, 5b, 5a, 4a, 3b, 3a) for the full shipped arc.

## [Wave 5i] — 2026-04-23 — matilha-security-pack shipped (Caminho C, AI-ops scoped)

Seventh companion pack shipped. Third Caminho C pack. **Honest scope framing**: baseline for AI-assisted software operational security, does NOT replace formal STRIDE/OWASP/Shostack threat modeling (those would ship in a future `sec-*` literature-based pack). 13 skills in 5 families.

### New external pack

- **[matilha-security-pack](https://github.com/danilods/matilha-security-pack) v0.1.0** — 13 skills (trust+key × 3, backend-only × 3, LLM risks × 3, LGPD × 2, operational defense × 2). Caminho C source: 4 new rules in `docs/rules/` (1,110 lines). Tag `wave-5i-security-pack-0.1.0`.

### New rules (in matilha-skills)

- `docs/rules/Trust Boundary e Secret Management.md` (240 lines)
- `docs/rules/LLM-Specific Operational Risks.md` (253 lines)
- `docs/rules/PII e LGPD na Prática.md` (282 lines)
- `docs/rules/Defesa Operacional por Engenharia.md` (335 lines)

### Cross-repo

- `matilha` CLI validator extended with 110 new tests. Total: 1356 → 1466 passing, zero regressions.

### Overlap disclosures (2)

- `swsec-rate-limiting-as-defense` **Complementa** `matilha-sysdesign-pack:sysdesign-rate-limiting-strategies` — sysdesign focuses on algorithms (token bucket vs sliding window); swsec focuses on rate limiting as primary abuse defense + fail-closed discipline.
- `swsec-llm-cost-as-availability` **Complementa** `matilha-harness-pack:harness-nfrs-as-prompts` — harness treats NFRs as constraints in system prompts; swsec treats LLM cost runaway as availability risk.

## [Wave 5h] — 2026-04-23 — matilha-software-arch-pack shipped (Caminho C)

Sixth companion pack shipped. Second Caminho C pack — architectural patterns distilled from Argos + Gravicode practice. 17 skills in 5 families.

### New external pack

- **[matilha-software-arch-pack](https://github.com/danilods/matilha-software-arch-pack) v0.1.0** — 17 skills in 5 families (layering × 3, event-driven × 4, data architecture × 4, bounded contexts × 3, scaling × 3). Caminho C source: 5 rules drafted in `docs/rules/` (981 lines, same content shipped inside the pack for transparency). Tag `wave-5h-software-arch-pack-0.1.0`.

### New rules (in matilha-skills)

- `docs/rules/Layering e Dependency Direction.md` (156 lines)
- `docs/rules/Event-Driven Decoupling.md` (187 lines)
- `docs/rules/Dual-Store Architecture.md` (201 lines)
- `docs/rules/Bounded Contexts na Prática.md` (212 lines)
- `docs/rules/Escalabilidade sem Prematuridade.md` (225 lines)

### Cross-repo

- `matilha` CLI validator extended with 145 new tests. Total: 1211 → 1356 passing, zero regressions.

### Overlap disclosures (5)

- `swarch-dual-store-source-of-truth` **Complementa** `matilha-sysdesign-pack:sysdesign-dual-write-event-sourcing` — sysdesign treats dual-write as anti-pattern + 3 alternatives; swarch focuses on Postgres-SoT + Dynamo-hot-state via CDC.
- `swarch-event-gateway-boundary` **Complementa** `matilha-sysdesign-pack:sysdesign-event-streaming-kafka` — sysdesign decides Kafka vs alternatives; swarch designs Event Gateway boundary for fan-out.
- `swarch-ticker-vs-rule-per-entity` + `swarch-pull-over-push-orchestration` **Complementam** `matilha-sysdesign-pack:sysdesign-scalability-horizontal-vs-vertical` — sysdesign structural; swarch brings concrete Argos cases.
- `swarch-lambda-chain-shape` **Complementa** `matilha-harness-pack:harness-orchestrator-workers` — same abstract shape, different substrates (AWS Lambda vs LLM agents).

## [Wave 5f] — 2026-04-23 — matilha-software-eng-pack shipped (Caminho C)

Fifth companion pack shipped. First Caminho C (opinions-from-practice) pack — distilled from Danilo-experience rules, not literature. 15 skills on day-to-day coding discipline.

### New external pack

- **[matilha-software-eng-pack](https://github.com/danilods/matilha-software-eng-pack) v0.1.0** — 15 skills in 5 families (princípios de código × 4, documentação viva × 3, rastreabilidade × 2, gestão de tarefas × 3, análise crítica × 3). Source: `/Memory/docs/rules/` (7 documents, ~2,095 lines — Danilo's curated engineering rules). Tag `wave-5f-software-eng-pack-0.1.0`.

### New workflow documented

- First pack to introduce the **source distillation workflow** (2-layer distillation from Danilo rule → skill) as opposed to the 3-layer paraphrase workflow (book → wiki concept → skill) used by ux/growth/harness/sysdesign packs. This keeps Danilo's voice intact — the pack is opinions-from-practice, not literature summary.

### Updated

- `README.md` — companion packs list references software-eng-pack as 5th shipped pack. Reserved packs list updated accordingly.

### Cross-repo

- `matilha` CLI validator extended with 126 new tests. Line-range for sweng skills relaxed to 100-500 (vs 150-500 for other packs) to accommodate 2-layer distillation's natural compactness. Uniqueness heuristic's stopword list expanded with PT terms (de, da, do, para, com, em, quando, que, ao) since source rules are in Portuguese. Total: 1085 → 1211 passing, zero regressions.

### Overlap disclosures

- `sweng-kiss-antidote-overengineering` **Complementa** `matilha-harness-pack:harness-code-is-free` — harness treats code as cheap (AI writes fast); sweng-kiss treats simplicity as human-architectural-value discipline.
- `sweng-pre-analise-clarifying` **Complementa** `matilha:matilha-plan` — matilha-plan for new features (spec authoring); sweng-pre-analise for reviewing existing code/architecture (diagnose before judge).

## [Wave 5e] — 2026-04-23 — matilha-sysdesign-pack shipped

Fourth companion pack shipped. Distributed-systems methodology layer, zero overlap with ux/growth/harness. Established from Wave 5d.1 composition infrastructure (plugin-namespace detection, sigil emission, lazy-bootstrap).

### New external pack

- **[matilha-sysdesign-pack](https://github.com/danilods/matilha-sysdesign-pack) v0.1.0** — 19 skills synthesized from Zhiyong Tan's *Acing the System Design Interview*. Families: NFR framework (6), common services (3), design patterns (5), case-specific patterns (3), methodology (2). Tag `wave-5e-sysdesign-pack-0.1.0`.

### Updated

- `README.md` — companion packs list now references sysdesign-pack as 4th shipped pack. Reserved-pack list updated to reflect Wave 5d.1 decisions (software-eng-pack next, software-arch-pack deferred until Uncle Bob + Evans wiki ingestion, security-pack deferred until OWASP + Shostack ingestion).

### Cross-repo

- `matilha` CLI validator extended with 157 new tests (frontmatter schema, body section compliance, overlap disclosure). Total validator tests: 928 → 1085, zero regressions.

### Overlap disclosures

- `sysdesign-nfr-clarification` **Complementa** `matilha-harness-pack:harness-nfrs-as-prompts`. Sysdesign encodes NFRs as clarifying questions during spec/design authoring (human-facing); harness encodes NFRs as system-prompt constraints for AI agents (agent-facing). Same principle ("requirements before decisions"), different audiences.

## [Wave 5d.1] — 2026-04-22 — Methodology-First Pivot

Broadens Wave 5d activation scope from "matilha projects only" to "any workspace where matilha is installed". Matilha methodology is now universally available whenever the plugin is loaded; companion packs become optional enrichment rather than activation gates. Corrects the value-proposition inversion that Wave 5d's narrow gate had introduced.

### Changed

- `skills/matilha-compose/SKILL.md` — activation gate expanded from "matilha project context" to "matilha installed" (self-detected via ambient skill list presence). Intent classification expanded from creative-work-only to full software-construction (planning / designing / researching / building / reviewing / dispatching / status / merging). Dispatch table expanded to 12 routing targets (7 matilha phase skills + brainstorming + writing-plans + ambiguous fallback). `docs/matilha/`, `project-status.md`, and `matilha-*-pack` visibility reclassified as supplementary routing signals, not activation gates. Companion Integration restructured into three-tier model: superpowers (craft layer), matilha phases (methodology layer), packs (domain knowledge layer). Explicit "Matilha is never hostage to superpowers" — standalone mode via internal clarifying flows when superpowers absent.
- `CLAUDE.md` — activation priority instruction broadened from "in matilha projects" to "whenever matilha is installed in this workspace". Explicit note that matilha wraps superpowers (not replaces) and that phase skills lazy-create `docs/matilha/` structure without requiring matilha-init.
- `skills/matilha-plan/SKILL.md` — `project-status.md` precondition removed. Step 1 now lazy-bootstraps: `mkdir -p docs/matilha/{specs,plans,research}` and writes minimal `project-status.md` stub if absent before proceeding.
- `skills/matilha-scout/SKILL.md` — same lazy-bootstrap pattern. Mkdir `docs/matilha/research/`, stub project-status.md when absent.
- `skills/matilha-howl/SKILL.md` — reports on a lazy-bootstrapped stub when `project-status.md` is missing (next_action points user to scout/plan/init).

### Philosophy

- **Matilha as methodology harness applicable everywhere** — the plugin install is the opt-in signal; no per-project bootstrap required.
- **Superpowers as craft engine** — matilha routes to superpowers for the how-do-I-brainstorm / how-do-I-write-plans / how-do-I-TDD craft concerns; matilha tracks phases + state + learnings on top.
- **Packs as optional domain enrichment** — surface value when installed + relevant; silent pass-through when absent. Never the reason matilha fires or doesn't.
- **Lazy bootstrap** — matilha-init becomes implicit, invoked as a side effect of the first phase skill that needs to write artifacts.

## [Wave 5d] — 2026-04-22 — Composition Layer

Make matilha core skills pack-aware orchestrators. Closes the Wave 5c smoke gap where `superpowers:brainstorming` intercepted creative-work prompts in matilha projects without companion-pack awareness.

### Added

- `skills/matilha-compose/SKILL.md` — new gateway skill (14 sections: 12 canonical + Pack awareness + Fallback semantics). Detects installed companion packs via plugin-namespace inspection (`matilha-*-pack` pattern), classifies user intent semantically, injects pack-aware preamble when dispatching to `superpowers:brainstorming`, routes to `matilha:matilha-plan` / `matilha:matilha-design` for explicit planning/design prompts.
- `CLAUDE.md` — new "CRITICAL — activation priority in matilha projects" section instructing the harness to invoke `matilha:matilha-compose` BEFORE `superpowers:brainstorming` in matilha projects. Backup plan per spec §11 risk #1 — was the final mechanism needed to win activation after skill-description strength alone proved insufficient.
- `docs/matilha/specs/wave-5d-composition-layer-spec.md` — design spec.
- `docs/matilha/plans/wave-5d-composition-layer-plan.md` — implementation plan (4 SPs + SP0 activation-gate spike).
- `docs/matilha/smoke-results/wave-5d-smoke.md` — smoke results and iteration history.

### Changed

- `skills/matilha-plan/SKILL.md` — Execution Workflow step 2 expanded from one-line brainstorming delegation to five-substep pack-aware block (detection + classification + preamble build + emit + fallback). Companion Integration cross-references `matilha-compose` as canonical template source.
- `skills/matilha-design/SKILL.md` — Execution Workflow restructured with explicit Pack detection (step 1) + Intent classification (step 2) + intent-based routing (step 3) + core-heuristics fallback (step 4). Companion Integration cross-references `matilha-compose`.
- `.claude-plugin/marketplace.json` — switched from flat schema to canonical `owner` + `metadata` + `plugins[]` shape matching `matilha-harness-pack`. Previous schema failed Claude Code's marketplace validator and blocked live install. `plugins[0].name` now `matilha` (matching `plugin.json`); install command: `/plugin install matilha@matilha-skills`.
- `index.json` — registered `matilha-compose` entry.

### Fixed

- Composition gap surfaced during Wave 5c smoke: `superpowers:brainstorming` intercepting creative-work prompts in matilha projects without companion-pack awareness. End-to-end flow now: compose wins activation (via CLAUDE.md priority) → detects packs dynamically via plugin-namespace inspection → classifies intent → dispatches enriched.

### Design decisions locked

- **Detection**: plugin-namespace pattern `matilha-*-pack` as sole signal. Zero hardcoded pack list in skill body. Self-healing — packs uninstalled disappear, new packs appear automatically.
- **Classification**: prose-semantic inline, no subagent dispatch, no keyword maps.
- **Preamble format**: per-pack synthesis + skill list + guidance paragraph (~30-40 lines). Emitted only when terminal destination is `superpowers:brainstorming`; compose routes to plan/design without preamble (those skills handle their own enrichment).
- **Activation priority**: dual-layer — skill description (competitive) + CLAUDE.md instruction (ambient, higher priority).

## [0.4.0] — 2026-04-19 — Wave 4a: Plugin Activation + Companion Contract

### Added

- `.claude-plugin/plugin.json` + `marketplace.json` — Claude Code and Cursor plugin manifests.
- `gemini-extension.json` — Gemini CLI extension.
- `CLAUDE.md` + `GEMINI.md` + `AGENTS.md` — context primers with the slogan "You lead. Agents hunt."
- `docs/matilha/companions-contract.md` — formal companion-pack detection + delegation contract.
- `docs/matilha/skill-authoring-guide.md` — strict frontmatter schema, description activation phrasing, 12-section body structure.
- `docs/matilha/naming-conventions.md` — skill/agent/command/pack prefix rules.
- `docs/matilha/pack-authors.md` — how to ship a companion pack.
- `docs/matilha/wave-4a-smoke-results.md` — structural smoke + deferred manual validation plan.
- `docs/platform-tool-mapping.md` — Claude Code ↔ Cursor ↔ Codex ↔ Gemini tool equivalents.
- `.claude-plugin/agents/matilha-code-architect.md` — seed agent; routes features through phases 10/20/30/40.
- `.claude-plugin/agents/matilha-plan-reviewer.md` — seed agent; audits draft plans against 7 quality gates.

### Changed

- All 10 core skills (`skills/matilha-*/SKILL.md`) rewritten with canonical frontmatter (name, description starting with "Use when", category, version) and 12-section body structure. Wave 2a/2f-era `MATILHA_MANAGED` markers and `## Mission` / `## SoR Reference` sections replaced with the new structure documented in `docs/matilha/skill-authoring-guide.md`.
- All 9 slash commands (`commands/*.md`) reduced to thin wrappers invoking their corresponding `matilha-*` skill. Each command body is ≤ 5 lines.
- README.md rewritten with Matilha-as-platform framing (companion packs, cross-platform install, interop with superpowers).

### Notes

- Zero changes to `matilha` CLI logic. The CLI repo drops 4 vestigial plugin stubs (`.claude-plugin/`, `.cursor-plugin/`, `.codex/`, `gemini-extension.json`) and 4 obsolete manifest tests as part of cleanup. CLI stays at 0.4.0.
- The plugin path is self-sufficient — no `npm install` required to use `/matilha-init`, `/matilha-plan`, `/matilha-hunt`, etc.
- Companion pack implementations (UX, growth, design, security, harness) deferred to Wave 5+.
- Matilha CLI test suite extended with 44 new validation tests (skill frontmatter schema, description linter, plugin manifests, context files, agent frontmatter, governance docs, tool mapping completeness). Final count: 437/437 green.
