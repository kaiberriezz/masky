#requires -Version 5.1
$ErrorActionPreference = "Stop"

$stencilsDir = "$env:APPDATA\spicetify\Extensions\masky-stencils"
$outputJs = "$env:APPDATA\spicetify\Extensions\masky-masks.js"

function Build-Masks {
    $files = Get-ChildItem -LiteralPath $stencilsDir -Filter *.png | Sort-Object Name
    $entries = @()
    foreach ($f in $files) {
        $name = $f.BaseName
        $artist = "uncredited"
        $source = "-"
        if ($name -match '\(([^)]+)\)$') {
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
        $displayName = $name -replace '\s*\([^)]+\)$', ''
        $id = ($displayName -replace '[^a-zA-Z0-9]+', '-').Trim('-').ToLower()
        $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($f.FullName))
        $entry = '  { id: "' + $id + '", name: "' + $displayName + '", url: "data:image/png;base64,' + $b64 + '", artist: "' + $artist + '", source: "' + $source + '" }'
        $entries += $entry
    }
    $js = "window.MASKY_MASKS = [`n" + ($entries -join ",`n") + "`n];`n"
    Set-Content -LiteralPath $outputJs -Value $js -Encoding UTF8
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Built $outputJs with $($files.Count) mask(s)"
}

# Initial build
Build-Masks

# Watch for changes
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $stencilsDir
$watcher.Filter = "*.png"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$debounce = @{}
$action = {
    $name = $Event.SourceEventArgs.Name
    $key = $name.ToLower()
    if (-not $debounce.ContainsKey($key)) {
        $debounce[$key] = $true
        Start-Sleep -Milliseconds 500
        Build-Masks
        $debounce.Remove($key)
    }
}
Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $action | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $action | Out-Null

Write-Host "Watching $stencilsDir for PNG changes... (Ctrl+C to stop)"
Write-Host "Drop PNG files in the folder to auto-update masky-masks.js"
try {
    while ($true) { Start-Sleep -Seconds 10 }
} finally {
    Unregister-Event -SourceIdentifier "Created" -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier "Deleted" -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier "Renamed" -ErrorAction SilentlyContinue
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
}