#!/usr/bin/env bash

# Fonte: https://github.com/iuricode/padroes-de-commits

# Ruta ao ficheiro da mensaxe de commit (fornecido por Git)
COMMIT_MSG_FILE=$1

# Le a mensaxe de commit do ficheiro
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

CONVENTIONAL_COMMIT_REGEX='^(feat|fix|docs|style|refactor|test|chore|build|ci|perf|revert)(\([a-zA-Z0-9_.-]+\))?(!)?:\s.*$'

# Comproba se a mensaxe de commit cadra co regex
if ! [[ $COMMIT_MSG =~ $CONVENTIONAL_COMMIT_REGEX ]]; then
    echo "ERRO: A mensaxe de commit non segue o formato dos Conventional Commits."
    echo
    echo "Cómpre utilizar mensaxes de commit co seguinte formato:"
    echo "  <tipo>(<contexto opcional>): <descrición>"
    echo
    echo "Os tipos válidos son:"
    echo "  feat:     Engadir unha nova funcionalidade."
    echo "  fix:      Corrección dun bug."
    echo "  docs:     Cambios na documentación."
    echo "  style:    Cambios de estilo no código (formato, punto e coma ausente, etc.)."
    echo "  refactor: Reescribir ou reestruturar o código (nin corrixe bugs nin engade funcionalidades)."
    echo "  perf:     Melloras no rendemento."
    echo "  test:     Engadir ou actualizar tests."
    echo "  build:    Cambios que afectan o sistema de build ou dependencias externas."
    echo "  chore:    Cambios que non modifican o src nin os tests (actualización dependencias, scripts, modificar .gitignore, etc.)."
    echo "  ci:       Cambios nos ficheiros de configuración de CI ou scripts."
    echo "  revert:   Reverter un commit anterior."
    echo
    echo "Nota:"
    echo "  Os commit que introduzan cambios críticos deben ser indicados cun «!» antes do «:»."
    echo
    echo "Exemplos:"
    echo "  feat(auth): engadir funcionalidade de login"
    echo "  fix(api)!: resolver problema de timeout"
    echo "  docs(readme): actualizar instrucións de instalación"
    echo
    exit 1
fi

exit 0
