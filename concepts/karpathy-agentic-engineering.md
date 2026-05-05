---
type: concept
status: deep
maturity: v1
created: 2026-05-05
updated: 2026-05-05
tags: [karpathy, software-3, agentic-engineering, vibe-coding, methodology]
sources:
  - "Andrej Karpathy - Software 2.0"
  - "Andrej Karpathy - From vibe coding to agentic engineering"
author: matilha
license: MIT
---

# Karpathy - Software 3.0 e agentic engineering

> [!abstract] TL;DR
> Matilha adota Karpathy como regra de maturidade: **vibe coding e bom para explorar, agentic engineering e obrigatorio para shippar**. Prompts, skills, docs, evals e tools sao software de terceira camada: precisam de versao, contrato, teste e revisao como qualquer codigo.

## Tese

Karpathy descreve tres camadas que coexistem:

1. **Software 1.0** - codigo classico escrito em linguagens formais.
2. **Software 2.0** - redes neurais treinadas; comportamento codificado em pesos.
3. **Software 3.0** - programas escritos em linguagem natural para LLMs: prompts, regras, skills, AGENTS.md, CLAUDE.md, evaluators, tool descriptions e docs que guiam agentes.

Matilha trata Software 3.0 como parte do produto, nao como conversa descartavel.

## Regras para Matilha

### 1. Vibe coding e spike, nao delivery

Use vibe coding quando a pergunta ainda e "qual e a forma disso?". Vale para:

- descobrir API de biblioteca;
- explorar uma UI ou fluxo;
- testar uma arquitetura em pequena escala;
- gerar alternativas antes de escolher uma direcao.

Nao use vibe coding como criterio de pronto. Para virar entrega, o spike precisa ser promovido para:

- spec ou decisao registrada;
- plano de execucao;
- testes ou evals;
- commit revisavel;
- cleanup do que foi descartado.

### 2. Prompt e codigo

Qualquer instrucao que muda comportamento do agente e software:

- `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.cursor/rules/*.mdc`, `CONVENTIONS.md`;
- `SKILL.md`;
- slash commands;
- hook descriptions;
- tool schemas e descriptions;
- kickoff prompts;
- review/evaluator prompts.

Regras:

- versionar;
- manter pequeno e navegavel;
- preferir exemplos concretos;
- testar manualmente ou com smoke quando alterar comportamento;
- remover prompt morto como remove codigo morto.

### 3. Agentic engineering e loop fechado

O loop minimo para trabalho serio:

1. Humano define intencao, restricoes e criterio de valor.
2. Agente transforma em artefato estruturado: spec, plano, patch, review ou teste.
3. Ambiente devolve feedback objetivo: typecheck, tests, build, browser, logs, diff, reviewer.
4. Agente ajusta com base no feedback.
5. Humano decide trade-offs e finaliza.

Sem feedback objetivo, o agente esta apenas narrando.

### 4. O ambiente e a verdadeira interface

A qualidade do agente depende menos de "prompt magico" e mais do ambiente:

- arquivos de entrada pequenos e estaveis;
- docs como source of record;
- tool descriptions claras;
- comandos de verificacao simples;
- erros legiveis;
- repo facil de navegar;
- worktrees e checkpoints para tarefas longas.

Isso conecta diretamente com ACI, context engineering e agent-centric codebase.

## Gate de promocao: spike -> engineering

Antes de manter uma saida de vibe coding:

- [ ] O problema que o spike resolveu foi nomeado?
- [ ] A solucao escolhida foi registrada em doc, ADR, spec ou plano?
- [ ] Alternativas descartadas foram removidas do codigo?
- [ ] Existe teste, eval, smoke manual ou checklist objetivo?
- [ ] O diff esta pequeno o bastante para review humano?
- [ ] As instrucoes persistentes afetadas foram atualizadas?

Se qualquer resposta for "nao", o trabalho ainda e exploracao.

## Aplicacao nas fases Matilha

| Fase | Aplicacao Karpathy |
|---|---|
| 00 | Vibe coding permitido para explorar problema, mas descobertas precisam virar notas de discovery. |
| 10 | Prompt do usuario vira PRD: linguagem natural ganha contrato. |
| 20 | Stack privilegia ambiente observavel e testavel para agentes. |
| 30 | Skills, rules, hooks e tool descriptions sao Software 3.0 versionado. |
| 40 | Execucao exige loop fechado: agente + ambiente + checkpoint. |
| 50 | Evals/testes sao compilador do Software 3.0. |
| 60 | Deploy fecha a realidade: observabilidade e rollback substituem confianca narrativa. |
| 70 | Time aprende a editar metodologia como edita codigo. |

## Anti-padroes

- "Funcionou na conversa" como criterio de pronto.
- Prompt persistente sem versao ou dono.
- Skill longa que vira dump de conhecimento sem criterio de acionamento.
- Agent autonomo sem sandbox, budget, checkpoint ou eval.
- Refatorar com LLM sem diff pequeno e sem teste antes/depois.
- Guardar exploracoes mortas porque "talvez ajude depois".

## Links

- Metodologia: [index](../methodology/index.md)
- Fase 30: [skills-agents](../methodology/30-skills-agents.md)
- Fase 40: [execucao](../methodology/40-execucao.md)
- Qualidade: [50-qualidade-testes](../methodology/50-qualidade-testes.md)
- Relacionados: [agentic-patterns](./agentic-patterns.md), [context-engineering](./context-engineering.md), [agent-centric-codebase](./agent-centric-codebase.md), [harness-engineering](./harness-engineering.md), [agent-evaluation](./agent-evaluation.md)
