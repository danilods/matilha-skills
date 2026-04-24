---
description: "Show the complete matilha ecosystem install guide (core + 7 companion packs) formatted for copy-paste"
argument_hint: "(none)"
---

Respond with the complete matilha ecosystem install guide below. Do NOT execute any commands — output the guide as a formatted markdown message for the user to copy-paste. The user will run the `/plugin install` commands themselves.

---

# Matilha Ecosystem — Install Guide

You already have `matilha-skills` installed. Below is the complete guide for adding the 7 companion packs. Each pack is optional — install only the domains that match your work.

## Recommended: user scope (methodology-everywhere)

Install at user scope so each pack is available in every workspace, not just per-project. Copy-paste the block below:

```
/plugin marketplace add danilods/matilha-ux-pack
/plugin install matilha-ux-pack@matilha-ux-pack --user

/plugin marketplace add danilods/matilha-growth-pack
/plugin install matilha-growth-pack@matilha-growth-pack --user

/plugin marketplace add danilods/matilha-harness-pack
/plugin install matilha-harness-pack@matilha-harness-pack --user

/plugin marketplace add danilods/matilha-sysdesign-pack
/plugin install matilha-sysdesign-pack@matilha-sysdesign-pack --user

/plugin marketplace add danilods/matilha-software-eng-pack
/plugin install matilha-software-eng-pack@matilha-software-eng-pack --user

/plugin marketplace add danilods/matilha-software-arch-pack
/plugin install matilha-software-arch-pack@matilha-software-arch-pack --user

/plugin marketplace add danilods/matilha-security-pack
/plugin install matilha-security-pack@matilha-security-pack --user
```

(If `--user` is not recognized, use the interactive `/plugin` menu and select **user scope**.)

## Pick individual packs (à la carte)

If you prefer to install only specific packs, use the table below to decide. Each pack auto-activates via matilha-compose when user intent matches — installing all of them doesn't add noise, so bulk-install is safe.

| Pack | Skills | Install when you... |
|---|---|---|
| **matilha-ux-pack** | 22 | Build UIs, forms, error flows, cognitive-load decisions. Weinschenk + Krug + cognitive psych. |
| **matilha-growth-pack** | 20 | Do growth work — signup flows, pricing, activation, retention, positioning. AARRR + JTBD. |
| **matilha-harness-pack** | 22 | Build LLM agents — multi-agent systems, context engineering, evals. Anthropic + OpenAI + Lopopolo. |
| **matilha-sysdesign-pack** | 19 | Scale distributed systems — NFRs, CAP, Kafka, CDN, rate limiting. Zhiyong Tan. |
| **matilha-software-eng-pack** | 15 | Day-to-day engineering discipline — KISS, RORO, commits, docs, task tracking. Danilo-experience. |
| **matilha-software-arch-pack** | 17 | Organize code — layering, Lambda chains, event-driven, dual-store, bounded contexts. Argos + Gravicode. |
| **matilha-security-pack** | 13 | Ship AI software safely — keys, trust boundary, LLM risks, LGPD. NOT a STRIDE/OWASP replacement. |

## After installing

Verify with:

```
/plugin list
```

You should see `matilha` + the packs you chose, all marked as **enabled**.

Open a fresh session in any directory and type a software-construction prompt. The SessionStart hook fires matilha-bootstrap, then matilha-compose detects installed packs and injects atmospheric preamble before dispatching to brainstorming. The sigil (♛ + pack dogs) confirms the flow is working.

## Tip

You don't need ALL packs to use matilha. Core alone is valuable (11 methodology skills). Each pack adds domain expertise. Start with 1-2 packs matching your current project, add more as you hit new domains.

## Troubleshooting

- **Sigil never appears** → check `/plugin list`. matilha must be enabled at user scope.
- **Compose fires but no packs detected** → pack plugin(s) missing from user-scope install. Re-run the install block above.
- **"Use the /plugin menu" prompt** → your Claude Code version doesn't recognize `--user`. Use the interactive menu and select user scope.

---

**You lead. Agents hunt.** 🐺
