# Material 1 — Sequência e expressões

Apoia o [Projeto 1](../projetos/01-sequencia-e-expressoes/README.md) (aulas 9–26 do [guia de avanço](../docs/guia-de-avanco.md#projeto-1)). Anterior: [Material 0](00-pensamento-algoritmico.md). Próximo: [Material 2](02-decisoes.md). Consulte também a [folha de apoio de C](linguagem-c.md).

Os exemplos usam contextos **diferentes** do enunciado (camisetas, bicicletas, temperatura). Você deve adaptar as técnicas ao problema da cantina.

## Ao final você deve conseguir

- escrever, compilar e executar um programa C com entrada, processamento e saída;
- escolher tipos, nomear variáveis e declarar constantes com critério;
- avaliar expressões respeitando precedência, divisão inteira e conversões;
- formatar valores com `printf` e ler dados com `scanf`, verificando o resultado da leitura;
- ler mensagens do compilador e explicar o que compilador e ligador fazem.

## 1. Estrutura de um programa

```c
/* estrutura.c */
#include <stdio.h>   /* biblioteca de entrada e saída: printf, scanf */

int main(void) {     /* todo programa começa em main */
    int idade = 16;  /* declaração com valor inicial */

    printf("Idade: %d\n", idade);
    return 0;        /* 0 = terminou sem erro */
}
```

```text
Idade: 16
```

- Cada **instrução** termina com `;`.
- Blocos ficam entre `{` e `}`.
- Comentários `/* ... */` são ignorados pelo compilador; use-os para explicar o **porquê**, não o óbvio.
- Prefira nomes e textos **sem acentos** em identificadores e em mensagens do `printf`: alguns terminais exibem acentos incorretamente.

## 2. Variáveis e tipos

Uma variável tem **tipo** (que valores guarda e quanto espaço ocupa), **nome** e **valor**. Escolha o tipo pela natureza do dado:

| Dado | Tipo | Exemplos | Observação |
|---|---|---|---|
| contagem, quantidade | `int` | `3`, `-12`, `0` | cerca de ±2 bilhões |
| inteiro muito grande | `long long` | `9000000000` | cerca de ±9 quintilhões |
| valor com parte fracionária | `double` | `12.50`, `-0.75` | usa ponto, não vírgula; cerca de 15 dígitos significativos |
| uma letra ou símbolo | `char` | `'A'`, `'7'` | aspas simples |
| texto | `char nome[N]` | `"Ana"` | vetor de caracteres (Projeto 5) |

Os tamanhos abaixo são os de um computador comum; a linguagem só garante limites mínimos.

```c
/* tipos.c */
#include <limits.h>
#include <stdio.h>

int main(void) {
    printf("char      : %zu byte\n", sizeof(char));
    printf("int       : %zu bytes, de %d a %d\n", sizeof(int), INT_MIN, INT_MAX);
    printf("long long : %zu bytes, de %lld a %lld\n", sizeof(long long), LLONG_MIN, LLONG_MAX);
    printf("double    : %zu bytes\n", sizeof(double));
    return 0;
}
```

```text
char      : 1 byte
int       : 4 bytes, de -2147483648 a 2147483647
long long : 8 bytes, de -9223372036854775808 a 9223372036854775807
double    : 8 bytes
```

`sizeof` informa o tamanho, em bytes, de um tipo; seu formato no `printf` é `%zu`.

**Inicialize sempre.** Uma variável declarada e não inicializada contém lixo da memória. Se o valor vier de `scanf`, garanta que a leitura deu certo antes de usá-lo.

**Nomes (identificadores):** letras, dígitos e `_`; não começam com dígito; não têm acentos nem espaços; maiúsculas e minúsculas diferem (`total` ≠ `Total`); não podem ser palavras reservadas (`int`, `while`...). Use nomes que dizem o que a variável guarda: `preco_unitario`, não `x`.

### Tabela de tipos (entrega do projeto)

Antes de codificar, liste cada dado e justifique o tipo. Exemplo para um aluguel de bicicletas:

| Dado | Papel | Tipo | Justificativa |
|---|---|---|---|
| `horas` | entrada | `int` | contagem inteira, sem fração |
| `valor_hora` | entrada | `double` | valor em reais com centavos |
| `desconto_percentual` | entrada | `double` | pode ser 7,5 % |
| `TAXA_FIXA` | constante | `double` | valor que não muda durante a execução |
| `total` | saída | `double` | resultado monetário |

## 3. Constantes

Um número solto no meio do código ("número mágico") esconde seu significado e obriga a alterar vários pontos quando ele muda. Dê nome a ele:

```c
const double TAXA_FIXA = 5.00;   /* variável que não pode ser alterada */
#define MAX_ITENS 3              /* substituição de texto; sem ponto e vírgula */
```

- `const` cria um valor com tipo, verificado pelo compilador. É a primeira escolha para valores como taxas e preços.
- `#define` é substituído antes da compilação. Será necessário para **tamanhos de vetores** (Projetos 5 a 7).
- Por convenção, constantes usam `MAIUSCULAS`.

## 4. Operadores e expressões

| Operador | Operação | Exemplo | Resultado |
|---|---|---|---|
| `+` `-` `*` | soma, subtração, produto | `3 + 4 * 2` | `11` |
| `/` | divisão | `10 / 4` (inteiros) | `2` |
| `/` | divisão | `10.0 / 4` | `2.5` |
| `%` | resto (só inteiros) | `10 % 4` | `2` |

**Precedência** (da maior para a menor): parênteses `( )` → operadores unários (`-x`, conversão `(double)`) → `*` `/` `%` → `+` `-` → atribuição `=`. Operadores de mesma precedência associam da esquerda para a direita. Na dúvida, use parênteses.

**A regra que mais causa erros:** se os **dois** operandos de `/` são inteiros, o resultado é inteiro, e a parte fracionária é descartada. Para obter o resultado real, faça pelo menos um operando ser `double`:

```c
/* divisao.c */
#include <stdio.h>

int main(void) {
    int a = 10;
    int b = 4;
    int nota1 = 7;
    int nota2 = 8;

    double media_errada = (nota1 + nota2) / 2;    /* divide inteiros, depois converte */
    double media_certa = (nota1 + nota2) / 2.0;   /* 2.0 força divisão real */

    printf("10 / 4        = %d\n", a / b);
    printf("10 %% 4        = %d\n", a % b);
    printf("10.0 / 4      = %.2f\n", 10.0 / b);
    printf("(double)a / b = %.2f\n", (double)a / b);
    printf("(double)(a/b) = %.2f\n", (double)(a / b));
    printf("media errada  = %.2f\n", media_errada);
    printf("media certa   = %.2f\n", media_certa);
    return 0;
}
```

```text
10 / 4        = 2
10 % 4        = 2
10.0 / 4      = 2.50
(double)a / b = 2.50
(double)(a/b) = 2.00
media errada  = 7.00
media certa   = 7.50
```

Repare na diferença entre `(double)a / b` (converte `a` antes de dividir) e `(double)(a / b)` (divide como inteiros e só então converte: tarde demais).

O operador `%` e a divisão inteira formam um par: para `n` e `d` positivos, `n == (n / d) * d + (n % d)`. Essa relação resolve problemas de "quantos grupos completos e quantas sobras":

```c
/* caixas.c */
#include <stdio.h>

int main(void) {
    const int POR_CAIXA = 12;
    int camisetas;

    printf("Camisetas produzidas: ");
    if (scanf("%d", &camisetas) != 1 || camisetas < 0) {
        printf("Entrada invalida.\n");
        return 1;
    }

    int caixas_cheias = camisetas / POR_CAIXA;
    int sobras = camisetas % POR_CAIXA;

    printf("%d camisetas: %d caixas cheias e %d sobras\n", camisetas, caixas_cheias, sobras);
    return 0;
}
```

```text
Camisetas produzidas: 47
47 camisetas: 3 caixas cheias e 11 sobras
```

Para converter uma medida em **duas ou mais unidades** (dias em semanas e dias; centavos em reais e centavos), aplique o mesmo raciocínio: o quociente é a unidade maior, o resto é o que sobrou. Quando há três unidades, o resto de uma etapa vira a entrada da etapa seguinte.

### Conversão de tipos

- **Implícita:** em `3 * 2.5`, o `3` vira `3.0` automaticamente.
- **Explícita (cast):** `(double)a` converte `a` no ponto em que aparece.
- Guardar um `double` em um `int` descarta a fração; `-Wconversion` avisa quando isso pode acontecer sem você perceber.

Outro exemplo clássico: converter Celsius em Fahrenheit. A fração `9/5`, escrita com inteiros, vale `1`:

```c
/* temperatura.c */
#include <stdio.h>

int main(void) {
    double celsius;

    printf("Temperatura em Celsius: ");
    if (scanf("%lf", &celsius) != 1) {
        printf("Entrada invalida.\n");
        return 1;
    }

    double errado = celsius * (9 / 5) + 32;
    double certo = celsius * 9.0 / 5.0 + 32.0;

    printf("Com 9 / 5 inteiro: %.1f F\n", errado);
    printf("Com 9.0 / 5.0    : %.1f F\n", certo);
    return 0;
}
```

```text
Temperatura em Celsius: 100
Com 9 / 5 inteiro: 132.0 F
Com 9.0 / 5.0    : 212.0 F
```

## 5. Atribuição e sequência

`=` **atribui**: calcula o lado direito e guarda o resultado na variável do lado esquerdo. Não é uma igualdade matemática: `contador = contador + 1` é válido e significa "some 1 ao valor atual". Formas abreviadas: `x += 5`, `x -= 5`, `x *= 2`, `x++`.

Em uma sequência, **a ordem importa**. Para trocar os valores de duas variáveis é preciso uma terceira, pois `a = b; b = a;` perderia o valor original de `a`:

```c
/* troca.c */
#include <stdio.h>

int main(void) {
    int a = 3;
    int b = 8;
    int auxiliar;

    printf("Antes : a = %d, b = %d\n", a, b);
    auxiliar = a;
    a = b;
    b = auxiliar;
    printf("Depois: a = %d, b = %d\n", a, b);
    return 0;
}
```

```text
Antes : a = 3, b = 8
Depois: a = 8, b = 3
```

Use o **teste de mesa** (Material 0) para acompanhar o valor de cada variável linha a linha.

## 6. Entrada e saída

### `printf`

| Formato | Para | Exemplo | Saída |
|---|---|---|---|
| `%d` | `int` | `printf("%d", 42)` | `42` |
| `%lld` | `long long` | `printf("%lld", 9000000000LL)` | `9000000000` |
| `%f` | `double` | `printf("%f", 2.5)` | `2.500000` |
| `%.2f` | `double` com 2 casas | `printf("%.2f", 2.5)` | `2.50` |
| `%8.2f` | `double`, largura 8 | `printf("%8.2f", 2.5)` | `    2.50` |
| `%c` | `char` | `printf("%c", 'A')` | `A` |
| `%s` | texto | `printf("%s", "oi")` | `oi` |
| `%-12s` | texto alinhado à esquerda, largura 12 | `printf("%-12s|", "Total")` | `Total       |` |
| `%%` | o caractere `%` | `printf("10%%")` | `10%` |

Sequências de escape: `\n` (nova linha), `\t` (tabulação), `\"` (aspas), `\\` (barra invertida).

**Cada `%` precisa de um argumento do tipo certo**, na ordem. Passar um `int` para `%f` é erro; o compilador avisa (seção 8).

### `scanf`

```c
int horas;
double valor;
if (scanf("%d %lf", &horas, &valor) != 2) {
    /* entrada inválida: trate o erro */
}
```

- O `&` entrega ao `scanf` o **endereço** da variável, para que ele possa gravar nela. Esquecê-lo é um erro grave.
- Para `double`, o `scanf` usa `%lf` (o `printf` usa `%f`).
- O `scanf` **devolve quantos valores conseguiu ler**. Compare com o esperado antes de usar as variáveis.
- Espaços e quebras de linha entre números são ignorados. Para ler um `char`, escreva um espaço antes: `scanf(" %c", &letra)`.
- Textos com espaços: use `fgets` (Projeto 5).

### Exemplo completo: recibo de aluguel

```c
/* aluguel.c */
#include <stdio.h>

int main(void) {
    const double TAXA_FIXA = 5.00;
    int horas;
    double valor_hora;
    double desconto_percentual;

    printf("Horas, valor por hora e desconto (%%): ");
    if (scanf("%d %lf %lf", &horas, &valor_hora, &desconto_percentual) != 3) {
        printf("Entrada invalida.\n");
        return 1;
    }

    double subtotal = horas * valor_hora;
    double desconto = subtotal * desconto_percentual / 100.0;
    double total = subtotal - desconto + TAXA_FIXA;

    printf("\n--- Recibo ---\n");
    printf("%-12s R$ %8.2f\n", "Subtotal:", subtotal);
    printf("%-12s R$ %8.2f\n", "Desconto:", desconto);
    printf("%-12s R$ %8.2f\n", "Taxa fixa:", TAXA_FIXA);
    printf("%-12s R$ %8.2f\n", "Total:", total);
    return 0;
}
```

```text
Horas, valor por hora e desconto (%): 3 12.50 10

--- Recibo ---
Subtotal:    R$    37.50
Desconto:    R$     3.75
Taxa fixa:   R$     5.00
Total:       R$    38.75
```

Note o que o programa **assume**: entradas dentro do contrato (horas e valor não negativos, desconto entre 0 e 100). Nesta etapa isso é aceitável; a validação de verdade vem com decisões e repetições.

### Tabela de testes

Para cada teste, calcule o resultado **à mão antes de executar**:

| # | Entrada (`horas valor desconto`) | Subtotal | Desconto | Total |
|---|---|---:|---:|---:|
| 1 | `0 10.00 0` | 0,00 | 0,00 | 5,00 |
| 2 | `1 10.00 0` | 10,00 | 0,00 | 15,00 |
| 3 | `3 12.50 10` | 37,50 | 3,75 | 38,75 |
| 4 | `2 20.00 100` | 40,00 | 40,00 | 5,00 |
| 5 | `4 7.50 50` | 30,00 | 15,00 | 20,00 |
| 6 | `5 0.00 25` | 0,00 | 0,00 | 5,00 |

## 7. Dinheiro e números reais

Um `double` guarda os números em binário, e muitos valores decimais simples não têm representação exata:

```c
/* precisao.c */
#include <stdio.h>

int main(void) {
    double soma = 0.1 + 0.2;

    printf("0.1 + 0.2 com 2 casas : %.2f\n", soma);
    printf("0.1 + 0.2 com 20 casas: %.20f\n", soma);
    printf("soma == 0.3 ? %d\n", soma == 0.3);
    return 0;
}
```

```text
0.1 + 0.2 com 2 casas : 0.30
0.1 + 0.2 com 20 casas: 0.30000000000000004441
soma == 0.3 ? 0
```

Consequências práticas:

- apresente valores monetários com `%.2f`, que arredonda **na exibição**;
- não compare `double` com `==` (Material 2 mostra alternativas);
- uma alternativa profissional é guardar dinheiro em **centavos**, como `int` ou `long long`, e converter só na apresentação (`centavos / 100` e `centavos % 100`). Vale como extensão do projeto.

## 8. Compilar e ler mensagens do compilador

```text
cantina.c ─► pré-processador ─► compilador ─► montador ─► ligador ─► executável
             (#include,          (C para       (gera      (junta    (arquivo que
              #define)            assembly)     .o)        os .o e   você executa)
                                                            as bibliotecas)
```

O `gcc` executa todas as etapas em um comando:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion cantina.c -o build/cantina
```

| Opção | Significado |
|---|---|
| `-std=c17` | usa o padrão C17 da linguagem |
| `-Wall -Wextra -Wpedantic` | ativa avisos sobre erros prováveis e construções não padronizadas |
| `-Wconversion` | avisa sobre conversões que podem perder informação |
| `-o build/cantina` | nome do executável gerado |

Um **aviso** (*warning*) não impede a geração do executável, mas quase sempre indica um defeito. No curso, **entregue sem avisos**. Um **erro** (*error*) impede a compilação.

Exemplo de aviso: passar um `int` para `%f`.

```c
printf("Total: %f\n", total);   /* total é int */
```

```text
aviso.c: In function ‘main’:
aviso.c:5:21: warning: format ‘%f’ expects argument of type ‘double’, but argument 2 has type ‘int’ [-Wformat=]
    5 |     printf("Total: %f\n", total);
      |                    ~^     ~~~~~
      |                     |     |
      |                     |     int
      |                     double
      |                    %d
```

Como ler: `aviso.c:5:21` é **arquivo:linha:coluna**; depois vêm a gravidade (`warning`), a descrição e a opção que gerou o aviso. O compilador até sugere a correção (`%d`).

Exemplo de erro: faltou `;` na linha 4.

```text
erro.c: In function ‘main’:
erro.c:5:5: error: expected ‘,’ or ‘;’ before ‘printf’
    5 |     printf("Total: %d\n", total);
      |     ^~~~~~
```

O compilador aponta a linha **seguinte** ao `;` que faltou, porque só percebe o problema ao encontrar o `printf`. Regra prática: quando o erro parece estranho, olhe a linha anterior. Corrija sempre o **primeiro** erro da lista; os demais costumam ser consequência dele.

O **ligador** (etapa final) também gera erros, por exemplo quando falta a função `main`:

```text
(.text+0x1b): referência não definida para "main"
collect2: error: ld returned 1 exit status
```

(Em um sistema em inglês: `undefined reference to 'main'`.) Esse tipo de erro não é de sintaxe: é falta de uma peça na hora de juntar o programa.

## Erros comuns

- **Divisão de inteiros** onde se esperava resultado real (`9 / 5`, `(a + b) / 2`).
- **Esquecer o `&`** no `scanf`, ou usar `%f` em vez de `%lf` para `double`.
- **Não verificar** o retorno do `scanf` e usar uma variável não lida.
- **Variável sem valor inicial** usada em um cálculo.
- **Formato incompatível** com o tipo do argumento do `printf`.
- **Número mágico** repetido pelo programa em vez de uma constante.
- **Ponto e vírgula** esquecido, ou colocado onde não deve.

## Autoteste

1. Quanto valem `7 / 2`, `7 % 2`, `7.0 / 2`, `-7 / 2` e `-7 % 2`?
2. Por que `double media = (a + b) / 2;` com `a = 7` e `b = 8` (ambos `int`) resulta em `7.00`?
3. Que tipo você escolheria para: idade, preço de um produto, número de matrícula com 12 dígitos, primeira letra do nome?
4. O que acontece se você trocar `%lf` por `%f` em um `scanf` que lê `double`?
5. Converta 200 minutos em horas e minutos usando apenas `/` e `%`.

<details>
<summary>Respostas</summary>

1. `3`, `1`, `3.5`, `-3` (a divisão inteira descarta a fração, aproximando de zero) e `-1` (o resto tem o sinal do dividendo).
2. `a + b` vale `15` e `15 / 2` é divisão de inteiros: `7`. A conversão para `double` acontece depois, na atribuição.
3. `int`; `double`; `long long` (12 dígitos excedem o `int`); `char`.
4. O `scanf` passa a tratar a variável como `float` (4 bytes) e grava só parte dos 8 bytes do `double`: o valor fica errado. O compilador avisa (`-Wformat`).
5. `200 / 60` dá `3` horas e `200 % 60` dá `20` minutos.

</details>

## Ligação com o Projeto 1

| Incremento do projeto | Onde estudar | Exemplo relacionado |
|---|---|---|
| 1. Conversor de duração | seção 4 (divisão inteira, `%`, encadeamento de etapas) | `caixas.c` |
| 2. Pedido com desconto | seções 2, 3 e 6 (tipos, constantes, `scanf`) | `aluguel.c` |
| 3. Fechamento e troco | seções 6 e 7 (formatação com `%.2f`, precisão) | `aluguel.c`, `precisao.c` |
| 4. Transferência (papelaria) | seções 2 e 3: refaça a tabela de tipos e troque as constantes | tabela de tipos da seção 2 |

| Questão de investigação | Onde |
|---|---|
| Quais dados são inteiros ou reais? | seção 2 |
| Quando uma constante é apropriada? | seção 3 |
| Qual a precedência dos operadores? | seção 4 |
| Por que `10 / 4` difere de `10.0 / 4`? | seção 4, `divisao.c` |
| O que fazem compilador, ligador e executável? | seção 8 |

**Ao adaptar um exemplo** (incremento 4): não copie o arquivo. Reescreva partindo do seu algoritmo em Portugol, consulte o exemplo apenas para a sintaxe, e confirme que os seis testes passam.

## Para ir além

- Guardar todos os valores em **centavos** (`long long`) e comparar os resultados com a versão em `double`.
- Ler sobre `float` e por que o curso usa `double`.
- Explorar `gcc -E`, `gcc -S` e `gcc -c` para ver as etapas da compilação separadamente.

Próximo: [Material 2 — Decisões](02-decisoes.md).
