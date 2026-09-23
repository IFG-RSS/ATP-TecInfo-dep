# Material 6 — Matrizes

Apoia o [Projeto 6](../projetos/06-matrizes/README.md) (aulas 107–122 do [guia de avanço](../docs/guia-de-avanco.md#projeto-6)). Anterior: [Material 5](05-vetores-e-strings.md). Próximo: [Material 7](07-registros-integrador.md).

Os exemplos usam ingressos por sessão e dia, matrizes quadradas e faces de dado, e não a ocupação de laboratórios. Adapte as técnicas ao mapa de ocupação.

## Ao final você deve conseguir

- declarar matrizes e usar `m[i][j]` sabendo **qual índice é a linha e qual é a coluna**;
- distinguir dimensões **máximas** (declaradas) de dimensões **lógicas** (em uso);
- percorrer por linhas e por colunas com laços aninhados, calculando totais e extremos com posição;
- passar matrizes a funções e explicar por que a segunda dimensão é obrigatória;
- explicar a transposta e a tabela de frequências.

## 1. Matrizes

Uma **matriz** é uma tabela de valores do **mesmo tipo**, organizada em **linhas** e **colunas**. Cada elemento é identificado por dois índices, **sempre nesta ordem**: `m[linha][coluna]`. Como nos vetores, ambos começam em zero.

```c
int m[2][3] = {
    {10, 20, 30},    /* linha 0 */
    { 5,  0,  8}     /* linha 1 */
};
```

```text
              coluna 0   coluna 1   coluna 2
  linha 0   [   10    ][   20    ][   30    ]
  linha 1   [    5    ][    0    ][    8    ]

  m[0][2] = 30        m[1][0] = 5        m[1][1] = 0
```

Uma matriz é, na prática, um **vetor de vetores**: cada linha é um vetor de colunas.

### Dimensões máximas e dimensões lógicas

Como nos vetores, o tamanho declarado é fixo. Declare os **máximos** com `#define` e guarde as **dimensões em uso** em variáveis:

```c
#define MAX_L 10       /* máximo de linhas */
#define MAX_C 7        /* máximo de colunas */

int m[MAX_L][MAX_C];   /* capacidade: 10 x 7 */
int l;                 /* linhas em uso: 1 <= l <= MAX_L */
int c;                 /* colunas em uso: 1 <= c <= MAX_C */
```

Os laços usam `l` e `c`, **nunca** `MAX_L` e `MAX_C`; os máximos servem apenas para dimensionar e validar. Valide `l` e `c` **antes** de ler os dados.

Inicialização útil: `int m[MAX_L][MAX_C] = {0};` zera todas as posições.

## 2. Percursos com laços aninhados

Para visitar todos os elementos, use dois laços: um para as linhas e outro para as colunas.

**Por linhas** (a linha é o laço externo): útil para totais **por linha** e para imprimir.

```c
for (int i = 0; i < l; i++) {
    for (int j = 0; j < c; j++) {
        /* trata m[i][j] */
    }
}
```

**Por colunas** (a coluna é o laço externo): útil para totais **por coluna**.

```c
for (int j = 0; j < c; j++) {
    for (int i = 0; i < l; i++) {
        /* trata m[i][j] */
    }
}
```

O que muda é **quem fica fixo enquanto o outro varia**. Para o total de uma linha `i`, mantém-se `i` e varia-se `j`. Para o total de uma coluna `j`, mantém-se `j` e varia-se `i`. Se você não consegue dizer qual índice o laço interno varia, desenhe a matriz e trace o percurso com o dedo.

Atenção ao **acumulador**: ele deve ser **zerado a cada volta do laço externo**, se a soma é por linha (ou por coluna):

```c
for (int i = 0; i < l; i++) {
    int total_linha = 0;               /* zera a cada nova linha */
    for (int j = 0; j < c; j++) {
        total_linha += m[i][j];
    }
    /* usa total_linha */
}
```

Se o acumulador fosse declarado **fora** do laço externo, o total de cada linha incluiria as anteriores.

## 3. Matrizes e funções

Como nos vetores, a função trabalha sobre a **mesma matriz** do chamador. Duas regras específicas:

- o parâmetro precisa informar a **quantidade de colunas declarada**: `int m[][MAX_C]`. Sem ela, o compilador não sabe o tamanho de uma linha e não consegue calcular a posição de `m[i][j]`. O número de linhas é livre;
- passe também as **dimensões lógicas** `l` e `c`.

```c
int total_linha(int m[][MAX_C], int i, int c);
```

**Sobre `const`:** com vetores, `const int v[]` é a prática recomendada. Com matrizes, em C17 o compilador emite um aviso (`-Wpedantic`: *pointers to arrays with different qualifiers*) ao chamar a função com uma matriz comum. Como o curso exige compilar **sem avisos**, escreva o parâmetro **sem** `const` e registre no contrato da função que ela **só lê** a matriz.

## 4. Exemplo completo: ingressos por sessão e dia

Cada **linha** é uma sessão do cinema; cada **coluna**, um dia da semana; cada célula, os ingressos vendidos. O programa lê a matriz, imprime a tabela com totais e localiza a maior venda.

```c
/* ingressos.c */
#include <stdio.h>

#define MAX_L 10   /* sessoes */
#define MAX_C 7    /* dias */

/* Soma da linha i (colunas 0..c-1). So le a matriz. */
int total_linha(int m[][MAX_C], int i, int c) {
    int total = 0;
    for (int j = 0; j < c; j++) {
        total += m[i][j];
    }
    return total;
}

/* Soma da coluna j (linhas 0..l-1). So le a matriz. */
int total_coluna(int m[][MAX_C], int j, int l) {
    int total = 0;
    for (int i = 0; i < l; i++) {
        total += m[i][j];
    }
    return total;
}

/* Imprime a matriz l x c com cabecalhos e totais. So le a matriz. */
void imprimir(int m[][MAX_C], int l, int c) {
    printf("    ");
    for (int j = 0; j < c; j++) {
        printf("%5d", j + 1);
    }
    printf("  Total\n");

    for (int i = 0; i < l; i++) {
        printf("%3d|", i + 1);
        for (int j = 0; j < c; j++) {
            printf("%5d", m[i][j]);
        }
        printf("%7d\n", total_linha(m, i, c));
    }

    int geral = 0;
    printf("Tot|");
    for (int j = 0; j < c; j++) {
        int t = total_coluna(m, j, l);
        printf("%5d", t);
        geral += t;
    }
    printf("%7d\n", geral);
}

int main(void) {
    int m[MAX_L][MAX_C] = {0};
    int l;
    int c;

    printf("Sessoes (1 a %d) e dias (1 a %d): ", MAX_L, MAX_C);
    if (scanf("%d %d", &l, &c) != 2 || l < 1 || l > MAX_L || c < 1 || c > MAX_C) {
        printf("Dimensoes invalidas.\n");
        return 1;
    }

    for (int i = 0; i < l; i++) {
        printf("Sessao %d - vendas em %d dia(s): ", i + 1, c);
        for (int j = 0; j < c; j++) {
            if (scanf("%d", &m[i][j]) != 1 || m[i][j] < 0) {
                printf("Valor invalido.\n");
                return 1;
            }
        }
    }

    printf("\n");
    imprimir(m, l, c);

    int maior = m[0][0];
    int linha_maior = 0;
    int coluna_maior = 0;
    for (int i = 0; i < l; i++) {
        for (int j = 0; j < c; j++) {
            if (m[i][j] > maior) {
                maior = m[i][j];
                linha_maior = i;
                coluna_maior = j;
            }
        }
    }
    printf("\nMaior venda: %d (sessao %d, dia %d)\n", maior, linha_maior + 1, coluna_maior + 1);
    return 0;
}
```

```text
Sessoes (1 a 10) e dias (1 a 7): 2 3
Sessao 1 - vendas em 3 dia(s): 10 20 30
Sessao 2 - vendas em 3 dia(s): 5 0 8

        1    2    3  Total
  1|   10   20   30     60
  2|    5    0    8     13
Tot|   15   20   38     73

Maior venda: 30 (sessao 1, dia 3)
```

Pontos importantes:

- **Laços com `l` e `c`**, nunca com `MAX_L` e `MAX_C`: uma matriz `2 x 3` dentro de um espaço `10 x 7` só tem 6 valores em uso.
- A posição do maior guarda **duas** informações (`linha_maior` e `coluna_maior`), e os índices são convertidos para a contagem humana (`+ 1`) só na impressão.
- O maior começa em `m[0][0]` (o primeiro elemento), como nos vetores, e o `>` estrito mantém a **primeira** ocorrência em caso de empate.
- A matriz `1 x 1` funciona sem tratamento especial:

```text
Sessoes (1 a 10) e dias (1 a 7): 1 1
Sessao 1 - vendas em 1 dia(s): 7

        1  Total
  1|    7      7
Tot|    7      7

Maior venda: 7 (sessao 1, dia 1)
```

- **Sala vazia ou sessão sem venda?** Aqui `0` significa "nenhum ingresso vendido". Se fosse importante distinguir "sem venda" de "sessão que não ocorreu", seria preciso um valor especial (por exemplo `-1`) **excluído** dos totais e dos extremos.

### Testes para totais

Faça a conta à mão e confira as **somas cruzadas**: a soma dos totais das linhas deve ser igual à soma dos totais das colunas, e ambas iguais ao total geral. Casos: matriz `1 x 1`; uma única linha; uma única coluna; matriz cheia (`MAX_L x MAX_C`); matriz só de zeros; maior na primeira e na última posição; empate de máximos.

## 5. Transposta

A **transposta** de uma matriz `m` de `l x c` é a matriz `t` de **`c x l`** em que **linhas viram colunas**:

```text
  m (2 x 3)               t (3 x 2)
  10  20  30              10   5
   5   0   8              20   0
                          30   8

  t[j][i] = m[i][j]
```

Regras que orientam a implementação e os testes:

- as **dimensões trocam**: se `m` usa `l` linhas e `c` colunas, `t` usa `c` linhas e `l` colunas. Verifique que a capacidade de `t` comporta as novas dimensões (em um espaço `10 x 7`, uma transposta de `5 x 9` não caberia);
- a transposta é uma **nova matriz**: para uma matriz retangular, transpor "no lugar" não funciona;
- **transpor duas vezes** devolve a matriz original: excelente teste automático;
- na transposta, o que era total de linha vira total de coluna.

O exemplo a seguir usa matrizes **quadradas**, em que linha e coluna têm o mesmo tamanho `n`. Ele mostra outras relações entre índices: a **diagonal principal** (`m[i][i]`), a **diagonal secundária** (`m[i][n - 1 - i]`) e a **simetria** (`m[i][j] == m[j][i]`, isto é, a matriz é igual à própria transposta).

```c
/* diagonais.c */
#include <stdio.h>

#define MAX_N 10

/* Soma da diagonal principal. So le a matriz. */
int soma_diagonal_principal(int m[][MAX_N], int n) {
    int soma = 0;
    for (int i = 0; i < n; i++) {
        soma += m[i][i];
    }
    return soma;
}

/* Soma da diagonal secundaria. So le a matriz. */
int soma_diagonal_secundaria(int m[][MAX_N], int n) {
    int soma = 0;
    for (int i = 0; i < n; i++) {
        soma += m[i][n - 1 - i];
    }
    return soma;
}

/* Devolve 1 se m[i][j] == m[j][i] para todo i e j, e 0 caso contrario. */
int eh_simetrica(int m[][MAX_N], int n) {
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (m[i][j] != m[j][i]) {
                return 0;
            }
        }
    }
    return 1;
}

int main(void) {
    int a[MAX_N][MAX_N] = {{1, 2, 3}, {2, 5, 6}, {3, 6, 9}};
    int b[MAX_N][MAX_N] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};

    printf("A: principal %d, secundaria %d, simetrica %d\n",
           soma_diagonal_principal(a, 3), soma_diagonal_secundaria(a, 3), eh_simetrica(a, 3));
    printf("B: principal %d, secundaria %d, simetrica %d\n",
           soma_diagonal_principal(b, 3), soma_diagonal_secundaria(b, 3), eh_simetrica(b, 3));
    return 0;
}
```

```text
A: principal 15, secundaria 11, simetrica 1
B: principal 15, secundaria 15, simetrica 0
```

Repare em `j = i + 1` em `eh_simetrica`: basta comparar os elementos **acima** da diagonal com seus espelhos, e o laço interno parte de `i + 1`. Só faz sentido em matrizes **quadradas**.

## 6. Tabela de frequências

Para **contar quantas vezes cada valor ocorre**, use o próprio valor para escolher a posição de um **vetor de contadores**. Em vez de vários `if`, uma única linha:

```c
/* dado.c */
#include <stdio.h>

#define FACES 6

int main(void) {
    int rolagens[] = {3, 6, 2, 6, 1, 4, 6, 3, 5, 2, 7, 1, 1, 4, 3, 6, 2, 5, 6, 3};
    int total = (int)(sizeof rolagens / sizeof rolagens[0]);
    int freq[FACES] = {0};
    int invalidas = 0;

    for (int k = 0; k < total; k++) {
        int face = rolagens[k];
        if (face >= 1 && face <= FACES) {
            freq[face - 1]++;          /* face 1 usa a posição 0, e assim por diante */
        } else {
            invalidas++;
        }
    }

    printf("Face  Ocorrencias\n");
    for (int f = 0; f < FACES; f++) {
        printf("%4d  %5d  ", f + 1, freq[f]);
        for (int k = 0; k < freq[f]; k++) {
            printf("#");
        }
        printf("\n");
    }
    printf("Invalidas: %d\n", invalidas);
    return 0;
}
```

```text
Face  Ocorrencias
   1      3  ###
   2      3  ###
   3      4  ####
   4      2  ##
   5      2  ##
   6      5  #####
Invalidas: 1
```

Três cuidados:

- o **deslocamento**: o valor `1` vai para a posição `0` (`face - 1`); o índice precisa estar **dentro** de `0..FACES-1`, por isso os valores inválidos são separados **antes** de indexar (acessar `freq[6]` seria um acesso fora do vetor);
- a soma das frequências mais as inválidas deve ser igual ao total de respostas: use como teste;
- a tabela pode ter **duas dimensões** quando há duas variáveis cruzadas (por exemplo, opção de resposta por turma): cada célula conta as respostas de uma turma para uma opção.

## Erros comuns

- **Trocar linha e coluna**: escrever `m[j][i]` onde queria `m[i][j]`, ou laços na ordem inversa.
- **Percorrer até `MAX_L`/`MAX_C`** em vez de `l`/`c`: imprime e soma lixo.
- **Acumulador declarado fora do laço externo**, misturando linhas.
- **Esquecer a segunda dimensão** no parâmetro (`int m[][]` não compila).
- **`const` em parâmetro de matriz**, que gera aviso em C17.
- **Escrever `m[i, j]`**: o C aceita o texto (operador vírgula), mas significa outra coisa; use `m[i][j]`.
- **Dimensões da transposta** iguais às da original.
- **Não validar `l` e `c`** antes de ler ou percorrer.
- **Usar o valor lido como índice** de frequência sem conferir o intervalo.

## Autoteste

1. Em `int m[3][4]`, quantos elementos existem? Qual o último índice válido de cada dimensão?
2. Que soma o laço abaixo calcula, sabendo que `m` tem `l` linhas e `c` colunas?
   `for (int j = 0; j < c; j++) { soma += m[2][j]; }`
3. Quais as dimensões da transposta de uma matriz `4 x 6`? O elemento `m[1][3]` fica em que posição da transposta?
4. Por que `int m[][]` não é aceito como parâmetro de função?
5. Em um mapa de ocupação `m x n`, como você localizaria **a coluna** com o maior total?

<details>
<summary>Respostas</summary>

1. Doze elementos; último índice `2` nas linhas e `3` nas colunas.
2. A soma dos elementos da linha `2` (a terceira linha). Requer `l >= 3`.
3. `6 x 4`. O elemento `m[1][3]` fica em `t[3][1]`.
4. Sem o número de colunas, o compilador não sabe onde começa cada linha na memória e não consegue calcular a posição de `m[i][j]`.
5. Calcule o total de cada coluna (percurso por colunas) e, ao comparar, guarde **o índice** da coluna com maior total, e não só o valor, como em `linha_maior`/`coluna_maior`.

</details>

## Ligação com o Projeto 6

| Incremento do projeto | Onde estudar | Exemplo relacionado |
|---|---|---|
| 1. Ler e imprimir `m x n` com cabeçalhos | seções 1, 2 e 3 | `ingressos.c` (`imprimir`) |
| 2. Totais por linha, por coluna, geral e posição do maior | seções 2 e 4 | `ingressos.c` |
| 3. Transposta | seção 5 | regra `t[j][i] = m[i][j]`, dimensões trocadas |
| 4. Coluna de total por linha | seções 2 e 4 | `total_linha`; se o total ficar dentro da matriz, reserve uma coluna a mais na capacidade |
| 5. Tabela de frequências (5 opções) | seção 6 | `dado.c` |

| Questão de investigação | Onde |
|---|---|
| Qual laço percorre linhas e qual percorre colunas? | seção 2 |
| Quais dimensões tem a transposta? | seção 5 |
| Como representar uma sala vazia? | seção 4 (último tópico) |
| O maior valor basta ou também precisamos guardar sua posição? | seção 4 (`linha_maior` e `coluna_maior`) |

**Critérios de aceitação:** "dimensões respeitam os máximos" → seção 1; "todos os totais concordam" → somas cruzadas da seção 4; "matriz retangular e `1 x 1` funcionam" → seção 4; "transpor duas vezes recupera a original" → seção 5.

Para a **demonstração de um percurso**, use o esquema da seção 2: desenhe a matriz e mostre, seta a seta, a ordem em que os laços visitam os elementos.

## Para ir além

- Guardar a ocupação em **três dimensões** (laboratório × dia × horário) e discutir por que a leitura de `m[i][j][k]` fica difícil sem bons nomes.
- Detectar a **linha** de maior total além da posição do maior valor isolado.
- Escrever uma função que **soma duas matrizes** de mesmas dimensões e outra que as **multiplica** (linhas × colunas).

Próximo: [Material 7 — Registros e sistema modular](07-registros-integrador.md).
