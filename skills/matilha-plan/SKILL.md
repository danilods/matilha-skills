---
name: matilha-plan
description: Guide PRD + Stack + Skills/Agents (phases 10+20+30) with binary gates from methodology pages.
metadata:
  author: matilha
  phase: 10-30
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /plan — Phase 10 PRD scaffold + attest

## Mission
Scaffold a BMAD-compatible PRD and execution plan for a new feature, then guide the user (with or without superpowers) to fill each section and attest binary gates one-by-one. The CLI never writes content — it scaffolds, validates, and advances phase state. The AI agent in the IDE fills each section using `methodology/10-prd.md` as source-of-truth. Optional: import a deep-research markdown (Gemini / Claude Deep Research) as Section 1 foundational context from which the AI derives the rest.

## SoR Reference
Content of truth lives in:
- `methodology/10-prd.md` — PRD gates, required sections, binary acceptance criteria
- `methodology/20-stack.md` — Stack decisions (Phase 20 gates)
- `methodology/30-skills-agents.md` — Skills/agents identification (Phase 30 gates)
- `templates/spec.md.tmpl` — scaffold shape the CLI writes
- `templates/plan.md.tmpl` — execution plan scaffold shape

ALWAYS consult methodology pages at the start of each phase.

## Preconditions
- `project-status.md` exists (user ran `matilha init`)
- `current_phase >= 10` (Phase 00 discovery completed via `matilha scout`)
- Optional: deep-research markdown file available locally (`.md` or `.markdown`, ≤ 1 MiB)

## Execution Workflow

### Phase 10 — PRD

1. User runs: `matilha plan <feature-slug>` (optionally `--import-research <file.md>`)
2. CLI fetches `templates/spec.md.tmpl` + `templates/plan.md.tmpl` from the registry, renders scaffolds to `docs/matilha/specs/YYYY-MM-DD-<slug>-spec.md` and `docs/matilha/plans/YYYY-MM-DD-<slug>-plan.md`
3. CLI updates `project-status.md`: appends `feature_artifact` entry, seeds all phase_{10,20,30}_gates to `pending`
4. **AI agent fills the spec in the IDE, section-by-section**, using `methodology/10-prd.md` as SoR:
   - Section 2 (Problem Statement) → satisfies gate `problem_defined`
   - Section 3 (Personas & JTBD) → satisfies gate `target_user_clear`
   - Section 4 (Functional Requirements / RFs) → satisfies `rfs_enumerated` (needs `- RF-001` pattern, ≥1)
   - Section 5 (Non-Functional Requirements / RNFs) → satisfies `rnfs_covered` (needs `- RNF-001` pattern, ≥1)
   - Section 6 (Risks) → satisfies `risks_listed`
   - Section 7 (Assumptions) → satisfies `premissas_listed`
   - Section 8 (Success Metrics) → satisfies `success_metrics_defined`
   - Section 9 (AHA Moment) → satisfies `aha_moment_identified`
   - Section 11 (Out of Scope) → satisfies `scope_boundaries_locked`
   - Section 12 (Peer Review) → satisfies `peer_review_done`
5. After filling each section, the user (or agent) runs `matilha attest <gate-key>`. The CLI validates the section (≥ 30 non-whitespace words, no `[placeholder]` or `<!-- TODO` sentinels, RF-001/RNF-001 pattern where applicable) and flips the gate to `yes`.
6. When all 10 Phase 10 gates are `yes`, `current_phase` auto-advances to `20`.

### Phase 20 — Stack

- User/AI follows `methodology/20-stack.md` to fill CLAUDE.md/AGENTS.md stack table + write `docs/architecture.md` + create `.env.example` + pin versions
- Gates validated minimally in Wave 2d (accepted on call); future waves tighten heuristics
- 6 gates: `stack_table_declared`, `architecture_doc_exists`, `rnf_traceability`, `docker_compose_mirrors_prod`, `env_example_created`, `versions_pinned`
- `matilha attest <gate>` to advance each

### Phase 30 — Skills / Agents

- User/AI follows `methodology/30-skills-agents.md` to create `.claude/skills/` (or equivalent per detected tool), declare agents with models, register hookify rule with ≥1 blocking PreToolUse
- 5 gates: `claude_md_declares_stack_rules`, `skills_by_domain`, `skills_by_key_tech`, `agents_with_models`, `one_blocking_hook`

## Rules: Do
- Read `methodology/10-prd.md` at the start of Phase 10. The methodology page is source-of-truth; the spec is the artifact.
- When imported research is present (`Section 1. Research Context`), derive Sections 2-12 FROM it. Don't ignore the research block.
- Fill one section at a time; run `matilha attest <gate>` as each section completes.
- For RFs and RNFs sections: enumerate with `RF-001`, `RNF-001` pattern. Every RF has a binary acceptance criterion. RNFs cover at minimum performance, security, availability, latency, scalability, accessibility.
- Register every significant judgment decision in `project-status.md` → `recent_decisions` array with date + what + why.
- If a gate is ambiguous or requires human judgment: mark as `pending` in project-status, add a note to `blockers` or `pending_decisions` — don't force-attest without explicit `--force` override.

## Rules: Don't
- Don't invoke the CLI to write content. CLI is scaffolder only. Content is the agent's job.
- Don't advance phase manually. `matilha attest` auto-advances when all gates of a phase flip to `yes`.
- Don't clobber existing spec with `matilha plan <slug>` unless you explicitly pass `--force` and the change is intentional.
- Don't edit `methodology/*.md` from the spec — methodology is read-only SoR.
- Don't duplicate methodology content into the spec. Reference via links (`methodology/10-prd.md`) instead.
- Don't skip enumerating RFs or RNFs. `rfs_enumerated` / `rnfs_covered` attest will reject sections without `RF-001` / `RNF-001` patterns.

## Expected Behavior
- Deliberate, gate-driven pace. A session can end mid-phase; `matilha plan-status` or `matilha howl` resumes.
- When user pushes to skip a gate, respond: "This gate has a binary acceptance criterion in `methodology/10-prd.md`. Run `matilha attest <gate> --force` to override (will log to pending_decisions), or fix the section and re-attest."
- Prefer asking the user vs guessing on ambiguous requirements — this is Phase 10, the most expensive phase to redo.

## Quality Gates
- Every entry in `project-status.md` → `phase_{10,20,30}_gates` is `yes | no | pending` (no empty).
- `matilha attest <gate>` rejects sections with `[placeholder]` or `<!-- TODO` markers.
- `matilha attest <gate>` rejects sections with fewer than 30 non-whitespace words.
- `rfs_enumerated` requires ≥1 line matching `- RF-\d{3}`.
- `rnfs_covered` requires ≥1 line matching `- RNF-\d{3}`.
- Spec exists at `docs/matilha/specs/<date>-<slug>-spec.md`.
- Plan exists at `docs/matilha/plans/<date>-<slug>-plan.md` (skeleton only at this stage; `/hunt` fills waves).
- `feature_artifacts` in `project-status.md` references both files.

## Companion Integration
- **Superpowers detected** (`companion_skills.superpowers === "installed"` in `project-status.md`):
  - `FeatureArtifact.owned_by` set to `"superpowers"` automatically (CLI does this)
  - Recommended flow: open the scaffolded spec, then invoke `superpowers:brainstorming` in your IDE passing the spec file (or just Section 1 if research was imported) as the context doc
  - Superpowers brainstorming produces structured output → paste/merge into spec sections 2-12 one-by-one
  - Between sections, still run `matilha attest <gate>` to lock progress
  - For the plan artifact, `superpowers:writing-plans` can fill the wave/SP breakdown after Phase 30 gates are met
- **Superpowers NOT detected**:
  - `owned_by` = `"matilha"` automatically
  - AI agent in the IDE (Claude Code, Cursor, Codex, Gemini CLI) reads the spec + methodology/10-prd.md and fills sections directly
  - If the user has a deep-research markdown (from Gemini or Claude Deep Research), use `matilha plan <slug> --import-research <file.md>` so the research becomes Section 1 and the AI can derive the rest from it
- **Impeccable detected + frontend archetype**:
  - Pre-configure `design-spec.md` to include `/impeccable teach` step during Phase 20-30
- **Shadcn-skills detected + frontend archetype**:
  - Inject shadcn registry context during Phase 30 skills identification (UI components = first-class skills)

## Output Artifacts
- `docs/matilha/specs/YYYY-MM-DD-<slug>-spec.md` — BMAD-compatible PRD scaffold, filled section-by-section
- `docs/matilha/plans/YYYY-MM-DD-<slug>-plan.md` — execution plan skeleton (waves/SPs filled in Phase 30 or later)
- `project-status.md` updates: appended `feature_artifacts` entry, seeded `phase_{10,20,30}_gates`, gates flipped to `yes` as attested, `current_phase` auto-advanced
- `docs/matilha/discovery-notes.md` — unchanged from Phase 00 (input to Phase 10)

## Example Constraint Language
- Use "must" for: binary acceptance criteria on RFs/gates, frontmatter schema compliance, methodology SoR precedence over spec
- Use "should" for: default stack choices per archetype, aesthetic commitments, enumerating secondary pain points
- Use "may" for: custom archetype exceptions with justification, `--force` overrides with documented reason in `pending_decisions`

## Troubleshooting

- **"`matilha attest` rejects my section with 'placeholder sentinel'"**: Remove `[placeholder]` and `<!-- TODO` comments from the section. These are the scaffold markers — they must be replaced with real content.
- **"Section has <30 words, attest fails"**: The heuristic threshold is 30 non-whitespace words. This is a tunable in `src/config.ts` but intentionally conservative. Expand the section with real content; don't pad with filler.
- **"`rfs_enumerated` fails even though I wrote requirements"**: The validator requires `- RF-001` format. Use numbered RF-XXX and RNF-XXX tokens per `methodology/10-prd.md` convention.
- **"Phase didn't auto-advance after attesting last gate"**: Check `matilha plan-status --json` — all 10 Phase 10 gate values must be `yes`. If one is still `pending` or `no`, auto-advance is blocked.
- **"I want to redo a section"**: Re-edit the spec. Then `matilha attest <gate> --force` if the section now differs from what the heuristic accepts. Or just run `matilha attest <gate>` again if valid — idempotent.
- **"I'm using superpowers but owned_by says matilha"**: Check `project-status.md` → `companion_skills.superpowers` is `installed` (not `not_installed`). `matilha init` detects at bootstrap; re-run with overwrite or edit manually.
- **"I have research from Gemini but `matilha plan` was already run without --import-research"**: Manually paste the research content into Section 1 of the existing spec, wrapped between `<!-- MATILHA_RESEARCH_START -->` and `<!-- MATILHA_RESEARCH_END -->`, then continue normally. Or: delete the scaffold and re-run `matilha plan --force --import-research <file.md>`.

<!-- MATILHA_MANAGED_END -->
