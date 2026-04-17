---
type: concept
sources:
  - "Clippings/Alavancando o Codex em um mundo centrado no agente"
created: 2026-04-16
updated: 2026-04-17
tags: [source, agents, openai, codex, agent-centric, harness]
phase: reference
author: matilha
license: MIT
---

# Alavancando o Codex em um mundo centrado no agente

Post oficial da OpenAI (Ryan Lopopolo, equipe técnica). Publicado 2026-02-11. URL: `https://openai.com/pt-BR/index/harness-engineering/`.

> [!quote] Tese central
> "Construímos 1M+ linhas de código com **0 linhas escritas por humanos** — 1.500 PRs em 5 meses, 7 engenheiros. Humanos dirigem, agentes executam. O trabalho humano deixou de ser código e passou a ser: projetar ambientes, especificar intenções, construir ciclos de feedback."

## Contexto e escala

- 5 meses, 7 engineers (começou com 3), 1.500 PRs merged, ~1M linhas de código.
- 3,5 PRs/engineer/day — produtividade AUMENTOU conforme time cresceu.
- Produto real, com usuários internos + alfa-testers externos.
- Estimado: 1/10 do tempo vs. código manual.

## Princípio central: "Humans drive, agents execute"

**O que humanos fazem:**
- Priorizar o trabalho.
- Transformar feedback do usuário em critérios de aceitação.
- Validar resultados.
- Quando agente trava: identificar o que está faltando (tooling, docs, guardrails) e fazer o próprio Codex escrever o fix.

**O que agentes fazem:**
- Código de produto + testes + config de CI + ferramentas internas + documentação + observabilidade + scripts que gerenciam o próprio repo + arquivos de dashboards + arnês de avaliação + comentários de review.

## Bootstrap de repo vazio

Primeiro commit em repo vazio, agosto 2025. Estrutura inicial (repo structure, CI config, formatação, pacotes, app) **gerada por Codex CLI + GPT-5** guiado por templates mínimos. Até `AGENTS.md` inicial foi escrito por Codex.

## Base de conhecimento: AGENTS.md como ÍNDICE, não enciclopédia

### O que NÃO funciona: "one big AGENTS.md"

Falhas previsíveis:
- **Contexto é escasso** — arquivo gigante ocupa janela, ofusca código/docs relevantes.
- **Excesso de orientação é não-orientação** — "tudo importante" = nada importante.
- **Apodrece rápido** — monolito = cemitério de regras obsoletas.
- **Difícil verificar mecanicamente** (cobertura, frescor, propriedade).

### O que funciona: AGENTS.md ≈ 100 linhas, indexa `docs/` estruturado

```
AGENTS.md                    ← mapa, ~100 linhas
ARCHITECTURE.md
docs/
├── design-docs/
│   ├── index.md
│   ├── core-beliefs.md
│   └── ...
├── exec-plans/               ← planos versionados + logs de progresso
│   ├── active/
│   ├── completed/
│   └── tech-debt-tracker.md
├── product-specs/
├── references/               ← llms.txt de deps importantes
├── generated/                ← docs geradas (db-schema, etc.)
├── DESIGN.md
├── FRONTEND.md
├── PLANS.md
├── PRODUCT_SENSE.md
├── QUALITY_SCORE.md
├── RELIABILITY.md
└── SECURITY.md
```

- **Progressive disclosure**: agente começa pelo `AGENTS.md` pequeno, segue ponteiros para o que precisa. Não afoga no primeiro turn.
- **Linters dedicados + CI** validam frescor, interlinkagem, estrutura da base de conhecimento.
- **Recurring "janitor" agent** detecta documentação obsoleta e abre PRs de correção.
- Planos efêmeros (leves) para mudanças pequenas; `exec-plans/` para trabalhos complexos.

## Legibilidade pelo agente como objetivo arquitetural

> "Do ponto de vista do agente, qualquer coisa que ele não consiga acessar no contexto enquanto está em execução, efetivamente não existe."

Implicações:
- Discussões de Slack que não viram docs = invisíveis.
- Conhecimento tácito em cabeças humanas = invisível.
- **Reg: artefatos versionados LOCAIS do repo são a única fonte acessível.**

### Tecnologias "chatas" ganham

- APIs estáveis, composição clara, boa representação no training set.
- **Em alguns casos, reimplementar subset é MAIS barato** do que contornar biblioteca opaca.
- Exemplo: em vez de `p-limit` genérico, implementaram helper próprio com OTel instrumentação, 100% coverage, comportamento exato.

## Ferramentas legíveis para o agente

### Aplicativo controlável via Chrome DevTools MCP
Codex seleciona alvo → captura snapshot do DOM antes/depois → observa eventos runtime → aplica fix → reinicia → valida. **Ciclo de feedback completo sem humano.**

### Observability stack local, efêmero por worktree
- Logs → Vector → Victoria Logs (LogQL)
- Métricas → Victoria Metrics (PromQL)
- Rastreamentos → Victoria Traces (TraceQL)
- Apagados quando task termina.

**Viabiliza instruções tipo**: "garanta que startup < 800ms" ou "nenhum span nessas 4 jornadas críticas excede 2s". Concreto, verificável pelo agente.

### Worktree-per-change
App inicializável por Git worktree → Codex roda instância isolada por alteração.

### Rotinas de 6+ horas autônomas
"Regularmente vemos execuções únicas do Codex trabalhando em uma única tarefa por mais de seis horas (muitas vezes enquanto os humanos estão dormindo)."

## Arquitetura rígida, imposta por linters

Cada domínio de negócio = conjunto fixo de camadas com direções de dependência estrita:

```
Types → Config → Repo → Service → Runtime → UI
                 ↑
              Providers  (auth, conectores, telemetria, feature flags — única interface para cross-cutting)
```

- Linters custom (gerados por Codex) validam dependency edges.
- Testes estruturais enforcement.
- "Invariantes de gosto" também codificados: structured logging, naming conventions, file size limits, platform reliability.

> "Com agentes de codificação, arquitetura rígida é pré-requisito inicial, não luxo de 100-engineer-company. As restrições são o que permite velocidade sem deterioração."

### Mensagens de erro como input

- Como lints são custom, escreveram mensagens de erro para **inserir instruções de correção no contexto do agente**.
- Erro ≠ "seu código está errado" — erro = "faça X, ver Y". Próxima iteração do Codex já sabe como consertar.

## Throughput vs merge philosophy

- Repo opera com **mínimo de bloqueios em merge**.
- PRs curtos. Instabilidades de teste → re-runs, não blockers.
- Em baixa throughput, seria irresponsável. Em alta throughput, correções são baratas, esperar é caro.

## Gestão de entropia: "Golden Principles" + garbage collection

**Problema**: Codex replica padrões existentes (mesmo ruins). Drift acumula.

**Solução**: 
- "Princípios de ouro" codificados no repo: regras mecânicas opinativas (ex: "prefira utility packages compartilhados"; "não faça polling YOLO — valide boundaries ou confie em SDKs tipados").
- **Recurring background Codex tasks** verificam drift, atualizam quality ratings, abrem PRs de refactor específico.
- Maioria dessas PRs revisáveis em <1 min e merge automático.
- Tech debt como empréstimo com juros altos — pagar continuamente > acumular.

## Nível máximo de autonomia atingido

Com o scaffolding completo, com UM comando o agente:
- Valida estado atual
- Reproduz bug relatado
- Grava vídeo demonstrando falha
- Implementa correção
- Valida correção rodando app
- Grava segundo vídeo demonstrando resolução
- Abre PR
- Responde feedback de agents e humanos
- Detecta e corrige falhas de build
- Recorre a humano SÓ se precisar decisão
- Consolida mudança

## Lições para metodologia

1. **AGENTS.md como índice** (+ `docs/` estruturado) >>> monolito.
2. **Tudo agent-readable**: docs, observability, Chrome DevTools, observability stack.
3. **Arquitetura rígida imposta por linters** é acelerador, não freio.
4. **Mensagens de erro de lint são canal** entre linter e agente — escreva-as como instruções.
5. **Tech debt GC contínuo** por background agents é sustentável; limpeza em rajadas não.
6. **Janitor agent** para doc rot é padrão emergente.
7. **Ralph Wiggum loop**: agente itera até todos revisores agente + humano estarem satisfeitos.

## Links

- Clipping: Clippings/Alavancando o Codex em um mundo centrado no agente
- Concept derivado: [agent-centric-codebase](../concepts/agent-centric-codebase.md)
- Related: [harness-engineering](../concepts/harness-engineering.md), [agentic-patterns](../concepts/agentic-patterns.md), [building-effective-agents-anthropic](../concepts/building-effective-agents-anthropic.md)
- Methodology consumers: methodology/20-stack (tech chata ganha), methodology/30-skills-agents (AGENTS.md como índice, ACI), methodology/40-execucao (Ralph Wiggum, worktree-per-change), methodology/50-qualidade-testes (linters custom, erro como input)
