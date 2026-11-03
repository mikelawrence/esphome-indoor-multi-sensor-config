param(
    [string]$ConfigDirectory = ".",
    [string[]]$Versions = @("stable", "beta", "dev"),
    [string]$Image,
    [string[]]$Include = @("*"),
    [switch]$SkipValidation
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$composeFile = Join-Path $PSScriptRoot "docker-compose.yml"
$workspaceContainerPath = "/workspaces/component"
$docker = Get-Command docker.exe -ErrorAction SilentlyContinue

if (-not $docker) {
    throw "docker.exe was not found. Install or start Docker Desktop, then retry."
}

# Lint and auto-fix the repository before building so problems surface before a long compile.
if (-not $SkipValidation) {
    & (Join-Path $PSScriptRoot "validate.ps1")
}

$configDirectoryPath = Join-Path $repoRoot $ConfigDirectory
if (-not (Test-Path -LiteralPath $configDirectoryPath -PathType Container)) {
    throw "Configuration directory was not found: $configDirectoryPath"
}

$configDirectoryPath = (Resolve-Path -LiteralPath $configDirectoryPath).Path
$repoRootPrefix = $repoRoot.TrimEnd('\') + '\'
foreach ($path in @($configDirectoryPath)) {
    if (
        -not $path.Equals($repoRoot, [System.StringComparison]::OrdinalIgnoreCase) -and
        -not $path.StartsWith($repoRootPrefix, [System.StringComparison]::OrdinalIgnoreCase)
    ) {
        throw "Build paths must stay inside the repository: $path"
    }
}

$configs = @(
    Get-ChildItem -LiteralPath $configDirectoryPath -File |
        Where-Object {
            $_.Extension -in @(".yaml", ".yml") -and
            $_.Name -ne "secrets.yaml" -and
            $(foreach ($pattern in $Include) { if ($_.BaseName -like $pattern -or $_.Name -like $pattern) { $true } }) -and
            $_.FullName -notmatch '[\\/]\.esphome[\\/]' -and
            $_.Name -notmatch '\.local-build-[0-9a-f-]+\.'
        } |
        Sort-Object FullName
)

if ($configs.Count -eq 0) {
    throw "No .yaml or .yml files were found under $configDirectoryPath."
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
$utf8WithoutBom = [System.Text.UTF8Encoding]::new($false)
$stagedConfigs = @()
$images = if ($Image) {
    @($Image)
}
else {
    @($Versions | ForEach-Object { "ghcr.io/esphome/esphome:$_" })
}

function Get-RemoteDigest([string]$ImageName) {
    $output = & docker.exe buildx imagetools inspect $ImageName 2>$null
    if ($LASTEXITCODE -ne 0) {
        return $null
    }
    $match = [regex]::Match(($output -join "`n"), '(?m)^Digest:\s+(sha256:[0-9a-f]+)')
    if ($match.Success) { $match.Groups[1].Value } else { $null }
}

# Skip beta when it is the same image as stable
$stableImage = "ghcr.io/esphome/esphome:stable"
$betaImage = "ghcr.io/esphome/esphome:beta"
if (-not $Image -and ($images -contains $stableImage) -and ($images -contains $betaImage)) {
    $stableDigest = Get-RemoteDigest $stableImage
    $betaDigest = Get-RemoteDigest $betaImage
    if ($stableDigest -and $stableDigest -eq $betaDigest) {
        $betaSameAsStable = $true
        $images = @($images | Where-Object { $_ -ne $betaImage })
    }
}

# Versions shown on the status line; beta is listed even when skipped
$statusVersions = @(
    $images | ForEach-Object { if ($_ -match '^ghcr\.io/esphome/esphome:(.+)$') { $Matches[1] } else { $_ } }
)
if ($betaSameAsStable) {
    $statusVersions = @("stable", "beta", "dev") | Where-Object { $_ -in ($statusVersions + "beta") }
}

if ($images.Count -eq 0) {
    throw "Select at least one ESPHome image with -Versions or -Image."
}

# Staged configs live in <config dir>/.esphome/config, so remote packages from this repository become
# local !include entries and every relative !include is re-based on the repository files.
function Convert-ToLocalConfig([string]$Content, [string]$Newline, [string]$Prefix) {
    $lines = $Content -split "`r?`n"
    $output = [System.Collections.Generic.List[string]]::new()
    $index = 0
    while ($index -lt $lines.Count) {
        $line = $lines[$index]
        $remote = [regex]::Match($line, '^(?<indent>[ \t]*)remote:\s*$')
        if (-not $remote.Success) {
            $output.Add($line)
            $index++
            continue
        }
        $indent = $remote.Groups["indent"].Value
        $files = [System.Collections.Generic.List[string]]::new()
        $index++
        while ($index -lt $lines.Count) {
            $child = $lines[$index]
            if ($child.Trim() -ne "" -and $child.Length - $child.TrimStart().Length -le $indent.Length) { break }
            $file = [regex]::Match($child, '^\s+-\s+(?<file>[^\s#]+\.ya?ml)\s*(?:#.*)?$')
            if ($file.Success) { $files.Add($file.Groups["file"].Value) }
            $index++
        }
        for ($n = 0; $n -lt $files.Count; $n++) {
            $output.Add("${indent}local_${n}: !include $($files[$n])")
        }
    }
    $result = $output -join $Newline
    [regex]::Replace($result, '(!include\s+)(?![/.])(\S+)', "`${1}$Prefix`${2}")
}
try {
    $configDirectoryRelativePath = $configDirectoryPath.Substring($repoRoot.TrimEnd('\').Length).TrimStart('\')
    $includePrefix = "../" * (@($configDirectoryRelativePath -split '\\' | Where-Object { $_ }).Count + 2)
    $stagedConfigDirectory = Join-Path $configDirectoryPath ".esphome\config"
    # Start clean in case an earlier run was interrupted
    Remove-Item -LiteralPath $stagedConfigDirectory -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path $stagedConfigDirectory -Force | Out-Null
    $containerConfigDirectory = "$workspaceContainerPath/$($configDirectoryRelativePath.Replace('\', '/'))/.esphome/config"

    # Every image gets its own staged copy of each config (unique file name) so files never collide.
    # ESPHOME_DATA_DIR keeps build output inside each container, since ESPHome would otherwise
    # share test/.esphome/build/<name> between images.
    $containerConfigPathsByImage = @{}
    foreach ($image in $images) {
        $containerConfigPathsByImage[$image] = @()
        foreach ($config in $configs) {
            $content = [System.IO.File]::ReadAllText($config.FullName)
            $newline = if ($content.Contains("`r`n")) { "`r`n" } else { "`n" }
            $localContent = Convert-ToLocalConfig $content $newline $includePrefix

            $stagedPath = Join-Path $stagedConfigDirectory (
                "$($config.BaseName).local-build-$([guid]::NewGuid().ToString()).$($config.Extension.TrimStart('.'))"
            )
            [System.IO.File]::WriteAllText($stagedPath, $localContent, $utf8WithoutBom)
            $stagedConfigs += $stagedPath

            $relativePath = $stagedPath.Substring($repoRoot.TrimEnd('\').Length).TrimStart('\')
            $containerConfigPathsByImage[$image] += "$workspaceContainerPath/$($relativePath.Replace('\', '/'))"
        }
    }

    # Each image builds in its own job (separate process, so ESPHOME_IMAGE is isolated)
    # and its own compose project, so the images compile in parallel.
    $buildImage = {
        param($image, $label, $projectName, $composeFile, $containerConfigDirectory, $containerConfigPaths)

        $ErrorActionPreference = "Stop"
        $PSNativeCommandUseErrorActionPreference = $false
        # Decode docker output as UTF-8 (the job process otherwise uses the OEM code page and garbles box-drawing characters)
        [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
        $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
        $env:ESPHOME_IMAGE = $image
        # Parallel images must not share the ESPHome/PlatformIO toolchain caches
        $env:ESPHOME_CACHE_SUFFIX = "-$label"
        $stamp = { "[{0:HH:mm:ss.fff}] [{1}]" -f (Get-Date), $label }

        foreach ($containerConfigPath in $containerConfigPaths) {
            "$(& $stamp) Compiling $containerConfigPath with $image"
            # Do not wrap this in script(1) for a pseudo-TTY: util-linux 2.41 script spins at 100% CPU and
            # stops draining its pty, which deadlocks esphome and ninja until the build is killed.
            & docker.exe compose --project-name $projectName --file $composeFile run --pull missing --rm --no-deps -T `
                -e ESPHOME_DATA_DIR=/esphome-data `
                --workdir $containerConfigDirectory esphome esphome compile $containerConfigPath 2>&1 |
                ForEach-Object { "$(& $stamp) $($_ -replace '\r+$', '')" }

            if ($LASTEXITCODE -ne 0) {
                "$(& $stamp) FAILED: $containerConfigPath (exit code $LASTEXITCODE)"
                throw "Compile failed for $containerConfigPath with $image (exit code $LASTEXITCODE)."
            }
        }
        "$(& $stamp) Finished $($containerConfigPaths.Count) configs successfully"
    }

    $jobs = foreach ($image in $images) {
        $label = if ($image -match '^ghcr\.io/esphome/esphome:(.+)$') { $Matches[1] } else { $image }
        $imageProjectName = "$projectName-" + [regex]::Replace($label.ToLowerInvariant(), '[^a-z0-9_-]', '-')
        Start-Job -Name $label -ScriptBlock $buildImage -ArgumentList `
            $image, $label, $imageProjectName, $composeFile, $containerConfigDirectory, $containerConfigPathsByImage[$image]
    }

    # Each image's output is also kept in a temp log, copied to <config dir>/.esphome when the build ends
    $runStamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $tempLogs = @{}
    foreach ($job in $jobs) {
        $tempLogs[$job.Id] = Join-Path ([System.IO.Path]::GetTempPath()) "esphome-build-$runStamp-$($job.Name)-$PID.log"
        [System.IO.File]::WriteAllText($tempLogs[$job.Id], "", $utf8WithoutBom)
    }
    $progress = @{}
    foreach ($job in $jobs) {
        $progress[$job.Id] = @{
            Version = ""; Started = 0; Config = ""; Phase = "Starting"; CompileCount = 0; Warnings = 0; Errors = 0; Elapsed = $null
        }
    }
    $buildStart = [datetime]::Now
    $receiveLogs = {
        foreach ($job in $jobs) {
            $state = $progress[$job.Id]
            $lines = @($job | Receive-Job -ErrorAction SilentlyContinue | ForEach-Object { "$_" })
            foreach ($rawLine in $lines) {
                # Classify on the text without ANSI color codes
                $line = $rawLine -replace "\x1B\[[0-9;]*[A-Za-z]", ''
                if ($line -match '\] Compiling /\S+/(?<name>[^/]+?)\.local-build-[0-9a-f-]+\.ya?ml with ') {
                    $state.Started++
                    $state.Config = $Matches.name
                    $state.Phase = "Starting"
                    $state.CompileCount = 0
                }
                elseif ($line -match '\] INFO ESPHome (?<version>\S+)\s*$') { $state.Version = $Matches.version }
                elseif ($line -match '\] INFO Reading configuration') { $state.Phase = "Reading config" }
                elseif ($line -match '\] INFO Generating C\+\+') { $state.Phase = "Generating C++" }
                elseif ($line -match '\] INFO (Downloading|Installing|Checking) ') { $state.Phase = "Installing toolchain" }
                elseif ($line -match '\[(?<n>\d+)/(?<m>\d+)\] (Building|Linking|Generating)') {
                    $state.Phase = "Building $($Matches.n)/$($Matches.m)"
                }
                elseif ($line -match '\] INFO Compiling app') { $state.Phase = "Preparing build" }
                elseif ($line -match '\] Processing ') { $state.Phase = "Resolving platform" }
                elseif ($line -match '\] (Compiling|Building) \.pioenvs/\S+\.(o|a)\s*$') {
                    # PlatformIO has no total, so show how many objects have compiled so far
                    $state.CompileCount++
                    $state.Phase = "Compiling $($state.CompileCount) files"
                }
                elseif ($line -match '\] (Linking|Building|Creating|Retrieving|Checking) (\.pioenvs|maximum|size|firmware)') { $state.Phase = "Linking" }
                elseif ($line -match '\] INFO Successfully compiled') { $state.Phase = "Compiled" }

                # Compose volume-label notices are not build warnings
                if ($line -notmatch 'level=warning') {
                    if ($line -match '\] WARNING |: warning:') { $state.Warnings++ }
                    elseif ($line -match '\] ERROR |: error:') { $state.Errors++ }
                }
            }
            if ($lines.Count -gt 0) {
                # The saved log is per image, so drop the image tag and dim the timestamp; ESPHome's own colors stay
                $fileLines = [string[]]@($lines | ForEach-Object { $_ -replace "^(\[[^\]]+\]) \[$([regex]::Escape($job.Name))\] ", "$([char]27)[90m`$1$([char]27)[0m " })
                [System.IO.File]::AppendAllLines($tempLogs[$job.Id], $fileLines, $utf8WithoutBom)
            }
            if ($job.State -notin @("NotStarted", "Running") -and -not $progress[$job.Id].Elapsed) {
                $progress[$job.Id].Elapsed = [datetime]::Now - $buildStart
            }
        }
    }

    function Format-Elapsed([timespan]$Elapsed) {
        $minutes = [int][math]::Floor($Elapsed.TotalMinutes)
        if ($minutes -gt 0) { "{0}m {1}s" -f $minutes, $Elapsed.Seconds } else { "{0}s" -f $Elapsed.Seconds }
    }

    # Status table redrawn in place; only the saved logs get the compiler output
    $interactive = -not [Console]::IsOutputRedirected
    $useColor = $interactive -and -not $env:NO_COLOR
    $esc = [char]27
    $paint = {
        param($text, $code)
        if ($useColor -and $code) { "$esc[${code}m$text$esc[0m" } else { $text }
    }
    $box = @{
        H = [string][char]0x2500; V = [string][char]0x2502; Ellipsis = [string][char]0x2026
        TL = [string][char]0x250C; TM = [string][char]0x252C; TR = [string][char]0x2510
        ML = [string][char]0x251C; MM = [string][char]0x253C; MR = [string][char]0x2524
        BL = [string][char]0x2514; BM = [string][char]0x2534; BR = [string][char]0x2518
    }
    $columns = @(
        @{ Title = "Image"; Width = 7 }, @{ Title = "ESPHome"; Width = 14 }, @{ Title = "Config"; Width = 32 },
        @{ Title = "Phase"; Width = 22 }, @{ Title = "Time"; Width = 7 }, @{ Title = "Warn"; Width = 5 },
        @{ Title = "Err"; Width = 4 }, @{ Title = "Result"; Width = 8 }
    )
    $borderLine = {
        param($left, $middle, $right)
        & $paint ($left + (($columns | ForEach-Object { $box.H * ($_.Width + 2) }) -join $middle) + $right) "90"
    }
    $rowLine = {
        param($cells)
        $divider = & $paint $box.V "90"
        $parts = for ($i = 0; $i -lt $columns.Count; $i++) {
            $width = $columns[$i].Width
            $text = [string]$cells[$i].Text
            if ($text.Length -gt $width) { $text = $text.Substring(0, $width - 1) + $box.Ellipsis }
            " " + (& $paint $text.PadRight($width) $cells[$i].Color) + " "
        }
        $divider + ($parts -join $divider) + $divider
    }

    $renderTable = {
        param([bool]$Final)
        $now = [datetime]::Now
        $titles = foreach ($version in $statusVersions) {
            $name = (Get-Culture).TextInfo.ToTitleCase($version)
            $job = $jobs | Where-Object { $_.Name -eq $version }
            if ($job -and $progress[$job.Id].Version) { "$name v$($progress[$job.Id].Version)" }
            elseif ($job) { $name }
            else { "$name None" }
        }
        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add((& $paint "Building ESPHome $($titles -join ', ')" "1;36"))
        # A single short line: a wrapped line would break the cursor-up redraw
        $lines.Add((& $paint "Configs: $($configs.Count)" "90"))
        $lines.Add((& $borderLine $box.TL $box.TM $box.TR))
        $lines.Add((& $rowLine @($columns | ForEach-Object { @{ Text = $_.Title; Color = "1;36" } })))
        $lines.Add((& $borderLine $box.ML $box.MM $box.MR))

        foreach ($version in $statusVersions) {
            $name = (Get-Culture).TextInfo.ToTitleCase($version)
            $job = $jobs | Where-Object { $_.Name -eq $version }
            if (-not $job) {
                $gray = "90"
                $cells = @(
                    @{ Text = $name; Color = $gray }, @{ Text = "-"; Color = $gray }, @{ Text = "Same image as Stable"; Color = $gray },
                    @{ Text = "-"; Color = $gray }, @{ Text = "-"; Color = $gray }, @{ Text = "-"; Color = $gray },
                    @{ Text = "-"; Color = $gray }, @{ Text = "Skipped"; Color = $gray }
                )
            }
            else {
                $state = $progress[$job.Id]
                $finished = [bool]$state.Elapsed
                $ok = $job.State -eq "Completed"
                $statusColor = if (-not $finished) { "33" } elseif ($ok) { "32" } else { "31" }
                $result = if (-not $finished) { "Running" } elseif ($ok) { "Success" } else { "Failed" }
                $phase = if (-not $finished) { $state.Phase } elseif ($ok) { "Finished" } else { "Stopped: $($state.Phase)" }
                $elapsed = if ($finished) { $state.Elapsed } else { $now - $buildStart }
                $configText = if ($state.Config) { "$($state.Started)/$($configs.Count) $($state.Config)" } else { "Waiting" }
                $cells = @(
                    @{ Text = $name; Color = "1" }, @{ Text = $(if ($state.Version) { $state.Version } else { "..." }); Color = $null },
                    @{ Text = $configText; Color = $null }, @{ Text = $phase; Color = $statusColor },
                    @{ Text = (Format-Elapsed $elapsed); Color = $null },
                    @{ Text = $state.Warnings; Color = $(if ($state.Warnings) { "33" } else { "90" }) },
                    @{ Text = $state.Errors; Color = $(if ($state.Errors) { "31" } else { "90" }) },
                    @{ Text = $result; Color = $statusColor }
                )
            }
            $lines.Add((& $rowLine $cells))
        }
        $lines.Add((& $borderLine $box.BL $box.BM $box.BR))

        if ($Final) {
            $totalWarnings = [int](($progress.Values | ForEach-Object { $_.Warnings } | Measure-Object -Sum).Sum)
            $totalErrors = [int](($progress.Values | ForEach-Object { $_.Errors } | Measure-Object -Sum).Sum)
            $allPassed = -not ($jobs | Where-Object { $_.State -ne "Completed" })
            $verdict = if ($allPassed) { & $paint "SUCCESS" "1;32" } else { & $paint "FAILURE" "1;31" }
            $warningText = & $paint "$totalWarnings warnings" $(if ($totalWarnings) { "33" } else { "90" })
            $errorText = & $paint "$totalErrors errors" $(if ($totalErrors) { "31" } else { "90" })
            $lines.Add("$verdict  $warningText, $errorText, $($configs.Count * $jobs.Count) builds in $(Format-Elapsed ($now - $buildStart))")
        }
        $lines
    }

    $drawnLines = 0
    $lastFrame = ""
    $drawTable = {
        param([bool]$Final)
        if (-not $interactive -and -not $Final) { return }
        $lines = @(& $renderTable $Final)
        $frame = $lines -join "`n"
        if ($frame -eq $script:lastFrame) { return }
        $text = if ($interactive) {
            $(if ($script:drawnLines -gt 0) { "$esc[$($script:drawnLines)A" } else { "" }) +
                (($lines | ForEach-Object { "`r$_$esc[K" }) -join "`n") + "`n"
        }
        else {
            ($lines -join "`n") + "`n"
        }
        [Console]::Write($text)
        $script:drawnLines = $lines.Count
        $script:lastFrame = $frame
    }

    try {
        do {
            Start-Sleep -Milliseconds 500
            & $receiveLogs
            & $drawTable $false
        } while ($jobs | Where-Object { $_.State -in @("NotStarted", "Running") })
        & $receiveLogs
        & $drawTable $true
    }
    finally {
        $jobs | Where-Object { $_.State -eq "Running" } | Stop-Job

        $logDirectory = Join-Path $configDirectoryPath ".esphome"
        New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
        # Only the latest run is kept: remove every previous log before writing the new ones
        Get-ChildItem -LiteralPath $logDirectory -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Extension -in @(".log", ".html", ".pdf", ".ansi") -and $_.Name -like "build-*" } |
            Remove-Item -Force
        $logDate = Get-Date -Format "yyyy-MM-dd"
        foreach ($job in $jobs) {
            $logPath = Join-Path $logDirectory "build-$($job.Name)-$logDate.log"

            $logLines = [System.IO.File]::ReadAllLines($tempLogs[$job.Id], $utf8WithoutBom)
            [System.IO.File]::WriteAllLines($logPath, [string[]]$logLines, $utf8WithoutBom)
            Remove-Item -LiteralPath $tempLogs[$job.Id] -Force
            $relativeLogPath = ($logPath.Substring($repoRoot.TrimEnd('\').Length).TrimStart('\')) -replace '\\', '/'
            Write-Host "Log saved to $relativeLogPath"
        }
    }

    $failedJobs = @($jobs | Where-Object { $_.State -ne "Completed" })
    $jobs | Remove-Job -Force
    if ($failedJobs.Count -gt 0) {
        throw "Compile failed for: $($failedJobs.Name -join ', ')."
    }
}
finally {
    # Remove the staged configs and the .gitignore ESPHome writes next to them
    if ($stagedConfigDirectory -and (Test-Path -LiteralPath $stagedConfigDirectory)) {
        Remove-Item -LiteralPath $stagedConfigDirectory -Recurse -Force -ErrorAction SilentlyContinue
    }
}
