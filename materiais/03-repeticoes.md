# Material 3 — Repetições

Apoia o [Projeto 3](../projetos/03-repeticoes/README.md) (aulas 45–68 do [guia de avanço](../docs/guia-de-avanco.md#projeto-3)). Anterior: [Material 2](02-decisoes.md). Próximo: [Material 4](04-funcoes.md).

Os exemplos usam temperaturas, doações e crescimento populacional, não notas de estudantes. Adapte as técnicas ao painel de indicadores.

## Ao final você deve conseguir

- escolher entre `for`, `while` e `do while` a partir do contrato do problema;
- usar contadores, acumuladores e variáveis de estado anterior;
- calcular média, maior e menor sem criar resultados falsos e tratar o conjunto vazio;
- ler dados até uma sentinela e validar entradas com repetição;
- fazer o teste de mesa de um laço e demonstrar que ele termina.

## 1. Anatomia de um laço

Todo laço correto responde a três perguntas:

| Pergunta | Nome | Se faltar |
|---|---|---|
| Onde começa? | **inicialização** | o laço usa lixo de memória |
| Quando continua? | **condição** | ele não para, ou nunca executa |
| Como avança? | **progresso** | a condição nunca muda: laço infinito |

Ao escrever um laço, aponte as três partes. Se não consegue apontar o progresso, o laço provavelmente não termina.

## 2. `while`, `do while` e `for`

```c
while (condicao) {          /* testa antes: pode executar zero vezes */
    /* corpo */
}

do {                        /* testa depois: executa ao menos uma vez */
    /* corpo */
} while (condicao);

for (int i = 0; i < n; i++) {   /* inicialização; condição; progresso */
    /* corpo */
}
```

O `for` reúne as três partes na primeira linha e é o mais legível quando a **quantidade de voltas é conhecida**. Os três laços são equivalentes: o `for` acima equivale a

```c
int i = 0;
while (i < n) {
    /* corpo */
    i++;
}
```

Para escolher, olhe o contrato do problema:

| Situação | Laço | Exemplo |
|---|---|---|
| sabe-se quantas vezes repetir | `for` | ler as notas de `n` estudantes |
| repete até um valor especial (**sentinela**) | `while` | ler compras até o código `0` |
| repete até a entrada ser válida | `do while` | pedir a nota até ela estar entre 0 e 100 |
| repete enquanto uma situação evolui | `while` | contar quantos anos até um valor dobrar |

Em Portugol, `repita … ate c` para quando `c` é verdadeira; em C, `do { … } while (c);` continua **enquanto** `c` é verdadeira. Ao traduzir, negue a condição.

## 3. Contadores, acumuladores e estado

| Papel | O que faz | Inicia em | Exemplo |
|---|---|---|---|
| **contador** | conta ocorrências (soma 1) | `0` | `quantidade++;` |
| **acumulador** | soma valores | `0` | `total += valor;` |
| **estado anterior** | lembra o valor da volta anterior | um valor especial ou o primeiro elemento | `anterior = atual;` |
| **extremo** | guarda o maior ou o menor visto até agora | o **primeiro valor lido** | `if (x > maior) maior = x;` |

Para cada variável de um laço, pergunte: qual o papel, com que valor começa e quando é atualizada?

## 4. Quantidade conhecida: média, maior e menor

**Inicializar `maior` com `0` é um defeito.** Se todos os valores forem negativos, o programa responderá `0`, que nunca foi lido. O extremo deve começar com o **primeiro valor lido**.

**Média de zero valores não existe.** Dividir por `n = 0` é erro; o programa precisa tratar o conjunto vazio antes.

```c
/* temperaturas.c */
#include <stdio.h>

int main(void) {
    int n;

    printf("Quantos dias? ");
    if (scanf("%d", &n) != 1 || n < 0) {
        printf("Entrada invalida.\n");
        return 1;
    }
    if (n == 0) {
        printf("Sem dados: nao ha media, maior nem menor.\n");
        return 0;
    }

    double soma = 0.0;
    double maior = 0.0;   /* valor inicial irrelevante: o dia 1 o substitui */
    double menor = 0.0;

    for (int dia = 1; dia <= n; dia++) {
        double temperatura;

        printf("Temperatura do dia %d: ", dia);
        if (scanf("%lf", &temperatura) != 1) {
            printf("Entrada invalida.\n");
            return 1;
        }

        soma += temperatura;
        if (dia == 1 || temperatura > maior) {
            maior = temperatura;
        }
        if (dia == 1 || temperatura < menor) {
            menor = temperatura;
        }
    }

    printf("Media: %.1f  Maior: %.1f  Menor: %.1f\n", soma / n, maior, menor);
    return 0;
}
```

```text
Quantos dias? 4
Temperatura do dia 1: 24.0
Temperatura do dia 2: 27.5
Temperatura do dia 3: 19.0
Temperatura do dia 4: 31.5
Media: 25.5  Maior: 31.5  Menor: 19.0
```

O `dia == 1 ||` faz o primeiro valor lido tornar-se, ao mesmo tempo, maior e menor. Com valores negativos o resultado continua correto:

```text
Quantos dias? 3
Temperatura do dia 1: -3
Temperatura do dia 2: -1
Temperatura do dia 3: -5
Media: -3.0  Maior: -1.0  Menor: -5.0
```

E o conjunto vazio é tratado:

```text
Quantos dias? 0
Sem dados: nao ha media, maior nem menor.
```

Casos de teste para este tipo de laço: `n = 0`; `n = 1` (média, maior e menor coincidem); todos os valores iguais (**empate** nos extremos); valores todos negativos; maior no início e no fim da sequência.

## 5. Sentinela: quantidade desconhecida

Quando não se sabe quantos dados virão, o usuário encerra com um **valor sentinela** que não pode ser um dado válido (por exemplo `0` em uma lista de doações). O padrão clássico, em Portugol, é a **leitura antecipada**:

```text
leia(valor)                       // primeira leitura, fora do laço
enquanto valor <> 0 faca
    processe(valor)
    leia(valor)                   // próxima leitura, no fim do laço
fimenquanto
```

Em C, uma forma compacta une a leitura e o teste na condição. Como `&&` avalia da esquerda para a direita (curto-circuito), o `scanf` acontece primeiro, e o valor só é comparado se a leitura funcionou:

```c
/* doacoes.c */
#include <stdio.h>

int main(void) {
    const double LIMITE_GRANDE = 100.0;
    double valor;
    double total = 0.0;
    int quantidade = 0;
    int grandes = 0;

    printf("Doacoes em reais, positivas (0 encerra):\n");
    while (scanf("%lf", &valor) == 1 && valor != 0.0) {
        total += valor;
        quantidade++;
        if (valor >= LIMITE_GRANDE) {
            grandes++;
        }
    }

    if (quantidade == 0) {
        printf("Nenhuma doacao registrada.\n");
    } else {
        printf("Doacoes: %d\n", quantidade);
        printf("Total: R$ %.2f\n", total);
        printf("Media: R$ %.2f\n", total / quantidade);
        printf("Doacoes de R$ %.2f ou mais: %d\n", LIMITE_GRANDE, grandes);
    }
    return 0;
}
```

```text
Doacoes em reais, positivas (0 encerra):
50
120
30
100
0
Doacoes: 4
Total: R$ 300.00
Media: R$ 75.00
Doacoes de R$ 100.00 ou mais: 2
```

Se o usuário encerra logo na primeira leitura, nenhum valor foi processado e não há média:

```text
Doacoes em reais, positivas (0 encerra):
0
Nenhuma doacao registrada.
```

Observe também o `if` **dentro** do laço: o contador `grandes` só conta as doações que passam pela condição. Combinar laço e decisão é o cotidiano dos indicadores: para faixas com três categorias, use `if / else if / else` dentro do laço, com um contador para cada faixa.

### Teste de mesa de um laço

Acompanhe as variáveis a cada volta. Entrada: `50`, `120`, `0`.

| Volta | `valor` lido | `valor != 0`? | `total` | `quantidade` | `grandes` |
|---|---:|---|---:|---:|---:|
| antes do laço | — | — | 0 | 0 | 0 |
| 1 | 50 | sim | 50 | 1 | 0 |
| 2 | 120 | sim | 170 | 2 | 1 |
| 3 | 0 | **não**: sai | 170 | 2 | 1 |

A tabela também demonstra o **término**: cada volta consome um valor da entrada, e a entrada é finita (ou chega o `0`).

## 6. Validação de entrada com `do while`

Para exigir uma entrada válida, o programa precisa **perguntar ao menos uma vez**: é o caso do `do while`. Há um detalhe importante: se o usuário digitar letras, o `scanf` **não consome** o texto e falha de novo a cada volta, criando um laço infinito. É preciso descartar o restante da linha.

```c
/* validacao.c */
#include <stdio.h>

int main(void) {
    int idade = 0;
    int lidos;

    do {
        printf("Idade (0 a 120): ");
        lidos = scanf("%d", &idade);

        if (lidos == EOF) {
            printf("\nEntrada encerrada.\n");
            return 1;
        }
        if (lidos != 1) {
            printf("Digite um numero.\n");
            int c;
            do {
                c = getchar();          /* descarta o resto da linha */
            } while (c != '\n' && c != EOF);
        } else if (idade < 0 || idade > 120) {
            printf("Valor fora do intervalo.\n");
        }
    } while (lidos != 1 || idade < 0 || idade > 120);

    printf("Idade registrada: %d\n", idade);
    return 0;
}
```

```text
Idade (0 a 120): abc
Digite um numero.
Idade (0 a 120): 150
Valor fora do intervalo.
Idade (0 a 120): -3
Valor fora do intervalo.
Idade (0 a 120): 25
Idade registrada: 25
```

A condição do `while` final é a **negação** de "entrada válida": o laço repete enquanto a leitura falhou **ou** o valor está fora do intervalo.

## 7. Laços aninhados

Um laço dentro de outro executa o corpo interno **várias vezes por volta do externo**. Com 5 voltas externas e 5 internas, o corpo interno roda 25 vezes.

```c
/* tabuada.c */
#include <stdio.h>

int main(void) {
    for (int linha = 1; linha <= 5; linha++) {
        for (int coluna = 1; coluna <= 5; coluna++) {
            printf("%4d", linha * coluna);
        }
        printf("\n");
    }
    return 0;
}
```

```text
   1   2   3   4   5
   2   4   6   8  10
   3   6   9  12  15
   4   8  12  16  20
   5  10  15  20  25
```

O laço externo escolhe a **linha**; o interno percorre as **colunas** dela; a quebra de linha vem depois do interno. Este é o esqueleto que os percursos de matrizes usam no Projeto 6. Também é o modelo para "para cada turma, processe as presenças": o laço externo avança de turma em turma, e o interno trata as aulas de cada turma, reiniciando os acumuladores da turma a cada volta externa.

## 8. Simulação e estado anterior

Nem todo laço percorre uma lista. Em uma **simulação**, a condição depende de um estado que evolui a cada volta; o laço para quando o estado atinge um objetivo.

**Quantos anos para uma população dobrar?** O estado é a população; o progresso é o crescimento anual:

```c
/* crescimento.c */
#include <stdio.h>

int main(void) {
    double populacao;
    double taxa;

    printf("Populacao inicial e taxa anual (%%): ");
    if (scanf("%lf %lf", &populacao, &taxa) != 2 || populacao <= 0.0 || taxa <= 0.0) {
        printf("Entrada invalida: valores devem ser positivos.\n");
        return 1;
    }

    const double meta = 2.0 * populacao;
    int anos = 0;

    while (populacao < meta) {
        populacao = populacao * (1.0 + taxa / 100.0);
        anos++;
    }

    printf("Para dobrar: %d anos (populacao final %.0f)\n", anos, populacao);
    return 0;
}
```

```text
Populacao inicial e taxa anual (%): 1000 3
Para dobrar: 24 anos (populacao final 2033)
```

**Por que a taxa precisa ser positiva?** Com taxa zero ou negativa, `populacao` nunca chega à `meta`: o laço não terminaria. A validação da entrada é o que **garante o término**.

Outro uso do estado é lembrar o **valor anterior**. Para saber se uma sequência é estritamente crescente, compare cada valor com o anterior:

```c
/* crescente.c */
#include <stdio.h>

int main(void) {
    int atual;
    int anterior = 0;
    int quantidade = 0;
    int crescente = 1;   /* 1 enquanto nenhuma violação foi encontrada */

    printf("Numeros (0 encerra): ");
    while (scanf("%d", &atual) == 1 && atual != 0) {
        if (quantidade > 0 && atual <= anterior) {
            crescente = 0;
        }
        anterior = atual;
        quantidade++;
    }

    if (crescente) {
        printf("Estritamente crescente (%d numeros)\n", quantidade);
    } else {
        printf("Nao e estritamente crescente\n");
    }
    return 0;
}
```

```text
Numeros (0 encerra): 1 4 8 0
Estritamente crescente (3 numeros)
```

```text
Numeros (0 encerra): 2 5 9 9 0
Nao e estritamente crescente
```

O `quantidade > 0` evita comparar o primeiro valor com um "anterior" que ainda não existe.

## 9. `break` e `continue`

- `break` **sai** do laço imediatamente.
- `continue` **pula** para a próxima volta.

Ambos funcionam, mas escondem a condição de parada dentro do corpo. Nesta fase, prefira condições explícitas no `while`/`for`, como nos exemplos acima, e use `break` apenas quando ele deixar o código mais claro.

## Erros comuns

- **Laço infinito:** esquecer o progresso (`i++`), ou uma condição que nunca fica falsa.
- **Uma volta a mais ou a menos** (*off-by-one*): `i <= n` no lugar de `i < n` (ou o contrário). Teste `n = 0` e `n = 1`.
- **Extremos iniciados com um valor arbitrário** (`maior = 0`, `menor = 0`): use o primeiro valor lido.
- **Acumulador ou contador sem inicialização**, ou não reiniciado a cada turma.
- **Divisão por zero** ao calcular média de um conjunto vazio.
- **`;` depois do `for (...)`** ou do `while (...)`: o corpo vira um bloco vazio.
- **Alterar a variável de controle** do `for` dentro do corpo.
- **`scanf` falhando dentro de um laço** sem consumir a entrada errada.
- **Comparar `double` com `==` ou `!=`** para parar o laço.

## Autoteste

1. Quantas vezes o corpo executa em `for (int i = 1; i <= 10; i += 3)`? E em `for (int i = 0; i < 0; i++)`?
2. Qual laço você escolheria para: (a) somar os preços de 5 produtos; (b) ler senhas até acertar; (c) somar valores até o total passar de 1000?
3. O que o programa `doacoes.c` imprime se a primeira leitura for uma letra?
4. `maior = 0` funciona para notas (que nunca são negativas), mas `menor = 0` não. Por quê? E o que `maior = 0` "responde" para um conjunto vazio?
5. Escreva o teste de mesa de `for (int i = 1; i <= 4; i++) soma += i * i;` com `soma` inicial `0`.

<details>
<summary>Respostas</summary>

1. Quatro vezes (`i` vale 1, 4, 7 e 10) e nenhuma vez (a condição já começa falsa).
2. (a) `for`; (b) `do while`, pois é preciso perguntar ao menos uma vez; (c) `while (total <= 1000)`, pois não se sabe quantas voltas.
3. O `scanf` devolve `0` (não leu nada), a condição `== 1` falha e o laço não executa; o programa imprime "Nenhuma doacao registrada.".
4. Com `menor = 0`, nenhuma nota positiva seria menor que ele: o programa sempre responderia `0`, um valor que talvez nunca tenha sido lido. Com `maior = 0` e nenhum dado, o programa "informaria" um maior que não existe; o caso `n = 0` precisa ser tratado à parte. Iniciar com o primeiro valor lido funciona para qualquer conjunto de dados.
5. `soma`: `0` → `1` → `5` → `14` → `30` (com `i` = 1, 2, 3, 4). Ao fim, `i` vale 5 e a condição `i <= 4` é falsa.

</details>

## Ligação com o Projeto 3

| Incremento do projeto | Onde estudar | Exemplo relacionado |
|---|---|---|
| 1. Quantidade conhecida (`for`, `n = 0`) | seções 2, 3 e 4 | `temperaturas.c` |
| 2. Sentinela e faixas | seção 5 (e Material 2 para as faixas) | `doacoes.c` |
| 3. Validação com `do while` | seção 6 | `validacao.c` |
| 4. Frequência por turma | seções 5 e 7 (laços aninhados, reiniciar acumuladores) | `tabuada.c` |
| 5. Simulação | seção 8 | `crescimento.c` |
| Testes de mesa de um laço | seção 5 | tabela do `doacoes.c` |

| Questão de investigação | Onde |
|---|---|
| Qual laço expressa melhor cada contrato? | tabela da seção 2 |
| Quais variáveis são contadores, acumuladores ou estado anterior? | seção 3 |
| Como inicializar maior e menor sem resultados falsos? | seção 4 |
| Quando uma média não existe? | seções 4 e 5 (conjunto vazio) |

**Critérios de aceitação:** "inicialização, condição de parada e progresso demonstráveis" → seção 1 e teste de mesa; "conjunto vazio, um elemento, empate nos extremos, limites das faixas" → lista de casos de teste da seção 4.

## Para ir além

- Reescrever `temperaturas.c` com `while` e conferir que o resultado é idêntico.
- Contar quantas voltas cada laço do painel executa e comparar com a previsão do teste de mesa.
- Pesquisar o problema de números reais no laço: `for (double x = 0.0; x != 1.0; x += 0.1)` termina? Por quê?

Próximo: [Material 4 — Funções](04-funcoes.md).
