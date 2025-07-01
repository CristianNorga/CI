#!/bin/bash
set -e

if ! command -v trivy >/dev/null 2>&1; then
  echo "🔐 Instalando Trivy..."
  wget -qO trivy.deb https://github.com/aquasecurity/trivy/releases/download/v0.63.0/trivy_0.63.0_Linux-64bit.deb
  sudo dpkg -i trivy.deb
  rm trivy.deb
  echo "✅ Trivy instalado correctamente"
else
  echo "✅ Trivy ya está instalado"
fi

trivy --version
