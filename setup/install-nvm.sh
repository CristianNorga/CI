#!/bin/bash

set -e

# Activar colores si está en terminal
GREEN="\e[32m"
RESET="\e[0m"

echo -e "${GREEN}📦 Instalando NVM...${RESET}"

# Instalar NVM si no existe
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Cargar NVM
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

# Elegir versión de Node.js
if [ -f ".nvmrc" ]; then
  NODE_VERSION=$(cat .nvmrc)
  echo -e "${GREEN}🧭 Archivo .nvmrc encontrado, usando Node.js $NODE_VERSION${RESET}"
else
  NODE_VERSION="lts/*"
  echo -e "${GREEN}⚠️  No se encontró .nvmrc, instalando versión LTS más reciente${RESET}"
fi

# Instalar y usar la versión
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

echo -e "${GREEN}✅ Node.js $(node -v) instalado y configurado como predeterminado${RESET}"
