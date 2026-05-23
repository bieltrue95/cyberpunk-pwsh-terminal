# Getting Started

Language: [Português do Brasil](../GETTING_STARTED.md) | English

This guide is for people who want to install the setup without understanding all
internal project details first. The recommended path uses `setup.ps1`, which asks
questions, runs validations, and calls the safe repository scripts.

## Easiest Path

Open PowerShell in the repository folder and run:

```powershell
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1
```

The guided setup asks whether you want to:

| Question | Recommendation | What happens |
| --- | --- | --- |
| Install missing dependencies with `winget` | Yes | Installs PowerShell 7, Git, Windows Terminal, and oh-my-posh when missing. |
| Open the Nerd Fonts page | Yes if the font is missing | Download `FiraCode Nerd Font` and select it in Windows Terminal. |
| Install profile, theme, and rules | Yes | Copies files to the right PowerShell 7 profile folder. |
| Merge Windows Terminal settings | Yes for the full experience | Backs up `settings.json`, validates JSON, and adds the `dev` profile. |

## Five Commands If You Are In A Hurry

```powershell
git clone git@github.com:bieltrue95/cyberpunk-pwsh-terminal.git
cd cyberpunk-pwsh-terminal
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1
wt -p dev
```

If you do not have a GitHub SSH key yet, clone over HTTPS:

```powershell
git clone https://github.com/bieltrue95/cyberpunk-pwsh-terminal.git
```

## Prerequisites In Plain Language

Required to install the profile:

| Item | How to check | If missing |
| --- | --- | --- |
| Windows 10/11 | `winver` | Use Windows 10 or 11. |
| PowerShell 7 | `pwsh --version` | `winget install Microsoft.PowerShell` |
| Git | `git --version` | `winget install Git.Git` |

Required for the visual experience:

| Item | How to check | If missing |
| --- | --- | --- |
| Windows Terminal | `wt --version` | `winget install Microsoft.WindowsTerminal` |
| FiraCode Nerd Font | Selectable Terminal font | Download it from Nerd Fonts and select it in the `dev` profile. |
| oh-my-posh | `oh-my-posh --version` | `winget install JanDeDobbeleer.OhMyPosh -s winget` |

## If Something Breaks, Do This First

1. Open PowerShell 7 without loading the profile:

```powershell
pwsh -NoLogo -NoProfile
```

2. Enter the repo folder and run diagnostics:

```powershell
cd cyberpunk-pwsh-terminal
.\scripts\check.ps1
```

3. List profile backups and restore if needed:

```powershell
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.bak-*"
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.backup-before-uninstall-*"
```

4. Read the complete guide: [Backup and restore](BACKUP_RESTORE.md).

## What Is Not Automatic

- The font may still need to be installed manually and selected in Windows Terminal.
- SSH cloning requires a GitHub key; HTTPS works without SSH.
- `setup.ps1` does not delete old backups.
- Windows Terminal is edited only if you accept the merge prompt or pass `-ConfigureWindowsTerminal`.

## Useful Commands After Install

```powershell
ll ~
hist -Last 20
hfind git
ccurl --version
```

If icons show as boxes, the issue is almost always the font: select
`FiraCode Nerd Font Mono` in the Windows Terminal `dev` profile.

