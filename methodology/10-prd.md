---
type: methodology
phase: "10"
archetype: any
sources:
  - "2026-04-15-danilo-brain-dump"
status: deep
maturity: v1
created: 2026-04-15
updated: 2026-04-17
tags: [methodology, prd, requirements]
author: matilha
license: MIT
---

# 10 — PRD (Product Requirements Document)

> [!abstract] TL;DR
> Transforma o problema mapeado (fase 00) num documento denso de requisitos funcionais e não-funcionais que serve de "fundação do prédio". O PRD é o artefato mais caro de refazer — tempo gasto aqui se paga 10× nas fases seguintes.

## Quando esta fase se aplica

- Problema foi identificado e validado (fase 00 concluída ou, no mínimo, "dor confirmada com stakeholder").
- Existe convicção mínima de que a solução é software (nem sempre é — às vezes o processo manual resolve).
- O PRD é obrigatório mesmo para MVPs de 2 semanas. Muda o nível de detalhe, não a existência.

## Gates de entrada (binários — não avance sem atender)

- [ ] Resultado do mapeamento do problema existe (documento, notas, transcrição, deep research)
- [ ] Tipo do produto declarado: **próprio** (deep research web feito) OU **institucional** (documentação interna consolidada)
- [ ] Persona(s) identificada(s) — ao menos perfil + dor principal

Sem os 3 items, volte à fase 00. Começar PRD sem gates de entrada = PRD de ficção.

## Gates de saída (binários — só passe adiante quando todos estiverem atendidos)

- [ ] SSoT em markdown único (`docs/PRD-<produto>.md`), versionado em git
- [ ] RFs enumerados (`RF-001`…`RF-N`) com critério de aceitação **binário** (passa/não-passa) cada
- [ ] RNFs cobrem: performance, segurança, disponibilidade, latência, escalabilidade, acessibilidade
- [ ] Persona(s) consolidada(s) com JTBD (job-to-be-done) explicitado
- [ ] Riscos listados com probabilidade + impacto (L/M/H)
- [ ] Premissas listadas (o que você assume sem evidência firme)
- [ ] Stack candidata sinalizada (input para fase 20 — não é decisão final)
- [ ] Métricas: norte star metric + 2-3 KPIs secundários (pelo menos hipóteses)
- [ ] AHA moment identificado (menor experiência que convence o usuário do valor)
- [ ] ≥1 revisor não-autor leu e fez só perguntas de "como", não de "o quê"

Se faltar qualquer item, o PRD não está maduro. Volte a iterar até todos serem ✅.

**Como executar o brainstorm que gera esse PRD em cada ferramenta:** ver [materializacoes](./materializacoes.md) (ação "Brainstorm estruturado" e ação "Escrever spec/PRD").

## ═══ BLOCO DENSO (acionável) ═══

### Checklist operacional

- [ ] Problema está escrito em 1 parágrafo claro (sem jargão, alguém de fora entende?)
- [ ] Persona(s) definida(s) com nome fictício, perfil, dor, JTBD
- [ ] RFs enumerados e cada um tem critério de aceitação binário (passa/não-passa)
- [ ] RNFs cobrem: performance, segurança, disponibilidade, latência, escalabilidade, acessibilidade
- [ ] Contradições entre RFs foram identificadas e resolvidas (ou flaggadas como risco)
- [ ] Fluxo(s) principal(is) do usuário desenhado(s) (pode ser bullet list ou diagrama)
- [ ] AHA moment identificado — qual é a menor experiência que convence o usuário do valor?
- [ ] Freemium vs pago: se existir modelo freemium, limites definidos explicitamente (tempo, funcionalidades, volume)
- [ ] Riscos listados com probabilidade + impacto (L/M/H basta)
- [ ] Premissas listadas (o que você está assumindo sem evidência firme)
- [ ] Stack candidata (não é definição — é sinalização para a fase 20)
- [ ] Métricas: norte star metric + 2-3 KPIs secundários
- [ ] PRD foi revisado com brainstorm estruturado (ver [materializacoes](./materializacoes.md) ação "Brainstorm estruturado") até os gates de saída serem atendidos

### Regras invioláveis

1. **Single source of truth.** O PRD é UM arquivo markdown. Não espalhe requisitos em múltiplos docs/slides/planilhas. Se alguém perguntar "qual é o requisito X?", a resposta é "PRD seção Y".
2. **RFs enumerados e rastreáveis.** `RF-001` até `RF-N`. Sem número = sem rastreabilidade = sem priorização = sem teste.
3. **Critério de aceitação binário.** "O sistema deve ser rápido" NÃO é critério. "Resposta em <200ms no P95" SIM.
4. **Persona real, não inventada.** Use dados (entrevista, transcrição, forum, analytics). Persona que não vem de evidência é ficção.
5. **O PRD não é o brainstorm.** Brainstorm gera ideias; PRD é o subconjunto curado, priorizado e factível. Se tudo que surgiu no brainstorm entrar no PRD, o PRD vira wish-list.
6. **Iteração > perfeição.** PRD v1 sai em horas, não dias. Itere com stakeholders. v3 é onde fica bom.

### Árvore de decisão

```
Tipo do produto?
├── Próprio
│   ├── Deep research feito? → Sim → Extrair dores, concorrentes, posicionamento → Consolidar em seção "Contexto do mercado" do PRD
│   │                       → Não → FAZER ANTES (fase 00). Não escreva PRD sem entender o mercado.
│   └── Existe concorrente direto? → Sim → Seção "Competitive analysis" obrigatória no PRD
│                                  → Não → Mapear alternativas indiretas (planilha, manual, nada)
├── Institucional
│   ├── Setor tem documentação? → Sim → Ingerir tudo, consolidar, gerar expand com LLM
│   │                           → Não → Entrevista com stakeholder (gravar, transcrever, consolidar)
│   └── Sistemas legados existem? → Sim → Mapear interfaces e restrições (são RNFs)
│                                 → Não → Campo aberto — foco em JTBD puro
```

### Defaults e anti-padrões

**Defaults:**
- Formato PRD: markdown com frontmatter, seções padronizadas (Contexto, Personas, RFs, RNFs, Riscos, Métricas, Stack candidata).
- Brainstorm estruturado obrigatório antes da escrita — gates de saída do brainstorm em [materializacoes](./materializacoes.md).
- Nome do arquivo: `docs/PRD-<NOME-PRODUTO>.md` ou `docs/PRD-MASTER-<NOME>.md` quando for single source.
- Tamanho esperado: 1.000-3.000 linhas para produto real. 200-500 para MVP rápido.

**Anti-padrões:**
- ❌ PRD em Google Docs/Notion sem versionamento. Use markdown+git.
- ❌ PRD sem RNFs ("só precisa funcionar"). Performance, segurança e latência são invisíveis até falharem em prod.
- ❌ "PRD orgânico" — requisitos que surgem durante o código sem voltar ao PRD. O PRD é a fundação: se muda a planta, atualiza a planta.
- ❌ PRD que é ata de reunião glorificada. Ata ≠ requisito.
- ❌ PRD que omite freemium/limites. Se existe freemium, os limites são requisitos (ver Speechia: "não fui limitado após 5 min — isso é perigoso").

### Decisões de juízo (não-templatizáveis)

- **Escopo do MVP vs v1 completo.** Cortar features é fácil em slides e doloroso no código. A decisão "isso entra no v1?" precisa de: (a) qual é o AHA moment? (b) essa feature contribui para o AHA? (c) se não, ela contribui para retenção? Se nenhuma das três, sai.
- **Quando o PRD está "maduro o suficiente".** PRD perfeito não existe — perfeito é inimigo do entregue. Sinais de maturidade: RFs cobrem o AHA moment end-to-end; ao menos 1 pessoa não-autora leu e não fez pergunta de "o quê" (só de "como"); estimativa de esforço é factível no prazo.
- **Nível de detalhe das regras de negócio.** Muito vago → equipe interpreta errado. Muito detalhado → engessamento desnecessário. Heurística: se dois devs lerem o RF e implementarem coisas diferentes, o RF está vago demais.
- **Quando aceitar que o problema mudou.** Se durante a construção do PRD você descobre que o problema original não é real, tenha coragem de pivotar para outro problema em vez de escrever um PRD bonito para um problema falso.

## ═══ NARRATIVA ═══

### Racional

O PRD é chamado de "fundação do prédio" no brain-dump porque seus artefatos se propagam para as fases seguintes:
- Fase 20 (Stack) consome os RNFs para tomar decisões de latência, escala, disponibilidade — sem eles, stack é chute.
- Fase 30 (Skills/Agents) consulta os RFs para criar skills especializadas por domínio — sem eles, skills são genéricas.
- Fase 50 (Qualidade) deriva test cases dos critérios de aceitação dos RFs — sem eles, testes testam "o que o agente quis", não "o que o produto deveria fazer".

A conexão com [leis-de-krug](../concepts/leis-de-krug.md) é direta: "Não me faça pensar" se aplica ao consumidor do PRD (dev, agente, stakeholder) tanto quanto ao usuário do produto. Um PRD confuso faz o agente tomar decisões próprias — que podem divergir do que o produto precisa.

A conexão com [jtbd-positioning](../concepts/jtbd-positioning.md) é fundamental na construção de personas: JTBD Forces of Progress (Push/Pull/Anxiety/Habit) dão vocabulário preciso para articular dores em vez de genéricos ("o usuário quer facilidade").

### Exemplo real — adedonha

O projeto adedonha tem **dois PRDs** que ilustram dois momentos diferentes:

1. `PRD Jogo Adedonha_Stop Inovador.md` (68KB) — PRD estratégico, com análise de mercado, monetização, posicionamento. Escrito antes de qualquer código. Mais próximo de um business case + PRD híbrido.
2. `adedonha-prd-artifact.md` (50KB) — PRD técnico, gerado via brainstorm com Claude Code + superpowers. Contém RFs enumerados, architecture decisions, stack definida.

O CLAUDE.md de adedonha evidencia a materialização: lista regras como "Zero pay-to-win", "Server-authoritative", "WCAG 2.1 AA" que vieram do PRD e se tornaram regras de projeto. Isso é a **propagação** funcionando: PRD → CLAUDE.md → skills → hooks.

O que funcionou: dois PRDs separando estratégia de técnica. O que poderia melhorar: consolidar em 1 PRD com seções internas (Contexto + RFs + RNFs) — dois arquivos criam risco de divergência.

### Exemplo real — fluency

O fluency tem `docs/PRD-MASTER-AMIGO-DE-BOLSO.md` com 3.000+ linhas — single source of truth. O CLAUDE.md declara explicitamente: "**PRD Master (single source of truth):** — Read this FIRST for any implementation question." Isso é a regra 1 (SSoT) em prática.

437 test cases derivados diretamente dos business rules do PRD (`docs/plans/test-cases-cobertura-regras-negocio.md`). Isso demonstra a cadeia PRD → test cases em ação.

### Armadilhas comuns

- **PRD que cresce sem revisão.** O PRD-MASTER de fluency tem 3.000 linhas. Em algum ponto, partes se contradizem sem que ninguém perceba. Mitigação: lint periódico do PRD (mesmo manualmente: "leia seções X e Y — elas concordam?").
- **Deep research que nunca acaba.** Produto próprio com deep research infinito = procrastinação disfarçada. Defina um timebox (4h) e aceite o que tiver.
- **Persona inventada retrospectivamente.** "Ah, o João é nosso usuário ideal" — mas João nunca foi entrevistado, é o que o fundador imagina. Sem evidência, é ficção.
- **PRD como arma política.** Em contexto institucional, o PRD pode ser usado para "provar" que uma solução específica é necessária. O PRD deve mapear o PROBLEMA, não a solução que alguém já escolheu.

## Links

- Fase anterior: [00-mapeamento-problema](./00-mapeamento-problema.md)
- Fase seguinte: [20-stack](./20-stack.md)
- Princípios: [principios-transversais](./principios-transversais.md)
- **Materializações por ferramenta:** [materializacoes](./materializacoes.md)
- Conceitos embasadores: [leis-de-krug](../concepts/leis-de-krug.md), [jtbd-positioning](../concepts/jtbd-positioning.md), [aarrr-growth-metrics](../concepts/aarrr-growth-metrics.md), [hook-model](../concepts/hook-model.md), [peak-end-rule](../concepts/peak-end-rule.md)
- Análise relacionada: 2026-04-14-adedonha-engagement-blueprint
- Raw: 2026-04-15-danilo-brain-dump
