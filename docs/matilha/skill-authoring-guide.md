# Matilha Skill Authoring Guide

> How to write a skill that activates reliably, composes with companions, and scales to 100+ siblings.

## Frontmatter schema (strict)

```yaml
---
name: <slug>                       # REQUIRED; matches directory name; kebab-case
description: <1-sentence>          # REQUIRED; the activation contract
category: matilha | ux | growth | design | security | harness | cog
version: "1.0.0"                   # OPTIONAL; semantic versioning
requires: []                       # OPTIONAL; companion pack slugs this skill depends on
optional_companions: []            # OPTIONAL; companion skills invoked if present
---
```

Validator rules (enforced by matilha repo `tests/registry/content-validation.test.ts`):
- `name` must match the directory name exactly.
- `name` must match regex `^[a-z][a-z0-9-]*[a-z0-9]$`.
- `description` must be non-empty, ≤ 200 chars, and start with "Use when " OR "When " (activation phrasing).
- `category` must be one of the enum values.

## Description is the activation contract

The description is the SINGLE thing the Skill tool matches on to auto-invoke a skill. A bad description = invisible skill. Principles:

- **Start with "Use when ..."** — explicit trigger phrasing. Alternatives: "When X, ...".
- **Name the user intent**: "Use when planning a feature", "Use when adding a UI component", "Use when making a pricing decision".
- **Include load-bearing keywords**: the words a user actually says. The AI matches them.
- **Avoid vague framing**: "helpful for", "might apply", "sometimes useful". These don't activate.
- **Max ~25 words**: longer descriptions get de-weighted.

Examples:

✅ `Use when planning a feature with multiple subprojects or parallel work — generates a phase-gated plan.md with waves, SPs, merge_order.`

✅ `When the user is about to merge completed subprojects, use to validate SP-DONE gates and run per-SP regression before the wave is closed.`

❌ `A skill that can help with planning complex features.` (vague, won't trigger)

❌ `This skill is for experienced developers working on big projects.` (describes users, not intent)

## Body structure (required sections, in order)

Every `SKILL.md` body has these 12 sections. A registry validator confirms they exist.

```markdown
## When this fires
<one paragraph reinforcing the description>

## Preconditions
- <bulleted list the AI verifies before proceeding>

## Execution Workflow
<numbered steps using Claude Code tool names; AI substitutes per docs/platform-tool-mapping.md>

## Rules: Do
- <imperative guidance>

## Rules: Don't
- <anti-patterns>

## Expected Behavior
<how the skill should behave in common cases>

## Quality Gates
- <enumerable gates to verify before claiming done>

## Companion Integration
<optional delegation to companion packs; see companions-contract.md>

## Output Artifacts
- <files created/modified by this skill>

## Example Constraint Language
- Use "must" for: <...>
- Use "should" for: <...>
- Use "may" for: <...>

## Troubleshooting
- **"<error condition>"**: <recovery steps>

## Sources
<optional; wiki wikilinks for derived content>
```

## References subdirectory

If the skill needs long supplementary content (tables, tool mappings, citation dumps from wiki), put it in `skills/<slug>/references/<topic>.md`. Keep `SKILL.md` lean (< 300 lines).

## CLI shortcut tip (for skills with CLI equivalents)

Close the body with:

```markdown
## CLI shortcut (optional)

> If matilha CLI is installed (`matilha --version` succeeds), you can run
> `matilha <command> <args>` to execute this deterministically. Preferred
> for CI or repeatable automation. The plugin path described above works
> without any CLI installation.
```

## Citation discipline (for derived content)

Skills derived from wiki content MUST cite the source in a `## Sources` section:

```markdown
## Sources

- [[sources/100-things-every-designer]] — Weinschenk (2011), principles #12-18
- [[concepts/percepcao-visual]]
- [[concepts/leis-de-krug]]
```

Wiki wikilinks preserved so contributors can trace back to source of record.

## Checklist before merging a new skill

- [ ] Frontmatter schema validates.
- [ ] Description starts with "Use when" / "When" and names user intent.
- [ ] All 12 body sections present.
- [ ] If derived: `## Sources` cites wiki with wikilinks.
- [ ] Optional `references/` subdirectory clean.
- [ ] CLI shortcut tip added if applicable.
- [ ] Skill directory name matches `name:` frontmatter.
- [ ] Validator test passes.
