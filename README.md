# Algoritmos e Técnicas de Programação com C

Material didático em formato PBL para a disciplina **Algoritmos e Técnicas de Programação** do curso Técnico Integrado em Informática para Internet do IFG – Câmpus Inhumas.

A trilha parte da formulação de algoritmos e chega à construção de um sistema modular em linguagem C. Cada projeto nasce de um problema, exige investigação, planejamento em Portugol, implementação, testes e reflexão. A carga planejada é de **108 horas (144 aulas de 45 minutos)**.

## Percurso de aprendizagem

| Etapa | Projeto | Material de estudo | Conhecimentos centrais | Aulas |
|---|---|---|---|---:|
| 0 | [Pensar como quem programa](projetos/00-pensamento-algoritmico/README.md) | [Material 0](materiais/00-pensamento-algoritmico.md) | informação, processamento, hardware/software, algoritmos e refinamento | 8 |
| 1 | [Cantina sem calculadora](projetos/01-sequencia-e-expressoes/README.md) | [Material 1](materiais/01-sequencia-e-expressoes.md) | C básico, tipos, variáveis, constantes, expressões, entrada e saída | 18 |
| 2 | [Triagem de bolsas](projetos/02-decisoes/README.md) | [Material 2](materiais/02-decisoes.md) | operadores relacionais/lógicos, `if`, `else` e `switch` | 18 |
| 3 | [Painel de indicadores](projetos/03-repeticoes/README.md) | [Material 3](materiais/03-repeticoes.md) | contadores, acumuladores, sentinelas, `while`, `do while` e `for` | 24 |
| 4 | [Caixa de ferramentas](projetos/04-funcoes/README.md) | [Material 4](materiais/04-funcoes.md) | decomposição, funções, parâmetros, retorno, escopo e testes | 16 |
| 5 | [Analisador de turma](projetos/05-vetores-e-strings/README.md) | [Material 5](materiais/05-vetores-e-strings.md) | vetores, busca, agregação, ordenação introdutória e strings | 22 |
| 6 | [Mapa de ocupação](projetos/06-matrizes/README.md) | [Material 6](materiais/06-matrizes.md) | matrizes, percursos, agregações e tabelas | 16 |
| 7 | [Sistema acadêmico](projetos/07-registros-integrador/README.md) | [Material 7](materiais/07-registros-integrador.md) | `struct`, vetores de registros, modularização e integração | 22 |
| | **Total** | | | **144** |

Cada material de estudo explica o assunto do projeto e traz exemplos em C compilados e executados; os exemplos usam contextos diferentes dos enunciados, para ensinar a técnica sem entregar a solução. O [guia de avanço](docs/guia-de-avanco.md) distribui as aulas, indica as leituras de cada incremento e lista os critérios para passar ao projeto seguinte.

Consulte também o [plano do curso](docs/plano-do-curso.md), a [orientação PBL](docs/guia-pbl.md), o [sistema de avaliação](docs/avaliacao.md), o [guia de entrega](docs/entrega.md) e a [folha de apoio de C](materiais/linguagem-c.md).

## Como estudar cada projeto

1. Leia o cenário sem procurar imediatamente uma solução pronta.
2. Registre em `diario.md`: **o que sabemos**, **o que precisamos saber** e **como investigar**.
3. Estude no material do projeto as seções indicadas no [guia de avanço](docs/guia-de-avanco.md) e experimente os exemplos.
4. Escreva exemplos de entrada e saída e um algoritmo em Portugol.
5. Faça uma primeira implementação em C.
6. Teste casos normais, limites e entradas inválidas previstas no contrato.
7. Revise em pares e entregue código, evidências de teste e retrospectiva no fork da equipe, conforme o [guia de entrega](docs/entrega.md).

## Ambiente

Use um compilador compatível com C17 (GCC ou Clang):

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion programa.c -o programa
./programa
```

Copie os arquivos de [modelos](modelos/) para iniciar uma atividade. Execute `make check` para compilar os modelos com avisos rigorosos.

## Origem das atividades

Os problemas são adaptações didáticas e contextualizadas das classes de exercícios de **Farrer et al., _Algoritmos Estruturados_, 3ª ed.** A referência de seção/exercício é indicada em cada projeto e consolidada na [tabela de rastreabilidade](docs/rastreabilidade.md). Os enunciados não são transcrições do livro; contexto, restrições, entregas e critérios foram reformulados para PBL e C.

O repositório [c_yt_course](https://github.com/rogerio-silva/c_yt_course) orientou a divisão temática e o uso de exemplos em C. Este material acrescenta encadeamento PBL, resultados de aprendizagem, testes e avaliação por evidências.

## Licença

Os textos didáticos (arquivos Markdown) estão sob [CC BY-NC-SA 4.0](LICENSE-CC-BY-NC-SA-4.0). O código-fonte (`.c`, `.h` e `Makefile`) está sob a [licença MIT](LICENSE-MIT). O arquivo [LICENSE](LICENSE) resume a divisão e a forma de atribuição.
