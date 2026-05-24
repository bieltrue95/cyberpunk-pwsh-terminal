# Checklist Para Tornar O Repositório Público

Use este checklist antes de mudar a visibilidade do repositório para público.

## Código E Segurança

- [ ] Último CI verde em `main`.
- [ ] Último CI verde em `develop`.
- [ ] `scripts/legal-check.ps1` passou localmente.
- [ ] Nenhum segredo, token, chave privada, certificado ou `.env` nos arquivos atuais.
- [ ] Histórico Git revisado para segredos acidentais.
- [ ] Branches temporárias antigas removidas ou associadas a PRs ativos.

## Proteção De Branches

- [ ] `main` protegida.
- [ ] `develop` protegida.
- [ ] PR obrigatório antes de merge em `main`.
- [ ] PR obrigatório antes de merge em `develop`.
- [ ] CI `validate` obrigatório antes de merge.
- [ ] Review de CODEOWNERS obrigatório.
- [ ] Pelo menos 1 aprovação obrigatória.
- [ ] Force push bloqueado.
- [ ] Deleção de branch bloqueada.
- [ ] Bypass de admins bloqueado em `main`.

## Documentação

- [ ] `README.md` revisado.
- [ ] `README.en.md` revisado.
- [ ] `docs/GETTING_STARTED.md` e `docs/en/GETTING_STARTED.md` revisados.
- [ ] `docs/INSTALL.md` e `docs/en/INSTALL.md` revisados.
- [ ] `docs/TROUBLESHOOTING.md` e `docs/en/TROUBLESHOOTING.md` revisados.
- [ ] `ROADMAP.md` e `ROADMAP.en.md` publicados.
- [ ] `CONTRIBUTING.md` e `CONTRIBUTING.en.md` publicados.

## Legal E Atribuição

- [ ] `LICENSE` presente e correto.
- [ ] `SECURITY.md` presente.
- [ ] `LEGAL_COMPLIANCE.md` presente.
- [ ] `THIRD_PARTY_NOTICES.md` presente.
- [ ] `TRADEMARKS.md` presente.
- [ ] `ASSET_ATTRIBUTION.md` lista todos os SVGs e assets versionados.
- [ ] Nenhum binário de fonte ou executável de terceiro versionado.
- [ ] Referências a oh-my-posh, Nerd Fonts, Microsoft e GitHub são descritivas.

## GitHub UI

- [ ] About atualizado:

```text
Portable PowerShell 7 + Windows Terminal setup with safe install, backups, oh-my-posh theme, Nerd Font icons, and a custom cyberpunk ls renderer.
```

- [ ] Topics configurados:

```text
powershell pwsh windows-terminal oh-my-posh nerd-fonts terminal developer-tools windows cyberpunk dotfiles
```

- [ ] Apenas seções relevantes habilitadas na home do repo (por exemplo, Releases).
- [ ] Issues habilitadas se você quiser receber feedback público.
- [ ] Discussions habilitado somente se quiser comunidade/conversa aberta.

## Decisão Final

- [ ] Repositório pronto para público.
- [ ] Mantenedor confortável com o escopo atual.
- [ ] Plano claro para triagem de issues e PRs.

