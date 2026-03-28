<#
.SYNOPSIS
    Installs VS Code Dark+ color theme into Quartus II text editor.
.DESCRIPTION
    Reads theme entries from quartus2_vscode_dark_theme.ini and applies them
    to %USERPROFILE%\quartus2.qreg. Automatically detects all version sections
    (e.g. [13.1], [14.1]) and installs to every one. Safe to run multiple times.
.PARAMETER QregPath
    Path to quartus2.qreg. Defaults to %USERPROFILE%\quartus2.qreg.
.EXAMPLE
    .\install_dark_theme.ps1
#>
param(
    [string]$QregPath = (Join-Path $env:USERPROFILE "quartus2.qreg")
)

$ErrorActionPreference = "Stop"

# --- Read theme entries from .ini file ---
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$themeFile = Join-Path $scriptDir "quartus2_vscode_dark_theme.ini"

if (-not (Test-Path $themeFile)) {
    Write-Host "ERROR: Theme file not found: $themeFile" -ForegroundColor Red
    exit 1
}

$themeEntries = @(Get-Content $themeFile | Where-Object {
    $_.Trim() -ne '' -and $_ -notmatch '^\s*;;'
})

if ($themeEntries.Count -eq 0) {
    Write-Host "ERROR: No theme entries found in $themeFile" -ForegroundColor Red
    exit 1
}

# --- Font fallback: Cascadia Code -> Consolas ---
Add-Type -AssemblyName System.Drawing
$hasCascadiaCode = [System.Drawing.FontFamily]::Families.Name -contains "Cascadia Code"
if (-not $hasCascadiaCode) {
    Write-Host "Cascadia Code not found, using Consolas." -ForegroundColor Yellow
    $themeEntries = @($themeEntries | ForEach-Object { $_ -replace 'Cascadia Code', 'Consolas' })
} else {
    Write-Host "Font: Cascadia Code" -ForegroundColor Cyan
}

# --- Validate qreg ---
if (-not (Test-Path $QregPath)) {
    Write-Host "ERROR: $QregPath not found." -ForegroundColor Red
    Write-Host "Please run Quartus II at least once to generate quartus2.qreg."
    exit 1
}

# --- Warn if Quartus is running ---
if (Get-Process -Name "quartus*" -ErrorAction SilentlyContinue) {
    Write-Host "WARNING: Quartus II appears to be running. Close it for changes to take effect." -ForegroundColor Yellow
}

# --- Backup ---
$backupPath = "$QregPath.bak"
Copy-Item $QregPath $backupPath -Force
Write-Host "Backup: $backupPath" -ForegroundColor Cyan

# --- Read qreg and remove old AFCQ_TED_ entries ---
$lines = @([System.IO.File]::ReadAllLines($QregPath))
$filtered = @($lines | Where-Object { $_ -notmatch 'AFCQ_TED_' -and $_ -notmatch 'Font_version=' -and $_ -notmatch 'Color_version=' })

# --- Find all version sections and their end points ---
# Insert at the end of each version section (before the next section header)
$insertPoints = [System.Collections.Generic.List[int]]::new()
$currentSectionIsVersion = $false
$sectionEndIdx = -1

for ($i = 0; $i -lt $filtered.Count; $i++) {
    $trimmed = $filtered[$i].Trim()

    if ($trimmed -match '^\[') {
        # Save previous version section's end point
        if ($currentSectionIsVersion) {
            $insertPoints.Add($sectionEndIdx + 1)
        }
        $currentSectionIsVersion = ($trimmed -match '^\[\d+\.\d+\]$')
        $sectionEndIdx = $i
        continue
    }

    if ($currentSectionIsVersion -and $trimmed -ne '') {
        $sectionEndIdx = $i
    }
}

# Handle last section in file
if ($currentSectionIsVersion) {
    $insertPoints.Add($sectionEndIdx + 1)
}

if ($insertPoints.Count -eq 0) {
    Write-Host "ERROR: No version sections (e.g. [13.1]) found in $QregPath" -ForegroundColor Red
    exit 1
}

# --- Insert theme entries into all sections (reverse order to preserve indices) ---
$output = [System.Collections.Generic.List[string]]::new([string[]]$filtered)
$insertPoints.Sort()

for ($j = $insertPoints.Count - 1; $j -ge 0; $j--) {
    $output.InsertRange($insertPoints[$j], [string[]]$themeEntries)
}

[System.IO.File]::WriteAllLines($QregPath, $output.ToArray())

# --- Report ---
$sections = @($filtered | Where-Object { $_ -match '^\[\d+\.\d+\]$' }) -replace '[\[\]]', ''
Write-Host "Done! Installed $($themeEntries.Count) theme entries into $($insertPoints.Count) section(s): $($sections -join ', ')" -ForegroundColor Green
Write-Host "Restart Quartus II to apply the dark theme."
