#!/bin/bash
set -e

GIT_EMAIL="ci-bot@example.com"

if gpg --list-secret-keys "$GIT_EMAIL" >/dev/null 2>&1; then
  echo "✅ Clave GPG ya existe para $GIT_EMAIL"
else
  echo "🔐 Generando nueva clave GPG para $GIT_EMAIL..."

  cat > gpg_batch <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: CI Bot
Name-Email: $GIT_EMAIL
Expire-Date: 0
%no-protection
%commit
EOF

  gpg --batch --generate-key gpg_batch
  rm gpg_batch
fi

KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$GIT_EMAIL" | grep '^sec' | awk '{print $2}' | cut -d'/' -f2)

git config --global user.signingkey "$KEY_ID"

echo "✅ GPG configurado correctamente con Key ID: $KEY_ID"
