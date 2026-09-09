# Projeto 5 — Analisador de turma

**Duração:** 22 aulas. **Base:** Farrer 2.2.1; adaptações de 2.5.1.3–2.5.1.6, 2.5.1.8–2.5.1.11.

## Situação-problema

Para comparar resultados e localizar estudantes, o painel precisa manter uma coleção em memória. Nesta etapa, use vetores paralelos de matrícula e nota; registros virão depois.

## Incrementos

1. Leia `n` notas (`0 <= n <= 100`), liste-as, calcule média, extremos e frequências por faixa. Inspira-se em Farrer 2.5.1.5.
2. Busque uma matrícula e mostre a nota na mesma posição, adaptação de 2.5.1.9.
3. Remova notas duplicadas numa cópia e explique por que o vetor original não deve ser perdido.
4. Ordene matrículas e mantenha a correspondência com as notas. Compare seleção direta e troca de pares.
5. Intercale duas listas já ordenadas, adaptando Farrer 2.5.1.10.
6. Em uma frase lida com `fgets`, conte espaços, vogais e pares repetidos, inspirado em 2.5.1.3.

## Funções esperadas

```c
int buscar(const int valores[], int n, int procurado);
double media(const double valores[], int n);
void ordenar_pares(int matriculas[], double notas[], int n);
int intercalar(const int a[], int na, const int b[], int nb, int saida[]);
```

## Critérios de aceitação

Nenhum acesso sai de `0..n-1`; `n = 0` e `n = 1` são definidos; busca ausente retorna `-1`; ordenação preserva a associação matrícula–nota; texto não ultrapassa o buffer.

**Entrega:** biblioteca de vetores, analisador, testes de função e uma explicação visual de índice versus valor.
