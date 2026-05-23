[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Force,
    [switch]$RemoveTheme,
    [switch]$RemoveData
)

$ErrorActionPreference = 'Stop'

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

$targetProfile = $PROFILE.CurrentUserCurrentHost
if (-not $targetProfile) { $targetProfile = [string]$PROFILE }
$targetProfileDir = Split-Path -Parent $targetProfile
$targetTheme = Join-Path $targetProfileDir 'themes\cyberpunk-clean.omp.json'
$targetDataDir = Join-Path $targetProfileDir 'data'

if (-not (Test-Path -LiteralPath $targetProfile)) {
    Write-Host "No profile found at $targetProfile"
    return
}

$content = Get-Content -LiteralPath $targetProfile -Raw
$markerFound = $content -match 'PowerShell profile - Cyberpunk clean|PowerShell 7 profile - Cyberpunk clean'

if (-not $markerFound -and -not $Force) {
    throw "The profile does not look like the Cyberpunk profile. Use -Force only if you are sure."
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = "$targetProfile.backup-before-uninstall-$stamp"
Write-Step "Backing up profile before uninstall"
Copy-Item -LiteralPath $targetProfile -Destination $backup -Force
Write-Host "Backup: $backup"

if ($PSCmdlet.ShouldProcess($targetProfile, 'Remove PowerShell profile')) {
    Remove-Item -LiteralPath $targetProfile -Force
}

if ($RemoveTheme -and (Test-Path -LiteralPath $targetTheme)) {
    if ($PSCmdlet.ShouldProcess($targetTheme, 'Remove oh-my-posh theme')) {
        Remove-Item -LiteralPath $targetTheme -Force
    }
}

if ($RemoveData -and (Test-Path -LiteralPath $targetDataDir)) {
    if ($PSCmdlet.ShouldProcess($targetDataDir, 'Remove Cyberpunk rule data')) {
        Remove-Item -LiteralPath $targetDataDir -Recurse -Force
    }
}

Write-Step "Uninstall complete"
Write-Host "Windows Terminal settings were not changed by this script. Remove the profile/scheme manually if you added them."
