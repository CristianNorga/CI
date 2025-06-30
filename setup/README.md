# CI Setup Scripts

Este directorio contiene scripts independientes para configurar un entorno CI local (Ubuntu) que actúa como runner para GitHub Actions.

---

## 📦 Estructura

| Script                  | Propósito                                                |
|------------------------|----------------------------------------------------------|
| `install-deps.sh`      | Instala dependencias generales (git, curl, gpg, etc.)    |
| `install-nvm.sh`       | Instala NVM y Node.js según `.nvmrc` o versión manual    |
| `install-docker.sh`    | Instala Docker Engine                                     |
| `install-trivy.sh`     | Instala Trivy para escaneo de seguridad                  |
| `setup-gpg-ci.sh`      | Genera una clave GPG sin passphrase para firmar tags     |
| `setup-git.sh`         | Configura Git con nombre, email y firma por defecto      |

---

## 🧪 Orden de Ejecución Recomendado

```bash
./install-deps.sh
./install-nvm.sh
./install-docker.sh
./install-trivy.sh
./setup-gpg-ci.sh
./setup-git.sh
