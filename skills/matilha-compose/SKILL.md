---
name: matilha-compose
description: "You MUST use this skill before invoking superpowers:brainstorming when the user prompt signals creative work (building, designing, planning, adding, modifying a system/feature/product) AND the current project is a matilha project (docs/matilha/ exists, project-status.md exists, OR any skill with plugin namespace matching matilha-*-pack is visible in your skill list). Detects installed companion packs via plugin-namespace inspection, classifies intent, injects pack-aware preamble, then dispatches to brainstorming (or directly to matilha-plan/matilha-design for explicit planning/design prompts). If neither activation condition holds, defer to superpowers:brainstorming directly."
category: matilha
version: "0.0.1-spike"
optional_companions: ["superpowers:brainstorming", "matilha-plan", "matilha-design"]
---

## When this fires

(Stub — replaced by SP1 full body if activation gate test passes.)

When activation gate wins: emit marker text **"MATILHA-COMPOSE ACTIVATED (SP0 SPIKE)"** in the output so the spike test can confirm which skill handled the prompt. Then defer to `superpowers:brainstorming` via the Skill tool.

## Preconditions

- Ambient skill list available.

## Execution Workflow

1. Emit the marker text literally at the top of the output: `MATILHA-COMPOSE ACTIVATED (SP0 SPIKE)`.
2. Invoke `superpowers:brainstorming` via Skill tool to continue the exploration.

## Rules: Do

- Emit the marker text literally on every activation.
- Defer to `superpowers:brainstorming` after emitting the marker.

## Rules: Don't

- Don't perform full composition logic — this is a spike, body logic comes in SP1.
- Don't skip the marker — it is the signal for the spike test.

## Expected Behavior

If compose wins activation against `superpowers:brainstorming`, the marker text appears in the output. Then brainstorming takes over and runs normally.

## Quality Gates

- Marker emitted on activation.
- Brainstorming invoked after marker.

## Companion Integration

Defers to `superpowers:brainstorming` after emitting marker. Full companion-pack detection logic deferred to SP1 full body.

## Output Artifacts

None (spike).

## Example Constraint Language

- **Must**: emit marker on activation.
- **Should**: defer to brainstorming after marker.

## Troubleshooting

- **"Marker absent from output"** → description gate failed; `superpowers:brainstorming` won activation. Iterate description wording and reinstall plugin.

## CLI shortcut (optional)

None (spike).
