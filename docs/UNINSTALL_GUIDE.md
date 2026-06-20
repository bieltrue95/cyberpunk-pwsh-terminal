# Guia de Desinstalação

Idioma: Português do Brasil | [English](en/UNINSTALL_GUIDE.md)

Aprenda como remover completamente o Cyberpunk PowerShell Terminal da sua máquina.

---

## ⚠️ Antes de Começar

Desinstalar remove:
- ✅ Profile do PowerShell
- ✅ Tema do oh-my-posh
- ✅ Regras de ícones e cores
- ✅ Histórico de comandos (opcional)
- ❌ **NÃO** remove oh-my-posh ou PowerShell 7 (devem ser removidos manualmente se desejar)
- ❌ **NÃO** remove configurações do Windows Terminal (devem ser ajustadas manualmente)

---

## 🚀 Desinstalação Rápida

### Passo 1: Abra PowerShell

Clique no menu Iniciar e procure por **PowerShell** (branco).

### Passo 2: Navegue até o Projeto

```powershell
cd caminho\para\cyberpunk-pwsh-terminal
```

### Passo 3: Execute a Desinstalação

```powershell
.\uninstall.ps1
```

**Pronto!** O script remove o profile Cyberpunk e cria um backup automaticamente.

---

## 📋 Desinstalação com Checklist Completo

Para uma verificação detalhada de tudo que será removido, use:

```powershell
.\uninstall.ps1 -WithChecklist
```

Isso mostra um checklist visual:

```
╔═══════════════════════════════════════════════════╗
║   Cyberpunk Terminal - Uninstall Checklist       ║
╚═══════════════════════════════════════════════════╝

==> Iniciando desinstalação...

ℹ️  Verificando profile...
✅ Profile encontrado: C:\Users\...\profile.ps1
✅ É um profile Cyberpunk válido

ℹ️  Verificando tema...
✅ Tema encontrado: C:\Users\...\themes\cyberpunk-clean.omp.json

... (mais itens)

Itens a serem removidos:
  • Profile: C:\Users\...\profile.ps1
  • Tema: C:\Users\...\themes\cyberpunk-clean.omp.json
  • Dados: C:\Users\...\data

Deseja prosseguir com a desinstalação? (s/N)
```

Após confirmar (`s`), o script:
1. Faz backup de tudo em uma pasta segura
2. Remove os itens
3. Mostra um checklist final confirmando o que foi removido
4. Guarda o backup para restauração emergencial

---

## 🔧 Opções Avançadas

### Remover Tema e Dados

Por padrão, apenas o profile é removido. Para remover tudo:

```powershell
.\uninstall.ps1 -RemoveTheme -RemoveData
```

### Forçar Desinstalação

Se o script não conseguir confirmar que é um profile Cyberpunk:

```powershell
.\uninstall.ps1 -Force
```

⚠️ **Use apenas se tiver certeza!** Isso remove o arquivo sem validar.

### Desinstalar de Outro Caminho de Profile

Se seu profile está em um caminho customizado:

```powershell
.\uninstall.ps1 -TargetProfilePath "C:\caminho\customizado\profile.ps1"
```

---

## 💾 Backups

A desinstalação **SEMPRE** faz backup antes de remover:

### Localização do Backup

Quando você executa desinstalar, os backups vão para:

```
C:\Users\<SeuNome>\Documents\PowerShell\cyberpunk-backup-YYYYMMDD-HHMMSS\
```

Contém:
- `profile.ps1` — Seu profile Cyberpunk
- `themes/` — Temas
- `data/` — Regras de ícones

### Restaurar do Backup

Se precisar restaurar (por exemplo, desinstalou por engano):

```powershell
# 1. Encontre a pasta de backup
$backups = Get-ChildItem "C:\Users\$env:USERNAME\Documents\PowerShell" -Filter "cyberpunk-backup-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# 2. Restaure o profile
Copy-Item -Path "$($backups.FullName)\profile.ps1" -Destination $PROFILE -Force

# 3. Recarregue
. $PROFILE
```

---

## 🧹 Limpeza Completa

Para remover **TUDO** incluindo oh-my-posh e PowerShell 7:

### Passo 1: Desinstalar Cyberpunk

```powershell
.\uninstall.ps1 -WithChecklist -RemoveTheme -RemoveData
```

### Passo 2: Remover oh-my-posh (Opcional)

```powershell
winget uninstall JanDeDobbeleer.OhMyPosh
```

### Passo 3: Remover PowerShell 7 (Opcional)

```powershell
winget uninstall Microsoft.PowerShell
```

### Passo 4: Remover Windows Terminal Preview (Opcional)

```powershell
winget uninstall Microsoft.WindowsTerminalPreview
```

### Passo 5: Limpar Arquivos Temporários

```powershell
# Remove histórico do PowerShell
$historyFile = Join-Path $env:APPDATA 'Microsoft\PowerShell\PSReadLine\ConsoleHost_history.txt'
if (Test-Path $historyFile) { Remove-Item $historyFile -Force }

# Remove arquivos de notificação de atualização
$tempFiles = @(
    (Join-Path $env:TEMP 'cyberpunk-last-update-check.txt'),
    (Join-Path $env:TEMP 'cyberpunk-notification-date.txt')
)
$tempFiles | Where-Object { Test-Path $_ } | Remove-Item -Force
```

---

## 🔍 Verificar se Foi Desinstalado

Para confirmar que a desinstalação foi bem-sucedida:

```powershell
# Verifique se o profile Cyberpunk foi removido
Test-Path $PROFILE

# Verifique se a pasta de temas foi removida
$profileDir = Split-Path -Parent $PROFILE
Test-Path (Join-Path $profileDir 'themes')

# Verifique se os dados foram removidos
Test-Path (Join-Path $profileDir 'data')

# Se todos retornarem False, foi desinstalado com sucesso!
```

---

## ⚡ Restaurar do Windows Terminal

Se você usava o profile `dev` no Windows Terminal Preview:

1. Abra **Windows Terminal Preview**
2. Clique em **⚙️ Configurações** (canto inferior esquerdo)
3. Vá para **Profiles** (esquerda)
4. Encontre o profile **dev**
5. Clique em **🗑️ Deletar** (botão inferior)

---

## 🆘 Problemas na Desinstalação

### "Profile não parece ser Cyberpunk"

Se o script diz que o profile não é Cyberpunk:

```powershell
# Opção 1: Verificar o profile manualmente
cat $PROFILE | Select-String "Cyberpunk"

# Opção 2: Forçar remoção (CUIDADO!)
.\uninstall.ps1 -Force
```

### "Permissão negada ao remover"

Se os arquivos não podem ser deletados (arquivo em uso):

```powershell
# 1. Abra PowerShell SEM CARREGAR O PROFILE
pwsh -NoLogo -NoProfile

# 2. Navegue até o projeto
cd caminho\para\cyberpunk-pwsh-terminal

# 3. Tente desinstalar novamente
.\uninstall.ps1
```

### "Backup falhou"

Se não consegue fazer backup:

```powershell
# Crie o diretório manualmente
$profileDir = Split-Path -Parent $PROFILE
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null

# Tente novamente
.\uninstall.ps1
```

---

## 📚 Veja Também

- [Update Notifications](./UPDATE_NOTIFICATIONS.md) — Sistema de notificações automáticas
- [Backup & Restore](./BACKUP_RESTORE.md) — Guia completo de backup
- [Troubleshooting](./TROUBLESHOOTING.md) — Solução de problemas
- [Getting Started](./GETTING_STARTED.md) — Como reinstalar depois
