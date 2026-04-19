# Matilha Pack Authors Guide

> How to ship a companion pack that plugs cleanly into Matilha core.

## What you are building

A companion pack is its own plugin — own repo, own `.claude-plugin/plugin.json`, own versioning, own skills directory. Matilha core does not ship your pack. The user installs your pack separately via their plugin marketplace.

## Step-by-step

### 1. Decide domain + prefix

Pick a domain (UX, growth, design, security, harness, or a community-chosen domain) and its prefix (`ux-*`, `growth-*`, etc.). Consult `naming-conventions.md` — you must not claim a prefix already owned.

### 2. Scaffold the pack repo

```
matilha-<yourdomain>-pack/
├── .claude-plugin/
│   └── plugin.json            # MUST include "matilha-pack" in keywords
├── skills/
│   └── <prefix>-<topic>/
│       └── SKILL.md           # follows matilha skill-authoring-guide.md
├── CLAUDE.md                  # pack's own context primer
├── README.md
├── CHANGELOG.md
└── LICENSE
```

### 3. Manifest

Your `.claude-plugin/plugin.json`:

```json
{
  "name": "matilha-ux-pack",
  "version": "0.1.0",
  "description": "Cognitive UX skills for Matilha — Weinschenk, Krug, perception, memory.",
  "keywords": ["matilha-pack", "ux", "cognitive", "weinschenk", "krug"],
  "author": { "name": "<your name>" },
  "license": "MIT"
}
```

The `matilha-pack` keyword is **required**. Matilha core uses it as the discovery signal.

### 4. Skills

Write skills following `docs/matilha/skill-authoring-guide.md`:
- Strict frontmatter.
- Description starts with "Use when".
- All 12 body sections.
- References section for derived content.

### 5. Graceful behavior

Pack skills must NOT assume Matilha core is installed. If a user installs your pack alone, skills should:
- Work for their domain logic without requiring Matilha methodology.
- Mention Matilha core in their body if they integrate with it, but not hard-depend.

### 6. Test locally

```bash
# Clone both
git clone https://github.com/<you>/matilha-<domain>-pack.git
# In Claude Code (or your target platform):
/plugin install /path/to/matilha-skills
/plugin install /path/to/matilha-<domain>-pack

# Verify skill activation
# Trigger an intent that one of your pack skills should fire on.
# Also verify graceful: uninstall matilha-skills, confirm your pack still works.
```

### 7. Publish

Submit to the marketplace of each target platform (Claude Code marketplace, etc.). Include `matilha-pack` in your marketplace listing keywords.

### 8. Version compatibility

Declare Matilha core compatibility via a `matilha-core` range in your plugin.json when Wave 5+ formalizes this. Wave 4a does not enforce it.

## What to avoid

- **Don't duplicate Matilha core skills** — if you're rewriting `matilha-plan` for a domain, you're doing it wrong. Extend via companion integration in your pack skill; delegate core orchestration back to Matilha.
- **Don't hardcode paths to Matilha** — use Skill tool lookup.
- **Don't break graceful fallback** — your pack works standalone.

## Questions

Open an issue on `matilha-skills` repo tagged `pack-author`.
