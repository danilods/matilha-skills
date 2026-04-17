---
name: matilha-init
description: Bootstrap a Matilha project — generate CLAUDE.md, project-status.md, AGENTS.md, design-spec.md, install skills for detected tools.
metadata:
  author: matilha
  phase: transversal
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /init — Bootstrap Matilha Project

## Mission
Bootstrap a Matilha project from zero: detect the user's tool, ask about archetype and aesthetic direction, generate scaffolding (CLAUDE.md, project-status.md, design-spec.md, AGENTS.md), offer to install companion skills (Impeccable, shadcn/ui, superpowers), and leave the user ready to run `/scout` or `/plan`.

## SoR Reference
Content of truth lives in:
- methodology/index.md
- methodology/20-stack.md (archetype defaults)
- methodology/materializacoes.md (tool detection rules)

ALWAYS consult these pages for latest gates and archetype defaults.

## Preconditions
- Running in the root of a new or existing project (git repo recommended but not required)
- User has at least one agentic tool installed (Claude Code, Cursor, Codex, or Gemini CLI)

## Execution Workflow
1. Check if `project-status.md` already exists; if yes, ask whether to overwrite or skip
2. Detect agentic tool(s) by inspecting `.claude/`, `.cursor/`, `.codex/`, `.gemini/` directories; report detected
3. Ask: "What archetype is this project?" from options: saas-b2b, saas-b2c, frontend-only, cli, library, ml-service, marketplace
4. If archetype has frontend: ask "Aesthetic direction?" from brutalist, editorial, organic, luxury, minimal, maximalist
5. Generate files from templates with substitutions:
   - `CLAUDE.md` (from `CLAUDE.md.tmpl`, ≤150 lines, archetype-specific index)
   - `project-status.md` (frontmatter schema from Zod, gate objects empty, aesthetic filled in)
   - `AGENTS.md` (SoR for Codex, indexing skills/methodology)
   - `design-spec.md` (only if frontend; captures aesthetic + references from `references/`)
6. Ask: "Install recommended companions? (Impeccable ON, shadcn ON-if-frontend, superpowers ON)"
7. If yes, execute companion install commands appropriate for each detected tool
8. Write `.claude/skills/matilha-*/SKILL.md` via universal + detected-tool renderers
9. Print summary: "Matilha initialized. Next: /scout to begin Phase 00 (or /howl to view state)"

## Rules: Do
- Detect tools before asking archetype (influences recommendations)
- Pre-populate frontmatter of `project-status.md` with defaults reasonable for archetype
- Preserve existing `CLAUDE.md` content if overwriting; move old content to `CLAUDE.md.old-<timestamp>`
- Use YAML frontmatter for `project-status.md` (validates against `projectStatusSchema`)
- Always write universal skill target (`.agents/skills/`) even when no tool detected

## Rules: Don't
- Don't force companion install (offer with defaults ON, allow skip per companion)
- Don't overwrite `project-status.md` without asking
- Don't write to `.claude/` if Claude Code wasn't detected
- Don't proceed if user doesn't confirm archetype

## Expected Behavior
- Defaults are aggressive toward quality (companions ON, aesthetic committed)
- When user unsure of archetype, offer guidance per `methodology/20-stack.md` heuristics
- On dry-run (`--dry-run` flag), list what would be written without writing

## Quality Gates
- `project-status.md` parses cleanly against `projectStatusSchema` (Zod)
- All detected tools have corresponding skill files written (`.claude/skills/matilha-*`, etc)
- `.agents/skills/` universal target always populated
- Generated `CLAUDE.md` is ≤150 lines
- `design-spec.md` only generated if archetype has frontend

## Companion Integration
- If `superpowers` detected: recommend installing Matilha's superpowers-integration mode (doesn't override superpowers, coexists)
- If `impeccable` detected: pre-configure `design-spec.md` to include `/impeccable teach` step
- If `shadcn` skills detected: add component import hints to `design-spec.md`

## Output Artifacts
- `CLAUDE.md` (root)
- `AGENTS.md` (root)
- `project-status.md` (root)
- `design-spec.md` (root, only if frontend archetype)
- `.claude/skills/matilha-*/SKILL.md` (if Claude Code detected)
- `.cursor/skills/matilha-*/SKILL.md` (if Cursor detected)
- `.codex/skills/matilha-*/SKILL.md` (if Codex detected)
- `.gemini/skills/matilha-*/SKILL.md` (if Gemini CLI detected)
- `.agents/skills/matilha-*/SKILL.md` (always)

## Example Constraint Language
- Use "must" for: project-status.md schema validation, universal target population
- Use "should" for: companion install defaults, aesthetic direction commitment
- Use "may" for: optional companions beyond the 3 recommended (e.g., typeui)

## Troubleshooting
- **"No tools detected"**: User is in a fresh project. Ask which tool they prefer to target as primary; write skills for that one + universal.
- **"`project-status.md` already exists"**: Ask: overwrite, skip, or merge? Prefer skip unless user explicitly requests overwrite.
- **"Companion install failed"**: Report which companion and why. Continue with init; user can install companion manually later.
- **"User rejects all archetypes"**: Offer `custom` option that defaults to `saas-b2b` templates but flags `archetype: custom` in frontmatter.

<!-- MATILHA_MANAGED_END -->
