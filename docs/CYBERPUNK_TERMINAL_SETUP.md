# Cyberpunk Terminal Setup

Este documento explica as modificacoes feitas no Windows Terminal e no PowerShell 7 para o perfil `dev`.

## Arquivos Principais

- `$PROFILE`
- `Windows Terminal settings.json`
- `<profile-dir>\themes\cyberpunk-clean.omp.json`
- `<profile-dir>\data\cyber-item-rules.psd1`
- `$env:APPDATA\Microsoft\PowerShell\PSReadLine\ConsoleHost_history.txt`

## Windows Terminal

- O perfil padrao e `dev`.
- O perfil `dev` executa `pwsh.exe -NoLogo`, removendo o banner inicial do PowerShell.
- A fonte configurada e `FiraCode Nerd Font Mono`.
- O tamanho da fonte do perfil `dev` esta em `14`.
- O tema de cores ativo e `Cyberpunk2026`.
- O perfil usa acrylic com `opacity` em `92`.
- A aba usa `tabTitle` fixo como `dev` e `suppressApplicationTitle` para evitar que o shell sobrescreva o titulo.

Observacao importante:

- O `settings.json` foi mantido sem comentarios. Embora o Windows Terminal aceite JSON com comentarios em muitos cenarios, manter o arquivo como JSON limpo reduz risco de erro de parsing.

## PowerShell Profile

O profile configura quatro areas principais:

- Historico e busca com `PSReadLine`.
- Listagem customizada com `ls`, `dir`, `l` e `ll`.
- Helper `ccurl` para chamar `curl.exe`.
- Prompt com `oh-my-posh` e tema `cyberpunk-clean.omp.json`.

## Historico

O historico persistente fica em:

```text
$env:APPDATA\Microsoft\PowerShell\PSReadLine\ConsoleHost_history.txt
```

Comportamento configurado:

- Salva comandos incrementalmente.
- Remove duplicados no historico.
- Mantem ate `20000` comandos.
- `UpArrow` busca comandos anteriores pelo prefixo digitado.
- `DownArrow` avanca na busca pelo prefixo digitado.
- `Ctrl+r` busca reversa no historico.
- `Ctrl+s` busca para frente no historico.
- `Ctrl+Spacebar` abre menu de completions.

Comandos adicionados:

```powershell
hist
hist -Last 20
hist -Search git
hfind docker
```

## Listagem Com Icones

O setup nao depende mais do modulo `Terminal-Icons` para renderizar `ls`.
O mapa atual usa uma estrategia Devicons-heavy e fica em `data\cyber-item-rules.psd1`.
Linguagens, frameworks e ferramentas de desenvolvimento recebem glyphs especificos
de Nerd Fonts/Devicons quando possivel.

Motivo:

- O modulo estava apresentando erros de `Import-Clixml` por cache XML corrompido.
- Para deixar o terminal previsivel, os icones e cores foram mapeados diretamente no profile.

Comandos substituidos:

```powershell
ls
dir
l
ll
```

Comportamento:

- `ls`, `dir` e `l` mostram itens normais.
- `ll` usa `-Force` e mostra itens ocultos.
- A coluna `Name` recebe icone e cor dinamica por pasta, arquivo ou extensao.
- A coluna `Mode` usa magenta neon.
- A coluna `LastWriteTime` usa azul eletrico.
- A coluna `Length` usa amarelo neon.
- O texto `Directory:` usa ciano neon.

Exemplos de icones mapeados:

- JavaScript, TypeScript, React, Vue, Angular.
- Docker, npm, yarn, pnpm, webpack, eslint, Firebase.
- Python, PHP, Go, Rust, Ruby, Java, C#, C/C++, Lua, Dart, Swift, Kotlin.
- Shell scripts, PowerShell, JSON, YAML, Markdown, imagens, videos e arquivos compactados.
- Pastas do Windows: `Windows`, `System32`, `Program Files`, `ProgramData`, `PerfLogs`, `inetpub`, `Recovery`, `$Recycle.Bin`.
- Pastas de usuario: `Desktop`, `Documents`, `Downloads`, `Pictures`, `Music`, `Videos`, `OneDrive`, `Saved Games`, `Searches`, `3D Objects`.
- Contexto de dev: `.git`, `.github`, `.gitlab`, `.vscode`, `.idea`, `src`, `dist`, `build`, `node_modules`, `.venv`, `coverage`, `docs`.
- Cloud/infra: `.aws`, `.azure`, `.docker`, `.kube`, `.terraform`, Dockerfile, Compose, Terraform, Bicep e pipelines.
- Office e produtividade: Word, Excel, PowerPoint, OneNote, Visio, PDF, CSV.
- Seguranca: `.env`, chaves, certificados, `.pem`, `.crt`, `.cer`, `.key`, `.pfx`, `.p12`.
- Midia e assets: PNG, JPG, GIF, WebP, SVG, MP3, WAV, FLAC, MP4, MKV, MOV, fontes e arquivos compactados.

Observacao:

- Nao existe um mapeamento perfeito para literalmente todos os 10.000+ glyphs de Nerd Fonts, porque o terminal so ve nome/extensao do item. O que foi implementado e uma cobertura por contexto: Windows, usuario, dev, cloud, Office, seguranca, midia, banco de dados e arquivos comuns. Tudo que nao casar recebe fallback consistente de pasta ou arquivo comum.

## Funcoes Do Renderer

`ConvertTo-CyberAnsi`

- Converte cor hex `#RRGGBB` em escape ANSI RGB.
- Usada para pintar texto com true color no Windows Terminal.

`Get-CyberItemIcon`

- Decide o icone de cada item.
- Carrega regras de `data\cyber-item-rules.psd1`.
- Primeiro verifica nomes especiais como `.vscode`, `Downloads`, `Program Files`, `.aws`, `.docker`, `src`, `build`.
- Depois verifica extensoes como `.json`, `.ps1`, `.png`, `.zip`, `.docx`, `.tf`, `.pem`, `.sqlite`.
- Usa fallback de pasta ou arquivo comum quando nada casa.

`Get-CyberItemColor`

- Decide a cor do item.
- Carrega cores de `data\cyber-item-rules.psd1`.
- Pastas especiais recebem cores por nome.
- Arquivos recebem cores por nome conhecido ou extensao.

`Format-CyberItemName`

- Junta icone, espaco e nome.
- Aplica a cor dinamica do item.

`Show-CyberChildItem`

- E o renderer principal de `ls`.
- Imprime cabecalho, colunas alinhadas, cores por coluna e nomes com icones.

## Curl

O profile preserva o comportamento padrao do PowerShell para `curl`.

Para chamar o binario real:

```powershell
ccurl --version
curl.exe --version
```

## Oh My Posh

O prompt usa:

```text
<profile-dir>\themes\cyberpunk-clean.omp.json
```

Esse tema fica separado do profile para permitir ajuste visual sem mexer na logica de historico/listagem.

## Como Validar

Recarregar profile na aba atual:

```powershell
. $PROFILE
```

Testar icones e cores:

```powershell
ls
ll ~
```

Testar historico:

```powershell
hist -Last 10
hfind ls
```

Testar aliases:

```powershell
Get-Command ls,dir,l,ll,hist,hfind,ccurl
```

Validar o `settings.json`:

```powershell
Get-Content -Raw "Windows Terminal settings.json" | ConvertFrom-Json | Out-Null
```

## Manutencao

- Para adicionar um icone novo, edite `data\cyber-item-rules.psd1`.
- Para adicionar uma cor nova, edite `data\cyber-item-rules.psd1`.
- Edite `Get-CyberItemIcon` ou `Get-CyberItemColor` somente se precisar mudar a logica de resolucao.
- Para mudar a cor das colunas, edite as variaveis dentro de `Show-CyberChildItem`.
- Para mudar fonte, tamanho, transparencia ou scheme, edite `settings.json`.
- Para mudar prompt, edite `cyberpunk-clean.omp.json`.

## Cuidados

- Nao reativar `Terminal-Icons` como dependencia do `ls` sem antes limpar e validar o cache do modulo.
- Nao remover `FiraCode Nerd Font Mono`, porque os icones dependem de Nerd Font.
- Nao trocar `pwsh.exe -NoLogo` por `powershell.exe`, senao volta para Windows PowerShell 5.1.
- Nao comentar diretamente o `settings.json` sem validar com o Windows Terminal.

