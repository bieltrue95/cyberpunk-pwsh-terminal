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

