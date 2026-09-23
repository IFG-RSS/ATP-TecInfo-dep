# Projeto 4 — Caixa de ferramentas

**Duração:** 16 aulas. **Base:** Farrer, cap. 3 (sub-rotinas, funções e modularização).

**Estude com:** [Material 4 — Funções](../../materiais/04-funcoes.md). **Ritmo sugerido:** [aulas 69–84 no guia de avanço](../../docs/guia-de-avanco.md#projeto-4).

## Situação-problema

Os programas anteriores repetem validações e cálculos. A turma criará uma pequena biblioteca reutilizável e demonstrará que cada função cumpre seu contrato isoladamente.

## API mínima

```c
int esta_no_intervalo(double valor, double minimo, double maximo);
double percentual(double parte, double total);
double media3(double a, double b, double c);
int maximo3(int a, int b, int c);
int digito_verificador(long long numero);
```

O grupo define comportamento para argumentos inválidos e o documenta. O dígito verificador é uma adaptação simplificada de Farrer 2.5.3.6 e prepara o projeto de registros.

## Incrementos

1. Escreva contratos: propósito, parâmetros, retorno e restrições.
2. Implemente em `ferramentas.c` com declarações em `ferramentas.h`.
3. Teste com `assert`, incluindo fronteiras e total zero.
4. Refatore um projeto anterior para usar ao menos três funções.

## Critérios de aceitação

`main` coordena o fluxo; funções têm uma responsabilidade, nomes informativos e não dependem de variáveis globais. Testes podem rodar sem entrada interativa.

**Entrega:** `.h`, `.c`, testes, programa refatorado e diagrama simples das chamadas.
