# Guia de entrega

Cada equipe trabalha em um **fork** deste repositório. O repositório principal contém apenas enunciados e material de apoio; o trabalho da equipe fica no fork.

## Preparação (uma vez por equipe)

1. Um integrante cria o fork no GitHub e adiciona os demais como colaboradores.
2. Todos clonam o fork e registram o repositório principal como `upstream`:

   ```bash
   git clone git@github.com:<usuario>/ATP-TecInfo-dep.git
   cd ATP-TecInfo-dep
   git remote add upstream git@github.com:IFG-RSS/ATP-TecInfo-dep.git
   ```

3. Crie `EQUIPE.md` na raiz do fork a partir do [modelo](../modelos/equipe.md) e envie o endereço do fork ao professor.

Forks de repositórios públicos são públicos. Não inclua matrícula, e-mail, telefone ou qualquer dado pessoal além do nome.

## Organização dos arquivos

Tudo de um projeto fica na própria pasta do projeto, ao lado do enunciado:

```text
projetos/01-sequencia-e-expressoes/
├── README.md     enunciado (não altere)
├── diario.md     copiado de modelos/diario.md
└── cantina.c     programa pedido na entrega
```

Use os nomes de arquivo indicados na seção **Entrega** de cada enunciado. Projetos com várias partes (4 e 7) mantêm `.h`, `.c` e `testes.c` na mesma pasta. Portugol, tabela de testes e retrospectiva ficam no `diario.md`.

Não versione executáveis nem arquivos `.o`. Compile para `build/`, que já é ignorado:

```bash
mkdir -p build
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion projetos/01-sequencia-e-expressoes/cantina.c -o build/cantina
./build/cantina
```

Com vários arquivos, liste todos os `.c`:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion projetos/04-funcoes/ferramentas.c projetos/04-funcoes/testes.c -o build/testes_ferramentas
./build/testes_ferramentas
```

## Ritmo de commits

- ao menos um commit ao fim de cada incremento;
- mensagens curtas que digam o que mudou: "Adiciona cálculo de troco", "Trata n = 0 na média";
- todos os integrantes aparecem no histórico;
- `git pull` antes de começar e `git push` ao terminar cada sessão.

## Entrega de um projeto

A entrega é o estado do fork no prazo. Antes do prazo, confira:

1. o programa compila sem avisos com as opções do curso;
2. `diario.md` está completo, com casos de teste (saída esperada e obtida) e retrospectiva;
3. o uso de ferramentas e IA está declarado no diário;
4. o último commit está no GitHub;
5. opcional: marque a versão entregue com `git tag projeto-01` e `git push --tags`.

Correções após feedback vão em novos commits, com o registro pedido na [avaliação](avaliacao.md): defeito, causa, correção e teste que comprova a mudança.

## Atualizações do enunciado

Quando o repositório principal mudar, traga as alterações para o fork:

```bash
git fetch upstream
git merge upstream/main
git push
```

Ou use o botão **Sync fork** no GitHub. Como as pastas dos projetos só recebem arquivos novos da equipe, não há conflito com os enunciados.
