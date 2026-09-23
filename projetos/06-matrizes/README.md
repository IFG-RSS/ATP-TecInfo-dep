# Projeto 6 — Mapa de ocupação

**Duração:** 16 aulas. **Base:** Farrer 2.2.2; adaptações de 2.5.2.2–2.5.2.7 e 2.5.2.9.

**Estude com:** [Material 6 — Matrizes](../../materiais/06-matrizes.md). **Ritmo sugerido:** [aulas 107–122 no guia de avanço](../../docs/guia-de-avanco.md#projeto-6).

## Situação-problema

A escola quer visualizar a ocupação dos laboratórios ao longo dos horários. Uma matriz armazena, por linha, um laboratório e, por coluna, um horário; cada célula contém a quantidade de estudantes.

Use dimensões máximas fixas e dimensões lógicas informadas pelo usuário:

```c
#define MAX_LABS 10
#define MAX_HORARIOS 12
```

## Incrementos

1. Leia e imprima uma matriz `m x n` com cabeçalho de linhas e colunas.
2. Calcule total por laboratório, total por horário, total geral e posição de maior ocupação. Adapta as somas de linha/coluna de 2.5.2.2/2.5.2.3.
3. Gere a transposta para inverter a perspectiva, com base em 2.5.2.6.
4. Acrescente uma coluna de total por linha, adaptação de 2.5.2.7.
5. Construa uma tabela de frequências para respostas de uma pesquisa de 5 opções, reduzindo o problema 2.5.2.9.

## Questões de investigação

Qual laço percorre linhas e qual percorre colunas? Quais dimensões tem a transposta? Como representar uma sala vazia? O maior valor basta ou também precisamos guardar sua posição?

## Critérios de aceitação

Dimensões respeitam os máximos; todos os totais concordam; matriz retangular e matriz `1 x 1` funcionam; transpor duas vezes recupera a matriz original.

**Entrega:** `ocupacao.c`, tabela de testes, representação desenhada da matriz e demonstração de um percurso.
