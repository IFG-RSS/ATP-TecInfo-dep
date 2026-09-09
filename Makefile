CC ?= cc
CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion
BUILD_DIR := build

.PHONY: check clean

check: $(BUILD_DIR)/programa_base $(BUILD_DIR)/teste_funcao
	$(BUILD_DIR)/teste_funcao

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/programa_base: modelos/programa_base.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/teste_funcao: modelos/teste_funcao.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f $(BUILD_DIR)/programa_base $(BUILD_DIR)/teste_funcao
