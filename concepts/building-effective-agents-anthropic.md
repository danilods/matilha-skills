---
type: concept
sources:
  - "Clippings/Building Effective AI Agents"
created: 2026-04-16
updated: 2026-04-17
tags: [source, agents, anthropic, patterns, aci]
phase: reference
author: matilha
license: MIT
---

# Building Effective AI Agents

Artigo oficial da Anthropic (Erik S. + Barry Zhang). URL: `https://www.anthropic.com/engineering/building-effective-agents`.

> [!quote] Tese central
> "As implementações de mais sucesso não usaram frameworks complexos — usaram padrões simples e composáveis. Busque a solução mais simples; só adicione complexidade quando demonstravelmente melhora resultados."

## Definições-chave

- **Workflow**: LLMs e tools orquestrados via **caminhos de código pré-definidos**.
- **Agent**: LLM direciona dinamicamente seu próprio processo e uso de tools.
- Ambos são **agentic systems**. A escolha é sobre previsibilidade (workflow) vs flexibilidade (agent).

## 5 padrões composáveis (do mais simples ao mais complexo)

### 1. Augmented LLM (building block)
LLM + retrieval + tools + memory. Base de tudo. MCP é uma materialização possível.

### 2. Prompt Chaining
Decompor tarefa em sub-tasks sequenciais. Cada LLM call processa output do anterior. Gates programáticos entre passos.

**Usar quando**: tarefa decomponível em passos fixos. Trade-off: latência por acurácia.
**Exemplo**: gerar outline → validar outline → escrever doc baseado no outline.

### 3. Routing
Classificar input e direcionar para sub-task especializada. Separação de concerns + prompts focados.

**Usar quando**: categorias distintas que beneficiam de handling separado; classificação accurate (por LLM ou classifier).
**Exemplo**: queries fáceis → Haiku 4.5; queries difíceis → Sonnet 4.5.

### 4. Parallelization
Rodar LLMs simultâneos, agregar outputs. Duas variações:
- **Sectioning**: sub-tasks independentes em paralelo.
- **Voting**: mesma task N vezes, diversidade de outputs.

**Usar quando**: parallelismo possível; múltiplas perspectivas aumentam confiança.
**Exemplo voting**: review de código — múltiplos prompts procuram vulnerabilidades com critérios diferentes.

### 5. Orchestrator-Workers
Orchestrator decompõe DINAMICAMENTE (não pre-definido) e delega a workers. Sintetiza resultados.

**Usar quando**: não dá pra prever sub-tasks necessárias.
**Exemplo**: coding tasks onde número de arquivos a mudar depende do input.

### 6. Evaluator-Optimizer
Um LLM gera; outro avalia e dá feedback em loop. Refina iterativamente.

**Usar quando**: critérios claros de avaliação + refinamento iterativo agrega valor mensurável. Sinais de fit: (a) resposta melhora com feedback humano articulado; (b) LLM consegue dar esse feedback.
**Exemplo**: tradução literária com nuances; search task que decide se precisa mais rodadas.

### 7. Agent (autônomo)
LLM usando tools em loop, com feedback ambiental (tool results, code execution). Pausa em checkpoints / blockers. Terminal quando task completa.

**Usar quando**: problema aberto, passos imprevisíveis, ambiente de confiança para autonomia.
**Riscos**: custo alto, erros compostos. Sandbox + guardrails.
**Exemplo**: SWE-bench, computer use.

## 3 princípios-núcleo ao construir agents

1. **Simplicity** — manter simplicidade no design.
2. **Transparency** — mostrar passos de planejamento explícitos do agente.
3. **ACI deliberada** — craft do Agent-Computer Interface via tool documentation + testing.

## ACI (Agent-Computer Interface) — Appendix 2

Tools são a parte crítica. "Quanto esforço vai em HCI, invista igual em ACI."

**Princípios de tool design:**
- **Dê tokens para o modelo "pensar"** antes de escrever em canto que não tem saída.
- **Formato próximo ao que o modelo viu naturalmente em texto da internet**. JSON com escape é mais custoso que markdown.
- **Sem overhead de formatação** — não exija contagem exata de linhas, escape de aspas, etc.
- **Poka-yoke** — mude argumentos para tornar erros difíceis. Ex: tool exigindo caminho absoluto em vez de relativo evita "cd errado" confundir o agente.
- **Coloque-se no lugar do modelo.** A tool é óbvia? Tem exemplo, edge cases, formato claro?
- **Teste iterativamente** no workbench, observe erros, refine.
- **No SWE-bench, otimização de tools foi MAIS valor do que otimização do prompt.**

## Frameworks vs raw

- Frameworks (Claude Agent SDK, Strands, Rivet, Vellum) aceleram start mas adicionam abstração que obscurece prompts/responses.
- Recomendação: começar com **LLM APIs diretas**. Muitos padrões implementáveis em poucas linhas.
- Se usar framework: entenda o código por baixo. "Incorrect assumptions about what's under the hood are a common source of customer error."

## Aplicações com ajuste forte observado

- **Customer support**: conversa + ações + critério claro de sucesso + usage-based pricing possível.
- **Coding agents**: verificável por testes, iteração via test results, problema bem-definido.

## Conexão com o vault

- Cluster com harness-design-anthropic e [codex-agent-centric-world-openai](../concepts/codex-agent-centric-world-openai.md): este artigo é o **catálogo de padrões**; os outros são **aplicações avançadas**.
- Concept derivado: [agentic-patterns](../concepts/agentic-patterns.md) — padrões consumidos por methodology/30-skills-agents.
- ACI princípios alimentam methodology/30-skills-agents (como desenhar tools) e methodology/50-qualidade-testes (poka-yoke como defesa).

## Links

- Clipping: Clippings/Building Effective AI Agents
- Concept derivado: [agentic-patterns](../concepts/agentic-patterns.md)
- Related: [harness-engineering](../concepts/harness-engineering.md), [agent-centric-codebase](../concepts/agent-centric-codebase.md), [nfr-system-design](../concepts/nfr-system-design.md), [leis-de-krug](../concepts/leis-de-krug.md) (ACI = "don't make me think" aplicado a LLM)
