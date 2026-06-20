<#
    Script de verificação pós-desinstalação.

    Valida se a desinstalação foi bem-sucedida verificando a remoção de todos
    os componentes Cyberpunk Terminal.

    Uso:
        .\scripts\test-uninstall-verify.ps1
#>

$ErrorActionPreference = 'SilentlyContinue'

function Test-Item {
    param([string]$Path, [string]$Description, [bool]$ShouldExist = $false)

    $exists = Test-Path -LiteralPath $Path
    $status = if ($ShouldExist) {
        if ($exists) { "✅" } else { "❌" }
    } else {
        if (-not $exists) { "✅" } else { "❌" }
    }

    Write-Host "$status $Description"
    return if ($ShouldExist) { $exists } else { -not $exists }
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   Cyberpunk Terminal - Verification Tests         ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

$profilePath = $PROFILE
$profileDir = Split-Path -Parent $profilePath
$themeDir = Join-Path $profileDir 'themes'
$dataDir = Join-Path $profileDir 'data'

Write-Host "1. Verificando remoção de componentes principais..." -ForegroundColor Cyan
Write-Host ""

$checks = @(
    (Test-Item -Path $profilePath -Description "Profile Cyberpunk removido" -ShouldExist $false),
    (Test-Item -Path $themeDir -Description "Diretório de temas removido" -ShouldExist $false),
    (Test-Item -Path $dataDir -Description "Diretório de dados removido" -ShouldExist $false)
)

Write-Host ""
Write-Host "2. Verificando limpeza de arquivos temporários..." -ForegroundColor Cyan
Write-Host ""

$tempChecks = @(
    (Test-Item -Path (Join-Path $env:TEMP 'cyberpunk-last-update-check.txt') -Description "Arquivo de verificação de atualização removido" -ShouldExist $false),
    (Test-Item -Path (Join-Path $env:TEMP 'cyberpunk-notification-date.txt') -Description "Arquivo de notificação removido" -ShouldExist $false)
)

Write-Host ""
Write-Host "3. Verificando integridade do PowerShell..." -ForegroundColor Cyan
Write-Host ""

# Testar se consegue carregar um novo profile
$defaultProfile = if (Test-Path (Join-Path $profileDir 'Microsoft.PowerShell_profile.ps1')) {
    Get-Content (Join-Path $profileDir 'Microsoft.PowerShell_profile.ps1') -Raw
} else {
    $null
}

$hasCyberpunkMarkers = $defaultProfile -match 'Cyberpunk|Check-CyberUpdate|update-check'

Write-Host $(if (-not $hasCyberpunkMarkers) { "✅" } else { "❌" }) "Nenhuma referência Cyberpunk no novo profile"

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""

# Resumo
$allChecks = $checks + $tempChecks
$passed = ($allChecks | Where-Object { $_ } | Measure-Object).Count
$total = $allChecks.Count

Write-Host "Resultados:" -ForegroundColor Yellow
Write-Host "  ✅ Passou: $passed/$total"

if ($passed -eq $total) {
    Write-Host ""
    Write-Host "🎉 Desinstalação validada com sucesso!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "  ❌ Falhou: $($total - $passed)/$total"
    Write-Host ""
    Write-Host "⚠️  Alguns componentes ainda estão presentes." -ForegroundColor Yellow
    Write-Host "Execute .\uninstall.ps1 -WithChecklist para mais detalhes." -ForegroundColor Yellow
    exit 1
}
