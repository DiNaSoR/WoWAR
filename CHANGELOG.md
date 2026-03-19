# Changelog

All notable changes to **WoWAR** are listed here. Entries are derived from git history.

**Baseline:** git tag **`v12.01`** (2026-03-02) — changes since **12.01** through the work that corresponds to **`WoWAR.toc` version 12.02** (commits on `main` up to but not including the 12.03 version bump). There is no `v12.0.1` tag in this repo; **12.01** is used as the prior release marker.

---

## [12.02] - 2026-03-18

### Added

- **Movies / cinematics:** Large Arabic subtitle database (`Translations/Subtitles_AR.lua`) and subtitle display logic updates in `common/Movies` (fallbacks, font handling, cinematic visibility).
- **Books:** Arabic book text database (`Translations/Books_AR.lua`) and continued integration in `common/Books/Main.lua`.
- **Speech bubbles:** Split bubble translations into `Translations/Bubbles_AR_1.lua` and `Translations/Bubbles_AR_2.lua` (replacing the single `Bubbles_AR.lua` layout).
- **Text engine:** Helpers in `common/Text.lua` for mixed color-token normalization; font line-height measurement, caching, and dynamic spacing; `common/Text/Reshaper.lua` updates for measurement/wrapping.
- **Books HTML:** Normalization and handling of HTML in book text for Arabic alignment and rendering.
- **Docs / repo hygiene:** `README.md`, `CONTRIBUTING.md`; `.gitignore` entries for Python bytecode and cache under `scripts/memory`.

### Changed

- **Version:** `WoWAR.toc` set to **12.02** (with Talking Head / bubble improvements in `common/Bubbles/Main.lua`: visibility, RTL justification by content).
- **Chat & tutorials:** Arabic layout, fonts, and RTL behavior in `common/Chat/Chat.lua`; tutorial wrapping and font correction in `common/Tutorials/Main.lua`.
- **Tutorials data:** Arabic tutorial file renamed to `Translations/TutorialsData_AR.lua` (from `TutorialsData7_AR.lua`); references and `WoWAR.toc` updated; `release.yml` adjusted.
- **Translations maintenance:** Creation dates and versioning touch-ups across quest, gossip, bubble, and book data; large refreshes to `Gossip_AR.lua`, `QuestData_AR.lua`, and bubble files.
- **Core UI:** Minor button positioning tweak in `common/Core/Main.lua` for Arabic layout.

### Removed

- Legacy / redundant Arabic data files after consolidation (e.g. old `Books_AR1.lua` path, monolithic `Bubbles_AR.lua`, prior subtitle stub layout as replaced by the new subtitle pipeline).

---

## Earlier releases

- **12.01** — see tag `v12.01` (2026-03-02).
- **12.00** — see tag `v12.00`.

---

### Note on branches

If your checkout includes commits **after** the “Update WoWAR to version **12.03**” change on `main`, those entries are not part of the **12.02** section above; extend this file with a **12.03** section when you cut that release.
