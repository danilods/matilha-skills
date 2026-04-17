---
type: methodology
phase: transversal
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: deep
maturity: v1
created: 2026-04-15
updated: 2026-04-17
tags: [methodology, principles, engineering]
author: matilha
license: MIT
---

# Princípios Transversais

Regras que atravessam todas as fases do ciclo. Invocadas implicitamente em cada PRD, cada stack, cada skill.

> [!abstract] TL;DR
> KISS → DRY → SOLID → Clean Architecture. Checkpoint discipline nunca é opcional em projetos com >1 agente. Type safety strict. Silent failures são bugs.

## ═══ BLOCO DENSO ═══

### Regras invioláveis

1. **KISS primeiro, tudo depois.** A solução mais simples que funciona. 3 linhas similares > helper prematuro. Nunca abstraia antes da 3ª repetição.
2. **DRY como consequência, não como objetivo.** Single source of truth surge da abstração *justificada*. Abstração prematura acopla mais do que DRY economiza.
3. **SOLID especialmente SRP + DIP.** SRP: uma razão para mudar. DIP: dependa de interfaces, não implementações (injeção explícita).
4. **Clean Architecture hexagonal.** `domain/` puro (sem imports de framework) → `application/` (casos de uso) → `infrastructure/` (frameworks, APIs, DB). `tests/` espelha `src/`.
5. **TDD obrigatório.** Red → green → refactor. Teste primeiro. Sem teste, sem merge.
6. **Type safety strict.** `mypy --strict`, `tsc --strict`, `dart analyze`. Nada de `any` / `dynamic`.
7. **Silent failures são bugs.** Todo erro precisa ser logado com contexto ou levantado. Nunca `except: pass`. Nunca `catch` vazio.
8. **Checkpoint discipline.** Projetos com >1 agente exigem arquivo de controle/status que TODOS os agentes atualizam. Previne estouro de janela de contexto e permite retomada sem perda de estado.
9. **Valide só nas bordas.** Input do usuário e APIs externas. Código interno confia.
10. **Commits convencionais.** `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:` + escopo quando relevante.

### Checklist operacional (se aplica a cada feature)

- [ ] Solução mais simples foi considerada? Existe proposta mais simples viável?
- [ ] Abstração foi introduzida? Há ≥3 repetições justificando?
- [ ] Domínio tem import de framework? Se sim, violação Clean Arch.
- [ ] Teste escrito antes do código? `red` visto antes de `green`?
- [ ] Tipos cobertos em 100% das assinaturas públicas?
- [ ] Erros tratados com contexto? Logs estruturados (não `print`)?
- [ ] Arquivo excedeu limite do projeto (300 ou 400 linhas)? Função excedeu 20-40 linhas? Split.
- [ ] Commit message segue convenção?
- [ ] Coverage ≥80% global, ≥90% em core/domain?

### Limites quantitativos (ajuste por arquétipo)

| Métrica | Projeto simples | Projeto complexo |
|---|---|---|
| Linhas por arquivo | 400 | 300 |
| Linhas por função | 40 | 20 |
| Nesting levels | 3 | 3 |
| Imports internos por módulo | — | 5 |
| Coverage global | 80% | 80% (90% em core) |

*Defaults observados em adedonha (simples) e fluency (complexo).*

### Defaults e anti-padrões

**Defaults:**
- Structured logging (structlog em Python).
- Exceções customizadas por domínio (`StudentNotFoundError`, `ProviderUnavailableError`) em vez de genéricas.
- Testes integrados com testcontainers, não mocks de DB.
- Circuit breaker + fallback chain para chamadas a providers externos.

**Anti-padrões observados:**
- ❌ Abstração prematura (interface para uma implementação só).
- ❌ `except:` bare. Sempre specific.
- ❌ Mocks de DB em integration tests — use testcontainers.
- ❌ `print()` em código de produção.
- ❌ Comentários que reafirmam o código (explica WHY, não WHAT).
- ❌ Arquitetura em camadas sem injeção (`domain/` importando `infrastructure/`).
- ❌ Teste que roda só no happy path.

### Árvore de decisão — "esta regra se aplica?"

- Produto é MVP em janela <4 semanas? → Relaxe cobertura para 60%, mantenha KISS e silent-failure rule.
- Produto é multi-agente ou >3 serviços? → Checkpoint discipline **obrigatória**. Não opcional.
- Produto vai ter >3 teammates ao longo do tempo? → Type safety strict **obrigatório**. Não negociável.
- Produto é prova-de-conceito que não vira prod? → Dispense TDD. Mantenha KISS.

### Decisões de juízo (não-templatizáveis)

Pontos que exigem pensamento real, caso a caso. Checklist aqui é falso conforto.

- **Quando a abstração é justificada** — identificar a 3ª repetição é fácil; identificar se as 3 repetições são de fato a mesma coisa (mesma razão para mudar, não só mesma sintaxe) é juízo.
- **Quando quebrar KISS em nome de robustez** — circuit breakers, retries, idempotência: sempre parecem overkill até falharem em prod. A calibração é empírica.
- **Quando dispensar TDD** — explorações rápidas em notebook/REPL para descobrir API de uma lib. TDD atrasa a descoberta. Decisão: quando já sei o contrato, volto ao TDD.
- **Quando confiar na borda e quando fortificar** — validação em camadas multiplica código. Decisão depende de: quem é a borda real? (usuário direto vs. outro serviço meu).
- **Quando aceitar dívida técnica explícita** — MVP de 2 semanas vs. refactor de 2 dias que atrasa o launch. Dívida documentada (em `docs/tech-debt.md` ou similar) é OK; dívida esquecida é bomba.

## ═══ NARRATIVA ═══

### Racional

As regras acima não são dogma — são observações cristalizadas de 8 projetos reais. Cada uma tem uma cicatriz correspondente em algum projeto que falhou por violá-la.

**KISS antes de DRY:** o anti-padrão mais caro em código com assistência de IA é o agente inventar uma camada de abstração para "ficar organizado". Uma vez que a abstração existe, ela é herdada pelos próximos prompts — e só percebe-se o custo quando o próximo agente precisa entender a interface para cambiar uma linha. [leis-de-krug](../concepts/leis-de-krug.md) no software: "don't make me think" também se aplica ao próximo programador.

**Checkpoint discipline:** essa regra existe porque projetos multi-agente perdem contexto. Sem arquivo de controle, o agente de hoje à noite não sabe o que o agente de agora-pela-manhã fez. Ou pior: o mesmo agente, em sessão nova, reexecuta trabalho. A disciplina de "orquestrador + arquivo de status que todos atualizam" foi mencionada explicitamente no brain-dump como **"grande risco que deve ser prontamente atendido"**.

**Silent failures:** LLMs, quando não sabem o que fazer, tendem a `except: pass`. O código fica "funcionando" e o bug vai para prod. A regra 7 não é estética — é sobre evitar que o assistente converta bugs em silêncios.

### Exemplo real — fluency

O CLAUDE.md de `fluency/` codifica quase todas essas regras explicitamente (veja trecho):
- `KISS → DRY → SOLID → Clean Architecture` em ordem declarada.
- Max 300 linhas/arquivo, 20 linhas/função, 5 imports/módulo.
- TDD workflow: "write test FIRST → see it fail (red) → implement minimal code (green) → refactor".
- "**Silent failures are BUGS.** Every error must be logged with context or raised."

O mesmo CLAUDE.md tem **hookify rules** que fazem cumprir automaticamente:
- `hookify.architecture-violation.local.md` — bloqueia imports de `infrastructure/` dentro de `domain/`.
- `hookify.no-large-files.local.md` — bloqueia arquivos >300 linhas.
- `hookify.test-reminder.local.md` — lembra de teste quando código novo chega sem teste.
- `hookify.stop-quality-check.local.md` — roda lint/type/test antes de terminar sessão.

Isso é a materialização da regra: "não basta declarar, tem que ter hook bloqueando". Veja [30-skills-agents](./30-skills-agents.md) para como replicar isso em projeto novo.

### Exemplo real — adedonha

O adedonha é MVP com defaults diferentes (40 linhas/função, 400 linhas/arquivo) porque o domínio é menos complexo. Mesmo assim, mantém:
- Server-authoritative (regra de domínio — não é engenharia pura, mas se encaixa em "silent failures são bugs" — cliente manipular estado é failure silencioso).
- Strict typing (`mypy`, `tsc`, `dart analyze`).
- Coverage ≥80% em business logic (scoring, validation, matchmaking).

A calibração dos limites (300 vs 400, 20 vs 40) **é decisão de juízo** na fase 20-Stack, não no bloco denso deste princípio.

### Armadilhas comuns

- **Regra virando ritual.** Agente executa TDD só pela forma (escreve teste trivial só para passar). Antídoto: code review focado em "este teste pega a mudança que motivou ele?".
- **Clean Architecture virando camada extra.** Hexagonal não é sobre ter `/domain`, `/application`, `/infrastructure`. É sobre domain **não importar** framework. Um projeto com 3 pastas e imports cruzados é cosplay de Clean Arch.
- **Coverage virando métrica de vaidade.** 90% de cobertura com testes de getter é pior que 60% de cobertura com testes de borda. Inspect manual periódico.
- **Checkpoint esquecido em sessões curtas.** "Essa task é rápida, não preciso de checkpoint" — e aí vira multi-sessão. Default: checkpoint desde a primeira sessão do projeto.

## Links

- [index](./index.md) — hub de metodologia
- [10-prd](./10-prd.md) — fase PRD aplica estas regras na fundação
- [20-stack](./20-stack.md) — fase Stack calibra os limites quantitativos
- [30-skills-agents](./30-skills-agents.md) — fase Skills/Agents materializa as regras em hooks que bloqueiam
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- Conceitos embasadores: [nfr-system-design](../concepts/nfr-system-design.md), [leis-de-krug](../concepts/leis-de-krug.md)
- Raw: 2026-04-15-danilo-brain-dump
