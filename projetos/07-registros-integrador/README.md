# Projeto 7 — Sistema acadêmico

**Duração:** 22 aulas. **Base:** Farrer 2.3 e 2.5.3; adaptações de 2.5.3.1–2.5.3.8 e integração do problema 1.12.12.

**Estude com:** [Material 7 — Registros e sistema modular](../../materiais/07-registros-integrador.md). **Ritmo sugerido:** [aulas 123–144 no guia de avanço](../../docs/guia-de-avanco.md#projeto-7).

## Situação-problema

Vetores paralelos tornam difícil garantir que nome, matrícula, notas e frequência continuem associados. A coordenação encomenda um protótipo em memória para cadastrar estudantes, calcular situações e emitir relatórios.

## Modelo inicial

```c
#define MAX_ESTUDANTES 100
#define TAM_NOME 81

typedef struct {
    int matricula;
    char nome[TAM_NOME];
    double notas[3];
    int presencas;
    int total_aulas;
} Estudante;
```

## Histórias de usuário

1. Como atendente, quero cadastrar um estudante com matrícula única.
2. Como docente, quero buscar por matrícula e atualizar notas e frequência.
3. Como estudante, quero consultar média, percentual de frequência e situação justificada.
4. Como coordenação, quero listar estudantes, média da turma, maior/menor média e quantidades por situação.
5. Como auditor, quero validar a matrícula com a função de dígito verificador criada no Projeto 4, adaptação de Farrer 2.5.3.6.

## Incrementos

- **I1 — modelo:** desenhe o registro e implemente cadastro/listagem;
- **I2 — regras:** implemente funções de média, frequência e situação;
- **I3 — consultas:** busca e relatório agregado;
- **I4 — qualidade:** testes, revisão, demonstração e manual curto.

## Arquitetura mínima

```text
sistema.c       menu e coordenação
estudante.h     tipo e contratos
estudante.c     regras sobre um estudante
turma.h         operações sobre a coleção
turma.c
testes.c        testes das funções sem interação
```

Persistência em arquivo é uma extensão, não um requisito. O núcleo obrigatório trabalha em memória.

## Critérios de aceitação

- compila sem avisos nas opções do curso;
- impede mais de 100 cadastros e matrículas duplicadas;
- não acessa posições inválidas;
- define situação para todos os limites de nota e frequência;
- separa interface, regras e operações da coleção;
- possui testes de unidade das regras e roteiro de teste do menu;
- todos os integrantes demonstram uma parte sorteada.

## Extensões

Ordenar por nome ou média; pesquisar por fragmento do nome; importar/exportar CSV; comparar turmas numa matriz; criar relatório de recuperação.

**Entrega:** código modular, diário, backlog marcado, testes, manual de uso e apresentação de 8 minutos.
