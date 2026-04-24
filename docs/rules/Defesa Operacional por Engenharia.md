---
title: Defesa Operacional por Engenharia
date: 2026-04-23
version: 1.0
alwaysApply: false
---

## Princípios Fundamentais

**DEFESA NÃO É PRODUTO FINAL (WAF, FIREWALL, SIEM MÁGICO). É PRÁTICA CONTÍNUA DE ENGENHARIA — RATE LIMIT, ENCRYPTION, VALIDATION, MONITORING.**

Comprar WAF não substitui validar input. Contratar SIEM não substitui
emitir eventos de segurança. Ligar Shield não substitui rate limit
por user. Produtos de segurança são camadas que amplificam boa
engenharia; eles não a substituem. Sistema com engenharia ruim e
WAF na frente é sistema comprometível com passo extra.

As primitivas que importam no dia-a-dia são poucas:

- **Rate limiting** — controle de volume por dimensão (IP, user,
  endpoint, token).
- **Encryption** — TLS em trânsito, AES at rest, KMS pra chaves.
- **Input validation** — todo payload que cruza boundary é hostil
  até validado.
- **Authentication + Authorization separados** — quem é? vs. pode
  fazer?
- **Security events + alerting** — falhas visíveis em tempo real,
  não em relatório mensal.

Cada uma é barata de implementar bem e cara de implementar mal.
O ganho vem de fazer as cinco, sempre, em todo lugar que importa.

### Regras Fundamentais

1. **Rate limit é defesa primária, não otimização tardia**
   - Todo endpoint público tem rate limit, no mínimo por IP.
     Endpoints autenticados têm rate limit adicional por user.
     Endpoints caros (LLM, email, SMS) têm rate limit agressivo
     específico.
   - Fail-closed: se o rate limiter (Redis, etc.) está fora do ar,
     **bloqueie** (ou degrade, nunca "libere tudo"). "Fail-open
     pra não interromper serviço" = "desligue a defesa quando
     alguém começar a atacar a defesa".
   - Rate limit sem observabilidade é decoração. Métricas: rate de
     limit atingido, top offenders, distribuição temporal. Padrão
     de ataque fica visível.

2. **Encryption não-negociável em trânsito e em repouso**
   - TLS 1.3 em trânsito. AWS ACM managed certificates em CloudFront
     / ALB / API Gateway — zero motivo pra gerenciar cert manualmente
     em 2026. HSTS ligado, HTTP redireciona pra HTTPS.
   - AES-256 em repouso. S3 SSE-S3 ou SSE-KMS, RDS com encryption
     habilitada na criação (não dá pra adicionar depois sem
     migration), DynamoDB com encryption default. EBS com encryption
     default por conta/região.
   - Custo: negligível. Risco sem: significativo (um backup vazado
     sem encryption é todo o DB vazado).

3. **Input validation no backend é segurança; no frontend é UX**
   - Validação de frontend serve pra feedback rápido ao user. Backend
     **tem que revalidar tudo**, sempre, assumindo que o frontend foi
     bypassado (Postman, curl, cliente malicioso).
   - Toda request valida: tipo (number, string, array), formato
     (regex, enum), range (min/max), tamanho (evita DoS por payload
     gigante), presença de campos obrigatórios.
   - Ferramenta: schema validation declarativo (Zod, Pydantic, Ajv,
     JSON Schema). Valida no boundary do handler, antes de qualquer
     lógica de domínio. Payload inválido → 400 com erro estruturado,
     nunca chega à regra de negócio.

4. **Authentication e Authorization são camadas separadas**
   - **Authentication** (quem é?): JWT validation, OAuth flow, API
     key lookup. Produz identidade verificada.
   - **Authorization** (pode fazer?): middleware ou decorator
     explícito antes de cada rota/comando — checa se a identidade
     tem permissão pra aquela ação/recurso.
   - Anti-padrão: authz espalhada na regra de domínio (`if user.role
     === 'admin'` em 40 lugares diferentes). Em 6 meses uma rota
     esqueceu o check. Isole em camada auditável.

5. **Security events são alertas em tempo real, não linha de log**
   - Eventos que geram alerta imediato (PagerDuty, Slack #incidents):
     - Múltiplos logins falhados do mesmo IP/user
     - Rate limit explodindo (pico anormal de bloqueios)
     - IAM activity incomum (novo role criado, policy expandida)
     - Secret scanner falhou no CI (secret prestes a ser commitado)
     - WAF bloqueou padrão novo em volume alto
   - Relatório mensal é para análise de tendência, não para detecção.
     Se você descobre comprometimento em relatório mensal, já se
     passaram semanas.

### Camadas de defesa — ordem importa

```
Internet
   ↓
CloudFront/CDN (WAF nativo, rate limit geográfico)
   ↓
ALB/API Gateway (TLS termination, rate limit por IP)
   ↓
Backend (authentication → authorization → validation → domínio)
   ↓
Database (encryption at rest, IAM auth, network isolation)
```

Cada camada assume a anterior como possivelmente comprometida. "Só
o WAF protege" é arquitetura com ponto único de falha por design.

## Padrões na Prática

### Rate limiting multinível

```
// Nível 1: global per-IP (anti-bot/DDoS simples)
// Implementado em CloudFront/API Gateway
// Limit: 1000 req/min/IP

// Nível 2: per-user autenticado (anti-abuse)
// Token bucket no Redis
await userRateLimiter.consume(userId, { points: 1, duration: 60 });
// Limit: 300 req/min/user

// Nível 3: per-endpoint caro (LLM, email, SMS)
await llmRateLimiter.consume(userId, { points: 1, duration: 3600 });
// Limit: 50 req/hora/user em endpoint LLM

// Falha do Redis → fail-closed
try {
  await rateLimiter.consume(key);
} catch (err) {
  if (err.name === "RedisConnectionError") {
    metrics.emit("ratelimit.infra_failure");
    throw new ServiceUnavailableError("rate limiter unavailable");
    // nunca return next() aqui
  }
  throw err;
}
```

### Encryption — defaults corretos em IaC

```
// Terraform — RDS com encryption obrigatória
resource "aws_db_instance" "main" {
  storage_encrypted = true          // não default; sempre explícito
  kms_key_id        = aws_kms_key.rds.arn
  # ...
}

// S3 bucket encryption default
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.uploads.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
  }
}

// ALB — só TLS 1.3, redirect HTTP → HTTPS
resource "aws_lb_listener" "https" {
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  # ...
}
```

Checklist de boundary compliance automatizado (AWS Config rules,
tfsec, checkov): qualquer recurso novo sem encryption falha o CI.

### Input validation no boundary

```
// Zod schema declarativo
const CreateOrderSchema = z.object({
  items: z.array(z.object({
    product_id: z.string().uuid(),
    quantity: z.number().int().min(1).max(100),
  })).min(1).max(50),
  notes: z.string().max(500).optional(),
  shipping_address_id: z.string().uuid(),
});

// Middleware — valida antes da lógica
app.post("/api/orders",
  authenticate,
  authorize("orders.create"),
  validate(CreateOrderSchema),
  async (req, res) => {
    // req.body é tipado e validado; lógica de domínio não se
    // preocupa com forma do input
    const order = await createOrder(req.user, req.body);
    res.json(order);
  }
);
```

Validação cobre 3 dimensões:
- **Forma**: tipo, presença, formato
- **Range**: tamanhos, limites numéricos, enums
- **Semântica**: UUID existe? produto ativo? (geralmente aqui entra
  na lógica de domínio, mas também pode estar em middleware)

### Authorization como middleware isolado

```
// ❌ Authz espalhada no domínio
async function updateOrder(user, orderId, data) {
  const order = await db.orders.find(orderId);
  if (user.role !== "admin" && order.user_id !== user.id) {
    throw new ForbiddenError();
  }
  // ... 200 linhas de domínio
}
// Em 6 meses: nova rota `duplicateOrder()` esqueceu esse check.

// ✅ Middleware explícito
app.patch("/api/orders/:id",
  authenticate,
  authorize(async (req) => {
    const order = await db.orders.find(req.params.id);
    return req.user.role === "admin" || order.user_id === req.user.id;
  }),
  async (req, res) => { /* ... */ }
);

// ou: CASL / Oso / Cedar com policies declarativas
const ability = defineAbilityFor(user);
if (!ability.can("update", order)) throw new ForbiddenError();
```

Authz declarativa fica auditável: "quem pode fazer o quê" em um
arquivo, não espalhado.

### Monitoring de eventos de segurança

```
// Emissão
await securityEvents.emit({
  type: "login_failed",
  user_id: userId,
  ip: req.ip,
  reason: "invalid_password",
  ts: new Date(),
});

// Alertas associados (CloudWatch / Datadog)
// - 5+ login_failed do mesmo IP em 1 min → alerta
// - 3+ login_failed do mesmo user em 5 min → alerta + lock temporário
// - pico de rate_limit_exceeded em endpoint novo → alerta
// - IAM CreateRole ou AttachPolicy em prod fora de janela de deploy →
//   alerta crítico
```

## Sinais de Alerta

### Rate limit ausente ou fraco:

- Endpoint público (signup, login, password reset, contact form)
  sem rate limit. Vai virar vetor de abuse em dias.
- Endpoint LLM sem rate limit por user. Custo vira vetor de DoS.
- Rate limit só por IP em SaaS — user autenticado abusivo
  consegue múltiplos accounts, múltiplos IPs, e escapa. Precisa
  de limit por user ID também.
- Rate limiter fail-open por design. Redis down = sistema sem
  defesa, atacante explora a janela.

### Encryption incompleta:

- DB sem encryption at rest. Snapshot vazado = vazamento total.
- Backups sem encryption. Backup geralmente mora em bucket separado,
  com retenção maior, menos monitorado — paraíso pra quem pegar
  acesso.
- TLS 1.0/1.1 ainda aceito "pra compatibilidade". Em 2026, zero
  justificativa.
- Keys KMS compartilhadas entre ambientes (dev/staging/prod com
  mesma key). Comprometimento em dev = comprometimento em prod.

### Validação só no frontend:

- "Confio no payload porque o frontend valida" — Postman/curl
  contornam em 10 segundos.
- Payload aceito sem schema: `req.body.whatever` usado direto
  no DB. SQLi, NoSQLi, ou corrupção de dados esperando acontecer.
- Tamanhos não validados. Payload de 50MB derruba worker. `notes`
  field sem limit vira storage ilimitado por user.
- Validação existe mas inconsistente entre endpoints. Um caminho
  valida, outro não — atacante procura o não.

### Authorization descentralizada:

- `if user.role === 'admin'` em 20+ lugares diferentes. Impossível
  auditar "quem pode fazer X".
- Authz dentro da query SQL (`WHERE user_id = ?`) sem camada
  explícita acima — comprometimento do SQL = bypass total.
- Role hardcoded em frontend ("se role=admin mostra botão"). Se
  botão só existe no frontend, endpoint é acessível por qualquer
  um com HTTP client. Authz tem que estar no backend.

### Eventos de segurança invisíveis:

- Login falhado loga só no application log, sem alerta. Brute
  force acontece por dias sem ninguém notar.
- IAM changes em produção sem alerta. Atacante com acesso a
  console cria role backdoor; descoberta vem semanas depois.
- Secret scanner existe mas não bloqueia CI. Secret vaza em
  commit, fica público, ninguém rotaciona.
- Dashboards de segurança que ninguém olha. "Temos o dashboard" =
  não temos monitoring, temos decoração.

### Teste de fumaça

Para cada endpoint de produção, responda:
1. Qual é o rate limit (por IP e por user)?
2. Quais eventos de segurança ele emite, e qual o destino de
   alerta?
3. O payload é validado contra schema declarativo antes do
   domínio?
4. Authz é middleware explícito ou está espalhada?

Para o sistema como um todo:
5. Onde há PII, está encrypted at rest? TLS obrigatório em trânsito?
6. Se o rate limiter cair, o sistema fail-closes ou fail-opens?
7. Último drill de incidente (alerta → ack → mitigation) foi quando?

Respostas concretas em todas = defesa operacional funcionando. "Acho
que sim" em qualquer = risco não-gerenciado.

## Conexões

- Secrets + IAM como base de tudo: `Trust Boundary e Secret Management.md`
- Rate limit específico pra LLM cost: `LLM-Specific Operational Risks.md`
- PII exigindo encryption + audit: `PII e LGPD na Prática.md`
- Sysdesign-pack: `sysdesign-rate-limiting-strategies` cobre algoritmos;
  esta regra foca em rate limit como primitiva de defesa em camadas.
