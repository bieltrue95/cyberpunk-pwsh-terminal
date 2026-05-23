# Troubleshooting

Language: [Português do Brasil](../TROUBLESHOOTING.md) | English

## First Aid

If the terminal opens broken or the profile does not load, enter without a
profile:

```powershell
pwsh -NoLogo -NoProfile
```

Then run diagnostics from the repository folder:

```powershell
.\scripts\check.ps1
```

If you need to roll back, use the [Backup and restore](BACKUP_RESTORE.md) guide.

## Icons Show As Boxes

Install a Nerd Font and select it in Windows Terminal:

```text
FiraCode Nerd Font Mono
```

Then reopen the terminal tab. If VS Code still shows boxes, set both editor and
integrated terminal font families to the same Nerd Font.

## Prompt Is Not Styled

Check if oh-my-posh is available:

```powershell
oh-my-posh --version
```

If it is missing, install it and reopen PowerShell:

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

## Profile Does Not Load

Confirm the active profile path:

```powershell
$PROFILE
Test-Path $PROFILE
```

Reload manually:

```powershell
. $PROFILE
```

If execution policy blocks local scripts, run PowerShell as your user and use:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Windows Terminal Settings Broke

The merge script creates a backup next to the original `settings.json`:

```text
settings.json.bak-yyyyMMdd-HHmmss
```

Restore by replacing `settings.json` with the backup.

Example command for stable Windows Terminal:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$backupPath = "$settingsPath.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $settingsPath -Force
```

Example command for Windows Terminal Preview:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
$backupPath = "$settingsPath.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $settingsPath -Force
```

## Restore My Old Profile

`install.ps1` creates a backup of your previous profile next to `$PROFILE`, using
this format:

```text
Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss
```

To restore:

```powershell
$profilePath = $PROFILE
$backupPath = "C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $profilePath -Force
. $PROFILE
```

To list available backups:

```powershell
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.bak-*"
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.backup-before-uninstall-*"
```

Complete guide with backup paths and restore commands:
[Backup and restore](BACKUP_RESTORE.md).

## See What Was Installed

Use:

```powershell
$profileDir = Split-Path -Parent $PROFILE
Get-Item $PROFILE
Get-ChildItem -LiteralPath (Join-Path $profileDir "themes")
Get-ChildItem -LiteralPath (Join-Path $profileDir "data")
```

## `curl` Looks Different

PowerShell may map `curl` to `Invoke-WebRequest`. This setup intentionally keeps
that behavior and provides `ccurl` for the native binary:

```powershell
ccurl --version
curl.exe --version
```

## `ls` Is Pretty But Not Pipeline-Friendly

The custom `ls` renderer is for human-readable terminal output. For scripts,
prefer native PowerShell:

```powershell
Get-ChildItem | Where-Object Extension -eq '.ps1'
```

## Colors Or Icons Need Tweaking

Edit:

```text
data\cyber-item-rules.psd1
```

Then reload:

```powershell
. $PROFILE
```

## Run The Full Check

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
```

