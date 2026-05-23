# PowerShell profile - Cyberpunk clean

<#
    Objetivo
    - Inicializar o terminal dev com visual cyberpunk limpo.
    - Configurar historico persistente e atalhos de busca.
    - Substituir ls/dir/l/ll por uma listagem customizada com icones Nerd Font,
      cores RGB por coluna e cores dinamicas por tipo de arquivo/pasta.
    - Manter um helper explicito para curl.exe sem alterar o alias curl do PowerShell.

    Observacoes para futuras pessoas ou IAs
    - Este arquivo e carregado pelo PowerShell 7 em:
      $PROFILE
    - O perfil do Windows Terminal dev aponta para pwsh.exe -NoLogo no settings.json.
    - A listagem customizada NAO depende mais de Terminal-Icons. O modulo estava
      instavel por cache XML corrompido, entao os icones foram mapeados aqui.
    - Os icones dependem da fonte FiraCode Nerd Font Mono configurada no Terminal.
    - Ao editar glyphs, mantenha o arquivo salvo como UTF-8.
#>

# Caminho unico usado pelo PSReadLine, pelo comando hist e pelo comando hfind.
# Deixar global evita duplicacao e facilita futuras alteracoes.
$global:CyberHistoryPath = Join-Path $env:APPDATA 'Microsoft\PowerShell\PSReadLine\ConsoleHost_history.txt'

# PSReadLine controla historico, busca incremental, autocomplete e predicoes.
# Algumas opcoes de predicao so funcionam em console interativo real; por isso
# elas ficam em try/catch para nao quebrar scripts ou shells nao interativos.
if (Get-Module -ListAvailable -Name PSReadLine) {
    $psrl = Get-Module -ListAvailable PSReadLine | Sort-Object Version -Descending | Select-Object -First 1
    Import-Module $psrl.Path -Force -ErrorAction SilentlyContinue

    # Garante que o arquivo de historico exista antes de o PSReadLine tentar usar.
    $historyDir = Join-Path $env:APPDATA 'Microsoft\PowerShell\PSReadLine'
    if (-not (Test-Path $historyDir)) {
        New-Item -ItemType Directory -Path $historyDir -Force | Out-Null
    }
    if (-not (Test-Path $global:CyberHistoryPath)) {
        New-Item -ItemType File -Path $global:CyberHistoryPath -Force | Out-Null
    }

    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineOption -HistorySavePath $global:CyberHistoryPath
    Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
    Set-PSReadLineOption -MaximumHistoryCount 20000
    Set-PSReadLineOption -HistoryNoDuplicates
    # Atalhos principais do historico:
    # - Up/Down procuram comandos anteriores com o mesmo prefixo digitado.
    # - Ctrl+r e Ctrl+s fazem busca textual no historico.
    # - Ctrl+Space abre menu de completions.
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord Ctrl+r -Function ReverseSearchHistory
    Set-PSReadLineKeyHandler -Chord Ctrl+s -Function ForwardSearchHistory
    Set-PSReadLineKeyHandler -Chord Ctrl+Spacebar -Function MenuComplete

    try {
        Set-PSReadLineOption -PredictionSource History
    } catch {
    }

    try {
        Set-PSReadLineOption -PredictionViewStyle ListView
    } catch {
    }

    try {
        Set-PSReadLineOption -Colors @{
            InlinePrediction = '#63F3FF'
            Command          = '#E6ECFF'
            Parameter        = '#55A8FF'
            Operator         = '#D600FF'
            String           = '#67FF9A'
            Number           = '#FFD166'
        }
    } catch {
    }
}

# Mostra os ultimos comandos salvos no arquivo persistente do PSReadLine.
# Exemplo: hist -Last 20
# Exemplo: hist -Search git
function global:hist {
    param(
        [int]$Last = 50,
        [string]$Search
    )

    if (-not (Test-Path $global:CyberHistoryPath)) {
        Write-Host 'History file not found yet.' -ForegroundColor Yellow
        return
    }

    $lines = @(Get-Content -LiteralPath $global:CyberHistoryPath -ErrorAction SilentlyContinue)
    if ($Search) {
        $lines = @($lines | Where-Object { $_ -like "*$Search*" })
    }

    $start = [Math]::Max(0, $lines.Count - $Last)
    for ($i = $start; $i -lt $lines.Count; $i++) {
        Write-Host ('{0,5}  ' -f ($i + 1)) -ForegroundColor DarkCyan -NoNewline
        Write-Host $lines[$i] -ForegroundColor Cyan
    }
}

# Atalho curto para buscar texto no historico salvo.
# Exemplo: hfind docker
function global:hfind {
    param([Parameter(Mandatory)][string]$Text)
    hist -Search $Text -Last 200
}

# Converte uma cor hex RGB (#RRGGBB) para sequencia ANSI true color.
# O Windows Terminal entende esse formato e renderiza neon com 24 bits.
function ConvertTo-CyberAnsi {
    param([Parameter(Mandatory)][string]$Hex)

    $clean = $Hex.TrimStart('#')
    $r = [Convert]::ToInt32($clean.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($clean.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($clean.Substring(4, 2), 16)
    "$([char]27)[38;2;$r;$g;$b`m"
}

# Resolve os caminhos do projeto/profile de forma portatil.
# - Rodando direto do repo: <repo>\profile\Microsoft.PowerShell_profile.ps1
# - Instalado:           <Documents>\PowerShell\Microsoft.PowerShell_profile.ps1
function Get-CyberProfileRoot {
    if ($PSScriptRoot) { return $PSScriptRoot }
    if ($PROFILE) { return (Split-Path -Parent ([string]$PROFILE)) }
    return (Get-Location).Path
}

# Carrega regras de icones e cores a partir de data/cyber-item-rules.psd1.
# O profile continua funcionando sem o arquivo de dados, mas nesse caso usa
# apenas fallbacks basicos. Isso evita que um erro de contribuicao quebre o shell.
function Import-CyberItemRules {
    $profileRoot = Get-CyberProfileRoot
    $repoRoot = Split-Path -Parent $profileRoot
    $candidates = @(
        (Join-Path $profileRoot 'data\cyber-item-rules.psd1'),
        (Join-Path $repoRoot 'data\cyber-item-rules.psd1')
    )

    foreach ($candidate in $candidates) {
        if (-not (Test-Path -LiteralPath $candidate)) { continue }
        try {
            return (Import-PowerShellDataFile -LiteralPath $candidate)
        } catch {
            Write-Warning "Could not load Cyberpunk item rules from '$candidate': $($_.Exception.Message)"
        }
    }

    return @{
        Defaults = @{
            LinkIcon = ''
            DirectoryIcon = ''
            FileIcon = ''
            DirectoryColor = '#00E5FF'
            FileColor = '#E6ECFF'
        }
        DirectoryIconRules = @()
        FileIconRules = @()
        ExtensionIcons = @{}
        DirectoryColorRules = @()
        FileColorRules = @()
        ExtensionColors = @{}
    }
}

# Fica global para facilitar debug interativo:
# $CyberItemRules.ExtensionIcons['.ps1']
$global:CyberItemRules = Import-CyberItemRules

function Get-CyberRuleDefault {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Fallback
    )

    $defaults = $global:CyberItemRules['Defaults']
    if ($defaults -and $defaults.ContainsKey($Name) -and $defaults[$Name]) {
        return [string]$defaults[$Name]
    }

    return $Fallback
}

function Find-CyberRuleValue {
    param(
        [object[]]$Rules,
        [Parameter(Mandatory)][string]$ItemName,
        [Parameter(Mandatory)][string]$ValueKey
    )

    foreach ($rule in @($Rules)) {
        if (-not $rule) { continue }
        $pattern = [string]$rule['Pattern']
        if ($pattern -and $ItemName -match $pattern) {
            return [string]$rule[$ValueKey]
        }
    }

    return $null
}

function Find-CyberExtensionValue {
    param(
        [hashtable]$Map,
        [string]$Extension
    )

    if (-not $Map -or -not $Extension) { return $null }

    $normalized = $Extension.ToLowerInvariant()
    if ($Map.ContainsKey($normalized)) {
        return [string]$Map[$normalized]
    }

    return $null
}

# Decide qual icone Nerd Font sera usado para cada item.
# A logica fica pequena de proposito; os padroes ficam em data/cyber-item-rules.psd1.
function Get-CyberItemIcon {
    param([Parameter(Mandatory)][System.IO.FileSystemInfo]$Item)

    if ($Item.LinkType) { return (Get-CyberRuleDefault -Name 'LinkIcon' -Fallback '') }

    if ($Item.PSIsContainer) {
        $folderIcon = Find-CyberRuleValue -Rules $global:CyberItemRules['DirectoryIconRules'] -ItemName $Item.Name -ValueKey 'Icon'
        if ($folderIcon) { return $folderIcon }
        return (Get-CyberRuleDefault -Name 'DirectoryIcon' -Fallback '')
    }

    $fileIcon = Find-CyberRuleValue -Rules $global:CyberItemRules['FileIconRules'] -ItemName $Item.Name -ValueKey 'Icon'
    if ($fileIcon) { return $fileIcon }

    $extensionIcon = Find-CyberExtensionValue -Map $global:CyberItemRules['ExtensionIcons'] -Extension $Item.Extension
    if ($extensionIcon) { return $extensionIcon }

    return (Get-CyberRuleDefault -Name 'FileIcon' -Fallback '')
}

# Decide a cor do nome do item.
# A paleta cyberpunk tambem vive em data/cyber-item-rules.psd1 para facilitar PRs.
function Get-CyberItemColor {
    param([Parameter(Mandatory)][System.IO.FileSystemInfo]$Item)

    if ($Item.PSIsContainer) {
        $folderColor = Find-CyberRuleValue -Rules $global:CyberItemRules['DirectoryColorRules'] -ItemName $Item.Name -ValueKey 'Color'
        if ($folderColor) { return $folderColor }
        return (Get-CyberRuleDefault -Name 'DirectoryColor' -Fallback '#00E5FF')
    }

    $fileColor = Find-CyberRuleValue -Rules $global:CyberItemRules['FileColorRules'] -ItemName $Item.Name -ValueKey 'Color'
    if ($fileColor) { return $fileColor }

    $extensionColor = Find-CyberExtensionValue -Map $global:CyberItemRules['ExtensionColors'] -Extension $Item.Extension
    if ($extensionColor) { return $extensionColor }

    return (Get-CyberRuleDefault -Name 'FileColor' -Fallback '#E6ECFF')
}

# Junta icone, espaco e nome do item, aplicando a cor dinamica do item.
# A cor das outras colunas e aplicada em Show-CyberChildItem.
function Format-CyberItemName {
    param([Parameter(Mandatory)][System.IO.FileSystemInfo]$Item)

    $name = "$(Get-CyberItemIcon $Item)  $($Item.Name)"

    "$(ConvertTo-CyberAnsi (Get-CyberItemColor $Item))$name$([char]27)[0m"
}

# Renderer customizado do ls/dir.
# Motivo: o formatter automatico de Terminal-Icons estava instavel neste ambiente.
# Esta funcao controla toda a tabela: cabecalho, colunas, alinhamento e cores.
function Show-CyberChildItem {
    $items = @(Get-ChildItem @args)
    if ($items.Count -eq 0) { return }

    $pathArg = @($args | Where-Object { $_ -is [string] -and $_ -notlike '-*' } | Select-Object -First 1)
    $directory = if ($pathArg) {
        $resolved = Resolve-Path -LiteralPath $pathArg -ErrorAction SilentlyContinue
        if ($resolved) { $resolved.ProviderPath } else { $pathArg }
    } else {
        (Get-Location).Path
    }

    # Paleta fixa das colunas. A coluna Name usa cor dinamica por item.
    $reset = "$([char]27)[0m"
    $modeColor = ConvertTo-CyberAnsi '#FF4DFF'
    $timeColor = ConvertTo-CyberAnsi '#55A8FF'
    $lengthColor = ConvertTo-CyberAnsi '#FFD166'
    $nameHeaderColor = ConvertTo-CyberAnsi '#67FF9A'
    $directoryColor = ConvertTo-CyberAnsi '#63F3FF'

    Write-Host ''
    Write-Host "$directoryColor    Directory: $directory$reset"
    Write-Host ''
    Write-Host "$modeColor$('Mode'.PadRight(8))$reset" -NoNewline
    Write-Host "$timeColor$('LastWriteTime'.PadRight(18))$reset" -NoNewline
    Write-Host "$lengthColor$('Length'.PadLeft(10)) $reset" -NoNewline
    Write-Host "$nameHeaderColor$('Name')$reset"
    Write-Host "$modeColor$('----'.PadRight(8))$reset" -NoNewline
    Write-Host "$timeColor$('-------------'.PadRight(18))$reset" -NoNewline
    Write-Host "$lengthColor$('------'.PadLeft(10)) $reset" -NoNewline
    Write-Host "$nameHeaderColor$('----')$reset"

    foreach ($item in $items) {
        $mode = $item.Mode
        $time = $item.LastWriteTime.ToString('dd/MM/yyyy HH:mm')
        $length = if ($item.PSIsContainer) { '' } else { $item.Length }
        $name = Format-CyberItemName $item
        Write-Host "$modeColor$(('{0,-7} ' -f $mode))$reset" -NoNewline
        Write-Host "$timeColor$(('{0,-17} ' -f $time))$reset" -NoNewline
        Write-Host "$lengthColor$(('{0,10} ' -f $length))$reset" -NoNewline
        Write-Host $name
    }
}

# Remove aliases padrao de ls/dir e registra comandos globais customizados.
# l e ll sao atalhos: ll inclui itens ocultos por usar -Force.
Remove-Item Alias:ls, Alias:dir -Force -ErrorAction SilentlyContinue
function global:ls { Show-CyberChildItem @args }
function global:dir { Show-CyberChildItem @args }
function global:l { Show-CyberChildItem @args }
function global:ll { Show-CyberChildItem -Force @args }

# Mantem curl como comportamento padrao do PowerShell, mas oferece ccurl para
# chamar explicitamente o binario nativo curl.exe quando necessario.
function ccurl {
    & curl.exe @args
}

# Inicializa oh-my-posh com o tema local minimalista cyberpunk.
# O tema fica separado para permitir ajuste visual sem mexer na logica do profile.
$posh = Get-Command oh-my-posh -ErrorAction SilentlyContinue
if ($posh) {
    $profileRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent ([string]$PROFILE) }
    $repoRoot = Split-Path -Parent $profileRoot
    $themeCandidates = @(
        (Join-Path $profileRoot 'themes\cyberpunk-clean.omp.json'),
        (Join-Path $repoRoot 'themes\cyberpunk-clean.omp.json')
    )
    $themePath = $themeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($themePath -and (Test-Path $themePath)) {
        oh-my-posh init pwsh --config $themePath | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
    }
}

