# Cyberpunk PowerShell Terminal - Visual Diagrams

Idioma: Português do Brasil | [English](en/DIAGRAMS.md)

Diagramas interativos criados com Excalidraw para visualizar a arquitetura e fluxos do projeto.

---

## 📊 Diagramas Disponíveis

### 1. **Fluxo Completo do Projeto** (Complete Flow)

Mostra as três fases principais: Instalação → Runtime → Desinstalação

- **Zona Azul (Instalação)**: install.ps1 e setup
- **Zona Roxo (Runtime)**: Profile e execução
- **Zona Vermelha (Desinstalação)**: uninstall scripts

🔗 **[Abrir Diagrama Interativo →](https://excalidraw.com/#json=QIoddZeBEYkrpv0Cr--P7,ihTTvWFUKlCQf3SErG2xhQ)**

**Como usar:**
- Clique para selecionar elementos
- Arraste para mover
- Use mouse wheel para zoom
- Clique em "Edit in Excalidraw" para editar

---

### 2. **Fluxo Detalhado de Verificação de Atualização** (Update Check Flow)

Mostra o fluxo assíncrono da verificação de atualizações

- **Fase 1**: Verificação rápida (já notificou hoje?)
- **Fase 2**: ThreadJob em background
- **Fase 3**: Resultado não-bloqueante

🔗 **[Abrir Diagrama Interativo →](https://excalidraw.com/#json=QBEMyS-3zMRg-JmvwfaTV,cYmhmWc5cvpXy63H8jOmJw)**

**Destaque:**
- Profile volta o controle ANTES do job terminar
- Notificação aparece de forma assíncrona
- Sem bloqueio do prompt

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

## 💡 Como Contribuir

Quer atualizar os diagramas?

1. Clique no link do diagrama
2. Clique em "Edit in Excalidraw" (canto superior)
3. Faça as mudanças
4. Use "Save to browser" para salvar
5. Copie a nova URL
6. Abra PR com a URL atualizada neste arquivo

---

## 🔄 Histórico de Atualizações

| Data | Diagrama | Alteração |
|------|----------|-----------|
| 2026-06-20 | Complete Flow | Criado com 3 zonas |
| 2026-06-20 | Update Check Flow | Criado com async flow |

---

## 📌 Notas

- Os diagramas são hospedados no Excalidraw.com
- Links compartilháveis com acesso leitura/edição
- Compatível com navegadores modernos
- Sem necessidade de login para visualizar

---

**Última atualização:** 2026-06-20  
**Versão do projeto:** 2.2.0
