#!/bin/bash

set -e

# Obtiene el directorio donde se encuentra este script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Activar colores si está en terminal
GREEN="\e[32m"
RESET="\e[0m"

echo -e "${GREEN}🔧 Configurando permisos para habilitar scripts"

# Aplicar permisos de ejecución a todos los scripts en el directorio actual
find "$SCRIPT_DIR" -type f -name "*.sh" -exec chmod +x {} \;
find "$SCRIPT_DIR/../setup/" -type f -name "*.sh" -exec chmod +x {} \;
find "$SCRIPT_DIR/../util/git" -type f -name "*.sh" -exec chmod +x {} \;

echo -e "${GREEN}✅ Permisos de ejecución aplicados a scripts del CI.${RESET}"
