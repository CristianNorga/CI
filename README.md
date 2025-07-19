# 🚀 Configuración de CI con GitHub Actions, Docker y NitroJs

## 🛠️ Configuración de Entorno (maquina, etc)

### Instalar dependencias necesarias

1. **Docker:** `https://docs.docker.com/desktop/setup/install/linux/ubuntu/`

2. **KVM:** (habilitar virtualización en BIOS/UEFI)
 `https://docs.docker.com/desktop/setup/install/linux/#kvm-virtualization-support`

3. **minikube:** `https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download`



```bash
sudo install -y make
```
#### 🛠️ Configuración de GitHub Actions

##### Estrategias para aislar y controlar permisos

1. Crear un usuario dedicado sin sudo

- useradd --system --shell /bin/bash github-runner

- Instalar/configurar el servicio del runner con ese usuario

- Así limita el blast radius si un job corre un comando malicioso

2. Restringir con systemd sandboxing En el archivo de servicio `/etc/systemd/system/github-runner.service` puedes añadir parámetros:

```ini
[Service]
User=github-runner
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true
PrivateDevices=true
PrivateUsers=true
ReadOnlyPaths=/
CapabilityBoundingSet=CAP_CHOWN CAP_DAC_OVERRIDE CAP_SETGID
```
Con esto:

- `NoNewPrivileges`: impide `setuid`/`setgid` y nuevos permisos.

- `ProtectSystem=full`: monta `/usr` y `/boot` como solo-lectura.

- `ProtectHome`: aísla el home de otros usuarios.

3. Usar Docker o contenedores para cada job

- Cada job corre en un container y solo el runner “host” necesita permisos mínimos.

- Dentro del contenedor puedes dar sudo temporalmente (o no), sin exponer la máquina anfitriona.

4. Hooks de pre- y post-job Puedes definir scripts que se ejecuten antes y después de cada job para:

- Ajustar permisos en carpetas de trabajo.

- Limpiar procesos o ficheros sueltos. Para ello en tu config.yml del runner añade:

```yaml
runner:
  pre_job:  /opt/github-runner/hooks/pre-job.sh
  post_job: /opt/github-runner/hooks/post-job.sh
```
En esos scripts puedes, por ejemplo, revocar sudoers temporales o chequear UID/GID.

5. Agregar el usuario al grupo docker

sudo usermod -aG docker $(whoami)
newgrp docker

Luego reinicia el runner o la terminal para que los cambios surtan efecto.

⚠️ Esta opción es conveniente, pero ten en cuenta que da acceso completo al demonio de Docker, lo cual tiene implicaciones de seguridad.

##### Ejemplo: instalar y aislar un runner
1. Crear usuario sin sudo y home dedicado

```bash
sudo useradd --system --create-home --shell /bin/bash github-runner
```

2. Descargar e instalar el runner bajo ese usuario

```bash
sudo -u github-runner bash -c '
  cd ~github-runner
  curl -O -L https://github.com/actions/runner/releases/download/vX.Y.Z/actions-runner-linux-x64-*.tar.gz
  tar xzf actions-runner-*.tar.gz
  ./config.sh --url https://github.com/tuOrg/tuRepo --token $TOKEN
  sudo ./svc.sh install github-runner
  sudo ./svc.sh start
'
```

3. Aplicar sandboxing vía systemd

```ini
# /etc/systemd/system/github-runner.service.d/sandbox.conf
[Service]
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true
CapabilityBoundingSet=CAP_DAC_OVERRIDE CAP_CHOWN
```

**Luego:**

```bash
sudo systemctl daemon-reload
sudo systemctl restart github-runner
```

4. Aislar jobs en Docker En tu workflow de GitHub Actions:

```yaml
jobs:
  build:
    runs-on: self-hosted
    container:
      image: ubuntu:22.04
    steps:
      - run: echo "Corriendo dentro de un container aislado"
```

##### Buenas prácticas de fin de ejecución

- En `post-job` hook elimina ficheros temporales y revoca privilegios otorgados.

- Borra contenedores o procesos huérfanos.

- Verifica que el runner haya salido con código 0 para asegurar consistencia de permisos.

Con estas capas de protección te aseguras de que el runner:

- Arranque siempre con un usuario sin privilegios excesivos.

- No gane permisos de root durante la ejecución de jobs.

- Limpie y restaure el entorno al terminar cada trabajo.

##### 🧠 Alias Makeci 
se debe añadir a tu ~/.bashrc o ~/.zshrc:

```bash
alias makeci="make -f ~/personal/laboratory/CI/Makefile"
```
Así solo ejecutas:

```bash
cd ~/personal/laboratory/actions-runner/_work/mi-proyecto
makeci setup
```

**Nota:** Recuerda cambiar el path en base a la ubicacion del proyecto.

> ~/.bashrc - Makeci
> ~/personal/laboratory/CI/Makefile - PATHCI

#Conectarse SSH KEY 
> (PRUEBA LOCAL)

###🧾 Paso 1: Crear el par de claves SSH
Ejecuta el siguiente comando en la VM:

```bash
ssh-keygen -t ed25519 -C "ci-agent@tudominio.com"
```
**Explicación:**
-t ed25519: tipo de clave moderna, rápida y segura.
-C: comentario para identificar la clave.

Cuando se te pregunte dónde guardar la clave, presiona Enter para usar el valor por defecto (~/.ssh/id_ed25519). Puedes usar un nombre personalizado si quieres manejar varias claves.

###✅ Paso 2: Verifica que se creó correctamente

```bash
ls -la ~/.ssh
Deberías ver dos archivos:
```
id_ed25519 (clave privada – NO la compartas)
id_ed25519.pub (clave pública – se usa para registrar en GitHub)

###📋 Paso 3: Copiar la clave pública
Para copiar la clave pública al portapapeles:

```bash
cat ~/.ssh/id_ed25519.pub
```
**Copia** el contenido completo, que se verá algo como:

```bash
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICj... ci-agent@tudominio.com
```

###🌐 Paso 4: Registrar la clave en GitHub
**Opción A:** Como Deploy Key (ideal si solo necesitas acceso de lectura o lectura/escritura a un único repositorio)

#####Ve a tu repositorio en GitHub.

1. Entra a Settings > Deploy Keys.
2. Haz clic en "Add deploy key".
3. Pega la clave pública, ponle un nombre como CI Agent Key.

>Marca "Allow write access" si quieres que pueda hacer push.

**Opción B:** Como SSH Key de tu cuenta (acceso a todos los repos si eres colaborador)
Ve a https://github.com/settings/keys.

1. Haz clic en "New SSH Key".
2. Pega la clave pública y dale un nombre.

###⚙️ Paso 5: Configurar .ssh/config (opcional pero recomendado)
Edita o crea el archivo ~/.ssh/config y agrega lo siguiente:

```bash
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
```
>Esto asegura que se use la clave correcta al conectarse con GitHub.

###🔎 Paso 6: Probar la conexión

```bash
ssh -T git@github.com
```
Si es la primera vez, GitHub pedirá confirmar la huella digital. Luego deberías ver:

```bash
Hi your-username! You've successfully authenticated, but GitHub does not provide shell access.
```