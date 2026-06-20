# Plano de Melhorias - Documentação de Instalação

**Branch:** `docs/improve-installation-docs`  
**Data:** 2026-06-20  
**Objetivo:** Testar e melhorar a documentação de instalação do projeto

---

## Impactos Identificados

### 1. ❌ Problema: Instruções de Instalação Confusas
**Impacto:** Iniciantes têm dificuldade em seguir o processo  
**Afetados:** `docs/GETTING_STARTED.md`, `docs/en/GETTING_STARTED.md`, `docs/INSTALL.md`

**Melhorias Propostas:**
- [ ] Separar cada comando em bloco isolado (copy-paste fácil)
- [ ] Numerar passos claramente (Passo 1, 2, 3...)
- [ ] Deixar explícito: qual terminal usar (Windows Terminal vs PowerShell)
- [ ] Adicionar seção de "Erros Comuns" com soluções
- [ ] Incluir verificações pós-instalação

**Validação:**
- Rodar `scripts/check.ps1` ✓
- Rodar `scripts/test-profile.ps1` ✓
- Rodar `scripts/test-unit.ps1` ✓
- Testar em máquina limpa (simulado com E2E)

---

### 2. ❌ Problema: Links e Referências Quebradas
**Impacto:** Documentação desconectada, usuário se perde  
**Afetados:** Todos os `.md` files

**Melhorias Propostas:**
- [ ] Auditar todos os links internos
- [ ] Auditar referências a caminhos Windows
- [ ] Garantir referências cruzadas consistentes

**Validação:**
- [ ] Verificar links com regex ou manual
- [ ] Executar legal-check para segurança

---

### 3. ❌ Problema: Documentação PT-BR e EN Desincronizada
**Impacto:** Informações inconsistentes entre idiomas  
**Afetados:** Pares `*.md` e `en/*.md`

**Melhorias Propostas:**
- [ ] Manter versões PT-BR e EN sincronizadas
- [ ] Usar estrutura idêntica em ambas
- [ ] Traduzir com consistência de termos técnicos

**Validação:**
- [ ] Comparar estrutura de ambas versões
- [ ] Testar ambas docs em E2E

---

### 4. ❌ Problema: Falta de Visual/Screenshots
**Impacto:** Difícil entender qual tela/opção fazer  
**Afetados:** `docs/GETTING_STARTED.md`, `docs/en/GETTING_STARTED.md`

**Melhorias Propostas:**
- [ ] Adicionar descrições visuais com emojis/símbolos
- [ ] Descrever: "clique na seta", "abra menu", etc.
- [ ] Referenciar nomes exatos de botões/campos

**Validação:**
- [ ] Testar com usuário novo (seu irmão?)
- [ ] Validar que instruções são seguíveis

---

### 5. ❌ Problema: Pré-requisitos Não Claros
**Impacto:** Usuário instala coisas desnecessárias ou pula essenciais  
**Afetados:** `docs/INSTALL.md`, `docs/GETTING_STARTED.md`

**Melhorias Propostas:**
- [ ] Marcar **OBRIGATÓRIO** vs **RECOMENDADO**
- [ ] Explicar por quê cada um é necessário
- [ ] Mostrar como verificar se está instalado

**Validação:**
- [ ] Executar check.ps1 com/sem cada dependência
- [ ] Documentar fallbacks quando falta algo

---

## Checklist de Validação (GitFlow)

Antes de fazer PR, rodar:

```powershell
# Validação local
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-unit.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-e2e-reinstall.ps1
pwsh -NoLogo -NoProfile -File .\scripts\legal-check.ps1
```

- [ ] Todos os 5 scripts passando
- [ ] Nenhuma linha de código adicionada (apenas docs)
- [ ] PT-BR e EN sincronizados
- [ ] Links verificados
- [ ] Pronto para PR em `develop`

---

## Estrutura de PR Esperada

**Título (PT-BR):**
```
Melhorar documentação de instalação com instruções claras e passo-a-passo
```

**Body (PT-BR):**
```markdown
## Resumo

Melhoria na documentação de instalação para iniciantes com foco em:
- Instruções claras e passo-a-passo
- Separação de comandos por bloco
- Clareza sobre qual terminal usar
- Seção de erros comuns

## Impacto

- Usuários novos conseguem instalar sem confusão
- Reduz tickets de "não consegui instalar"
- Documentação PT-BR e EN sincronizada

## Plano de Testes

- ✓ Scripts de validação rodando
- ✓ E2E install/uninstall testado
- ✓ Links internos verificados
- ✓ Legal check passou

Closes #[issue-number] (se houver)
```

---

## Status

- [x] Branch criada
- [ ] Melhorias implementadas
- [ ] Testes executados
- [ ] PR aberta em `develop`
- [ ] Aprovação do mantenedor
- [ ] Merged em `develop`
