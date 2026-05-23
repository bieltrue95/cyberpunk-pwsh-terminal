[CmdletBinding()]
param(
    [switch]$InstallDependencies,
    [switch]$InstallOhMyPosh,
    [switch]$ConfigureWindowsTerminal,
    [switch]$SkipDiagnostics,
    [switch]$NonInteractive,
    [switch]$Yes,
    [string]$TerminalSettingsPath
)

$ErrorActionPreference = 'Stop'

function Write-Title {
    param([string]$Message)
    Write-Host ""
    Write-Host "=== $Message ===" -ForegroundColor Magenta
}

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Message)
    Write-Host "OK: $Message" -ForegroundColor Green
}

function Write-WarnSetup {
    param([string]$Message)
    Write-Host "WARN: $Message" -ForegroundColor Yellow
}

function Test-Windows {
    if ($env:OS -eq 'Windows_NT') { return $true }
    return $false
}

function Get-CommandPath {
    param([Parameter(Mandatory)][string]$Name)

    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $command) { return $null }
    return $command.Source
}

function Update-ProcessPath {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $processPath = [Environment]::GetEnvironmentVariable('Path', 'Process')
    $env:Path = @($machinePath, $userPath, $processPath) -join ';'
}

function Read-YesNo {
    param(
        [Parameter(Mandatory)][string]$Question,
        [bool]$Default = $true
    )

    if ($Yes) { return $true }
    if ($NonInteractive) { return $Default }

    $suffix = if ($Default) { '[Y/n]' } else { '[y/N]' }

    while ($true) {
        $answer = Read-Host "$Question $suffix"
        if ([string]::IsNullOrWhiteSpace($answer)) { return $Default }

        switch ($answer.Trim().ToLowerInvariant()) {
            { $_ -in @('y', 'yes', 's', 'sim') } { return $true }
            { $_ -in @('n', 'no', 'nao') } { return $false }
            default { Write-WarnSetup 'Responda com s/n ou y/n.' }
        }
    }
}

function Test-FontInstalled {
    param([string]$FontName)

    $fontRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts',
        'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
    )

    foreach ($root in $fontRoots) {
        if (-not (Test-Path $root)) { continue }
        $props = (Get-ItemProperty -Path $root).PSObject.Properties
        if ($props.Name -match [regex]::Escape($FontName)) { return $true }
    }

    return $false
}

function Install-WingetPackage {
    param(
        [Parameter(Mandatory)][string]$DisplayName,
        [Parameter(Mandatory)][string]$PackageId,
        [string]$CommandName
    )

    if ($CommandName -and (Get-CommandPath $CommandName)) {
        Write-Ok "$DisplayName encontrado."
        return
    }

    $winget = Get-CommandPath 'winget'
    if (-not $winget) {
        Write-WarnSetup "winget nao encontrado. Instale $DisplayName manualmente."
        return
    }

    Write-Step "Instalando $DisplayName com winget"
    & $winget install --id $PackageId --exact --source winget --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) { throw "winget falhou ao instalar $DisplayName." }

    Update-ProcessPath
}

function Invoke-PwshScript {
    param(
        [Parameter(Mandatory)][string]$PwshPath,
        [Parameter(Mandatory)][string]$ScriptPath,
        [string[]]$Arguments = @()
    )

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        throw "Script nao encontrado: $ScriptPath"
    }

    & $PwshPath -NoLogo -NoProfile -ExecutionPolicy Bypass -File $ScriptPath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao executar: $ScriptPath"
    }
}

if (-not (Test-Windows)) {
    throw 'Este setup foi feito para Windows 10/11 com Windows Terminal.'
}

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$checkScript = Join-Path $repoRoot 'scripts\check.ps1'
$installScript = Join-Path $repoRoot 'install.ps1'

Write-Title 'Cyberpunk PowerShell Terminal - setup guiado'
Write-Host 'Este script guia a instalacao sem substituir a logica segura do install.ps1.'
Write-Host 'Backups continuam sendo criados antes de alterar profile ou Windows Terminal.'

$shouldInstallDependencies = $InstallDependencies
if (-not $shouldInstallDependencies -and -not $NonInteractive) {
    $shouldInstallDependencies = Read-YesNo 'Instalar dependencias ausentes com winget?' $true
}

if ($shouldInstallDependencies) {
    Write-Title 'Dependencias'
    Install-WingetPackage -DisplayName 'PowerShell 7' -PackageId 'Microsoft.PowerShell' -CommandName 'pwsh'
    Install-WingetPackage -DisplayName 'Git' -PackageId 'Git.Git' -CommandName 'git'
    Install-WingetPackage -DisplayName 'Windows Terminal' -PackageId 'Microsoft.WindowsTerminal' -CommandName 'wt'
    Install-WingetPackage -DisplayName 'oh-my-posh' -PackageId 'JanDeDobbeleer.OhMyPosh' -CommandName 'oh-my-posh'
} else {
    Write-Step 'Instalacao automatica de dependencias ignorada.'
}

Update-ProcessPath
$pwshPath = Get-CommandPath 'pwsh'
if (-not $pwshPath) {
    throw 'PowerShell 7 (pwsh) nao foi encontrado. Instale com: winget install Microsoft.PowerShell'
}

if (-not (Test-FontInstalled 'FiraCode Nerd Font')) {
    Write-WarnSetup 'FiraCode Nerd Font nao foi detectada. Icones podem aparecer como quadrados.'
    if (-not $NonInteractive -and (Read-YesNo 'Abrir a pagina oficial do Nerd Fonts para baixar FiraCode?' $true)) {
        Start-Process 'https://www.nerdfonts.com/font-downloads'
    }
}

if (-not $SkipDiagnostics) {
    Write-Title 'Diagnostico antes da instalacao'
    Invoke-PwshScript -PwshPath $pwshPath -ScriptPath $checkScript
}

$shouldInstallProfile = $true
if (-not $NonInteractive -and -not $Yes) {
    $shouldInstallProfile = Read-YesNo 'Instalar profile, tema e regras cyberpunk agora?' $true
}

if ($shouldInstallProfile) {
    Write-Title 'Instalacao'

    $installArgs = @()
    if ($InstallOhMyPosh) { $installArgs += '-InstallOhMyPosh' }

    $shouldConfigureTerminal = $ConfigureWindowsTerminal
    if (-not $shouldConfigureTerminal -and -not $NonInteractive) {
        $shouldConfigureTerminal = Read-YesNo 'Mesclar perfil dev e esquema Cyberpunk2026 no Windows Terminal? Backup sera criado.' $true
    }

    if ($shouldConfigureTerminal) {
        $installArgs += '-ConfigureWindowsTerminal'
        if ($TerminalSettingsPath) {
            $installArgs += @('-TerminalSettingsPath', $TerminalSettingsPath)
        }
    }

    Invoke-PwshScript -PwshPath $pwshPath -ScriptPath $installScript -Arguments $installArgs
} else {
    Write-WarnSetup 'Instalacao do profile ignorada por escolha do usuario.'
}

if (-not $SkipDiagnostics) {
    Write-Title 'Diagnostico final'
    Invoke-PwshScript -PwshPath $pwshPath -ScriptPath $checkScript
}

Write-Title 'Proximos passos'
Write-Host '1. Feche e abra o Windows Terminal, ou rode: . $PROFILE'
Write-Host '2. Se configurou o Terminal, abra o perfil: wt -p dev'
Write-Host '3. Teste icones e cores com: ll ~'
Write-Host '4. Se algo quebrar, leia: docs\BACKUP_RESTORE.md'
Write-Host ''
Write-Ok 'Setup guiado finalizado.'

