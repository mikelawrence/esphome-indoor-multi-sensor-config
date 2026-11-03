param(
    [string]$Image = "ghcr.io/esphome/esphome:dev"
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$composeFile = Join-Path $PSScriptRoot "docker-compose.yml"
$docker = Get-Command docker.exe -ErrorAction SilentlyContinue

if (-not $docker) {
    throw "docker.exe was not found. Install or start Docker Desktop, then retry."
}

$projectHashProvider = [System.Security.Cryptography.SHA256]::Create()
try {
    $projectHash = [System.BitConverter]::ToString(
        $projectHashProvider.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($repoRoot.ToLowerInvariant()))
    ).Replace("-", "").Substring(0, 8).ToLowerInvariant()
}
finally {
    $projectHashProvider.Dispose()
}
$projectSlug = [regex]::Replace(
    (Split-Path -Leaf $repoRoot).ToLowerInvariant(),
    '[^a-z0-9_-]',
    '-'
)
$projectName = "component-$projectSlug-$projectHash"
$previousImage = $env:ESPHOME_IMAGE

try {
    $env:ESPHOME_IMAGE = $Image
    $env:COMPOSE_PROGRESS = "quiet"

    & docker.exe compose --project-name $projectName --file $composeFile run --pull missing --rm --no-deps `
        --workdir /workspaces/component esphome /bin/bash .devcontainer/validate.sh --fix

    if ($LASTEXITCODE -ne 0) {
        throw "Component auto-fix or validation failed (exit code $LASTEXITCODE)."
    }
}
finally {
    $env:ESPHOME_IMAGE = $previousImage
    Remove-Item Env:\COMPOSE_PROGRESS -ErrorAction SilentlyContinue
}
