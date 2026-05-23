# Solução De Problemas

Idioma: Português do Brasil | [English](en/TROUBLESHOOTING.md)

## Ícones Aparecem Como Quadrados

Instale uma Nerd Font e selecione-a no Windows Terminal:

```text
FiraCode Nerd Font Mono
```

Depois reabra a aba do terminal. Se o VS Code ainda mostrar quadrados, configure
a mesma fonte no editor e no terminal integrado.

## Prompt Não Está Estilizado

Verifique se oh-my-posh está disponível:

```powershell
oh-my-posh --version
```

Se estiver ausente, instale e reabra o PowerShell:

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

## Profile Não Carrega

Confirme o caminho ativo do profile:

```powershell
$PROFILE
Test-Path $PROFILE
```

Recarregue manualmente:

```powershell
. $PROFILE
```

Se a política de execução bloquear scripts locais, use no escopo do usuário:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Configuração Do Windows Terminal Quebrou

O script de merge cria backup ao lado do `settings.json` original:

```text
settings.json.bak-yyyyMMdd-HHmmss
```

Restaure substituindo `settings.json` pelo backup.

Comando exemplo para Windows Terminal estável:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$backupPath = "$settingsPath.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $settingsPath -Force
```

Comando exemplo para Windows Terminal Preview:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
$backupPath = "$settingsPath.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $settingsPath -Force
```

## Quero Voltar Meu Profile Antigo

O `install.ps1` cria backup do profile antigo ao lado do `$PROFILE`, com este
formato:

```text
Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss
```

Para restaurar:

```powershell
$profilePath = $PROFILE
$backupPath = "C:\Users\<voce>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $profilePath -Force
. $PROFILE
```

Para listar backups disponíveis:

```powershell
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.bak-*"
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.backup-before-uninstall-*"
```

## Quero Saber O Que Foi Instalado

Use:

```powershell
$profileDir = Split-Path -Parent $PROFILE
Get-Item $PROFILE
Get-ChildItem -LiteralPath (Join-Path $profileDir "themes")
Get-ChildItem -LiteralPath (Join-Path $profileDir "data")
```

## `curl` Parece Diferente

PowerShell pode mapear `curl` para `Invoke-WebRequest`. Este setup mantém esse
comportamento e oferece `ccurl` para chamar o binário nativo:

```powershell
ccurl --version
curl.exe --version
```

## `ls` É Bonito, Mas Não É Para Pipeline

O renderer customizado de `ls` é para saída visual. Para scripts, prefira o
PowerShell nativo:

```powershell
Get-ChildItem | Where-Object Extension -eq '.ps1'
```

## Quero Ajustar Cores Ou Ícones

Edite:

```text
data\cyber-item-rules.psd1
```

Depois recarregue:

```powershell
. $PROFILE
```

## Rodar Verificação Completa

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
```
