#!/bin/bash
set -e

echo "🔄 Restaurando etiquetas relevantes al HEAD actual..."

CURRENT_COMMIT=$(git rev-parse HEAD)
PREVIOUS_COMMIT=$(git rev-parse HEAD^)

# Ajusta este patrón según tus tipos de etiquetas
TAGS=$(git tag --points-at "$PREVIOUS_COMMIT" | grep -E '^(compliance/|build/|v[0-9]+\.[0-9]+\.[0-9]+)$')

if [ -z "$TAGS" ]; then
  echo "⚠️  No se encontraron etiquetas relevantes en el commit anterior."
  exit 0
fi

for TAG in $TAGS; do
  echo "🔁 Reposicionando etiqueta $TAG al commit actual ($CURRENT_COMMIT)..."
  git tag -f "$TAG" "$CURRENT_COMMIT"
  git push origin "$TAG" --force
done

echo "✅ Restauración completa de etiquetas relevantes."
