$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Cyan
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   Cyberpunk PowerShell Terminal - Safe Update     ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# Verificar se estamos em um repositório Git
if (-not (Test-Path -LiteralPath (Join-Path $repoRoot '.git'))) {
    Write-Error-Custom "Não estou em um repositório Git válido."
    Write-Info "Execute este script dentro da pasta 'cyberpunk-pwsh-terminal'."
    exit 1
}

# Verificar conexão com GitHub
Write-Info "Verificando conexão com GitHub..."
try {
    $null = Invoke-WebRequest -Uri "https://github.com" -TimeoutSec 5 -ErrorAction Stop
    Write-Success "Conexão estabelecida"
} catch {
    Write-Error-Custom "Sem conexão com a internet ou GitHub inacessível."
    exit 1
}

# Verificar se há mudanças locais não commitadas
Write-Info "Verificando status do repositório..."
$gitStatus = & git status --porcelain
if ($gitStatus) {
    Write-Warning-Custom "Você tem mudanças locais não commitadas."
    Write-Host ""
    Write-Host "Mudanças detectadas:" -ForegroundColor Yellow
    $gitStatus | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
    Write-Host ""
    Write-Warning-Custom "Commit ou descarte as mudanças antes de atualizar."
    Write-Info "Comandos úteis:"
    Write-Host "  git status              # Ver mudanças"
    Write-Host "  git add .               # Preparar mudanças"
    Write-Host "  git commit -m 'msg'     # Fazer commit"
    Write-Host "  git checkout .          # Descartar mudanças (CUIDADO!)"
    exit 1
}

Write-Success "Repositório limpo"

# Fazer pull seguro
Write-Info "Atualizando repositório de 'develop'..."
try {
    $pullOutput = & git pull origin develop 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao fazer pull"
    }
    Write-Success "Repositório atualizado"
} catch {
    Write-Error-Custom "Falha ao fazer pull de 'develop'."
    Write-Host $pullOutput -ForegroundColor Red
    Write-Info "Verifique sua conexão ou conflitos de merge."
    exit 1
}

# Rodar diagnóstico
Write-Info "Rodando diagnóstico de integridade..."
try {
    & pwsh -NoLogo -NoProfile -File (Join-Path $repoRoot 'scripts\check.ps1') | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Diagnóstico falhou"
    }
    Write-Success "Diagnóstico passou"
} catch {
    Write-Error-Custom "Diagnóstico de integridade falhou."
    Write-Info "Execute manualmente: .\scripts\check.ps1"
    exit 1
}

# Reinstalar profile com backup
Write-Info "Atualizando profile do PowerShell..."
try {
    & pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'install.ps1') | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Instalação falhou"
    }
    Write-Success "Profile atualizado com backup seguro"
} catch {
    Write-Error-Custom "Falha ao atualizar o profile."
    Write-Info "Revise o output acima ou execute: .\install.ps1"
    exit 1
}

# Verificar versão
$version = & git describe --tags --abbrev=0 2>$null
if ($version) {
    Write-Success "Versão instalada: $version"
} else {
    Write-Info "Sem tag de versão encontrada"
}

Write-Host ""
Write-Success "Atualização concluída com sucesso!"
Write-Host ""
Write-Info "Próximos passos:"
Write-Host "  1. Recarregue seu PowerShell: . `$PROFILE"
Write-Host "  2. Teste o novo perfil: ls"
Write-Host "  3. Verifique o histórico: hist -Last 5"
Write-Host ""
Write-Info "Se algo não funcionar, verifique:"
Write-Host "  • Documentação: .\docs\GETTING_STARTED.md"
Write-Host "  • Troubleshooting: .\docs\TROUBLESHOOTING.md"
Write-Host "  • Backup: .\docs\BACKUP_RESTORE.md"
Write-Host ""
