# Roadmap

Idioma: Português do Brasil | [English](ROADMAP.en.md)

Este roadmap existe para ajudar pessoas novas a contribuir sem precisar adivinhar
por onde começar. As ideias abaixo são sugestões; antes de uma mudança grande,
abra uma issue ou draft PR para alinharmos direção.

## Como Escolher Uma Tarefa

- Se quer uma primeira contribuição: procure itens `bom primeiro PR`.
- Se quer aprender a arquitetura: comece por regras em `data/`.
- Se quer mexer no comportamento: leia `docs/ARCHITECTURE.md` primeiro.
- Se quer alterar instalação/rollback: rode o E2E antes de abrir PR.

## Bom Primeiro PR

- Adicionar ou ajustar ícones e cores em `data/cyber-item-rules.psd1`.
- Melhorar exemplos em `docs/GETTING_STARTED.md`.
- Adicionar casos comuns ao troubleshooting.
- Corrigir textos, links quebrados ou inconsistências entre PT/EN.
- Melhorar SVGs de documentação mantendo registro em `ASSET_ATTRIBUTION.md`.

## Próximas Melhorias

- Criar mais testes Pester para edge cases do renderer.
- Adicionar teste para merge do Windows Terminal com fixtures de `settings.json`.
- Criar modo `-DryRun` mais explícito no instalador.
- Melhorar logs de instalação com arquivo opcional.
- Criar guia de customização de paletas e regras.
- Adicionar exemplos de profiles alternativos do Windows Terminal.

## Itens Maiores

- Extrair o motor de regras para módulo PowerShell testável.
- Criar release workflow com pacote `.zip`, checksum e changelog.
- Criar matriz de CI para versões diferentes do PowerShell.
- Medir performance de startup do profile e definir orçamento máximo.
- Criar documentação de compatibilidade para Windows Terminal Stable/Preview.

## Regras Para Contribuir

- Features e fixes entram primeiro em `develop`.
- Use branches `feature/*`, `fix/*`, `bugfix/*`, `hotfix/*`, `release/*`,
  `chore/*` ou `docs/*`.
- Rode validação local antes do PR:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-unit.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-e2e-reinstall.ps1
pwsh -NoLogo -NoProfile -File .\scripts\legal-check.ps1
```

## Fora Do Escopo Por Enquanto

- Distribuir binários de fontes ou executáveis de terceiros.
- Substituir o Windows Terminal por outro terminal alvo principal.
- Depender de módulos PowerShell externos para renderizar `ls` em runtime.
- Commitar `settings.json` pessoal completo do Windows Terminal.

