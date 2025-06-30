#!/bin/bash

set -e

# Configuración básica
GIT_NAME="CI Bot"
GIT_EMAIL="ci-bot@example.com"
KEY_COMMENT="CI GPG Key"
KEY_TYPE="RSA"
KEY_LENGTH="4096"
KEY_EXPIRE="0"  # 0 = nunca expira

echo "✅ Configurando Git..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "📦 Instalando GnuPG..."
sudo apt-get update && sudo apt-get install -y gnupg2

echo "🔐 Generando clave GPG..."
cat > gpg_batch <<EOF
Key-Type: $KEY_TYPE
Key-Length: $KEY_LENGTH
Subkey-Type: $KEY_TYPE
Subkey-Length: $KEY_LENGTH
Name-Real: $GIT_NAME
Name-Email: $GIT_EMAIL
Expire-Date: $KEY_EXPIRE
%no-protection
%commit
EOF

gpg --batch --generate-key gpg_batch
rm gpg_batch

echo "🔍 Obteniendo KEY ID largo..."
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$GIT_EMAIL" | grep '^sec' | awk '{print $2}' | cut -d'/' -f2)

echo "🔧 Configurando Git para firmar con GPG..."
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
git config --global tag.gpgSign true

echo "✅ GPG configurado exitosamente con Key ID: $KEY_ID"
