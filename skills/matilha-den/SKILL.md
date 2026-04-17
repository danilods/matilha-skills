---
name: matilha-den
description: Phase 60 — Deploy with security gate. Infra choice (DO, Vercel, Cloudflare, EKS).
metadata:
  author: matilha
  phase: "60"
  version: 1.0.0
  requires: []
  optional_companions: [impeccable, shadcn-skills, superpowers]
license: MIT
---

<!-- MATILHA_MANAGED_START -->

# /den — Phase 60 (Deploy + Infra)

## Mission
Guide deployment with a mandatory security gate. Select infra target based on project archetype, generate deploy artifacts (Dockerfile, docker-compose, CI/CD workflows, infra-as-code), and confirm production readiness before any environment receives code.

## SoR Reference
Content of truth lives in:
- methodology/60-deploy-infra.md (security checklist, infra decision tree by archetype, artifact conventions)

ALWAYS consult this page for latest security checklist items and infra defaults per archetype.

## Preconditions
- `/review` has passed (no unresolved `critical` findings)
- No secrets committed to repository (checked via `git log` + secret scan)
- `current_phase` in project-status.md is ≥ 50
- Deployment target environment exists or will be created during this phase

## Execution Workflow
1. Load `methodology/60-deploy-infra.md` — extract security checklist and infra decision tree
2. Run security gate — walk checklist items with user:
   - No secrets in git history (run `git log -p | grep -i 'secret\|password\|api_key\|token'`)
   - `.env.example` present and complete; `.env` in `.gitignore`
   - HTTPS enforced on all endpoints
   - Auth middleware covers all protected routes
   - Dependency audit clean (`npm audit` / `pip audit` / equivalent)
   - Rate limiting configured on public endpoints
3. If any checklist item fails: halt; do not proceed to infra selection until resolved
4. Ask infra target based on archetype defaults from methodology:
   - `frontend-only`: Vercel or Cloudflare Pages (default: Vercel)
   - `saas-b2b` / `saas-b2c`: DigitalOcean App Platform or EKS (default: DO)
   - `cli` / `library`: PyPI / npm publish (no server infra)
   - `ml-service`: DO Droplet with Docker or EKS
5. Generate deploy artifacts for chosen infra:
   - `Dockerfile` + `.dockerignore`
   - `docker-compose.yml` (local parity environment)
   - CI/CD workflow (`.github/workflows/deploy.yml` or platform-native)
   - Infra-as-code if chosen (Terraform for DO/EKS, wrangler.toml for Cloudflare)
6. Verify local Docker build succeeds before writing CI/CD workflow
7. Update `project-status.md`: set `current_phase: 60`, record infra target, link artifacts

## Rules: Do
- Run security checklist before every infra selection, even on re-deploys
- Generate `docker-compose.yml` for local parity regardless of production infra choice
- Validate `Dockerfile` builds locally before writing CI/CD artifacts
- Record infra choice and rationale in `project-status.md` `recent_decisions`
- Keep secrets out of generated artifacts — use environment variable references, not hardcoded values

## Rules: Don't
- Don't bypass the security checklist — it is mandatory, not advisory
- Don't generate infra artifacts before security gate passes
- Don't hardcode credentials, API keys, or secrets in any generated file
- Don't choose infra without confirming archetype matches methodology defaults
- Don't modify `methodology/*.md` (read-only SoR)

## Expected Behavior
- If user has already deployed to an infra target, `/den` can run in update mode (regenerate CI/CD artifacts for the existing target)
- For `cli`/`library` archetypes, the "deploy" is a publish workflow — generate `npm publish` or PyPI release CI instead of Docker artifacts
- If user disagrees with archetype-default infra, log the exception as `decisão de juízo` and proceed with chosen target

## Quality Gates
- Security checklist complete with all items resolved (no failures)
- `Dockerfile` builds successfully (local validation)
- CI/CD workflow file exists and references correct environment variables (not hardcoded secrets)
- `docker-compose.yml` exists for local parity
- Infra target recorded in `project-status.md` with rationale
- `current_phase` set to 60

## Companion Integration
- If `superpowers` detected: can delegate CI/CD workflow generation to a superpowers-powered infra agent; Matilha wraps with security gate enforcement
- If `impeccable` + frontend archetype: ensure build output passes Impeccable audit before deployment artifacts are finalized
- If Cloudflare infra chosen: generate `wrangler.toml` with correct bindings and check for Cloudflare-specific deployment constraints

## Output Artifacts
- `Dockerfile` (root or `deploy/`)
- `.dockerignore` (root)
- `docker-compose.yml` (root, local parity)
- `.github/workflows/deploy.yml` (or platform-native CI/CD config)
- Infra-as-code files if applicable (`terraform/`, `wrangler.toml`, `app.yaml`)
- Updated `project-status.md` (`current_phase: 60`, infra target, artifacts links)

## Example Constraint Language
- Use "must" for: security checklist completion, no hardcoded secrets in artifacts, Dockerfile local build validation
- Use "should" for: docker-compose.yml for local parity, infra choice matching archetype defaults
- Use "may" for: infra-as-code (Terraform) for teams who prefer declarative infra management

## Troubleshooting
- **"Security checklist item can't be verified automatically"**: Report it as "manual check required" with instructions for the user. Do not mark as passed without verification.
- **"Docker build fails"**: Report the exact error from `docker build` output. Common causes: missing base image, COPY path errors, missing env vars at build time.
- **"User wants to deploy before /review passes"**: Decline. State: "Matilha requires /review to pass before /den. To override, set `force_deploy_without_review: true` in project-status.md with documented justification."
- **"Archetype is 'cli' but user wants server infra"**: Ask: is this a CLI tool that also has a backend API? If yes, update archetype to `cli-with-api` and apply saas defaults. Log the decision.
- **"CI/CD environment variables not set up in target platform"**: Generate a checklist of required env vars from the Dockerfile and CI/CD workflow. User must set them in the platform dashboard before the first deploy.

<!-- MATILHA_MANAGED_END -->
