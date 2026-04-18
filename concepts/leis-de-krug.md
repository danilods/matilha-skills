---
type: concept
sources:
  - "krug-usabilidade"
created: 2026-04-11
updated: 2026-04-17
tags:
  - usability
  - laws
  - design-principles
  - krug
phase: reference
author: matilha
license: MIT
---

# Leis de Krug e Como Usamos a Web

## As 3 Leis

### 1a Lei: "Não me faça pensar"

- Princípio primordial. Se só puder gravar uma regra, grave esta
- Páginas devem ser evidentes (clear) ou pelo menos auto-explicativas (self-evident → self-explanatory)
- Cada dúvida consome do estoque limitado de paciência/boa vontade (reservatorio-boa-vontade)
- Exemplos: nomes claros vs engracadinhos ("Empregos" vs "Emprego-Rama"), botões que parecem botões, links que parecem links
- Amazon.com como exemplo: busca sem distinção Autor/Título/Palavra-chave — "por que eu deveria pensar em como o mecanismo quer que eu formule a pergunta?"
- Conexão com Weinschenk: cognicao-pensamento — progressive disclosure e cognitive load. memoria-cognicao — working memory limitada a 4 items justifica não sobrecarregar. atencao-foco — atenção de 7-10 min, scanning

### 2a Lei: "Não importa quantos cliques, desde que cada clique seja óbvio"

- Clareza > contagem de cliques. "Três cliques claros equivalem a um que requer raciocínio"
- Metáfora do Twenty Questions: "Animal, Vegetal ou Mineral?" — escolha sem raciocínio
- "Rastro da informação" (Jared Spool) — confiança contínua de estar no caminho certo
- Conexão: cognicao-pensamento — Fitt's Law, trade-off clicks vs thinking. Cognitive load < Visual load < Motor load

### 3a Lei: "Livre-se de metade das palavras e depois de metade das que restaram"

- E.B. White, "The Elements of Style": "Omita palavras desnecessárias"
- Dois inimigos: "papo bobo" (happy talk — texto introdutório sem valor) e instruções longas
- Efeitos de cortar: menos confusão visual, mais destaque ao útil, menos scroll
- Ninguém lê instruções — objetivo é eliminar a necessidade delas
- Exemplo Verizon: 115 palavras → 48 palavras sem perder informação
- Conexão: leitura-tipografia — pessoas escaneiam, não leem. atencao-foco — salient cues

## Os 3 Fatos

### Fato 1: Não lemos — damos uma olhada (scanning)

- Feito documentado: pouco tempo lendo, muito escaneando
- Razões: pressa, sabemos que não precisamos ler tudo, somos bons nisso (experiência com jornais/revistas)
- Metáfora Far Side de Gary Larson: cachorro ouve "bla bla GINGER bla bla GINGER"
- Focamos em: (a) palavras relacionadas à tarefa, (b) interesses pessoais, (c) gatilhos ("Grátis", "Venda", "Sexo", nosso nome)
- Conexão: percepcao-visual — scanning de telas, pessoas ignoram bordas. atencao-foco — atenção seletiva, captadores de atenção (perigo, comida, sexo)

### Fato 2: Não escolhemos o melhor — escolhemos o primeiro razoável (satisficing)

- Termo de Gary Klein: "satisficing" — primeiro plano razoável sem comparar opções
- Klein estudou bombeiros: não comparavam NENHUMA opção. Primeiro plano plausível → teste mental → ação
- Na web: baixa penalidade (botão Voltar), otimizar é caro/lento, adivinhar é mais divertido
- Conexão: tomada-decisao — decisões inconscientes (Bechara). processamento-inconsciente — maioria do processamento é inconsciente

### Fato 3: Não descobrimos como funciona — apenas atingimos o objetivo (muddling through)

- Pessoas usam coisas eficazmente sem compreendê-las (URL na caixa de busca do Yahoo)
- "Uma vez que encontramos algo que funciona, ficamos com ele" — mesmo se for subótimo
- Problema: muddling through é ineficiente e propenso a erros
- Conexão: erros-usabilidade — tipos de erros previsíveis. cognicao-pensamento — modelos mentais

## Design para o Mundo Real

> "Se seu público age como se você estivesse projetando um painel, então projete alguns muito bons."

### 5 Princípios do Cap 3

1. **Hierarquia visual clara** — proeminência = importância, relacionamento visual = relacionamento lógico, aninhamento mostra pertencimento
2. **Convenções** — só reinvente a roda se tiver uma ideia comprovadamente melhor ("Uau!")
3. **Áreas definidas** — dividir a página em áreas claramente separadas
4. **Clicáveis óbvios** — deixar evidente o que pode ser clicado
5. **Minimizar confusão** — dois tipos: "muito o que fazer" (shouting) e "confusão de segundo plano" (background noise)

---

Ver também: nao-me-faca-pensar, steve-krug, navegacao-web, reservatorio-boa-vontade, testes-usabilidade
