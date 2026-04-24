---
type: template
consumers: [matilha install-plugins --with-claudemd, /matilha-install wizard]
version: v1
---

# claude-matilha-snippet

Canonical snippet inserted into a user's `./CLAUDE.md` to activate matilha's compose priority rule.

**Do not edit freely** — consumers (SP-A CLI, SP-C slash command) bundle / embed this content. Any edits must be propagated through the merge-or-create contract (`claude-matilha-contract.md`) and a version bump (v1 → v2).

## Snippet (copy between markers into CLAUDE.md)

<!-- matilha-start v1 -->
## Matilha — activation priority

This project uses the matilha harness. **Before invoking any creative-work skill** (`superpowers:brainstorming`, `superpowers:writing-plans`, etc.), you MUST first invoke `matilha:matilha-compose` via the Skill tool.

`matilha-compose` classifies intent into a matilha phase (scout / plan / design / hunt / gather / review / howl), detects installed companion packs, and dispatches to the right skill with pack-aware enrichment.

If `matilha:matilha-compose` is NOT visible in your skill list, matilha is not installed — proceed with default skills.

**Phases:** 0 (howl) → 10 (scout) → 20-30 (plan) → 40 (hunt/gather) → 50 (review) → 60 (den) → 70 (pack).

**Docs:** https://github.com/danilods/matilha-skills
<!-- matilha-end v1 -->
