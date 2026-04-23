---
title: B-Packs Brainstorm — Prompt Template
date: 2026-04-21
status: working doc (for Danilo's structured pack-idea capture)
purpose: collect + prioritize next-wave pack ideas post v1.0.0
---

# B-Packs Brainstorm — Prompt Template

After v1.0.0 ships with 5 companion packs (ux, growth, harness, sysdesign, software-eng), the next wave is "B packs" — Danilo's backlog of pack ideas that didn't make the 5-pack lineup. This doc is a structured capture template.

**How to use**: copy the Question Sheet block once per candidate pack, fill it in, then run the Priority Matrix + Decision Gate at the end. The goal is a ranked list that tells you which pack to build next.

---

## 1. Question Sheet (one copy per candidate pack)

```
### Pack candidate: <working name>

**1. Domain** — what surface of AI-assisted development does this cover?
(E.g., cloud infrastructure, security, data engineering, devrel, mobile, embedded, LLM-ops, compliance, etc.)

**2. Problem it solves** — what pattern of mistake or blind spot disappears when this pack is installed?
(Concrete: "teams keep misusing IAM in AWS" or "engineers skip threat modeling on new features")

**3. Source type** — where does the content come from? (Check one — or more):
  [ ] Literature (books / papers / talks ingested via wiki)
  [ ] Opinions from practice (curated rules from Danilo or invited expert)
  [ ] Hybrid (literature scaffolding + practice rules)
  [ ] Vendor docs (AWS official, K8s official, etc.) — risk: freshness decay

**4. Specific sources** — list top 3-5 sources you'd synthesize:
  - Source 1:
  - Source 2:
  - Source 3:

**5. Estimated skill count** — typical pack is 15-22. Bucket this candidate:
  [ ] Small (8-14 skills — narrow niche, focused use)
  [ ] Medium (15-20 skills — standard pack size)
  [ ] Large (21-30 skills — deep domain, multiple families)

**6. Audience** — who installs this?
  - Primary persona:
  - Secondary persona:
  - What job title is most likely to install it on day 1?

**7. Trigger phrases** — what 3-5 user prompts would surface this pack's skills?
  - Phrase 1:
  - Phrase 2:
  - Phrase 3:

**8. Overlap** — which already-shipped pack does this touch?
  - matilha-ux-pack:       [ ] none  [ ] some  [ ] heavy  → notes:
  - matilha-growth-pack:   [ ] none  [ ] some  [ ] heavy  → notes:
  - matilha-harness-pack:  [ ] none  [ ] some  [ ] heavy  → notes:
  - matilha-sysdesign-pack:[ ] none  [ ] some  [ ] heavy  → notes:
  - matilha-software-eng-pack: [ ] none  [ ] some  [ ] heavy  → notes:

**9. Unique moat** — what does this pack have that no existing Claude Code / Cursor / Codex plugin has?
(If "nothing", reconsider.)

**10. Risk** — what could kill this pack's value?
  [ ] Content rot (vendor docs change, framework deprecates)
  [ ] Domain-narrowness (too niche; low install base)
  [ ] Author capacity (needs expertise Danilo would have to grow)
  [ ] Overlap with existing pack (incremental value)
  [ ] Compliance / legal risk (security, regulated domain)
```

---

## 2. Example answers (hypothetical `matilha-aws-pack`)

Shows what a filled-in sheet looks like.

```
### Pack candidate: matilha-aws-pack

**1. Domain** — AWS cloud infrastructure + production operations.

**2. Problem it solves** — teams building AI-assisted apps on AWS repeat the same
mistakes: over-provisioning, security-group sprawl, IAM permission bloat, missing
observability on Lambda/ECS, naive S3 bucket policies, cost runaway on GPU instances.
Skills activate when user intent touches these surfaces.

**3. Source type** — Hybrid.
  [x] Literature (AWS Well-Architected Framework, Werner Vogels posts, reInvent talks)
  [x] Opinions from practice (Danilo rules for AWS project setup from past consultancy)
  [x] Hybrid
  [ ] Vendor docs (risk: freshness decay — prefer principles over API specifics)

**4. Specific sources**
  - AWS Well-Architected Framework (6 pillars)
  - AWS Builder's Library essays (Werner Vogels' series)
  - Danilo's own AWS setup rules (IAM scaffold, tagging, cost-alerts template)
  - Charity Majors' observability posts (Lambda + CloudWatch pain)
  - Corey Quinn's Last Week in AWS archive (for anti-patterns)

**5. Estimated skill count** — Medium (18-22).

**6. Audience**
  - Primary persona: solo dev or small team shipping AI-assisted SaaS on AWS
  - Secondary persona: consultant running AWS due diligence
  - Job title day-1 installer: Staff / Principal Engineer

**7. Trigger phrases**
  - "como organizo IAM nesse projeto novo"
  - "preciso colocar observability no lambda"
  - "S3 bucket policy pra esse bucket público"
  - "por que a fatura AWS explodiu?"
  - "vou rodar GPU instance pra treinar esse modelo"

**8. Overlap**
  - matilha-sysdesign-pack:  [x] some  → sysdesign has general distributed-systems principles;
    aws-pack adds AWS-specific mappings (SQS vs Kafka, Aurora vs RDS, etc.). "Complementa" disclosure needed on ~5 skills.
  - matilha-harness-pack:    [x] some  → harness-nfrs-as-prompts + harness-agents-md-as-index;
    aws-pack inherits those and applies to AWS setup. "Complementa" on ~2 skills.
  - matilha-software-eng-pack:[x] some  → sweng-commits-atomicos, sweng-session-checklists
    apply within AWS workflow. Generic, no direct overlap.
  - ux + growth: none.

**9. Unique moat** — no AWS-specific Claude Code plugin curates Well-Architected
+ Builder's Library + real consultancy rules into auto-activating skills. Vendor
plugins tend to be API-wrappers; this is reasoning-level.

**10. Risk**
  [ ] Content rot — principle-level content (Well-Architected pillars) is stable;
    avoid API-specific skill bodies.
  [x] Domain-narrowness — AWS users are large but not universal. Install base
    smaller than ux/growth packs.
  [ ] Author capacity — Danilo has consulting-level AWS experience.
  [x] Overlap with sysdesign — 5-ish skills. Manageable via "Complementa" discipline.
  [ ] Compliance / legal — no unique risk.
```

---

## 3. Priority matrix template

Plot each candidate on value × effort. Use this 2×2 after filling sheets for 4-10 candidates.

```
                    HIGH VALUE
                        ^
                        |
  QUICK WINS            |          STRATEGIC BETS
  (do next)             |          (plan a wave)
                        |
  <---- LOW EFFORT ----+---- HIGH EFFORT ---->
                        |
  FILL-INS              |          RECONSIDER
  (batch later)         |          (high risk,
                        |           may skip)
                        |
                    LOW VALUE
                        v
```

**Value signals** (use when placing on vertical axis):
- Unique moat (§9 of question sheet): if "nothing", vertical = low.
- Audience breadth (§6): how many installers on day 30? Wide = high.
- Trigger-phrase frequency (§7): how often does this surface in a typical dev week? High = high.
- Overlap (§8): if "heavy" across multiple shipped packs, incremental value drops.

**Effort signals** (use when placing on horizontal axis):
- Skill count (§5): Large = high effort.
- Source type (§3): Literature + Opinions Hybrid = highest effort (3-layer paraphrase + interviews). Opinions-only = medium (2-layer distillation). Literature-only = medium-low.
- Author capacity (§10): external expertise required = high effort.
- Risk of content rot (§10): if frequent updates needed, effort scales with time, not one-off.

### Matrix slots to fill after brainstorming 4-10 candidates:

| Candidate | Value (H/M/L) | Effort (H/M/L) | Quadrant | Rank |
|---|---|---|---|---|
| (fill from sheets) | | | | |

Target: ship 1-2 Quick Wins in the next wave; invest in 1 Strategic Bet per quarter.

---

## 4. Decision gate — Caminho C (opinions) vs Caminho A (wiki)

Every pack has to commit to one source methodology. Use this gate to decide:

### Caminho A — wiki-ingestion (3-layer paraphrase)

**Choose this when**:
- The domain has well-known literature (books, papers, talks) that you can ingest into Obsidian wiki first.
- You want the pack to read as "canonical synthesis" of the domain.
- 3-4 week investment in wiki before skill authoring is acceptable.
- Overlap with already-shipped packs will be managed via `Complementa` discipline.

**Workflow**: source book → wiki concept page → skill body. 3 layers of remove. See `matilha-ux-pack/docs/wiki-ingestion-workflow.md` or `matilha-sysdesign-pack/docs/wiki-ingestion-workflow.md`.

**Shipped examples**: ux, growth, harness, sysdesign packs.

### Caminho C — source distillation (2-layer, opinions-from-practice)

**Choose this when**:
- The domain expertise lives in the author's (or an invited expert's) hands, not in a book.
- You want the pack to read as "curated practice discipline", not "textbook summary".
- You have 1-2 days of interview / reflection time rather than 3-4 weeks of ingestion.
- Preserving the author's voice is a feature, not a bug.

**Workflow**: curated rule document → skill body. 2 layers of remove. See `matilha-software-eng-pack/docs/source-distillation-workflow.md`.

**Shipped examples**: software-eng pack (first Caminho C ship).

### Hybrid path (C-leaning)

**Choose this when**:
- Literature provides scaffolding (Well-Architected pillars, Shostack threat-model categories) but lived experience provides the concrete examples.
- You want structural rigor from literature + voice + specificity from practice.

**Workflow**: literature provides outline + one-layer concept pages; author writes skill bodies with their own examples + "Complementa literature citation" discipline. 2-3 layers of remove, depending on skill.

**Caveat**: no shipped pack yet follows this path; would need a wave-level commitment to codify the workflow.

---

## 5. Candidates to seed the brainstorm (optional, Danilo-originated hints)

From memory docs (not yet captured in a sheet):

- **`matilha-security-pack`** — threat modeling, OWASP, secrets handling. Deferred in Wave 5; wiki is light. Caminho A blocker: needs Shostack + OWASP ingestion first.
- **`matilha-software-arch-pack`** — Uncle Bob clean architecture + Evans DDD + hexagonal. Caminho A; deferred until post-v1.0.0 wiki ingestion of those authors.
- **`matilha-aws-pack`** (example above) — Hybrid.
- **`matilha-devrel-pack`** — how to document, blog, open-source, talk-give as an AI-assisted engineer. Caminho C lean.
- **`matilha-mobile-pack`** — iOS + Android patterns for AI-assisted dev. Caminho C or Hybrid.
- **`matilha-llmops-pack`** — prompt versioning, eval pipelines, model routing. Literature exists (Anthropic + OpenAI posts already in harness-pack) — risk of heavy overlap.
- **`matilha-data-eng-pack`** — ETL, warehouse design, Airflow/dbt patterns. Hybrid.

These are seeds. Fill a Question Sheet for each before treating as committed.

---

## 6. Process — how to run this brainstorm

Recommended one-sitting flow (~90 min):

1. **Seed list** (15 min): open this doc, copy §5 candidates, add 3-5 more from memory.
2. **Fill Question Sheets** (45 min): one per candidate. Keep answers terse.
3. **Plot on matrix** (15 min): assign H/M/L on value + effort; place in quadrant.
4. **Decision-gate pass** (10 min): for top-3 candidates, commit Caminho A vs C.
5. **Next-action** (5 min): if top candidate is Caminho A, next action is wiki ingestion plan. If Caminho C, next action is source-rule curation / interview scheduling.

Result: a ranked list + a clear next-wave commitment.
