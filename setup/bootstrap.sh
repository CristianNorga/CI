#!/bin/bash
set -e

# Obtiene el directorio donde se encuentra este script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "🚀 Iniciando configuración completa del entorno CI..."

SCRIPTS=(
  "install-deps.sh"
  "install-nvm.sh"
  "install-docker.sh"
  "install-trivy.sh"
  "setup-gpg-ci.sh"
  "setup-git.sh"
)

for script in "${SCRIPTS[@]}"; do
  echo "🔍 Verificando existencia de $script..."
  if [ -f "$SCRIPT_DIR/$script" ]; then
    echo "🔧 Ejecutando $script..."
    bash "$SCRIPT_DIR/$script"
    echo
  else
    echo "❌ Script $script no encontrado en $SCRIPT_DIR"
    exit 1
  fi
done

echo "🛡️ Aplicando permisos de ejecución a scripts del CI..."