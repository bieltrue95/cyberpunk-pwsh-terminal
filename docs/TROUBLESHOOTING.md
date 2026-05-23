# Troubleshooting

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
