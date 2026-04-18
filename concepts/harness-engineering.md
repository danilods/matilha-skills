---
type: concept
sources:
  - "harness-design-anthropic"
  - "2026-04-15-danilo-brain-dump"
created: 2026-04-16
updated: 2026-04-17
tags: [concept, harness, agents, orchestration, methodology]
phase: reference
author: matilha
license: MIT
---

# Harness engineering

Conjunto de decisões arquiteturais que envolvem o modelo LLM para compensar gaps de capability e produzir comportamento determinístico em tarefas longas ou complexas. Oposto de "prompt engineering isolado" — harness é a infraestrutura AO REDOR do modelo.

> [!abstract] Princípio mestre
> Cada componente de um harness **codifica uma suposição sobre o que o modelo não consegue fazer sozinho**. A cada modelo novo, suposições antigas podem ficar obsoletas. Stress-testar é disciplina.

## Por que existe

Dois modos de falha em agentes long-running que prompt engineering puro não resolve:

1. **Context degradation + context anxiety** — janela enche, coerência cai, modelo pode encerrar prematuramente acreditando estar perto do limite.
2. **Self-evaluation bias** — agente gera output medíocre e aprova a si mesmo com confiança. Pronunciado em tarefas subjetivas (design, UX, escrita criativa) onde não há teste binário.

Harness resolve via **orquestração** e **separação de responsabilidades** — não via instrução melhor ao modelo.

## Técnicas canônicas

### 1. Context reset vs compactação

**Compactação** (in-place): histórico é sumarizado, mesmo agente continua em janela menor. Preserva continuidade; **não dá clean slate**, context anxiety persiste.

**Context reset**: janela nova + agente novo + **artefato estruturado** que carrega estado + próximos passos. Resolve anxiety completamente; custo: orchestration overhead, latência, tokens do handoff.

**Quando usar cada:**
- Sonnet 4.5 (e modelos com context anxiety): reset essencial.
- Opus 4.6+ (context anxiety reduzido): compactação automática frequentemente basta.

### 2. Separar generator de evaluator

Tornar generator crítico de si mesmo é **muito mais difícil** do que afinar um evaluator cético à parte. A separação:

- Dá ao generator feedback **externo** e concreto para iterar contra.
- Permite tuning focado do evaluator sem contaminar o generator.
- Elimina o bias de "confidentemente aprovar o próprio trabalho".

**Evaluator tuning loop**: ler logs → achar onde julgamento divergiu do humano → atualizar prompt do evaluator → repetir. Leva várias rodadas.

### 3. Decomposição + artefatos de handoff

Generator trabalha em **chunks tratáveis** (sprints, features, módulos), com commits entre chunks. **Artefatos em arquivos** (não mensagens efêmeras) carregam contexto.

## Arquitetura de referência: Planner → Generator → Evaluator

GAN-inspired (generator vs discriminator). Mapeia naturalmente ao ciclo product → build → QA.

```
Usuário
  ↓ prompt 1-4 frases
Planner
  ↓ product spec completo (ambicioso em escopo, alto-nível em técnico)
Generator ⇄ Evaluator  [sprint contract: "o que é done" ANTES do código]
  ↓ feature implementada
Evaluator (com Playwright MCP ou equivalente, clica como usuário)
  ↓ bugs + grade contra criteria (hard threshold por critério)
Generator refina OU Evaluator aprova → próxima sprint
```

### Responsabilidades

- **Planner**: expande prompt → spec completo. Ambicioso em escopo; alto-nível em técnico (granularidade cedo vira erro em cascata).
- **Generator**: implementa feature-by-feature, commita, faz self-eval leve antes de entregar.
- **Evaluator**: ataca a aplicação viva como usuário (Playwright MCP, click real). Tests criteria com threshold. Qualquer critério abaixo → sprint falha.

### Sprint contract

Generator e evaluator **negociam** "o que é done" ANTES de qualquer código. Iteram até acordar. Bridge entre:
- Spec alto-nível (user stories, deliverables) — do planner.
- Implementação testável (criteria binários, endpoints específicos) — do sprint.

Sem sprint contract, evaluator e generator divergem no meio do caminho.

## Tornando qualidade subjetiva gradável

Para tarefas sem teste binário (design, UX, escrita):

1. **Criteria explícitos** encodam princípios. Não "é bom?" — mas "segue nossos princípios de bom design?".
2. **Pesos intencionais** para desviar do "safe/generic AI slop".
3. **Few-shot examples** no prompt do evaluator com breakdowns de score — reduz drift.
4. **Wording importa** — frases como "best designs are museum quality" mudam o CARÁTER do output, não só o score.

## Evolução com o modelo

Cada modelo novo é oportunidade de **re-auditar o harness**:

- Strip componentes que eram compensatórios e não são mais load-bearing.
- Adicione componentes para capacidades agora possíveis (ex: contexto mais longo permite menos resets).
- "A space of interesting harness combinations doesn't shrink — it moves."

**Anti-padrão**: harness congelado em v1 de 6 meses atrás. Likely contém scaffolding obsoleto + falta oportunidade nova.

## Quando aplicar

Por complexidade da tarefa:

| Tarefa | Harness recomendado |
|---|---|
| Edição pontual, <30 min | Solo, sem harness |
| Feature isolada, poucas horas | Solo + hooks de quality check |
| MVP de 2-4 semanas | Planner (de spec) + Generator + hooks; evaluator opcional |
| Aplicação full-stack autônoma | Planner + Generator + Evaluator + sprint contracts |
| Multi-agent com domínios | + orquestrador + agent por domínio + shared state file |

## Relação com os princípios do vault

- [principios-transversais](./principios-transversais.md) regra 8 (**Checkpoint discipline**) é a base — sem arquivo de estado, não existe handoff estruturado.
- [nfr-system-design](../concepts/nfr-system-design.md) — harness é o análogo de "reliability engineering" aplicado a agentes.
- [frameworks-comportamentais](../concepts/frameworks-comportamentais.md) — self-evaluation bias é análogo a Dunning-Kruger; anchoring bias afeta como evaluator reage à primeira impressão.
- [leis-de-krug](../concepts/leis-de-krug.md) — "don't make me think" aplicado ao próximo agente lendo o handoff: artefato precisa ser auto-suficiente.

## Antipadrões

- ❌ **Prompt-engineering tudo, harness nada.** Quando a tarefa ultrapassa capability do modelo, scaffolding estrutural (não prompt maior) é a saída.
- ❌ **Harness pesado quando modelo já resolve solo.** Custo de orchestration > ganho. Strip.
- ❌ **Evaluator que é o mesmo agente "virado do avesso".** Self-eval bias persiste. Evaluator precisa ser processo separado (subagent ou session).
- ❌ **Handoff via mensagem, não arquivo.** Mensagens são efêmeras; arquivos são reproduzíveis.
- ❌ **Sprint sem contract.** Generator entrega o que interpretou; evaluator julga o que imaginou. Expectativa desalinha.
- ❌ **Criteria sem hard threshold.** "Score médio 7" deixa passar feature que falha em usabilidade mas compensa em craft. Threshold por criterion força coerência.

## Materializações por ferramenta

Ver methodology/materializacoes ação "Arquitetura de harness multi-agente".

## Links

- Source: harness-design-anthropic
- Methodology consumers: methodology/30-skills-agents, methodology/40-execucao, methodology/50-qualidade-testes
- Related: [principios-transversais](./principios-transversais.md), [nfr-system-design](../concepts/nfr-system-design.md), [frameworks-comportamentais](../concepts/frameworks-comportamentais.md)
