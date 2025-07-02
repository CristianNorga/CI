#!/bin/bash
echo "[post_job] Finalizando job en $(date)"

# Borrar directorios temporales
rm -rf /tmp/github-runner-job

# Limpiar contenedores salidos (si usas Docker)
docker ps -a --filter "status=exited" --format "{{.ID}}" | xargs -r docker rm

# Eliminar imágenes sin tag (dangling)
docker image prune -f

# Eliminar variables sensibles si las guardas temporalmente
unset SECRET_KEY
unset GITHUB_TOKEN

echo "[post_job] Cleanup completado ✔️"
