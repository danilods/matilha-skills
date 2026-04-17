---
type: methodology
phase: "60"
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: skeleton
maturity: v1
created: 2026-04-16
updated: 2026-04-17
tags: [methodology, deploy, infra, cicd, devops]
author: matilha
license: MIT
---

# 60 — Deploy e infraestrutura

> [!abstract] TL;DR
> Docker Compose local reflete prod. Esteira MVP: **Digital Ocean droplet + Docker Compose + Vercel (frontend) + Cloudflare (DNS/SSL/CDN) + GitHub Actions**. Para escala real: EKS/GKE + ArgoCD + ECR + observabilidade completa.
>
> **Status: `skeleton`** — esteira DO consolidada em 4 MVPs do brain-dump; fluency mostra caminho EKS. Upgrade para `deep` com ADR comparando os dois padrões e template de GitHub Actions por arquétipo.

## Quando esta fase se aplica

- Stack definida (fase 20) inclui Docker Compose local.
- Código passa quality gates (fase 50).
- Há um ambiente de destino definido (droplet, EKS, serverless, etc.).

## Gates de entrada (binários)

- [ ] Docker Compose local funciona (todos os serviços sobem, healthchecks verdes)
- [ ] `.env.example` completo; `.env` real **não** commitado
- [ ] Quality gates passam em CI (lint + typecheck + testes + coverage)
- [ ] Ambiente de destino escolhido com justificativa (arquétipo + RNFs)
- [ ] Domínio comprado ou decisão de usar subdomínio de plataforma

## Gates de saída (binários)

- [ ] Deploy automatizado via CI (GitHub Actions ou equivalente) — push → staging → prod com gates
- [ ] SSL funcionando end-to-end (Cloudflare + certificado válido)
- [ ] Healthcheck endpoint exposto e monitorado
- [ ] Logs centralizados (stdout dos containers coletados)
- [ ] Rollback documentado e testado (reverter para versão anterior em <5min)
- [ ] Backup de dados configurado (pg_dump automático, ou equivalente para seu DB)
- [ ] Observability mínimo: Sentry para erros + métricas de infra + dashboard básico
- [ ] Zero credencial hardcoded — tudo via `.env` / secrets manager
- [ ] Documentação de deploy em `docs/deploy/` ou equivalente (como deployar manualmente se CI falhar)

**Como materializar cada etapa em cada ferramenta:** CI/CD geralmente agnóstico, mas templates variam por plataforma.

## ═══ BLOCO DENSO ═══

### Checklist operacional

- [ ] Domínio delegado à Cloudflare (ou equivalente) para SSL + DDoS
- [ ] Subdomínios apontando para IPs dos serviços (droplet) ou load balancer (EKS)
- [ ] Docker Compose de produção separado do dev (`docker-compose.prod.yml`)
- [ ] Healthcheck em cada serviço crítico
- [ ] Secrets via env vars no servidor, não no compose
- [ ] Volumes nomeados para dados persistentes (Postgres data, uploads)
- [ ] NGINX (ou equivalente) como reverse proxy + WebSocket upgrade quando necessário
- [ ] pg_dump agendado + upload para S3 (ou equivalente)
- [ ] GitHub Actions workflow: checkout → test → build → ssh deploy → healthcheck
- [ ] Rollback: tag da versão anterior mantida no registry + script `deploy-rollback.sh`
- [ ] Sentry conectado (erros em prod chegam no Slack/Discord)
- [ ] Logs dos containers agregados (stdout → arquivo rotativo ou serviço de logs)

### Regras invioláveis

1. **Docker Compose de prod reflete dev.** Mesmos serviços, versões fixadas, healthchecks. Diferenças mínimas (ex: volumes, replicas).
2. **Secrets nunca no repo.** Nem em `.env.example`, nem em commits apagados. Use `.env` local + secrets manager / env vars no servidor.
3. **Deploy automatizado desde o dia 1.** Deploy manual vira hábito que esconde bugs. Scripts podem ser simples (ssh + docker-compose up), mas automatizados.
4. **SSL/TLS obrigatório.** Cloudflare free tier cobre MVP. Sem SSL em prod é negligência.
5. **Rollback testado é pré-requisito de deploy.** "Se quebrar, volto" só funciona se você já voltou em simulação.

### Árvore de decisão — onde deployar?

```
Qual é o arquétipo do projeto?
│
├── MVP rápido (<4 semanas, validação)
│   ├── Backend: Digital Ocean droplet + Docker Compose
│   ├── Frontend: Vercel (repo separado, deploy automático)
│   ├── DNS/SSL/CDN: Cloudflare (free)
│   ├── CI/CD: GitHub Actions → SSH deploy
│   └── Monitoring: Sentry free + logs rotativos
│
├── SaaS em crescimento (tem usuários pagando, precisa SLA)
│   ├── Backend: Managed (DO App Platform, Railway, Fly.io) OU droplet com auto-deploy
│   ├── DB: Managed (DO Managed Postgres, Supabase, Neon)
│   ├── Observability: Sentry + Better Stack / Grafana Cloud
│   └── CI/CD: GitHub Actions → Managed deploy hooks
│
├── Produto com escala planejada (>10k usuários, multi-serviço)
│   ├── Backend: EKS / GKE
│   ├── DB: Aurora Postgres / Cloud SQL
│   ├── LLM obs: Langfuse self-hosted ou cloud
│   ├── Service mesh opcional (Linkerd, Istio) se >5 serviços
│   ├── CI/CD: GitHub Actions → ECR → ArgoCD (GitOps)
│   └── Observability: OpenTelemetry + Prometheus + Grafana
│
└── Institucional (on-premise ou cloud do cliente)
    ├── Respeitar stack do cliente (k8s, OpenShift, on-premise VM, etc.)
    ├── Foco: reproduzir ambiente local via Docker Compose
    └── Deploy: scripts adaptados ao ambiente do cliente
```

### Defaults e anti-padrões

**Defaults (esteira DO — MVP):**
- Cloud: Digital Ocean (droplet Ubuntu 22.04, 2-4GB RAM inicial).
- Frontend: Vercel (vinculado ao repo).
- DNS: Registro.BR → delegado à Cloudflare.
- SSL: Cloudflare Full (strict).
- CI/CD: GitHub Actions com secrets para SSH key.
- Dumps de dados via SCP (GitHub Actions tem limite de tamanho).

**Defaults (esteira EKS — escala):**
- Cloud: AWS ou GCP.
- Kubernetes managed (EKS/GKE).
- Registry: ECR/GCR.
- Deploy: ArgoCD (GitOps).
- LLM obs: Langfuse self-hosted on-cluster.
- Multi-env: DEV + Staging + PRD.

**Anti-padrões:**
- ❌ Kubernetes em MVP. Custo operacional mata velocidade.
- ❌ Deploy manual recorrente. Todo hotfix vira "lembrar de fazer X" e vai esquecer.
- ❌ Secrets no compose.yml versionado. Vaze uma vez = comprometido para sempre.
- ❌ Sem backup automático de DB. Perda de dados é quando, não se.
- ❌ Subir em prod sem healthcheck. Down silencioso = perda de dinheiro.
- ❌ `latest` tag em imagens de prod. Versão imutável por commit SHA ou tag semver.

### Decisões de juízo (não-templatizáveis)

- **Quando migrar de DO droplet para EKS.** Sinais: >3 serviços escalando independentemente; pico de tráfego exige auto-scaling; compliance exige certificação cloud. **Não migre** por "ficar profissional".
- **Managed vs self-hosted DB.** Managed: custo maior, menos controle, zero ops. Self-hosted: controle total, ops recorrente. MVP → managed. Time com ops → self-hosted.
- **Observability level.** Mínimo: Sentry + logs. Escala: + métricas + traces + dashboards. Exagero: Datadog em MVP. Calibre pelo custo de ir cego em prod.

## ═══ NARRATIVA ═══

### Racional

A esteira DO consolidada do brain-dump (droplet + compose + Vercel + Cloudflare + GH Actions) é o padrão **"MVP que se paga"** — custo mensal ~$20-40 até ter usuários reais. Não compromete futuro: migrar para EKS depois é possível porque a stack já é containerizada.

Cloudflare free tier entrega SSL + CDN + DDoS basic sem custo adicional. Delegar DNS do Registro.BR para Cloudflare também adiciona camada de proteção ao domínio.

### Exemplo real — placeholder (skeleton)

> [!todo] Calibração pendente
> Candidatos: **adedonha** (DO + GitHub Actions + Docker Compose + Cloudflare — perfeito exemplo da esteira MVP) e **fluency** (AWS EKS + ECR + ArgoCD + Langfuse + Aurora — exemplo da esteira de escala). Upgrade para `deep` comparando os dois via ADR.

### Armadilhas comuns

- **Premature Kubernetes.** Time gasta 2 semanas aprendendo k8s em MVP que vale 3 semanas de lifetime. Custo de oportunidade brutal.
- **DNS propagation.** Achar que "funcionou" 5min depois de criar o registro e esquecer que TTL demora. Sempre dê 1h antes de assumir que DNS está errado.
- **SSL "funcionando" mas com mixed content.** Certificado válido, mas página puxa recurso HTTP — browsers bloqueiam. Inspect + corrigir.
- **Sem backup automático.** Fazer dump manual "quando lembrar". Defina cron ou GitHub Actions scheduled workflow.

## Links

- Fase anterior: [50-qualidade-testes](./50-qualidade-testes.md)
- Fase seguinte: [70-onboarding-time](./70-onboarding-time.md) (quando time entra)
- Princípios: [principios-transversais](./principios-transversais.md)
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- Conceitos embasadores: [nfr-system-design](../concepts/nfr-system-design.md), [common-services](../concepts/common-services.md)
- Raw: 2026-04-15-danilo-brain-dump
