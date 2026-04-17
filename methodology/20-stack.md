---
type: methodology
phase: "20"
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: deep
maturity: v1
created: 2026-04-15
updated: 2026-04-17
tags: [methodology, stack, architecture]
author: matilha
license: MIT
---

# 20 — Stack Tecnológica

> [!abstract] TL;DR
> Transforma RNFs do PRD em decisões de tecnologia concretas. Brainstorm de stack usa raciocínio + busca web + MCPs atualizados + deep research para identificar gaps. A stack deve refletir o ambiente real localmente via Docker Compose.

## Quando esta fase se aplica

- PRD aprovado (fase 10 concluída) com RNFs explícitos.
- Sem RNFs → volte à fase 10. Escolher stack sem saber latência, escala e disponibilidade desejadas é chute.

## Gates de entrada (binários — não avance sem atender)

- [ ] PRD completo aprovado (fase 10 concluída)
- [ ] RNFs explícitos cobrindo latência, disponibilidade, escalabilidade, segurança, performance
- [ ] Restrições declaradas: budget, expertise do time, providers já contratados, compliance

Sem RNFs, qualquer escolha de stack é chute. Volte à fase 10.

## Gates de saída (binários — só passe adiante quando todos estiverem atendidos)

- [ ] **CLAUDE.md / AGENTS.md slim (≤150 linhas)** — contém APENAS: stack TABLE, princípios de engenharia, quality guardrails, segurança, convenções, PONTEIROS para docs detalhados. NÃO coloque docker-compose config, deploy details, tutorials aqui.
- [ ] **`docs/architecture.md`** (ou `ARCHITECTURE.md`) — docker-compose structure, diagrama de serviços, deployment topology, ADRs detalhados. Referenciado pelo CLAUDE.md, NÃO embutido nele.
- [ ] Stack table no CLAUDE.md: componente → tecnologia → versão → justificativa
- [ ] Cada escolha aponta para o RNF que endereça (rastreabilidade)
- [ ] Docker Compose local espelha prod (mesmos serviços, mesmas networks) — config vive no compose file + `docs/architecture.md`, NÃO no CLAUDE.md
- [ ] `.env.example` criado com todas as variáveis documentadas; `.env` real **não** commitado
- [ ] Versões fixadas (não `latest` em prod)
- [ ] Ambientes definidos (dev + staging + prod, ou subconjunto justificado)
- [ ] ADR por decisão não-óbvia — em `docs/architecture.md` ou `docs/decisions/`
- [ ] Observability mínimo definido (ou deferimento explícito com razão)

**Estrutura de docs recomendada** (padrão [agent-centric-codebase](../concepts/agent-centric-codebase.md)):

```
CLAUDE.md (~100-150 linhas, índice + regras)
docs/
├── architecture.md           ← docker-compose, serviços, diagrama
├── PRD-<produto>.md          ← requisitos
├── plans/                    ← planos de execução, wave-status
├── decisions/                ← ADRs por decisão
└── references/               ← llms.txt de deps, docs de stack
```

**Como executar as decisões de stack em cada ferramenta:** ver [materializacoes](./materializacoes.md) (ação "Criar skills/agents/hooks" e ação "Escrever spec/PRD" para ADRs).

## ═══ BLOCO DENSO (acionável) ═══

### Checklist operacional

- [ ] RNFs foram consultados para cada decisão de stack? (ex: "PostgreSQL por causa de RNF-003 consistency")
- [ ] Cada componente tem justificativa ("por que X e não Y")
- [ ] Docker Compose local espelha prod (mesmos serviços, mesmas networks, variáveis de ambiente via `.env`)
- [ ] `.env.example` criado com todas as variáveis documentadas
- [ ] Ambientes definidos: dev + staging + prod (ou subconjunto adequado)
- [ ] Stack do frontend decidida separadamente (monorepo ou repo separado + Vercel/etc.)
- [ ] Package manager declarado (uv para Python, pnpm/npm para Node)
- [ ] Versões fixadas (não `latest` em prod)
- [ ] Observability mínimo definido: logs + métricas + traces (ou decisão explícita de deferimento)
- [ ] ADR escrito para cada decisão polêmica (ex: "Cognee sim, Graphiti não")

### Regras invioláveis

1. **Docker Compose reflete prod localmente.** Não aceite "funciona na minha máquina" com serviços faltando. Se prod tem Redis, dev tem Redis.
2. **Nunca lock em um único LLM provider.** Use abstrações (pydantic-ai, LiteLLM, configs YAML) para trocar sem reescrever domínio.
3. **Stack declarada no CLAUDE.md do projeto.** Tabela (componente|tecnologia|versão) é obrigatória. É a referência que todo agente lê primeiro.
4. **Decisão ≠ opinião.** Cada escolha de stack deve apontar para: RNF que endereça, trade-off aceito, e alternativa considerada.

### Árvore de decisão — arquétipos de stack

```
Qual é o arquétipo do projeto?
│
├── MVP rápido (< 4 semanas, validação de mercado)
│   ├── Backend: FastAPI (Python) ou Express (Node) — o que o dev principal domina
│   ├── Frontend: Next.js + Vercel ou Vite+React no Vercel
│   ├── DB: PostgreSQL (único) + Redis (cache/sessions se necessário)
│   ├── Infra: Digital Ocean droplet + Docker Compose
│   ├── CI/CD: GitHub Actions → Docker → SSH deploy
│   ├── DNS/SSL: Cloudflare (free tier) + Registro.BR
│   └── Monitoring: Sentry (free tier) + logs no container
│
├── SaaS produto próprio (escala planejada, recorrência)
│   ├── Backend: FastAPI + SQLModel + uv (Python moderno, type-safe)
│   ├── Frontend: Next.js/React + Vercel (ou repo separado)
│   ├── DB: PostgreSQL (Aurora se AWS, Managed se DO) + Redis (cache + pub/sub + queues)
│   ├── AI: LangGraph para orquestração + pydantic-ai para chamadas LLM (multi-provider)
│   ├── Memory: Cognee + FalkorDB (graph) + Qdrant (vector)
│   ├── Infra: AWS (EKS) ou DO (droplet + managed DB)
│   ├── CI/CD: GitHub Actions → ECR/Docker → ArgoCD ou SSH
│   ├── Observability: Langfuse (LLM) + Prometheus+Grafana (infra) + Sentry
│   └── Testes: pytest + testcontainers + coverage >80%
│
├── Multi-agent com voz / tempo real
│   ├── Tudo do SaaS +
│   ├── STT: Deepgram Nova-3 (streaming) + Groq Whisper Turbo (batch)
│   ├── TTS: ElevenLabs (primary, clone de voz) + fallback Azure/Google
│   ├── Voice realtime: Gemini Live API ou OpenAI Realtime API + VAD
│   ├── WhatsApp: WhatsApp Business API + webhook handler dedicado
│   └── Latência: circuit breaker em todo provider de voz, fallback chain
│
└── Projeto institucional (compliance, legado, segurança elevada)
    ├── Stack do cliente (respeitar decisões já tomadas)
    ├── Foco: integração com sistemas existentes (FHIR, HL7, APIs proprietárias)
    ├── Segurança: RBAC, audit trail, criptografia at-rest/in-transit
    └── Deployment: on-premise ou cloud do cliente (não sua infra)
```

### Defaults e anti-padrões

**Defaults (v1, 2026):**

| Componente | Default | Por que |
|---|---|---|
| Linguagem | Python 3.13 | Ecossistema AI/LLM maduro, FastAPI, tipagem, uv |
| Framework | FastAPI + SQLModel | Async, type-safe, OpenAPI, SQLAlchemy 2.0 embaixo |
| Package manager | uv | 10-100× mais rápido que pip/poetry, lockfile |
| DB relacional | PostgreSQL 16-17 | Maturidade, JSON, full-text, extensões |
| Cache/Queue | Redis (Valkey 7.2) | Pub/Sub, Streams, cache, sessions |
| LLM orchestration | LangGraph 1.0 | Checkpoints nativos, state machine explícita |
| LLM calls | pydantic-ai | Multi-provider, typed, testável |
| Knowledge graph | Cognee + FalkorDB | GraphRAG sem lock em Neo4j |
| Vector DB | Qdrant | Open-source, performance, gRPC |
| Observability LLM | Langfuse | Self-hosted possível, traces de LLM |
| TTS primary | ElevenLabs | Qualidade, clonagem, multi-idioma |
| STT streaming | Deepgram Nova-3 | Latência, accuracy em PT-BR |
| STT batch | Groq Whisper Turbo | Velocidade em transcrição offline |
| Frontend | React + Vite + TypeScript | Ecossistema, velocidade de build |
| Mobile | Flutter (se necessário) | Cross-platform, Dart type-safe |
| DNS/SSL | Cloudflare (free) | DDoS, CDN, SSL automático |
| Container | Docker + Compose (dev) | Paridade com prod |
| CI/CD | GitHub Actions | Integrado ao repo |

**Anti-padrões:**
- ❌ "Vamos usar Kubernetes desde o dia 1." K8s é para >5 serviços em escala real. MVPs usam Docker Compose.
- ❌ "Vamos usar MongoDB porque é fácil." PostgreSQL faz tudo que Mongo faz + transações reais + JSON nativo.
- ❌ Stack escolhida por hype, não por RNF. Se o RNF não exige streaming STT, não escolha Deepgram — Whisper batch basta.
- ❌ Provider único de LLM hardcoded. Amanhã o preço muda, a latência sobe, ou o modelo degrada. Abstração desde o dia 0.
- ❌ `.env` commitado no repo (credenciais expostas). `.env.example` sim, `.env` nunca.

### Decisões de juízo (não-templatizáveis)

- **"Tecnologias chatas" ganham em contexto agent-centric.** APIs estáveis, composição clara, forte representação no training set dos modelos. Em alguns casos, reimplementar subset é mais barato do que contornar biblioteca opaca. Ver [agent-centric-codebase](../concepts/agent-centric-codebase.md) seção "Tecnologias chatas". Exemplo da OpenAI: em vez de `p-limit` genérico, implementaram helper próprio com instrumentação OTel + 100% coverage + comportamento previsível. Ponderação: evite over-engineering, mas prefira o estável ao cutting-edge quando não há RNF exigindo.
- **Managed vs self-hosted.** Managed DB custa mais e dá menos controle. Self-hosted exige ops. Decisão depende de: (a) time tem ops? (b) SLA de uptime necessário? (c) budget? Regra de bolso: MVP → managed. Escala com ops → self-hosted.
- **Quando migrar de Digital Ocean para AWS/EKS.** Sinais: >3 serviços que escalam independentemente, necessidade de auto-scaling, compliance que exige certificação do cloud provider. NÃO migre porque "é mais profissional".
- **Graph DB vs embeddings-only.** Se o domínio tem relações semânticas ricas (médico → especialidade → procedimento → paciente → medicamento), graph compensa. Se é busca por similaridade pura (FAQ), vector-only basta.
- **Monorepo vs multi-repo.** Monorepo para <3 serviços ou quando time é 1-3 pessoas. Multi-repo para serviços que evoluem em velocidades diferentes ou quando times diferentes trabalham simultaneamente (ex: Gravicode com 4 repos).
- **Latência aceitável em voice AI.** <3s end-to-end para feel "responsivo". <1.5s para feel "instantâneo". Se STT + LLM + TTS somam >3s, precisa de streaming parcial (TTS começa antes do LLM terminar). Essa arquitetura é 3× mais complexa — só adote se o RNF exigir.

## ═══ NARRATIVA ═══

### Racional

A stack não é "o que eu sei usar" — é "o que os RNFs exigem que eu use". A árvore de decisão por arquétipo existe porque projetos de arquétipos diferentes exigem stacks fundamentalmente diferentes. Um MVP de validação não precisa de Kubernetes. Um sistema multi-agent com voz precisa de circuit breakers e fallback chains.

A regra "Docker Compose reflete prod" resolve o anti-padrão mais caro: "funciona local, quebra em deploy". Se localmente você tem API + PostgreSQL + Redis e no deploy descobre que precisa de um serviço de jobs que nunca testou localmente, isso é dias de debug evitável.

A tabela de stack no CLAUDE.md não é documentação — é a interface de leitura para todos os agentes. Sem ela, cada agente descobre a stack por tentativa e erro nos imports do código. Ver [common-services](../concepts/common-services.md) para padrões de comunicação entre serviços e [nfr-system-design](../concepts/nfr-system-design.md) para trade-offs de escalabilidade e disponibilidade.

### Exemplo real — fluency

A tabela de stack do CLAUDE.md de fluency é o melhor exemplo da metodologia em ação:
- 22 linhas cobrindo de linguagem a linting.
- Versões específicas declaradas (`Python 3.13`, `Valkey 7.2`, `PostgreSQL Aurora 17`).
- Alternativas registradas: "Cognee + FalkorDB (NOT Graphiti — definitively rejected)" — ADR implícito em uma linha.
- "pydantic-ai hybrid (CRITICAL): NEVER lock to one LLM" — regra de stack com justificativa inline.
- 7 serviços: whatsapp-gateway, ai-engine, voice-gateway, cognee-worker, proactivity-scheduler, admin-api, tracking-service.
- Deploy avançado: EKS + ArgoCD + ECR + Langfuse self-hosted. Coerente com o arquétipo "SaaS com escala planejada".

### Exemplo real — adedonha (contraste)

A stack de adedonha é 7 linhas no CLAUDE.md:
- Python+FastAPI+SocketIO, React+Vite+TS, Flutter, PostgreSQL 16, Redis 7+, Docker Compose, Cloudflare, DigitalOcean, GitHub Actions.
- Sem Kubernetes, sem managed services além do droplet. Coerente com arquétipo "MVP rápido".
- Deploy pipeline: GitHub Actions → Docker → DigitalOcean via SSH.

A diferença entre os dois demonstra **a árvore de decisão por arquétipo em ação**: mesmo autor, mesma filosofia, stacks radicalmente diferentes porque os RNFs são diferentes.

### Armadilhas comuns

- **Resume-driven development.** Escolher stack para engordar o currículo em vez de resolver o problema. Kubernetes para 2 serviços. Graph DB para dados tabulares.
- **"Depois a gente migra."** Migrar de provider nunca é tão fácil quanto promete. Quanto mais cedo abstrair (pydantic-ai, env vars, interfaces), mais barato trocar depois.
- **Docker Compose incompleto.** Ter API + DB no compose mas não ter Redis/queue/worker = descobrir bugs de integração no deploy. Regra: se está em prod, está no compose.
- **Ignorar voice AI latency budget.** STT (300ms) + LLM (800ms) + TTS (400ms) = 1.5s best case. Adicione network (200ms) + processing (100ms) = 1.8s. Se o RNF pede <1.5s, você precisa de streaming ou edge. Faça a conta ANTES de codificar.

## Links

- Fase anterior: [10-prd](./10-prd.md)
- Fase seguinte: [30-skills-agents](./30-skills-agents.md)
- Princípios: [principios-transversais](./principios-transversais.md)
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- **Agent-centric codebase (tech chata, AGENTS.md como índice):** [agent-centric-codebase](../concepts/agent-centric-codebase.md)
- **Agentic patterns (workflow vs agent afeta stack):** [agentic-patterns](../concepts/agentic-patterns.md)
- Conceitos embasadores: [nfr-system-design](../concepts/nfr-system-design.md), [scaling-databases](../concepts/scaling-databases.md), [common-services](../concepts/common-services.md), [design-cases](../concepts/design-cases.md)
- Raw: 2026-04-15-danilo-brain-dump
