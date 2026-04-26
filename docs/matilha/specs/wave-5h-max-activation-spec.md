---
slug: wave-5h-max-activation
phase: 20
status: spec_ready
created: 2026-04-24
---

# Wave 5h — Maximum Deterministic Pack Activation

## Purpose

Pack activation in matilha is currently probabilistic: compose relies on LLM semantic classification to decide which packs are relevant. Two root causes produce misses:

1. **No CLAUDE.md on fresh installs** — after `claude plugin marketplace add`, no activation-priority rule is written. Compose may not even win the activation contest; `superpowers:brainstorming` fires directly.
2. **Non-deterministic LLM classification** — the same prompt can yield different pack selections across sessions. Keywords like "DDD", "AARRR", or "RAG" are pack-strong signals, but a general prompt mixing domains can miss a pack on a given run.

Wave 5h eliminates both failure modes via two complementary mechanisms:

- **Routing table** (compose-path): explicit keyword→pack mapping read by compose Step 2 before LLM classification. High-confidence keyword matches are resolved deterministically.
- **Trigger skills** (independent path): one skill per pack, living in the pack itself, with a keyword-rich description. Fires via Claude Code's native skill-selection when pack keywords appear in a prompt — regardless of compose or CLAUDE.md.

Combined, the two mechanisms cover all activation surfaces:
- Compose activated (CLAUDE.md present) → routing table ensures pack selection is deterministic for known keywords.
- Compose not activated (no CLAUDE.md) → trigger skill in the pack fires independently.

## Design Principles

1. **Determinism over confidence**: keyword lookup is O(n_keywords), reproducible across runs. LLM semantic classification is reserved for ambiguous intents not covered by the table.
2. **Pack independence**: trigger skills must work when compose is absent. They are the pack's first-class activation signal, not a compose fallback.
3. **No false negatives over false positives**: keyword lists err inclusive. A tangential keyword firing a pack costs one extra skill in context; a missed keyword costs a missed pack — asymmetric harm.
4. **Minimal surface area per SP**: routing table is a Markdown file (read by compose via Bash cat or inline); trigger skills are SKILL.md files with no new runtime dependencies.

## Architecture

### SP-A: Routing Table + Compose Step 2 Update

**File**: `skills/matilha-compose/routing-table.md`

Format:
```
# keyword → pack-namespace
keyword (exact, case-insensitive) | pack-namespace
```

One entry per line, `|`-delimited. Compose reads the table via Bash (`cat routing-table.md`) or inline read, then matches against user prompt before running LLM classification.

**Compose Step 2 update** — new preamble before existing prose classification:

> 2a. Read `routing-table.md` (co-located with this skill). For each entry, check if the user prompt contains the keyword (case-insensitive). If a keyword matches, mark that pack as `relevant` — deterministic, no LLM inference needed.
>
> 2b. For packs not matched in step 2a, apply prose semantic classification as before.

Fallback: if routing-table.md is unavailable (Bash blocked), skip 2a and proceed with 2b prose classification only.

### SP-B: 7 Trigger Skills

One trigger skill per pack, living inside each companion pack's `skills/` directory.

| Pack | Trigger skill path | Description seed |
|---|---|---|
| matilha-ux-pack | `skills/matilha-ux-trigger/SKILL.md` | UI, UX, design, interface, component, layout, typography, color, visual hierarchy, cognitive load, wireframe, design system, Figma, accessibility, responsive, mobile, onboarding, navigation, attention, habit, dopamine, pricing, choice, social proof |
| matilha-growth-pack | `skills/matilha-growth-trigger/SKILL.md` | AARRR, acquisition, activation, retention, referral, revenue, funnel, conversion, churn, North Star, viral, k-factor, JTBD, switch, hook model, engagement, DAU, MAU |
| matilha-harness-pack | `skills/matilha-harness-trigger/SKILL.md` | agent, multi-agent, orchestrator, planner, executor, subagent, eval, LLM, prompt, harness, RAG, retrieval, grader, transcript, context window |
| matilha-sysdesign-pack | `skills/matilha-sysdesign-trigger/SKILL.md` | system design, architecture, scale, scalability, distributed, latency, throughput, availability, CAP, database, cache, queue, rate limiting, CDN, microservices, SLA, NFR, capacity, bottleneck |
| matilha-software-eng-pack | `skills/matilha-software-eng-trigger/SKILL.md` | commit, PR, review, refactor, TODO, backlog, KISS, DRY, TDD, coverage, diff, context loss, session, blocker, clean code, naming, technical debt |
| matilha-software-arch-pack | `skills/matilha-software-arch-trigger/SKILL.md` | hexagonal, DDD, bounded context, event sourcing, CQRS, CDC, outbox, Lambda, pipeline, saga, adapter, handler, clean architecture, dependency direction, layer |
| matilha-security-pack | `skills/matilha-security-trigger/SKILL.md` | security, auth, JWT, OAuth, RBAC, LGPD, GDPR, PII, input validation, XSS, injection, secrets, credentials, API key, rate limiting, encryption, OWASP |

**Trigger skill body contract**:
1. Check ambient skill list for skills in the corresponding pack namespace (e.g., `matilha-ux-pack:*`).
2. If pack is installed: emit mini domain intro (2 lines max) + list most relevant pack skills for the detected sub-intent. Invoke the best-matching pack skill via Skill tool.
3. If pack is not installed: emit a one-line nudge: "matilha-ux-pack not installed — run `/matilha-install` to add UX methodology skills." Then proceed with matilha-compose or superpowers default flow.

Trigger skills do NOT emit the full compose sigil (that belongs to compose). They emit a compact pack-specific acknowledgment.

## Data Flow

```
User prompt arrives
        │
        ├─[compose active, CLAUDE.md present]─────────────────────────────┐
        │                                                                  │
        │   Step 2a: routing-table.md keyword lookup                       │
        │   ─ keyword match → pack marked `relevant` (deterministic)       │
        │   ─ no match → Step 2b prose semantic classification             │
        │   Step 3: dispatch decision (unchanged)                          │
        │   Step 4: emit preamble with matched packs                       │
        │   → superpowers:brainstorming or matilha phase skill             │
        │                                                                  │
        └─[compose NOT active, pack installed]────────────────────────────┐
                                                                          │
            Trigger skill description matches prompt keywords             │
            → Claude Code native skill selection fires trigger            │
            → Trigger emits domain intro + routes to pack skill           │
            (compose is bypassed; pack gets context regardless)           │
```

## Keyword Coverage per Pack

Routing table includes all keywords above. Compound phrases (e.g., "system design", "bounded context", "event sourcing") are included as multi-word entries; single-word keywords cover the common cases.

Minimum 15 keywords per pack in routing-table.md. Trigger skill description must mirror the routing table (same keyword set, phrased as a "Use when" description).

## Open Questions

- None blocking. Routing table format chosen (Markdown, `|`-delimited, single file). Trigger skill naming agreed (`matilha-<domain>-trigger`).

## Exit Criteria

1. `routing-table.md` exists at `skills/matilha-compose/routing-table.md` with ≥15 keyword entries per pack (7 packs × ≥15 = ≥105 entries).
2. Compose `SKILL.md` Step 2 opens with routing-table lookup (Step 2a) before prose classification (Step 2b). Fallback documented.
3. 7 trigger skills exist, one per pack. Each has: (a) keyword-rich description covering the pack's domain signals, (b) body that checks pack presence and routes or nudges.
4. Validator tests: routing-table structure (file exists, ≥15 entries per pack), trigger skill schema (file exists, description length, "Use when" opener), compose Step 2 routing-table reference.
5. Manual smoke: prompt "I want to build a UI component library" → ux-trigger fires OR compose routes ux-pack even without CLAUDE.md.
