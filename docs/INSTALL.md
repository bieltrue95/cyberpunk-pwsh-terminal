# Instalação

Idioma: Português do Brasil | [English](en/INSTALL.md)

O instalador copia o profile portátil para o caminho de profile do usuário atual
e coloca o tema do oh-my-posh e os dados de regras ao lado dele.

## Pré-Requisitos

Antes de instalar, confirme que a máquina tem:

| Ferramenta | Comando de verificação | Observações |
| --- | --- | --- |
| PowerShell 7 | `pwsh --version` | Obrigatório. Não use Windows PowerShell 5.1 para este setup. |
| Git | `git --version` | Necessário para instalar a partir de um repositório clonado. |
| Windows Terminal | `wt --version` | Recomendado para a experiência visual completa. |
| FiraCode Nerd Font Mono | Verificar lista de fontes do Windows Terminal | Necessário para ícones/glyphs renderizarem corretamente. |
| oh-my-posh | `oh-my-posh --version` | Recomendado para o prompt estilizado. |

Comandos comuns de instalação:

```powershell
winget install Microsoft.PowerShell
winget install Git.Git
winget install Microsoft.WindowsTerminal
winget install JanDeDobbeleer.OhMyPosh -s winget
```

A fonte `FiraCode Nerd Font Mono` deve ser instalada a partir do Nerd Fonts e
selecionada no Windows Terminal. Sem Nerd Font, os ícones geralmente aparecem
como quadrados vazios ou pontos de interrogação.

Rode o diagnóstico antes de instalar:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
```

## Instalação Padrão

```powershell
.\install.ps1
```

O que o instalador faz:

- Cria backup do `$PROFILE` existente, quando houver.
- Copia `profile\Microsoft.PowerShell_profile.ps1` para `$PROFILE`.
- Copia `themes\cyberpunk-clean.omp.json` para `<profile-dir>\themes`.
- Copia `data\cyber-item-rules.psd1` para `<profile-dir>\data`.

## Onde Os Arquivos Ficam

O instalador imprime os caminhos reais durante a execução. Em uma instalação
padrão do PowerShell 7 no Windows, normalmente fica assim:

| Item | Caminho típico |
| --- | --- |
| Profile instalado | `C:\Users\<voce>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |
| Tema oh-my-posh | `C:\Users\<voce>\Documents\PowerShell\themes\cyberpunk-clean.omp.json` |
| Regras de ícones/cores | `C:\Users\<voce>\Documents\PowerShell\data\cyber-item-rules.psd1` |
| Histórico PSReadLine | `%APPDATA%\Microsoft\PowerShell\PSReadLine\ConsoleHost_history.txt` |

Para ver o caminho exato do profile na sua máquina:

```powershell
$PROFILE
Split-Path -Parent $PROFILE
```

## Onde Os Backups Ficam

O backup do profile fica na mesma pasta do `$PROFILE`.

Formato criado pelo `install.ps1`:

```text
Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss
```

Exemplo:

```text
C:\Users\<voce>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-20260523-183000
```

O backup criado pelo `uninstall.ps1` também fica ao lado do `$PROFILE`, mas usa
um nome mais explícito:

```text
Microsoft.PowerShell_profile.ps1.backup-before-uninstall-yyyyMMdd-HHmmss
```

Se você usar `-ConfigureWindowsTerminal`, o backup do Windows Terminal fica ao
lado do `settings.json` original.

Formato:

```text
settings.json.bak-yyyyMMdd-HHmmss
```

Caminhos comuns do Windows Terminal:

```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json
```

## Como Restaurar Se Der Ruim

Restaurar profile:

```powershell
$profilePath = $PROFILE
$backupPath = "C:\Users\<voce>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $profilePath -Force
. $PROFILE
```

Restaurar Windows Terminal:

```powershell
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$backupPath = "$settingsPath.bak-yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $backupPath -Destination $settingsPath -Force
```

Se você usa Windows Terminal Preview, troque `Microsoft.WindowsTerminal` por
`Microsoft.WindowsTerminalPreview` no caminho.

## Flags Opcionais

Instalar oh-my-posh via winget quando estiver ausente:

```powershell
.\install.ps1 -InstallOhMyPosh
```

Mesclar automaticamente o perfil e esquema de cores no Windows Terminal:

```powershell
.\install.ps1 -ConfigureWindowsTerminal
```

Usar caminho customizado para `settings.json` do Windows Terminal:

```powershell
.\install.ps1 -ConfigureWindowsTerminal -TerminalSettingsPath "C:\path\to\settings.json"
```

## Segurança

O instalador não altera o Windows Terminal por padrão. Se você optar por
`-ConfigureWindowsTerminal`, ele cria backup com timestamp antes e valida o JSON
antes de escrever.
