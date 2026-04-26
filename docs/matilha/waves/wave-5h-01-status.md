---
wave: "01"
slug: wave-5h-max-activation
created: 2026-04-26
status: in_progress
merge_order:
  - sp-a-routing-table
  - sp-b-trigger-skills
sps:
  - id: sp-a-routing-table
    branch: wave-01-sp-a-routing-table
    repo: matilha-skills
    worktree: ../matilha-skills-sp-a-routing-table
    status: pending
    touches:
      - skills/matilha-compose/routing-table.md
      - skills/matilha-compose/SKILL.md
  - id: sp-b-trigger-skills
    branch: wave-01-sp-b-trigger-skill
    repo: matilha-ux-pack | matilha-growth-pack | matilha-harness-pack | matilha-sysdesign-pack | matilha-software-eng-pack | matilha-software-arch-pack | matilha-security-pack
    worktree: direct (separate repos — no worktree needed)
    status: pending
    touches:
      - skills/matilha-ux-trigger/SKILL.md (in matilha-ux-pack)
      - skills/matilha-growth-trigger/SKILL.md (in matilha-growth-pack)
      - skills/matilha-harness-trigger/SKILL.md (in matilha-harness-pack)
      - skills/matilha-sysdesign-trigger/SKILL.md (in matilha-sysdesign-pack)
      - skills/matilha-software-eng-trigger/SKILL.md (in matilha-software-eng-pack)
      - skills/matilha-software-arch-trigger/SKILL.md (in matilha-software-arch-pack)
      - skills/matilha-security-trigger/SKILL.md (in matilha-security-pack)
notes: >
  SPs are disjoint (different repos). matilha CLI test additions
  (tests/registry/content-validation.test.ts) handled at gather time —
  SP-A and SP-B each add separate describe blocks, no merge conflict.
  Version bump: matilha-skills 1.2.x→1.3.0 (minor), each pack 0.2.x→0.3.0 (minor).
---
