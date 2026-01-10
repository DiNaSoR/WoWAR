# WoWLang / WoWAR – Project Memo

Last updated: 2026-01-03

## High signal (current state)

- QuestMapFrame translation is applied **post-layout**; Blizzard refresh APIs must not be called during toggles.
- Translation toggle state is authoritative (`QTR_curr_trans`) and must never be flipped implicitly by fallback logic.
- Arabic RTL layout and headers are applied **only when real Arabic QuestData exists**.
- Mixed Arabic headers with English quest bodies are explicitly prevented (fallback restores LTR + original headers).
- Tooltip hooks and font templating are owned exclusively by `common/Tooltips/*`.
- Arabic tooltips enforce RTL-feeling layout via RIGHT justification (no anchor mirroring), applied in `common/Tooltips/Hooks.lua`.
- Arabic font application is centralized in `common/UI/Fonts.lua`.
- UI translation is data-driven via `common/UI/Translate.lua`; ad-hoc per-frame logic is discouraged.
- RTL detection is centralized via `ns.RTL.IsRTL()`; raw locale checks are deprecated.
- All legacy `ST_*` globals are registered only in `common/Core/Compat.lua`.
- Hook/ticker wiring uses shared helpers from `common/Core/HookUtils.lua`.
- Primary settings UI is the Plumber-style **ControlCenter panel** in `common/Config/ControlCenter/*` (AceConfig UI is disabled).
- AceDB is the source of truth for config persistence; legacy migration runs **once only** on first install.

## RTL / text shaping invariants

- RTL text shaping preserves WoW special codes (`|T` / `|A` / colors / links).
- Multi-digit placeholder restoration must handle digit reversal, otherwise icons/codes vanish in RTL.
- Generic hyperlinks `|H...|h...|h` must be protected through reversal.

## Quest title decoration strategy (RTL-safe)

- Quest title “icons” may come from:
  - leading font glyphs (present in Blizzard font, missing in Arabic fonts), OR
  - `|H...|h...|h` decorations whose display payload may include `|A`/`|T`.
- In RTL, keep the shaped Arabic title string clean (do not inject `|H...|h...|h` into shaped text).
- Render the title icon as a separate overlay FontString using `Original_Font1`.
- In RTL, anchor the overlay to the RIGHT side and keep it tied to `QuestInfoTitleHeader` for stable vertical alignment.
- If a FontString is double-anchored (LEFT+RIGHT), `SetWidth()` won’t enforce width; adjust the RIGHT anchor offset by a computed delta.

## RTL layout safety

- Do not mirror anchors for RTL; control layout via justification and fonts.
- For RTL UI labels that are RIGHT-justified, include safe right padding when sizing widths (prevents glyph clipping), especially in QuestMapFrame rewards.

## Load order requirements

- `WoWAR/WoWAR.toc` must load:
  - `common/Core/Compat.lua`
  - `common/Core/HookUtils.lua`
  - `common/UI/Translate.lua`
