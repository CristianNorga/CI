#!/bin/bash
set -e

echo "📦 Verificando e instalando dependencias básicas..."

sudo apt-get update

for pkg in git curl wget jq gnupg2 ca-certificates dpkg lsb-release; do
  if ! dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "➡️  Instalando $pkg..."
    sudo apt-get install -y "$pkg"
  else
    echo "✅ $pkg ya está instalado"
  fi
done
