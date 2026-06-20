[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Force,
    [switch]$RemoveTheme,
    [switch]$RemoveData,
    [switch]$WithChecklist,
    [string]$TargetProfilePath
)

$ErrorActionPreference = 'Stop'

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

# Se usar -WithChecklist, roda o script de checklist detalhado
if ($WithChecklist) {
    $repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
    $checklistScript = Join-Path $repoRoot 'scripts\uninstall-checklist.ps1'
    if (Test-Path -LiteralPath $checklistScript) {
        & pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File $checklistScript -TargetProfilePath $TargetProfilePath
        return
    }
}

$targetProfile = if ($TargetProfilePath) { $TargetProfilePath } else { $PROFILE.CurrentUserCurrentHost }
if (-not $targetProfile) { $targetProfile = [string]$PROFILE }
$targetProfileDir = Split-Path -Parent $targetProfile
$targetTheme = Join-Path $targetProfileDir 'themes\cyberpunk-clean.omp.json'
$targetDataDir = Join-Path $targetProfileDir 'data'

if (-not (Test-Path -LiteralPath $targetProfile)) {
    Write-Host "Nenhum profile encontrado em $targetProfile"
    return
}

$content = Get-Content -LiteralPath $targetProfile -Raw
$markerFound = $content -match 'PowerShell profile - Cyberpunk clean|PowerShell 7 profile - Cyberpunk clean'

if (-not $markerFound -and -not $Force) {
    throw "O profile não parece ser um profile Cyberpunk. Use -Force apenas se tem certeza."
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = "$targetProfile.backup-before-uninstall-$stamp"
Write-Step "Fazendo backup do profile antes de desinstalar"
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

# Remover arquivos temporários de notificação
$updateCheckFile = Join-Path $env:TEMP 'cyberpunk-last-update-check.txt'
$notificationFile = Join-Path $env:TEMP 'cyberpunk-notification-date.txt'
if (Test-Path -LiteralPath $updateCheckFile) {
    Remove-Item -LiteralPath $updateCheckFile -Force -ErrorAction SilentlyContinue
}
if (Test-Path -LiteralPath $notificationFile) {
    Remove-Item -LiteralPath $notificationFile -Force -ErrorAction SilentlyContinue
}

Write-Step "Desinstalação concluída"
Write-Host "ℹ️  Configurações do Windows Terminal não foram alteradas por este script. Remova o profile/scheme manualmente se adicionou."
Write-Host ""
Write-Host "Para um checklist completo de desinstalação, execute:"
Write-Host "  .\uninstall.ps1 -WithChecklist"
