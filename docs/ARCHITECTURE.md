# Arquitetura

Idioma: Português do Brasil | [English](en/ARCHITECTURE.md)

O projeto é dividido em partes pequenas para permitir evolução visual sem
transformar o profile do PowerShell em um bloco difícil de manter.

## Partes Principais

```text
data\cyber-item-rules.psd1
profile\Microsoft.PowerShell_profile.ps1
scripts\check.ps1
scripts\merge-windows-terminal.ps1
terminal\windows-terminal-snippet.json
themes\cyberpunk-clean.omp.json
```

## Fluxo De Inicialização Do Profile

1. Configura histórico e atalhos do PSReadLine.
2. Carrega regras de ícones e cores de `data\cyber-item-rules.psd1`.
3. Registra `ls`, `dir`, `l` e `ll` como renderers visuais.
4. Registra helpers como `hist`, `hfind` e `ccurl`.
5. Inicializa oh-my-posh quando disponível.

## Resolução De Regras

Para cada item do sistema de arquivos, o renderer resolve ícone e cor nesta
ordem:

1. Fallback para links.
2. Regras regex para diretórios.
3. Regras regex para nomes de arquivos.
4. Mapas por extensão.
5. Fallback padrão para pasta/arquivo.

Isso mantém casos comuns rápidos e facilita contribuições apenas em dados.

## Por Que Não Usar Terminal-Icons?

Terminal-Icons é um bom módulo, mas este setup evita depender dele em tempo de
execução. O ambiente original teve instabilidade com cache do módulo, então o
renderer virou autocontido para ter startup previsível e facilitar distribuição
no GitHub.

## Por Que Usar Write-Host?

O `ls` customizado é propositalmente um comando visual. Ele pinta colunas e nomes
com sequências ANSI RGB, então é otimizado para leitura humana no terminal.

Para scripts e pipeline, use comandos nativos:

```powershell
Get-ChildItem | Where-Object Extension -eq '.ps1'
```

## Segurança Do Instalador

O instalador copia arquivos para o diretório de profile do usuário atual e cria
backup do profile existente antes de substituir.

As configurações do Windows Terminal não são alteradas por padrão. O script de
merge é opcional e faz:

1. Lê o `settings.json` existente.
2. Lê `terminal\windows-terminal-snippet.json`.
3. Substitui ou adiciona apenas o perfil `dev` e o esquema `Cyberpunk2026`.
4. Valida o JSON.
5. Cria backup com timestamp.
6. Escreve o arquivo mesclado.
