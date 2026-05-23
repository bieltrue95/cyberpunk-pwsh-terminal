# Cyberpunk PowerShell Terminal

![Cyberpunk PowerShell Terminal preview](screenshots/terminal-showcase.svg)

A portable Windows Terminal + PowerShell 7 setup with a cyberpunk visual style,
fast history search, an oh-my-posh prompt, and a custom `ls` renderer powered by
Nerd Font icons and neon RGB colors.

This project started as a real daily-driver terminal setup and was cleaned up
into a reproducible kit that other people can inspect, install, customize, and
contribute to safely.

[![CI](https://github.com/bieltrue95/cyberpunk-pwsh-terminal/actions/workflows/ci.yml/badge.svg)](https://github.com/bieltrue95/cyberpunk-pwsh-terminal/actions/workflows/ci.yml)
![PowerShell](https://img.shields.io/badge/PowerShell-7+-5391FE?logo=powershell&logoColor=white)
![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-ready-00E5FF)
![License](https://img.shields.io/badge/license-MIT-67FF9A)

## Preview Gallery

| Terminal renderer | History search |
| --- | --- |
| ![Terminal listing with icons and colors](screenshots/terminal-showcase.svg) | ![History search preview](screenshots/history-search.svg) |

| Data-driven rules | Safe installer |
| --- | --- |
| ![Data-driven rules architecture](screenshots/data-driven-rules.svg) | ![Safe install flow](screenshots/safe-install-flow.svg) |

The previews are committed as SVG files so the README renders nicely on GitHub
without external image hosting. Real PNG screenshots can be added later in the
same `screenshots/` folder.

## What You Get

- PowerShell 7 profile focused on developer workflow.
- Persistent PSReadLine history with prefix search on `UpArrow` and `DownArrow`.
- `hist` and `hfind` helpers for searching saved command history.
- Custom `ls`, `dir`, `l`, and `ll` renderer with icon-aware, colorized output.
- Data-driven icon/color rules in `data/cyber-item-rules.psd1`.
- Broad coverage for Windows folders, user folders, dev tools, cloud folders,
  Office files, certificates, media, archives, databases, and common languages.
- Minimal cyberpunk oh-my-posh prompt theme.
- Windows Terminal `dev` profile snippet and `Cyberpunk2026` color scheme.
- Safe installer that backs up existing files before replacing anything.
- Optional Windows Terminal merge with backup and JSON validation.
- Diagnostics and smoke tests that are also used by GitHub Actions.

## Requirements

- Windows 10/11.
- PowerShell 7 (`pwsh`).
- Windows Terminal.
- FiraCode Nerd Font Mono.
- oh-my-posh.

The profile still works without oh-my-posh, but the styled prompt only loads
when `oh-my-posh` is installed and available in `PATH`.

## Quick Start

Clone the repo:

```powershell
git clone git@github.com:bieltrue95/cyberpunk-pwsh-terminal.git
cd cyberpunk-pwsh-terminal
```

Run diagnostics before installing:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
```

Install the profile, theme, and rule data:

```powershell
.\install.ps1
```

Reload the current shell or open a new Windows Terminal tab:

```powershell
. $PROFILE
```

## Optional Install Modes

Install oh-my-posh with `winget` when missing:

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

The Terminal merge is opt-in. It creates a timestamped backup and validates JSON
before writing anything.

## Daily Commands

```powershell
ls
ll
hist -Last 20
hist -Search git
hfind docker
ccurl --version
```

## How The Icon Engine Works

The renderer is intentionally split into logic and data.

```text
data\cyber-item-rules.psd1       # icon/color rules
profile\Microsoft.PowerShell_profile.ps1  # rule engine and renderer
```

The profile loads `data/cyber-item-rules.psd1`, then resolves each item in this
order:

1. Link fallback.
2. Directory regex rules.
3. File-name regex rules.
4. Extension maps.
5. Default folder/file fallback.

This keeps contributions simple: most new icon requests only touch the data
file, not the PowerShell renderer.

## Customize Icons And Colors

Edit:

```text
data\cyber-item-rules.psd1
```

Example:

```powershell
ExtensionIcons = @{
    '.ps1' = '󰨊'
    '.json' = ''
}

ExtensionColors = @{
    '.ps1' = '#63F3FF'
    '.json' = '#FFD166'
}
```

Main sections:

- `DirectoryIconRules`: regex rules for folder icons.
- `FileIconRules`: regex rules for file-name icons.
- `ExtensionIcons`: extension-to-icon map.
- `DirectoryColorRules`: regex rules for folder colors.
- `FileColorRules`: regex rules for file-name colors.
- `ExtensionColors`: extension-to-color map.

Keep the file saved as UTF-8 because Nerd Font glyphs are stored directly in it.

## Windows Terminal Setup

Manual setup reference:

```text
terminal\windows-terminal-snippet.json
```

The snippet contains:

- `dev` profile.
- `Cyberpunk2026` color scheme.
- FiraCode Nerd Font Mono configuration.
- Acrylic opacity and tab styling.

Automatic setup is available with:

```powershell
.\scripts\merge-windows-terminal.ps1
```

## Test Without Installing

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
```

This loads the repo profile directly, creates a temporary folder with sample
files, renders the custom listing, and removes the temporary folder.

## Project Layout

```text
cyberpunk-pwsh-terminal/
├─ data/
│  └─ cyber-item-rules.psd1
├─ docs/
│  ├─ ARCHITECTURE.md
│  ├─ CYBERPUNK_TERMINAL_SETUP.md
│  ├─ INSTALL.md
│  ├─ SCREENSHOTS.md
│  └─ TROUBLESHOOTING.md
├─ profile/
│  └─ Microsoft.PowerShell_profile.ps1
├─ screenshots/
├─ scripts/
│  ├─ check.ps1
│  ├─ merge-windows-terminal.ps1
│  └─ test-profile.ps1
├─ terminal/
├─ themes/
├─ install.ps1
└─ uninstall.ps1
```

## Troubleshooting

If icons render as boxes, install/select `FiraCode Nerd Font Mono` in Windows
Terminal and VS Code.

If the prompt is not styled, verify `oh-my-posh` is installed:

```powershell
oh-my-posh --version
```

If `ls` works but icon colors are not what you expect, edit:

```text
data\cyber-item-rules.psd1
```

More fixes live in [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## Documentation

- [Install notes](docs/INSTALL.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Screenshots](docs/SCREENSHOTS.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Terminal setup notes](docs/CYBERPUNK_TERMINAL_SETUP.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## Roadmap

- Add real PNG screenshots from Windows Terminal.
- Add more preset themes: minimal, heavy neon, and high-contrast.
- Add Pester tests for icon/color rule resolution.
- Add a rule gallery generated from `data/cyber-item-rules.psd1`.
- Add a safe update command for already-installed profiles.

## Notes

- This project intentionally does not depend on Terminal-Icons for `ls`.
- The renderer is self-contained to avoid module cache problems.
- The terminal can only infer icons from file/folder names and extensions, so
  the goal is broad practical coverage, not a perfect mapping of every Nerd Font
  glyph.

## License

MIT
