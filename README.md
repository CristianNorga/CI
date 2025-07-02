# 🚀 Configuración de CI con GitHub Actions y SSH Key

### 🛠️ Configuración de GitHub Actions
### 🛠️ Configuración de Entorno (maquina, etc)

```bash
sudo install -y make
```

###🧠 Alias Makeci 
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