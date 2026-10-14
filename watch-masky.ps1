#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$StencilDir,
    [string]$OutputJs,
    [switch]$SkipWatch
)

$ErrorActionPreference = "Stop"

function ConvertTo-JsString {
    param([string]$Value)

    if ($null -eq $Value) {
        return '""'
    }

    $escaped = $Value
    $escaped = $escaped.Replace('\\', '\\\\')
    $escaped = $escaped.Replace('"', '\\"')
    $escaped = $escaped.Replace("`r", '\\r')
    $escaped = $escaped.Replace("`n", '\\n')
    $escaped = $escaped.Replace("`t", '\\t')

    return '"' + $escaped + '"'
}

function Get-DefaultStencilDir {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $repoStencilDir = Join-Path $scriptDir 'stencils'

    if (Test-Path -LiteralPath $repoStencilDir) {
        return $repoStencilDir
    }

    return Join-Path $env:APPDATA 'spicetify\Extensions\masky-stencils'
}

function Get-DefaultOutputJs {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $repoStencilDir = Join-Path $scriptDir 'stencils'

    if (Test-Path -LiteralPath $repoStencilDir) {
        return Join-Path $scriptDir 'masky-masks.js'
    }

    return Join-Path $env:APPDATA 'spicetify\Extensions\masky-masks.js'
}

if (-not $StencilDir) {
    $StencilDir = Get-DefaultStencilDir
}

if (-not $OutputJs) {
    $OutputJs = Get-DefaultOutputJs
}

$stencilParent = Split-Path -Parent $StencilDir
if ($stencilParent) {
    New-Item -ItemType Directory -Path $StencilDir -Force | Out-Null
}

$outputParent = Split-Path -Parent $OutputJs
if ($outputParent) {
    New-Item -ItemType Directory -Path $outputParent -Force | Out-Null
}

function Build-Masks {
    $files = Get-ChildItem -LiteralPath $StencilDir -Filter *.png -File | Sort-Object Name
    $entries = @()

    foreach ($f in $files) {
        $name = $f.BaseName
        $artist = 'uncredited'
        $source = '—'

        if ($name -match '\(([^)]+)\)$') {
            $credit = $matches[1]
            if ($credit -match '^(.+?)\s+(?:on\s+)?(tumblr|twitter|instagram|github)$') {
                $artist = $matches[1].Trim()
                $source = $matches[2]
            }
            elseif ($credit -match '^creds\s+(.+?)\s+on\s+tumblr$') {
                $artist = $matches[1].Trim()
                $source = 'Tumblr'
            }
            else {
                $artist = $credit
                $source = 'Tumblr'
            }
        }

        $displayName = $name -replace '\s*\([^)]+\)$', ''
        $id = ($displayName -replace '[^a-zA-Z0-9]+', '-').Trim('-').ToLower()
        $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($f.FullName))

        $entry = '{ id: ' + (ConvertTo-JsString $id) + ', name: ' + (ConvertTo-JsString $displayName) + ', url: ' + (ConvertTo-JsString "data:image/png;base64,$b64") + ', artist: ' + (ConvertTo-JsString $artist) + ', source: ' + (ConvertTo-JsString $source) + ' }'
        $entries += $entry
    }

    if ($entries.Count -eq 0) {
        $js = 'window.MASKY_MASKS = [];'
    }
    else {
        $js = 'window.MASKY_MASKS = [' + "`n" + ($entries -join ',`n') + "`n];`n"
    }

    Set-Content -LiteralPath $OutputJs -Value $js -Encoding UTF8
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Built $OutputJs with $($files.Count) mask(s)"
}

Build-Masks

if ($SkipWatch) {
    exit 0
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $StencilDir
$watcher.Filter = '*.png'
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$debounce = @{}
$subscriptions = @()

$action = {
    $name = $Event.SourceEventArgs.Name
    $key = $name.ToLowerInvariant()

    if (-not $debounce.ContainsKey($key)) {
        $debounce[$key] = $true
        Start-Sleep -Milliseconds 500
        Build-Masks
        $debounce.Remove($key)
    }
}

$subscriptions += Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action
$subscriptions += Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $action
$subscriptions += Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $action

Write-Host "Watching $StencilDir for PNG changes... (Ctrl+C to stop)"
Write-Host 'Drop PNG files in the folder to auto-update masky-masks.js'

try {
    while ($true) { Start-Sleep -Seconds 10 }
}
finally {
    foreach ($subscription in $subscriptions) {
        Unregister-Event -SubscriptionId $subscription.Id -ErrorAction SilentlyContinue
    }

    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
}
