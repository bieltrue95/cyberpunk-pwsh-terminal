# Como Contribuir

Idioma: Português do Brasil | [English](CONTRIBUTING.en.md)

Obrigado por ajudar a melhorar este setup de terminal. A ideia do projeto é ser
simples: a maioria das contribuições visuais deve acontecer em arquivos de
dados, não na lógica do renderer.

Se você ainda está escolhendo uma tarefa, comece pelo `ROADMAP.md`.

## Validação Local

Rode antes de abrir um pull request:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-unit.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-e2e-reinstall.ps1
pwsh -NoLogo -NoProfile -File .\scripts\legal-check.ps1
```

## Fluxo De Branch E Aprovação De PR

- Não fazer push direto em `main`.
- Use `develop` como branch de integração.
- Crie features em `feature/<nome-curto>`.
- Crie correções comuns em `fix/<nome-curto>` ou `bugfix/<nome-curto>`.
- Crie correções urgentes em `hotfix/<nome-curto>` a partir de `main`.
- Prepare releases em `release/<versao>` a partir de `develop`.
- Toda mudança deve entrar por PR.
- Merge só com CI verde.
- Merge depende de aprovação do mantenedor (CODEOWNERS + proteção de branch).

Guia completo: `docs/GITFLOW_PR_APPROVAL.md`.

## Adicionar Ícones

Edite:

```text
data\cyber-item-rules.psd1
```

Use estas seções:

- `DirectoryIconRules` para regras regex de pastas.
- `FileIconRules` para regras regex de nomes de arquivos.
- `ExtensionIcons` para mapas de extensões.
- `DirectoryColorRules` para regras de cores de pastas.
- `FileColorRules` para regras de cores de nomes de arquivos.
- `ExtensionColors` para mapas de cores por extensão.

Diretrizes:

- Mantenha regex específicas o bastante para evitar matches inesperados.
- Coloque regras mais específicas antes das genéricas.
- Use extensões em minúsculo, incluindo ponto: `.json`, `.ps1`, `.png`.
- Use cores RGB hex no formato `#RRGGBB`.
- Mantenha arquivos em UTF-8 porque glyphs Nerd Font ficam gravados direto.

## Lógica Do Renderer

Edite `profile\Microsoft.PowerShell_profile.ps1` somente quando mudar
comportamento. Exemplos:

- Layout de colunas.
- Atalhos do PSReadLine.
- Carregamento de prompt/tema.
- Como as regras são resolvidas.

Adicionar ícones quase nunca deve exigir mudança na lógica do profile.

## Windows Terminal

Não commite um `settings.json` pessoal completo do Windows Terminal. Use snippets
em `terminal\` para permitir merge seguro.

## Segurança

Não commite segredos, histórico, certificados, chaves privadas, arquivos `.env`
ou caminhos pessoais. O `.gitignore` bloqueia casos comuns, mas revise sempre o
diff antes de subir alterações.

## Checklist Jurídico (Obrigatório)

- Conteúdo autoral próprio ou com licença compatível documentada.
- Assets visuais/mídia novos registrados em `ASSET_ATTRIBUTION.md`.
- Sem material proprietário de terceiros sem autorização.
- Sem segredos, tokens, API keys, chaves privadas ou dados confidenciais.
- Referências a marcas somente de forma descritiva (compatibilidade), sem
  sugerir afiliação/endosso.

Referências rápidas:

- `THIRD_PARTY_NOTICES.md`
- `ASSET_ATTRIBUTION.md`
- `TRADEMARKS.md`
- `LEGAL_COMPLIANCE.md`
- `SECURITY.md`
