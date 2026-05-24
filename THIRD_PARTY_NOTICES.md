# Third-Party Notices

This repository is licensed under MIT (`LICENSE`), but it references third-party software, services, marks, and visual assets with their own terms.

Use this inventory to understand what is covered by this repository and what remains under third-party terms.

## Component Inventory

| Component | License / Terms | Official Source | Attribution Requirement | Required Action |
| --- | --- | --- | --- | --- |
| oh-my-posh (runtime dependency) | MIT (upstream project) | https://ohmyposh.dev/ and https://github.com/JanDeDobbeleer/oh-my-posh | Keep upstream license notice when redistributing upstream code/assets. | Use as external dependency only. Do not vendor binaries/themes/assets from upstream unless license obligations are explicitly documented in this repository. |
| Nerd Fonts / FiraCode Nerd Font Mono (font dependency) | Upstream font licenses and Nerd Fonts patching terms vary by font family. | https://www.nerdfonts.com/ | End users must comply with the selected font's license. | Do not bundle font binaries in this repository unless license and attribution are documented first. Glyph usage in text config does not grant redistribution rights for font binaries. |
| Windows Terminal product references and snippets | Microsoft product terms apply to product usage. | https://github.com/microsoft/terminal | No special attribution required for plain compatibility references. | Use references only for compatibility documentation; do not imply endorsement. |
| GitHub Actions badge and Shields.io badge assets | Service terms of GitHub and Shields.io apply. | https://docs.github.com/ and https://shields.io/ | Keep references as links; avoid copying external branded artwork into repo unless license is known. | Keep badges as remote links in README files. |
| Repository SVG previews in `screenshots/` | Repository-owned assets unless stated otherwise in `ASSET_ATTRIBUTION.md`. | Local files in this repository | Every visual asset must have source and license metadata in `ASSET_ATTRIBUTION.md`. | Update `ASSET_ATTRIBUTION.md` whenever adding/changing visual assets. |

## Notes

- Third-party names and logos are property of their owners.
- Trademark usage policy is documented in `TRADEMARKS.md`.
- Visual asset provenance and licenses are documented in `ASSET_ATTRIBUTION.md`.
- This project is not affiliated with, sponsored by, or endorsed by oh-my-posh, Nerd Fonts, Microsoft, or GitHub.
