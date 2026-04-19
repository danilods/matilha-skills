# Matilha Companions Contract

> The rules for plugging a companion pack into Matilha core.

## What is a companion pack?

A companion pack is an independent plugin that extends Matilha's methodology with specialized intelligence for a domain — UX, growth, design, security, harness, or any other domain. Packs are installed separately by the user and Matilha core detects + delegates to them gracefully.

**Matilha core stays lean** (10-15 skills covering methodology orchestration). **Domain expertise lives in packs.** This keeps the core plugin's cognitive load small for users who only want methodology, while enabling power users to install multiple packs for specialist guidance.

## Pack manifest requirements

A pack's `.claude-plugin/plugin.json` MUST include `"matilha-pack"` in its `keywords` array:

```json
{
  "name": "matilha-ux-pack",
  "description": "Weinschenk, Krug, and cognitive-psychology skills for Matilha.",
  "keywords": ["matilha-pack", "ux", "cognitive", "weinschenk", "krug"],
  ...
}
```

The `matilha-pack` keyword is the discovery signal — no separate registry. Any plugin with this keyword declares itself a Matilha companion.

## Skill naming in packs

Pack skills use `<domain>-<topic>` prefix (see `naming-conventions.md`). One domain prefix per pack. Collision across packs is prevented by unique prefix.

## Detection pattern (core → companion delegation)

Matilha core skills that have potential companion integrations include a **Companion integration** section in their body:

```markdown
## Integration with companions

- **If `ux-weinschenk:perception-rules` is available** (from matilha-ux-pack):
  invoke via Skill tool during Phase 20 (design) for a visual-perception audit.
- **If `growth-jtbd:forces-of-progress` is available** (from matilha-growth-pack):
  invoke during Phase 10 (discovery) to map push/pull/anxiety/habit.
- **Otherwise**: proceed with core heuristics documented below.
```

Detection uses the Skill tool's natural "is this skill available" check. If absent → fall through to core instructions. **Zero errors on absent companions.**

## Graceful fallback principle

Three non-negotiable rules:

1. **Core Matilha skills MUST function end-to-end without any companion installed.**
2. **Companion integration is a QUALITY enhancement**, not a requirement.
3. **If a companion's skill fails at runtime**, the core skill catches the error (5-rule format) and continues with core instructions. Never cascades.

## Runtime versioning

Packs declare Matilha core compatibility via semver range in their own plugin.json (e.g., `"matilha-core": ">=0.4.0"`). Matilha does not enforce this at runtime in Wave 4a; Wave 5+ ships a linter.

## Contract evolution

Changes to this contract are additive. Deprecations follow 2-wave notice (announce in Wave N; remove in Wave N+2). Pack authors can rely on the contract holding across minor matilha versions.
