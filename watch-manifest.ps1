<#
.SYNOPSIS
    Auto-updates masky-stencils/manifest.json when PNGs are added/removed.
    Run once, leave it running in background (or add to startup).
#>

$ErrorActionPreference = "Stop"

$stencilsDir = "$env:APPDATA\spicetify\Extensions\masky-stencils"
$manifestPath = Join-Path $stencilsDir "manifest.json"

function Update-Manifest {
    $files = Get-ChildItem -LiteralPath $stencilsDir -Filter *.png | Sort-Object Name
    $stencils = foreach ($f in $files) {
        $base = $f.BaseName
        $artist = "uncredited"
        $source = "—"
        if ($base -match '\(([^)]+)\)$') {
            $credit = $matches[1]
            if ($credit -match '^(.+?)\s+(?:on\s+)?(tumblr|twitter|instagram|github)$') {
                $artist = $matches[1].Trim()
                $source = $matches[2]
            } elseif ($credit -match '^creds\s+(.+?)\s+on\s+tumblr$') {
                $artist = $matches[1].Trim()
                $source = "Tumblr"
            } else {
                $artist = $credit
                $source = "Tumblr"
            }
        }
        $name = $base -replace '\s*\([^)]+\)$', ''
        @{
            id     = ($name -replace '[^a-zA-Z0-9]+', '-').Trim('-').ToLower()
            name   = $name
            file   = $f.Name
            artist = $artist
            source = $source
        }
    }
    $manifest = @{
        version = 1
        stencils = $stencils
    }
    $manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Manifest updated: $($stencils.Count) stencils"
}

# Initial build
Update-Manifest

# Watch for changes
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $stencilsDir
$watcher.Filter = "*.png"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$debounce = @{}
Register-ObjectEvent -InputObject $watcher -EventName Created -Action {
    $name = $Event.SourceEventArgs.Name
    $key = $name.ToLower()
    if (-not $debounce.ContainsKey($key)) {
        $debounce[$key] = $true
        Start-Sleep -Milliseconds 500
        Update-Manifest
        $debounce.Remove($key)
    }
} | Out-Null

Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action {
    $name = $Event.SourceEventArgs.Name
    $key = $name.ToLower()
    if (-not $debounce.ContainsKey($key)) {
        $debounce[$key] = $true
        Start-Sleep -Milliseconds 500
        Update-Manifest
        $debounce.Remove($key)
    }
} | Out-Null

Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action {
    $name = $Event.SourceEventArgs.Name
    $key = $name.ToLower()
    if (-not $debounce.ContainsKey($key)) {
        $debounce[$key] = $true
        Start-Sleep -Milliseconds 500
        Update-Manifest
        $debounce.Remove($key)
    }
} | Out-Null

Write-Host "Watching $stencilsDir for PNG changes... (Ctrl+C to stop)"
Write-Host "Drop PNG files in the folder to auto-update manifest.json"
try {
    while ($true) { Start-Sleep -Seconds 10 }
} finally {
    Unregister-Event -SourceIdentifier "Created" -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier "Deleted" -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier "Renamed" -ErrorAction SilentlyContinue
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
}