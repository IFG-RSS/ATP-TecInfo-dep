# Projeto 1 — Cantina sem calculadora

**Duração:** 18 aulas. **Base:** Farrer 1.1–1.9 e problemas sequenciais que antecedem 1.12.

## Situação-problema

A cantina estudantil registra vendas manualmente. Ela precisa de um programa que calcule subtotal, desconto previamente informado, valor final e troco, sem decidir ainda quem recebe desconto.

## Incrementos

1. **Conversor:** transforme uma duração em segundos para horas, minutos e segundos; investigue quociente e resto.
2. **Pedido:** leia quantidades e preços de três itens, calcule subtotal, desconto percentual e total.
3. **Fechamento:** leia valor recebido, calcule troco e apresente todos os valores com duas casas decimais.
4. **Transferência:** adapte a solução para uma papelaria com outros itens e uma taxa fixa, sem copiar o código.

## Questões de investigação

Quais dados são inteiros ou reais? Quando uma constante é apropriada? Qual a precedência dos operadores? Por que `10 / 4` pode diferir de `10.0 / 4`? O que compilador, ligador e executável fazem?

## Critérios de aceitação

Aceite quantidades não negativas, preços e valor recebido não negativos, desconto entre 0 e 100. Nesta etapa, assuma entradas dentro do contrato. A saída deve identificar subtotal, desconto, total e troco. Compile sem avisos.

**Entrega:** tabela de tipos, Portugol, `cantina.c`, ao menos seis testes e explicação de uma expressão escolhida.
