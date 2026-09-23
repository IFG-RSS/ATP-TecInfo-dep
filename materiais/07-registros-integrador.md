# Material 7 — Registros e sistema modular

Apoia o [Projeto 7](../projetos/07-registros-integrador/README.md) (aulas 123–144 do [guia de avanço](../docs/guia-de-avanco.md#projeto-7)). Anterior: [Material 6](06-matrizes.md). Este é o último material; depois dele, consulte a [folha de apoio de C](linguagem-c.md) e o [guia de entrega](../docs/entrega.md).

O exemplo integrador é uma **biblioteca escolar** (livros e empréstimos), e não o sistema acadêmico. A estrutura é a mesma; adapte-a ao problema de estudantes, notas e frequência.

## Ao final você deve conseguir

- agrupar dados heterogêneos em um **registro** (`struct`) e manter **vetores de registros**;
- passar registros a funções por valor ou por endereço, sabendo quando usar cada um;
- separar um programa em **interface**, **regras** e **operações sobre a coleção**, em módulos `.h`/`.c`;
- testar as regras sem interação e criar um **roteiro de teste** para o menu;
- planejar, integrar e apresentar o sistema, com todos os integrantes capazes de explicar qualquer parte.

## 1. Registros (`struct`)

Nos vetores paralelos do Projeto 5, matrícula, nome e nota viviam em vetores separados e era preciso lembrar que "a posição `i` de todos descreve a mesma pessoa". Um **registro** reúne esses dados em **uma única variável**, com **campos** de tipos diferentes:

```c
typedef struct {
    char nome[30];
    int idade;
    double altura;
} Atleta;
```

- `struct { ... }` descreve o registro; `typedef ... Atleta;` dá ao tipo um nome curto. A partir daí, `Atleta` é usado como qualquer tipo (`int`, `double`).
- Os campos são acessados com **ponto**: `a.idade`, `a.nome`.
- A **atribuição** de registros copia **todos** os campos, inclusive os vetores de `char` que estiverem dentro deles.
- Um texto dentro do registro **não** se atribui com `=`: use `snprintf` (Material 5).

```c
/* registro_basico.c */
#include <stdio.h>

#define TAM_NOME 30
#define MAX_ATLETAS 3

typedef struct {
    char nome[TAM_NOME];
    int idade;
    double altura;
} Atleta;

int main(void) {
    Atleta a = {"Marta", 17, 1.62};
    Atleta b = a;                                   /* copia todos os campos */

    snprintf(b.nome, sizeof b.nome, "%s", "Bia");   /* texto: nao use = */
    b.idade = 16;

    printf("a: %s, %d anos, %.2f m\n", a.nome, a.idade, a.altura);
    printf("b: %s, %d anos, %.2f m\n", b.nome, b.idade, b.altura);

    Atleta time[MAX_ATLETAS] = {a, b, {"Lia", 18, 1.70}};
    double soma = 0.0;

    for (int i = 0; i < MAX_ATLETAS; i++) {
        soma += time[i].altura;
    }
    printf("Altura media do time: %.2f m\n", soma / MAX_ATLETAS);
    return 0;
}
```

```text
a: Marta, 17 anos, 1.62 m
b: Bia, 16 anos, 1.62 m
Altura media do time: 1.65 m
```

Note que `b` começou como cópia de `a`, mas mudar `b` **não** alterou `a`: são variáveis independentes.

### Vetor de registros

A coleção do sistema é um **vetor de registros** mais uma **quantidade em uso**, exatamente como nos vetores comuns:

```c
Atleta time[MAX_ATLETAS];    /* capacidade */
int total = 0;               /* quantidade em uso */
```

O elemento é `time[i]`, e o campo dele é `time[i].altura`. Todas as regras do Material 5 continuam valendo: acessar apenas `0..total-1`, validar antes de inserir, tratar coleção vazia.

## 2. Registros e funções

Há duas formas de passar um registro a uma função:

| Situação | Como passar | Exemplo |
|---|---|---|
| a função apenas **consulta** um registro pequeno | **por valor** (recebe uma cópia) | `int livro_disponiveis(Livro livro)` |
| a função **altera** o registro | **por endereço** | `int livro_emprestar(Livro *livro)` |
| a função apenas consulta um registro **grande** (como a coleção inteira) | por endereço, com `const` | `int acervo_buscar(const Acervo *acervo, int id)` |

**Endereços.** Você já usa endereços desde o `scanf("%d", &x)`: o `&` entrega ao `scanf` **onde** a variável está, para que ele possa gravar nela. Uma função que recebe `Atleta *x` (lê-se "x é o endereço de um `Atleta`") trabalha sobre o **registro original**, e não sobre uma cópia. Duas regras bastam por ora:

- na chamada, passe o endereço com `&`: `fazer_aniversario(&a)`;
- dentro da função, acesse os campos com **seta**: `x->idade` (equivale a "o campo `idade` do registro apontado").

```c
/* registro_funcoes.c */
#include <stdio.h>

typedef struct {
    char nome[30];
    int idade;
} Pessoa;

/* Por valor: consulta. Nao altera o original. */
int idade_no_ano_que_vem(Pessoa pessoa) {
    pessoa.idade++;              /* altera so a copia */
    return pessoa.idade;
}

/* Por endereco: altera o registro do chamador. */
void fazer_aniversario(Pessoa *pessoa) {
    pessoa->idade++;
}

int main(void) {
    Pessoa p = {"Marta", 17};

    printf("Ano que vem: %d\n", idade_no_ano_que_vem(p));
    printf("Idade agora: %d\n", p.idade);

    fazer_aniversario(&p);
    printf("Depois do aniversario: %d\n", p.idade);
    return 0;
}
```

```text
Ano que vem: 18
Idade agora: 17
Depois do aniversario: 18
```

Um **vetor** já é passado "por endereço" (Material 5), por isso uma função que recebe `Pessoa lista[]` altera os elementos originais sem precisar de `&`. Para alterar **um único registro** ou a **quantidade** `total`, é necessário o endereço.

## 3. Do problema ao sistema: camadas

Um programa com menu, regras e dados fica confuso se tudo estiver em `main`. Organize em **três camadas**, cada uma em um arquivo (ou par `.h`/`.c`):

| Camada | Responsabilidade | Faz `scanf`/`printf`? |
|---|---|:-:|
| **interface** | menu, leitura de dados, mensagens, impressão de relatórios | sim |
| **coleção** | guardar os registros: cadastrar, buscar, atualizar, contar | não |
| **regras** | cálculos e classificações sobre **um** registro (média, situação) | não |

```text
biblioteca.c    interface: menu, leitura, impressao
     │ usa
     ├───────────► acervo.h / acervo.c   colecao: cadastrar, buscar, emprestar
     │                    │ usa
     └───────────► livro.h / livro.c ◄───┘   regras de um livro

testes.c ──► acervo, livro       (sem menu, sem entrada interativa)
```

Regra de dependência: a interface usa a coleção e as regras; a coleção usa as regras; **as regras não usam nada acima delas** e nunca imprimem nem leem. Assim as regras e a coleção podem ser testadas sem menu.

O mapeamento com o Projeto 7:

| Neste exemplo | No seu sistema |
|---|---|
| `Livro` | `Estudante` |
| `Acervo` | `Turma` (coleção) |
| `livro.h`, `livro.c` | `estudante.h`, `estudante.c` |
| `acervo.h`, `acervo.c` | `turma.h`, `turma.c` |
| `biblioteca.c` | `sistema.c` |
| `testes.c` | `testes.c` |

## 4. Exemplo completo: biblioteca escolar

Requisitos, em forma de histórias: cadastrar um livro com **ID único**; **impedir** cadastro além da capacidade; registrar **empréstimos** enquanto houver cópias; **listar** os livros com uma **situação** (esgotado, poucas cópias, disponível). A capacidade é `3` só para que a demonstração mostre o limite rapidamente; no seu projeto será `100`.

### Regras de um livro (`livro.h`, `livro.c`)

```c
/* livro.h */
#ifndef LIVRO_H
#define LIVRO_H

#define TAM_TITULO 50

typedef struct {
    int id;
    char titulo[TAM_TITULO];
    int exemplares;     /* copias que a biblioteca possui */
    int emprestados;    /* copias emprestadas no momento */
} Livro;

typedef enum {
    SITUACAO_ESGOTADO,
    SITUACAO_POUCAS_COPIAS,
    SITUACAO_DISPONIVEL
} Situacao;

/* Preenche *livro. Devolve 1 se os dados sao validos (id > 0, exemplares > 0
   e titulo com 1 a TAM_TITULO-1 caracteres) e 0 caso contrario; nesse caso
   *livro nao e alterado. */
int livro_preencher(Livro *livro, int id, const char titulo[], int exemplares);

/* Copias disponiveis para emprestimo. */
int livro_disponiveis(Livro livro);

/* ESGOTADO se nao ha copia; POUCAS_COPIAS se resta uma; DISPONIVEL nos demais casos. */
Situacao livro_situacao(Livro livro);

/* Nome legivel da situacao, para exibicao. */
const char *nome_situacao(Situacao situacao);

/* Registra um emprestimo. Devolve 1 se havia copia disponivel e 0 caso contrario. */
int livro_emprestar(Livro *livro);

#endif
```

`typedef enum { ... } Situacao;` cria uma **enumeração**: um tipo cujos valores são nomes (`SITUACAO_ESGOTADO`, ...), no lugar de números soltos como `0`, `1`, `2`. `const char *` é "um texto que não será alterado", e pode ser passado ao `printf("%s", ...)`.

```c
/* livro.c */
#include <stdio.h>
#include <string.h>
#include "livro.h"

int livro_preencher(Livro *livro, int id, const char titulo[], int exemplares) {
    size_t tamanho = strlen(titulo);

    if (id <= 0 || exemplares <= 0 || tamanho == 0 || tamanho >= TAM_TITULO) {
        return 0;
    }
    livro->id = id;
    snprintf(livro->titulo, sizeof livro->titulo, "%s", titulo);
    livro->exemplares = exemplares;
    livro->emprestados = 0;
    return 1;
}

int livro_disponiveis(Livro livro) {
    return livro.exemplares - livro.emprestados;
}

Situacao livro_situacao(Livro livro) {
    int disponiveis = livro_disponiveis(livro);

    if (disponiveis == 0) {
        return SITUACAO_ESGOTADO;
    }
    if (disponiveis == 1) {
        return SITUACAO_POUCAS_COPIAS;
    }
    return SITUACAO_DISPONIVEL;
}

const char *nome_situacao(Situacao situacao) {
    switch (situacao) {
        case SITUACAO_ESGOTADO:
            return "ESGOTADO";
        case SITUACAO_POUCAS_COPIAS:
            return "POUCAS COPIAS";
        case SITUACAO_DISPONIVEL:
            return "DISPONIVEL";
    }
    return "?";
}

int livro_emprestar(Livro *livro) {
    if (livro->emprestados >= livro->exemplares) {
        return 0;
    }
    livro->emprestados++;
    return 1;
}
```

Observe: a validação está **em um lugar só** (`livro_preencher`), e a situação tem regras explícitas para os limites (`0`, `1` e `2 ou mais` cópias disponíveis).

### Operações sobre a coleção (`acervo.h`, `acervo.c`)

```c
/* acervo.h */
#ifndef ACERVO_H
#define ACERVO_H

#include "livro.h"

#define MAX_LIVROS 3

#define ACERVO_OK 0
#define ACERVO_CHEIO (-1)
#define ACERVO_DUPLICADO (-2)
#define ACERVO_NAO_ENCONTRADO (-3)
#define ACERVO_ESGOTADO (-4)

typedef struct {
    Livro itens[MAX_LIVROS];
    int total;              /* quantos itens estao em uso */
} Acervo;

/* Deixa o acervo vazio. */
void acervo_iniciar(Acervo *acervo);

/* Posicao do livro com o id dado em itens[0..total-1], ou -1 se ausente. */
int acervo_buscar(const Acervo *acervo, int id);

/* Acrescenta livro ao final. Verifica primeiro id duplicado (ACERVO_DUPLICADO)
   e depois a capacidade (ACERVO_CHEIO). Devolve ACERVO_OK em caso de sucesso. */
int acervo_cadastrar(Acervo *acervo, Livro livro);

/* Registra um emprestimo do livro com o id dado. Devolve ACERVO_OK,
   ACERVO_NAO_ENCONTRADO ou ACERVO_ESGOTADO. */
int acervo_emprestar(Acervo *acervo, int id);

#endif
```

```c
/* acervo.c */
#include "acervo.h"

void acervo_iniciar(Acervo *acervo) {
    acervo->total = 0;
}

int acervo_buscar(const Acervo *acervo, int id) {
    for (int i = 0; i < acervo->total; i++) {
        if (acervo->itens[i].id == id) {
            return i;
        }
    }
    return -1;
}

int acervo_cadastrar(Acervo *acervo, Livro livro) {
    if (acervo_buscar(acervo, livro.id) != -1) {
        return ACERVO_DUPLICADO;
    }
    if (acervo->total >= MAX_LIVROS) {
        return ACERVO_CHEIO;
    }
    acervo->itens[acervo->total] = livro;
    acervo->total++;
    return ACERVO_OK;
}

int acervo_emprestar(Acervo *acervo, int id) {
    int pos = acervo_buscar(acervo, id);

    if (pos == -1) {
        return ACERVO_NAO_ENCONTRADO;
    }
    if (!livro_emprestar(&acervo->itens[pos])) {
        return ACERVO_ESGOTADO;
    }
    return ACERVO_OK;
}
```

Repare que a coleção **devolve códigos** em vez de imprimir mensagens: quem decide o que dizer ao usuário é a interface. A **ordem** das verificações em `acervo_cadastrar` (duplicado antes de cheio) é uma decisão de precedência, como nas tabelas do Material 2, e está escrita no contrato.

### Interface (`biblioteca.c`)

```c
/* biblioteca.c */
#include <stdio.h>
#include "acervo.h"
#include "livro.h"

static void listar(const Acervo *acervo) {
    if (acervo->total == 0) {
        printf("Acervo vazio.\n");
        return;
    }
    printf("%-4s %-20s %5s %5s  %s\n", "ID", "Titulo", "Disp", "Total", "Situacao");
    for (int i = 0; i < acervo->total; i++) {
        Livro livro = acervo->itens[i];
        printf("%-4d %-20s %5d %5d  %s\n", livro.id, livro.titulo,
               livro_disponiveis(livro), livro.exemplares,
               nome_situacao(livro_situacao(livro)));
    }
}

static void cadastrar(Acervo *acervo) {
    int id;
    int exemplares;
    char titulo[TAM_TITULO];
    Livro livro;

    printf("ID, titulo (sem espacos) e exemplares: ");
    /* o 49 em %49s deve ser TAM_TITULO - 1 */
    if (scanf("%d %49s %d", &id, titulo, &exemplares) != 3) {
        printf("Entrada invalida.\n");
        return;
    }
    if (!livro_preencher(&livro, id, titulo, exemplares)) {
        printf("Dados invalidos.\n");
        return;
    }

    switch (acervo_cadastrar(acervo, livro)) {
        case ACERVO_OK:
            printf("Cadastrado.\n");
            break;
        case ACERVO_DUPLICADO:
            printf("Ja existe livro com o ID %d.\n", id);
            break;
        case ACERVO_CHEIO:
            printf("Acervo cheio (maximo %d).\n", MAX_LIVROS);
            break;
        default:
            printf("Erro inesperado.\n");
            break;
    }
}

static void emprestar(Acervo *acervo) {
    int id;

    printf("ID do livro: ");
    if (scanf("%d", &id) != 1) {
        printf("Entrada invalida.\n");
        return;
    }

    switch (acervo_emprestar(acervo, id)) {
        case ACERVO_OK:
            printf("Emprestimo registrado.\n");
            break;
        case ACERVO_NAO_ENCONTRADO:
            printf("Livro %d nao encontrado.\n", id);
            break;
        case ACERVO_ESGOTADO:
            printf("Livro %d esgotado.\n", id);
            break;
        default:
            printf("Erro inesperado.\n");
            break;
    }
}

int main(void) {
    Acervo acervo;
    int opcao = -1;

    acervo_iniciar(&acervo);

    while (opcao != 0) {
        printf("\n1) Cadastrar  2) Listar  3) Emprestar  0) Sair\nOpcao: ");
        if (scanf("%d", &opcao) != 1) {
            printf("\nEntrada encerrada.\n");
            return 1;
        }

        switch (opcao) {
            case 1:
                cadastrar(&acervo);
                break;
            case 2:
                listar(&acervo);
                break;
            case 3:
                emprestar(&acervo);
                break;
            case 0:
                printf("Ate logo.\n");
                break;
            default:
                printf("Opcao invalida.\n");
                break;
        }
    }
    return 0;
}
```

Detalhes da interface:

- as funções `static` (`listar`, `cadastrar`, `emprestar`) só existem neste arquivo: não fazem parte da interface pública de nenhum módulo;
- `main` só **coordena**: mostra o menu, lê a opção e chama a função certa;
- para simplificar, o texto digitado em `titulo` não tem espaços (`%49s`), e uma entrada que não seja número encerra o programa. Um sistema real trataria isso com `fgets` e descarte de linha (Materiais 3 e 5).

Compile e execute (todos os `.c` do programa, **um** `main`):

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion livro.c acervo.c biblioteca.c -o build/biblioteca
./build/biblioteca
```

Sessão de exemplo, que exercita cadastro, dado inválido, ID duplicado, empréstimo, esgotamento, ID inexistente, listagem e acervo cheio:

```text

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 1
ID, titulo (sem espacos) e exemplares: 1 Dom_Casmurro 2
Cadastrado.

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 1
ID, titulo (sem espacos) e exemplares: 5 Livro_X 0
Dados invalidos.

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 1
ID, titulo (sem espacos) e exemplares: 1 Outro_Livro 1
Ja existe livro com o ID 1.

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 1
ID, titulo (sem espacos) e exemplares: 2 Capitaes_da_Areia 1
Cadastrado.

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 3
ID do livro: 2
Emprestimo registrado.

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 3
ID do livro: 2
Livro 2 esgotado.

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 3
ID do livro: 9
Livro 9 nao encontrado.

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 2
ID   Titulo                Disp Total  Situacao
1    Dom_Casmurro             2     2  DISPONIVEL
2    Capitaes_da_Areia        0     1  ESGOTADO

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 1
ID, titulo (sem espacos) e exemplares: 3 Iracema 4
Cadastrado.

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 1
ID, titulo (sem espacos) e exemplares: 4 Senhora 1
Acervo cheio (maximo 3).

1) Cadastrar  2) Listar  3) Emprestar  0) Sair
Opcao: 0
Ate logo.
```

## 5. Testes do sistema

### Testes de unidade das regras e da coleção

O arquivo `testes.c` chama as funções **diretamente**, sem menu, e usa `assert`. Repare que as chamadas com efeito colateral (`livro_emprestar`, `acervo_cadastrar`) ficam **fora** do `assert`, em uma variável: se o `assert` fosse desligado (`NDEBUG`), a própria chamada desapareceria junto e o teste passaria a esconder o defeito.

```c
/* testes.c */
#include <assert.h>
#include <stdio.h>
#include "acervo.h"
#include "livro.h"

#define DEZ "AAAAAAAAAA"

static Livro livro_valido(int id, int exemplares) {
    Livro livro = {0};
    int ok = livro_preencher(&livro, id, "Titulo", exemplares);

    assert(ok);
    return livro;
}

static void testa_situacao_e_emprestimo(void) {
    Livro livro = livro_valido(1, 3);
    int ok;

    assert(livro_disponiveis(livro) == 3);
    assert(livro_situacao(livro) == SITUACAO_DISPONIVEL);

    ok = livro_emprestar(&livro);                    /* restam 2 */
    assert(ok);
    assert(livro_situacao(livro) == SITUACAO_DISPONIVEL);

    ok = livro_emprestar(&livro);                    /* resta 1: fronteira */
    assert(ok);
    assert(livro_situacao(livro) == SITUACAO_POUCAS_COPIAS);

    ok = livro_emprestar(&livro);                    /* restam 0: fronteira */
    assert(ok);
    assert(livro_situacao(livro) == SITUACAO_ESGOTADO);

    ok = livro_emprestar(&livro);                    /* nada a emprestar */
    assert(!ok);
    assert(livro_disponiveis(livro) == 0);           /* nao ficou negativo */
}

static void testa_dados_invalidos(void) {
    Livro livro = {0};
    int ok;

    ok = livro_preencher(&livro, 0, "X", 1);         /* id */
    assert(!ok);
    ok = livro_preencher(&livro, 1, "", 1);          /* titulo vazio */
    assert(!ok);
    ok = livro_preencher(&livro, 1, "X", 0);         /* exemplares */
    assert(!ok);

    /* limite do titulo: 49 caracteres cabem, 50 nao */
    ok = livro_preencher(&livro, 1, DEZ DEZ DEZ DEZ "AAAAAAAAA", 1);
    assert(ok);
    ok = livro_preencher(&livro, 1, DEZ DEZ DEZ DEZ DEZ, 1);
    assert(!ok);
}

static void testa_acervo(void) {
    Acervo acervo;
    int r;

    acervo_iniciar(&acervo);
    assert(acervo.total == 0);
    assert(acervo_buscar(&acervo, 1) == -1);         /* acervo vazio */

    for (int id = 1; id <= MAX_LIVROS; id++) {
        r = acervo_cadastrar(&acervo, livro_valido(id, 1));
        assert(r == ACERVO_OK);
    }
    assert(acervo.total == MAX_LIVROS);
    assert(acervo_buscar(&acervo, 1) == 0);          /* primeiro */
    assert(acervo_buscar(&acervo, MAX_LIVROS) == MAX_LIVROS - 1);   /* ultimo */
    assert(acervo_buscar(&acervo, 99) == -1);

    r = acervo_cadastrar(&acervo, livro_valido(99, 1));
    assert(r == ACERVO_CHEIO);                       /* id novo, sem espaco */
    r = acervo_cadastrar(&acervo, livro_valido(1, 1));
    assert(r == ACERVO_DUPLICADO);                   /* duplicado vem antes de cheio */
    assert(acervo.total == MAX_LIVROS);              /* nada foi acrescentado */

    r = acervo_emprestar(&acervo, 1);
    assert(r == ACERVO_OK);
    r = acervo_emprestar(&acervo, 1);
    assert(r == ACERVO_ESGOTADO);                    /* so havia 1 exemplar */
    r = acervo_emprestar(&acervo, 99);
    assert(r == ACERVO_NAO_ENCONTRADO);
}

int main(void) {
    testa_situacao_e_emprestimo();
    testa_dados_invalidos();
    testa_acervo();
    printf("Todos os testes passaram.\n");
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion livro.c acervo.c testes.c -o build/testes
./build/testes
```

```text
Todos os testes passaram.
```

Os testes cobrem: **fronteiras** das regras (`0`, `1`, `2` cópias), **limite** do título (49 e 50 caracteres), **capacidade** (primeiro e último item, coleção cheia), **duplicidade**, **ausência** e o efeito **nulo** de uma inserção rejeitada.

### Roteiro de teste do menu

O menu depende de interação; por isso, além dos testes de unidade, registre um **roteiro**: uma sequência de passos com o resultado esperado, para ser executada a cada versão. A sessão de exemplo acima segue este roteiro:

| Passo | Ação | Resultado esperado |
|---:|---|---|
| 1 | cadastrar `1 Dom_Casmurro 2` | `Cadastrado.` |
| 2 | cadastrar `5 Livro_X 0` | `Dados invalidos.` |
| 3 | cadastrar `1 Outro_Livro 1` | `Ja existe livro com o ID 1.` |
| 4 | cadastrar `2 Capitaes_da_Areia 1` | `Cadastrado.` |
| 5 | emprestar `2` | `Emprestimo registrado.` |
| 6 | emprestar `2` | `Livro 2 esgotado.` |
| 7 | emprestar `9` | `Livro 9 nao encontrado.` |
| 8 | listar | livro 1: `2 2 DISPONIVEL`; livro 2: `0 1 ESGOTADO` |
| 9 | cadastrar `3 Iracema 4` | `Cadastrado.` |
| 10 | cadastrar `4 Senhora 1` | `Acervo cheio (maximo 3).` |
| 11 | sair (`0`) | `Ate logo.` |

Truque: guarde as entradas do roteiro em um arquivo texto (uma por linha) e execute `./build/biblioteca < roteiro.txt`. O programa lê as respostas do arquivo, e você compara a saída com o esperado.

## 6. Planejar, integrar e apresentar

**Do backlog às funções.** Para cada história de usuário, defina o módulo, a função e o teste:

| História (biblioteca) | Módulo | Função | Teste |
|---|---|---|---|
| cadastrar livro com ID único | coleção | `acervo_cadastrar` | duplicado, cheio, primeiro e último item |
| consultar situação | regras | `livro_situacao` | fronteiras de 0, 1 e 2 cópias |
| registrar empréstimo | coleção + regras | `acervo_emprestar` | ok, esgotado, inexistente |
| listar com situação | interface | `listar` | passo 8 do roteiro |

Faça o mesmo com as cinco histórias do Projeto 7. A história do auditor (validar a matrícula com o **dígito verificador** do Projeto 4) pode reutilizar seus `ferramentas.h` e `ferramentas.c` sem copiá-los: acrescente o arquivo à linha de compilação e o diretório ao `-I`:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    -I projetos/04-funcoes projetos/04-funcoes/ferramentas.c \
    projetos/07-registros-integrador/estudante.c projetos/07-registros-integrador/turma.c \
    projetos/07-registros-integrador/sistema.c -o build/sistema
```

**Ordem de construção** (incrementos I1 a I4 do projeto):

1. **modelo:** desenhe o registro; escreva `estudante.h` e `turma.h` com **contratos**; faça cadastro e listagem funcionarem;
2. **regras:** média, percentual de frequência e situação, com testes de fronteira **antes** da interface;
3. **consultas:** busca, atualização e relatório agregado (média da turma, maior e menor média, contagem por situação), usando percursos do Material 3 e do 5;
4. **qualidade:** testes, roteiro do menu, revisão em pares, manual, demonstração.

**Checklist de integração** (antes de cada entrega):

- [ ] compila sem avisos com `-std=c17 -Wall -Wextra -Wpedantic -Wconversion`;
- [ ] os testes de unidade passam;
- [ ] o roteiro do menu foi executado e conferido;
- [ ] as duas fronteiras da coleção (limite de 100 cadastros e matrícula duplicada) foram testadas;
- [ ] nenhuma função de regras ou de coleção imprime ou lê dados;
- [ ] não há variáveis globais;
- [ ] todos os integrantes aparecem no histórico do `git` e explicam qualquer módulo.

**Manual curto** (uma página no `diario.md` ou em arquivo próprio): o que o sistema faz; como compilar e executar; o menu e cada opção; o que acontece nos casos de erro; limites conhecidos.

**Apresentação de 8 minutos** (sugestão): problema e público (1 min); arquitetura e responsabilidades de cada módulo (1,5 min); demonstração do roteiro no menu (3 min); testes e um defeito que ensinou algo (1,5 min); o que fariam a seguir (1 min). Como cada integrante demonstra uma parte **sorteada**, todos precisam entender o programa inteiro.

## Erros comuns

- **Comparar ou copiar textos de um campo com `==`/`=`**: use `strcmp` e `snprintf`.
- **Passar o registro por valor** a uma função que deveria alterá-lo: a alteração se perde na cópia.
- **Esquecer `&` na chamada** de uma função que recebe endereço (o compilador avisa: tipos incompatíveis).
- **Usar `.` onde precisa de `->`** (e vice-versa): com `Livro *livro`, use `livro->id`; com `Livro livro`, use `livro.id`.
- **Módulo de regras com `printf`/`scanf`**: impossível de testar sozinho.
- **Cadastrar sem verificar** capacidade ou duplicidade.
- **`.h` sem guarda de inclusão**, ou com definições de funções.
- **`assert` com efeito colateral** dentro (`assert(cadastrar(...))`): a chamada some com `NDEBUG`.
- **Mais de um `main`** na compilação (por exemplo, `testes.c` junto com `biblioteca.c`).
- **Dividir o trabalho sem contratos**: cada pessoa implementa uma função diferente do que a outra espera.

## Autoteste

1. Qual a diferença entre `livro.id` e `livro->id`? Quando usar cada uma?
2. Por que `livro_emprestar` recebe `Livro *` e `livro_disponiveis` recebe `Livro`?
3. Por que a coleção devolve códigos em vez de imprimir mensagens?
4. O que acontece com a coleção de 3 livros ao cadastrar um livro de ID repetido? E se ela estiver cheia e o ID for novo?
5. Que testes você adicionaria para o campo `emprestados` nunca ficar negativo ou maior que `exemplares`?

<details>
<summary>Respostas</summary>

1. `livro.id` acessa o campo de um registro que está em uma variável (ou recebido por valor); `livro->id` acessa o campo do registro **apontado** por um endereço (`Livro *livro`).
2. A primeira **altera** o registro do chamador, então precisa do endereço; a segunda só **consulta** e pode trabalhar com uma cópia.
3. Para separar as camadas: só a interface decide o texto e o idioma, e a coleção pode ser testada e reutilizada sem entrada e saída.
4. ID repetido: devolve `ACERVO_DUPLICADO` e nada é acrescentado. Coleção cheia com ID novo: devolve `ACERVO_CHEIO`. A ordem de verificação (duplicado primeiro) está no contrato e no teste.
5. Emprestar até esgotar e tentar mais uma vez (já no teste): `emprestados` deve continuar igual a `exemplares`. Para o limite inferior, verificar que `livro_preencher` inicia `emprestados` em `0`.

</details>

## Ligação com o Projeto 7

| Item do projeto | Onde estudar | Exemplo relacionado |
|---|---|---|
| Modelo inicial: `struct Estudante` e vetor de registros | seção 1 | `registro_basico.c`, `Acervo` |
| História 1: cadastro com matrícula única e limite de 100 | seções 1 e 4 | `acervo_cadastrar` |
| História 2: buscar por matrícula e atualizar | seções 2 e 4 | `acervo_buscar`, `livro_emprestar` |
| História 3: média, frequência e situação justificada | seção 4 (regras) | `livro_situacao`, `nome_situacao` |
| História 4: relatório agregado | seções 4 e 6 | `listar` (interface) + percursos do Material 5 |
| História 5: dígito verificador do Projeto 4 | seção 6 | compilação com `-I` e `ferramentas.c` |
| Arquitetura (`sistema`, `estudante`, `turma`, `testes`) | seção 3 | tabela de mapeamento |
| Testes de unidade e roteiro do menu | seção 5 | `testes.c` e o roteiro |
| Demonstração de 8 minutos | seção 6 | roteiro de apresentação |

**Critérios de aceitação:** "compila sem avisos" → seção 4 (comando); "impede mais de 100 cadastros e matrículas duplicadas" → `acervo_cadastrar`; "não acessa posições inválidas" → Material 5, seção 1; "define situação para todos os limites" → `livro_situacao` e seus testes de fronteira; "separa interface, regras e coleção" → seção 3; "testes de unidade e roteiro do menu" → seção 5.

## Para ir além

- Ordenar a coleção por nome ou média e discutir o custo de manter a ordem a cada inserção.
- Pesquisar por fragmento do nome com `strstr` (`<string.h>`).
- Exportar e importar **CSV** com `fopen`, `fprintf` e `fgets`: a persistência é extensão, não requisito.
- Comparar turmas em uma **matriz** (turma × situação).
- Substituir a capacidade fixa por **alocação dinâmica** (`malloc`), quando o curso avançar em ponteiros.
