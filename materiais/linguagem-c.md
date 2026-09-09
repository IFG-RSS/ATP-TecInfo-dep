# Folha de apoio: C17

## Estrutura mínima

```c
#include <stdio.h>

int main(void) {
    printf("Ola, mundo!\n");
    return 0;
}
```

## Tipos e entrada/saída

| Intenção | Tipo | `scanf` | `printf` |
|---|---|---|---|
| inteiro | `int` | `%d` e `&variavel` | `%d` |
| inteiro longo | `long long` | `%lld` | `%lld` |
| real | `double` | `%lf` | `%f` ou `%.2f` |
| caractere | `char` | ` %c` | `%c` |
| texto | `char texto[N]` | prefira `fgets` | `%s` |

Verifique quantos valores `scanf` conseguiu ler. `int / int` produz inteiro; converta um operando para `double` quando precisar da parte fracionária.

```c
if (condicao) { /* ... */ } else { /* ... */ }
while (condicao) { /* ... */ }
do { /* ... */ } while (condicao);
for (int i = 0; i < limite; i++) { /* ... */ }
```

```c
double media(const double valores[], int quantidade);

typedef struct {
    int matricula;
    char nome[81];
    double nota;
} Estudante;
```

Vetores começam no índice zero. Para `n` elementos, os índices válidos vão de `0` a `n - 1`. Passe o tamanho a funções que recebem vetores.

## Checklist

- compile com `-Wall -Wextra -Wpedantic -Wconversion`;
- inicialize acumuladores e contadores;
- proteja divisões contra zero;
- respeite limites de vetores e textos;
- teste o menor e o maior valor permitido.
