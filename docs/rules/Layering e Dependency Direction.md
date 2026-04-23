---
title: Layering e Dependency Direction
date: 2026-04-21
version: 0.1.0
alwaysApply: false
---

## Princípios Fundamentais

**DEPENDÊNCIAS APONTAM SEMPRE PARA O DOMÍNIO, NUNCA EM SENTIDO CONTRÁRIO**

Arquitetura em camadas não é sobre "quantas pastas" — é sobre direção. O núcleo
do sistema (regras de negócio, máquina de estados, invariantes) não pode saber
que AWS existe, que DynamoDB existe, que Slack existe. Quem sabe disso são as
bordas. O núcleo é puro; as bordas são adaptadores.

### Regras Fundamentais

1. **Domínio no centro, infraestrutura na borda**
   - Regras de negócio (ex.: "um alvo com `status = PENDING_AI` precisa passar
     por triagem semântica antes de notificar") vivem em código que não importa
     `boto3`, `pg8000`, nem SDK de Slack.
   - Infraestrutura (Lambda handlers, clientes AWS, repositórios Postgres) é
     periferia. Elas traduzem eventos/inputs externos em chamadas de domínio.

2. **Lambda Chain é uma pipeline, não uma bagunça**
   - Cada Lambda do Argos (Cleaner → Classifier → Extractor → Router → Notifier)
     é um adaptador finíssimo que faz: (1) parse do evento de entrada,
     (2) chama função de domínio pura, (3) escreve estado/publica evento.
   - Nenhuma Lambda conhece a próxima. O acoplamento é via estado (Dynamo/PG)
     ou via evento (EventBridge), nunca via import.

3. **Handlers são burros, domínio é inteligente**
   - Se um `lambda_handler` tem mais de 30 linhas úteis, tem lógica demais.
     Extrai pra uma função de domínio chamada por ele.
   - O handler deve fazer: parse, validação leve, delegação, serialização de
     saída. Qualquer decisão condicional que não seja sobre *shape do evento*
     não pertence ali.

4. **Regra da seta invertida**
   - Se você precisa importar algo de `infrastructure/` dentro de `domain/`,
     está errado. A dependência é injetada (protocolo/interface) ou o código
     pertence à outra camada.
   - Exemplo concreto no Argos: `domain.change_detection.classify(diff)` é
     pura — recebe diff como string, retorna `Classification` enum. Quem
     chama OpenAI/Bedrock é `infrastructure.ai_client.summarize()`, injetada
     via parâmetro na Lambda `analyze_change`.

### Camadas Típicas em Projetos Como Argos e Gravicode

```
┌─────────────────────────────────────────────┐
│  adapters/     (Lambda handlers, FastAPI)   │  ← bordas
├─────────────────────────────────────────────┤
│  application/  (use cases, orquestração)    │
├─────────────────────────────────────────────┤
│  domain/       (regras, estados, events)    │  ← núcleo
├─────────────────────────────────────────────┤
│  infrastructure/ (DynamoDB, PG, S3, Redis)  │  ← bordas
└─────────────────────────────────────────────┘
```

- `adapters/` e `infrastructure/` são as bordas. Ambas dependem de `domain/`.
- `domain/` nunca importa nada das bordas. Se precisa de I/O, recebe um
  protocolo (interface) no construtor/parâmetro.

## Padrões na Prática

### Argos — Lambda Chain `ContentProcessed`

A pipeline `Cleaner → Classifier → Extractor → Router → Notifier` é
implementada como cinco Lambdas, mas o *raciocínio* vive em módulos puros:

```python
# infrastructure/lambdas/classifier_handler.py  (borda — 20 linhas)
def lambda_handler(event, context):
    payload = parse_content_processed(event)          # adapter
    classification = classify_content(payload.text)   # domínio (puro)
    persist_classification(payload.id, classification) # infra
    publish_if_critical(payload.id, classification)    # infra
```

```python
# domain/classification.py  (núcleo — sem AWS, sem IO)
def classify_content(text: str) -> Classification:
    """Pure. Same input → same output. Testable offline."""
    if _looks_like_gabarito(text):
        return Classification.CRITICO
    if _looks_like_noise(text):
        return Classification.IRRELEVANTE
    return Classification.INFORMATIVO
```

Benefício real observado: quando precisei trocar o modelo de SLM (Phi-3-mini →
Gemini Flash), mexi apenas em `infrastructure/ai_client.py`. `domain/` não
sofreu uma linha de diff. Quando precisei adicionar nova categoria de
conteúdo (Súmulas), mexi apenas em `domain/classification.py` — nenhuma
Lambda precisou ser reescrita.

### Gravicode — Agent Viewer desacoplado do Orchestrator

O frontend (`gravicode-ai-soul`) consome um stream de eventos do Orchestrator
via WebSocket. O Orchestrator não sabe que existe um Viewer — emite eventos
de estado. Qualquer cliente pode consumir. Isso é dependency direction
aplicada entre processos: o *backend* define o contrato de eventos; o
*frontend* adapta-se a ele, nunca o contrário.

Sinal: quando o product manager pede "quero mostrar um novo painel no
Viewer", você mexe **só no frontend** — o backend já emite tudo que o
domínio conhece. Se a resposta for "preciso adicionar um evento novo no
Orchestrator pra isso", a fronteira está vazando.

## Sinais de Alerta

### Violações que indicam a seta apontando pro lado errado

- **Import de SDK dentro do domínio**: `from boto3` ou `import psycopg` em
  qualquer arquivo de `domain/` é red flag. Sempre.
- **Teste de domínio que precisa de Docker/LocalStack**: se um teste de
  regra de negócio exige subir DynamoDB local, a regra de negócio está
  acoplada a DynamoDB. Separe.
- **Handler com mais de ~30 linhas úteis**: provavelmente tem domínio
  escondido ali dentro. Extraia.
- **"Vou colocar esse if aqui no handler porque é mais rápido"**: nunca é
  mais rápido. É dívida técnica imediata. O próximo que ler o handler vai
  procurar lógica *lá* em vez de no domínio e vai sofrer.
- **`utils.py` gigante**: geralmente é domínio mal nomeado. Se a função
  pertence ao negócio (ex.: `detect_gabarito_pattern`), mora em `domain/`.
  Se é de fato util (serialização, formatação de data), mora em
  `infrastructure/`.

### Violações de pipeline (Lambda Chain específica)

- **Lambda que conhece a próxima**: `classifier_handler` não pode
  importar `extractor_handler` — elas se comunicam via evento/estado.
- **Lambda que faz trabalho de duas**: se `classifier` também extrai
  entidades, quebre em dois. Lambdas coesas são baratas; Lambdas
  multifunção são difíceis de testar e de reprocessar.
- **Cascateamento síncrono via chamada direta**: se `lambda A` invoca
  `lambda B` via `boto3.client("lambda").invoke()`, você recriou a
  orquestração push-driven que a coreografia event-driven veio resolver.
  Use eventos.

### Teste de fumaça

Abra um arquivo aleatório de `domain/`. Se ele:
- importa `boto3`, SDK AWS, ORM, cliente HTTP → quebrado
- tem função que chama `time.sleep`, `datetime.now()` sem injeção → frágil
- referencia `os.environ` → acoplado a ambiente
→ está na camada errada, ou precisa de abstração.

## Conexões

- Pipeline de Lambdas: ver skill `swarch-lambda-chain-shape`
- Event-driven decoupling: ver regra `Event-Driven Decoupling.md`
- Bounded contexts: ver regra `Bounded Contexts na Prática.md`
