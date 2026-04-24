---
title: Trust Boundary e Secret Management
date: 2026-04-23
version: 1.0
alwaysApply: false
---

## Princípios Fundamentais

**NENHUM SECRET CRUZA A FRONTEIRA DO BROWSER. FRONTEND É CONSUMER PURO; BACKEND É DONO DA CONFIANÇA.**

Browser é território hostil. Qualquer coisa que você enviar pra ele pode
ser inspecionada (DevTools), interceptada (proxy), ou extraída por
extensão maliciosa. "Minificado" não é "escondido". "Variável de ambiente
do build" não é "secret" — se virou JavaScript servido ao cliente, é
público. A única pergunta útil é: o que o frontend precisa saber pra
renderizar? Tudo mais fica no backend.

Secret management não é "onde guardar API key". É **quem tem autoridade
pra falar em nome do sistema**, e como essa autoridade é concedida,
escopada, rotacionada e revogada. API key é só a materialização mais
visível disso.

### Regras Fundamentais

1. **Frontend nunca carrega credencial de serviço externo**
   - Nada de `OPENAI_API_KEY`, `STRIPE_SECRET_KEY`, `AWS_ACCESS_KEY_ID`
     no bundle, no `window.__CONFIG__`, no `NEXT_PUBLIC_*`. Prefixo
     público do framework significa "público de verdade" — revise a
     lista desses prefixos antes de cada deploy.
   - Quando precisar chamar serviço externo, **backend faz proxy**:
     frontend chama `/api/llm/complete`, o backend adiciona a API key
     e repassa pro OpenAI. O user nunca vê a key, nunca consegue
     chamar OpenAI direto com ela.

2. **Secrets vivem em cofre, não em variável de ambiente**
   - Hierarquia de preferência:
     1. **AWS Secrets Manager / GCP Secret Manager / Vault** com
        rotação automática e audit log nativo.
     2. **Parameter Store (SSM)** com `SecureString` + KMS key
        dedicada — aceitável pra secrets de baixo blast radius.
     3. **Variável de ambiente do runtime** (Lambda, ECS task def) —
        aceitável **só** se o valor vem dinamicamente do cofre no
        startup, nunca hardcoded no IaC.
     4. **Arquivo `.env`** — só local/dev. Nunca commitado. Nunca
        em produção.
   - Regra: se tirar o cofre do ar quebra a aplicação inteira, ótimo
     — é sinal de que secrets não estão cacheados em lugar errado.

3. **IAM role por serviço, permission mínima, expansão com evidência**
   - Cada Lambda/ECS task/serviço tem role dedicada. Zero
     compartilhamento "por conveniência".
   - Comece restritivo: role nasce sem permission alguma. Cada
     `Action` adicionada precisa de justificativa (feature ou erro
     concreto de `AccessDenied`). Isso produz histórico auditável
     do porquê cada permission existe.
   - Nunca `"*:*"`, nunca `"s3:*"` em recurso wildcard. Se precisar
     de "todas as actions S3 neste bucket específico", liste: `GetObject`,
     `PutObject`, `DeleteObject`. É verbosidade que paga dividendo
     em blast radius.

4. **Rotação é padrão, não cerimônia**
   - Secret que nunca rotaciona é secret que **vai** vazar em algum
     momento (ex-funcionário, screenshot, commit acidental descoberto
     6 meses depois). Rotação periódica (30-90 dias) limita a janela.
   - Automatize: Secrets Manager com rotação Lambda built-in pra RDS,
     Redis, custom secrets. Zero intervenção humana no ciclo.
   - Tenha runbook testado pra rotação emergencial (<30 min do
     incidente ao secret novo em produção).

### Trust boundary — onde começa e onde termina

A fronteira útil é **payload que cruza a rede**, não "frontend vs
backend lógico". Cada um destes é uma boundary:

- Browser → seu backend (HTTPS público)
- Seu backend → serviço externo (OpenAI, Stripe, terceiros)
- Seu backend → seu próprio banco (VPC interna, mas ainda boundary)
- Lambda A → Lambda B (via SQS, EventBridge, invoke direto)

Cada boundary precisa de três coisas: **autenticação** (quem está
chamando?), **autorização** (pode fazer isso?), **validação do
payload** (o conteúdo é o que afirma ser?). Boundary que confia sem
verificar é boundary em nome só.

## Padrões na Prática

### Backend proxy para API externa (OpenAI)

Antipadrão comum: "vamos deixar o frontend chamar OpenAI direto pra
economizar latência de um hop."

```
// ❌ ANTIPADRÃO — key no browser
const response = await fetch("https://api.openai.com/v1/chat/completions", {
  headers: { Authorization: `Bearer ${process.env.NEXT_PUBLIC_OPENAI_KEY}` },
  ...
});
```

Resultado: em 48h alguém descobriu a key, rodou script de abuso, conta
OpenAI fechou com $8k de débito. Visto no mundo real, várias vezes.

```
// ✅ Backend proxy
// Frontend:
const response = await fetch("/api/llm/complete", {
  method: "POST",
  body: JSON.stringify({ messages, max_tokens: 500 })
});

// Backend (Lambda com IAM role que lê OPENAI_KEY do Secrets Manager):
export async function handler(event) {
  const user = await authenticate(event);        // quem é?
  await rateLimiter.check(user.id);              // abuse control
  const key = await secrets.get("openai/prod");  // cofre, não env
  const result = await openai.complete({ apiKey: key, ...event.body });
  await audit.log({ user, tokens: result.usage });
  return result.content;
}
```

Benefícios que só o proxy dá:
- **Rate limit por user** (não por IP global — user A não derruba user B)
- **Audit trail**: quem pediu o quê, quando, quanto custou
- **Filtro de output**: redact PII, sanitize HTML antes de devolver
- **Swap de provider**: troca OpenAI por Anthropic sem mudar frontend

### `.env` discipline local

```
# .env.example (commitado, template vazio)
OPENAI_API_KEY=
DATABASE_URL=
STRIPE_SECRET=

# .env (NUNCA commitado)
OPENAI_API_KEY=sk-proj-...
DATABASE_URL=postgres://...
STRIPE_SECRET=sk_live_...

# .gitignore
.env
.env.*
!.env.example
```

Secret scanner no pre-commit hook (`gitleaks`, `truffleHog`) é
infraestrutura defensiva obrigatória. Custa 2 minutos instalar,
evita incidente que custa dias pra limpar (secret vazado em commit
público continua vazado mesmo após force-push — assuma comprometido,
rotacione).

### IAM role least-privilege — Lambda que chama S3 + DynamoDB

```
// ❌ Role "Admin-like" comum em protótipos que viram produção
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}

// ✅ Restritiva desde o dia 1
{
  "Effect": "Allow",
  "Action": ["s3:GetObject"],
  "Resource": "arn:aws:s3:::my-app-uploads-prod/*"
},
{
  "Effect": "Allow",
  "Action": ["dynamodb:GetItem", "dynamodb:PutItem"],
  "Resource": "arn:aws:dynamodb:us-east-1:123:table/user-sessions"
}
```

Lambda comprometida com role específica: blast radius = um bucket +
uma tabela. Com role admin: toda a conta AWS.

## Sinais de Alerta

### Secrets vazando pelo frontend:

- Variável `NEXT_PUBLIC_*`, `VITE_*`, `REACT_APP_*` contendo qualquer
  coisa que pareça key, token, secret. O prefixo público é literal:
  vai pro bundle.
- Frontend chama serviço externo direto (OpenAI, Stripe Charge API,
  SendGrid) — a key **tem** que estar lá pra isso funcionar.
- `console.log(token)` em qualquer lugar do código. Logs de produção
  viram screenshot em Slack, viram anexo de ticket, viram input de
  treinamento de LLM.
- Network tab mostra header `Authorization: Bearer sk-...` saindo do
  browser pra domínio de terceiro. É vazamento por design.

### Secret management frouxo:

- `.env` commitado "só dessa vez porque é dev" — em 6 meses ninguém
  lembra qual branch tem qual secret, e os "de dev" viraram os "de
  prod" em algum copy-paste.
- Secret hardcoded em `serverless.yml` / `template.yaml` / Terraform
  como literal (não `${ssm:/path}`). IaC vira banco de dados de
  credenciais, versionado e público.
- Mesma API key usada em dev, staging e prod. Incident em dev obriga
  rotação em prod (ou pior, ninguém rotaciona e o comprometimento
  se espalha).
- Rotação "manual anual quando lembra". Secret não-rotacionado em 2+
  anos, em time que teve turnover, deve ser tratado como comprometido.

### IAM mal dimensionado:

- Policy com `"Action": "*"` ou `"Resource": "*"` em Lambda de
  produção. Zero justificativa técnica em 99% dos casos.
- Role compartilhada entre 10 Lambdas "pra simplificar". Comprometimento
  de uma = comprometimento das 10.
- Permissions que foram "adicionadas porque não funcionava" sem
  remover quando o problema era outro. Role vira acumulador
  histórico de debug.
- Sem boundary policy / SCP limitando o que roles podem conceder.
  Engenheiro junior cria role `*:*` e ninguém percebe.

### Teste de fumaça

Para cada secret em produção, responda:
1. Onde ele está armazenado? (resposta boa: "Secrets Manager")
2. Quem tem acesso de leitura? (resposta boa: "role X e role Y,
   auditável via CloudTrail")
3. Quando foi a última rotação? (resposta boa: <90 dias)
4. Qual é o procedimento se vazar agora? (resposta boa: runbook
   testado, <30 min)

Se não conseguir responder os quatro com confiança, este secret
é risco concreto, não teórico.

## Conexões

- Defesa em camadas (rate limit, encryption, validation):
  `Defesa Operacional por Engenharia.md`
- LLM-specific cost governance (outra faceta de trust boundary):
  `LLM-Specific Operational Risks.md`
- PII flowing through boundaries: `PII e LGPD na Prática.md`
