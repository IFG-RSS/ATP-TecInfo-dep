# Projeto 2 — Triagem de bolsas

**Duração:** 18 aulas. **Base:** Farrer 1.10; a classificação por faixas prepara os problemas 1.12.4 e 1.12.12.

## Situação-problema

Uma comissão precisa aplicar regras públicas de prioridade sem produzir classificações contraditórias. O programa recebe renda por pessoa, frequência, situação documental e modalidade, e emite decisão e justificativa.

## Regras iniciais

- documentação incompleta implica `PENDENTE`;
- frequência abaixo de 75 implica `INAPTO`;
- com documentos e frequência adequados: renda até 0,5 salário de referência é prioridade `A`; até 1,0 é `B`; acima disso é `CADASTRO_RESERVA`;
- modalidade deve ser `I` (integrado) ou `S` (subsequente); outro código é inválido.

O salário de referência é uma entrada para que o exercício não dependa de valor legal mutável.

## Incrementos

1. Modele as regras numa tabela de decisão e identifique precedência e fronteiras.
2. Implemente com `if`/`else if` garantindo uma única classificação.
3. Use `switch` para validar e nomear a modalidade.
4. Crie testes imediatamente abaixo, igual e acima de cada limite.

## Desafio inspirado em Farrer 1.12.4

Classifique a margem de um produto em três faixas definidas pela equipe. Compare a estrutura dessa decisão com a triagem e explique quando condições independentes seriam incorretas.

**Entrega:** tabela de decisão, Portugol, `triagem.c`, matriz de testes e parecer de equidade sobre as regras fornecidas.
