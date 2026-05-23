# Install Notes

Language: [Português do Brasil](../INSTALL.md) | English

The installer copies the portable profile into the current user's PowerShell
profile path and places the oh-my-posh theme plus rule data beside it.

## Prerequisites

Before installing, make sure the machine has:

| Tool | Check command | Notes |
| --- | --- | --- |
| PowerShell 7 | `pwsh --version` | Required. Do not use Windows PowerShell 5.1 for this setup. |
| Git | `git --version` | Required when installing from a cloned repository. |
| Windows Terminal | `wt --version` | Recommended for the full visual experience. |
| FiraCode Nerd Font Mono | Check Windows Terminal font list | Required for icons/glyphs to render correctly. |
| oh-my-posh | `oh-my-posh --version` | Recommended for the styled prompt. |

Common install commands:

```powershell
winget install Microsoft.PowerShell
winget install Git.Git
winget install Microsoft.WindowsTerminal
winget install JanDeDobbeleer.OhMyPosh -s winget
```

`FiraCode Nerd Font Mono` should be installed from Nerd Fonts and then selected
in Windows Terminal. Without a Nerd Font, icons usually render as empty boxes or
question marks.

Run diagnostics before installing:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
```

## Default Install

```powershell
.\install.ps1
```

What it does:

- Backs up the existing `$PROFILE` when one exists.
- Copies `profile\Microsoft.PowerShell_profile.ps1` to `$PROFILE`.
- Copies `themes\cyberpunk-clean.omp.json` to `<profile-dir>\themes`.
- Copies `data\cyber-item-rules.psd1` to `<profile-dir>\data`.

## Where Files Are Installed

The installer prints the real target paths while it runs. On a typical
PowerShell 7 Windows setup, they look like this:

| Item | Typical path |
| --- | --- |
| Installed profile | `C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |
| oh-my-posh theme | `C:\Users\<you>\Documents\PowerShell\themes\cyberpunk-clean.omp.json` |
| Icon/color rules | `C:\Users\<you>\Documents\PowerShell\data\cyber-item-rules.psd1` |
| PSReadLine history | `%APPDATA%\Microsoft\PowerShell\PSReadLine\ConsoleHost_history.txt` |

To see the exact profile path on your machine:

```powershell
$PROFILE
Split-Path -Parent $PROFILE
```

## Where Backups Are Saved

The profile backup is saved next to `$PROFILE`.

Created by `install.ps1`:

```text
Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss
```

Example:

```text
C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-20260523-183000
```

The backup created by `uninstall.ps1` also lives next to `$PROFILE`, but uses a
more explicit name:

```text
Microsoft.PowerShell_profile.ps1.backup-before-uninstall-yyyyMMdd-HHmmss
```

If you use `-ConfigureWindowsTerminal`, the Windows Terminal backup is saved next
to the original `settings.json`.

Format:

```text
settings.json.bak-yyyyMMdd-HHmmss
```

Common Windows Terminal paths:

```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json
```

## Restore If Something Breaks

Restore profile:

```powershell
$profilePath = $PROFILE
$backupPath = "C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $profilePath -Force
. $PROFILE
```

Restore Windows Terminal:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$backupPath = "$settingsPath.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $settingsPath -Force
```

If you use Windows Terminal Preview, replace `Microsoft.WindowsTerminal` with
`Microsoft.WindowsTerminalPreview` in the path.

Complete guide with formats, paths, listing, and restore commands:
[Backup and restore](BACKUP_RESTORE.md).

## Optional Flags

Install oh-my-posh through winget when missing:

```powershell
.\install.ps1 -InstallOhMyPosh
```

Merge the Windows Terminal profile and color scheme automatically:

```powershell
.\install.ps1 -ConfigureWindowsTerminal
```

Use a custom Windows Terminal settings path:

```powershell
.\install.ps1 -ConfigureWindowsTerminal -TerminalSettingsPath "C:\path\to\settings.json"
```

## Safety

The installer does not edit Windows Terminal by default. If you opt into
`-ConfigureWindowsTerminal`, it creates a timestamped backup first and validates
JSON before writing.

