#!/bin/bash

# Directorio actual (como pwd)
BASE_PATH=$(pwd)
COMPOSE_PATH="$BASE_PATH"
FLOWS_PATH="$BASE_PATH/flujos"  # Asegurate de tener la carpeta "flujos" al lado del script
VOLUME_NAME="n8n_data"
TEST_FILE="workflow.json"       # Cambiá esto si tu archivo clave se llama distinto

# Cambiar al directorio del docker-compose.yml
cd "$COMPOSE_PATH"

# Levantar los contenedores en segundo plano
docker-compose up -d

# Esperar unos segundos para que los volúmenes se monten
sleep 5

# Crear contenedor temporal que monte el volumen
docker create -v "$VOLUME_NAME:/data" --name temp_n8n alpine > /dev/null

# Verificar si el archivo ya existe dentro del volumen
EXISTS=$(docker run --rm -v "$VOLUME_NAME:/data" alpine sh -c "[ -f /data/$TEST_FILE ] && echo exists")

if [ "$EXISTS" = "exists" ]; then
    echo "✔️  Los flujos ya están en el volumen. No se copió nada."
else
    echo "📁 Copiando flujos desde: $FLOWS_PATH"
    docker cp "$FLOWS_PATH/." temp_n8n:/data
    echo "✅ Archivos copiados al volumen."
fi

# Eliminar contenedor temporal
docker rm temp_n8n > /dev/null

echo -e "\n🚀 Todo listo. Contenedores levantados y flujos presentes."
