# Material 0 — Pensar como quem programa

Apoia o [Projeto 0](../projetos/00-pensamento-algoritmico/README.md) (aulas 1–8 do [guia de avanço](../docs/guia-de-avanco.md#projeto-0)). Próximo: [Material 1](01-sequencia-e-expressoes.md).

Os exemplos deste material usam problemas **diferentes** dos enunciados. O objetivo é mostrar a técnica; adaptá-la ao problema do projeto é tarefa da equipe.

## Ao final você deve conseguir

- distinguir dado, informação e conhecimento e desenhar o fluxo entrada–processamento–saída;
- explicar o papel do hardware, do software e do compilador;
- escrever um algoritmo sem ambiguidade, com estado inicial e término garantido;
- refinar uma solução da linguagem natural até o Portugol e simular a execução com teste de mesa;
- reconhecer no Portugol os comandos que você escreverá em C nos próximos projetos.

## 1. Dado, informação e conhecimento

| Conceito | Exemplo | O que acrescenta |
|---|---|---|
| dado | `37` | nada além do símbolo: pode ser idade, sala ou temperatura |
| informação | "a temperatura do estudante é 37 °C" | contexto que dá sentido ao dado |
| conhecimento | "até 37,2 °C é considerado normal" | regra para interpretar a informação e decidir |

**Processar** é transformar dados em informação usando regras. Todo programa que você escreverá segue o mesmo fluxo:

```text
  ENTRADA ──────► PROCESSAMENTO ──────► SAÍDA
  (dados)          (regras, cálculos)    (informação)

  37,4            compara com 37,2       "febre: procure a enfermaria"
```

Ao desenhar o fluxo de um problema, pergunte: **quais dados entram, que regras os transformam e que informação precisa sair?**

## 2. Hardware e software

| Componente | Função | Exemplo |
|---|---|---|
| processador (CPU) | executa instruções, uma após outra, muito rápido | Intel, AMD, ARM |
| memória principal (RAM) | guarda o programa e os dados **enquanto executam**; perde tudo ao desligar | 8 GB |
| armazenamento | guarda arquivos de forma permanente | SSD, HD |
| entrada | leva dados ao computador | teclado, mouse, microfone |
| saída | apresenta resultados | tela, impressora, alto-falante |

**Software** é o conjunto de instruções que faz o hardware trabalhar: o sistema operacional (gerencia os recursos), os aplicativos e os programas que você vai escrever.

Duas ideias importantes para o que vem depois:

- Uma **variável** é um nome dado a um espaço da memória principal, onde um valor fica guardado.
- A CPU só entende **linguagem de máquina** (instruções em binário). Linguagens como C, Python ou Java são escritas para pessoas e precisam ser **traduzidas**.

## 3. Compilar ou interpretar

| | Compilador | Interpretador |
|---|---|---|
| Como traduz | o programa **inteiro**, antes de executar | **linha a linha**, durante a execução |
| Resultado | um arquivo executável | nenhum arquivo: a execução acontece na hora |
| Erros de sintaxe | aparecem na compilação, antes de qualquer execução | aparecem quando a linha com o erro é alcançada |
| Para rodar o programa | basta o executável | é preciso ter o interpretador |
| Exemplo | C com `gcc` | Python com `python3` |

Analogia: o compilador é o tradutor que entrega um livro pronto em outra língua; o interpretador é o intérprete que traduz a fala enquanto ela acontece. Existem também soluções híbridas (Java, por exemplo), mas a distinção acima basta por enquanto.

No curso usaremos C, que é compilada:

```text
programa.c ──► gcc (compilador) ──► programa (executável) ──► execução
```

O menor programa completo em C:

```c
/* ola.c */
#include <stdio.h>

int main(void) {
    printf("Ola, ATP!\n");
    return 0;
}
```

Para compilar e executar (o Projeto 1 explica cada opção):

```bash
mkdir -p build
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion ola.c -o build/ola
./build/ola
```

```text
Ola, ATP!
```

## 4. O que é um algoritmo

Um **algoritmo** é uma sequência **finita** e **não ambígua** de passos que, a partir de entradas, produz uma saída. Para conferir o seu, use a lista:

- [ ] as **entradas** estão listadas e o **estado inicial** de cada variável é conhecido;
- [ ] cada passo é **preciso**: alguém que não conhece o problema executa sem interpretar;
- [ ] a **ordem** dos passos está definida;
- [ ] o algoritmo **termina** para toda entrada válida;
- [ ] a **saída** esperada aparece no fim.

Todo algoritmo estruturado combina apenas três formas de organizar passos:

| Estrutura | Ideia | Palavra-chave |
|---|---|---|
| sequência | passos em ordem | "depois" |
| decisão | executa um caminho ou outro conforme uma condição | "se … senão" |
| repetição | repete passos enquanto uma condição valer | "enquanto", "repita" |

Exemplo cotidiano, com as três estruturas:

```text
Preparar macarrão instantâneo
 1. Coloque 500 ml de água em uma panela e leve ao fogo alto.
 2. Enquanto a água não estiver fervendo:
        aguarde 30 segundos e olhe de novo.
 3. Se o pacote tiver tempero em pó:
        abra o pacote e reserve o tempero em um prato.
 4. Coloque o macarrão na panela.
 5. Repita 6 vezes:
        mexa uma vez e aguarde 30 segundos.
 6. Desligue o fogo.
```

Passos 1, 4 e 6 são **sequência**; o passo 2 é **repetição condicional**; o 3 é **decisão**; o 5 é **repetição contada**. Compare com uma versão ruim: "ferva a água, coloque o macarrão e espere ficar bom". Quem executa literalmente não sabe quanto de água, quando o macarrão entra nem o que é "ficar bom". É esse tipo de ambiguidade que a Missão 2 pede que você encontre.

## 5. Refinamentos sucessivos e Portugol

Problemas grandes não se resolvem de uma vez. Parte-se de uma frase e detalha-se em níveis, até que cada passo seja simples o bastante para virar um comando.

**Problema:** listar os múltiplos positivos de `m` que não ultrapassam um `limite`.

**Nível 1 — o que fazer**

> Listar os múltiplos de `m` até o limite.

**Nível 2 — como fazer**

1. Ler `m` e `limite`.
2. Começar pelo primeiro múltiplo, que é o próprio `m`.
3. Enquanto o múltiplo atual não passar do limite: escrevê-lo e passar ao próximo múltiplo (somar `m`).

**Nível 3 — Portugol**

```text
algoritmo multiplos
var m, limite, atual : inteiro
inicio
    leia(m, limite)
    atual <- m
    enquanto atual <= limite faca
        escreva(atual)
        atual <- atual + m
    fimenquanto
fimalgoritmo
```

### Teste de mesa

Simule o algoritmo no papel, registrando o valor de cada variável a cada passo. Entrada: `m = 4`, `limite = 15`.

| Volta | `atual` | `atual <= limite`? | Saída |
|---:|---:|---|---|
| 1 | 4 | sim | 4 |
| 2 | 8 | sim | 8 |
| 3 | 12 | sim | 12 |
| 4 | 16 | não | — (o laço termina) |

Teste também os casos que costumam quebrar algoritmos:

| Caso | Entrada | Esperado |
|---|---|---|
| intervalo vazio | `m = 7`, `limite = 3` | nenhuma saída |
| limite exato | `m = 5`, `limite = 10` | 5 e 10 |
| **não termina** | `m = 0` | `atual` nunca cresce: laço infinito |

O último caso mostra por que a propriedade "termina" precisa ser verificada. A solução é declarar no **contrato** que `m >= 1` e, no programa, rejeitar a entrada que o viole.

### Portugol usado no curso

O Portugol tem várias variações; escolha uma e seja consistente. Esta é a tabela adotada aqui, com o comando equivalente em C que você aprenderá nos próximos projetos:

| Ideia | Portugol | C |
|---|---|---|
| atribuição | `x <- 5` | `x = 5;` |
| leitura | `leia(x)` | `scanf("%d", &x);` |
| escrita | `escreva(x)` | `printf("%d\n", x);` |
| quociente e resto inteiros | `a div b`, `a mod b` | `a / b`, `a % b` |
| decisão | `se c entao … senao … fimse` | `if (c) { … } else { … }` |
| repetição, teste antes | `enquanto c faca … fimenquanto` | `while (c) { … }` |
| repetição contada | `para i de 1 ate n faca … fimpara` | `for (int i = 1; i <= n; i++) { … }` |
| repetição, teste depois | `repita … ate c` | `do { … } while (!c);` |

Atenção: `repita … ate c` para quando `c` é **verdadeira**; `do … while (c)` continua enquanto `c` é verdadeira. Por isso a condição é negada na tradução.

### Do Portugol para C

Só para ver a correspondência (você escreverá programas assim a partir do Projeto 1), o algoritmo acima em C:

```c
/* multiplos.c */
#include <stdio.h>

int main(void) {
    int m, limite;

    printf("m e limite: ");
    if (scanf("%d %d", &m, &limite) != 2 || m < 1) {
        printf("Entrada invalida: m deve ser maior que zero.\n");
        return 1;
    }

    int atual = m;
    while (atual <= limite) {
        printf("%d\n", atual);
        atual = atual + m;
    }
    return 0;
}
```

Com `m = 4` e `limite = 15`:

```text
m e limite: 4 15
4
8
12
```

Com um intervalo vazio (`m = 7`, `limite = 3`) nada é escrito:

```text
m e limite: 7 3
```

E com `m = 0` a entrada é rejeitada, em vez de entrar em laço infinito:

```text
m e limite: 0 10
Entrada invalida: m deve ser maior que zero.
```

## Erros comuns

- **Passo vago:** "espere um pouco", "ajeite os valores". Troque por quantidades e condições verificáveis.
- **Estado inicial esquecido:** usar `atual` antes de dar a ele um valor.
- **Laço sem progresso:** a condição nunca deixa de ser verdadeira.
- **Confundir dado com informação:** `37` sozinho não diz nada; o contexto é que informa.
- **Testar só o caso feliz:** esquecer intervalo vazio, limite exato e valores fora do contrato.

## Autoteste

1. Classifique como dado, informação ou conhecimento: `"7,5"`; `"a média da turma é 7,5"`; `"média maior ou igual a 6 aprova"`.
2. Por que a memória RAM não substitui o armazenamento?
3. Que erro de programação um compilador acusa antes de o programa executar, e um interpretador só descobre ao chegar na linha?
4. Escreva em Portugol o nível 3 de "somar os números de 1 a `n`" e faça o teste de mesa para `n = 4`.
5. Sua solução termina para `n = 0`? E para `n` negativo? Como o contrato deve tratar esses casos?

<details>
<summary>Respostas</summary>

1. `"7,5"` é dado; "a média da turma é 7,5" é informação; "média maior ou igual a 6 aprova" é conhecimento (uma regra para interpretar e decidir).
2. A RAM é **volátil**: perde o conteúdo quando o computador é desligado. O armazenamento guarda os arquivos de forma permanente, embora seja mais lento; a RAM é onde o programa e seus dados ficam durante a execução.
3. Erros de **sintaxe**, como um parêntese não fechado: o compilador acusa antes de o programa executar; o interpretador só descobre ao chegar na linha com o erro.
4. Uma solução possível:

   ```text
   algoritmo soma_ate_n
   var n, i, soma : inteiro
   inicio
       leia(n)
       soma <- 0
       i <- 1
       enquanto i <= n faca
           soma <- soma + i
           i <- i + 1
       fimenquanto
       escreva(soma)
   fimalgoritmo
   ```

   Teste de mesa com `n = 4`: `i = 1` → `soma = 1`; `i = 2` → `3`; `i = 3` → `6`; `i = 4` → `10`; `i = 5` → o laço termina e escreve `10`.
5. Para `n = 0` o laço não executa e a saída é `0`, resposta coerente. Para `n` negativo o resultado também seria `0`, mas isso não faz sentido para o problema: o contrato deve exigir `n >= 0` e o programa deve rejeitar a entrada que o viole.

</details>

## Ligação com o Projeto 0

| Missão do projeto | Onde estudar |
|---|---|
| 1. Classificar exemplos e desenhar o fluxo | seções 1 e 2 |
| 2. Instruções executadas literalmente por outra equipe | seção 4 (lista de propriedades e exemplo do macarrão) |
| 3. Sequência com início, fim e paridade | seção 5 (refinamentos, Portugol, teste de mesa) |
| 4. Compilação × interpretação em até 150 palavras | seção 3 |

Critérios de aceitação do projeto → onde conferir: **estado inicial e término** (lista da seção 4), **intervalo vazio** e **três testes de mesa** (tabelas da seção 5).

## Para ir além

- Representar o mesmo algoritmo como **fluxograma**: oval para início/fim, retângulo para processamento, losango para decisão e paralelogramo para entrada/saída.
- Trocar o algoritmo da seção 5 por uma versão que use `para` e comparar as duas.
- Fazer um teste de mesa de um algoritmo de outra equipe e registrar as ambiguidades encontradas.

Próximo: [Material 1 — Sequência e expressões](01-sequencia-e-expressoes.md).
