---
title: PII e LGPD na Prática
date: 2026-04-23
version: 1.0
alwaysApply: false
---

## Princípios Fundamentais

**PII NÃO É SÓ COMPLIANCE — É PEGADA QUE CRESCE. MENOS PII RETIDA = MENOS DANO EM BREACH + MENOS COMPLEXIDADE PRA DIREITO DE DELEÇÃO.**

A LGPD (e GDPR, e CCPA) deram forma jurídica a uma disciplina que
seria boa engenharia de qualquer jeito: coletar só o necessário, usar
só pro que foi coletado, guardar só pelo tempo útil, deixar o titular
apagar. Tratar isso como checklist jurídico produz código defensivo e
burocracia; tratar como engenharia de minimização produz sistema mais
simples e mais seguro de graça.

O princípio central: **todo dado pessoal que você tem é passivo**.
Tem custo de armazenamento, custo de backup, custo de auditoria, custo
regulatório, e blast radius em caso de breach. A pergunta certa não
é "posso guardar isso?" — é "preciso guardar isso, e por quanto
tempo?".

### Regras Fundamentais

1. **Minimização é arquitetural, não opcional**
   - Cada campo coletado precisa de finalidade explícita. Se não
     consegue nomear o uso em uma frase ("usamos CPF pra emitir
     nota fiscal"), não coleta.
   - "Vamos coletar agora, a gente pensa no uso depois" é débito
     de compliance + dívida técnica ao mesmo tempo. Em 2 anos
     você tem 40 campos que ninguém sabe por que foram coletados,
     e deletar cada um exige arqueologia.

2. **Consent é por finalidade, não global**
   - LGPD art. 7: cada uso de dado tem base legal (consent, contrato,
     legítimo interesse, obrigação legal, etc.). Marketing, analytics
     product, training de AI são finalidades **separadas** — cada uma
     exige base legal própria.
   - Dado coletado pra finalidade X não pode ser reusado em Y sem
     nova base legal. "Temos os dados, vamos treinar modelo com eles"
     é violação se o consent original era só "fornecer o serviço".
   - Implementação técnica: tabela `consents(user_id, purpose, granted_at,
     revoked_at)`. Cada caminho de código que usa PII checa consent
     pra aquela finalidade específica. Sem middleware de consent, é
     só promessa em política de privacidade.

3. **Retenção é política executada, não intenção**
   - Cada tipo de dado tem TTL explícito:
     - Logs de acesso: 30-90 dias
     - Conversas/mensagens: 90-365 dias (varia por produto)
     - Dados transacionais: 5-10 anos (obrigação fiscal)
     - Audit trail de decisões automatizadas: 5+ anos (LGPD art. 20)
   - TTL sem job de deleção automatizada é decoração. Implementação:
     cron/scheduled Lambda que deleta rows `WHERE created_at < NOW()
     - INTERVAL '...'`. Teste o job em staging com dados reais (shape
     real, não mockado).
   - "Guardamos indefinidamente só por garantia" é antipadrão. Garantia
     de quê? O que você ganha com dado de 5 anos que não ganharia com
     dado de 1 ano? Se a resposta é "nada concreto", delete.

4. **Direito de deleção é endpoint, não ticket**
   - Deleção manual via DBA escrevendo SQL é insustentável. Em um
     produto com 10 usuários/mês pedindo deleção, é burocracia
     quebrada; em 100/mês, é bomba.
   - Implementação: endpoint `DELETE /api/users/me` que executa
     cascade em todos os stores onde o user aparece:
     - SQL: tabela principal + todas as FKs
     - DynamoDB: itens da partição + GSIs
     - S3: objetos identificados por user_id (prefixo ou tag)
     - Cache (Redis): invalidação
     - Vector store (LLM): deleção dos embeddings
     - Logs estruturados: tombstone ou anonimização
     - Backups: política explícita (rolling window)
   - Testa o fluxo end-to-end periodicamente. "Deletou o user e
     ele ainda aparece no dashboard" é não-compliance evidente.

5. **Log de acesso a PII é auditoria, não debug**
   - Toda leitura de PII sensível (CPF, data de nascimento, endereço,
     dados de saúde) gera log estruturado: quem acessou, quando,
     qual recurso, com qual justificativa.
   - CloudTrail + tabela `pii_access_log` + auditoria trimestral
     (humana, não só automática). Auditoria que ninguém olha é só
     custo de storage.

## Padrões na Prática

### Minimização ao LLM — redact antes de enviar

```
// ❌ Contexto completo pro modelo
const prompt = `
  Aluno: ${user.full_name} (CPF ${user.cpf}, nascido ${user.birth_date})
  Pergunta: ${question}
`;

// Se o modelo loga requests (muitos providers logam por 30d pra
// abuse detection), CPF de todos os users virou dado em serviço
// de terceiro. Se o modelo for retreinado, PII pode vazar em
// resposta futura.

// ✅ Contexto mínimo + tokenização consistente
const prompt = `
  Aluno (ID interno: ${hashUserId(user.id)})
  Pergunta: ${question}
`;
// Hash consistente permite correlação interna sem enviar PII.
// Se o task é "gerar resposta pedagógica", ele não precisa de CPF.
```

Heurística: **o LLM só recebe PII quando a task exige PII**. Gerar
resposta educacional? Não exige. Gerar boleto? Exige CPF (e aí fica
claro que esse caminho específico é o único com PII, auditável).

### Consent por finalidade — tabela + middleware

```
// Schema
CREATE TABLE consents (
  user_id UUID NOT NULL,
  purpose VARCHAR(50) NOT NULL,   -- 'marketing', 'analytics', 'ai_training'
  granted_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ,
  PRIMARY KEY (user_id, purpose)
);

// Middleware
async function requireConsent(purpose: string) {
  return async (req, res, next) => {
    const c = await db.consents.find(req.user.id, purpose);
    if (!c || c.revoked_at) {
      return res.status(403).json({ error: `no_consent:${purpose}` });
    }
    next();
  };
}

// Rota
app.post("/api/marketing/email-campaign",
  authenticate,
  requireConsent("marketing"),
  sendMarketingEmail);
```

Revogar consent: update row com `revoked_at = NOW()`. Efeito imediato
em todas as rotas. Log do evento pra auditoria.

### Deleção em cascade — endpoint unificado

```
async function deleteUserCompletely(userId: string) {
  const trace = { userId, startedAt: new Date(), steps: [] };

  // 1. SQL principal + FKs com ON DELETE CASCADE
  await db.users.delete({ where: { id: userId } });
  trace.steps.push("sql:users");

  // 2. DynamoDB
  await dynamo.deleteAllItems({ table: "sessions", pk: userId });
  trace.steps.push("dynamo:sessions");

  // 3. S3 — objetos taggeados com user_id
  await s3.deleteByTag({ bucket: "uploads", tag: `user_id=${userId}` });
  trace.steps.push("s3:uploads");

  // 4. Vector store (LLM embeddings)
  await vectorDb.deleteByMetadata({ user_id: userId });
  trace.steps.push("vector:embeddings");

  // 5. Redis cache
  await redis.del(`user:${userId}:*`);
  trace.steps.push("redis");

  // 6. Logs — tombstone (anonimização), não deleção total (pode quebrar
  //    integridade de audit trail necessário por lei)
  await db.auditLog.update({
    where: { user_id: userId },
    data: { user_id: null, anonymized_at: new Date() }
  });
  trace.steps.push("logs:anonymized");

  await auditSink.log({ event: "user_deleted", trace });
}
```

Cada passo idempotente (executar 2x não quebra). Reporta cada etapa
pra rastreabilidade. Falha explícita se algum store não confirma
deleção — não "best-effort silencioso".

### Retenção automatizada — job noturno

```
// scheduled Lambda / cron diário
async function retentionSweep() {
  // Logs de acesso: 30 dias
  await db.accessLogs.deleteMany({
    where: { created_at: { lt: daysAgo(30) } }
  });

  // Mensagens de chat: 365 dias
  await db.messages.deleteMany({
    where: { created_at: { lt: daysAgo(365) } }
  });

  // Sessions expired: 7 dias
  await dynamo.deleteExpired({ table: "sessions", ttl: daysAgo(7) });

  await metrics.emit("retention_sweep.completed", { ... });
}
```

Monitora o job como serviço crítico. Job parado = retenção violada
silenciosamente.

## Sinais de Alerta

### PII expandindo sem governança:

- Tabela `users` com 40+ colunas e ninguém sabe por que cada uma
  existe. Arqueologia obrigatória antes de qualquer refactor.
- Campos como `notes`, `metadata`, `extra` recebendo PII
  semi-estruturada — invisível pra qualquer ferramenta de scanning
  automatizado.
- PII em logs de debug ("user logged in with email ${user.email}").
  Logs geralmente têm retenção maior que o DB principal, e vão pra
  mais lugares (SIEM, dashboards, SaaS de observabilidade).
- PII em prompt do LLM sem redação. Se o provider loga requests
  (padrão), virou PII em serviço de terceiro.

### Consent ausente ou genérico:

- Um único checkbox "aceito os termos" cobre marketing + analytics
  + AI training + compartilhamento com parceiros. LGPD art. 7 exige
  separação por finalidade.
- Consent não revogável na UI. "Pra cancelar email envie um email
  pra nosso suporte" não é canal válido — LGPD exige que seja tão
  fácil revogar quanto foi conceder.
- Dado coletado pra finalidade A usado em B sem registro de nova
  base legal. Ex: emails coletados pra verificação de conta usados
  em campanha de marketing.

### Retenção como intenção:

- Política de retenção escrita em política de privacidade, zero
  código que a executa. Auditoria pergunta "me mostre um user
  deletado pela política automática" — não existe.
- Backups com retenção indefinida ("mantemos pra sempre por
  segurança"). Backup que guarda PII por 10 anos quando o DB
  principal retém por 1 ano é vazamento institucional.
- Soft delete (`deleted_at`) sem purge real posterior. Dados
  "deletados" ainda aparecem em backup, export, relatório.

### Deleção sem operação:

- Endpoint de deleção é ticket manual. Escala mal, cria back-pressure,
  vira não-compliance quando o volume sobe.
- Deleção SQL deixa arquivos órfãos em S3, embeddings em vector DB,
  keys em Redis. User pediu deleção em Janeiro, em Junho ainda
  aparece em search do vector store.
- Zero log de quem deletou, quando, qual foi o resultado. Auditoria
  vira "achamos que deletou" — não defensável.

### Teste de fumaça

Para cada campo PII que você armazena:
1. Qual é a finalidade documentada?
2. Qual é a base legal (consent, contrato, obrigação, etc.)?
3. Qual é o TTL? Qual job executa a deleção?
4. Em caso de pedido de deleção, quantos stores precisam ser
   tocados e existe endpoint automatizado pra isso?

Se algum dos quatro não tem resposta concreta, este campo é
passivo não-gerenciado. Delete se possível, documente + governe
se necessário.

## Conexões

- Redação de PII antes de enviar ao LLM:
  `LLM-Specific Operational Risks.md`
- PII em logs cruzando boundaries: `Trust Boundary e Secret Management.md`
- Encryption at rest de PII: `Defesa Operacional por Engenharia.md`
