#!/bin/bash
set -e

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
  if [ -f "./$script" ]; then
    echo "🔧 Ejecutando $script..."
    bash "./$script"
    echo
  else
    echo "❌ Script $script no encontrado"
    exit 1
  fi
done

echo "🎉 Entorno CI configurado exitosamente."
