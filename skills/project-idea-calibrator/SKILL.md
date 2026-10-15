---
name: project-idea-calibrator
description: Gera ideias de projetos de software calibradas ao nível do usuário em cada tecnologia mencionada, de qualquer camada (APIs web, front-end, mobile, CLIs, sistemas, embarcados, Assembly). Use quando o usuário pedir ideias do que construir ou praticar com uma stack, linguagem ou conceito (ex. "ideias de projeto com ASP.NET e Swagger", "o que posso fazer em Assembly x86?", "projeto pra treinar ponteiros em C", "project ideas for Rust"). Não use quando o usuário já tem um projeto definido e quer ajuda para implementá-lo.
---

# Calibrador de Ideias de Projetos

O objetivo é só entregar ideias de projeto focadas exatamente nas tecnologias e conceitos que o usuário descreveu. Não implemente, não planeje e não amplie o escopo para outras tecnologias.

A mesma ideia pode ser trivial para um avançado e inviável para um iniciante. Por isso, entenda o nível antes de sugerir.

## Etapa 1: Sondagem

Se o pedido não citar nenhuma tecnologia, área ou conceito (ex. "me dá uma ideia de projeto"), pergunte primeiro qual stack ou área o usuário quer praticar e só depois siga.

Identifique cada tecnologia ou conceito mencionado e pergunte, **numa única mensagem curta**:

1. **Nível em cada tecnologia**:
   - **Iniciante**: nunca usou ou só viu o básico.
   - **Intermediário**: já fez algo simples e entende o fluxo principal.
   - **Avançado**: domina recursos complexos, arquitetura e otimizações.
2. **Ambiente**, só quando a tecnologia depende dele: sistema operacional e arquitetura para Assembly e programação de sistemas (ex. x86-64 Linux, ARM64 macOS), placa ou hardware disponível para embarcados (ex. Arduino, ESP32, nenhum), plataforma alvo para mobile (Android, iOS).
3. **Objetivo** (opcional): aprender um conceito, montar portfólio ou se preparar para entrevista.

Pule o que já estiver claro na mensagem. Se o usuário responder só parte, assuma "Intermediário" nos níveis faltantes, o ambiente mais comum (ex. x86-64 Linux, nenhum hardware) e "aprender" como objetivo, e diga o que assumiu.

## Etapa 2: Três ideias calibradas

Proponha 3 ideias práticas e diferentes entre si, centradas nas tecnologias descritas e compatíveis com o ambiente informado. Evite exercícios genéricos como to-do list, CRUD de biblioteca, "hello world" ou calculadora simples.

Varie o tamanho: em geral, uma ideia curta, uma média e uma longa. Se o objetivo for portfólio, prefira ideias com resultado demonstrável (deploy, demo, README com prints); se for entrevista, ideias que exercitem os conceitos mais cobrados da stack.

Para cada ideia:

1. **Nome e conceito**: o que o programa faz, em 1–2 frases.
2. **Por que se encaixa no seu nível**: como cada tecnologia será exigida. Puxe mais nas tecnologias em que o usuário é mais fraco, sem deixar trivial o que ele domina. Exemplos:
   - Swagger iniciante: geração automática e anotações básicas.
   - Swagger avançado: múltiplos documentos OpenAPI, filtros customizados e JWT na UI.
   - Assembly iniciante: aritmética, laços e syscalls de I/O.
   - Assembly avançado: manipulação direta de memória, convenções de chamada, interrupções e otimização por ciclos.
3. **Escopo**: fim de semana, 1–2 semanas ou mais de 1 mês, considerando o nível informado.
4. **Ponto de partida**: 3–4 peças concretas para começar, no formato natural da stack. Podem ser rotas (APIs), telas (front/mobile), comandos (CLIs), funções ou módulos (bibliotecas, C/Rust), ou rotinas, syscalls e registradores envolvidos (Assembly, embarcados).
5. **Desafio bônus**: um passo um pouco além do nível atual.

## Formato da resposta

Use exatamente esta estrutura para cada ideia, na língua do usuário:

```markdown
### 1. Encurtador de URLs com métricas

Uma API que encurta links e registra quantos acessos cada um recebeu, por dia e por origem.

**Por que se encaixa no seu nível:** ASP.NET (intermediário) exige middleware próprio para contar acessos e injeção de dependência no repositório; Swagger (iniciante) fica na geração automática, com exemplos de request e response nas anotações.

**Escopo:** fim de semana

**Ponto de partida:**
- `POST /links` cria o link curto
- `GET /{code}` redireciona e registra o acesso
- `GET /links/{code}/stats` devolve as métricas
- Swagger com exemplos em cada rota

**Desafio bônus:** expirar links por data e documentar o erro 410 no Swagger.
```

Entregue as três ideias e encerre. Não ofereça próximos passos nem faça perguntas adicionais.
