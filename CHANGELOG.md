# Changelog

---
# 📦 WoWAR - Release Notes

## [12.02] — 2026-03-18

### 🎮 Supported WoW Patches
- **11.2.5** (110205)
- **11.2.7** (110207)
- **12.0.0** (120000)

---

## 📊 Translation Databases
Current status of the Arabic localization project:

| Database | Translated Entries | Last Updated |
| :--- | :--- | :--- |
| **Bubbles (Part 1 & 2)** | 132,348 | 2026-03-18 |
| **Gossip** | 58,243 | 2026-03-18 |
| **Quest** | 35,692 | 2026-03-18 |
| **Subtitles** | 5,351 | 2026-03-18 |
| **Books** | 4,369 | 2026-03-18 |
| **Tutorials** | 2,363 | 2026-03-18 |
| **Tooltips** | 88 | 2026-03-19 |
| **TOTAL** | **106,106** | — |

---

## 🔍 Key Changes

### ✨ Enhancements & New Features
* **Cinematics:** Integrated a massive Arabic subtitle database (`Subtitles_AR.lua`) with updated logic for font handling and visibility.
* **Speech Bubbles:** Optimized performance by splitting bubble translations into two parts (`Bubbles_AR_1` & `Bubbles_AR_2`).
* **Text Engine:** * New helpers in `common/Text.lua` for mixed color-token normalization.
    * Improved dynamic spacing, font line-height measurement, and caching.
    * Updated `Reshaper.lua` for better text wrapping and measurement.
* **Books:** Added Arabic book text support with HTML normalization for correct alignment and rendering.
* **UI/Chat:** Refined RTL (Right-to-Left) behavior for Chat, Tutorials, and Talking Head frames.

### 🔄 Maintenance & Refactors
* **Version Bump:** Core `.toc` files updated to **12.02**.
* **Repo Hygiene:** Added `.gitignore` for Python bytecode/cache; updated `README.md` and `CONTRIBUTING.md`.
* **Cleanup:** Removed legacy monolithic files (e.g., the old `Bubbles_AR.lua` and `Books_AR1.lua`) in favor of the new split architecture.
* **Logic:** Refined quest toggle button handling and gossip data refreshes.

---

## 🧪 Debug Policy
* **Module Inclusion:** Debug modules are included in standard release packages.
* **Runtime Defaults:** Debugging is **OFF** by default (enforced by CI guards).
* **Manual Toggle:** Users can opt-in by typing `/wowardebug` in-game.

---

## 🔗 Technical Changelog
* **Enhancements:** [fa3244c](https://github.com/DiNaSoR/WoWAR/commit/fa3244c), [b2f2754](https://github.com/DiNaSoR/WoWAR/commit/b2f2754)
* **Updates:** [1412bbb](https://github.com/DiNaSoR/WoWAR/commit/1412bbb), [62ff17e](https://github.com/DiNaSoR/WoWAR/commit/62ff17e), [b95fa2c](https://github.com/DiNaSoR/WoWAR/commit/b95fa2c)
* **Refactors:** [b158e46](https://github.com/DiNaSoR/WoWAR/commit/b158e46), [c7f504c](https://github.com/DiNaSoR/WoWAR/commit/c7f504c)

**Full Comparison:** [v12.01...v12.02](https://github.com/DiNaSoR/WoWAR/compare/v12.01...v12.02)

---
