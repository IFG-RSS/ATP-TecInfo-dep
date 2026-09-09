# Projeto 3 — Painel de indicadores

**Duração:** 24 aulas. **Base:** Farrer 1.11; adaptações de 1.12.2, 1.12.4, 1.12.6, 1.12.7 e 1.12.12.

## Situação-problema

A coordenação recebe registros um por vez e precisa produzir indicadores sem saber antecipadamente quantos registros chegarão. O grupo construirá o núcleo de um painel textual.

## Incrementos

1. **Quantidade conhecida:** leia as notas de `n` estudantes e informe média, maior, menor e quantos atingiram 60 pontos. Use `for` e trate `n = 0`.
2. **Sentinela:** processe compras até um código zero; totalize compra e venda e conte margens em três faixas. Adapta Farrer 1.12.4.
3. **Validação:** use `do while` para repetir a leitura até obter nota entre 0 e 100.
4. **Frequência:** para cada turma, processe presenças e calcule percentual de ausência, inspirado em 1.12.7/1.12.12.
5. **Simulação:** dado um valor inicial positivo, conte quantos intervalos são necessários para cair abaixo de um limite ao ser reduzido pela metade; converta o tempo total, adaptando 1.12.6.

## Investigue antes de codificar

Qual laço expressa melhor cada contrato? Quais variáveis são contadores, acumuladores ou estado anterior? Como inicializar maior e menor sem criar resultados falsos? Quando uma média não existe?

## Critérios de aceitação

Cada laço possui inicialização, condição de parada e progresso demonstráveis. O programa trata conjunto vazio, um elemento, empate nos extremos e limites das faixas.

**Entrega:** quatro programas incrementais, testes de mesa de um laço e painel final. Desafio individual: adaptar os indicadores a alturas, com base em Farrer 1.12.2.
