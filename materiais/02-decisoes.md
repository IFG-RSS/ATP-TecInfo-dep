# Material 2 — Decisões

Apoia o [Projeto 2](../projetos/02-decisoes/README.md) (aulas 27–44 do [guia de avanço](../docs/guia-de-avanco.md#projeto-2)). Anterior: [Material 1](01-sequencia-e-expressoes.md). Próximo: [Material 3](03-repeticoes.md).

Os exemplos usam triângulos, fretes e categorias de atletas, não bolsas. Adapte as técnicas ao problema da triagem.

## Ao final você deve conseguir

- construir condições com operadores relacionais e lógicos, sem sobreposições;
- transformar uma **tabela de decisão** em `if`/`else if`/`else` que produz uma única classificação;
- escolher entre `if` encadeado e `switch`;
- validar entradas antes de classificar;
- criar testes abaixo, igual e acima de cada limite.

## 1. Condições em C

Em C, **falso é `0`** e **verdadeiro é qualquer valor diferente de zero**. Uma comparação produz `1` (verdadeiro) ou `0` (falso).

| Operador | Significado | Exemplo | Resultado |
|---|---|---|---|
| `==` | igual | `5 == 5` | `1` |
| `!=` | diferente | `5 != 5` | `0` |
| `<` `<=` | menor, menor ou igual | `3 <= 3` | `1` |
| `>` `>=` | maior, maior ou igual | `3 > 4` | `0` |

**Cuidado:** `=` atribui, `==` compara. `if (x = 0)` compila, zera `x` e nunca entra no `if`. O `-Wall` avisa; leia o aviso.

### Operadores lógicos

| Operador | Significado | Verdadeiro quando |
|---|---|---|
| `&&` | **e** | as duas condições são verdadeiras |
| `\|\|` | **ou** | ao menos uma é verdadeira |
| `!` | **não** | a condição é falsa |

| `a` | `b` | `a && b` | `a \|\| b` | `!a` |
|---|---|---|---|---|
| V | V | V | V | F |
| V | F | F | V | F |
| F | V | F | V | V |
| F | F | F | F | V |

Precedência: `!` primeiro, depois `&&`, depois `||`. Use parênteses para deixar a intenção clara: `(a || b) && c`.

**Curto-circuito:** em `a && b`, se `a` é falso, `b` nem é avaliado; em `a || b`, se `a` é verdadeiro, `b` não é avaliado. Isso permite escrever `if (n != 0 && total / n > 10)` sem dividir por zero.

**Intervalos:** a expressão matemática `0 <= x <= 100` **não funciona** em C: ela compila, mas é sempre verdadeira, porque `0 <= x` vale `0` ou `1`, e ambos são menores que `100`. Escreva `x >= 0 && x <= 100`. Para "fora do intervalo": `x < 0 || x > 100`.

## 2. `if`, `else` e `else if`

```c
if (condicao) {
    /* executa se a condição for verdadeira */
} else if (outra_condicao) {
    /* executa se a primeira for falsa e esta for verdadeira */
} else {
    /* executa se nenhuma anterior for verdadeira */
}
```

- As condições são avaliadas **de cima para baixo**; ao encontrar a primeira verdadeira, o restante da cadeia é ignorado. Por isso a **ordem** das regras é decisiva.
- Use **sempre chaves**, mesmo com uma única instrução: evita erros ao acrescentar linhas depois.
- Uma cadeia `if / else if / else` executa **exatamente um** ramo. Vários `if` independentes podem executar vários.

### Por que `else if` e não vários `if`

```c
/* sobreposicao.c */
#include <stdio.h>

int main(void) {
    int pontos = 95;

    printf("Com ifs independentes:\n");
    if (pontos >= 90) {
        printf("  conceito A\n");
    }
    if (pontos >= 70) {
        printf("  conceito B\n");
    }
    if (pontos >= 50) {
        printf("  conceito C\n");
    }

    printf("Com else if:\n");
    if (pontos >= 90) {
        printf("  conceito A\n");
    } else if (pontos >= 70) {
        printf("  conceito B\n");
    } else if (pontos >= 50) {
        printf("  conceito C\n");
    } else {
        printf("  conceito D\n");
    }
    return 0;
}
```

```text
Com ifs independentes:
  conceito A
  conceito B
  conceito C
Com else if:
  conceito A
```

As condições dos `if` independentes **se sobrepõem**: 95 satisfaz as três, e o resultado é uma classificação contraditória. Na cadeia, cada condição só é testada se as anteriores falharam; por isso `pontos >= 70` já significa "de 70 a 89".

Use `if`s independentes quando as condições **realmente não se excluem** (por exemplo, "aplicar desconto de cliente antigo" e "aplicar frete grátis" podem valer ao mesmo tempo).

## 3. Da tabela de decisão ao código

Uma **tabela de decisão** organiza as regras antes de codificar. Ela deve responder: quais condições existem, em que **ordem de precedência** são avaliadas e o que acontece em cada **fronteira**.

Exemplo: frete de uma loja.

| Ordem | Condição | Resultado |
|---:|---|---|
| 1 | peso inválido (menor ou igual a 0, ou maior que 30) | `INVALIDO` |
| 2 | peso até 1 kg (inclusive) | R$ 8,00 |
| 3 | peso até 5 kg (inclusive) | R$ 15,00 |
| 4 | demais (acima de 5 até 30) | R$ 30,00 |

Observe: na linha 3 não é preciso escrever "maior que 1 e até 5", porque a linha 2 já capturou os pesos até 1. A **precedência substitui condições repetidas**.

```c
/* frete.c */
#include <stdio.h>

int main(void) {
    double peso;

    printf("Peso do pacote (kg): ");
    if (scanf("%lf", &peso) != 1) {
        printf("Entrada invalida.\n");
        return 1;
    }

    if (peso <= 0.0 || peso > 30.0) {
        printf("INVALIDO: peso fora de 0 a 30 kg\n");
    } else if (peso <= 1.0) {
        printf("Frete: R$ 8.00\n");
    } else if (peso <= 5.0) {
        printf("Frete: R$ 15.00\n");
    } else {
        printf("Frete: R$ 30.00\n");
    }
    return 0;
}
```

```text
Peso do pacote (kg): 1
Frete: R$ 8.00
```

Trate a **validação primeiro**: dados inválidos não devem chegar às regras de negócio. Aqui a linha 1 da tabela é o primeiro `if`.

### Testes nas fronteiras

Erros de decisão quase sempre estão no limite (`<` ou `<=`?). Para cada limite, teste um valor **abaixo**, **igual** e **acima**:

| # | Peso | Esperado | Verifica |
|---|---:|---|---|
| 1 | 0 | `INVALIDO` | limite inferior (exclusivo) |
| 2 | 0,5 | R$ 8,00 | interior da faixa 1 |
| 3 | 1 | R$ 8,00 | limite igual (inclusivo) |
| 4 | 1,01 | R$ 15,00 | logo acima do limite |
| 5 | 5 | R$ 15,00 | limite igual |
| 6 | 5,01 | R$ 30,00 | logo acima |
| 7 | 30 | R$ 30,00 | limite superior (inclusivo) |
| 8 | 30,01 | `INVALIDO` | logo acima do máximo |

### Comparando números reais

Números `double` podem carregar pequenos erros (Material 1, seção 7). Comparar `==` com um valor calculado é arriscado. Em geral, as **faixas com `<` e `<=`** já são seguras, pois o valor cai de um lado ou de outro do limite. Se for indispensável testar igualdade de valores calculados, use uma tolerância pequena: `fabs(a - b) < 0.000001` (exige `#include <math.h>`).

## 4. `switch`

O `switch` escolhe um ramo conforme o valor de uma expressão **inteira ou `char`**. É indicado para **códigos discretos**: opções de menu, tipos, categorias. Não serve para faixas nem para `double`.

```c
/* categoria.c */
#include <stdio.h>

int main(void) {
    char codigo;

    printf("Codigo da categoria (I, J, A, V): ");
    if (scanf(" %c", &codigo) != 1) {
        printf("Entrada invalida.\n");
        return 1;
    }

    switch (codigo) {
        case 'I':
        case 'i':
            printf("Infantil\n");
            break;
        case 'J':
        case 'j':
            printf("Juvenil\n");
            break;
        case 'A':
        case 'a':
            printf("Adulto\n");
            break;
        case 'V':
        case 'v':
            printf("Veterano\n");
            break;
        default:
            printf("Codigo invalido: %c\n", codigo);
            break;
    }
    return 0;
}
```

```text
Codigo da categoria (I, J, A, V): j
Juvenil
```

Com um código fora da lista:

```text
Codigo da categoria (I, J, A, V): x
Codigo invalido: x
```

Pontos de atenção:

- **`break` encerra o ramo.** Sem ele, a execução "cai" no ramo seguinte (*fall-through*). Isso é útil de propósito, como em `case 'I': case 'i':` acima, mas é um defeito quando esquecido.
- **`default`** trata todos os valores não previstos. É o lugar natural para "código inválido".
- Os valores dos `case` são **constantes**: `case 'A':`, `case 3:`, nunca `case x:`.

Quando usar cada um:

| Situação | Melhor ferramenta |
|---|---|
| faixas de valores (`<`, `<=`) | `if` / `else if` |
| combinação de condições diferentes (`&&`, `\|\|`) | `if` |
| um código ou letra entre várias opções | `switch` |
| menu de opções numeradas | `switch` |

## 5. Um exemplo com várias condições: classificar triângulos

Este exemplo combina **validação**, condições compostas e precedência. Três lados formam um triângulo se cada lado é menor que a soma dos outros dois.

| Ordem | Condição | Resultado |
|---:|---|---|
| 1 | algum lado menor ou igual a 0 | `INVALIDO` |
| 2 | não vale a desigualdade triangular | `NAO FORMA TRIANGULO` |
| 3 | os três lados iguais | `EQUILATERO` |
| 4 | dois lados iguais (quaisquer) | `ISOSCELES` |
| 5 | demais | `ESCALENO` |

```c
/* triangulo.c */
#include <stdio.h>

int main(void) {
    int a, b, c;

    printf("Lados: ");
    if (scanf("%d %d %d", &a, &b, &c) != 3) {
        printf("Entrada invalida.\n");
        return 1;
    }

    if (a <= 0 || b <= 0 || c <= 0) {
        printf("INVALIDO\n");
    } else if (a >= b + c || b >= a + c || c >= a + b) {
        printf("NAO FORMA TRIANGULO\n");
    } else if (a == b && b == c) {
        printf("EQUILATERO\n");
    } else if (a == b || a == c || b == c) {
        printf("ISOSCELES\n");
    } else {
        printf("ESCALENO\n");
    }
    return 0;
}
```

```text
Lados: 3 4 5
ESCALENO
```

Por que a ordem importa aqui? Se o teste de `EQUILATERO` viesse antes da validação, `0 0 0` seria classificado como equilátero. E `ISOSCELES` só é correto depois de excluir o equilátero, que também tem dois lados iguais.

Casos de teste (um por ramo, mais os limites):

| Lados | Esperado | Verifica |
|---|---|---|
| `0 4 5` | `INVALIDO` | lado nulo |
| `1 2 3` | `NAO FORMA TRIANGULO` | fronteira: soma **igual** ao terceiro lado |
| `2 2 2` | `EQUILATERO` | três iguais |
| `2 2 3` | `ISOSCELES` | dois iguais |
| `3 4 5` | `ESCALENO` | todos diferentes |

Confira o caso de fronteira:

```text
Lados: 1 2 3
NAO FORMA TRIANGULO
```

## 6. Validar antes de decidir

Um padrão recorrente em programas robustos:

1. leia os dados e confira o retorno do `scanf`;
2. **rejeite** o que viola o contrato, com mensagem clara;
3. só então aplique as regras de negócio.

Assim as regras de negócio podem assumir dados válidos, e cada `else if` fica simples.

## Erros comuns

- **`=` no lugar de `==`** dentro de um `if`.
- **`0 <= x <= 100`** escrito como em matemática.
- **Vários `if` que se sobrepõem** onde deveria haver `else if`.
- **Ordem das regras errada**: casos específicos depois dos gerais.
- **`<` no lugar de `<=`** (ou vice-versa) exatamente na fronteira.
- **`break` esquecido** no `switch`.
- **Ponto e vírgula depois do `if (...)`**: `if (x > 3);` executa um bloco vazio.
- **Comparar `double` com `==`** após cálculos.

## Autoteste

1. Qual é o valor de `5 > 3 && 2 > 4 || 1`?
2. Reescreva "fora do intervalo de 0 a 100" usando `&&` e usando `||`.
3. No `frete.c`, o que acontece se você trocar a ordem dos ramos 2 e 3?
4. Por que `switch` não serve para classificar notas em faixas?
5. Monte a tabela de decisão de "ingresso: crianças até 12 anos pagam meia; maiores de 60 anos pagam meia; estudantes pagam meia; os demais pagam inteira". As condições são mutuamente exclusivas?

<details>
<summary>Respostas</summary>

1. `1`: primeiro `5 > 3 && 2 > 4` dá `0`; depois `0 || 1` dá `1`.
2. Com `||`: `x < 0 || x > 100`. Com `&&` é preciso negar o intervalo inteiro: `!(x >= 0 && x <= 100)`.
3. Todo peso até 5 kg (inclusive os de até 1 kg) receberia R$ 15,00: o ramo `peso <= 5.0` capturaria antes o ramo `peso <= 1.0`. A ordem muda o resultado.
4. O `switch` compara a igualdade com constantes; cada faixa teria de listar todos os valores possíveis, e `double` não é aceito.
5. Não são exclusivas: um estudante de 10 anos satisfaz duas condições. O resultado ("meia") é o mesmo, então basta uma condição composta com `||`; se os benefícios tivessem valores diferentes, seria preciso definir a precedência entre eles.

</details>

## Ligação com o Projeto 2

| Incremento do projeto | Onde estudar | Exemplo relacionado |
|---|---|---|
| 1. Tabela de decisão, precedência e fronteiras | seção 3 | tabela do frete e do triângulo |
| 2. `if`/`else if` com uma única classificação | seções 2 e 3 | `sobreposicao.c`, `frete.c`, `triangulo.c` |
| 3. `switch` para validar e nomear a modalidade | seção 4 | `categoria.c` |
| 4. Testes abaixo, igual e acima dos limites | seção 3 (testes nas fronteiras) | tabelas de testes do frete e do triângulo |
| Desafio (margem em três faixas) | seções 2 e 3 | `sobreposicao.c` mostra o defeito de condições independentes |

Regras da triagem → ferramenta: "documentação incompleta implica `PENDENTE`" e "frequência abaixo de 75 implica `INAPTO`" são **validações com precedência** (seções 3 e 6); as faixas de renda são **`else if` em cadeia** (seção 2); a modalidade `I`/`S` é um **código discreto** (seção 4).

Para o parecer de equidade: discuta o que as regras fazem **nos limites** (quem fica de fora por uma diferença mínima?) e se a ordem de precedência favorece ou prejudica algum grupo.

## Para ir além

- Escrever a tabela de decisão como **matriz** (condições nas linhas, regras nas colunas) e verificar se toda combinação de entradas tem um resultado.
- Extrair cada decisão para uma **função** que devolve o texto do resultado (Projeto 4).
- Experimentar o operador ternário `condição ? a : b` e discutir quando ele piora a leitura.

Próximo: [Material 3 — Repetições](03-repeticoes.md).
