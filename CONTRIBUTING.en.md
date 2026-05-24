# Contributing

Language: [Português do Brasil](CONTRIBUTING.md) | English

Thanks for helping improve this terminal setup. The project is intentionally
simple: most visual contributions should happen in data files, not in renderer
logic.

## Local Validation

Run these before opening a pull request:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-unit.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-e2e-reinstall.ps1
pwsh -NoLogo -NoProfile -File .\scripts\legal-check.ps1
```

## Branch Flow And PR Approval

- Do not push directly to `main`.
- Use `develop` as the integration branch.
- Create features in `feature/<short-name>`.
- Create regular fixes in `fix/<short-name>` or `bugfix/<short-name>`.
- Create urgent production fixes in `hotfix/<short-name>` from `main`.
- Prepare releases in `release/<version>` from `develop`.
- All changes must go through pull requests.
- Merge only with green CI.
- Merge requires maintainer approval (CODEOWNERS + branch protection).

Full guide: `docs/GITFLOW_PR_APPROVAL.md`.

## Adding Icons

Edit:

```text
data\cyber-item-rules.psd1
```

Use these sections:

- `DirectoryIconRules` for folder-name regex rules.
- `FileIconRules` for file-name regex rules.
- `ExtensionIcons` for extension maps.
- `DirectoryColorRules` for folder-name color rules.
- `FileColorRules` for file-name color rules.
- `ExtensionColors` for extension color maps.

Guidelines:

- Keep regex rules specific enough to avoid surprising matches.
- Put more specific rules before generic rules.
- Use lowercase extensions, including the dot: `.json`, `.ps1`, `.png`.
- Use hex RGB colors in `#RRGGBB` format.
- Keep files as UTF-8 because Nerd Font glyphs are stored directly.

## Renderer Logic

Only edit `profile\Microsoft.PowerShell_profile.ps1` when changing behavior.
Examples:

- Column layout.
- PSReadLine bindings.
- Prompt/theme loading.
- How rules are resolved.

Icon additions should almost never require profile logic changes.

## Windows Terminal

Do not commit a full personal Windows Terminal `settings.json`. Use snippets in
`terminal\` so users can merge safely.

## Security

Do not commit secrets, history files, certificates, private keys, `.env` files,
or personal paths. The `.gitignore` blocks common cases, but contributors should
still review their diffs.

## Legal Checklist (Required)

- Submit only original content or third-party content with compatible license.
- Register new visual/media assets in `ASSET_ATTRIBUTION.md`.
- Do not submit proprietary third-party material without authorization.
- Do not commit secrets, tokens, API keys, private keys, or confidential data.
- Use third-party marks only descriptively (compatibility), without implying
  affiliation/endorsement.

Quick references:

- `THIRD_PARTY_NOTICES.md`
- `ASSET_ATTRIBUTION.md`
- `TRADEMARKS.md`
- `LEGAL_COMPLIANCE.md`
- `SECURITY.md`

