# Backup And Restore

Language: [Português do Brasil](../BACKUP_RESTORE.md) | English

This document answers the questions that matter when something breaks: what was
saved, where it was saved, how to list backups, and how to roll back.

## What The Installer Saves

`install.ps1` copies three things into the PowerShell 7 profile directory:

| Item | Typical path |
| --- | --- |
| Profile | `C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |
| Theme | `C:\Users\<you>\Documents\PowerShell\themes\cyberpunk-clean.omp.json` |
| Rules | `C:\Users\<you>\Documents\PowerShell\data\cyber-item-rules.psd1` |

The exact path can vary. To check your machine:

```powershell
$PROFILE
Split-Path -Parent $PROFILE
```

## Profile Backup

If `$PROFILE` already exists, `install.ps1` creates a backup before replacing it.

Where it lives:

```text
same folder as $PROFILE
```

Format:

```text
Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss
```

Example:

```text
C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-20260523-183000
```

## Uninstall Backup

Before removing the profile, `uninstall.ps1` also creates a backup.

Format:

```text
Microsoft.PowerShell_profile.ps1.backup-before-uninstall-yyyyMMdd-HHmmss
```

## Windows Terminal Backup

Windows Terminal is only changed when you run:

```powershell
.\install.ps1 -ConfigureWindowsTerminal
```

or:

```powershell
.\scripts\merge-windows-terminal.ps1
```

When that happens, the backup is saved next to the original `settings.json`.

Format:

```text
settings.json.bak-yyyyMMdd-HHmmss
```

Common paths:

```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json
```

## List Available Backups

Profile backups:

```powershell
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.bak-*"
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.backup-before-uninstall-*"
```

Stable Windows Terminal backups:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Get-ChildItem -LiteralPath (Split-Path -Parent $settingsPath) -Filter "settings.json.bak-*"
```

Windows Terminal Preview backups:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
Get-ChildItem -LiteralPath (Split-Path -Parent $settingsPath) -Filter "settings.json.bak-*"
```

## Restore Previous Profile

Replace the backup path with the real backup file you want to restore:

```powershell
$profilePath = $PROFILE
$backupPath = "C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $profilePath -Force
. $PROFILE
```

## Restore Windows Terminal

Stable Windows Terminal:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$backupPath = "$settingsPath.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $settingsPath -Force
```

Windows Terminal Preview:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
$backupPath = "$settingsPath.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $settingsPath -Force
```

## See What Is Installed

```powershell
$profileDir = Split-Path -Parent $PROFILE
Get-Item $PROFILE
Get-ChildItem -LiteralPath (Join-Path $profileDir "themes")
Get-ChildItem -LiteralPath (Join-Path $profileDir "data")
```

## What Uninstall Removes

By default:

```powershell
.\uninstall.ps1
```

removes only the profile recognized as Cyberpunk and creates a backup first.

To remove theme and data as well:

```powershell
.\uninstall.ps1 -RemoveTheme -RemoveData
```

`uninstall.ps1` does not automatically remove Windows Terminal changes. If you
added the `dev` profile and `Cyberpunk2026` scheme, remove them manually or
restore a `settings.json` backup.
