# Screenshots

Language: [Português do Brasil](../SCREENSHOTS.md) | English

The repository includes SVG previews so GitHub renders the visual identity even
before real PNG screenshots are captured.

## Current Preview Assets

| File | Purpose |
| --- | --- |
| `screenshots/terminal-showcase.svg` | Main terminal renderer preview. |
| `screenshots/history-search.svg` | PSReadLine history/search preview. |
| `screenshots/data-driven-rules.svg` | Architecture preview for data-driven rules. |
| `screenshots/safe-install-flow.svg` | Installer and validation flow preview. |
| `screenshots/beginner-quick-start.svg` | Beginner five-command flow preview. |
| `screenshots/emergency-restore.svg` | Emergency restore flow preview. |

## Adding Real Screenshots

Recommended PNG names:

```text
screenshots/terminal-real.png
screenshots/history-real.png
screenshots/install-real.png
screenshots/emergency-real.png
```

Suggested capture checklist:

- Use Windows Terminal profile `dev`.
- Use `FiraCode Nerd Font Mono`.
- Run `ll ~` or `pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1`.
- Capture at 1280x720 or 1600x900.
- Avoid showing secrets, tokens, private paths, or personal command history.

After adding PNGs, update `README.md` to show the real captures above or beside
the SVG previews.

