# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Automatic update notification system (`check-update.ps1`).
  - Toast notifications (1x per day) when new versions are available.
  - `update-check` command to view changelog and available updates.
  - Fallback console notifications for systems without Toast support.
- Comprehensive uninstall checklist script (`scripts/uninstall-checklist.ps1`).
  - Visual checklist of all components being removed.
  - Automatic backup before uninstall.
  - Detailed verification of successful uninstall.
- Post-uninstall verification script (`scripts/test-uninstall-verify.ps1`).
- `VERSION` file for semantic versioning.
- `Update Notifications` guide documentation.
- `Uninstall Guide` with step-by-step instructions and troubleshooting.
- Safe update script (`update.ps1`) for users to update their installation.
- Support for `-a` flag in `ls` command (Linux-style hidden files).
- Improved installation documentation with Windows Terminal Preview emphasis.
- Improvements plan documentation for future development.
- Contribution policy clarifying open-source nature and AI-assisted contributions.

### Changed

- Enhanced `uninstall.ps1` with `-WithChecklist` option for detailed uninstall verification.
- Improved uninstall script with cleanup of temporary notification files.
- Added `Check-CyberUpdate` and `update-check` functions to profile initialization.
- Enhanced `GETTING_STARTED.md` with clearer step-by-step instructions.
- Better distinction between mandatory and recommended prerequisites.
- Improved troubleshooting section with common error solutions.

## [0.1.0] - 2026-05-23

### Added

- Portable PowerShell 7 profile.
- Data-driven Nerd Font icon and color rules.
- Custom `ls`, `dir`, `l`, and `ll` renderer.
- PSReadLine history search and helper commands.
- oh-my-posh cyberpunk clean theme.
- Windows Terminal profile and color scheme snippet.
- Safe installer and uninstall script.
- Optional Windows Terminal merge script with backup and JSON validation.
- Diagnostics script and CI-friendly profile test.
- Contribution guide and MIT license.
- Screenshot gallery using committed SVG previews.
- Architecture, screenshots, and troubleshooting documentation.
- Portuguese-Brazilian documentation as the primary docs, with English as secondary docs.
- Backup locations and restore instructions in install/troubleshooting docs.
- Dedicated bilingual backup and restore guide.
- Guided `setup.ps1` onboarding script for beginner-friendly installs.
- Bilingual getting-started guide with emergency recovery path.
- Additional SVG previews for quick start and emergency restore flows.
