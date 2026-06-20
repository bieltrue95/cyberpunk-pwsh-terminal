[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$TargetProfilePath
)

$ErrorActionPreference = 'Stop'

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Check {
    param([string]$Message, [bool]$Passed)
    $icon = if ($Passed) { "✅" } else { "❌" }
    $color = if ($Passed) { "Green" } else { "Red" }
    Write-Host "$icon $Message" -ForegroundColor $color
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   Cyberpunk Terminal - Uninstall Checklist       ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

$targetProfile = if ($TargetProfilePath) { $TargetProfilePath } else { $PROFILE.CurrentUserCurrentHost }
if (-not $targetProfile) { $targetProfile = [string]$PROFILE }
$targetProfileDir = Split-Path -Parent $targetProfile
$targetThemeDir = Join-Path $targetProfileDir 'themes'
$targetTheme = Join-Path $targetThemeDir 'cyberpunk-clean.omp.json'
$targetDataDir = Join-Path $targetProfileDir 'data'

$checks = @{
    'Profile removido' = $false
    'Tema removido' = $false
    'Dados removidos' = $false
    'Histórico limpo' = $false
    'Notificação de atualização limpa' = $false
}

Write-Step "Iniciando desinstalação..."
Write-Host ""

# 1. Verificar profile
Write-Info "Verificando profile..."
$profileExists = Test-Path -LiteralPath $targetProfile
Write-Check "Profile encontrado: $targetProfile" $profileExists

if ($profileExists) {
    $profileContent = Get-Content -LiteralPath $targetProfile -Raw -ErrorAction SilentlyContinue
    $isCyberpunk = $profileContent -match 'PowerShell profile - Cyberpunk clean|PowerShell 7 profile - Cyberpunk clean'
    Write-Check "É um profile Cyberpunk válido" $isCyberpunk
} else {
    Write-Check "É um profile Cyberpunk válido" $false
}

# 2. Verificar tema
Write-Host ""
Write-Info "Verificando tema..."
$themeExists = Test-Path -LiteralPath $targetTheme
Write-Check "Tema encontrado: $targetTheme" $themeExists

# 3. Verificar dados
Write-Host ""
Write-Info "Verificando dados..."
$dataExists = Test-Path -LiteralPath $targetDataDir
Write-Check "Diretório de dados encontrado: $targetDataDir" $dataExists

# 4. Verificar histórico
Write-Host ""
Write-Info "Verificando histórico..."
$historyFile = Join-Path $targetProfileDir '.pwsh_history'
$historyExists = Test-Path -LiteralPath $historyFile
Write-Check "Histórico encontrado: $historyFile" $historyExists

# 5. Verificar arquivos de notificação
Write-Host ""
Write-Info "Verificando arquivos temporários..."
$updateCheckFile = Join-Path $env:TEMP 'cyberpunk-last-update-check.txt'
$notificationFile = Join-Path $env:TEMP 'cyberpunk-notification-date.txt'
$updateCheckExists = Test-Path -LiteralPath $updateCheckFile
$notificationExists = Test-Path -LiteralPath $notificationFile
Write-Check "Arquivo de verificação de atualização: $updateCheckFile" $updateCheckExists
Write-Check "Arquivo de notificação: $notificationFile" $notificationExists

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""

# Resumo pré-desinstalação
$itemsToRemove = @()
if ($profileExists) { $itemsToRemove += "Profile: $targetProfile" }
if ($themeExists) { $itemsToRemove += "Tema: $targetTheme" }
if ($dataExists) { $itemsToRemove += "Dados: $targetDataDir" }
if ($historyExists) { $itemsToRemove += "Histórico: $historyFile" }
if ($updateCheckExists) { $itemsToRemove += "Arquivo de atualização: $updateCheckFile" }
if ($notificationExists) { $itemsToRemove += "Arquivo de notificação: $notificationFile" }

if ($itemsToRemove.Count -eq 0) {
    Write-Host "Nenhum arquivo Cyberpunk encontrado para remover." -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

Write-Host "Itens a serem removidos:" -ForegroundColor Yellow
$itemsToRemove | ForEach-Object { Write-Host "  • $_" -ForegroundColor Yellow }
Write-Host ""

$confirm = Read-Host "Deseja prosseguir com a desinstalação? (s/N)"
if ($confirm -ne 's' -and $confirm -ne 'S') {
    Write-Host "Desinstalação cancelada." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Step "Executando desinstalação..."

# Backup antes de remover
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupDir = Join-Path $targetProfileDir "cyberpunk-backup-$stamp"

if ($profileExists) {
    Write-Host "Fazendo backup..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

    if ($PSCmdlet.ShouldProcess($targetProfile, 'Backup do profile')) {
        Copy-Item -LiteralPath $targetProfile -Destination (Join-Path $backupDir 'profile.ps1') -Force
        $checks['Profile removido'] = $false
    }
}

# Remover profile
if ($profileExists) {
    if ($PSCmdlet.ShouldProcess($targetProfile, 'Remove profile')) {
        Remove-Item -LiteralPath $targetProfile -Force -ErrorAction SilentlyContinue
        $checks['Profile removido'] = -not (Test-Path -LiteralPath $targetProfile)
    }
}

# Remover tema
if ($themeExists) {
    if ($PSCmdlet.ShouldProcess($targetTheme, 'Remove theme')) {
        Remove-Item -LiteralPath $targetTheme -Force -ErrorAction SilentlyContinue
        $checks['Tema removido'] = -not (Test-Path -LiteralPath $targetTheme)
    }
}

# Remover dados
if ($dataExists) {
    if ($PSCmdlet.ShouldProcess($targetDataDir, 'Remove data directory')) {
        Remove-Item -LiteralPath $targetDataDir -Recurse -Force -ErrorAction SilentlyContinue
        $checks['Dados removidos'] = -not (Test-Path -LiteralPath $targetDataDir)
    }
}

# Remover histórico
if ($historyExists) {
    if ($PSCmdlet.ShouldProcess($historyFile, 'Remove history')) {
        Remove-Item -LiteralPath $historyFile -Force -ErrorAction SilentlyContinue
        $checks['Histórico limpo'] = -not (Test-Path -LiteralPath $historyFile)
    }
}

# Remover arquivos temporários
if ($updateCheckExists) {
    Remove-Item -LiteralPath $updateCheckFile -Force -ErrorAction SilentlyContinue
}
if ($notificationExists) {
    Remove-Item -LiteralPath $notificationFile -Force -ErrorAction SilentlyContinue
}
$checks['Notificação de atualização limpa'] = $true

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""

# Checklist final
Write-Step "Checklist de desinstalação"
Write-Host ""
$checks.GetEnumerator() | ForEach-Object {
    Write-Check $_.Key $_.Value
}

Write-Host ""
$allPassed = $checks.Values | Where-Object { $_ -eq $false } | Measure-Object | Select-Object -ExpandProperty Count
if ($allPassed -eq 0) {
    Write-Host "✅ Desinstalação concluída com sucesso!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Alguns itens não foram removidos. Verifique manualmente." -ForegroundColor Yellow
}

Write-Host ""
Write-Info "Backup salvo em: $backupDir"
Write-Info "Para restaurar, crie um novo terminal sem profile e execute:"
Write-Host "  Copy-Item -Path '$backupDir\profile.ps1' -Destination '$targetProfile' -Force"
Write-Host ""
