# matilha-security-pack (Wave 5i) — proposed skill inventory

**Caminho C** (opinions-from-practice) scoped to **AI-software operational security**. NOT OWASP/STRIDE formal threat modeling — that's for a future `sec-*` literature-based pack. Prefix here: `swsec-*`. Category: `swsec`.

## Scope (Danilo's brief + additions)

Danilo's original framing:
- Key exposure prevention
- Backend security responsibility (trust boundary)
- Frontend = consult and render only (no business logic / no secrets)
- Outras sugestões

My additions (LLM-era specific risks that the other packs don't cover):
- Prompt injection defense
- Output sanitization (HTML/SQL/shell injection via LLM-generated content)
- Cost governance as security (runaway LLM spend = availability risk)
- PII minimization in LLM context (don't send more than necessary to models)
- Secrets in prompts (model gets exfil vector)

## Proposed 13 skills in 5 families

### Family 1 — Trust boundary + key protection (3 skills)

| Skill | Triggering intent | Key principle |
|---|---|---|
| `swsec-secrets-never-in-frontend` | "Frontend chamando API direto com key?" / "Pode commitar essa .env?" | Nenhuma API key, token ou secret no cliente. Tudo via backend proxy. Browser é território hostil. |
| `swsec-secrets-manager-discipline` | "Onde guardo essa key?" / "Como rotacionar?" | AWS Secrets Manager (ou equivalente) > env vars > arquivo. Rotação automática + least-privilege IAM. |
| `swsec-iam-least-privilege` | "Essa Lambda precisa dessa permission?" / "Role muito aberta" | Cada Lambda/serviço tem IAM role dedicada com permission mínima. Start restrictive; expand com evidence. |

### Family 2 — Backend-only responsibility (3 skills)

| Skill | Triggering intent | Key principle |
|---|---|---|
| `swsec-frontend-consult-render-only` | "Lógica de autorização no frontend?" / "Frontend checando role?" | Frontend consulta e renderiza. Não valida, não autoriza, não calcula preço. Backend é única fonte de verdade. |
| `swsec-backend-input-validation` | "Esse payload veio validado do frontend" / "Confio nesse input" | Todo input que cruza boundary é hostil até validado no backend. Validação do frontend é UX, não segurança. |
| `swsec-backend-authorization-layer` | "Como checo permissão?" / "Middleware de auth" | Authorization é camada explícita antes da lógica de domínio. "Quem pode fazer o quê" fica isolado, auditável. |

### Family 3 — LLM-specific risks (3 skills)

| Skill | Triggering intent | Key principle |
|---|---|---|
| `swsec-prompt-injection-defense` | "User input vira parte do prompt?" / "Como prevenir jailbreak?" | Separe system prompt de user content via delimiters + structure. Tratar user input como data, nunca como instruction. |
| `swsec-llm-output-sanitization` | "LLM gera HTML/SQL/código?" / "Render direto o que veio do modelo?" | Output do LLM é input-não-confiável. Sanitize antes de render (XSS), antes de query (SQLi), antes de exec (RCE). |
| `swsec-llm-cost-as-availability` | "Limite de spend?" / "User pode custar $1000/dia?" | Unbounded LLM spend = DoS por conta bancária. Rate limit por user + budget alert + circuit breaker ao atingir ceiling. |

### Family 4 — Data minimization + LGPD (2 skills)

| Skill | Triggering intent | Key principle |
|---|---|---|
| `swsec-pii-minimization-llm` | "Envio dados do user pro modelo?" / "Preciso de todo contexto?" | PII só cruza boundary do modelo quando o task exige. Tokenize, redact, ou sumarize antes. |
| `swsec-lgpd-operational-basics` | "LGPD no projeto" / "Como lido com consent?" | Consent explícito por finalidade, retenção mínima, direito de deleção automatizado, log de acesso a PII. Não é checklist jurídico — é engenharia. |

### Family 5 — Defesa operacional (2 skills)

| Skill | Triggering intent | Key principle |
|---|---|---|
| `swsec-rate-limiting-as-defense` | "Endpoint público pode ser abusado?" / "Prevenção de brute force?" | Rate limiting é linha primária de defesa. Per-IP, per-user, per-endpoint. Fail closed em caso de dúvida. |
| `swsec-encryption-at-rest-and-transit` | "TLS nessa API?" / "Banco criptografado?" | TLS 1.3 em trânsito, AES-256 at rest (S3, RDS, DynamoDB). Não negociável — cost baixo, risco alto sem. |

## Overlap disclosures

- `swsec-rate-limiting-as-defense` **Complementa** `matilha-sysdesign-pack:sysdesign-rate-limiting-strategies` — sysdesign foca em algoritmos e quando escalar (token bucket vs sliding window); swsec foca em rate limit como defesa primária contra abuso + brute force.
- `swsec-llm-cost-as-availability` **Complementa** `matilha-harness-pack:harness-nfrs-as-prompts` — harness trata NFRs como prompts de constraint; swsec trata cost runaway como availability risk específico do LLM.

## Sources

5 novas rules a criar antes do pack wave:

1. `Trust Boundary e Secret Management.md` — Families 1 + 2
2. `LLM-Specific Operational Risks.md` — Family 3
3. `PII e LGPD na Prática.md` — Family 4
4. `Defesa Operacional por Engenharia.md` — Family 5

Rules a serem draftadas por subagent similar ao Session 1 do arch-pack, depois promovidas pra `docs/rules/` da matilha-skills e ao pack repo.

## Effort estimate

Similar ao Wave 5h:
- SP0 rules drafting (new) — 3h (subagent dispatch)
- SP1 scaffold — 2h
- SP2 13 skills (3 parallel dispatches 5+4+4) — 5h
- SP3 validator extension — 3h
- SP4 ship — 3h

**Total: ~16h wall-clock** (same as Wave 5h).

## Differentiation from other packs

| Pack | Audience |
|---|---|
| matilha-sysdesign-pack | "How do distributed systems scale?" — Tan/industry lens |
| matilha-software-arch-pack | "How do I organize code in my Argos-like system?" — practitioner lens |
| matilha-software-eng-pack | "How do I write code day-to-day?" — discipline lens |
| **matilha-security-pack (Wave 5i)** | **"How do I not get pwned while shipping AI software fast?"** — AI-ops practitioner lens |

Pack does NOT claim to replace OWASP/Shostack threat modeling. Claims: practical baseline for AI-assisted software that keeps keys safe, trust boundaries clear, and LLM-specific risks addressed. Honest scope framing in README.
