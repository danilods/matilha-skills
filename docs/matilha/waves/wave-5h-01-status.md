---
wave: 5h
sp: SP-A
slug: sp-a-routing-table
branch: wave-01-sp-a-routing-table
worktree: ../matilha-skills-sp-a-routing-table
status: completed
---

# Wave 5h — SP-A status

## Scope (per kickoff)

- A.1 — Create `skills/matilha-compose/routing-table.md`
- A.2 — Edit `skills/matilha-compose/SKILL.md` Step 2 (insert 2a, relabel old prose as 2b)

A.3 (validator tests) is out of scope for this kickoff.

## Exit gate

- [x] `skills/matilha-compose/routing-table.md` exists
- [x] ≥15 entries per pack section (7 packs)
- [x] Compose `SKILL.md` contains "routing-table", "Step 2a", "Step 2b"
- [x] Git status clean, commit on branch `wave-01-sp-a-routing-table`

## Per-pack entry counts

| Pack                          | Entries |
|-------------------------------|---------|
| matilha-ux-pack               | 17      |
| matilha-growth-pack           | 16      |
| matilha-harness-pack          | 15      |
| matilha-sysdesign-pack        | 16      |
| matilha-software-eng-pack     | 15      |
| matilha-software-arch-pack    | 15      |
| matilha-security-pack         | 16      |

## Deviation from "verbatim" plan A.1

The plan A.1 ships `matilha-software-eng-pack` with 12 entries, but both the plan's own A.1 exit gate and the kickoff exit gate require **≥15 per pack**. To satisfy the gate without rewriting the table, three keywords were added:

- `yagni` → `sweng-kiss-antidote-overengineering` (also matches B.5 trigger description)
- `changelog` → `sweng-changelog-discipline`
- `atomic commits` → `sweng-commits-atomicos-semanticos`

All three map cleanly to existing pack skills. User-approved before commit.

## Notes for downstream SPs

- SP-A.3 (validator tests) — when implemented in a follow-up SP, the `EXPECTED_PACKS` array and the `≥15` assertion in plan A.3 will pass against this table.
- SP-B (trigger skills) — disjoint, unblocked by SP-A merge.
