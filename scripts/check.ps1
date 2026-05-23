$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$failures = 0
$warnings = 0

function Write-Pass {
    param([string]$Message)
    Write-Host "PASS: $Message" -ForegroundColor Green
}

function Write-WarnCheck {
    param([string]$Message)
    $script:warnings++
    Write-Host "WARN: $Message" -ForegroundColor Yellow
}

function Write-Fail {
    param([string]$Message)
    $script:failures++
    Write-Host "FAIL: $Message" -ForegroundColor Red
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

function Test-PowerShellParse {
    param([Parameter(Mandatory)][string]$Path)

    $tokens = $null
    $errors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$errors)
    if ($errors -and $errors.Count) {
        Write-Fail "PowerShell parse failed: $Path"
        $errors | ForEach-Object { Write-Host "  $($_.Message)" -ForegroundColor Red }
    } else {
        Write-Pass "PowerShell parse ok: $([System.IO.Path]::GetFileName($Path))"
    }
}

if ($PSVersionTable.PSEdition -eq 'Core' -and $PSVersionTable.PSVersion.Major -ge 7) {
    Write-Pass "PowerShell $($PSVersionTable.PSVersion)"
} else {
    Write-Fail "PowerShell 7 is required. Current version: $($PSVersionTable.PSVersion)"
}

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Pass 'oh-my-posh found in PATH'
} else {
    Write-WarnCheck 'oh-my-posh not found. Prompt theme will be skipped until installed.'
}

if (Test-FontInstalled 'FiraCode Nerd Font') {
    Write-Pass 'FiraCode Nerd Font detected'
} else {
    Write-WarnCheck 'FiraCode Nerd Font not detected. Icons may render as boxes.'
}

if (Get-Command wt.exe -ErrorAction SilentlyContinue) {
    Write-Pass 'Windows Terminal launcher found'
} else {
    Write-WarnCheck 'wt.exe not found in PATH. Windows Terminal may still be installed as a Store app.'
}

$terminalSettings = @(@(
    (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
    (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json')
) | Where-Object { Test-Path -LiteralPath $_ })

if ($terminalSettings) {
    Write-Pass "Windows Terminal settings found: $($terminalSettings[0])"
} else {
    Write-WarnCheck 'Windows Terminal settings.json not found.'
}

foreach ($file in @('setup.ps1','install.ps1','uninstall.ps1','scripts\test-profile.ps1','scripts\merge-windows-terminal.ps1','profile\Microsoft.PowerShell_profile.ps1')) {
    Test-PowerShellParse -Path (Join-Path $repoRoot $file)
}

foreach ($json in @('themes\cyberpunk-clean.omp.json','terminal\windows-terminal-snippet.json','terminal\cyberpunk2026-scheme.json')) {
    $path = Join-Path $repoRoot $json
    try {
        Get-Content -Raw -LiteralPath $path | ConvertFrom-Json | Out-Null
        Write-Pass "JSON ok: $json"
    } catch {
        Write-Fail "JSON invalid: $json - $($_.Exception.Message)"
    }
}

try {
    $rulesPath = Join-Path $repoRoot 'data\cyber-item-rules.psd1'
    $rules = Import-PowerShellDataFile -LiteralPath $rulesPath
    if ($rules.ExtensionIcons.Count -lt 50 -or $rules.ExtensionColors.Count -lt 50) {
        Write-Fail 'Rule data loaded but has unexpectedly few extension mappings.'
    } else {
        Write-Pass "Rule data ok: $($rules.ExtensionIcons.Count) extension icons, $($rules.ExtensionColors.Count) extension colors"
    }
} catch {
    Write-Fail "Rule data invalid: $($_.Exception.Message)"
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Pass 'git found in PATH'
} else {
    Write-WarnCheck 'git not found in PATH.'
}

Write-Host ""
Write-Host "Diagnostics finished: $failures failure(s), $warnings warning(s)."
if ($failures -gt 0) { exit 1 }
