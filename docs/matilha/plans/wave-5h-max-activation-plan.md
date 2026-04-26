---
slug: wave-5h-max-activation
wave: 5h
phase: 40
status: ready
created: 2026-04-24
spec: docs/matilha/specs/wave-5h-max-activation-spec.md
---

# Wave 5h — Maximum Deterministic Pack Activation — Implementation Plan

## Goal

Eliminate probabilistic pack activation by adding (1) a keyword routing table consumed by compose Step 2 and (2) one independent trigger skill per pack with a keyword-rich description. Both mechanisms work independently; together they provide full-coverage deterministic activation.

## Architecture Summary

- **SP-A** — routing table (`skills/matilha-compose/routing-table.md`) + compose `SKILL.md` Step 2 update
- **SP-B** — 7 trigger skills in corresponding pack directories

SPs are disjoint. SP-A and SP-B can be executed in parallel.

---

## SP-A: Routing Table + Compose Step 2 Update

**Slug:** `sp-a-routing-table`
**Disjoint from:** SP-B (touches compose, not packs)

### Tasks

#### A.1 — Create `skills/matilha-compose/routing-table.md`

Create the file with the following structure:

```
# Matilha Compose — Routing Table
# Format: keyword (case-insensitive exact match) | pack-namespace
# One entry per line. Blank lines and lines starting with # are ignored.

# ux-pack
ui | matilha-ux-pack
ux | matilha-ux-pack
interface | matilha-ux-pack
component | matilha-ux-pack
layout | matilha-ux-pack
typography | matilha-ux-pack
wireframe | matilha-ux-pack
figma | matilha-ux-pack
accessibility | matilha-ux-pack
responsive | matilha-ux-pack
onboarding | matilha-ux-pack
visual hierarchy | matilha-ux-pack
cognitive load | matilha-ux-pack
design system | matilha-ux-pack
navigation | matilha-ux-pack
mobile design | matilha-ux-pack
social proof | matilha-ux-pack

# growth-pack
aarrr | matilha-growth-pack
acquisition | matilha-growth-pack
activation | matilha-growth-pack
retention | matilha-growth-pack
referral | matilha-growth-pack
churn | matilha-growth-pack
funnel | matilha-growth-pack
conversion | matilha-growth-pack
north star | matilha-growth-pack
viral | matilha-growth-pack
k-factor | matilha-growth-pack
jtbd | matilha-growth-pack
hook model | matilha-growth-pack
dau | matilha-growth-pack
mau | matilha-growth-pack
engagement | matilha-growth-pack

# harness-pack
orchestrator | matilha-harness-pack
planner | matilha-harness-pack
executor | matilha-harness-pack
subagent | matilha-harness-pack
multi-agent | matilha-harness-pack
eval | matilha-harness-pack
grader | matilha-harness-pack
rag | matilha-harness-pack
retrieval | matilha-harness-pack
transcript | matilha-harness-pack
context window | matilha-harness-pack
harness | matilha-harness-pack
agent architecture | matilha-harness-pack
prompt | matilha-harness-pack
llm | matilha-harness-pack

# sysdesign-pack
scalability | matilha-sysdesign-pack
distributed | matilha-sysdesign-pack
latency | matilha-sysdesign-pack
throughput | matilha-sysdesign-pack
availability | matilha-sysdesign-pack
cap theorem | matilha-sysdesign-pack
cache | matilha-sysdesign-pack
rate limiting | matilha-sysdesign-pack
cdn | matilha-sysdesign-pack
microservices | matilha-sysdesign-pack
system design | matilha-sysdesign-pack
bottleneck | matilha-sysdesign-pack
capacity planning | matilha-sysdesign-pack
sla | matilha-sysdesign-pack
nfr | matilha-sysdesign-pack
message queue | matilha-sysdesign-pack

# software-eng-pack
refactor | matilha-software-eng-pack
technical debt | matilha-software-eng-pack
kiss | matilha-software-eng-pack
dry | matilha-software-eng-pack
tdd | matilha-software-eng-pack
coverage | matilha-software-eng-pack
context loss | matilha-software-eng-pack
clean code | matilha-software-eng-pack
naming | matilha-software-eng-pack
backlog | matilha-software-eng-pack
code review | matilha-software-eng-pack
pull request | matilha-software-eng-pack

# software-arch-pack
hexagonal | matilha-software-arch-pack
ddd | matilha-software-arch-pack
bounded context | matilha-software-arch-pack
event sourcing | matilha-software-arch-pack
cqrs | matilha-software-arch-pack
outbox | matilha-software-arch-pack
saga | matilha-software-arch-pack
clean architecture | matilha-software-arch-pack
handler as adapter | matilha-software-arch-pack
dependency direction | matilha-software-arch-pack
domain model | matilha-software-arch-pack
aggregate | matilha-software-arch-pack
cdc | matilha-software-arch-pack
pipeline | matilha-software-arch-pack
ports and adapters | matilha-software-arch-pack

# security-pack
security | matilha-security-pack
auth | matilha-security-pack
jwt | matilha-security-pack
oauth | matilha-security-pack
rbac | matilha-security-pack
lgpd | matilha-security-pack
gdpr | matilha-security-pack
pii | matilha-security-pack
xss | matilha-security-pack
injection | matilha-security-pack
secrets | matilha-security-pack
owasp | matilha-security-pack
encryption | matilha-security-pack
credentials | matilha-security-pack
input validation | matilha-security-pack
api key | matilha-security-pack
```

**Exit gate A.1:** file exists at `skills/matilha-compose/routing-table.md`, ≥15 entries per pack section.

#### A.2 — Update compose `SKILL.md` Step 2

Edit `skills/matilha-compose/SKILL.md`. Find the **Step 2** heading. Replace the opening paragraph to add routing-table lookup as Step 2a before the existing prose classification (now Step 2b):

New Step 2 opening (insert BEFORE existing prose classification):

```
**Step 2 — Intent classification (routing-table first, then prose semantic).**

**Step 2a — Routing table lookup (deterministic).**

Using Bash (`cat skills/matilha-compose/routing-table.md`), or by reading the file via the Read tool, load `routing-table.md` co-located with this skill. Parse each non-comment line as `keyword | pack-namespace`. For each entry, check case-insensitively whether the user prompt contains the keyword. If it does, mark that pack as `relevant` immediately — no LLM inference needed.

Fallback: if the file is unavailable or Bash is blocked, skip 2a and proceed to 2b.

**Step 2b — Prose semantic classification (for packs not matched by 2a).**

For packs not already marked `relevant` via 2a, apply the existing prose semantic classification:
```

Keep the rest of Step 2 (the existing prose semantic text and bias instructions) unchanged below the new 2b heading.

**Exit gate A.2:** compose `SKILL.md` contains "routing-table" and "Step 2a" and "Step 2b".

#### A.3 — Update validator tests

In `tests/registry/content-validation.test.ts`, add a new describe block for the routing table:

```ts
describe("routing-table (Wave 5h)", () => {
  const tablePath = path.join(skillsDir, "matilha-compose", "routing-table.md");

  it("file exists", () => {
    expect(fs.existsSync(tablePath)).toBe(true);
  });

  const EXPECTED_PACKS = [
    "matilha-ux-pack",
    "matilha-growth-pack",
    "matilha-harness-pack",
    "matilha-sysdesign-pack",
    "matilha-software-eng-pack",
    "matilha-software-arch-pack",
    "matilha-security-pack",
  ];

  it.each(EXPECTED_PACKS)("pack %s has ≥15 entries", (pack) => {
    const content = fs.readFileSync(tablePath, "utf-8");
    const entries = content
      .split("\n")
      .filter((l) => l.includes("|") && !l.startsWith("#"))
      .filter((l) => l.split("|")[1]?.trim() === pack);
    expect(entries.length).toBeGreaterThanOrEqual(15);
  });

  it("compose SKILL.md references routing-table", () => {
    const composePath = path.join(skillsDir, "matilha-compose", "SKILL.md");
    const content = fs.readFileSync(composePath, "utf-8");
    expect(content).toContain("routing-table");
    expect(content).toContain("Step 2a");
    expect(content).toContain("Step 2b");
  });
});
```

**Exit gate A.3:** new tests pass, no existing tests regress.

---

## SP-B: 7 Trigger Skills

**Slug:** `sp-b-trigger-skills`
**Disjoint from:** SP-A (touches pack directories only)

Each trigger skill lives in the pack it serves. All 7 follow the same template. Execute all 7 within this SP.

### Trigger Skill Template

```markdown
---
name: <pack-domain>-trigger
description: "Use when the user mentions <comma-separated keyword list — full domain coverage for the pack>. Fires independently of compose and CLAUDE.md to ensure <pack-name> methodology skills activate whenever their domain appears."
category: <pack-namespace-without-matilha-prefix>
version: "1.0.0"
---

## When this fires

User prompt mentions any keyword from <pack>'s domain: <same keyword list as description>.

## Execution Workflow

1. **Pack presence check.** Inspect the ambient skill list for skills in the `<pack-namespace>:*` namespace.

2. **Pack installed path.** If ≥1 skill from `<pack-namespace>` is visible:
   - Identify the user's sub-intent within the domain (planning, designing, reviewing, etc.).
   - Emit a compact domain acknowledgment (≤2 lines — no full sigil, that belongs to compose).
   - Invoke the most relevant pack skill via the Skill tool.

3. **Pack not installed path.** If no `<pack-namespace>` skills are visible:
   - Emit: "<Pack display name> skills not installed. Run `/matilha-install` and select <pack short name> to add <N> <domain> skills."
   - Proceed with default flow (matilha-compose or superpowers:brainstorming if available).

## Rules

- Do NOT emit the full compose sigil. The sigil belongs to compose; this skill emits a compact pack-specific acknowledgment.
- Do NOT block on pack absence — emit the nudge and continue.
- Prefer invoking a specific pack skill over listing all skills.
```

### B.1 — matilha-ux-pack trigger

**Path:** `packs/matilha-ux-pack/skills/matilha-ux-trigger/SKILL.md`

Description:
> Use when the user mentions UI, UX, user interface, design system, component, layout, typography, color, visual hierarchy, cognitive load, wireframe, Figma, accessibility, responsive design, mobile design, onboarding flow, navigation, attention, habit, dopamine, pricing, choice, social proof, or any topic related to user experience and interface design. Fires independently of compose to ensure matilha-ux-pack skills activate whenever UX/UI domain appears.

Pack namespace: `matilha-ux-pack`
Pack skill count for nudge: 22

**Exit gate B.1:** file exists, description contains "Use when" + ≥10 UX keywords, body has pack-presence check.

### B.2 — matilha-growth-pack trigger

**Path:** `packs/matilha-growth-pack/skills/matilha-growth-trigger/SKILL.md`

Description:
> Use when the user mentions AARRR, acquisition, activation, retention, referral, revenue, funnel, conversion, churn, North Star metric, viral coefficient, k-factor, JTBD, jobs-to-be-done, hook model, engagement, DAU, MAU, growth hacking, product-led growth, or any topic related to product growth and user metrics. Fires independently of compose to ensure matilha-growth-pack skills activate whenever growth domain appears.

Pack namespace: `matilha-growth-pack`
Pack skill count for nudge: 20

### B.3 — matilha-harness-pack trigger

**Path:** `packs/matilha-harness-pack/skills/matilha-harness-trigger/SKILL.md`

Description:
> Use when the user mentions agent architecture, multi-agent, orchestrator, planner, executor, subagent, eval, evaluation, LLM pipeline, prompt engineering, RAG, retrieval-augmented generation, grader, transcript, context window, harness, or any topic related to building AI agent systems and LLM-powered workflows. Fires independently of compose to ensure matilha-harness-pack skills activate whenever agentic AI domain appears.

Pack namespace: `matilha-harness-pack`
Pack skill count for nudge: 22

### B.4 — matilha-sysdesign-pack trigger

**Path:** `packs/matilha-sysdesign-pack/skills/matilha-sysdesign-trigger/SKILL.md`

Description:
> Use when the user mentions system design, scalability, distributed systems, latency, throughput, availability, CAP theorem, database design, caching, rate limiting, CDN, microservices, SLA, NFR, capacity planning, bottleneck, message queue, or any topic related to large-scale system architecture and infrastructure design. Fires independently of compose to ensure matilha-sysdesign-pack skills activate whenever system design domain appears.

Pack namespace: `matilha-sysdesign-pack`
Pack skill count for nudge: 19

### B.5 — matilha-software-eng-pack trigger

**Path:** `packs/matilha-software-eng-pack/skills/matilha-software-eng-trigger/SKILL.md`

Description:
> Use when the user mentions refactoring, technical debt, KISS, DRY, TDD, test coverage, context loss, clean code, naming conventions, backlog grooming, code review, pull request, commit discipline, YAGNI, or any topic related to software engineering practices, team discipline, and day-to-day coding decisions. Fires independently of compose to ensure matilha-software-eng-pack skills activate whenever software engineering domain appears.

Pack namespace: `matilha-software-eng-pack`
Pack skill count for nudge: 15

### B.6 — matilha-software-arch-pack trigger

**Path:** `packs/matilha-software-arch-pack/skills/matilha-software-arch-trigger/SKILL.md`

Description:
> Use when the user mentions hexagonal architecture, DDD, domain-driven design, bounded context, event sourcing, CQRS, CDC, outbox pattern, saga, clean architecture, handler as adapter, dependency direction, domain model, aggregate, ports and adapters, or any topic related to software architecture patterns and long-term structural decisions. Fires independently of compose to ensure matilha-software-arch-pack skills activate whenever software architecture domain appears.

Pack namespace: `matilha-software-arch-pack`
Pack skill count for nudge: (to verify from pack)

### B.7 — matilha-security-pack trigger

**Path:** `packs/matilha-security-pack/skills/matilha-security-trigger/SKILL.md`

Description:
> Use when the user mentions security, authentication, authorization, JWT, OAuth, RBAC, LGPD, GDPR, PII, input validation, XSS, SQL injection, secrets management, credentials, API key, rate limiting, encryption, OWASP, threat modeling, or any topic related to application security, compliance, and secure coding. Fires independently of compose to ensure matilha-security-pack skills activate whenever security domain appears.

Pack namespace: `matilha-security-pack`
Pack skill count for nudge: (to verify from pack)

### B.8 — Validator tests for trigger skills

In `tests/registry/content-validation.test.ts`, add a describe block for trigger skills:

```ts
describe("trigger skills (Wave 5h)", () => {
  const TRIGGER_SKILLS = [
    { pack: "matilha-ux-pack", name: "matilha-ux-trigger" },
    { pack: "matilha-growth-pack", name: "matilha-growth-trigger" },
    { pack: "matilha-harness-pack", name: "matilha-harness-trigger" },
    { pack: "matilha-sysdesign-pack", name: "matilha-sysdesign-trigger" },
    { pack: "matilha-software-eng-pack", name: "matilha-software-eng-trigger" },
    { pack: "matilha-software-arch-pack", name: "matilha-software-arch-trigger" },
    { pack: "matilha-security-pack", name: "matilha-security-trigger" },
  ];

  it.each(TRIGGER_SKILLS)("$name SKILL.md exists in $pack", ({ pack, name }) => {
    const skillPath = path.join(packsDir, pack, "skills", name, "SKILL.md");
    expect(fs.existsSync(skillPath)).toBe(true);
  });

  it.each(TRIGGER_SKILLS)("$name has keyword-rich description (≥8 domain keywords)", ({ pack, name }) => {
    const skillPath = path.join(packsDir, pack, "skills", name, "SKILL.md");
    const content = fs.readFileSync(skillPath, "utf-8");
    const frontmatterMatch = content.match(/^---\n([\s\S]*?)\n---/);
    const descMatch = frontmatterMatch?.[1]?.match(/description:\s*["'](.+?)["']/s);
    // count comma-separated or space-separated distinct domain words
    const desc = descMatch?.[1] ?? "";
    const wordCount = desc.split(/[,\s]+/).filter(w => w.length > 3).length;
    expect(wordCount).toBeGreaterThanOrEqual(8);
  });

  it.each(TRIGGER_SKILLS)("$name description starts with 'Use when'", ({ pack, name }) => {
    const skillPath = path.join(packsDir, pack, "skills", name, "SKILL.md");
    const content = fs.readFileSync(skillPath, "utf-8");
    const descMatch = content.match(/description:\s*["'](.+?)["']/s);
    expect(descMatch?.[1]).toMatch(/^Use when/i);
  });

  it.each(TRIGGER_SKILLS)("$name body contains pack-presence check", ({ pack, name }) => {
    const skillPath = path.join(packsDir, pack, "skills", name, "SKILL.md");
    const content = fs.readFileSync(skillPath, "utf-8");
    expect(content).toContain("Pack presence check");
  });
});
```

**Exit gate B.8:** all 7 × 3 = 21 trigger tests pass.

---

## SP-A Exit Gate (full)

- [ ] `skills/matilha-compose/routing-table.md` exists
- [ ] ≥15 entries per pack (7 packs)
- [ ] Compose `SKILL.md` contains "routing-table", "Step 2a", "Step 2b"
- [ ] Routing-table validator tests pass

## SP-B Exit Gate (full)

- [ ] 7 trigger skill directories + SKILL.md files created
- [ ] Each description: `Use when` opener + ≥8 domain keywords
- [ ] Each body: Pack presence check + installed path + not-installed nudge
- [ ] Trigger skill validator tests pass (21 tests)

## Wave Exit Gate

- [ ] SP-A and SP-B both complete
- [ ] `npm test` — all tests pass (≥1517 = 1496 + routing-table tests + trigger tests)
- [ ] `project-status.md` updated: `current_phase: 40`, `next_action: gather wave-5h`
- [ ] Manual smoke: prompt without CLAUDE.md → trigger skill fires for domain keyword
- [ ] Manual smoke: prompt with CLAUDE.md → compose routing-table match deterministic

## Version bump on completion

- matilha-skills: `1.2.1 → 1.3.0` (minor — new activation mechanism, new skills)
- matilha CLI: no change (no CLI code modified)
