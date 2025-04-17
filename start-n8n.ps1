# Obtener el directorio actual como base
$basePath = Get-Location
$composePath = $basePath.Path
$flowFilesPath = Join-Path $basePath "flujos"  # Asumiendo que hay una carpeta llamada "flujos" en este mismo directorio
$volumeName = "n8n_data"
$testFile = "workflow.json"  # Archivo clave que indica si los flujos ya están en el volumen

# Ir al directorio donde está el docker-compose.yml
Set-Location -Path $composePath

# Levantar los contenedores
docker-compose up -d

# Esperar a que los servicios inicien
Start-Sleep -Seconds 5

# Crear contenedor temporal para acceder al volumen
$containerId = docker create -v $volumeName:/data --name temp_n8n alpine

# Verificar si el flujo ya existe
$exists = docker run --rm -v $volumeName:/data alpine sh -c "test -f /data/$testFile && echo exists"

if ($exists -eq "exists") {
    Write-Host "✔️  Los flujos ya están en el volumen. No se copió nada."
} else {
    Write-Host "📁 Copiando flujos al volumen desde: $flowFilesPath"
    docker cp "$flowFilesPath\." temp_n8n:/data
    Write-Host "✅ Archivos copiados al volumen."
}

# Limpiar contenedor temporal
docker rm temp_n8n | Out-Null

Write-Host "`n🚀 Todo listo. Contenedores levantados y flujos presentes."
pause
