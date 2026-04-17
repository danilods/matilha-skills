# Contributing

## Skill changes

Each skill must follow the 12-section blueprint defined in [matilha/DESIGN.md](https://github.com/danilods/matilha/blob/main/DESIGN.md):

Mission, SoR Reference, Preconditions, Execution Workflow, Rules: Do, Rules: Don't, Expected Behavior, Quality Gates, Companion Integration, Output Artifacts, Example Constraint Language, Troubleshooting.

Wrap content between `<!-- MATILHA_MANAGED_START -->` and `<!-- MATILHA_MANAGED_END -->` markers so `matilha update` can refresh without losing user annotations.

## Methodology changes

Methodology pages have frontmatter:

```yaml
---
type: methodology
phase: <00|10|20|30|40|50|60|70|transversal|index>
status: <stub|skeleton|deep>
maturity: <v1|v2|...>
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

PRs that add new methodology pages must update `index.json`.

## Registry index

`index.json` has the shape:

```json
{
  "slug-here": {
    "slug": "slug-here",
    "name": "Display Name",
    "skillPath": "skills/slug-here/SKILL.md"
  }
}
```

Slugs must be lowercase letters, digits, hyphens only (`^[a-z0-9](?:[a-z0-9-_]*[a-z0-9])?$`).
