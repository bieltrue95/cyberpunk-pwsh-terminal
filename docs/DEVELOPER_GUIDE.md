# Guia do Desenvolvedor - Cyberpunk PowerShell Terminal

Idioma: Português do Brasil | [English](en/DEVELOPER_GUIDE.md)

Documentação completa para dev junior entender e modificar o código do projeto.

---

## 📚 Estrutura do Projeto

```
cyberpunk-pwsh-terminal/
├── profile/
│   └── Microsoft.PowerShell_profile.ps1    ← Arquivo principal carregado ao abrir PowerShell
├── scripts/
│   ├── check-update.ps1                    ← Verifica atualizações no GitHub
│   ├── check.ps1                           ← Valida instalação
│   ├── uninstall-checklist.ps1             ← Checklist de desinstalação
│   ├── test-profile.ps1                    ← Testa se profile funciona
│   ├── performance-analysis.ps1            ← Mede velocidade
│   └── ...outros scripts
├── install.ps1                              ← Script de instalação
├── uninstall.ps1                            ← Script de desinstalação
├── update.ps1                               ← Script de atualização
├── data/
│   └── cyber-item-rules.psd1               ← Regras de ícones e cores
├── themes/
│   └── cyberpunk-clean.omp.json            ← Tema do oh-my-posh
├── docs/
│   ├── DEVELOPER_GUIDE.md                  ← Este arquivo
│   ├── GETTING_STARTED.md                  ← Como instalar
│   ├── UPDATE_NOTIFICATIONS.md             ← Sistema de atualizações
│   └── ...outros docs
└── terminal/
    └── windows-terminal-snippet.json       ← Config do Windows Terminal
```

---

## 🔧 Arquivo Principal: `profile/Microsoft.PowerShell_profile.ps1`

Este é o **coração do projeto**. Ele é executado automaticamente quando você abre o PowerShell.

### **Seção 1: Configuração de Histórico (Linhas 1-78)**

**O que faz:**
- Configura o PSReadLine (módulo que controla histórico e autocompletar do PowerShell)
- Define atalhos de teclado (Up/Down para buscar, Ctrl+R para reverter busca)
- Define cores neon para syntax highlighting

**Como modificar:**

#### Exemplo 1: Aumentar limite de histórico de 20000 para 50000 comandos
```powershell
# ANTES (linha 45):
Set-PSReadLineOption -MaximumHistoryCount 20000

# DEPOIS:
Set-PSReadLineOption -MaximumHistoryCount 50000
```

#### Exemplo 2: Trocar cor do comando de azul (#E6ECFF) para verde (#00FF00)
```powershell
# ANTES (linha 70):
Command          = '#E6ECFF'

# DEPOIS:
Command          = '#00FF00'
```

#### Exemplo 3: Adicionar novo atalho (Ctrl+L para limpar tela)
```powershell
# Adicione após linha 55:
Set-PSReadLineKeyHandler -Chord Ctrl+l -Function ClearScreen
```

---

### **Seção 2: Comando `hist` (Linhas 80-104)**

**O que faz:**
- Cria comando `hist` para ver histórico de comandos
- Permite buscar comandos por texto

**Exemplos de uso:**
```powershell
hist                    # Últimos 50 comandos
hist -Last 20           # Últimos 20 comandos
hist -Search "git"      # Comandos que contêm "git"
```

**Como modificar:**

#### Exemplo: Mudar limite padrão de 50 para 100 comandos
```powershell
# ANTES (linha 85):
[int]$Last = 50

# DEPOIS:
[int]$Last = 100
```

---

### **Seção 3: Função `hfind` (Linhas 106-111)**

**O que faz:**
- Atalho rápido para buscar no histórico
- É só um "alias" para `hist -Search`

**Exemplos de uso:**
```powershell
hfind docker            # Busca "docker" no histórico
hfind npm               # Busca "npm" no histórico
```

**Como modificar:**

#### Exemplo: Criar novo comando `gitfind` para git
```powershell
# Adicione após a função hfind:
function global:gitfind {
    param([Parameter(Mandatory)][string]$Text)
    hist -Search "git $Text" -Last 200
}

# Agora pode usar:
gitfind commit          # Busca "git commit" no histórico
```

---

### **Seção 4: Conversão de Cores (Linhas 113-123)**

**O que faz:**
- Converte cores hexadecimais (#RRGGBB) para código ANSI que o terminal entende
- Permite usar cores de 24 bits (16 milhões de cores) no terminal

**Como modificar:**

#### Exemplo: Criar novo padrão de cor
```powershell
# Adicione uma variável de cor personalizada:
$CyberMagenta = ConvertTo-CyberAnsi '#FF00FF'

# Use em:
Write-Host "Texto magenta" -ForegroundColor $CyberMagenta
```

---

### **Seção 5: Carregamento de Regras (Linhas 125-173)**

**O que faz:**
- Carrega arquivo `data/cyber-item-rules.psd1` que define:
  - Ícones para cada tipo de arquivo (.ps1, .json, etc)
  - Cores para pastas e arquivos

**Como modificar:**

#### Exemplo: Adicionar novo ícone para arquivos .go (Go language)
1. Abra `data/cyber-item-rules.psd1`
2. Encontre a seção `ExtensionIcons = @{ ... }`
3. Adicione:
```powershell
'.go' = ''  # Ícone Go (copie de uma fonte de ícones Nerd Font)
```

---

### **Seção 6: Comando `ls` Customizado (Linhas 278-360)**

**O que faz:**
- Replace o comando `ls` padrão por versão com ícones e cores
- Mostra pastas com ícones especiais, arquivos com cores diferentes
- Suporta flag `-a` para mostrar arquivos ocultos

**Exemplos de uso:**
```powershell
ls                      # Lista normal com ícones
ls -a                   # Inclui arquivos ocultos
ll                      # Alias para ls com flag -Force (arquivos ocultos)
```

**Como modificar:**

#### Exemplo: Adicionar coluna de tamanho do arquivo
Procure a função `Show-CyberChildItem` (linha ~280) e adicione:
```powershell
# Encontre onde printa o nome do arquivo (linha ~330):
Write-Host $item.Name -ForegroundColor $itemColor

# Adicione antes:
Write-Host ("{0,10}" -f $item.Length) -ForegroundColor Gray -NoNewline
```

---

### **Seção 7: oh-my-posh (Linhas 368-384)**

**O que faz:**
- Inicializa o prompt customizado com oh-my-posh
- Renderiza informações do Git, versões de linguagens, etc

**Como modificar:**

#### Exemplo: Usar tema diferente
```powershell
# ANTES (linha 380):
oh-my-posh init pwsh --config $themePath | Invoke-Expression

# DEPOIS (usar tema padrão "blue"):
oh-my-posh init pwsh | Invoke-Expression

# OU usar tema específico:
oh-my-posh init pwsh --config "C:\path\to\another\theme.json" | Invoke-Expression
```

---

### **Seção 8: Verificação de Atualização (Linhas 387-498)**

**O que faz:**
- Verifica se há nova versão do projeto no GitHub
- Mostra notificação toast (Windows 10+) ou aviso no console
- Roda em background para não bloquear o terminal

**Exemplos de uso:**
```powershell
update-check            # Ver se há atualização
update-check -Force     # Forçar verificação (ignora cache)
```

**Como modificar:**

#### Exemplo 1: Mudar frequência de cache de 6h para 24h
Abra `scripts/check-update.ps1` e encontre:
```powershell
# ANTES (linha ~52):
if ($cacheAge.TotalMinutes -lt 360) {  # 360 = 6 horas

# DEPOIS:
if ($cacheAge.TotalMinutes -lt 1440) {  # 1440 = 24 horas
```

#### Exemplo 2: Adicionar som quando atualização está disponível
Adicione na função `Check-CyberUpdate` (linha ~414):
```powershell
# Após detectar que há atualização:
[console]::beep(1000, 500)  # Tom de 1000Hz por 500ms
```

---

## 🔍 Script: `scripts/check-update.ps1`

**O que faz:**
- Verifica GitHub API para saber se há nova versão
- Implementa cache (6h) para não sobrecarregar API
- Retorna informações sobre versão atual vs nova

### **Seções principais:**

#### Seção 1: Validação Inicial (Linhas 1-45)
```powershell
# Verifica se arquivo VERSION existe
if (-not (Test-Path -LiteralPath $versionFile)) {
    Write-Error-Custom "VERSION file not found"
    return @{ UpdateAvailable = $false; Error = $true }
}
```

**Como modificar:** Adicionar validação de conexão diferente
```powershell
# Trocar de:
$null = Invoke-WebRequest -Uri "https://api.github.com" -TimeoutSec 5

# Para:
$null = Invoke-WebRequest -Uri "https://raw.githubusercontent.com" -TimeoutSec 5
```

#### Seção 2: Verificação de Cache (Linhas 47-90)
```powershell
# Se arquivo de cache existe e tem menos de 6 horas:
if ($cacheAge.TotalMinutes -lt 360) {
    return @{ ... }  # Retorna resultado em cache
}
```

**Como modificar:** Debugar se cache está sendo usado
```powershell
# Adicione após linha 60:
Write-Host "Cache válido! Saltando API call..." -ForegroundColor Green
```

---

## 📝 Script: `install.ps1`

**O que faz:**
- Copia profile, tema e regras para pasta do PowerShell do usuário
- Faz backup automático de profile antigo
- Configura Windows Terminal (opcional)

### **Fluxo principal:**

```
1. Verifica pré-requisitos (PowerShell 7, oh-my-posh, fonts)
   ↓
2. Cria pasta de destino
   ↓
3. Faz backup do profile antigo
   ↓
4. Copia arquivos:
   - profile
   - theme
   - data/rules
   ↓
5. (Opcional) Configura Windows Terminal
```

**Como modificar:**

#### Exemplo: Adicionar instalação de extensão PowerShell
```powershell
# Adicione ao final do script (antes de "Install complete"):
Write-Step "Installing PowerShell modules"
Install-Module PSReadLine -Force
```

---

## 🗑️ Script: `uninstall.ps1`

**O que faz:**
- Remove profile do PowerShell
- Remove tema e dados (opcional)
- Faz backup antes de remover

### **Fluxo:**

```
1. Valida que é um profile Cyberpunk
   ↓
2. Faz backup completo
   ↓
3. Remove arquivos:
   - Profile
   - Tema (se -RemoveTheme)
   - Dados (se -RemoveData)
```

**Como modificar:**

#### Exemplo: Adicionar remoção de arquivo de cache
```powershell
# Adicione após linha 51 (remover dados):
$cacheFile = Join-Path $env:TEMP 'cyberpunk-cache.json'
if (Test-Path -LiteralPath $cacheFile) {
    Remove-Item -LiteralPath $cacheFile -Force
}
```

---

## 🧪 Script: `scripts/check.ps1`

**O que faz:**
- Valida que tudo está instalado corretamente
- Verifica sintaxe dos scripts PowerShell
- Valida arquivos JSON

### **Checklist:**
- PowerShell 7+? ✓
- oh-my-posh instalado? ✓
- Font Nerd Font? ✓
- Sintaxe dos scripts? ✓
- JSON válido? ✓

**Como modificar:**

#### Exemplo: Adicionar check para Git
```powershell
# Adicione após verificação de PowerShell:
Write-Step "Checking Git"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Fail "Git not found in PATH"
    $failures++
} else {
    Write-Pass "Git found"
}
```

---

## 🎨 Arquivo: `data/cyber-item-rules.psd1`

**O que faz:**
- Define ícones para extensões de arquivo (.ps1, .json, etc)
- Define cores para tipos de arquivo e diretórios

### **Estrutura:**

```powershell
@{
    # Ícone padrão, cor padrão
    Defaults = @{
        FileIcon = ''
        DirectoryIcon = ''
        FileColor = '#E6ECFF'
        DirectoryColor = '#00E5FF'
    }

    # Regras por padrão (para nomes específicos)
    DirectoryColorRules = @(
        @{ Pattern = '^node_modules$'; Color = '#FF6B6B' }
    )

    # Ícones por extensão
    ExtensionIcons = @{
        '.ps1' = '󰨊'
        '.json' = ''
        '.git' = ''
    }
}
```

**Como modificar:**

#### Exemplo: Mudar cor de node_modules para vermelho
```powershell
# ANTES:
@{ Pattern = '^node_modules$'; Color = '#FF6B6B' }

# DEPOIS:
@{ Pattern = '^node_modules$'; Color = '#FF0000' }
```

#### Exemplo: Adicionar ícone para .go files
```powershell
# Adicione em ExtensionIcons:
'.go' = ''  # Ícone Go
```

---

## 🚀 Fluxo Completo de Uso

### **1. Instalação**
```powershell
pwsh -NoLogo -NoProfile -File .\setup.ps1
# Ou manual:
.\install.ps1
```

### **2. Abertura do Terminal**
```
PowerShell inicia
   ↓
Carrega Microsoft.PowerShell_profile.ps1
   ↓
PSReadLine configura histórico
   ↓
oh-my-posh renderiza prompt
   ↓
Check-CyberUpdate verifica atualização (em background)
   ↓
Terminal pronto para usar
```

### **3. Utilização**
```powershell
ls                   # Vê arquivos com ícones
hist -Search git     # Busca histórico
update-check         # Verifica atualização
```

### **4. Atualização**
```powershell
.\update.ps1         # Faz pull, reinstala
```

### **5. Desinstalação**
```powershell
.\uninstall.ps1 -WithChecklist   # Remove tudo com checklist
```

---

## 📊 Diagrama de Fluxo

```
┌─────────────────────────────────┐
│  Usuário abre PowerShell        │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ $PROFILE carrega:               │
│ Microsoft.PowerShell_profile.ps1│
└────────────┬────────────────────┘
             │
             ├─→ PSReadLine config
             ├─→ Aliases (ls, dir)
             ├─→ Funções (hist, hfind)
             ├─→ oh-my-posh init
             └─→ Check-CyberUpdate (async)
                        │
                        ↓
             ┌──────────────────────┐
             │ Verifica cache 6h    │
             └──────┬───────────────┘
                    │
          ┌─────────┴─────────┐
          │                   │
          ↓                   ↓
      Cache válido        Chama GitHub
      (retorna)           API
          │                   │
          │                   ↓
          │            Compara versão
          │                   │
          └─────────┬─────────┘
                    │
                    ↓
          ┌──────────────────────┐
          │ Há atualização?      │
          └──────┬───────┬──────┘
                 │       │
              SIM│       │NÃO
                 │       │
                 ↓       ↓
            Toast    Nada
           Notif.    acontece
```

---

## 🔧 Exemplos Práticos de Modificações

### **Exemplo 1: Adicionar novo alias**

Você quer adicionar comando `ll` (long list) = `ls` com detalhes extras.

**Arquivo:** `profile/Microsoft.PowerShell_profile.ps1`

**Código a adicionar (após linha 360):**
```powershell
# Alias 'll' mostra lista detalhada com tamanho
function global:ll-details {
    ls @args | Format-Table Name, Length, Mode, LastWriteTime
}

# Use como:
# ll-details C:\
```

### **Exemplo 2: Trocar cor do prompt**

**Arquivo:** `profile/Microsoft.PowerShell_profile.ps1`

Encontre linha ~380 onde oh-my-posh é inicializado:
```powershell
# Para usar tema "star" em vez de cyberpunk-clean:
oh-my-posh init pwsh --config "C:\Program Files\oh-my-posh\themes\star.omp.json" | Invoke-Expression
```

### **Exemplo 3: Adicionar função customizada**

```powershell
# Função para abrir arquivo no VSCode
function code-open {
    param([string]$Path)
    code $Path
}

# Use como:
code-open C:\Users\Gabriel\Documents\projeto
```

---

## 📖 Recursos Adicionais

- **PowerShell Docs:** https://docs.microsoft.com/powershell/
- **oh-my-posh:** https://ohmyposh.dev/
- **Nerd Fonts:** https://www.nerdfonts.com/
- **Windows Terminal:** https://github.com/microsoft/terminal

---

## ❓ Dúvidas Comuns

**P: Como mudar a fonte do terminal?**
R: Windows Terminal → Configurações → Perfil → Aparência → Fonte

**P: Como adicionar novo ícone?**
R: Edite `data/cyber-item-rules.psd1` e copie ícone de nerd fonts

**P: Como debugar se algo não funciona?**
R: Execute `.\scripts\check.ps1` para diagnóstico completo

---

**Última atualização:** 2026-06-20
**Versão do projeto:** 2.2.0
