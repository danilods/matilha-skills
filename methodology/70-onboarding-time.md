---
type: methodology
phase: "70"
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: skeleton
maturity: v1
created: 2026-04-16
updated: 2026-04-17
tags: [methodology, team, onboarding, replication]
author: matilha
license: MIT
---

# 70 — Onboarding do time

> [!abstract] TL;DR
> Fase meta: como teammates absorvem esta metodologia para replicar a produtividade (projetos R$1M+ entregues em equivalente de 5-10 profissionais). Não é treinamento formal — é **projeto piloto supervisionado + consulta sistemática ao segundo cérebro**.
>
> **Status: `skeleton`** — estrutura proposta, nenhum teammate passou ainda. Upgrade para `deep` depois que ≥1 pessoa completar o ciclo e dar feedback. Esta é a fase mais suscetível a "morrer no papel" sem uso real.

## Quando esta fase se aplica

- Depois que v1 da metodologia está operacional (fases 10, 20, 30 em deep).
- Quando há um candidato a teammate para onboardar — seja dev interno, contratado, ou consultor.

## Gates de entrada (binários)

- [ ] Teammate candidato tem acesso ao vault Obsidian (ou export dele)
- [ ] Teammate tem Claude Code ou ferramenta equivalente configurada
- [ ] Slash command `/metodologia` instalado no projeto piloto (ver docs/templates/README-metodologia)
- [ ] Você (Danilo) tem bandwidth para ≥2h/semana de supervisão direta nas primeiras 4 semanas
- [ ] Projeto piloto escolhido — NÃO o projeto mais crítico (dívida de aprendizado); escopo claro e tempo delimitado

## Gates de saída (binários — só considerar teammate "autônomo" quando todos)

- [ ] Teammate completou um ciclo 10-PRD → 20-Stack → 30-Skills/Agents → 40-Execução em projeto piloto
- [ ] Teammate consulta `/metodologia` antes de cada fase (histórico nos logs do projeto mostra)
- [ ] Gates de saída das fases 10/20/30 atendidos sem sua intervenção direta no projeto piloto
- [ ] Teammate produziu ≥1 ADR (architecture decision record) sem ajuda
- [ ] Teammate identificou ≥1 regra da metodologia que precisava de ajuste e propôs update (feedback loop ativo)
- [ ] Code review do teammate não acusa violações sistemáticas (apenas bugs específicos aceitáveis)
- [ ] Teammate conseguiu retomar sessão depois de pausa de 3+ dias sem re-briefing (checkpoint discipline internalizada)

**Como estruturar a supervisão em cada ferramenta:** agnóstico. A disciplina de consulta e revisão é a mesma.

## ═══ BLOCO DENSO ═══

### Checklist operacional

- [ ] Semana 1 — Imersão: teammate lê `methodology/index` + `principios-transversais` + fases deep. Pair-programming em 1 task real.
- [ ] Semana 2 — Supervisionado: teammate pega projeto piloto, passa pelas fases 00, 10, 20. Você revisa cada gate de saída.
- [ ] Semana 3 — Solo com review: teammate implementa 30 + 40. Você revisa async, não pair.
- [ ] Semana 4 — Validação: teammate completa qualidade + deploy. Você valida que gates de saída estão atendidos sem override seu.
- [ ] Retrospectiva formal: o que a metodologia facilitou? O que atrapalhou? O que faltou? (feedback vira ingest novo no brain-dump).

### Regras invioláveis

1. **Projeto piloto ≠ projeto crítico.** Primeiro projeto do teammate não é o mais caro. Risco pedagógico tem custo.
2. **Consulta é obrigatória nas primeiras 3 semanas.** Teammate deve invocar `/metodologia <fase>` antes de cada fase mudar. Hábito > entendimento inicial.
3. **Feedback do teammate vira ingest.** O que eles acham confuso, redundante, ou faltante é sinal de lint para as páginas. Registre em `raw/methodology/` como novo brain-dump.
4. **Sem autonomia precoce.** Marcar teammate como "autônomo" antes dos gates de saída é mentira que explode em 3 meses.
5. **Sua supervisão é investimento, não custo.** Cada hora gasta nas primeiras 4 semanas economiza 10h nas próximas 12.

### Árvore de decisão

```
Perfil do teammate?
├── Dev sênior com Claude Code
│   ├── 4 semanas de supervisão leve (2h/sem)
│   ├── Foco: gates de saída + checkpoint discipline
│   └── Retro na semana 4 + ingest de feedback
│
├── Dev sênior sem Claude Code
│   ├── +1 semana de setup (Claude Code + MCP Obsidian + plugin superpowers + `/metodologia`)
│   ├── Pair-programming em 1 projeto pequeno pré-piloto
│   └── Depois segue trilha do sênior com CC
│
├── Dev médio/júnior
│   ├── 8 semanas de supervisão (1h/dia nos primeiros 10 dias)
│   ├── Projeto piloto MENOR ainda (bug-fix, feature isolada, não produto novo)
│   ├── Escalar complexidade gradualmente
│   └── Pareamento mais denso
│
└── Não-dev (PM, designer, analista)
    ├── Foco: fases 00, 10, 70 (pilares do produto)
    ├── Não esperar autonomia em 20/30/40/50/60
    └── Colaboração em vez de replicação
```

### Defaults e anti-padrões

**Defaults:**
- Projeto piloto: MVP de 2-3 semanas, arquétipo "MVP rápido" da fase 20.
- Ferramenta default: Claude Code + superpowers (a pilha mais madura da metodologia). Outras via [materializacoes](./materializacoes.md).
- Canal de comunicação: você + teammate + wiki acessível.
- Retro documentada: markdown em `raw/methodology/YYYY-MM-DD-onboarding-<nome>.md` (vira ingest do wiki).

**Anti-padrões:**
- ❌ "Aqui está o vault, boa sorte." Auto-didatismo sem supervisão = 80% de falha.
- ❌ Projeto piloto crítico. Pressão impede aprendizado.
- ❌ Presumir que o teammate vai ler 50 páginas do wiki antes de começar. Consulta just-in-time > leitura antecipada.
- ❌ Supervisionar sem deixar autonomia crescer. Cria dependência, não paridade.
- ❌ Pular a retro ("funcionou, vamos para próximo"). Feedback é o ingest que evolui a metodologia.

### Decisões de juízo (não-templatizáveis)

- **Quando encerrar a supervisão.** Sinal: teammate previu uma decisão de juízo antes de você comentar. Isso é internalização.
- **Quando adaptar a metodologia ao teammate vs. teammate à metodologia.** Se 3+ teammates relatam a mesma dificuldade em algo, a metodologia tem o bug, não eles. Atualize a página.
- **Quantos teammates onboardar em paralelo.** 1 por vez nas primeiras iterações. 2-3 em paralelo só quando você já teve ≥3 ciclos completos e tem templates sólidos.
- **Como valorizar teammate que desafia a metodologia.** Desafios válidos são ouro — atualizam o wiki. Desafios gratuitos (não seguem porque "não gosto") são risco. A diferença vive em: há evidência? Há proposta melhor?

## ═══ NARRATIVA ═══

### Racional

A razão de existir de toda a metodologia é esta fase. Se o segundo cérebro não produz teammates equivalentes, ele é uma ferramenta solo — útil, mas não o que o pedido original queria.

A disciplina "consulta obrigatória nas primeiras 3 semanas" é explícita porque a tentação de improvisar é gigante. Teammate que "não precisa consultar" no dia 3 está reproduzindo padrões pré-metodologia — e o valor da metodologia some.

Ver [hook-model](../concepts/hook-model.md) — a consulta sistemática à metodologia é um hábito que precisa de **trigger + action + reward + investment**. O trigger é a mudança de fase. A action é `/metodologia <fase>`. O reward é economia de tempo (gates claros, não precisa inventar). O investment é o próprio feedback loop.

### Exemplo real — placeholder (skeleton)

> [!todo] Calibração pendente
> **Nenhum teammate onboardou ainda.** Esta página é aspiracional até que ≥1 pessoa complete o ciclo. Primeiro ciclo será o experimento real — documentar TUDO via retro. Candidato a projeto piloto: um dos MVPs simples (kriativ, masterplan, CNH) com arquétipo bem definido.

### Armadilhas comuns

- **Cargo-cult.** Teammate segue as páginas sem entender o porquê. Antídoto: forçar discussão de "Decisões de juízo" — se não houver, teammate está só executando.
- **Metodologia como desculpa para micromanagement.** "Você não seguiu o passo X" quando o passo X era adaptável. A metodologia prescreve o que está no bloco denso, não cada linha de código.
- **Isolamento do teammate.** Metodologia poderosa + dev isolado não gera conhecimento no time. Force pareamento ou review cruzado.
- **Falta de feedback do teammate para as páginas.** Se 4 semanas depois a wiki não mudou, ou você não ouviu o feedback, ou o feedback veio e você não ingestiu. Ambos são bugs.

## Links

- Fase anterior: [60-deploy-infra](./60-deploy-infra.md)
- Fase seguinte: (ciclo reinicia em [00-mapeamento-problema](./00-mapeamento-problema.md) para novo projeto do teammate)
- Princípios: [principios-transversais](./principios-transversais.md)
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- Conceitos embasadores: [hook-model](../concepts/hook-model.md), [peak-end-rule](../concepts/peak-end-rule.md), [motivacao-comportamento](../concepts/motivacao-comportamento.md), [frameworks-comportamentais](../concepts/frameworks-comportamentais.md)
- Raw: 2026-04-15-danilo-brain-dump
