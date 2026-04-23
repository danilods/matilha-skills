# Changelog

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
