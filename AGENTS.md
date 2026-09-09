# AGENTS.md

## Visão geral

Este repositório pertence à disciplina de dependência em ATP do curso Técnico Integrado em Informática para a Internet do IFG – Câmpus Inhumas.

O projeto contém material PBL em Markdown, modelos em C17 e oito projetos progressivos. Preserve a coerência entre `README.md`, `docs/plano-do-curso.md` e as cargas horárias declaradas nos projetos.

## Diretrizes de trabalho

- Preserve o português do Brasil na documentação e nos textos voltados aos estudantes.
- Faça mudanças pequenas e diretamente relacionadas à tarefa solicitada.
- Não presuma linguagem, framework, gerenciador de pacotes ou ferramenta de build enquanto eles não estiverem definidos no repositório.
- Não adicione dependências, arquivos gerados ou configurações de ferramentas sem necessidade demonstrável.
- Nunca inclua credenciais, tokens, segredos ou dados pessoais no repositório.
- Enunciados inspirados em obras bibliográficas devem ser adaptações autorais com rastreabilidade; não copie longos trechos protegidos.
- Exemplos em C devem ser compatíveis com C17 e acessíveis a estudantes iniciantes.

## Validação

Execute a validação básica com:

```bash
make check
```

Ao adicionar programas aos projetos, compile-os com `-std=c17 -Wall -Wextra -Wpedantic -Wconversion`. Além disso:

1. documente aqui os comandos exatos;
2. execute as verificações relevantes antes de concluir uma alteração;
3. informe claramente qualquer verificação que não tenha sido possível executar.

## Commits e revisão

- Use mensagens de commit curtas e descritivas.
- Antes de finalizar, revise `git diff` e confirme que não há alterações alheias à tarefa.
- Atualize o `README.md` quando uma mudança alterar a forma de instalar, executar ou utilizar o projeto.
