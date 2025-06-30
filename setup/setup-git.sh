#!/bin/bash
set -e

echo "🔧 Configurando Git globalmente..."

git config --global user.name "CI Bot"
git config --global user.email "ci-bot@example.com"
git config --global commit.gpgsign true
git config --global tag.gpgSign true

echo "✅ Git configurado correctamente"
