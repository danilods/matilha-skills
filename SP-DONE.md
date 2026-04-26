---
sp_id: sp-a-routing-table
feature: wave-5h-max-activation
wave: "01"
status: completed
completed_at: "2026-04-26"
---

# SP-A — Routing Table — Done Checklist

## Deliverables

- [x] `skills/matilha-compose/routing-table.md` created (≥15 entries × 7 packs)
- [x] `skills/matilha-compose/SKILL.md` Step 2 updated (2a + 2b structure)
- [x] Commit on `wave-01-sp-a-routing-table`

## Verify

```bash
grep -c "|" skills/matilha-compose/routing-table.md   # expect ~120
grep "Step 2a" skills/matilha-compose/SKILL.md         # expect 1+ match
grep "routing-table" skills/matilha-compose/SKILL.md   # expect 1+ match
```

Per-pack counts (all ≥15):

| Pack                          | Entries |
|-------------------------------|---------|
| matilha-ux-pack               | 17      |
| matilha-growth-pack           | 16      |
| matilha-harness-pack          | 15      |
| matilha-sysdesign-pack        | 16      |
| matilha-software-eng-pack     | 15      |
| matilha-software-arch-pack    | 15      |
| matilha-security-pack         | 16      |

## Notes

**Deviation from "copy plan A.1 verbatim":** plan A.1 shipped `matilha-software-eng-pack` with only 12 entries, contradicting both the plan's own A.1 exit gate and the kickoff exit gate (≥15 per pack). Three keywords were added (user-approved) to close the gap:

- `yagni` → `sweng-kiss-antidote-overengineering` (also matches B.5 trigger description, aligning the two activation paths)
- `changelog` → `sweng-changelog-discipline`
- `atomic commits` → `sweng-commits-atomicos-semanticos`

All three are distinctive (low false-positive risk) and map to real skills shipped in `matilha-software-eng-pack`.

**Step 2 edit:** preserved the existing prose-semantic block verbatim under the new `Step 2b` heading; only the opening paragraph was replaced to insert `Step 2a`. Existing rule "Don't use hardcoded keyword maps" was kept inside Step 2b — it now reads as guidance for the *fallback* prose path, not the deterministic 2a layer. (The contract has shifted: deterministic keyword matching is now first-class for known terms; semantic prose handles the long tail.)

**Out of scope per kickoff:** A.3 validator tests. The shipped table will satisfy the plan's `≥15` assertion when those tests land.
