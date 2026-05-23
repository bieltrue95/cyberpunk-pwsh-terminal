# Architecture

This project is split into small pieces so the visual style can evolve without
turning the PowerShell profile into an unmaintainable blob.

## Main Parts

```text
data\cyber-item-rules.psd1
profile\Microsoft.PowerShell_profile.ps1
scripts\check.ps1
scripts\merge-windows-terminal.ps1
terminal\windows-terminal-snippet.json
themes\cyberpunk-clean.omp.json
```

## Profile Boot Flow

1. Configure PSReadLine history and keybindings.
2. Load icon/color rules from `data\cyber-item-rules.psd1`.
3. Register `ls`, `dir`, `l`, and `ll` as visual renderers.
4. Register helper commands like `hist`, `hfind`, and `ccurl`.
5. Initialize oh-my-posh when available.

## Rule Resolution

For every file system item, the renderer resolves icon and color in this order:

1. Link fallback.
2. Directory regex rules.
3. File-name regex rules.
4. Extension maps.
5. Default folder/file fallback.

This makes common cases fast and keeps new contributions data-only.

## Why Not Terminal-Icons?

Terminal-Icons is a good module, but this setup intentionally avoids taking a
runtime dependency on it. The original environment hit module cache instability,
so the renderer became self-contained for predictable startup and easier GitHub
sharing.

## Why Use Write-Host?

The custom `ls` is intentionally a visual command. It paints columns and names
with ANSI RGB sequences, so it is optimized for humans looking at a terminal.

For pipeline-heavy scripting, use native commands directly:

```powershell
Get-ChildItem | Where-Object Extension -eq '.ps1'
```

## Installer Safety

The installer copies files into the current user's PowerShell profile directory.
It backs up an existing profile before replacing it.

Windows Terminal settings are not modified by default. The merge script is
opt-in and performs these steps:

1. Read existing `settings.json`.
2. Read `terminal\windows-terminal-snippet.json`.
3. Replace or append only the `dev` profile and `Cyberpunk2026` scheme.
4. Validate JSON.
5. Create a timestamped backup.
6. Write the merged file.
