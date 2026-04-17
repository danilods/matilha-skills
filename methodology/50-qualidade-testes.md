---
type: methodology
phase: "50"
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: skeleton
maturity: v1
created: 2026-04-16
updated: 2026-04-17
tags: [methodology, quality, testing, tdd, code-review]
author: matilha
license: MIT
---

# 50 — Qualidade e testes

> [!abstract] TL;DR
> Testes em todos os espectros: unitários, integração, regressão, E2E. Coverage gates em CI. TDD obrigatório em código de negócio. Mocks para dependências externas; **testcontainers (DB real) para integração**, nunca mock de DB.
>
> **Status: `skeleton`** — regras do brain-dump + inferidas dos CLAUDE.md de adedonha/fluency. Upgrade para `deep` quando houver projeto que tenha sofrido com bug de mock-vs-prod.

## Quando esta fase se aplica

- Transversal — desde o primeiro commit (TDD) até o último antes do deploy.
- **Não é fase em série** como 10/20/30 — é infraestrutura que roda em paralelo com 40-Execução.

## Gates de entrada (binários)

- [ ] Stack definida inclui framework de teste declarado (pytest, vitest, dart test, etc.)
- [ ] CI configurada (GitHub Actions ou equivalente) rodando lint + typecheck + tests
- [ ] Coverage threshold declarado no projeto (default 80% global, 90% em core/domain)

## Gates de saída (binários — aplicados continuamente, não só ao final)

- [ ] **TDD respeitado**: cada commit de código novo inclui teste que falha antes do código
- [ ] Coverage ≥ threshold do projeto (sem override silencioso)
- [ ] Integration tests usam DB real via testcontainers (não mocks)
- [ ] E2E tests cobrem fluxos críticos (onboarding, fluxo principal de valor, edge-cases de dinheiro/segurança)
- [ ] Zero `silent failure` detectado (nenhum `except: pass` ou equivalente)
- [ ] Lint + typecheck strict passam sem warnings em código de produção
- [ ] Code review (humano ou agente especializado) executado antes de merge
- [ ] Regression tests existem para bugs já corrigidos (bug fixado sem teste = bug que volta)

**Como materializar cada gate em cada ferramenta:** ver [materializacoes](./materializacoes.md) (ação "Code review e qualidade").

## ═══ BLOCO DENSO ═══

### Checklist operacional

- [ ] Teste escrito antes do código? `red → green → refactor`?
- [ ] Teste de unidade para cada função pública
- [ ] Teste de integração para cada endpoint de API
- [ ] Teste E2E para cada fluxo crítico (do usuário, não da unidade técnica)
- [ ] Integration tests usam testcontainers (PostgreSQL, Redis, etc. reais)
- [ ] Mocks apenas para: APIs externas, filesystem, tempo, random
- [ ] Teste de regressão adicionado para cada bug corrigido
- [ ] Coverage verificado em CI (não local)
- [ ] Code review antes de merge (humano ou agente)
- [ ] Security review para código que toca autenticação, pagamento, PII
- [ ] `stop-quality-check` (ou equivalente) roda lint+type+test antes de encerrar sessão

### Regras invioláveis

1. **Sem teste, sem merge.** Nem exceção "é só um hotfix" — hotfix precisa de teste de regressão.
2. **Integration tests com DB real.** Mock de DB é dívida silenciosa — passa local, quebra em prod quando migration é real.
3. **Silent failures são bugs.** `except: pass`, `catch(e) {}`, swallow errors sem log = priorize fix antes de feature nova.
4. **Coverage é métrica de apoio, não de verdade.** 90% cobertura com testes de getter é pior que 60% com testes de borda. Inspecione manualmente periodicamente.
5. **E2E não testa unidade.** Não confunda: E2E valida fluxo do usuário. Para validar lógica, use unit test.
6. **Bugs corrigidos ganham teste de regressão.** Primeira coisa ao reproduzir o bug: escrever o teste que falha. Fix é o próximo passo.
7. **Evaluator agent é SEPARADO do generator.** Em tarefas autônomas longas, o agente que revisa qualidade precisa ser processo separado do que gera código. Self-evaluation bias (agente elogia confidencialmente seu próprio trabalho) é defeito observado consistentemente. Ver [harness-engineering](../concepts/harness-engineering.md) técnica 2.
8. **Evaluator usa o produto vivo, não screenshot.** Playwright MCP ou equivalente: clica, digita, testa endpoints reais. Avaliar output estático deixa passar bugs de interação.
9. **Criteria com hard threshold.** Score médio esconde falha crítica. Threshold POR critério força coerência: qualquer critério abaixo = fail, independente dos outros.
10. **Linters custom com mensagens como INSTRUÇÃO ao agente.** Lint ruim: "Arquivo muito grande". Lint bom: "Arquivo excede 300 linhas. Split em módulos por responsabilidade. Ver `docs/DESIGN.md` section X. Sugestão: extrair `<Y>` para novo módulo." Mensagem de erro é canal privilegiado entre linter e próximo agente — escreva como instruiria um junior dev. Ver [agent-centric-codebase](../concepts/agent-centric-codebase.md) pilar 5.
11. **Arquitetura rígida enforced por linters acelera com agents.** Com humanos, restrição vira burocracia. Com agents, previne drift e permite velocidade. Camadas fixas + direções de dependência estritas + "invariantes de gosto" (structured logging, naming, file size) codificados mecanicamente. Ver [agent-centric-codebase](../concepts/agent-centric-codebase.md) pilar 4.
12. **Gestão de entropia contínua (não em rajada).** Background agent recorrente (janitor) checa drift, atualiza quality ratings, abre PRs de refactor. Tech debt em pagamentos pequenos contínuos &gt;&gt; acumular e limpar em dias doloridos.

### Árvore de decisão

```
Tipo de código a testar?
├── Business logic (domain layer)
│   ├── Unit tests: sempre, cobertura >90%
│   ├── Mocks externos, não mocks internos
│   └── Testa invariantes, não implementação
│
├── Infrastructure (adapters, DB access)
│   ├── Integration tests: testcontainers
│   └── Mock só APIs externas fora do seu controle
│
├── API endpoints (application layer)
│   ├── Integration tests com TestClient / equivalente
│   └── Coverage próxima a 100% de paths
│
├── UI / frontend
│   ├── Component tests (shallow) para lógica de componente
│   ├── Visual regression para layouts críticos
│   └── E2E (Playwright/Cypress) só para fluxos críticos
│
└── Algoritmos / cálculos (scoring, validação, etc.)
    ├── Property-based testing quando aplicável
    └── Tabela de casos: input → expected
```

### Defaults e anti-padrões

**Defaults:**
- Python: `pytest + pytest-asyncio + pytest-cov + testcontainers`.
- TypeScript/JS: `vitest` (web) / `jest` (node) + `testcontainers-node`.
- Flutter: `flutter_test` + `mocktail`.
- Coverage gate em CI: 80% global, 90% core/domain.
- Lint: `ruff` (Python) / `eslint` (TS) / `dart analyze` (Flutter).
- Typecheck strict: `mypy --strict` / `tsc --strict` / `dart analyze --fatal-infos`.

**Anti-padrões:**
- ❌ Mock de DB em integration test — descobre erro em prod.
- ❌ Teste que testa a implementação, não o contrato (quebra a cada refactor).
- ❌ `print()` em código de produção — use structured logging.
- ❌ Disable CI temporariamente para "adiantar merge" — dívida garantida.
- ❌ `@ignore` / `skip` em teste sem comentário explicando e link para ticket.
- ❌ Coverage > threshold via testes triviais — fraude.

### Decisões de juízo (não-templatizáveis)

- **Quando dispensar TDD.** Explorações em notebook para descobrir API de lib: sim. Código que vai para prod: nunca.
- **Quando aceitar um teste frágil.** Se cobre borda importante mas é difícil de manter: vale o custo. Se cobre caminho feliz comum: simplifique.
- **Nível de E2E vs integration.** Muito E2E = CI lenta e flaky. Pouco E2E = regressões no fluxo de dinheiro passam. Heurística: E2E para fluxos que "se quebrar, perco dinheiro/usuário AGORA". Integration para todo o resto.
- **Quando investir em property-based vs example-based.** Algoritmos com muitas combinações de input (scoring, parsing, compression) → property. Lógica simples com casos enumeráveis → example.

### Eval-driven development (para componentes com agents)

Para componentes que envolvem agents (tool use, multi-turn, state modification), testes unitários não bastam. Aplique **eval-driven development**: escreva evals ANTES do agent ser capaz. Ver [agent-evaluation](../concepts/agent-evaluation.md) para framework completo.

**Distinção crítica:**

| Tipo de eval | Pass rate esperado | Propósito |
|---|---|---|
| **Capability eval** | Baixo (target pontos fracos) | Hill to climb |
| **Regression eval** | ~100% | Detecta drift |

Capability que satura "gradua" para regression suite.

**3 tipos de graders** (escolher por task):
- **Code-based**: string match, binary tests, static analysis, state check, tool calls. Rápido, determinístico, limitado para subjetivo.
- **Model-based** (LLM-as-judge): rubric, natural language assertions. Flexível, não-determinístico, **requer calibração com humanos**.
- **Human**: SME review, spot-check, A/B. Gold standard, caro.

**Métricas para não-determinismo:**
- **pass@k**: ≥1 sucesso em k tentativas. Cresce com k. Use quando um sucesso basta.
- **pass^k**: TODOS os k. Cai com k. Use para customer-facing (consistência esperada).

**Read the transcripts** — skill crítica. Você não sabe se graders funcionam sem ler. 0% pass@100 = task quebrada, não agent incapaz.

**Swiss Cheese de camadas** — automated evals + production monitoring + A/B + user feedback + manual transcript review + systematic human. Combinar é padrão de teams eficazes.

Materialização por ferramenta (incluindo frameworks Harbor, Braintrust, LangSmith, Langfuse, Arize): ver [materializacoes](./materializacoes.md) ação "Design eval suite + graders".

## ═══ NARRATIVA ═══

### Racional

A regra mais cara de violar é "integration tests com DB real" — porque a violação é invisível (testes passam) até o momento em que uma migration em prod quebra um constraint que o mock não tinha. Esse é o cenário clássico de "passou no CI, falhou no deploy".

TDD não é sobre cobertura — é sobre design. Um teste escrito antes força você a pensar no contrato público antes da implementação. Implementação sem teste tende a expor estado interno desnecessariamente.

### Exemplo real — placeholder (skeleton)

> [!todo] Calibração pendente
> Candidatos: **fluency** (437 test cases derivados dos business rules do PRD, testcontainers para PostgreSQL/Redis/FalkorDB, coverage gates >80% global e >90% core/domain) e **adedonha** (regra `Test business logic — 80% coverage minimum on scoring, validation, matchmaking`). Upgrade para `deep` com análise detalhada das pipelines de CI.

### Armadilhas comuns

- **Coverage como pseudo-métrica.** 95% cobertura ≠ 95% qualidade. Olhe os testes, não só o número.
- **E2E instáveis.** Flaky E2E corrói confiança no CI. Investigue root cause antes de adicionar retry — retry esconde bug.
- **Testes que testam framework.** Testar que "o Django retornou 200" não testa a sua lógica. Testes devem falhar quando seu código muda, não quando o framework muda.

## Links

- Fase anterior: [40-execucao](./40-execucao.md) (execução e testes rodam em paralelo, não serial)
- Fase seguinte: [60-deploy-infra](./60-deploy-infra.md)
- Princípios: [principios-transversais](./principios-transversais.md) (especialmente regras 5, 6, 7 — TDD, type safety, silent failures)
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- **Harness engineering (evaluator pattern, criteria threshold):** [harness-engineering](../concepts/harness-engineering.md)
- **Agentic patterns (ACI + poka-yoke como defesa):** [agentic-patterns](../concepts/agentic-patterns.md)
- **Agent-centric codebase (linters custom como instrução + janitor agent):** [agent-centric-codebase](../concepts/agent-centric-codebase.md)
- **Agent evaluation (eval-driven dev, graders, pass@k vs pass^k, Swiss Cheese):** [agent-evaluation](../concepts/agent-evaluation.md)
- Conceitos embasadores: [nfr-system-design](../concepts/nfr-system-design.md)
- Raw: 2026-04-15-danilo-brain-dump
