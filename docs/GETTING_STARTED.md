# Comece Aqui

Idioma: Português do Brasil | [English](en/GETTING_STARTED.md)

Guia rápido e prático para instalar o Cyberpunk PowerShell Terminal. Cada etapa é numerada e cada comando está isolado para copiar facilmente.

---

## ⚡ A Forma Mais Rápida (Recomendado)

Se você quer instalar tudo de uma vez com o setup guiado, siga este caminho:

### Passo 1: Abra PowerShell

Clique no menu Iniciar do Windows, procure por **PowerShell** (branco/padrão) ou **cmd.exe** e abra.

### Passo 2: Navegue até a Pasta do Projeto

Se você já clonou o repositório, copie e cole:

```powershell
cd caminho\para\cyberpunk-pwsh-terminal
```

Se ainda não clonou, use este comando (copiar e colar):

```powershell
git clone https://github.com/bieltrue95/cyberpunk-pwsh-terminal.git
cd cyberpunk-pwsh-terminal
```

### Passo 3: Instale Windows Terminal Preview (IMPORTANTE!)

⚠️ **Este projeto requer Windows Terminal Preview, NÃO a versão estável!**

Abra PowerShell e copie/cole:

```powershell
winget install Microsoft.WindowsTerminalPreview
```

**Por que Preview?** A versão estável do Windows Terminal não tem suporte completo para todos os recursos que o projeto usa (esquemas de cores, acrylic transparency, e outros).

Se já tem Windows Terminal estável instalado, tudo bem - apenas instale o Preview também (funcionam em paralelo).

### Passo 4: Rode o Setup Guiado

Copie e cole este comando no PowerShell:

```powershell
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1
```

O setup vai fazer perguntas. Responda **S** (Sim) para as perguntas padrão:

| Pergunta | Responda | Por quê |
| --- | --- | --- |
| Instalar dependências ausentes? | S | Instala PowerShell 7, Git, oh-my-posh (se faltarem) |
| Abrir página Nerd Fonts? | S | Você baixa a fonte para os ícones renderizarem |
| Instalar profile? | S | Copia os arquivos para a pasta certa |
| Mesclar Windows Terminal Preview? | S | Configura o perfil `dev` no Preview automaticamente |

### Passo 5: Abra o Windows Terminal Preview Customizado

Depois que o setup terminar:

1. Procure **Windows Terminal Preview** no menu Iniciar (ícone preto com símbolo ">_")
2. Clique para abrir
3. Clique na seta ao lado das abas, no topo
4. Selecione o perfil **dev**
5. Você verá o prompt cyberpunk funcionando!

**Pronto!** 🎉

---

## 📋 Alternativa: Instalação Passo-a-Passo (Para Iniciantes)

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

## 📦 Pré-Requisitos

### ✅ OBRIGATÓRIOS (Precisam estar instalados)

| Item | Verificar | Se Não Tiver |
|------|-----------|--------------|
| **Windows 10/11** | Clique em Iniciar → Configurações → Sistema → Sobre | Atualize seu Windows |
| **PowerShell 7** | Abra PowerShell e digite: `pwsh --version` | Instale com: `winget install Microsoft.PowerShell` |
| **Git** | Abra PowerShell e digite: `git --version` | Instale com: `winget install Git.Git` |

### 🎨 RECOMENDADOS (Para visual completo)

| Item | Verificar | Se Não Tiver |
|------|-----------|--------------|
| **Windows Terminal Preview** ⚠️ | Procure "Terminal Preview" no menu Iniciar (ícone >_) | Instale com: `winget install Microsoft.WindowsTerminalPreview` |
| **FiraCode Nerd Font** | Abra Terminal Preview → ⚙️ Settings → dev profile → Font name | Baixe em [nerdfonts.com](https://nerdfonts.com) e selecione |
| **oh-my-posh** | Abra PowerShell e digite: `oh-my-posh --version` | Instale com: `winget install JanDeDobbeleer.OhMyPosh -s winget` |

⚠️ **IMPORTANTE:** Use **Windows Terminal Preview** (não a versão estável). A versão estável não tem suporte completo para este projeto. Elas podem coexistir no seu computador.

**Nota:** O instalador `setup.ps1` pode instalar automaticamente as dependências se você responder "Sim" à primeira pergunta.

## ⚠️ Se Der Problema

### ❌ Erro: "Ícones aparecem como quadrados/pontos"

**Causa:** A fonte FiraCode Nerd Font Mono não está instalada ou selecionada.

**Solução:**
1. Baixe a fonte em [nerdfonts.com](https://nerdfonts.com) (procure por FiraCode)
2. Descompacte e instale todos os arquivos `.ttf`
3. Abra **Windows Terminal Preview** (não o estável!)
4. Clique em ⚙️ (Settings) no canto superior direito
5. No menu esquerdo, procure por **dev** (em Profiles)
6. Procure por **Font name** e selecione `FiraCode Nerd Font Mono`
7. Clique Save

Os ícones devem aparecer coloridos agora.

---

### ❌ Erro: "Instalei Windows Terminal mas não funciona"

**Causa:** Você instalou a versão **estável**, mas o projeto usa **Preview**.

**Solução:**

Abra PowerShell e instale a versão Preview:

```powershell
winget install Microsoft.WindowsTerminalPreview
```

Ambas as versões podem coexistir. Use apenas o **Preview** para este projeto.

Para verificar qual está aberta, procure no menu Iniciar:
- ❌ "Windows Terminal" (versão estável)
- ✅ "Windows Terminal Preview" (versão que você precisa)

---

### ❌ Erro: "PowerShell não reconhece comando pwsh"

**Causa:** PowerShell 7 não está instalado.

**Solução:**

Abra PowerShell comum (branco) ou cmd.exe e copie/cole:

```powershell
winget install Microsoft.PowerShell
```

Aguarde terminar e feche a janela. Abra uma nova e tente novamente.

---

### ❌ Erro: "Setup.ps1 não executou"

**Causa:** Policy de execução bloqueando scripts.

**Solução:**

Abra PowerShell como **Administrador** e copie/cole:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Responda `Y` (Sim) e tente o setup novamente.

---

### ❌ Erro: "Terminal parece quebrado depois de instalar"

**Causa:** Arquivo de profile estava corrupto ou backup foi necessário.

**Solução:**

Abra PowerShell 7 (sem carregar profile):

```powershell
pwsh -NoLogo -NoProfile
```

Rode o diagnóstico:

```powershell
cd caminho\para\cyberpunk-pwsh-terminal
.\scripts\check.ps1
```

Se der erro, veja os backups:

```powershell
Get-ChildItem -LiteralPath (Split-Path -Parent $PROFILE) -Filter "*.bak-*"
```

Para restaurar um backup, veja [Backup e Restauração](BACKUP_RESTORE.md).

---

### 🆘 Problema Não Listado?

1. Verifique [Troubleshooting Completo](TROUBLESHOOTING.md)
2. Rode o diagnóstico: `.\scripts\check.ps1`
3. Abra uma issue no GitHub com o erro exato

---

## ✨ Próximos Passos Depois de Instalar

Seu terminal agora está pronto! Experimente estes comandos:

**Ver arquivos com ícones coloridos:**
```powershell
ll ~
```

**Ver últimos 20 comandos salvos:**
```powershell
hist -Last 20
```

**Buscar um comando específico:**
```powershell
hfind git
```

**Usar curl diretamente (sem conflito com PowerShell):**
```powershell
ccurl --version
```

---

## 📚 Documentação Completa

- **Instalação Manual:** [INSTALL.md](INSTALL.md)
- **Backup e Recuperação:** [BACKUP_RESTORE.md](BACKUP_RESTORE.md)
- **Solução de Problemas:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Arquitetura:** [ARCHITECTURE.md](ARCHITECTURE.md)
- **Como Contribuir:** [../CONTRIBUTING.md](../CONTRIBUTING.md)

---

## 🎯 Customizações Comuns

### Mudar Cores dos Ícones

Edite o arquivo:
```
~\Documents\PowerShell\data\cyber-item-rules.psd1
```

### Mudar o Tema do Prompt

Edite o arquivo:
```
~\Documents\PowerShell\themes\cyberpunk-clean.omp.json
```

### Desinstalar Tudo

Na pasta do projeto, copie e cole:

```powershell
.\uninstall.ps1
```

O script vai remover os arquivos e criar um backup de segurança.

---

## 💡 Dicas

- ⚡ Use `ll` em vez de `ls` para saída mais compacta
- 🔍 `hist` mostra histórico persistente (não perde ao fechar)
- 📌 `hfind <termo>` busca rápido no histórico
- 🎨 Sem a FiraCode Nerd Font, os ícones aparecem como `?` mas tudo funciona
