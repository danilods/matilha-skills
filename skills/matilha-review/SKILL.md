---
name: matilha-review
description: Phase 50 — Orchestrate 6 native review agents + delegate to code-review plugin if detected.
metadata:
  author: matilha
  phase: "50"
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /review — Phase 50 (Multi-Angle Quality Review)

## Mission
Orchestrate 6 native review agents for multi-angle quality coverage, delegating specialized checks to the `code-review` plugin when Claude Code is detected. Each agent targets a distinct risk vector. Produce a consolidated review report before any wave is tagged or deployed.

## SoR Reference
Content of truth lives in:
- methodology/50-qualidade-testes.md (review agent definitions, consolidation rules, severity taxonomy)

ALWAYS consult this page for latest agent roster and severity thresholds.

## Preconditions
- Either at end of a wave (`/gather` calls `/review` automatically) or user invokes directly
- Diff scope is determinable: uncommitted changes, recent commits, or full branch vs main
- Test suite is accessible (for regression agent)

## Execution Workflow
1. Determine review scope: ask user if invoked directly — uncommitted changes / last N commits / full branch diff
2. Load `methodology/50-qualidade-testes.md` — extract 6 agent definitions and severity taxonomy
3. Dispatch 6 review agents in parallel, each targeting its vector:
   - **Agent 1 — Methodology Compliance**: checks that code follows Matilha conventions (phase gates, file naming, project-status.md currency)
   - **Agent 2 — Security**: secrets exposure, injection vectors, auth holes, dependency CVEs
   - **Agent 3 — Silent Failures**: unhandled errors, missing null checks, swallowed exceptions, unchecked async
   - **Agent 4 — Test Coverage**: missing tests for changed logic, brittle assertions, test-to-code ratio
   - **Agent 5 — Performance**: N+1 queries, unbounded loops, memory leaks, missing indexes on queried fields
   - **Agent 6 — Architecture**: coupling, dependency direction violations, abstraction leaks
4. If `code-review` plugin detected (Claude Code): delegate Agents 4 (tests) and 6 (architecture) to the plugin; receive and merge its output
5. Consolidate findings: group by severity (critical / major / minor / suggestion), deduplicate
6. Write `docs/matilha/reviews/YYYY-MM-DD-<scope>.md` with: scope summary, findings table, per-agent sections, recommended actions
7. Print summary to console: counts by severity; highlight criticals
8. If invoked by `/gather`: return pass/fail signal — any `critical` finding = fail

## Rules: Do
- Run Agents 1 (methodology), 2 (security), and 3 (silent failures) always, even when delegating to code-review plugin
- Assign severity to every finding per `methodology/50-qualidade-testes.md` taxonomy (no unseveritied findings)
- Write review report to `docs/matilha/reviews/` with date-stamped filename
- Link review report in `project-status.md` `feature_artifacts`
- When invoked by `/gather`: block wave tag if any `critical` finding exists

## Rules: Don't
- Don't skip security agent even for "small" waves
- Don't auto-fix findings during review — report only; fixes are a separate operation
- Don't merge agent outputs without deduplication
- Don't modify `methodology/*.md` (read-only SoR)
- Don't allow wave tagging with unresolved `critical` findings

## Expected Behavior
- Parallel agent dispatch is the norm — do not serialize unless tool constraints require it
- When code-review plugin is absent, Matilha native agents cover the full roster
- A review with zero findings is valid — report "no issues found" per agent, do not fabricate
- User may request a quick review (--quick flag) that runs only Agents 2 and 3 for rapid feedback

## Quality Gates
- Review report exists at `docs/matilha/reviews/YYYY-MM-DD-<scope>.md`
- All 6 agent sections are present in the report (even if "no issues found")
- Every finding has a severity label from the defined taxonomy
- No `critical` findings remain unresolved before wave tag is applied
- Report path recorded in `project-status.md` `feature_artifacts`

## Companion Integration
- If `code-review` plugin detected (Claude Code): delegate Agents 4 and 6 to it; Matilha merges output into consolidated report
- If `superpowers` detected: can invoke superpowers review flow for enhanced agent depth; Matilha wraps with consolidation and report writing
- If `impeccable` + frontend scope: add Impeccable audit as Agent 7 (UI/design compliance); run after core 6 agents

## Output Artifacts
- `docs/matilha/reviews/YYYY-MM-DD-<scope>.md` (consolidated multi-agent report)
- Updated `project-status.md` (`feature_artifacts` with review report link)
- Console summary: severity counts + critical list

## Example Constraint Language
- Use "must" for: security agent always runs, critical findings block wave tag, report written to docs/matilha/reviews/
- Use "should" for: parallel agent dispatch, code-review plugin delegation when available
- Use "may" for: --quick mode (agents 2+3 only), Agent 7 for frontend Impeccable audit

## Troubleshooting
- **"code-review plugin not found but expected"**: Check `.claude/settings.json` for plugin registration. If absent, Matilha native agents cover the full roster — no capability gap.
- **"Review scope unclear (uncommitted vs branch)"**: Default to uncommitted changes for quick reviews, full branch for post-wave reviews. Ask user if ambiguous.
- **"Agent finds zero issues but code looks suspicious"**: Report "no issues found" honestly. Do not fabricate findings to justify the review step.
- **"critical finding blocks wave tag but user wants to ship"**: User must either fix the finding, downgrade its severity with explicit justification (logged in project-status.md `recent_decisions`), or accept the risk explicitly.
- **"Multiple reviews in one day create filename collision"**: Append scope descriptor: `YYYY-MM-DD-wave-01.md`, `YYYY-MM-DD-hotfix.md`, etc.

<!-- MATILHA_MANAGED_END -->
