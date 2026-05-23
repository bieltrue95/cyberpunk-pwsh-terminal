[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$SkipBackup,
    [switch]$InstallOhMyPosh,
    [switch]$ConfigureWindowsTerminal,
    [string]$TerminalSettingsPath
)

$ErrorActionPreference = 'Stop'

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Warn {
    param([string]$Message)
    Write-Host "WARN: $Message" -ForegroundColor Yellow
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

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceProfile = Join-Path $repoRoot 'profile\Microsoft.PowerShell_profile.ps1'
$sourceTheme = Join-Path $repoRoot 'themes\cyberpunk-clean.omp.json'
$sourceDataDir = Join-Path $repoRoot 'data'
$terminalSnippet = Join-Path $repoRoot 'terminal\windows-terminal-snippet.json'
$mergeScript = Join-Path $repoRoot 'scripts\merge-windows-terminal.ps1'

if (-not (Test-Path -LiteralPath $sourceProfile)) { throw "Profile source not found: $sourceProfile" }
if (-not (Test-Path -LiteralPath $sourceTheme)) { throw "Theme source not found: $sourceTheme" }
if (-not (Test-Path -LiteralPath $sourceDataDir)) { throw "Data directory not found: $sourceDataDir" }

$targetProfile = $PROFILE.CurrentUserCurrentHost
if (-not $targetProfile) { $targetProfile = [string]$PROFILE }
$targetProfileDir = Split-Path -Parent $targetProfile
$targetThemeDir = Join-Path $targetProfileDir 'themes'
$targetTheme = Join-Path $targetThemeDir 'cyberpunk-clean.omp.json'
$targetDataDir = Join-Path $targetProfileDir 'data'

Write-Step "Installing Cyberpunk PowerShell profile"
Write-Host "Target profile: $targetProfile"
Write-Host "Target theme:   $targetTheme"
Write-Host "Target data:    $targetDataDir"

if ($PSVersionTable.PSEdition -ne 'Core' -or $PSVersionTable.PSVersion.Major -lt 7) {
    Write-Warn "You are not running PowerShell 7. Re-run this with pwsh for the intended setup."
}

if ($InstallOhMyPosh -and -not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Step "Installing oh-my-posh with winget"
        winget install JanDeDobbeleer.OhMyPosh -s winget
    } else {
        Write-Warn "winget was not found. Install oh-my-posh manually."
    }
}

if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Warn "oh-my-posh was not found in PATH. The profile will load, but the styled prompt will be skipped."
}

if (-not (Test-FontInstalled 'FiraCode Nerd Font')) {
    Write-Warn "FiraCode Nerd Font was not detected. Icons may show as boxes until the font is installed and selected in Windows Terminal."
}

New-Item -ItemType Directory -Path $targetProfileDir -Force | Out-Null
New-Item -ItemType Directory -Path $targetThemeDir -Force | Out-Null
New-Item -ItemType Directory -Path $targetDataDir -Force | Out-Null

if ((Test-Path -LiteralPath $targetProfile) -and -not $SkipBackup) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backup = "$targetProfile.bak-$stamp"
    Write-Step "Backing up existing profile"
    Copy-Item -LiteralPath $targetProfile -Destination $backup -Force
    Write-Host "Backup: $backup"
}

if ($PSCmdlet.ShouldProcess($targetProfile, 'Copy portable PowerShell profile')) {
    Copy-Item -LiteralPath $sourceProfile -Destination $targetProfile -Force
}

if ($PSCmdlet.ShouldProcess($targetTheme, 'Copy oh-my-posh theme')) {
    Copy-Item -LiteralPath $sourceTheme -Destination $targetTheme -Force
}

if ($PSCmdlet.ShouldProcess($targetDataDir, 'Copy icon/color rule data')) {
    Copy-Item -LiteralPath (Join-Path $sourceDataDir '*') -Destination $targetDataDir -Recurse -Force
}

if ($ConfigureWindowsTerminal) {
    if (-not (Test-Path -LiteralPath $mergeScript)) { throw "Merge script not found: $mergeScript" }
    Write-Step "Configuring Windows Terminal with a safe backup + JSON validation"
    $mergeParams = @{ SnippetPath = $terminalSnippet }
    if ($TerminalSettingsPath) { $mergeParams.SettingsPath = $TerminalSettingsPath }
    & $mergeScript @mergeParams
}

Write-Step "Install complete"
Write-Host "Reload current shell: . `$PROFILE"
Write-Host "Run diagnostics:    .\scripts\check.ps1"
Write-Host "Terminal snippet:   $terminalSnippet"
Write-Host "Use -ConfigureWindowsTerminal if you want the installer to merge the Terminal profile automatically."
