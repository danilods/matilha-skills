---
type: concept
sources:
  - "[building-effective-agents-anthropic](../concepts/building-effective-agents-anthropic.md)"
created: 2026-04-16
updated: 2026-04-17
tags: [concept, agents, patterns, aci, workflows]
phase: reference
author: matilha
license: MIT
---

# Agentic Patterns

Taxonomia de padrões composáveis para sistemas agentic. Do mais simples ao mais autônomo. Escolher o padrão certo para a tarefa é o que diferencia agentic system efetivo de overengineering.

> [!abstract] Princípio mestre
> Start simples. Só adicione complexidade quando demonstravelmente melhora resultados. Frameworks aceleram start mas obscurecem internals — prefira LLM APIs diretas quando produção se aproxima.

## Workflow × Agent — a distinção-chave

- **Workflow**: LLM + tools em caminho de código PRÉ-DEFINIDO. Previsível, testável, controlável.
- **Agent**: LLM direciona DINAMICAMENTE seu próprio fluxo. Flexível, potente, menos previsível.

Escolha baseada em: a tarefa é bem-definida (workflow) ou aberta (agent)?

## Os padrões (em ordem crescente de autonomia)

### 0. Augmented LLM (building block)
LLM + retrieval + tools + memory. Base de tudo. MCP como materialização possível.

### 1. Prompt Chaining
Decomposição em passos sequenciais. Cada chamada processa output da anterior. Gates programáticos opcionais entre passos.

**Usar quando**: task decomponível em passos fixos. Trade: latência por acurácia.

### 2. Routing
Classificar input → direcionar para sub-task especializada. Separação de concerns.

**Usar quando**: categorias distintas beneficiam de handling separado; classificação é accurate.
**Uso prático**: routing por custo (Haiku para triviais, Opus para complexos).

### 3. Parallelization
Sub-tasks simultâneas, outputs agregados. Duas formas:
- **Sectioning**: sub-tasks independentes.
- **Voting**: mesma task N vezes, diversidade.

**Usar quando**: paralelismo possível; múltiplas perspectivas aumentam confiança.
**Uso prático**: guardrails (um agente processa query, outro screen content); code review por voting (múltiplos prompts com critérios diferentes).

### 4. Orchestrator-Workers
Orchestrator decompõe DINAMICAMENTE (não pre-fixado). Delega a workers. Sintetiza.

**Usar quando**: sub-tasks imprevisíveis a priori.
**Uso prático**: coding tasks onde arquivos a mudar dependem do input.

### 5. Evaluator-Optimizer
Gerador + avaliador em loop. Refina iterativamente.

**Usar quando**: critérios claros + refinamento iterativo agrega valor mensurável.
**Sinais de fit**: output melhora com feedback humano articulado; LLM consegue dar esse feedback.
**Overlap com**: [harness-engineering](../concepts/harness-engineering.md) (Planner/Generator/Evaluator é a instância multi-agente + sprint contract desse padrão).

### 6. Agent autônomo
LLM em loop, usando tools, ganhando ground truth do ambiente a cada step (tool results, code execution). Pausa em checkpoints/blockers. Stopping condition (max iterations).

**Usar quando**: problema aberto, passos imprevisíveis, ambiente confiável.
**Custo**: alto. Erros compostos. Sandbox + guardrails obrigatórios.
**Uso prático**: SWE-bench, computer use.

## Árvore de decisão: qual padrão escolher?

```
A task tem critério binário de sucesso e passos previsíveis?
├── SIM → Workflow
│   ├── Passos sequenciais fixos? → Prompt Chaining
│   ├── Categorias de input? → Routing
│   ├── Sub-tasks independentes? → Parallelization (sectioning)
│   ├── Precisa de múltiplas opiniões? → Parallelization (voting)
│   ├── Sub-tasks imprevisíveis a priori? → Orchestrator-Workers
│   └── Precisa refinamento iterativo com critério? → Evaluator-Optimizer
│
└── NÃO (aberto, autonomia necessária) → Agent
    ├── Ambiente confiável e sandbox viável? → Prossiga com agent
    └── Custos compostos preocupam? → Volte para workflow ou adicione guardrails
```

## 3 princípios-núcleo (mandatórios)

1. **Simplicity** — menos scaffolding > mais scaffolding. Complexidade custa debuggability.
2. **Transparency** — mostrar planning steps explícitos do agente. Caixa-preta em produção = risco.
3. **Careful ACI** — Agent-Computer Interface via tool documentation + testing.

## ACI (Agent-Computer Interface)

Tools são o que liga o LLM ao mundo. Design de tools é tão crítico quanto design de prompts.

### Princípios de ACI design

1. **Formato próximo ao que o modelo viu em texto natural** da internet. JSON com escape custa mais que markdown.
2. **Sem overhead de formatação** — não exija contagem exata de linhas, escape de aspas.
3. **Dê tokens para "pensar"** antes de escrever em canto sem saída (reasoning tags, planning steps).
4. **Poka-yoke** — mude argumentos para erros serem difíceis. Ex: exigir caminho absoluto em vez de relativo evita confusão após `cd`.
5. **Coloque-se no lugar do modelo**. Tool descriptions são docstrings para junior dev. Exemplos, edge cases, formato, limites.
6. **Teste iterativamente** no workbench. Observe erros reais. Itere.

**Observação forte**: no SWE-bench da Anthropic, otimização de tools deu **mais valor** do que otimização do prompt.

## Quando usar framework vs raw API

| Situação | Recomendação |
|---|---|
| Prototipação rápida, exploratório | Framework (Claude Agent SDK, Strands, Rivet) |
| Produção com debugging preciso | LLM API direta |
| Framework é usado mas problema persiste | Inspect o código por baixo — abstrações escondem bugs |

## Quando NÃO usar agentic system

Alguns problemas ficam melhor com:
- Single LLM call + retrieval + in-context examples.
- Traditional code (sem LLM).
- Workflow simples sem agência.

Agentic systems trocam **latência e custo** por **performance em task**. A troca só vale quando a task de fato exige.

## Ligações com o resto do vault

- [harness-engineering](../concepts/harness-engineering.md) — Evaluator-Optimizer levado a arquitetura multi-agente com Planner/Generator/Evaluator + sprint contract. Extensão natural deste concept para long-running.
- [agent-centric-codebase](../concepts/agent-centric-codebase.md) — playbook de como estruturar repo para viabilizar agents autônomos (padrão 6).
- methodology/30-skills-agents — fase da metodologia que escolhe padrão por projeto.
- [nfr-system-design](../concepts/nfr-system-design.md) — NFRs determinam escolha (latência high = cuidado com padrões caros; complexidade low = single LLM basta).
- [leis-de-krug](../concepts/leis-de-krug.md) — "Don't make me think" aplica-se ao próximo modelo/agent lendo a tool. ACI é UX para LLMs.

## Antipadrões

- ❌ **Agente autônomo quando workflow resolveria.** Custo/latência injustificados.
- ❌ **Framework sem entender o underlying.** Quando debuga, descobre que abstração não era o que parecia.
- ❌ **ACI genérica tipo "file tool aceita qualquer path"** em vez de poka-yoke. Erros silenciosos.
- ❌ **Tool description vaga** — economiza tokens agora, custa horas de debug depois.
- ❌ **Transparency sacrificada** — agente que não explica o plano é agente que você não pode avaliar.

## Links

- Source: [building-effective-agents-anthropic](../concepts/building-effective-agents-anthropic.md)
- Concepts relacionados: [harness-engineering](../concepts/harness-engineering.md), [agent-centric-codebase](../concepts/agent-centric-codebase.md)
- Methodology consumers: methodology/30-skills-agents, methodology/20-stack, methodology/50-qualidade-testes
