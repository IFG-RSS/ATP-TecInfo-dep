# Guia de avanço na disciplina

Este guia mostra **como percorrer as 144 aulas**: o que estudar em cada etapa, o que entregar e como saber que você já pode passar para o próximo projeto. Ele conecta três peças do repositório:

- os **enunciados** em [`projetos/`](../projetos/00-pensamento-algoritmico/README.md);
- os **materiais de estudo** em [`materiais/`](../materiais/00-pensamento-algoritmico.md), com explicações e exemplos em C;
- a **avaliação** e a **entrega** ([avaliação](avaliacao.md), [guia de entrega](entrega.md)).

A distribuição das aulas por incremento é uma **sugestão**. Os totais por projeto seguem o [plano do curso](plano-do-curso.md) (144 aulas de 45 minutos); o professor pode ajustar o ritmo conforme a turma.

## Como usar

**Em cada incremento:**

1. Leia o cenário e o incremento no enunciado. No `diario.md`, registre **o que sabemos**, **o que precisamos saber** e **como investigar**.
2. Estude as seções do material indicadas na coluna *Leitura* das tabelas abaixo. Os exemplos usam contextos **diferentes** dos enunciados: eles ensinam a técnica; a adaptação é da equipe.
3. Escreva o **contrato** e os **casos de teste** antes do código.
4. Escreva o algoritmo em Portugol e faça o teste de mesa.
5. Implemente em C e compile **sem avisos**: `-std=c17 -Wall -Wextra -Wpedantic -Wconversion`.
6. Execute os testes e registre resultado esperado e obtido.
7. Faça um commit ao fim do incremento e preencha a retrospectiva.

**Ao fim de cada projeto**, confira a lista **Posso avançar?**. Se algum item não estiver satisfeito, resolva antes de seguir: os projetos se apoiam uns nos outros (veja o [mapa de dependências](#mapa-de-dependências)).

**Ritmo de um bloco de 4 aulas** (do plano do curso): uma aula de lançamento e investigação; uma de oficina e planejamento; uma de implementação; uma de testes e revisão. Projetos maiores repetem esse ciclo por incremento.

## Visão geral

| Etapa | Projeto | Aulas | Acumulado | Material | Marco |
|---|---|---:|---|---|---|
| 0 | [Pensar como quem programa](../projetos/00-pensamento-algoritmico/README.md) | 8 | 1–8 | [Material 0](../materiais/00-pensamento-algoritmico.md) | M0: algoritmo desplugado e teste de mesa |
| 1 | [Cantina sem calculadora](../projetos/01-sequencia-e-expressoes/README.md) | 18 | 9–26 | [Material 1](../materiais/01-sequencia-e-expressoes.md) | M1: calculadora da cantina |
| 2 | [Triagem de bolsas](../projetos/02-decisoes/README.md) | 18 | 27–44 | [Material 2](../materiais/02-decisoes.md) | M2: motor de triagem com tabela de decisão |
| 3 | [Painel de indicadores](../projetos/03-repeticoes/README.md) | 24 | 45–68 | [Material 3](../materiais/03-repeticoes.md) | M3: painel com totais, médias, extremos e percentuais |
| 4 | [Caixa de ferramentas](../projetos/04-funcoes/README.md) | 16 | 69–84 | [Material 4](../materiais/04-funcoes.md) | M4: biblioteca de funções testada |
| 5 | [Analisador de turma](../projetos/05-vetores-e-strings/README.md) | 22 | 85–106 | [Material 5](../materiais/05-vetores-e-strings.md) | M5: analisador de turma com vetores |
| 6 | [Mapa de ocupação](../projetos/06-matrizes/README.md) | 16 | 107–122 | [Material 6](../materiais/06-matrizes.md) | M6: mapa de ocupação com matrizes |
| 7 | [Sistema acadêmico](../projetos/07-registros-integrador/README.md) | 22 | 123–144 | [Material 7](../materiais/07-registros-integrador.md) | M7: sistema acadêmico modular com registros |
| | **Total** | **144** | | | |

Em todos os projetos, a [folha de apoio de C](../materiais/linguagem-c.md) resume a sintaxe e o checklist de compilação.

<a id="projeto-0"></a>

## Projeto 0 — Pensar como quem programa (aulas 1–8)

Material: [Material 0](../materiais/00-pensamento-algoritmico.md).

| Aulas | Missão | Leitura | Evidência |
|---|---|---|---|
| 1–2 | 1. Classificar exemplos; fluxo entrada–processamento–saída | §1 e §2 | fluxo desenhado no diário |
| 3–4 | 2. Instruções executadas literalmente por outra equipe | §4 | lista de ambiguidades encontradas |
| 5–7 | 3. Sequência com início, fim e paridade: linguagem natural, refinamentos, Portugol | §5 (e §4) | Portugol e três testes de mesa |
| 8 | 4. Compilação × interpretação; fechamento | §3 | texto de até 150 palavras e reflexão |

**Posso avançar se…**

- [ ] meu algoritmo tem estado inicial, termina e não usa comandos vagos;
- [ ] trata o intervalo vazio e tem três testes de mesa;
- [ ] consigo explicar o fluxo entrada–processamento–saída de um programa;
- [ ] sei dizer a diferença entre compilar e interpretar;
- [ ] leio um trecho em Portugol e prevejo o resultado.

**Sinais de alerta:** se o algoritmo só funciona no caso feliz, refaça os testes de mesa com intervalo vazio e limite exato. Se outra equipe não consegue executar suas instruções à risca, releia a lista de propriedades do §4.

<a id="projeto-1"></a>

## Projeto 1 — Cantina sem calculadora (aulas 9–26)

Material: [Material 1](../materiais/01-sequencia-e-expressoes.md).

| Aulas | Incremento | Leitura | Evidência |
|---|---|---|---|
| 9–13 | 1. Conversor de duração | §1, §2, §4, §6 | primeiro programa que compila e roda |
| 14–18 | 2. Pedido com desconto | §2, §3, §6 | tabela de tipos e cálculo do total |
| 19–22 | 3. Fechamento e troco | §6, §7 | valores com duas casas decimais |
| 23–26 | 4. Transferência (papelaria) e entrega | §2, §3 | `cantina.c`, seis testes, explicação de uma expressão |

**Posso avançar se…**

- [ ] `cantina.c` compila **sem avisos** com as opções do curso;
- [ ] tenho a tabela de tipos e ao menos seis testes com resultados calculados à mão;
- [ ] explico por que `10 / 4` difere de `10.0 / 4` e uso `/` e `%` corretamente;
- [ ] verifico o retorno do `scanf` e sei ler uma mensagem do compilador (arquivo:linha:coluna);
- [ ] adaptei a solução para outro contexto **sem copiar** o código.

**Sinais de alerta:** totais com valores estranhos costumam indicar divisão de inteiros (§4). Avisos do compilador não são "detalhe": cada um aponta um defeito provável (§8).

<a id="projeto-2"></a>

## Projeto 2 — Triagem de bolsas (aulas 27–44)

Material: [Material 2](../materiais/02-decisoes.md).

| Aulas | Incremento | Leitura | Evidência |
|---|---|---|---|
| 27–30 | 1. Tabela de decisão | §3 | tabela com precedência e fronteiras |
| 31–35 | 2. `if`/`else if` com uma única classificação | §1, §2, §3, §6 | `triagem.c` classificando os casos centrais |
| 36–38 | 3. `switch` para a modalidade | §4 | validação e nome da modalidade |
| 39–41 | 4. Matriz de testes | §3 (testes nas fronteiras) | testes abaixo, igual e acima de cada limite |
| 42–44 | Desafio da margem e parecer de equidade; fechamento | §2, §5 | comparação com a triagem e parecer escrito |

**Posso avançar se…**

- [ ] toda entrada válida recebe **exatamente uma** classificação e as inválidas são rejeitadas antes;
- [ ] a tabela de decisão mostra a precedência e o código a segue;
- [ ] testei abaixo, igual e acima de cada limite;
- [ ] explico quando `if`s independentes estão errados e quando o `switch` é adequado;
- [ ] entreguei o parecer de equidade.

**Sinais de alerta:** duas mensagens para uma mesma entrada indicam sobreposição de condições (§2). Se um teste muda ao trocar `<` por `<=`, revise as fronteiras (§3).

<a id="projeto-3"></a>

## Projeto 3 — Painel de indicadores (aulas 45–68)

Material: [Material 3](../materiais/03-repeticoes.md).

| Aulas | Incremento | Leitura | Evidência |
|---|---|---|---|
| 45–49 | 1. Quantidade conhecida (`for`, `n = 0`) | §1 a §4 | programa 1 e teste de mesa |
| 50–54 | 2. Sentinela e faixas | §5 (e Material 2) | programa 2 |
| 55–57 | 3. Validação com `do while` | §6 | programa 3 |
| 58–62 | 4. Frequência por turma | §5, §7 | programa 4 com laços aninhados |
| 63–65 | 5. Simulação | §8 | programa 5 |
| 66–68 | Painel final, desafio de alturas, testes de mesa | §5, §9 | painel e desafio individual |

**Posso avançar se…**

- [ ] para cada laço, aponto inicialização, condição de parada e progresso;
- [ ] tratei conjunto vazio, um elemento, empate nos extremos e limites das faixas;
- [ ] os extremos começam pelo primeiro valor lido e não há divisão por zero;
- [ ] fiz o teste de mesa de ao menos um laço;
- [ ] escolho `for`, `while` ou `do while` justificando pelo contrato.

**Sinais de alerta:** programa que não termina (falta de progresso, §1); resultado errado com valores negativos (extremo iniciado em `0`, §4); leitura que repete para sempre com entrada inválida (§6).

<a id="projeto-4"></a>

## Projeto 4 — Caixa de ferramentas (aulas 69–84)

Material: [Material 4](../materiais/04-funcoes.md).

| Aulas | Incremento | Leitura | Evidência |
|---|---|---|---|
| 69–71 | 1. Contratos | §2 | contrato de cada função da API mínima |
| 72–76 | 2. `ferramentas.h` e `ferramentas.c` | §1, §3, §5 | funções compilando em módulo separado |
| 77–80 | 3. Testes com `assert` | §6 | `testes.c` passando, com fronteiras |
| 81–84 | 4. Refatorar um projeto anterior e diagramar chamadas | §3, §4 | programa refatorado e diagrama |

**Posso avançar se…**

- [ ] as cinco funções têm contrato no `.h`, inclusive o comportamento para argumentos inválidos;
- [ ] os testes rodam **sem entrada interativa** e passam;
- [ ] `main` só coordena e nenhuma função usa variável global;
- [ ] refatorei um projeto anterior com ao menos três funções e o resultado é o mesmo;
- [ ] compilo vários `.c` juntos sem avisos.

**Sinais de alerta:** função que calcula e imprime ao mesmo tempo é difícil de testar (§2); teste que precisa de teclado não é teste automático (§6).

<a id="projeto-5"></a>

## Projeto 5 — Analisador de turma (aulas 85–106)

Material: [Material 5](../materiais/05-vetores-e-strings.md).

| Aulas | Incremento | Leitura | Evidência |
|---|---|---|---|
| 85–88 | 1. Notas: lista, média, extremos e faixas | §1, §2 | analisador básico |
| 89–91 | 2. Busca por matrícula | §4 | busca com `-1` para ausente |
| 92–94 | 3. Remover duplicados em uma cópia | §4, §7 | cópia sem repetições e original intacto |
| 95–98 | 4. Ordenar mantendo a correspondência | §5 | ordenação de pares com teste de associação |
| 99–101 | 5. Intercalar duas listas ordenadas | §6 | teste de mesa e função |
| 102–104 | 6. Strings com `fgets` | §8 | contagens sobre uma frase |
| 105–106 | Biblioteca de vetores, testes e explicação visual | §3 | testes de função e esquema índice × valor |

**Posso avançar se…**

- [ ] nenhum acesso sai de `0..n-1` (conferi com sanitizers) e `n = 0` e `n = 1` estão definidos;
- [ ] busca ausente retorna `-1` e nunca uso `-1` como índice;
- [ ] a ordenação preserva a associação matrícula–nota e um teste confere isso;
- [ ] os textos são lidos com `fgets` e não ultrapassam o buffer;
- [ ] explico a diferença entre índice e valor.

**Sinais de alerta:** dados "trocados de dono" após a ordenação (§5); lixo na saída ou travamentos (acesso fora do vetor, §1).

<a id="projeto-6"></a>

## Projeto 6 — Mapa de ocupação (aulas 107–122)

Material: [Material 6](../materiais/06-matrizes.md).

| Aulas | Incremento | Leitura | Evidência |
|---|---|---|---|
| 107–109 | 1. Ler e imprimir `m x n` | §1, §2, §3 | matriz impressa com cabeçalhos |
| 110–113 | 2. Totais e posição da maior ocupação | §2, §4 | totais por linha, por coluna e geral |
| 114–116 | 3. Transposta | §5 | transposta com dimensões trocadas |
| 117–118 | 4. Coluna de totais por linha | §2, §4 | tabela com coluna extra |
| 119–121 | 5. Tabela de frequências | §6 | frequências de 5 opções |
| 122 | Fechamento e demonstração de um percurso | §2 | percurso demonstrado |

**Posso avançar se…**

- [ ] os laços usam as dimensões **lógicas** e respeitam os máximos;
- [ ] todos os totais concordam (somas cruzadas);
- [ ] matriz retangular e `1 x 1` funcionam, e transpor duas vezes recupera a original;
- [ ] sei dizer qual índice o laço interno varia em cada percurso.

**Sinais de alerta:** totais que acumulam linhas anteriores (acumulador fora do laço externo, §2); lixo na impressão (laço até o máximo em vez da dimensão lógica, §1).

<a id="projeto-7"></a>

## Projeto 7 — Sistema acadêmico (aulas 123–144)

Material: [Material 7](../materiais/07-registros-integrador.md).

| Aulas | Incremento | Leitura | Evidência |
|---|---|---|---|
| 123–127 | I1 — modelo: registro, cadastro e listagem | §1, §2, §3 | `estudante.h`, `turma.h` e cadastro funcionando |
| 128–132 | I2 — regras: média, frequência e situação | §4 (regras), §5 | testes de unidade das fronteiras |
| 133–136 | I3 — consultas: busca, atualização, relatório | §4 | relatório agregado |
| 137–144 | I4 — qualidade: testes, roteiro do menu, revisão, manual e demonstração | §5, §6 | sistema completo, manual e apresentação de 8 minutos |

**Posso concluir a disciplina se…**

- [ ] compila sem avisos e os testes de unidade passam;
- [ ] impede mais de 100 cadastros e matrículas duplicadas, e não acessa posições inválidas;
- [ ] define a situação para todos os limites de nota e frequência;
- [ ] separa interface, regras e operações da coleção;
- [ ] o roteiro de teste do menu foi executado e conferido;
- [ ] todos os integrantes demonstram qualquer parte sorteada.

**Sinais de alerta:** funções de regras com `printf`/`scanf` (§3); cada integrante implementando uma função diferente da que o outro espera (falta de contrato, §6).

## Mapa de dependências

| Projeto | Reutiliza | Prepara |
|---|---|---|
| 0 | — | Portugol e teste de mesa, usados em todos os projetos |
| 1 | Portugol e teste de mesa | tipos, expressões e entrada/saída: base de todos os programas |
| 2 | expressões e entrada/saída | decisões dentro de laços (3), contratos de funções (4), situação de um registro (7) |
| 3 | decisões | percursos de vetores (5) e de matrizes (6); laços aninhados |
| 4 | tudo o que vem antes (refatora um projeto anterior) | funções nos projetos 5 a 7; dígito verificador usado no 7 |
| 5 | laços e funções | matrizes (6); coleção de registros (7) |
| 6 | laços aninhados e vetores | tabelas e frequências; percursos de coleções no 7 |
| 7 | funções (4), vetores (5), decisões (2), laços (3), dígito verificador (4) | — |

## Se o ritmo apertar

Sugestão para priorizar quando faltar tempo (a decisão é do professor):

| Projeto | Essencial | Pode ser reduzido |
|---|---|---|
| 1 | incrementos 1 a 3 | incremento 4 vira desafio individual |
| 2 | incrementos 1, 2 e 4 | `switch` em uma miniaula; desafio da margem opcional |
| 3 | incrementos 1 a 4 | simulação (incremento 5) como extensão |
| 4 | incrementos 1 a 3 | refatoração limitada ao mínimo de três funções |
| 5 | incrementos 1, 2, 4 e 6 | duplicados (3) e intercalação (5) como extensão |
| 6 | incrementos 1 e 2 | transposta, coluna de totais e frequências em demonstração guiada |
| 7 | I1 a I3 e testes | apresentação e manual em formato mais curto |

## Se você ficou para trás

1. Converse com o professor logo que perceber o atraso, com o diário em mãos.
2. Volte ao **último projeto cuja lista "Posso avançar?" você não consegue marcar** e estude o material correspondente.
3. Após o feedback, entregue a nova versão com o registro pedido na [avaliação](avaliacao.md): **defeito, causa, correção e teste que comprova a mudança**.
4. Estude em par: explicar o programa para um colega revela lacunas.

## Acompanhamento

Como os projetos 0 a 6 valem 45 %, os desafios individuais 20 %, o projeto integrador 25 % e o diário, a revisão e as retrospectivas 10 % (veja a [avaliação](avaliacao.md)), vale manter o quadro abaixo atualizado no seu fork (por exemplo, em `EQUIPE.md`):

| Projeto | Aulas | Entregue em | Tag (`projeto-0N`) | Feedback incorporado? |
|---|---|---|---|---|
| 0 | 1–8 | | | |
| 1 | 9–26 | | | |
| 2 | 27–44 | | | |
| 3 | 45–68 | | | |
| 4 | 69–84 | | | |
| 5 | 85–106 | | | |
| 6 | 107–122 | | | |
| 7 | 123–144 | | | |
