[CmdletBinding()]
param(
    [switch]$Silent,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

$repoRoot = if ($env:CYBERPUNK_REPO_ROOT) { $env:CYBERPUNK_REPO_ROOT } else { Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path) }
$versionFile = Join-Path $repoRoot 'VERSION'
$updateCheckFile = Join-Path $env:TEMP 'cyberpunk-last-update-check.txt'
$lastNotificationFile = Join-Path $env:TEMP 'cyberpunk-notification-date.txt'

if (-not (Test-Path -LiteralPath $versionFile)) {
    if (-not $Silent) {
        Write-Error-Custom "VERSION file not found at $versionFile"
    }
    return @{ UpdateAvailable = $false; Error = $true }
}

$currentVersion = Get-Content -LiteralPath $versionFile -Raw | ForEach-Object { $_.Trim() }

if (-not $currentVersion) {
    if (-not $Silent) {
        Write-Error-Custom "VERSION file is empty"
    }
    return @{ UpdateAvailable = $false; Error = $true }
}

# Verificar conexão
if (-not $Silent) {
    Write-Info "Verificando conexão com GitHub..."
}

try {
    $null = Invoke-WebRequest -Uri "https://api.github.com" -TimeoutSec 5 -ErrorAction Stop
} catch {
    if (-not $Silent) {
        Write-Warning-Custom "Sem conexão com internet. Verificação de atualização abortada."
    }
    return @{ UpdateAvailable = $false; Error = $true; Reason = "NoInternet" }
}

# Obter versão remota do GitHub
if (-not $Silent) {
    Write-Info "Buscando versão disponível no GitHub..."
}

try {
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/bieltrue95/cyberpunk-pwsh-terminal/releases/latest" -TimeoutSec 10 -ErrorAction Stop
    $remoteVersion = $release.tag_name -replace '^v', ''
} catch {
    if (-not $Silent) {
        Write-Warning-Custom "Falha ao verificar versão remota: $_"
    }
    return @{ UpdateAvailable = $false; Error = $true; Reason = "APIError" }
}

if (-not $remoteVersion) {
    if (-not $Silent) {
        Write-Warning-Custom "Não foi possível determinar a versão remota"
    }
    return @{ UpdateAvailable = $false; Error = $true; Reason = "NoVersion" }
}

# Comparar versões
$current = [version]$currentVersion
$remote = [version]$remoteVersion

$updateAvailable = $remote -gt $current

# Salvar último check
@{
    LastCheck = Get-Date -Format 'o'
    CurrentVersion = $currentVersion
    RemoteVersion = $remoteVersion
    UpdateAvailable = $updateAvailable
} | ConvertTo-Json | Set-Content -LiteralPath $updateCheckFile -Force

if ($updateAvailable) {
    if (-not $Silent) {
        Write-Success "Nova atualização disponível: v$currentVersion → v$remoteVersion"
    }
    return @{
        UpdateAvailable = $true
        CurrentVersion = $currentVersion
        RemoteVersion = $remoteVersion
        ChangelogUrl = "https://github.com/bieltrue95/cyberpunk-pwsh-terminal/releases/tag/v$remoteVersion"
    }
} else {
    if (-not $Silent) {
        Write-Success "Você está na versão mais recente (v$currentVersion)"
    }
    return @{ UpdateAvailable = $false; CurrentVersion = $currentVersion }
}
