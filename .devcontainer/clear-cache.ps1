$ErrorActionPreference = "Stop"

$composeFile = Join-Path $PSScriptRoot "docker-compose.yml"
$docker = Get-Command docker.exe -ErrorAction SilentlyContinue
if (-not $docker) {
    throw "docker.exe was not found. Install or start Docker Desktop, then retry."
}

$clearCacheCommand = @'
set -e
for cache_dir in /root/.cache/esphome /root/.platformio /root/.cache/pip /esphome-data; do
    find "$cache_dir" -mindepth 1 -delete
done
'@

Write-Output "Clearing shared ESPHome, PlatformIO, and pip cache volumes..."
$imageCacheVolumes = @(
    & docker.exe volume ls --quiet --filter "name=esphome-components-" |
        Where-Object { $_ -match '^esphome-components-((esphome|platformio)-cache|data)-.+$' }
)
if ($imageCacheVolumes.Count -gt 0) {
    Write-Output "Removing per-image cache volumes: $($imageCacheVolumes -join ', ')"
    & docker.exe volume rm @imageCacheVolumes
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to remove per-image cache volumes (exit code $LASTEXITCODE)."
    }
}
& docker.exe compose --file $composeFile run --pull missing --rm --no-deps `
    esphome /bin/bash -lc $clearCacheCommand
if ($LASTEXITCODE -ne 0) {
    throw "Failed to clear the shared component cache volumes (exit code $LASTEXITCODE)."
}

$images = @(& docker.exe image ls --format '{{.Repository}}:{{.Tag}}' ghcr.io/esphome/esphome)
if ($LASTEXITCODE -ne 0) {
    throw "Cache volumes were cleared, but ESPHome Docker images could not be listed."
}
$images = @($images | Where-Object { $_ -match '^ghcr\.io/esphome/esphome:[^<]+$' } | Sort-Object -Unique)

if ($images.Count -gt 0) {
    Write-Output "Removing downloaded ESPHome images: $($images -join ', ')"
    & docker.exe image rm @images
    if ($LASTEXITCODE -ne 0) {
        throw "Cache volumes were cleared, but some ESPHome images could not be removed. Close any containers using them and retry."
    }
}
else {
    Write-Output "No downloaded ghcr.io/esphome/esphome images were found."
}

Write-Output "Shared component caches and downloaded ESPHome images were cleared."
