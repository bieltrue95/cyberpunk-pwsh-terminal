# Backup E Restauração

Idioma: Português do Brasil | [English](en/BACKUP_RESTORE.md)

Este documento responde às perguntas que aparecem quando algo quebra: o que foi
salvo, onde foi salvo, como listar backups e como voltar atrás.

## O Que O Instalador Salva

O `install.ps1` copia três coisas para a pasta do profile do PowerShell 7:

| Item | Caminho típico |
| --- | --- |
| Profile | `C:\Users\<voce>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |
| Tema | `C:\Users\<voce>\Documents\PowerShell\themes\cyberpunk-clean.omp.json` |
| Regras | `C:\Users\<voce>\Documents\PowerShell\data\cyber-item-rules.psd1` |

O caminho exato pode variar. Para descobrir na sua máquina:

```powershell
$PROFILE
Split-Path -Parent $PROFILE
```

## Backup Do Profile

Se já existir um `$PROFILE`, o `install.ps1` cria backup antes de substituir.

Onde fica:

```text
mesma pasta do $PROFILE
```

Formato:

```text
Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss
```

Exemplo:

```text
C:\Users\<voce>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-20260523-183000
```

## Backup Do Uninstall

Antes de remover o profile, o `uninstall.ps1` também cria backup.

Formato:

```text
Microsoft.PowerShell_profile.ps1.backup-before-uninstall-yyyyMMdd-HHmmss
```

## Backup Do Windows Terminal

O Windows Terminal só é alterado se você rodar:

```powershell
.\install.ps1 -ConfigureWindowsTerminal
```

ou:

```powershell
.\scripts\merge-windows-terminal.ps1
```

Quando isso acontece, o backup fica ao lado do `settings.json` original.

Formato:

```text
settings.json.bak-yyyyMMdd-HHmmss
```

Caminhos comuns:

```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json
```

## Listar Backups Disponíveis

Backups do profile:

```powershell
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.bak-*"
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.backup-before-uninstall-*"
```

Backups do Windows Terminal estável:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Get-ChildItem -LiteralPath (Split-Path -Parent $settingsPath) -Filter "settings.json.bak-*"
```

Backups do Windows Terminal Preview:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
Get-ChildItem -LiteralPath (Split-Path -Parent $settingsPath) -Filter "settings.json.bak-*"
```

## Restaurar Profile Antigo

Troque o caminho do backup pelo arquivo real que você quer restaurar:

```powershell
$profilePath = $PROFILE
$backupPath = "C:\Users\<voce>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $profilePath -Force
. $PROFILE
```

## Restaurar Windows Terminal

Windows Terminal estável:

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

## Ver O Que Está Instalado

```powershell
$profileDir = Split-Path -Parent $PROFILE
Get-Item $PROFILE
Get-ChildItem -LiteralPath (Join-Path $profileDir "themes")
Get-ChildItem -LiteralPath (Join-Path $profileDir "data")
```

## O Que O Uninstall Remove

Por padrão:

```powershell
.\uninstall.ps1
```

remove apenas o profile reconhecido como Cyberpunk e cria backup antes.

Para remover também tema e dados:

```powershell
.\uninstall.ps1 -RemoveTheme -RemoveData
```

O `uninstall.ps1` não remove alterações do Windows Terminal automaticamente.
Se você adicionou o perfil `dev` e o esquema `Cyberpunk2026`, remova manualmente
ou restaure um backup do `settings.json`.
