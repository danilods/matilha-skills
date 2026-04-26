---
wave: "01"
slug: wave-5h-max-activation
created: 2026-04-26
started: 2026-04-26
ended: 2026-04-26
status: completed
regression_status: passed
regression_summary:
  command: "npm test (in matilha CLI repo)"
  total: 1540
  passed: 1540
  failed: 0
  delta_from_baseline: "+44 (1496 → 1540) — added validators per plan A.3 + B.8"
  validator_extension_commit: "matilha:36e0bbd"
merge_order:
  - sp-a-routing-table
  - sp-b-trigger-skills
sps:
  - id: sp-a-routing-table
    branch: wave-01-sp-a-routing-table
    repo: matilha-skills
    worktree: ../matilha-skills-sp-a-routing-table
    status: completed
    feat_commit: 9e6de57
    merge_commit: 9971ca6
    touches:
      - skills/matilha-compose/routing-table.md
      - skills/matilha-compose/SKILL.md
  - id: sp-b-trigger-skills
    branch: wave-01-sp-b-trigger-skill
    repo: matilha-ux-pack | matilha-growth-pack | matilha-harness-pack | matilha-sysdesign-pack | matilha-software-eng-pack | matilha-software-arch-pack | matilha-security-pack
    worktree: direct (separate repos — no worktree used)
    status: completed
    pack_merges:
      matilha-ux-pack:           { feat: 83746fd, merge: ce24a84, version: 0.3.0 }
      matilha-growth-pack:       { feat: deb693e, merge: 66d6b28, version: 0.3.0 }
      matilha-harness-pack:      { feat: ca1a563, merge: eecf2ab, version: 0.3.0 }
      matilha-sysdesign-pack:    { feat: e62dd86, merge: 39e63ea, version: 0.3.0 }
      matilha-software-eng-pack: { feat: 169287c, merge: f2c2954, version: 0.3.0 }
      matilha-software-arch-pack: { feat: 03b6af1, merge: bfc52f9, version: 0.3.0 }
      matilha-security-pack:     { feat: 9ef121b, merge: b5898b2, version: 0.3.0 }
    touches:
      - skills/matilha-ux-trigger/SKILL.md (in matilha-ux-pack)
      - skills/matilha-growth-trigger/SKILL.md (in matilha-growth-pack)
      - skills/matilha-harness-trigger/SKILL.md (in matilha-harness-pack)
      - skills/matilha-sysdesign-trigger/SKILL.md (in matilha-sysdesign-pack)
      - skills/matilha-software-eng-trigger/SKILL.md (in matilha-software-eng-pack)
      - skills/matilha-software-arch-trigger/SKILL.md (in matilha-software-arch-pack)
      - skills/matilha-security-trigger/SKILL.md (in matilha-security-pack)
notes: >
  SPs disjoint (different repos). SP-A landed in matilha-skills via the
  worktree at ../matilha-skills-sp-a-routing-table. SP-B landed across
  7 sibling pack repos, each bumped 0.2.0 → 0.3.0 with a tailored
  CHANGELOG entry. Each pack now ships an independent activation
  surface (`matilha-<domain>-trigger`) that complements the routing
  table in matilha-skills/skills/matilha-compose/routing-table.md.
sp_a_deviation: >
  Plan A.1 shipped matilha-software-eng-pack with 12 entries; plan's
  own gate required ≥15. Added 3 keywords (yagni / changelog / atomic
  commits) — each maps cleanly to an existing pack skill, user-approved.
methodology_lessons:
  - cross_repo_waves_break_gather: >
      /matilha-gather is single-repo by design (one wave-NN-status.md,
      one merge_order, merges into one main). Wave 5h is structurally
      cross-repo (SP-A in matilha-skills + SP-B across 7 pack repos).
      Gather can't model this. Wave-5h shipped via 8 manual merges.
      Methodology gap to address: introduce cross-repo waves (or split
      cross-repo SPs into per-repo mini-waves) before next time a wave
      touches multiple repos.
  - sp_b_worktree_isolation_reincidence: >
      SP-B agent did not use isolation:worktree — swapped HEAD in 7
      live pack repos and left files untracked. This repeats the
      Wave 5g HEAD-swap race that the worktree-isolation feedback rule
      already documents. The file `worktree: direct (separate repos
      — no worktree needed)` line in this manifest LICENSED that
      behavior. The manifest authoring step (matilha-hunt) must
      enforce isolation per agent regardless of repo separation —
      isolation is about the agent's writes being recoverable, not
      about repo collisions.
  - hallucinated_completion_report: >
      The SP-B agent reported "branch wave-01-sp-b-trigger-skill,
      untracked" + per-pack file paths + count tables — all of which
      were structurally wrong (files were really in sibling repos, not
      under packs/) but the report read coherent enough to look done.
      Trust-but-verify caught it: a `find` across the claimed paths
      returned zero files. Without verification, gather would have
      run on phantom artifacts.
  - validator_must_evolve_with_skill_categories: >
      The validator was built for craft skills (Caminho C / Wikinha
      distillations: 100-500 lines, mandatory Sources, 11 required
      sections). When SP-B introduced trigger skills (compact routing
      surfaces: ~37 lines, no Sources, focused subset of sections),
      the existing validator failed 39 tests. Lesson: any new skill
      category requires a category-aware validator extension before
      ship — not as a follow-up SP. The original SP-A.3 / SP-B.8
      "out-of-scope" deferral was a mistake; validator support for
      a new surface is *part of the surface*, not a subsequent task.
---
