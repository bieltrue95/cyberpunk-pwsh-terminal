# Roadmap

Language: [Português do Brasil](ROADMAP.md) | English

This roadmap helps new contributors find useful work without guessing where to
start. The ideas below are suggestions; for larger changes, open an issue or
draft PR first so we can align on direction.

## How To Pick A Task

- If this is your first contribution: look for `good first PR` items.
- If you want to learn the architecture: start with rules in `data/`.
- If you want to change behavior: read `docs/en/ARCHITECTURE.md` first.
- If you change install/rollback behavior: run the E2E test before opening a PR.

## Good First PR

- Add or tune icons and colors in `data/cyber-item-rules.psd1`.
- Improve examples in `docs/en/GETTING_STARTED.md`.
- Add common cases to troubleshooting.
- Fix wording, broken links, or PT/EN inconsistencies.
- Improve documentation SVGs while keeping `ASSET_ATTRIBUTION.md` updated.

## Next Improvements

- Add more Pester tests for renderer edge cases.
- Add tests for Windows Terminal merge using `settings.json` fixtures.
- Add a clearer `-DryRun` mode to the installer.
- Improve install logs with an optional log file.
- Create a palette and rule customization guide.
- Add examples for alternative Windows Terminal profiles.

## Larger Items

- Extract the rule engine into a testable PowerShell module.
- Create a release workflow with `.zip`, checksum, and changelog.
- Add a CI matrix for multiple PowerShell versions.
- Measure profile startup performance and define a maximum budget.
- Document compatibility for Windows Terminal Stable/Preview.

## Contribution Rules

- Features and fixes land in `develop` first.
- Use branches named `feature/*`, `fix/*`, `bugfix/*`, `hotfix/*`, `release/*`,
  `chore/*`, or `docs/*`.
- Run local validation before opening a PR:

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-unit.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-e2e-reinstall.ps1
pwsh -NoLogo -NoProfile -File .\scripts\legal-check.ps1
```

## Out Of Scope For Now

- Shipping third-party font binaries or executable binaries.
- Replacing Windows Terminal as the primary target terminal.
- Depending on external PowerShell modules for the runtime `ls` renderer.
- Committing a full personal Windows Terminal `settings.json`.

