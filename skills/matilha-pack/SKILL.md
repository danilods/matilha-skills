---
name: matilha-pack
description: Phase 70 — Generate onboarding guide for new teammate from project state.
metadata:
  author: matilha
  phase: "70"
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /pack — Phase 70 (Teammate Onboarding)

## Mission
Generate a complete onboarding guide for a new teammate joining an active Matilha project. Read the current project state, completed wave history, and review reports to produce `ONBOARDING.md` — a self-contained document that gets a new developer from zero to first contribution without hand-holding.

## SoR Reference
Content of truth lives in:
- methodology/70-onboarding-time.md (onboarding guide structure, minimum required sections, "shadow wave" convention)

ALWAYS consult this page for latest onboarding guide structure and the shadow pilot wave protocol.

## Preconditions
- `project-status.md` exists in project root
- At least one wave has been completed (entry in `completed_waves`)
- `CLAUDE.md` exists (provides project conventions summary)
- Repository has a remote (guides clone instructions)

## Execution Workflow
1. Load `methodology/70-onboarding-time.md` — extract required sections and shadow wave protocol
2. Read core project artifacts:
   - `project-status.md` (phase, archetype, completed waves, recent decisions, feature artifacts)
   - `CLAUDE.md` (project conventions, agent instructions)
   - `docs/matilha/reviews/` most recent review report (code quality context)
   - `docs/matilha/waves/` most recent wave-NN-status.md (current work context)
3. Determine installed companions (check `.claude/skills/`, `.cursor/skills/`, `.agents/skills/`)
4. Generate `ONBOARDING.md` with sections:
   - **Clone + Install**: repo URL, prerequisites, install commands for project stack
   - **Install Matilha**: install command per detected tool (Claude Code, Cursor, Codex, Gemini)
   - **Install Companions**: Impeccable, shadcn-skills, superpowers (if detected in project)
   - **Read CLAUDE.md**: summary of what the new teammate will find there
   - **Run /howl**: output of `/howl` at time of onboarding (snapshot current state)
   - **Understand the Methodology**: links to `methodology/index.md` + 5 most relevant methodology pages for current phase
   - **Shadow a Pilot Wave**: step-by-step instructions for the shadow wave protocol from methodology/70
   - **Contacts + Decision Log**: point to `project-status.md` `recent_decisions` for context on key choices
5. Ask user to review `ONBOARDING.md` before finalizing; offer to add project-specific sections
6. Update `project-status.md`: set `current_phase: 70`, link `ONBOARDING.md` in `feature_artifacts`

## Rules: Do
- Pull clone URL from `git remote get-url origin` — don't hardcode it
- Include exact install commands for detected project stack (not generic placeholder text)
- Link to specific methodology pages for the current project phase, not the full list
- Include the shadow wave protocol from `methodology/70-onboarding-time.md` verbatim (adapted to project context)
- Keep ONBOARDING.md self-contained — a new developer must not need Slack to complete steps 1-N

## Rules: Don't
- Don't generate ONBOARDING.md before at least one wave is completed (no real project state to surface)
- Don't expose secrets or environment variable values in ONBOARDING.md (reference `.env.example` instead)
- Don't include stale wave history beyond the last 3 completed waves (keep it signal, not noise)
- Don't copy-paste entire review reports — summarize findings relevant to a new contributor

## Expected Behavior
- ONBOARDING.md should be completable in under 30 minutes by a developer unfamiliar with the project
- When companions are absent, note their absence and explain what the project uses instead
- If `project-status.md` has active blockers, surface them in ONBOARDING.md under a "Known Issues" section
- When invoked from a fresh project (wave 1 just completed), focus on foundations; skip advanced sections

## Quality Gates
- `ONBOARDING.md` exists in project root
- All 8 required sections present (from methodology/70 structure)
- Clone URL is populated (not a placeholder)
- Shadow wave protocol section included and references a specific recent wave
- No secrets or hardcoded credentials in ONBOARDING.md
- `current_phase` set to 70 in project-status.md
- `ONBOARDING.md` linked in `feature_artifacts`

## Companion Integration
- If `superpowers` detected: include superpowers skill list in the "Install Companions" section with links to each skill's SKILL.md
- If `impeccable` detected: add `/impeccable teach` command as a required step in the aesthetic onboarding section (for frontend projects)
- If `shadcn-skills` detected: add shadcn component library install step and link to the project's component registry

## Output Artifacts
- `ONBOARDING.md` (root)
- Updated `project-status.md` (`current_phase: 70`, `feature_artifacts` with ONBOARDING.md link)

## Example Constraint Language
- Use "must" for: all 8 sections present, no secrets in output, self-contained (no Slack required)
- Use "should" for: completable in ≤30 min, shadow wave protocol tied to a real recent wave
- Use "may" for: project-specific sections added after user review, advanced topics beyond the minimum

## Troubleshooting
- **"No completed waves yet"**: Halt with message: "ONBOARDING.md requires at least one completed wave for real context. Run `/hunt` and `/gather` for Wave 01 first."
- **"Git remote URL not set"**: Insert placeholder `[REPO_URL]` and add a note reminding the user to fill it in before sharing with teammates.
- **"Project has unusual stack not covered by install templates"**: Ask user for the correct install command. Persist it in project-status.md under `install_command` for future use.
- **"ONBOARDING.md already exists"**: Ask: overwrite, append new sections, or skip? Default: show diff of what would change and ask for confirmation.
- **"User wants onboarding for non-developer role (designer, PM)"**: Offer a minimal variant with: repo context, `/howl` state, design-spec.md, and Impeccable guide only.

<!-- MATILHA_MANAGED_END -->
