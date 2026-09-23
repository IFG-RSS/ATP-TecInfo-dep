# Material 4 — Funções

Apoia o [Projeto 4](../projetos/04-funcoes/README.md) (aulas 69–84 do [guia de avanço](../docs/guia-de-avanco.md#projeto-4)). Anterior: [Material 3](03-repeticoes.md). Próximo: [Material 5](05-vetores-e-strings.md).

Os exemplos usam geometria, calendário e conta de dígitos, e não a API pedida no projeto. Escreva as suas funções a partir dos contratos que a equipe definir.

## Ao final você deve conseguir

- decompor um programa em funções com **uma responsabilidade** cada;
- escrever o **contrato** de uma função (propósito, parâmetros, retorno, restrições);
- declarar e definir funções, separando interface (`.h`) e implementação (`.c`);
- testar funções isoladamente com `assert`, incluindo fronteiras;
- explicar escopo, passagem por valor e por que evitar variáveis globais.

## 1. Anatomia de uma função

```text
tipo_de_retorno nome(tipo parametro1, tipo parametro2) {
    corpo
    return valor;
}
```

Uma função **recebe** valores (parâmetros), **calcula** e **devolve** um resultado (`return`). Se não devolve nada, o tipo é `void`.

```c
/* funcoes_basicas.c */
#include <stdio.h>

int eh_par(int n);
int maior_de_dois(int a, int b);
void imprimir_linha(int tamanho);

int main(void) {
    int x = 7;
    int y = 12;

    printf("%d e par? %d\n", x, eh_par(x));
    printf("%d e par? %d\n", y, eh_par(y));
    printf("Maior entre %d e %d: %d\n", x, y, maior_de_dois(x, y));
    imprimir_linha(20);
    return 0;
}

/* Devolve 1 se n e par e 0 caso contrario. */
int eh_par(int n) {
    return n % 2 == 0;
}

/* Devolve o maior entre a e b. */
int maior_de_dois(int a, int b) {
    if (a > b) {
        return a;
    }
    return b;
}

/* Escreve uma linha de tracos com o tamanho pedido. */
void imprimir_linha(int tamanho) {
    for (int i = 0; i < tamanho; i++) {
        printf("-");
    }
    printf("\n");
}
```

```text
7 e par? 0
12 e par? 1
Maior entre 7 e 12: 12
--------------------
```

Repare que:

- as três linhas do início são **declarações** (protótipos): avisam o compilador que as funções existem, com quais tipos, antes de `main` usá-las. As **definições** (com corpo) vêm depois;
- `eh_par` devolve `1` ou `0`: em C não é preciso um tipo lógico especial, e o nome `eh_...` deixa claro que a resposta é sim ou não;
- `imprimir_linha` é `void`: age (imprime), mas não devolve valor.

Funções podem chamar outras funções. Uma função **não** pode ser definida dentro de outra.

## 2. Contrato de uma função

O **contrato** é o que a função promete, escrito **antes** de implementar. Ele permite usar e testar a função sem olhar o corpo.

```c
/*
 * limitar
 * Propósito : restringe valor ao intervalo [minimo, maximo].
 * Parâmetros: valor, minimo e maximo (pré-condição: minimo <= maximo).
 * Retorno   : minimo se valor < minimo; maximo se valor > maximo;
 *             valor nos demais casos.
 * Inválidos : se minimo > maximo, devolve valor sem alteração.
 */
int limitar(int valor, int minimo, int maximo);
```

Todo contrato precisa responder:

| Pergunta | Exemplo |
|---|---|
| O que a função faz (uma frase)? | restringe um valor a um intervalo |
| O que recebe, com que tipos e unidades? | três `int` |
| O que devolve? | um `int` dentro do intervalo |
| O que **não** aceita? Qual o comportamento nesse caso? | intervalo invertido: devolve o valor original |
| Quais os casos-limite? | valor igual ao mínimo, igual ao máximo |

**Decidir o comportamento para argumentos inválidos é parte do projeto** da função: devolver um valor especial (`-1`, `0`), documentar e testar. O importante é que a decisão seja explícita.

### Uma responsabilidade

Uma função deve fazer **uma coisa**. Regra prática: separe **calcular** de **interagir**.

| Função | Faz cálculo | Lê / imprime |
|---|:-:|:-:|
| `area_retangulo(base, altura)` | sim | não |
| `ler_medidas(...)` | não | sim |
| `imprimir_relatorio(...)` | não | sim |

Funções de cálculo sem `scanf`/`printf` são fáceis de testar automaticamente (seção 6) e de reutilizar em outros programas.

## 3. Parâmetros por valor e escopo

**Passagem por valor.** A função recebe uma **cópia** dos argumentos. Alterar o parâmetro não altera a variável de quem chamou:

```c
/* passagem_por_valor.c */
#include <stdio.h>

void tentar_dobrar(int n) {
    n = n * 2;
    printf("dentro de tentar_dobrar: n = %d\n", n);
}

int dobro(int n) {
    return n * 2;
}

int main(void) {
    int valor = 5;

    tentar_dobrar(valor);
    printf("depois de tentar_dobrar: valor = %d\n", valor);

    valor = dobro(valor);
    printf("depois de valor = dobro(valor): valor = %d\n", valor);
    return 0;
}
```

```text
dentro de tentar_dobrar: n = 10
depois de tentar_dobrar: valor = 5
depois de valor = dobro(valor): valor = 10
```

Para uma função "entregar" um resultado, use `return` e atribua na chamada. (Quando for preciso devolver vários resultados ou alterar dados do chamador, veja vetores no Projeto 5 e endereços no Projeto 7.)

**Escopo.** Uma variável declarada dentro de uma função é **local**: só existe ali e desaparece quando a função termina. Variáveis locais de funções diferentes são independentes, mesmo com o mesmo nome:

```c
/* escopo.c */
#include <stdio.h>

int soma_ate(int n) {
    int total = 0;                /* local: só existe dentro de soma_ate */
    for (int i = 1; i <= n; i++) {
        total += i;
    }
    return total;
}

int main(void) {
    int total = 100;              /* outra variável, com o mesmo nome */
    int soma = soma_ate(4);

    printf("total de main = %d, soma_ate(4) = %d\n", total, soma);
    return 0;
}
```

```text
total de main = 100, soma_ate(4) = 10
```

**Evite variáveis globais** (declaradas fora de qualquer função). Qualquer função pode alterá-las, e você deixa de conseguir dizer o que uma função faz olhando apenas seus parâmetros e retorno. Isso torna os testes imprevisíveis: o resultado passa a depender de "quem rodou antes". No projeto, funções **não** dependem de globais.

## 4. Decompondo um programa

Para dividir um programa em funções:

1. escreva o algoritmo em passos (Portugol);
2. dê um **nome de verbo** a cada passo que tem propósito próprio (`ler_medidas`, `calcular_area`, `imprimir_relatorio`);
3. defina, para cada um, o contrato: o que entra e o que sai;
4. deixe `main` apenas **coordenar** o fluxo: chamar as funções na ordem certa.

Um **diagrama de chamadas** mostra quem chama quem:

```text
main
 ├── ler_medidas
 ├── calcular_area
 │     └── limitar
 └── imprimir_relatorio
```

### Refatorar: extrair função

Refatorar é reorganizar o código **sem mudar o resultado**. Receita:

1. encontre um trecho repetido ou um bloco com propósito nomeável;
2. defina o contrato: quais valores o trecho usa (parâmetros) e qual valor produz (retorno);
3. crie a função e teste-a sozinha;
4. substitua o trecho pela chamada e confirme que o programa se comporta como antes.

Antes, com a mesma validação repetida em três pontos:

```text
if (idade < 0 || idade > 120) { ... }     // ler aluno
if (idade < 0 || idade > 120) { ... }     // ler professor
if (idade < 0 || idade > 120) { ... }     // ler visitante
```

Depois, com um nome e um lugar só para corrigir:

```text
int idade_valida(int idade);              // 1 se estiver entre 0 e 120
if (!idade_valida(idade)) { ... }
```

## 5. Vários arquivos: `.h` e `.c`

Quando o programa cresce, separe em módulos:

| Arquivo | Conteúdo | Quem usa |
|---|---|---|
| `nome.h` | **declarações** e contratos (a interface) | quem chama as funções |
| `nome.c` | **definições** (a implementação) | compilado uma vez |
| `programa.c` | `main` | usa `#include "nome.h"` |

Exemplo: um pequeno módulo de geometria e calendário.

```c
/* geometria.h */
#ifndef GEOMETRIA_H
#define GEOMETRIA_H

/* Area de um retangulo. Devolve 0.0 se base ou altura forem negativas. */
double area_retangulo(double base, double altura);

/* Perimetro de um retangulo. Devolve 0.0 se base ou altura forem negativas. */
double perimetro_retangulo(double base, double altura);

/* Restringe valor ao intervalo [minimo, maximo].
   Se minimo > maximo, devolve valor sem alteracao. */
int limitar(int valor, int minimo, int maximo);

/* Soma dos digitos de numero (numero >= 0). Devolve -1 se numero for negativo. */
int soma_digitos(long long numero);

/* Devolve 1 se o ano e bissexto e 0 caso contrario. */
int eh_bissexto(int ano);

#endif
```

```c
/* geometria.c */
#include "geometria.h"

double area_retangulo(double base, double altura) {
    if (base < 0.0 || altura < 0.0) {
        return 0.0;
    }
    return base * altura;
}

double perimetro_retangulo(double base, double altura) {
    if (base < 0.0 || altura < 0.0) {
        return 0.0;
    }
    return 2.0 * (base + altura);
}

int limitar(int valor, int minimo, int maximo) {
    if (minimo > maximo) {
        return valor;
    }
    if (valor < minimo) {
        return minimo;
    }
    if (valor > maximo) {
        return maximo;
    }
    return valor;
}

int soma_digitos(long long numero) {
    if (numero < 0) {
        return -1;
    }
    int soma = 0;
    while (numero > 0) {
        soma += (int)(numero % 10);   /* ultimo digito */
        numero /= 10;                 /* descarta o ultimo digito */
    }
    return soma;
}

int eh_bissexto(int ano) {
    return (ano % 4 == 0 && ano % 100 != 0) || ano % 400 == 0;
}
```

```c
/* sala.c */
#include <stdio.h>
#include "geometria.h"

int main(void) {
    double base;
    double altura;

    printf("Base e altura da sala (m): ");
    if (scanf("%lf %lf", &base, &altura) != 2) {
        printf("Entrada invalida.\n");
        return 1;
    }

    printf("Area: %.2f m2\n", area_retangulo(base, altura));
    printf("Perimetro: %.2f m\n", perimetro_retangulo(base, altura));
    return 0;
}
```

Para compilar, liste **todos os `.c`**; o `.h` é incluído pelo pré-processador:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion geometria.c sala.c -o build/sala
./build/sala
```

```text
Base e altura da sala (m): 4.5 3
Area: 13.50 m2
Perimetro: 15.00 m
```

Detalhes importantes:

- **Guarda de inclusão** (`#ifndef` / `#define` / `#endif`): impede que o mesmo `.h` seja processado duas vezes no mesmo programa.
- Use aspas para os seus cabeçalhos (`"geometria.h"`) e `< >` para os da biblioteca (`<stdio.h>`).
- O `.c` inclui o **próprio** `.h`: assim o compilador confere se as definições batem com as declarações.
- Só **um** arquivo do programa tem `main`.
- Funções auxiliares usadas apenas dentro de um `.c` ficam `static` e fora do `.h`.

## 6. Testes de função com `assert`

`assert(condicao)` (de `<assert.h>`) não faz nada se a condição for verdadeira e **aborta o programa** com uma mensagem se for falsa. Um arquivo de testes chama as funções com entradas conhecidas e afirma o resultado esperado. Assim, **os testes rodam sem entrada interativa** e podem ser repetidos a cada mudança.

```c
/* testes_geometria.c */
#include <assert.h>
#include <stdio.h>
#include "geometria.h"

/* Compara reais com tolerancia: nao use == para valores calculados. */
static int aprox(double a, double b) {
    double diferenca = a - b;
    if (diferenca < 0.0) {
        diferenca = -diferenca;
    }
    return diferenca < 0.000001;
}

static void testa_area(void) {
    assert(aprox(area_retangulo(3.0, 4.0), 12.0));
    assert(aprox(area_retangulo(0.0, 4.0), 0.0));      /* fronteira: lado zero */
    assert(aprox(area_retangulo(-1.0, 4.0), 0.0));     /* argumento invalido */
}

static void testa_limitar(void) {
    assert(limitar(5, 0, 10) == 5);       /* dentro */
    assert(limitar(0, 0, 10) == 0);       /* igual ao minimo */
    assert(limitar(10, 0, 10) == 10);     /* igual ao maximo */
    assert(limitar(-1, 0, 10) == 0);      /* abaixo */
    assert(limitar(11, 0, 10) == 10);     /* acima */
    assert(limitar(7, 10, 0) == 7);       /* intervalo invertido */
}

static void testa_soma_digitos(void) {
    assert(soma_digitos(0) == 0);
    assert(soma_digitos(7) == 7);
    assert(soma_digitos(123) == 6);
    assert(soma_digitos(9000000000LL) == 9);   /* maior que int */
    assert(soma_digitos(-5) == -1);
}

static void testa_bissexto(void) {
    assert(eh_bissexto(2024));    /* divisivel por 4 */
    assert(!eh_bissexto(2023));
    assert(!eh_bissexto(1900));   /* seculo nao divisivel por 400 */
    assert(eh_bissexto(2000));    /* seculo divisivel por 400 */
}

int main(void) {
    testa_area();
    testa_limitar();
    testa_soma_digitos();
    testa_bissexto();
    printf("Todos os testes passaram.\n");
    return 0;
}
```

```text
Todos os testes passaram.
```

Quando um teste falha, o programa para e diz **qual** afirmação falhou:

```text
falha: falha.c:9: main: Assertion `dobro(4) == 8' failed.
```

(arquivo, linha, função e a condição que era esperada; o exemplo acima vem de um arquivo `falha.c` com um teste errado de propósito). Boas práticas para os testes:

- teste os valores **normais**, as **fronteiras** (zero, limites, igual ao mínimo/máximo) e os **inválidos** documentados;
- um teste por comportamento, com nomes que dizem o que verificam (`testa_limitar`);
- para reais, compare com **tolerância** (a função `aprox` acima);
- não defina `NDEBUG` ao compilar os testes: ele desliga o `assert`, e por isso **nunca** coloque dentro do `assert` uma chamada que precise acontecer (com efeito colateral); guarde o resultado em uma variável e afirme sobre ela.

## Erros comuns

- **Usar a função antes de declarar**: o compilador avisa `implicit declaration`. Declare o protótipo antes de `main` ou inclua o `.h`.
- **Caminho sem `return`** em função que devolve valor (`-Wreturn-type` avisa).
- **Achar que alterar um parâmetro altera a variável de quem chamou** (passagem por valor).
- **Misturar cálculo e interação** (`scanf`/`printf` dentro do cálculo): a função fica impossível de testar sozinha.
- **Variáveis globais** como atalho para "passar" dados.
- **Nomes genéricos** (`calcula`, `funcao1`): use verbo + objeto (`calcular_media`, `eh_bissexto`).
- **Ponto e vírgula depois do cabeçalho** na definição: `int f(int x); { ... }`.
- **Definir função em um `.h`**: o `.h` só declara; o corpo fica no `.c`.
- **Esquecer um `.c` na compilação**: aparece `referência não definida` (erro do ligador).

## Autoteste

1. O que imprime `int f(int n) { n = n + 1; return n; }` chamada como `int a = 3; f(a); printf("%d", a);`?
2. Qual a diferença entre **declarar** e **definir** uma função?
3. Escreva o contrato de `dias_no_mes(mes, ano)`, incluindo o que acontece com meses inválidos.
4. Por que um teste automático não deve conter `scanf`?
5. Que valores você testaria para `soma_digitos`?

<details>
<summary>Respostas</summary>

1. Imprime `3`: `f` altera uma cópia, e o retorno foi descartado.
2. Declarar informa nome, tipos de parâmetros e de retorno (o protótipo, no `.h` ou antes de `main`); definir escreve o corpo. Pode haver várias declarações, mas só uma definição.
3. Por exemplo: "Devolve a quantidade de dias do mês `mes` (1 a 12) do ano `ano`, considerando anos bissextos em fevereiro. Devolve `-1` se `mes` não estiver entre 1 e 12."
4. Porque o teste precisa rodar sozinho, sempre com os mesmos dados, e uma leitura interativa depende de uma pessoa digitando.
5. `0`, um dígito (`7`), vários dígitos (`123`), zeros no meio (`1001`), um valor maior que `int` (`9000000000`) e o inválido (`-5`).

</details>

## Ligação com o Projeto 4

| Incremento do projeto | Onde estudar | Exemplo relacionado |
|---|---|---|
| 1. Contratos | seção 2 | contrato de `limitar` e `geometria.h` |
| 2. `ferramentas.c` e `ferramentas.h` | seção 5 | `geometria.h` e `geometria.c` |
| 3. Testes com `assert` | seção 6 | `testes_geometria.c` |
| 4. Refatorar um projeto anterior | seções 3 e 4 (extrair função, diagrama de chamadas) | receita da seção 4 |

**API mínima:**

- `esta_no_intervalo` e `percentual` pedem **decisões de contrato** que só a equipe pode tomar: o que fazer com limites invertidos e com `total = 0`? Escreva a decisão no `.h` e teste-a (seção 2).
- `media3` e `maximo3` são, na estrutura, iguais a `maior_de_dois` e a `limitar`: compare e teste as fronteiras (seção 6).
- `digito_verificador` precisa **extrair dígitos**: veja `soma_digitos` na seção 5 (`% 10` e `/ 10`). As **regras** do dígito (pesos, módulo, resultado) são da equipe: defina-as no contrato antes de implementar.

**Critérios de aceitação:** "`main` coordena o fluxo" → seção 4; "sem variáveis globais" → seção 3; "testes rodam sem entrada interativa" → seções 2 e 6.

## Para ir além

- Reescrever `eh_bissexto` e `eh_par` com `<stdbool.h>` (`bool`, `true`, `false`) e discutir o que ganha em legibilidade.
- Criar um `Makefile` com uma regra `check` que compila e executa os testes, como o do repositório.
- Pesquisar **recursão** (função que chama a si mesma): fatorial e soma de dígitos recursivos.

Próximo: [Material 5 — Vetores e strings](05-vetores-e-strings.md).
