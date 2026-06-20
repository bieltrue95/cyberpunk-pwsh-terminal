# Cyberpunk PowerShell Terminal - Visual Diagrams

Idioma: Português do Brasil | [English](en/DIAGRAMS.md)

Diagramas visuais criados em ASCII para visualizar a arquitetura e fluxos do projeto.

---

## 📊 Diagramas Disponíveis

### 1. **Fluxo Completo do Projeto** (Complete Flow)

Mostra as três fases principais: Instalação → Runtime → Desinstalação

```
┌─────────────────────────────────────────────────────────────┐
│         CYBERPUNK TERMINAL - COMPLETE SYSTEM FLOW           │
│                                                             │
│  ┌──────────┐        ┌──────────┐        ┌──────────┐     │
│  │ 1.INSTALL│        │2.RUNTIME │        │3.UNINSTAL│     │
│  │ install  │        │ Profile  │        │ uninstall│     │
│  │ .ps1     │        │ load     │        │ .ps1     │     │
│  └─────┬────┘        └────┬─────┘        └────┬─────┘     │
│        │                  │                    │            │
│        ↓                  ↓                    ↓            │
│  ┌──────────┐        ┌──────────┐        ┌──────────┐     │
│  │Copy Files│        │ Commands │        │ Restore  │     │
│  │ Theme    │        │ Ready    │        │ Backup   │     │
│  │ Rules    │        │ls,hist.. │        │ Clean    │     │
│  └──────────┘        └──────────┘        └──────────┘     │
│        │                  │                    │            │
│        ↓                  ↓                    ↓            │
│  ✓ Profile         ✓ Terminal          ✓ Removal       │
│    Installed         Ready              Complete       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Zonas:**
- 🔵 **Azul (Instalação)**: install.ps1, copy files, backup
- 🟣 **Roxo (Runtime)**: Profile load, commands, update check
- 🔴 **Vermelho (Desinstalação)**: uninstall, cleanup, restore

---

### 2. **Fluxo Detalhado de Verificação de Atualização** (Update Check Flow)

Mostra o fluxo **assíncrono** da verificação de atualizações

```
┌─────────────────────────────────────────────────────────┐
│          UPDATE CHECK - ASYNCHRONOUS EXECUTION          │
│                                                         │
│  Check-CyberUpdate called                              │
│         │                                              │
│         ↓                                              │
│  ┌─────────────────────────┐                          │
│  │ Already notified today? │                          │
│  │ (fast sync check)       │                          │
│  └────────┬───────────┬────┘                          │
│       YES │           │ NO                             │
│           │           │                                │
│    ┌──────↓──┐   ┌────↓──────────┐                    │
│    │ Return  │   │ Start Job     │                    │
│    │ (skip)  │   │ check-update  │                    │
│    └─────────┘   └────┬──────────┘                    │
│                        │                               │
│                        ↓                               │
│         ┌──────────────────────────┐                  │
│         │ Profile Finishes         │                  │
│         │ PROMPT READY             │                  │
│         │ (User can type now)      │                  │
│         └──────────────────────────┘                  │
│                        │                               │
│        Meanwhile:      │      ↓                        │
│        Job running     │  Toast notification           │
│        in background   │  (if update found)            │
│                        │  No wait!                     │
│                        ↓                               │
│                   ┌─────────────┐                     │
│                   │ Notification│                     │
│                   │ Async fired │                     │
│                   └─────────────┘                     │
│                                                       │
└─────────────────────────────────────────────────────┘
```

**Destaques:**
- ✅ Profile volta controle ANTES do job terminar
- ✅ Verificação no background (ThreadJob)
- ✅ Notificação assíncrona quando atualização encontrada
- ✅ Sem bloqueio do prompt

---

## 🎨 Padrão de Cores

| Cor | Significado | Uso |
|-----|-------------|-----|
| 🔵 Azul | Entrada/Instalação | install.ps1, scripts de setup |
| 🟣 Roxo | Processamento/Runtime | Profile, ThreadJob, processamento |
| 🟢 Verde | Sucesso/Output | Comandos prontos, cache válido |
| 🟠 Laranja | Aviso/Pendente | Verificação, cache check |
| 🔴 Vermelho | Erro/Remoção | uninstall, limpeza |
| 🔶 Amarelo | Nota/Decisão | Backup, verificação |

---

## 📖 Documentação Relacionada

| Documento | Descrição |
|-----------|-----------|
| [ARCHITECTURE_FLOW.md](ARCHITECTURE_FLOW.md) | Diagramas em ASCII + explicações detalhadas |
| [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) | Código comentado linha por linha |
| [UPDATE_NOTIFICATIONS.md](UPDATE_NOTIFICATIONS.md) | Sistema de notificações |
| [GETTING_STARTED.md](GETTING_STARTED.md) | Instalação e configuração |

---

## 💡 Contribuindo

Quer adicionar ou melhorar um diagrama?

1. Edite o arquivo markdown
2. Use caracteres ASCII para desenhar
3. Mantenha o padrão de cores
4. Teste a visualização
5. Abra uma PR com a melhoria

---

## 🔄 Histórico de Atualizações

| Data | Diagrama | Alteração |
|------|----------|-----------|
| 2026-06-20 | Complete Flow | ASCII diagram criado |
| 2026-06-20 | Update Check Flow | ASCII diagram criado |

---

## 📌 Notas

- Os diagramas são renderizados como texto puro (ASCII art)
- Compatível com qualquer visualizador markdown
- Sempre disponível offline no repositório
- Fácil de editar e versionar com git

---

**Última atualização:** 2026-06-20  
**Versão do projeto:** 2.2.0
