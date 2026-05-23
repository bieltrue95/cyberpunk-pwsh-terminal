# Comece Aqui

Idioma: Português do Brasil | [English](en/GETTING_STARTED.md)

Este guia é para quem quer instalar sem entender todos os detalhes internos do
projeto. A trilha recomendada usa `setup.ps1`, que faz perguntas, roda
validações e chama os scripts seguros do repositório.

## Caminho Mais Fácil

Abra PowerShell na pasta do repositório e rode:

```powershell
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1
```

O setup guiado vai perguntar se você quer:

| Pergunta | Recomendação | O que acontece |
| --- | --- | --- |
| Instalar dependências ausentes com `winget` | Sim | Instala PowerShell 7, Git, Windows Terminal e oh-my-posh quando faltarem. |
| Abrir página do Nerd Fonts | Sim se a fonte faltar | Você baixa `FiraCode Nerd Font` e seleciona no Windows Terminal. |
| Instalar profile, tema e regras | Sim | Copia os arquivos para a pasta certa do PowerShell 7. |
| Mesclar Windows Terminal | Sim para experiência completa | Cria backup do `settings.json`, valida JSON e adiciona perfil `dev`. |

## Cinco Comandos Para Quem Tem Pressa

```powershell
git clone git@github.com:bieltrue95/cyberpunk-pwsh-terminal.git
cd cyberpunk-pwsh-terminal
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1
wt -p dev
```

Se você ainda não tem chave SSH no GitHub, clone por HTTPS:

```powershell
git clone https://github.com/bieltrue95/cyberpunk-pwsh-terminal.git
```

## Pré-Requisitos Em Linguagem Simples

Obrigatórios para instalar o profile:

| Item | Como verificar | Se faltar |
| --- | --- | --- |
| Windows 10/11 | `winver` | Use Windows 10 ou 11. |
| PowerShell 7 | `pwsh --version` | `winget install Microsoft.PowerShell` |
| Git | `git --version` | `winget install Git.Git` |

Obrigatórios para o visual ficar bonito:

| Item | Como verificar | Se faltar |
| --- | --- | --- |
| Windows Terminal | `wt --version` | `winget install Microsoft.WindowsTerminal` |
| FiraCode Nerd Font | Fonte selecionável no Terminal | Baixe em Nerd Fonts e selecione no perfil `dev`. |
| oh-my-posh | `oh-my-posh --version` | `winget install JanDeDobbeleer.OhMyPosh -s winget` |

## Se Der Ruim, Faça Isto Primeiro

1. Abra PowerShell 7 sem carregar profile:

```powershell
pwsh -NoLogo -NoProfile
```

2. Entre na pasta do repo e rode o diagnóstico:

```powershell
cd cyberpunk-pwsh-terminal
.\scripts\check.ps1
```

3. Veja onde estão os backups e restaure se precisar:

```powershell
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.bak-*"
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.backup-before-uninstall-*"
```

4. Leia o guia completo: [Backup e restauração](BACKUP_RESTORE.md).

## O Que Não É Automático

- A fonte pode precisar ser instalada manualmente e selecionada no Windows Terminal.
- O clone por SSH exige chave cadastrada no GitHub; HTTPS funciona sem SSH.
- O `setup.ps1` não apaga seus backups antigos.
- O Windows Terminal só é alterado se você aceitar a pergunta de merge ou usar `-ConfigureWindowsTerminal`.

## Comandos Úteis Depois De Instalar

```powershell
ll ~
hist -Last 20
hfind git
ccurl --version
```

Se os ícones aparecerem como quadrados, o problema quase sempre é fonte: selecione
`FiraCode Nerd Font Mono` no perfil `dev` do Windows Terminal.
