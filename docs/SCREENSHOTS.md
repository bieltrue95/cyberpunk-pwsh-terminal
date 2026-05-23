# Screenshots

Idioma: Português do Brasil | [English](en/SCREENSHOTS.md)

O repositório inclui prévias em SVG para que o GitHub mostre a identidade visual
mesmo antes de existirem capturas PNG reais.

## Assets Atuais

| Arquivo | Finalidade |
| --- | --- |
| `screenshots/terminal-showcase.svg` | Prévia principal do renderer do terminal. |
| `screenshots/history-search.svg` | Prévia do histórico e busca do PSReadLine. |
| `screenshots/data-driven-rules.svg` | Prévia da arquitetura data-driven. |
| `screenshots/safe-install-flow.svg` | Prévia do fluxo de instalação e validação. |

## Adicionar Screenshots Reais

Nomes PNG recomendados:

```text
screenshots/terminal-real.png
screenshots/history-real.png
screenshots/install-real.png
```

Checklist sugerido:

- Usar o perfil `dev` do Windows Terminal.
- Usar `FiraCode Nerd Font Mono`.
- Rodar `ll ~` ou `pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1`.
- Capturar em 1280x720 ou 1600x900.
- Evitar mostrar segredos, tokens, caminhos privados ou histórico pessoal.

Depois de adicionar PNGs, atualize `README.md` para exibir as capturas reais
acima ou ao lado das prévias SVG.
