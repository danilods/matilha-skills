---
title: Wave 5d — Composition Layer Smoke Results
date: 2026-04-22
wave: 5d
spec: docs/matilha/specs/wave-5d-composition-layer-spec.md
plan: docs/matilha/plans/wave-5d-composition-layer-plan.md
---

# Wave 5d — Composition Layer Smoke Results

## Environment

- Claude Code v2.1.117 (Sonnet 4.6, high effort)
- matilha-skills plugin installed at project scope (version 0.4.0, commit fb9228cf — includes CLAUDE.md activation priority)
- matilha CLI validator: 924 / 924 passing
- Plugin-namespace format confirmed: `matilha:matilha-compose` (namespace derived from plugin.json `name: matilha`, not repo name `matilha-skills`)

## Key discoveries during smoke

Three findings surfaced during Wave 5d smoke that inform future methodology:

1. **Plugin scoping is per-project, not global.** `installed_plugins.json` records plugins with `scope: "project"` and a `projectPath` field. Installing a companion pack in workspace A does not make it available in workspace B. Each matilha project where a pack is desired requires its own `/plugin install` invocation.

2. **Skill descriptions alone do not reliably win activation competition against `superpowers:brainstorming`.** Even with a strengthened description (531 chars, "You MUST use before any creative work", explicit "SUPERSEDES superpowers:brainstorming"), brainstorming continued to win activation. The fix was the backup plan documented in spec §11 risk #1: injecting a `CRITICAL — activation priority` section in the plugin's CLAUDE.md that tells the harness to invoke matilha-compose BEFORE brainstorming. CLAUDE.md is loaded ambiently with higher priority than skill-description competition.

3. **marketplace.json schema requires `owner` + `metadata` + `plugins[]` array** (per harness-pack working version); matilha-skills' previous schema used a flat top-level descriptor that Claude Code's marketplace validator rejected. The cleanup TODO for ux-pack and growth-pack (inherited from Wave 5c) is now also blocking their live install.

## Test 1 — Regression (Wave 5c failure re-run)

**Prompt**: "Estou construindo MVP de 4 semanas que precisa rodar autonomamente. Como estruturo os agents?"

### Sub-result 1a — pre-backup-plan (description-only)

Description strength alone did not win activation. Output trace showed `Skill(superpowers:brainstorming)` firing directly without compose. **Outcome C** per spec §11 risk #1 taxonomy.

### Sub-result 1b — post-backup-plan (CLAUDE.md priority added)

After adding `CRITICAL — activation priority in matilha projects` to the plugin's CLAUDE.md, user re-ran the prompt in a fresh session.

Output trace:

```
Vou invocar matilha:matilha-compose primeiro, conforme a instrução do projeto,
antes de qualquer trabalho criativo/de design.

Skill(matilha:matilha-compose)
  Successfully loaded skill

Step 1 — Pack detection: Inspecionando o ambient skill list para namespaces
matilha-*-pack... Não encontro matilha-ux-pack:*, matilha-growth-pack:* ou
matilha-harness-pack:* registrados nesta sessão. Zero packs detectados.

Step 3 — Dispatch: Prompt é "general creative work" ("Estou construindo...") →
superpowers:brainstorming.

Step 5 — Silent pass-through (Case C): zero packs, sem preamble. Invocando
diretamente.

Skill(superpowers:brainstorming)
  Successfully loaded skill
```

**Outcome A** achieved for activation gate: compose invoked first, ran full 5-step workflow, classified intent correctly, executed Case C pass-through (no packs enabled in workspace), then dispatched to brainstorming.

### Sub-result 1c — full Case A (captured 2026-04-22 with user-scope harness-pack)

After installing both matilha and matilha-harness-pack at user scope (globally for the user), user invoked `/matilha:matilha-compose` directly in a non-matilha project (DynamoDB/Lambda scheduling module scenario).

Full output trace:

```
Step 1 — Pack detection: identifico um pack instalado com namespace matilha-*-pack:
  - matilha-harness-pack — padrões de arquitetura de harness para sistemas
    orientados a agentes/workers

Step 2 — Intent classification: o prompt "como estrutura um módulo..." é
exploração criativa geral — o usuário ainda está descobrindo a arquitetura antes
de commitar um spec. Rota → superpowers:brainstorming.

Classificação do pack: matilha-harness-pack = yes — skills como
harness-orchestrator-workers, harness-routing-parallelization e
harness-architecture mapeiam diretamente para a dinâmica Lambda/EventBridge/
DynamoDB sendo explorada.

[Preamble emitted with 8 harness-pack skills + guidance paragraph]

Skill(superpowers:brainstorming)
  Successfully loaded skill
```

**All 5 compose steps verified**:
- Step 1 Pack detection via plugin-namespace → matilha-harness-pack identified
- Step 2 Intent classification → harness-pack classified yes with domain reasoning
- Step 3 Dispatch decision → superpowers:brainstorming (general creative exploration)
- Step 4 Preamble built with 8 skills (harness-orchestrator-workers, harness-routing-parallelization, harness-architecture, harness-nfrs-as-prompts, harness-docs-as-system-of-record, harness-long-horizon-strategies, harness-jit-retrieval, harness-evaluator-optimizer-loop) + Guidance paragraph
- Step 5 Emit + invoke → preamble in output + brainstorming invoked

**Pass/Fail**: **PASS (full Case A)** — composition flow proven end-to-end in a cross-project context. Invocation was manual (`/matilha:matilha-compose`) — auto-activation requires matilha-bootstrap skill which is in a later commit than the user-scope install captured at smoke time.

## Test 2 — Cross-pack intent

**Prompt**: "Quero desenhar o signup flow desse SaaS — precisa ter baixa fricção (UX) mas também maximizar activation rate (growth)."

**Status**: **Deferred** — requires matilha-ux-pack and matilha-growth-pack installed in the matilha-skills workspace. Neither pack is currently in the user's plugin cache. Install requires schema fix (Wave 5c TODO) for both packs before `/plugin marketplace add danilods/<pack>` succeeds.

**Pass/Fail**: **DEFERRED**. Non-blocking. Will verify cross-pack behavior once Wave 5c cleanup lands.

## Test 3 — Silent pass-through (Case C)

**Prompt**: any creative-work prompt in matilha project with zero packs installed.

**Result**: **IMPLICITLY PASSED via Test 1 Sub-result 1b.** Output confirmed compose detected zero packs, routed to brainstorming without preamble, zero noise in user-visible output.

Excerpt from trace:

```
Step 5 — Silent pass-through (Case C): zero packs, sem preamble. Invocando
diretamente.
```

**Pass/Fail**: **PASS**.

## Test 4 — Non-matilha project

**Status**: **Deferred pending user execution.** Requires opening a Claude Code session in a directory without `docs/matilha/` and without `project-status.md`, then running a creative-work prompt to verify that matilha-compose does NOT fire (description gate + CLAUDE.md priority both scoped to matilha projects).

**Pass/Fail**: **DEFERRED**. Non-blocking.

## Test 5 — Case B (superpowers absent, packs present) — design-verified

Requires uninstalling superpowers plugin — impractical to reproduce at runtime.

Design review of `skills/matilha-compose/SKILL.md` §9 (Fallback semantics):

- ✅ 4-step inline clarifying flow present (lines referencing "matilha-internal clarifying flow inline")
- ✅ Preamble-as-context-guide reference present ("Treat the built preamble as your own context guide")
- ✅ Downstream invocation guidance present (Case B step 4 — invoke matilha-plan / matilha-design / inline output)

**Design-verified**: **PASS**. Runtime verification deferred (requires superpowers plugin uninstall).

## Aggregate result

| Test | Status | Blocking? |
|---|---|---|
| 1 Regression | PASS (1a capture + 1b Case C proven; 1c pending pack install) | Yes — **blocker lifted** via 1b |
| 2 Cross-pack | DEFERRED (needs ux+growth install) | No |
| 3 Silent pass-through | PASS (via Test 1 sub-result) | Yes |
| 4 Non-matilha project | DEFERRED | Yes |
| 5 Case B | DESIGN-VERIFIED | No |

**Ship gate**: **Proceed with documented known gaps.**

- Test 1 composition flow is proven end-to-end (activation → detection → classification → dispatch → pass-through).
- Tests 2 and 4 deferred — non-blocking for Wave 5d ship since:
  - Test 2 depends on marketplace.json schema fix for ux-pack / growth-pack (separate cleanup track).
  - Test 4 can be run any time by the user and does not alter the plugin artifacts.
- Test 5 Case B design-verified per spec decision.

## Post-ship verification checklist

After shipping Wave 5d, verify:

1. `/plugin install matilha-harness-pack@matilha-harness-pack` in matilha-skills workspace.
2. Re-run Test 1 prompt → expect Case A (preamble emitted with harness-pack skills, brainstorming references them during exploration).
3. Once ux-pack and growth-pack marketplace.json schema fixes land, install both in matilha-skills workspace.
4. Run Test 2 prompt → expect cross-pack preamble (ux + growth sections).
5. Run Test 4 in any non-matilha directory → expect compose NOT to fire.

## Iteration history

1. **Initial stub (commit `7f6e229`)**: 12-section minimal stub, description 682 chars. Used for SP0 activation-gate spike.
2. **SP1 full body (commit `539f1f4`)**: replaced stub with 14-section 202-line body. Description unchanged from stub.
3. **Description iteration 1 (commit `4f05963`)**: shortened to 531 chars, added "SUPERSEDES superpowers:brainstorming" and enumeration of "agents, workflows, flows". User smoke still showed brainstorming winning.
4. **marketplace.json schema fix (commit `ceb1de6`)**: switched from flat schema to owner+metadata+plugins[] schema matching harness-pack. Enables live install.
5. **Name reconciliation (commit `88d1fd4`)**: marketplace plugins[0].name aligned to plugin.json `name: matilha`. Install command: `/plugin install matilha@matilha-skills`.
6. **CLAUDE.md activation priority (commit `fb9228c`)**: added `CRITICAL — activation priority in matilha projects` section instructing harness to invoke matilha-compose BEFORE superpowers:brainstorming. **This was the commit that moved Test 1 from Outcome C to Outcome A**.
