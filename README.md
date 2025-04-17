# 🧠 IA Center - Automatización con n8n, Gemini y Qdrant

Este proyecto contiene flujos automatizados creados con [n8n](https://n8n.io/) para procesamiento de audio, generación de transcript, integración con Gemini y almacenamiento en vectores con Qdrant.

---

## 📁 Estructura del proyecto
## Estructura del proyecto

```text
IACENTER-TEST/
├── flujos/ # Flujos exportados de n8n en formato JSON
│   ├── AAA_AI_Center_Transcript_Workflow_Option_A.json
│   └── ...
├── workflow.json # Archivo clave para verificar si ya se copiaron los flujos
├── .env # Variables de entorno del proyecto (no versionado)
├── .env.template # Plantilla de las variables (puede copiarse como .env)
├── docker-compose.yml # Orquestación de los contenedores n8n y Qdrant
├── start-n8n.ps1 # Script PowerShell para Windows (usando rutas relativas)
├── start-n8n.bat # Script doble-clickeable que ejecuta el de PowerShell
├── start-n8n.sh # Script Bash para Linux
└── README.md # Este archivo ;)
```
---

## ⚙️ Requisitos previos

- Docker y Docker Compose instalados.
- PowerShell (en Windows) o Bash (en Linux).
- Archivo `.env` creado a partir del `.env.template` con tus claves y configuraciones:

### 📄 `.env.template` (ejemplo)

```env
N8N_PORT=5678
N8N_HOST=localhost
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=supersecret
N8N_LOG_LEVEL=info
N8N_DEFAULT_LOCALE=en
N8N_EDITOR_BASE_URL=http://localhost:5678
N8N_PROTOCOL=http
QDRANT_URL=http://qdrant:6333
QDRANT_API_KEY=tu-api-key
GEMINI_API_KEY=tu-api-key-gemini
```
Renombra este archivo como .env y completa los valores.

---

## 🚀 Cómo levantar el proyecto
Los scripts incluyen la lógica para levantar los contenedores y copiar automáticamente los flujos al volumen de n8n, si aún no han sido copiados.

🪟 En Windows
Hacé doble clic en start-n8n.bat

Esperá a que se levanten los contenedores y se copien los flujos.

También podés ejecutar manualmente en PowerShell:
```powershell
./start-n8n.ps1
```

🐧 En Linux
Dale permisos de ejecución al script:
```bash
chmod +x start-n8n.sh
```

Y luego ejecuta
```bash
./start-n8n.sh
```
---
## 🧠 ¿Qué hace el script?
- Lanza los contenedores con Docker Compose.
- Verifica si el archivo workflow.json ya está en el volumen n8n_data.
- Si no está, copia todos los archivos desde ./flujos/ al volumen.
- Deja n8n corriendo con todos los flujos cargados automáticamente.

## 🌐 Acceder a n8n
Una vez levantado, podés entrar a:
http://localhost:5678
(o el puerto y host que hayas definido en tu .env)

🛑 (Opcional) Cómo detener y borrar todo
```bash
docker-compose down -v
```