# matilha

> **You lead. Agents hunt.**
> A cognitive + methodological harness for building complex projects with AI.

> 🏠 **Official entry point.** This is the canonical repository for the matilha ecosystem. New users — start here, follow [Quick start](#quick-start) below. The 7 companion packs + CLI are satellites; this repo has the full install walkthrough, docs, and rules.

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

**You are the alpha.** The pack hunts at your side — 7 companion packs with 128 domain skills across UX, growth, agent architecture, system design, engineering discipline, software architecture, and AI-ops security. Plus 11 core methodology skills. **139 skills total**. Methodology wraps craft; the wolf does not replace your thinking.

## Ecosystem map

| Repository | Role | Where to go |
|---|---|---|
| **[danilods/matilha-skills](https://github.com/danilods/matilha-skills)** (this repo) | **Official hub** — core plugin + docs + rules + install guide | Start here |
| [danilods/matilha](https://github.com/danilods/matilha) | npm CLI (deterministic twin) — `npm install -g matilha` | After plugin install, if you want CLI |
| [danilods/matilha-ux-pack](https://github.com/danilods/matilha-ux-pack) | 22 UX + cognitive skills | Via `/matilha-install` after core |
| [danilods/matilha-growth-pack](https://github.com/danilods/matilha-growth-pack) | 20 growth + product strategy skills | Via `/matilha-install` |
| [danilods/matilha-harness-pack](https://github.com/danilods/matilha-harness-pack) | 22 agent architecture skills | Via `/matilha-install` |
| [danilods/matilha-sysdesign-pack](https://github.com/danilods/matilha-sysdesign-pack) | 19 distributed systems skills | Via `/matilha-install` |
| [danilods/matilha-software-eng-pack](https://github.com/danilods/matilha-software-eng-pack) | 15 engineering discipline skills | Via `/matilha-install` |
| [danilods/matilha-software-arch-pack](https://github.com/danilods/matilha-software-arch-pack) | 17 software architecture skills | Via `/matilha-install` |
| [danilods/matilha-security-pack](https://github.com/danilods/matilha-security-pack) | 13 AI-ops security skills | Via `/matilha-install` |

---

## Why matilha exists

Multi-week AI-assisted software projects fail in predictable ways: context is lost between sessions, methodology erodes under time pressure, companion knowledge (UX heuristics, scaling patterns, growth frameworks) stays scattered in books nobody re-reads.

Matilha is a harness — a methodology wrapper around `superpowers:*` skills + a companion-pack composition layer — that keeps discipline across weeks. You lead (intent, gates, decisions). Agents hunt (parallel worktrees, per-SP focus, gated output). Companion packs enrich brainstorming with domain-specific expertise automatically.

**What makes matilha different from "skills in a marketplace"**:

- **Composition, not competition.** Core skills delegate to companion packs via plugin-namespace detection. No hardcoded pack list; new packs are picked up automatically.
- **Methodology wraps craft.** Matilha orchestrates phases (scout/plan/design/hunt/gather/review/howl) around `superpowers:brainstorming` + `superpowers:writing-plans`. Superpowers stays the craft engine; matilha tracks where you are in the process and enriches context.
- **Works everywhere.** SessionStart hook activates matilha priority in any workspace where the plugin is installed. No `matilha-init` required for casual use — phase skills lazy-bootstrap structure on demand.
- **Runs standalone.** Matilha does not require superpowers. When superpowers is absent, matilha runs inline clarifying flows using its own methodology core.

---

## Quick start

### Prerequisites

- **[Claude Code](https://docs.anthropic.com/claude/claude-code)** installed (or Cursor / Codex CLI / Gemini CLI with plugin support)
- Git (for marketplace fetches)
- Internet access (plugin marketplace + initial clone only; matilha runs offline after)

### Install on a new machine (full ecosystem, recommended)

Start Claude Code in any directory, then paste these commands:

```
# 1. Core plugin (required)
/plugin marketplace add danilods/matilha-skills
/plugin install matilha@matilha-skills --user

# 2. Companion packs (install the ones relevant to your work)
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

The `--user` flag installs at user scope (global for your account, available in every workspace). If your version of Claude Code doesn't recognize `--user`, use the interactive `/plugin` menu and select **user scope**. Per-project install also works but must be repeated for each new workspace.

### Verify install

```
/plugin list
```

Should show `matilha` + all installed companion packs as **enabled**.

Open a fresh Claude Code session in any directory and type a creative-work prompt. The SessionStart hook activates matilha priority automatically — you'll see the sigil preamble before the first response.

### Optional: CLI for CI / determinism

If you also want the deterministic CLI (for scripts, CI pipelines, or power-user workflows):

```
npm install -g matilha
matilha --version  # 1.0.0
```

The CLI is **optional** — the plugin ecosystem works fully without it. They're twin surfaces of the same methodology source.

### Plugin-only deployment (no npm required)

If you don't have npm / don't want to install the CLI, **skip it entirely**. The full methodology is available via the 8 plugin installs above. Phase skills (`matilha-plan`, `matilha-scout`, etc.) are all plugin-native — they run inside Claude Code without any CLI dependency. Lazy-bootstrap means `docs/matilha/` structure is created on demand by phase skills themselves.

The CLI is a **separate surface** (deterministic, scriptable, CI-friendly). Use it when you want:
- Reproducible CI pipelines that verify matilha methodology state
- Shell-scripted project bootstrap (`matilha init` from Makefile)
- Headless automation (generate spec + plan without Claude Code session)

For interactive development in Claude Code, the plugin ecosystem is complete.

---

## Why install at user scope?

Plugin scoping in Claude Code is **per-project** by default. Per-project install means you'd need to repeat `/plugin install` for every new workspace. User-scope install makes matilha available globally — matilha-bootstrap's SessionStart hook fires in any directory, not just matilha-bootstrapped projects.

Methodology-everywhere only works at user scope.

### Try it

Open any project (matilha-bootstrapped or not) and type:

> "Estou construindo MVP de 4 semanas que precisa rodar autonomamente. Como estruturo os agents?"

Expected output:

```
[compose fires] → sigil emitted
A alcateia farejou território familiar: arquitetura de agentes
autônomos em Lambda/EventBridge/DynamoDB.

matilha-harness-pack ao lado → harness-orchestrator-workers,
harness-routing-parallelization, harness-architecture,
harness-nfrs-as-prompts, harness-long-horizon-strategies.

Brainstorming adiante. Skills entram em cena conforme tópicos surgirem.

[superpowers:brainstorming] → runs enriched, references pack skills
during clarifying questions.
```

---

## Companion packs — 128 skills across 7 domains

| Pack | Skills | What it covers | Install |
|---|---|---|---|
| **[matilha-ux-pack](https://github.com/danilods/matilha-ux-pack)** | 22 | UX + cognitive principles (Weinschenk, Krug, attention, memory, error tolerance, reservatório de boa vontade) | `/plugin install matilha-ux-pack@matilha-ux-pack` |
| **[matilha-growth-pack](https://github.com/danilods/matilha-growth-pack)** | 20 | Product growth — AARRR, JTBD, positioning, pricing, activation, retention, forces-of-progress | `/plugin install matilha-growth-pack@matilha-growth-pack` |
| **[matilha-harness-pack](https://github.com/danilods/matilha-harness-pack)** | 22 | Agent architecture — Anthropic Planner/Generator/Evaluator, context engineering, agentic patterns, evals, team operational rituals | `/plugin install matilha-harness-pack@matilha-harness-pack` |
| **[matilha-sysdesign-pack](https://github.com/danilods/matilha-sysdesign-pack)** | 19 | Distributed systems — NFRs, scalability, availability, CAP, Kafka, CDN, rate limiting, 11 design cases (Tan) | `/plugin install matilha-sysdesign-pack@matilha-sysdesign-pack` |
| **[matilha-software-eng-pack](https://github.com/danilods/matilha-software-eng-pack)** | 15 | Day-to-day engineering discipline (Danilo-experience) — KISS, RORO, Pythonic idioms, commits, documentation, task tracking, critical analysis | `/plugin install matilha-software-eng-pack@matilha-software-eng-pack` |
| **[matilha-software-arch-pack](https://github.com/danilods/matilha-software-arch-pack)** | 17 | Architecture from Argos + Gravicode practice — layering + Lambda chain, event-driven boundaries, dual-store (Postgres+DynamoDB), bounded contexts without microservice-spaghetti, disciplined scaling | `/plugin install matilha-software-arch-pack@matilha-software-arch-pack` |
| **[matilha-security-pack](https://github.com/danilods/matilha-security-pack)** | 13 | AI-software operational security (baseline, not a STRIDE/OWASP replacement) — keys + trust boundary, backend responsibility, LLM risks (prompt injection, output sanitization, cost as availability), LGPD minimization, operational defense | `/plugin install matilha-security-pack@matilha-security-pack` |

### What makes the packs different from each other

- **Literature packs** (ux, growth, harness, sysdesign) — synthesized from published sources (Weinschenk, Krug, Eyal, Anthropic, OpenAI Codex, Tan). 3-layer paraphrase discipline (source → wiki → skill).
- **Opinions-from-practice pack** (software-eng) — distilled from curated engineering rules refined across multi-week projects. 2-layer distillation, preserves the author's voice.

---

## Core methodology — 11 skills across 7 phases

Matilha organizes multi-week work across 7 phases. Each has an entry-point skill. All are auto-activated via matilha-compose (the gateway) when user intent matches.

| Phase | Purpose | Entry skill |
|---|---|---|
| 0 | Project state + next action | `matilha-howl` |
| 10 | Discovery / research | `matilha-scout` |
| 20–30 | Spec + plan authoring | `matilha-plan` |
| 40 | Dispatch + merge (waves, SPs, worktrees) | `matilha-hunt`, `matilha-gather` |
| 50 | Multi-agent quality review | `matilha-review` (runtime Wave 3c pending) |
| 60 | Deploy with security gate | `matilha-den` |
| 70 | Teammate onboarding artifacts | `matilha-pack` |
| Cross-phase | Gateway + routing | `matilha-compose` |
| Cross-phase | UX/UI guidance | `matilha-design` |
| Bootstrap | Initialize new matilha project | `matilha-init` |

Plus a SessionStart hook that injects matilha activation priority — compose runs BEFORE `superpowers:brainstorming` in every session, ensuring methodology wraps every creative-work prompt.

---

## The composition architecture (why it works)

Most plugin ecosystems are flat — each skill fires independently when its description matches. Matilha introduces a **composition layer**:

```
┌─────────────────────────────────────────────────────────┐
│ SessionStart hook (any workspace, matilha user-scope)    │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼ injects activation priority
┌─────────────────────────────────────────────────────────┐
│ User prompt — software-construction intent              │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│ matilha:matilha-compose (gateway)                       │
│   1. Pack detection (plugin-namespace matilha-*-pack)   │
│   2. Intent classification (prose semantic)             │
│   3. Dispatch decision (phase skill OR brainstorming)   │
│   4. Build preamble (sigil + atmospheric + pack lines)  │
│   5. Emit + invoke downstream                           │
└─────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          ▼                               ▼
┌─────────────────────┐       ┌──────────────────────────┐
│ Matilha phase skill │       │ superpowers:brainstorming │
│ (plan/design/scout/ │       │ (with pack-aware preamble)│
│  hunt/gather/howl/  │       │                          │
│  review)            │       │ Runs enriched. Pack       │
│                     │       │ skills referenced by name │
│ Lazy-bootstraps     │       │ during clarifying.        │
│ docs/matilha/       │       │                          │
│ if missing.         │       │                          │
└─────────────────────┘       └──────────────────────────┘
```

**Key invariants**:

- **Dynamic detection**: plugin namespace `matilha-*-pack` is the sole signal. No hardcoded pack list; removing or adding a pack reflects next turn.
- **Self-healing**: packs uninstalled disappear from ambient list → stop being detected. New packs installed → appear → detected.
- **Never competes with superpowers**: matilha wraps, not replaces. Brainstorming/writing-plans still run the clarifying-questions / plan-authoring flows — matilha just ensures methodology context wraps them.
- **Works standalone**: if superpowers is absent, matilha runs inline clarifying flows using methodology core.

Composition details in [`docs/matilha/companions-contract.md`](docs/matilha/companions-contract.md).

---

## Real examples — what you'll see

### Example 1 — system design prompt

Input:
> "Como escalo o meu sistema pra 10k QPS com P99 < 100ms?"

Output:
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

A alcateia farejou território familiar: escalabilidade de sistema
distribuído com metas rígidas de latência.

matilha-sysdesign-pack ao lado → sysdesign-scalability-horizontal-vs-vertical,
sysdesign-load-balancers, sysdesign-latency-targets-techniques,
sysdesign-consistency-cap, sysdesign-monitoring-4-golden-signals.

Brainstorming adiante. Skills entram em cena conforme os tópicos surgirem.
```

### Example 2 — multi-pack prompt (UX + growth)

Input:
> "Quero desenhar o signup flow desse SaaS — precisa ter baixa fricção
> (UX) mas também maximizar activation rate (growth)."

Output:
```
[sigil]

A alcateia farejou território misto: UX de onboarding com foco em
ativação.

matilha-ux-pack ao lado → cog-cognitive-load,
ux-recognition-over-recall, ux-error-format, ux-swiss-cheese-errors.
matilha-growth-pack ao lado → growth-signup-flow-cro,
growth-activation-emails, growth-aarrr, growth-jtbd-forces.

Brainstorming adiante.
```

### Example 3 — zero packs relevant

Input:
> "Quero refatorar a função calcula_taxa pra ser mais idiomática Python."

Output:
```
[sigil]

A alcateia farejou território familiar: qualidade de código Python
e refatoração idiomática.

matilha-software-eng-pack ao lado → sweng-pythonic-idioms,
sweng-roro-pattern, sweng-kiss-antidote-overengineering,
sweng-nomenclatura-clareza.

Brainstorming adiante.
```

### Example 4 — no packs installed

Input: same as above, but with only core matilha-skills installed.

Output:
```
[compose silent pass-through]
[superpowers:brainstorming fires directly, no sigil emitted]
```

The pack does not howl without territory — compose is invisible when it has no enrichment to add.

---

## Relationship to superpowers

If [`obra/superpowers`](https://github.com/obra/superpowers) is installed, matilha-compose dispatches to:

- `superpowers:brainstorming` — for general creative exploration
- `superpowers:writing-plans` — for implementation plan authoring

Matilha never replaces craft work. Matilha adds **methodology layer** (phase awareness, state tracking, lazy bootstrap, knowledge capture) + **pack enrichment** (domain skills surface during exploration). Superpowers stays the craft engine.

If superpowers is absent, matilha runs inline fallback flows using its own methodology core — it is not hostage to superpowers.

---

## Writing your own pack

Ship a companion pack in ~10 hours following the documented workflow:

1. **Name the plugin** `matilha-<domain>-pack` — this is how matilha-compose detects the pack (plugin-namespace inspection).
2. **Add `matilha-pack` to keywords** in your `plugin.json`.
3. **Skill prefix** `<domain>-*` (see [naming-conventions.md](docs/matilha/naming-conventions.md)).
4. **Paraphrase discipline** — 3 layers of remove (source book → wiki concept → skill body) for literature packs, or 2 layers (rule → skill) for opinions-from-practice.
5. **12 required body sections** per skill + mandatory `## Sources` section + wikilinks.
6. **Overlap disclosure** — if your skill derives from wiki pages used by another pack, declare `Complementa matilha-<otherpack>:<slug> at <angle>`.

Full details:
- [`docs/matilha/pack-authors.md`](docs/matilha/pack-authors.md) — pack authoring guide
- [`docs/matilha/skill-authoring-guide.md`](docs/matilha/skill-authoring-guide.md) — frontmatter schema + body structure
- [`docs/matilha/companions-contract.md`](docs/matilha/companions-contract.md) — detection + delegation contract
- [`docs/matilha/naming-conventions.md`](docs/matilha/naming-conventions.md) — reserved prefixes

---

## Roadmap

### Shipped (v1.0.0)
- **Core plugin** — 11 methodology skills + composition layer + SessionStart hook + 1466 validator tests
- **matilha-ux-pack** — 22 skills (Weinschenk + Krug + cognitive)
- **matilha-growth-pack** — 20 skills (AARRR + JTBD + pricing + retention)
- **matilha-harness-pack** — 22 skills (Anthropic + OpenAI Codex + Lopopolo)
- **matilha-sysdesign-pack** — 19 skills (Zhiyong Tan + NFRs + 11 cases)
- **matilha-software-eng-pack** — 15 skills (Danilo-experience rules, Caminho C)
- **matilha-software-arch-pack** — 17 skills (Argos + Gravicode practice, Caminho C)
- **matilha-security-pack** — 13 skills (AI-ops operational baseline, Caminho C)

### Planned (post-v1.0.0)
- Additional B packs — domain-specific (TBD, user-driven)
- `sec-*` formal security pack — STRIDE + OWASP Top 10 + Adam Shostack threat modeling, complement to the AI-ops swsec-* baseline (requires wiki ingestion)
- Wave 3c `matilha-review` runtime (6-agent parallel quality review)
- Marketplace submission to official Claude Code plugin marketplace
- Community-pack template + author onboarding materials

---

## Architecture highlights

- **Twin Identity** (Wave 4a) — matilha ships as **both** npm CLI (`matilha` command, deterministic engine for CI) and Claude Code plugin (cross-tool — Claude Code / Cursor / Codex / Gemini). Same skill content, two surfaces.
- **SessionStart hook** (Wave 5d.1) — auto-activation in any workspace where matilha is installed. No `matilha-init` required; compose fires on software-construction intent.
- **Plugin-namespace detection** (Wave 5d) — packs detected dynamically via `matilha-*-pack` namespace pattern. Zero hardcoded state, self-healing.
- **Lazy bootstrap** (Wave 5d.1) — `matilha-plan`, `matilha-scout`, `matilha-howl` create `docs/matilha/` structure on first write. Methodology available without project-level setup.
- **Sigil storytelling** (Wave 5d.1) — compose emits atmospheric ASCII preamble with user's domain language mirrored, creating a recognition aha moment before brainstorming begins.

---

## Project state

- **Main plugin**: `wave-5d1-storytelling` tag, stable
- **Test baseline**: 1211 validator tests passing (matilha CLI)
- **Live-verified**: SessionStart hook + pack detection + sigil emission confirmed in runtime smoke (see `docs/matilha/smoke-results/wave-5d-smoke.md`)
- **Active development**: Wave 5g (B packs), then software-arch-pack + security-pack after wiki ingestion

---

## Contributing

Bug reports + feature requests via [issues](https://github.com/danilods/matilha-skills/issues).

Pack authors: see `docs/matilha/pack-authors.md`. Community packs can use any `<author>-*` prefix per naming-conventions.md; reserved prefixes (`matilha-*`, `ux-*`, `cog-*`, `growth-*`, `harness-*`, `sysdesign-*`, `sweng-*`) are for the official pack ecosystem.

Methodology contributions: the `methodology/` directory is the source of record for phases 0-70. Amendments welcome via PR with rationale.

---

## License

MIT — see [LICENSE](LICENSE).

Matilha is opinionated methodology distilled from building complex AI-assisted software projects. Use it as-is, fork it, extend it, disagree with it. The alpha is yours.

---

**You lead. Agents hunt.**
