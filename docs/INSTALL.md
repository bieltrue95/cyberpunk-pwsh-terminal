# Install Notes

The installer copies the portable profile into the current user's PowerShell
profile path and places the oh-my-posh theme plus rule data beside it.

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
