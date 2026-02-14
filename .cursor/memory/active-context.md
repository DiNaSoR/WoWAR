# Active Context (Session Scratchpad)

Priority: this overrides older journal history *for this session only*.

CLEAR this file when the task is done:
- Run `scripts/memory/clear-active.ps1`

## Current Goal
- Fixed glyph overlap in RTL quest titles
- Updated DebugToolsUI with tabbed interface
- Remove vector smoke script and validate normal vector tools flow
- Enforce vector-first retrieval policy for future AI runs
- Enforce post-vector grounding so answers do not stay digest-only
- Record missing memory entry for Config LuaLS undefined-global fixes

## Files in Focus
- `common/Quests/Details.lua`
- `common/UI/DebugToolsUI.lua`
- `common/UI/Welcome.lua`
- `common/Locale/changelog.lua`
- `common/Config/ControlCenter/Registry.lua`
- `common/Config/ControlCenter/SettingsPanel.lua`
- `Tools/index.html`
- `Tools/changelog_Unshaped.lua`
- `scripts/memory/mnemo_vector.py`
- `.cursor/rules/01-vector-search.mdc`
- `common/Config/Minimap.lua`
- `common/Config/State.lua`

## Findings / Decisions
- Reserved 14px for glyph in RTL title width; positioned glyph at RIGHT edge of title
- Merged DebugUI and DebugToolsUI into single tabbed panel
- RTL reversal now auto-protects plain numeric tokens inside `Text.HandleWoWSpecialCodes` to prevent digit order flipping (e.g., "27" staying "27" after reversal).
- Consolidated quest header width adjustment to a single pass (glyph reserve applied once).
- Welcome screen: reduce RTL text width by 5px and use `WOWTR_Font1` for the title to improve bidi rendering.
- Welcome screen: compute stable body/tips wrap width before `QTR_ExpandUnitInfo`; enforce word-wrap mode and use a small body correction (`-10`) to prevent RTL orphan/reordered words.
- Changelog: updated latest entry (`12.00`) to reflect welcome RTL wrapping fixes and current release date.
- Changelog wording preference: keep Release Notes non-technical and user-facing.
- Tools reshaper now explicitly supports both `WoW_Localization_AR.lua` and `changelog.lua`, with export suffixes (`_Reshaped`/`_Unshaped`) to produce safe copies.
- Added `Tools/changelog_Unshaped.lua` as an unshaped working copy for changelog reshaping flow.
- Revised historical changelog entries (before 13 Feb 2026) in `Tools/changelog_Unshaped.lua` with cleaner player-facing Arabic wording.
- Changelog entry `color` is now wired end-to-end: preserved in registry conversion and applied in Release Notes date/title/body/bullets + version list labels.
- Changelog color styling tuned for readability: accent-only (date/title), while body text, bullets, and version list remain neutral.
- Changelog title styling: `h1` now uses `WOWTR_Font1` with increased size for stronger heading hierarchy.
- Fixed pooled FontString bleed in changelog renderer: non-title lines now force body font reset so bullet lines cannot inherit enlarged title size.
- Changelog date divider texture now flips horizontally in RTL so decorative direction matches Arabic layout.
- Settings panel tab strip now attaches 8px higher to remove perceived gap between main panel border and bottom tabs.
- Fixed tab strip anchoring bug: tab buttons are now anchored to `TabButtonContainer` (not `MainFrame`), so `TabAttachOffsetY` actually affects layout.
- SettingsPanel version labels now use version-first ordering in RTL (e.g., `12.00 الإصدار`) for better Arabic readability.
- ControlCenter module search now uses Arabic-aware variant matching (raw + reversed/reshaped transforms) so typed Arabic reliably filters and updates right-side preview.
- Search input in ControlCenter now renders Arabic through a shaped preview overlay (while keeping raw EditBox text for matching), so typing looks correctly shaped and results still update.
- ControlCenter settings preview now supports per-setting `preview_wowar_[prefix].png` images with placeholder fallback; generated placeholder-backed PNG files for sub-settings missing dedicated art.
- Removed `scripts/memory/vector-smoke.ps1` and switched back to normal vector tool validation (`vector_health`, `vector_sync`, `vector_search`).
- Normal vector tools currently pass with Gemini provider and return semantic hits.
- Updated `.cursor/rules/01-vector-search.mdc` to mandatory vector-first retrieval with fallback-only non-vector search.
- Updated `.cursor/rules/01-vector-search.mdc` with mandatory post-search grounding (read top refs, expand digest -> journal) before final answers.
- Confirmed LuaLS undefined globals in Config files are addressed via `rawget(_G, "...")` lookups (EasyMenu + reset/confirmation globals).

## Temporary Constraints
-

## Blockers
-