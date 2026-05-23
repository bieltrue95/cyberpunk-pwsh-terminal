# Cyberpunk PowerShell Terminal

A portable Windows Terminal + PowerShell 7 setup with a clean cyberpunk look,
history search, an oh-my-posh prompt, and a custom `ls` renderer with Nerd Font
icons and neon colors.

This project was extracted from a real daily-driver setup and turned into a
repo-ready kit so other people can clone, inspect, install, customize, and learn
from it.

## Features

- PowerShell 7 profile focused on developer workflow.
- Persistent PSReadLine history with prefix search on Up/Down arrows.
- `hist` and `hfind` helpers for searching saved command history.
- Custom `ls`, `dir`, `l`, and `ll` renderer with icons and RGB colors.
- Data-driven icon/color rules in `data/cyber-item-rules.psd1`.
- Broad icon coverage for Windows folders, user folders, dev tools, cloud,
  Office files, certificates, media, archives, databases, and common languages.
- Minimal cyberpunk oh-my-posh theme.
- Windows Terminal color scheme and profile snippet.
- Safe installer that backs up an existing profile before replacing it.
- Optional Windows Terminal merge with backup and JSON validation.
- Diagnostics and CI-friendly profile tests.

## Requirements

- Windows 10/11.
- PowerShell 7 (`pwsh`).
- Windows Terminal.
- FiraCode Nerd Font Mono.
- oh-my-posh.

The profile still works without oh-my-posh, but the styled prompt only loads
when `oh-my-posh` is installed and available in `PATH`.

## Quick Check

Before installing, run diagnostics:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
```

Warnings for missing font or oh-my-posh are expected on a fresh machine. Parser,
JSON, and rule-data failures should be fixed before installing.

## Install

Clone the repo and run the installer from PowerShell 7:

```powershell
git clone https://github.com/YOUR-USER/cyberpunk-pwsh-terminal.git
cd cyberpunk-pwsh-terminal
.\install.ps1
```

Optional: ask the installer to install oh-my-posh with `winget` if it is missing:

```powershell
.\install.ps1 -InstallOhMyPosh
```

Then open a new Windows Terminal tab or reload the profile:

```powershell
. $PROFILE
```

## Windows Terminal Setup

By default, the installer does not edit Windows Terminal settings. That avoids
rewriting personal `settings.json` files unexpectedly.

Manual setup reference:

```text
terminal\windows-terminal-snippet.json
```

Optional automatic merge with backup and JSON validation:

```powershell
.\install.ps1 -ConfigureWindowsTerminal
```

You can also run the merge script directly:

```powershell
.\scripts\merge-windows-terminal.ps1
```

The merge script appends/replaces only the `dev` profile and `Cyberpunk2026`
scheme, then creates a timestamped backup of the original Terminal settings.

## Useful Commands

```powershell
ls
ll
hist -Last 20
hist -Search git
hfind docker
ccurl --version
```

## Customize Icons And Colors

Edit the data file, not the renderer logic:

```text
data\cyber-item-rules.psd1
```

Main sections:

- `DirectoryIconRules`: regex rules for folder icons.
- `FileIconRules`: regex rules for file-name icons.
- `ExtensionIcons`: extension-to-icon map.
- `DirectoryColorRules`: regex rules for folder colors.
- `FileColorRules`: regex rules for file-name colors.
- `ExtensionColors`: extension-to-color map.

Keep the file saved as UTF-8 because Nerd Font glyphs are stored directly in it.

## Test Without Installing

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
```

This loads the repo profile directly, creates a temporary folder with sample
files, renders the custom listing, and removes the temporary folder.

## Uninstall

```powershell
.\uninstall.ps1
```

The uninstall script only removes the profile when it recognizes the Cyberpunk
profile marker. It backs up the file before removing it.

Optional cleanup:

```powershell
.\uninstall.ps1 -RemoveTheme -RemoveData
```

## Project Layout

```text
cyberpunk-pwsh-terminal/
├─ data/
│  └─ cyber-item-rules.psd1
├─ docs/
├─ profile/
│  └─ Microsoft.PowerShell_profile.ps1
├─ scripts/
│  ├─ check.ps1
│  ├─ merge-windows-terminal.ps1
│  └─ test-profile.ps1
├─ terminal/
├─ themes/
├─ install.ps1
└─ uninstall.ps1
```

## Notes

- This project intentionally does not depend on Terminal-Icons for `ls`.
- The renderer is self-contained to avoid module cache problems.
- The terminal can only infer icons from file/folder names and extensions, so
  the goal is broad practical coverage, not a perfect mapping of every Nerd Font
  glyph.

## License

MIT
