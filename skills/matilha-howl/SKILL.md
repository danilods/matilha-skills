---
name: matilha-howl
description: Status + resume — parse project-status.md, report state, suggest next action.
metadata:
  author: matilha
  phase: transversal
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /howl — Status + Resume

## Mission
Surface the current project state for session resumption. Read `project-status.md`, render a structured summary of phase progress, active waves, pending decisions, blockers, and the recommended next action. Read-only — does not modify any file.

## SoR Reference
Content of truth lives in:
- methodology/index.md (phase descriptions, phase progression order)

Consult this page when `current_phase` value is unclear or when suggesting the next command.

## Preconditions
- `project-status.md` exists in project root
- Caller is in the project root directory (or any subdirectory of the project)

## Execution Workflow
1. Locate `project-status.md` by walking up from current directory; report path found
2. Parse YAML frontmatter: extract `current_phase`, `archetype`, `aesthetic_direction`, `phase_*_gates`, `active_waves`, `completed_waves`, `blockers`, `recent_decisions`, `feature_artifacts`, `next_action`
3. Load `methodology/index.md` to map `current_phase` to phase name and description
4. Render summary output with clear sections:
   - **Project**: name, archetype, aesthetic (if set)
   - **Phase**: current phase number + name, status (in-progress / blocked / ready-to-advance)
   - **Gates**: table of gate keys and values for the current phase (yes/no/pending)
   - **Active Waves**: for each wave, list SPs and their status
   - **Completed Waves**: count + list of tags
   - **Pending Decisions**: from `recent_decisions` where status = pending
   - **Blockers**: from `blockers` array, numbered
   - **Next Action**: recommended command based on current state
5. If `blockers` is non-empty, highlight them prominently
6. Print suggested next command: `/scout`, `/plan`, `/hunt`, `/gather`, `/review`, `/den`, or `/pack` based on `current_phase`

## Rules: Do
- Report exactly what is in project-status.md — do not infer or assume progress beyond what the file records
- Show gate status for the current phase prominently
- Suggest the most logical next command given `current_phase` and gate states
- Handle missing optional fields gracefully (show "not set" rather than erroring)

## Rules: Don't
- Don't modify project-status.md or any other file
- Don't advance gates or phases during `/howl`
- Don't fabricate state not present in project-status.md
- Don't run long operations — `/howl` must be near-instant

## Expected Behavior
- Output is formatted for quick scanning: use a summary table for gates, not a wall of text
- When all gates for current phase are `yes`, note "Phase N complete — ready to advance"
- When any gate is `pending` or `no`, note "Phase N blocked on: [gate list]"
- When `next_action` is set in frontmatter, surface it verbatim first before adding suggestions

## Quality Gates
- (Read-only skill — no file mutations to validate)
- Output includes all 7 sections: Project, Phase, Gates, Active Waves, Completed Waves, Pending Decisions, Next Action
- Suggested next command maps correctly to `current_phase` per methodology/index.md progression

## Companion Integration
- If `superpowers` detected: note in output which superpowers skills are available for the current phase
- If `impeccable` detected and archetype has frontend: surface aesthetic_direction and Impeccable audit status in Project section
- If `shadcn-skills` detected: note in Active Waves section if any SP involves UI components

## Output Artifacts
- (none — printed to console only, no files written)

## Example Constraint Language
- Use "must" for: reading project-status.md, rendering all 7 sections
- Use "should" for: formatting choices (table vs list), color hints in terminal output
- Use "may" for: supplementary context from methodology/index.md beyond phase name

## Troubleshooting
- **"project-status.md not found"**: Walk up directory tree to project root. If still not found, suggest running `/init` to bootstrap scaffolding.
- **"YAML parse error in project-status.md"**: Report the specific parse error with line number. Do not attempt to auto-fix — show the raw line and ask user to correct it.
- **"current_phase value is unrecognized"**: Check methodology/index.md for valid phase values. Report the unknown value and the valid range to the user.
- **"active_waves references a wave-NN-status.md that doesn't exist"**: Report the missing file path. Suggest running `/hunt` to regenerate, or manually creating the file.
- **"All phases complete"**: Congratulate the user. Suggest tagging the release and running `/pack` to generate the onboarding guide.

<!-- MATILHA_MANAGED_END -->
