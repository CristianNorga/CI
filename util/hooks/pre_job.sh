#!/bin/bash
echo "[pre_job] Iniciando job en $(date)"

# Directorio temporal para el job
mkdir -p /tmp/github-runner-job
chmod 700 /tmp/github-runner-job

# Matar procesos huérfanos que hayan quedado (opcional y cuidadoso)
# pkill -u github-runner --older-than 15m

# Verificar conectividad si se requiere acceso remoto
ping -c 1 github.com &> /dev/null
if [ $? -ne 0 ]; then
  echo "[pre_job] ⚠️ No hay conexión con GitHub"
  exit 1
fi

if command -v make &>/dev/null; then
  make -f "~/personal/laboratory/CI/Makefile" "setup-permissions"
else
  echo "⚠️ 'make' no disponible. no se aplicarán permisos de ejecución a los scripts."
fi

echo "[pre_job] Listo para ejecutar el workflow"
