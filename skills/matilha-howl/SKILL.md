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
Surface the current project state for session resumption. Read `project-status.md` and render a colored terminal summary of phase, next action, tools, active waves, blockers, and pending decisions. Supports `--json` for full machine-readable output. Read-only — does not modify any file.

## SoR Reference
Content of truth lives in:
- `project-status.md` — sole source for howl output; no other files are read

Howl is intentionally narrow: it reports what is recorded in `project-status.md`, nothing more.

## Preconditions
- `project-status.md` exists in the project root (same directory where `matilha howl` is run)

## Execution Workflow
1. User runs `matilha howl` (default text mode) or `matilha howl --json`
2. CLI reads `project-status.md` from the current working directory
3. **If `--json`**: print `JSON.stringify(projectStatus, null, 2)` and exit — no color, no formatting
4. **Text mode** — render colored output using `picocolors`:
   - Header line: project name (bold cyan) + archetype (dim)
   - `Phase:` current_phase value + phase_status (dim)
   - `Next:` next_action value
   - `Tools:` tools_detected array joined by ", " (or dim "none")
   - `Active waves:` active_waves array (only if non-empty)
   - `Blockers:` count + each blocker bulleted in red (only if non-empty)
   - `Pending decisions:` count + each decision bulleted in yellow (only if non-empty)
5. Print and exit — no file writes, no prompts

## Rules: Do
- Report exactly what is in `project-status.md` — do not infer or extrapolate state
- Surface `next_action` verbatim from the file — this is the primary resumption signal
- Handle missing optional fields gracefully: `active_waves` / `blockers` / `pending_decisions` absent or empty → skip those lines silently
- Keep output near-instant — howl is a quick status check, not a computation

## Rules: Don't
- Don't modify `project-status.md` or any other file
- Don't advance gates or phases
- Don't fabricate state not present in `project-status.md`
- Don't load `methodology/index.md` or any other file beyond `project-status.md`
- Don't run long operations

## Expected Behavior
- Output scans quickly: one line per field, blockers and pending decisions highlighted in color
- `--json` output is the full project-status object — useful for piping to other tools or debugging
- When `active_waves` is empty, that line is omitted entirely (not printed as "Active waves: none")
- When `blockers` is non-empty, the count and each item appear in red for immediate visibility

## Quality Gates
- (Read-only skill — no file mutations to validate)
- Text output always includes: header (name + archetype), Phase, Next, Tools lines
- Blockers and Pending decisions lines appear only when those arrays are non-empty
- `--json` output is valid JSON of the full project-status object

## Companion Integration
- If `superpowers` detected: after reviewing howl output, consider invoking the relevant superpowers skill for the current phase (e.g. `superpowers:brainstorming` for Phase 10, `superpowers:writing-plans` for Phase 30)
- If `impeccable` detected and archetype has frontend: check `next_action` — if it references Phase 20, surface aesthetic_direction from project-status.md as a reminder
- If `shadcn-skills` detected: no special howl behavior; use `matilha plan-status` for wave-level detail

## Output Artifacts
- (none — printed to console only, no files written)

## Example Constraint Language
- Use "must" for: reading project-status.md, rendering header + Phase + Next + Tools
- Use "should" for: color choices (red blockers, yellow pending), omitting empty sections
- Use "may" for: supplementary context added manually by the AI agent beyond what CLI prints

## Troubleshooting
- **"project-status.md not found"**: The CLI reads from the current working directory. Ensure you are in the project root where `matilha init` was run. If `project-status.md` is missing entirely, run `matilha init` to bootstrap.
- **"Output shows no active waves"**: `active_waves` is empty in project-status.md. This is normal before `/hunt` starts a wave. Check `next_action` for what to do.
- **"--json output is hard to read"**: Pipe through `jq`: `matilha howl --json | jq '.'`.
- **"next_action is stale"**: The `next_action` field is written by CLI commands (scout, plan, attest). If it looks outdated, check `current_phase` and `phase_*_gates` in `--json` output and consult `methodology/index.md` to determine the actual next step.
- **"Blockers list is long"**: Blockers are appended by CLI commands and must be resolved manually. Edit `project-status.md` to remove resolved blockers, then re-run `matilha howl` to confirm.

<!-- MATILHA_MANAGED_END -->
