$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$installScript = Join-Path $repoRoot 'install.ps1'
$uninstallScript = Join-Path $repoRoot 'uninstall.ps1'
$rulesPath = Join-Path $repoRoot 'data\cyber-item-rules.psd1'

if (-not (Test-Path -LiteralPath $installScript)) { throw "Install script not found: $installScript" }
if (-not (Test-Path -LiteralPath $uninstallScript)) { throw "Uninstall script not found: $uninstallScript" }
if (-not (Test-Path -LiteralPath $rulesPath)) { throw "Rules file not found: $rulesPath" }

$tempBase = [System.IO.Path]::GetTempPath()
$sandboxRoot = Join-Path $tempBase "CyberpunkPwshE2E-$([guid]::NewGuid().ToString('N'))"
$profileDir = Join-Path $sandboxRoot 'PowerShell'
$targetProfile = Join-Path $profileDir 'Microsoft.PowerShell_profile.ps1'
$targetTheme = Join-Path $profileDir 'themes\cyberpunk-clean.omp.json'
$targetData = Join-Path $profileDir 'data\cyber-item-rules.psd1'

try {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null

    # 1) First uninstall should be safe even if profile does not exist yet.
    & $uninstallScript -Force -RemoveTheme -RemoveData -TargetProfilePath $targetProfile

    # 2) Install in sandbox.
    & $installScript -SkipBackup -TargetProfilePath $targetProfile

    foreach ($path in @($targetProfile, $targetTheme, $targetData)) {
        if (-not (Test-Path -LiteralPath $path)) {
            throw "Expected file was not installed: $path"
        }
    }

    # 3) Validate the installed profile can be loaded and rules are readable.
    . $targetProfile
    if (-not (Get-Command ls -ErrorAction SilentlyContinue)) { throw 'Installed profile did not register ls.' }
    if (-not (Test-Path -LiteralPath $targetData)) { throw 'Installed rule file not found after profile load.' }
    $rules = Import-PowerShellDataFile -LiteralPath $targetData
    if (-not $rules.ExtensionIcons -or $rules.ExtensionIcons.Count -lt 50) {
        throw 'Installed rules look incomplete.'
    }

    # 4) Uninstall and verify cleanup + backup creation.
    & $uninstallScript -Force -RemoveTheme -RemoveData -TargetProfilePath $targetProfile

    if (Test-Path -LiteralPath $targetProfile) { throw 'Profile still exists after uninstall.' }
    if (Test-Path -LiteralPath $targetTheme) { throw 'Theme still exists after uninstall.' }
    if (Test-Path -LiteralPath (Split-Path -Parent $targetData)) { throw 'Data directory still exists after uninstall.' }

    $backup = Get-ChildItem -LiteralPath $profileDir -Filter 'Microsoft.PowerShell_profile.ps1.backup-before-uninstall-*' -ErrorAction SilentlyContinue
    if (-not $backup) { throw 'Uninstall backup was not created.' }

    # 5) Reinstall to confirm reproducibility after uninstall.
    & $installScript -SkipBackup -TargetProfilePath $targetProfile
    if (-not (Test-Path -LiteralPath $targetProfile)) { throw 'Profile missing after reinstall.' }

    Write-Host 'E2E_REINSTALL_OK' -ForegroundColor Green
}
finally {
    if (Test-Path -LiteralPath $sandboxRoot) {
        Remove-Item -LiteralPath $sandboxRoot -Recurse -Force
    }
}
