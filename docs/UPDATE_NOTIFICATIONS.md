# Notificações de Atualização

Idioma: Português do Brasil | [English](en/UPDATE_NOTIFICATIONS.md)

O Cyberpunk Terminal automaticamente verifica se há novas versões disponíveis e notifica você uma vez por dia.

---

## 🔔 Como Funciona

### Verificação Automática

Quando você abre um novo terminal PowerShell:

1. **Verificação silenciosa** — O script `check-update.ps1` verifica o GitHub discretamente
2. **Uma notificação por dia** — Você só recebe notificação uma vez por dia, mesmo que abra múltiplos terminais
3. **Sem bloqueios** — A verificação é não-bloqueante; seu terminal abre normalmente enquanto a verificação acontece

### Opções de Notificação

Se houver uma atualização disponível, você verá:

#### Windows Toast Notification (Automática)
Aparece no canto inferior da tela como uma notificação do Windows:
```
┌──────────────────────────────┐
│ 🔔 Cyberpunk Terminal Update  │
│ Nova atualização: v2.1 → v2.2 │
│                               │
│  [Ver Detalhes]  [Ignorar]    │
└──────────────────────────────┘
```

Se o Toast não funcionar (sistemas antigos), você verá uma caixa colorida no console:
```
╔════════════════════════════════════════════════════╗
║  🔔 ATUALIZAÇÃO DISPONÍVEL                        ║
║                                                    ║
║  Versão atual: v2.1.0                            ║
║  Versão nova:  v2.2.0                            ║
║                                                    ║
║  Digite: update-check                             ║
║  para ver detalhes e atualizar                     ║
║                                                    ║
╚════════════════════════════════════════════════════╝
```

---

## 📋 Ver Detalhes da Atualização

Para ver o changelog completo e os detalhes da nova versão, use:

```powershell
update-check
```

Isso mostra:
- Versão atual vs nova
- Link para o changelog completo no GitHub
- Comando para instalar a atualização

---

## ⬆️ Instalar Atualização

Para instalar a nova versão:

### Opção 1: Scripts Guiados (Recomendado)

```powershell
.\update.ps1
```

O script `update.ps1` faz:
- ✅ Backup seguro do seu profile
- ✅ Pull da nova versão do Git
- ✅ Validação de integridade
- ✅ Reinstalação segura do profile
- ✅ Diagnóstico automático

### Opção 2: Atualização Manual

Se preferir controlar manualmente:

```powershell
git pull origin main
.\install.ps1
```

---

## 🔍 Verificação Manual

Para verificar se há atualizações sem esperar pela notificação automática:

```powershell
update-check -Force
```

---

## 🚫 Desabilitar Notificações

Se você não quer ser notificado automaticamente, há duas opções:

### Opção 1: Silenciar Por Um Dia

Ignore a notificação e ela não aparecerá novamente até amanhã.

### Opção 2: Desabilitar Completamente

Edite seu profile e comente a última linha:

```powershell
# Comentar esta linha desabilita notificações automáticas:
# Check-CyberUpdate -ErrorAction SilentlyContinue
```

Você ainda pode usar `update-check` manualmente quando quiser.

---

## 📁 Arquivos de Controle

A verificação de atualização usa estes arquivos temporários:

| Arquivo | Localização | Propósito |
| --- | --- | --- |
| `cyberpunk-notification-date.txt` | `%TEMP%` | Rastreia a data da última notificação |
| `cyberpunk-last-update-check.txt` | `%TEMP%` | Armazena resultado da última verificação |

Esses arquivos são automaticamente limpos durante a desinstalação.

---

## ❓ Solução de Problemas

### A verificação está muito lenta

A primeira verificação pode levar alguns segundos. Se persistir:

```powershell
# Verifique sua conexão de internet
ping github.com

# Teste a API do GitHub manualmente
Invoke-RestMethod https://api.github.com
```

### Toast notification não aparece

Isso é comum em sistemas antigos. O script mostrar a mensagem no console automaticamente.
Para testar manualmente:

```powershell
# Teste a notificação
$today = Get-Date -Format 'yyyy-MM-dd'
$notificationFile = Join-Path $env:TEMP 'cyberpunk-notification-date.txt'
Remove-Item -Path $notificationFile -ErrorAction SilentlyContinue

# Abra um novo terminal para ver a notificação
```

### Verificação falha com erro de permissão

Garanta que `%TEMP%` (pasta temporária do Windows) tem permissão de escrita:

```powershell
# Teste se consegue escrever em %TEMP%
$testFile = Join-Path $env:TEMP 'test-write.txt'
'test' | Set-Content -Path $testFile -Force
Remove-Item -Path $testFile -Force
```

---

## 📚 Veja Também

- [Update Scripts](./UPDATE_SCRIPTS.md) — Scripts de atualização detalhados
- [Uninstall Guide](./UNINSTALL_GUIDE.md) — Como desinstalar completamente
- [Backup & Restore](./BACKUP_RESTORE.md) — Backup e restauração de perfil
