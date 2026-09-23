# Material 5 — Vetores e strings

Apoia o [Projeto 5](../projetos/05-vetores-e-strings/README.md) (aulas 85–106 do [guia de avanço](../docs/guia-de-avanco.md#projeto-5)). Anterior: [Material 4](04-funcoes.md). Próximo: [Material 6](06-matrizes.md).

Os exemplos usam gols de um campeonato, estoque de produtos e frases, e não notas e matrículas. Os nomes das funções também diferem dos pedidos no projeto: a adaptação é da equipe.

## Ao final você deve conseguir

- declarar vetores, distinguir **capacidade** (tamanho físico) de **quantidade** (tamanho lógico) e nunca acessar fora de `0..n-1`;
- percorrer vetores para listar, somar, achar extremos com posição e contar por faixa;
- escrever funções que recebem vetores (com `const` quando só leem) e o tamanho;
- implementar busca sequencial, ordenação por seleção e o percurso com dois índices;
- manter **vetores paralelos** consistentes;
- ler e processar textos com `fgets` sem ultrapassar o buffer.

## 1. Vetores

Um **vetor** guarda vários valores do **mesmo tipo**, em posições numeradas a partir de **zero**. Ele resolve o problema de ter uma variável para cada valor.

```c
int gols[5];                    /* 5 posições: gols[0], gols[1], ..., gols[4] */
int zeros[5] = {0};             /* todas as posições valem 0 */
int fixos[] = {2, 0, 5, 3, 1};  /* o compilador conta: 5 posições */
```

```text
índice:   0    1    2    3    4
valor:  [ 2 ][ 0 ][ 5 ][ 3 ][ 1 ]
```

**Índice não é valor.** `fixos[2]` é o valor guardado na posição 2, que é `5`. Para `n` posições, os índices válidos vão de `0` a `n - 1`.

### Capacidade e quantidade

Em C, o tamanho de um vetor é fixo na declaração. Para dados que variam, declare uma **capacidade máxima** e mantenha uma variável com a **quantidade em uso**:

```c
#define MAX_PARTIDAS 100      /* capacidade */
int gols[MAX_PARTIDAS];
int n;                        /* quantidade em uso: 0 <= n <= MAX_PARTIDAS */
```

Só as posições `0..n-1` têm dados válidos; o resto é lixo. **Valide `n` antes de ler**.

### Acesso fora dos limites

`gols[5]` em um vetor de 5 posições **não é verificado** pelo compilador nem pelo programa: lê ou escreve em memória que não é sua. O comportamento é **indefinido**: pode dar resultado errado, travar ou "funcionar" por acaso e falhar em outro computador. Por isso a regra do curso é: **nenhum acesso fora de `0..n-1`**. Erros clássicos: laço com `i <= n`, `n` maior que a capacidade, índice negativo (por exemplo, o `-1` devolvido por uma busca sem resultado, usado como posição).

Para achar esses defeitos, compile com sanitizers durante os testes:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion -fsanitize=address,undefined programa.c -o build/programa
```

## 2. Percursos básicos

Quase tudo com vetores é um **laço `for` de `0` até `n - 1`** com uma variável de apoio: acumulador (soma), extremo (maior/menor), contador (faixas).

```c
/* gols.c */
#include <stdio.h>

#define MAX_PARTIDAS 100

/* Soma os n primeiros valores. */
int soma(const int valores[], int n) {
    int total = 0;
    for (int i = 0; i < n; i++) {
        total += valores[i];
    }
    return total;
}

/* Devolve a posicao do maior valor (a primeira, se houver empate).
   Devolve -1 se n <= 0. */
int posicao_do_maior(const int valores[], int n) {
    if (n <= 0) {
        return -1;
    }
    int pos = 0;
    for (int i = 1; i < n; i++) {
        if (valores[i] > valores[pos]) {
            pos = i;
        }
    }
    return pos;
}

int main(void) {
    int gols[MAX_PARTIDAS];
    int n;

    printf("Quantas partidas (0 a %d)? ", MAX_PARTIDAS);
    if (scanf("%d", &n) != 1 || n < 0 || n > MAX_PARTIDAS) {
        printf("Quantidade invalida.\n");
        return 1;
    }
    if (n == 0) {
        printf("Sem partidas.\n");
        return 0;
    }

    for (int i = 0; i < n; i++) {
        printf("Gols da partida %d: ", i + 1);
        if (scanf("%d", &gols[i]) != 1 || gols[i] < 0) {
            printf("Valor invalido.\n");
            return 1;
        }
    }

    printf("Gols:");
    for (int i = 0; i < n; i++) {
        printf(" %d", gols[i]);
    }
    printf("\n");

    int total = soma(gols, n);
    int pos = posicao_do_maior(gols, n);
    printf("Total: %d  Media: %.2f\n", total, (double)total / n);
    printf("Mais gols: %d (partida %d)\n", gols[pos], pos + 1);

    int baixa = 0;
    int media = 0;
    int alta = 0;
    for (int i = 0; i < n; i++) {
        if (gols[i] <= 1) {
            baixa++;
        } else if (gols[i] <= 3) {
            media++;
        } else {
            alta++;
        }
    }
    printf("0 a 1 gol: %d | 2 a 3 gols: %d | 4 ou mais: %d\n", baixa, media, alta);
    return 0;
}
```

```text
Quantas partidas (0 a 100)? 5
Gols da partida 1: 2
Gols da partida 2: 0
Gols da partida 3: 5
Gols da partida 4: 3
Gols da partida 5: 1
Gols: 2 0 5 3 1
Total: 11  Media: 2.20
Mais gols: 5 (partida 3)
0 a 1 gol: 2 | 2 a 3 gols: 2 | 4 ou mais: 1
```

Observe:

- a **posição** do maior é guardada, não só o valor: com a posição obtém-se o valor (`gols[pos]`) **e** o local (`pos + 1`, pois as pessoas contam a partir de 1);
- o extremo começa na posição `0` (o primeiro elemento), e o laço parte de `1`, como no Material 3;
- os contadores por faixa usam `if / else if / else` dentro do laço (Material 2): uma faixa por elemento;
- `n = 0` é tratado **antes** de qualquer cálculo; `n = 1` funciona (a média é o próprio valor).

Quando há muitas faixas, um **vetor de contadores** substitui variáveis soltas: `int freq[4] = {0};` e, para cada valor, `freq[faixa_do(valor)]++;`. Essa é a ideia da tabela de frequências do Projeto 6.

## 3. Vetores e funções

Ao passar um vetor a uma função, o C **não copia** os dados: a função trabalha sobre o **mesmo vetor** do chamador. Por isso:

- uma função **pode alterar** o vetor original (é o que `ordenar` faz);
- passe sempre o **tamanho** como outro parâmetro: a função não sabe quantos elementos existem;
- se a função só lê, escreva **`const`** no parâmetro (`const int valores[]`): o compilador recusa qualquer alteração acidental e o contrato fica claro.

```c
int soma(const int valores[], int n);   /* só lê */
void ordenar(int valores[], int n);     /* altera o vetor do chamador */
```

Dentro da função, `sizeof valores` **não** informa o tamanho do vetor; por isso o parâmetro `n`. Fora de funções, para vetores inicializados, `sizeof v / sizeof v[0]` dá a quantidade de posições.

## 4. Busca sequencial e vetores paralelos

A **busca sequencial** percorre o vetor comparando cada elemento com o procurado. Devolve a **posição** encontrada ou `-1` (uma posição que não existe) quando não há:

```c
/* busca_estoque.c */
#include <stdio.h>

#define MAX_PRODUTOS 50

/* Devolve a posicao de procurado em codigos[0..n-1], ou -1 se ausente. */
int posicao_de(const int codigos[], int n, int procurado) {
    for (int i = 0; i < n; i++) {
        if (codigos[i] == procurado) {
            return i;
        }
    }
    return -1;
}

int main(void) {
    int codigos[MAX_PRODUTOS] = {101, 205, 150, 320};
    int estoque[MAX_PRODUTOS] = {12, 0, 7, 30};
    int n = 4;
    int procurado;

    printf("Codigo do produto: ");
    if (scanf("%d", &procurado) != 1) {
        printf("Entrada invalida.\n");
        return 1;
    }

    int pos = posicao_de(codigos, n, procurado);
    if (pos == -1) {
        printf("Produto %d nao cadastrado.\n", procurado);
    } else {
        printf("Produto %d (posicao %d): estoque %d\n", procurado, pos, estoque[pos]);
    }
    return 0;
}
```

```text
Codigo do produto: 150
Produto 150 (posicao 2): estoque 7
```

```text
Codigo do produto: 999
Produto 999 nao cadastrado.
```

`codigos` e `estoque` são **vetores paralelos**: a posição `i` de um descreve o mesmo item que a posição `i` do outro. A busca acontece em um deles, e a **mesma posição** entrega o dado no outro. A fragilidade desse modelo é evidente: **qualquer operação que mude a ordem ou o conteúdo de um vetor deve ser repetida no outro**, sob pena de trocar o dono dos dados. (O Projeto 7 resolve isso com registros.)

Regras da busca: devolva `-1` para ausente; nunca use o `-1` como índice sem testar; a busca é feita **apenas** sobre as `n` posições em uso.

## 5. Ordenação por seleção

Na **seleção direta**, a cada passo `i` procura-se o menor elemento do trecho `i..n-1` e coloca-se na posição `i`:

```c
/* selecao.c */
#include <stdio.h>

void imprimir(const int v[], int n) {
    for (int i = 0; i < n; i++) {
        printf(" %d", v[i]);
    }
    printf("\n");
}

/* Ordena v[0..n-1] em ordem crescente. */
void ordenar(int v[], int n) {
    for (int i = 0; i < n - 1; i++) {
        int menor = i;                   /* posição do menor visto até agora */
        for (int j = i + 1; j < n; j++) {
            if (v[j] < v[menor]) {
                menor = j;
            }
        }
        if (menor != i) {
            int aux = v[i];              /* troca com variável auxiliar */
            v[i] = v[menor];
            v[menor] = aux;
        }
    }
}

int main(void) {
    int v[] = {5, 2, 9, 1};
    int n = 4;

    printf("Antes: ");
    imprimir(v, n);
    ordenar(v, n);
    printf("Depois:");
    imprimir(v, n);
    return 0;
}
```

```text
Antes:  5 2 9 1
Depois: 1 2 5 9
```

Teste de mesa para `{5, 2, 9, 1}`:

| Passo `i` | Trecho analisado | Menor encontrado | Vetor após o passo |
|---:|---|---|---|
| 0 | `5 2 9 1` | `1` (posição 3) | `1 2 9 5` |
| 1 | `2 9 5` | `2` (posição 1, já no lugar) | `1 2 9 5` |
| 2 | `9 5` | `5` (posição 3) | `1 2 5 9` |

O último elemento não precisa de passo próprio: sobrou o maior. Por isso o laço externo vai até `n - 2`. Casos de teste: `n = 0`, `n = 1`, já ordenado, ordem inversa, valores repetidos.

**Vetores paralelos:** ao ordenar um vetor de chaves (códigos), o vetor associado (estoque) precisa sofrer **a mesma troca** a cada movimento. Se apenas os códigos forem ordenados, os dados se desalinham:

| Posição | Códigos antes | Estoque | Códigos ordenados (só eles) | Estoque (não acompanhou) |
|---:|---:|---:|---:|---:|
| 0 | 205 | 0 | 101 | 0 |
| 1 | 101 | 12 | 205 | 12 |

Agora o código `101` aparece com estoque `0`, que era do `205`: o programa passa a mentir sem nenhum erro de compilação. Teste sempre com uma verificação de que cada chave continua com o seu dado.

Outra estratégia clássica é comparar **pares vizinhos** e trocá-los quando estão fora de ordem, repetindo até não haver trocas (método da bolha). Vale implementá-la e comparar o número de trocas com o da seleção.

## 6. Duas listas ordenadas: percurso com dois índices

Quando duas listas já estão **ordenadas**, dá para processá-las juntas com um índice em cada uma, avançando **só o do menor** valor a cada comparação. Nenhuma lista é percorrida mais de uma vez. Exemplo: contar quantos valores aparecem nas duas listas (sem repetições dentro de cada uma):

```c
/* em_comum.c */
#include <stdio.h>

/* Conta valores presentes em a[0..na-1] e em b[0..nb-1].
   Pré-condição: cada vetor está em ordem estritamente crescente. */
int contar_em_comum(const int a[], int na, const int b[], int nb) {
    int i = 0;
    int j = 0;
    int comuns = 0;

    while (i < na && j < nb) {
        if (a[i] == b[j]) {
            comuns++;
            i++;
            j++;
        } else if (a[i] < b[j]) {
            i++;
        } else {
            j++;
        }
    }
    return comuns;
}

int main(void) {
    int a[] = {2, 5, 8, 11, 14};
    int b[] = {1, 5, 9, 11, 20, 21};

    printf("Em comum: %d\n", contar_em_comum(a, 5, b, 6));
    return 0;
}
```

```text
Em comum: 2
```

Como o laço `while` tem **duas** condições de parada (`i < na && j < nb`), ele termina quando **uma** das listas acaba. O que fazer com o restante da outra depende do problema: aqui nada, pois nada mais pode coincidir. Na **intercalação** (juntar as duas listas em uma só, ordenada), a decisão a cada comparação e o tratamento das sobras são diferentes: pense no que deve acontecer em cada ramo antes de codificar e faça o teste de mesa com listas de tamanhos distintos e com uma lista vazia.

## 7. Cópia e remoção de duplicados

Um vetor **não** é copiado com `b = a`: é preciso copiar elemento a elemento, com um laço. Isso importa ao remover duplicados: o resultado vai para um **segundo vetor**, e o original permanece intacto, pois

- a lista original ainda pode ser necessária (relatórios, conferência);
- se algo der errado no meio do processamento, os dados originais não se perdem;
- vetores paralelos deixariam de corresponder se um deles encolhesse sozinho.

A ideia do algoritmo: para cada elemento do original, **procure-o** no vetor de saída (a busca da seção 4); se não estiver, acrescente-o ao final da saída e aumente a quantidade em uso da saída. Qual o tamanho mínimo da saída? E o máximo?

## 8. Strings

Um **texto** em C é um vetor de `char` terminado por um caractere especial `'\0'` (valor zero). O terminador marca o fim; **ele ocupa uma posição**.

```text
char nome[8] = "Inhumas";

índice:   0    1    2    3    4    5    6    7
valor:  [ I ][ n ][ h ][ u ][ m ][ a ][ s ][\0 ]
```

Para guardar `n` letras, é preciso um vetor com **`n + 1`** posições. Textos maiores que o vetor **estouram o buffer**: mesmo problema de acesso fora dos limites.

### Ler uma linha com segurança

Use `fgets`: ele lê **no máximo** o tamanho informado (menos um) e não estoura o vetor. Ele guarda também o `'\n'` do fim da linha, que costuma ser removido:

```c
char frase[81];
if (fgets(frase, sizeof frase, stdin) == NULL) {
    /* sem entrada */
}
frase[strcspn(frase, "\n")] = '\0';   /* troca o '\n' por '\0' */
```

- **Evite `scanf("%s", ...)`**: para no primeiro espaço e não limita o tamanho.
- Nunca use `gets`: foi removido do padrão por ser inseguro.
- Cuidado ao misturar `scanf` e `fgets`: o `scanf` deixa o `'\n'` digitado no buffer, e o `fgets` seguinte o lê como uma linha vazia. Descarte o restante da linha (com `getchar()` em laço, como no Material 3) antes do `fgets`.

### Funções úteis

| Função | Biblioteca | Faz |
|---|---|---|
| `strlen(s)` | `<string.h>` | quantidade de caracteres antes do `'\0'` (tipo `size_t`, use `%zu`) |
| `strcmp(a, b)` | `<string.h>` | `0` se os textos são iguais; negativo/positivo conforme a ordem alfabética |
| `snprintf(dest, sizeof dest, "%s", origem)` | `<stdio.h>` | copia com limite de tamanho |
| `isalpha`, `isdigit`, `isspace` | `<ctype.h>` | classificam um caractere |
| `toupper`, `tolower` | `<ctype.h>` | convertem um caractere |

- **Não compare textos com `==`**: isso compara endereços, não conteúdo. Use `strcmp(a, b) == 0`.
- **Não copie com `=`**: use `snprintf`.
- Nas funções de `<ctype.h>`, converta o caractere: `isalpha((unsigned char)c)`.

### Percorrer uma string

O laço para no terminador, sem precisar conhecer o tamanho:

```c
for (int i = 0; texto[i] != '\0'; i++) {
    /* trata texto[i] */
}
```

```c
/* texto.c */
#include <ctype.h>
#include <stdio.h>
#include <string.h>

#define TAM_FRASE 81

/* Conta palavras: sequencias de caracteres que nao sao espacos. */
int contar_palavras(const char texto[]) {
    int palavras = 0;
    int dentro = 0;                          /* 1 enquanto estamos numa palavra */

    for (int i = 0; texto[i] != '\0'; i++) {
        if (isspace((unsigned char)texto[i])) {
            dentro = 0;
        } else if (!dentro) {                /* primeiro caractere de uma palavra */
            dentro = 1;
            palavras++;
        }
    }
    return palavras;
}

/* Converte o texto para maiusculas, no proprio vetor. */
void maiusculas(char texto[]) {
    for (int i = 0; texto[i] != '\0'; i++) {
        texto[i] = (char)toupper((unsigned char)texto[i]);
    }
}

/* Inverte a ordem dos caracteres, no proprio vetor. */
void inverter(char texto[]) {
    size_t tamanho = strlen(texto);

    for (size_t i = 0; i < tamanho / 2; i++) {
        char aux = texto[i];
        texto[i] = texto[tamanho - 1 - i];
        texto[tamanho - 1 - i] = aux;
    }
}

int main(void) {
    char frase[TAM_FRASE];

    printf("Frase (ate %d caracteres): ", TAM_FRASE - 1);
    if (fgets(frase, TAM_FRASE, stdin) == NULL) {
        printf("Sem entrada.\n");
        return 1;
    }
    frase[strcspn(frase, "\n")] = '\0';

    printf("Tamanho: %zu caracteres\n", strlen(frase));
    printf("Palavras: %d\n", contar_palavras(frase));

    char copia[TAM_FRASE];
    snprintf(copia, sizeof copia, "%s", frase);
    maiusculas(copia);
    printf("Maiusculas: %s\n", copia);

    inverter(copia);
    printf("Invertida: %s\n", copia);
    printf("Original preservada: %s\n", frase);
    return 0;
}
```

```text
Frase (ate 80 caracteres): Ola  mundo cruel
Tamanho: 16 caracteres
Palavras: 3
Maiusculas: OLA  MUNDO CRUEL
Invertida: LEURC ODNUM  ALO
Original preservada: Ola  mundo cruel
```

O contador de palavras usa o mesmo raciocínio dos laços com **estado** (Material 3): a variável `dentro` lembra se o caractere anterior fazia parte de uma palavra, de modo que espaços repetidos não criam palavras vazias. Casos de teste: frase vazia, só espaços, uma palavra, espaços no início e no fim, frase com o tamanho máximo.

## Erros comuns

- **`i <= n`** em vez de `i < n`, acessando `v[n]`.
- **Usar o `-1` da busca como índice** sem testar.
- **`n` maior que a capacidade** do vetor, ou usado antes de validado.
- **Extremo iniciado com valor arbitrário** em vez do primeiro elemento.
- **Alterar um vetor só de um par** de vetores paralelos.
- **Esquecer o espaço do `'\0'`** ao dimensionar um texto.
- **`scanf("%s")`**, `gets` ou `strcpy` sem controle de tamanho: estouro de buffer.
- **Comparar textos com `==`** ou copiar com `=`.
- **`int i` comparado com `strlen`** (`size_t`, sem sinal): o compilador avisa (`-Wsign-compare`); use `size_t` no índice ou evite `strlen` no laço.
- **Não tratar `n = 0` e `n = 1`** em busca, extremos e ordenação.

## Autoteste

1. Quais os índices válidos de `double notas[8]`? O que pode acontecer com `notas[8] = 10.0`?
2. Por que a função `soma` recebe `n` e o parâmetro é `const`?
3. Faça o teste de mesa da seleção para `{4, 3, 2, 1}`. Quantas trocas ocorrem?
4. Qual o tamanho mínimo do vetor para guardar o texto `"Inhumas-GO"`?
5. Por que `if (nome == "Ana")` não funciona? Como escrever corretamente?
6. Escreva `int contar_pares(const int v[], int n)`, que devolve quantos elementos são pares.

<details>
<summary>Respostas</summary>

1. De `0` a `7`. `notas[8]` está fora do vetor: escreve em memória de outra variável ou área, com comportamento indefinido (resultado errado, travamento ou aparente sucesso).
2. `n` porque a função não sabe o tamanho do vetor; `const` porque a função só lê e o compilador passa a impedir alterações acidentais.
3. Passo 0: `1 3 2 4` (troca `4` e `1`); passo 1: `1 2 3 4` (troca `3` e `2`); passo 2: `3` e `4` já ordenados. Duas trocas.
4. 11: dez caracteres mais o `'\0'`.
5. Porque compara os endereços dos textos, não o conteúdo. Correto: `strcmp(nome, "Ana") == 0` (com `<string.h>`).
6. Veja o código a seguir.

```c
/* contar_pares.c */
int contar_pares(const int v[], int n) {
    int pares = 0;
    for (int i = 0; i < n; i++) {
        if (v[i] % 2 == 0) {
            pares++;
        }
    }
    return pares;
}
```

</details>

## Ligação com o Projeto 5

| Incremento do projeto | Onde estudar | Exemplo relacionado |
|---|---|---|
| 1. Ler `n` notas, listar, média, extremos e faixas | seções 1 e 2 | `gols.c` |
| 2. Buscar matrícula e mostrar a nota | seção 4 | `busca_estoque.c` |
| 3. Remover duplicados em uma cópia | seções 4 e 7 | função `posicao_de` |
| 4. Ordenar mantendo a correspondência | seção 5 (seleção, vetores paralelos) | `selecao.c` |
| 5. Intercalar duas listas ordenadas | seção 6 | `em_comum.c` |
| 6. Contar espaços, vogais e pares repetidos | seção 8 | `texto.c` (`contar_palavras`) |

| Função esperada no projeto | Comparar com |
|---|---|
| `buscar` | `posicao_de` (seção 4) |
| `media` | `soma` e a divisão com `(double)` (seção 2, Material 1) |
| `ordenar_pares` | `ordenar` (seção 5) + regra dos vetores paralelos |
| `intercalar` | percurso com dois índices (seção 6) |

**Critérios de aceitação:** "nenhum acesso fora de `0..n-1`" → seção 1 e teste com sanitizers; "`n = 0` e `n = 1` definidos" → seção 2; "busca ausente retorna `-1`" → seção 4; "ordenação preserva a associação" → seção 5; "texto não ultrapassa o buffer" → seção 8.

Para a **explicação visual de índice versus valor**, use o esquema da seção 1: desenhe o vetor com os índices acima e os valores dentro das caixas.

## Para ir além

- Implementar a **busca binária** em um vetor ordenado e comparar quantas comparações ela faz em relação à sequencial.
- Trocar a seleção pelo método da bolha e contar comparações e trocas em cada um.
- Detectar **palíndromos** ignorando espaços e maiúsculas.

Próximo: [Material 6 — Matrizes](06-matrizes.md).
