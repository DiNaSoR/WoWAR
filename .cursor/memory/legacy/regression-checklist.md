# WoWLang / WoWAR – Regression Checklist

Use this after changes in the listed areas.
Record what you tested in the journal entry.

---

## Quests / QuestMapFrame / Details
- Toggle translation ON/OFF while QuestMapFrame is open.
- Open a quest, scroll details, switch to another quest, then return.
- Ensure text does not revert to English due to UI refresh timing.
- Verify post-layout reapply still works (no Blizzard overwrite).
- Verify fallback-to-English does NOT flip the global toggle state.

## RTL / Arabic application (data-driven)
- Visit a quest with real Arabic QuestData:
  - RTL layout applies
  - Arabic headers apply
  - Fonts are Arabic
- Visit a quest with missing Arabic QuestData:
  - No Arabic headers mixed with English body
  - Layout restores to LTR and original headers
  - Arabic fonts are not forced

## RTL special codes (Text pipeline)
- Confirm `|T...|t` / `|A...|a` icons remain visible in RTL.
- Confirm generic hyperlinks `|H...|h...|h` survive reversal.
- Confirm multi-digit placeholder restoration works (indices >= 10).
- Confirm no placeholder garbage like `□1□` appears in visible text.

## Quest title decorations / icons
- Title has leading glyph icon (e.g. small “!”):
  - Verify it remains visible in Arabic mode via overlay FontString using original font
- Title has `|HRepeat...|h...|h` decoration:
  - Verify the icon (glyph or `|A`/`|T`) renders via overlay and does not get injected into shaped Arabic title
- Verify overlay anchor side:
  - RTL: anchored to RIGHT side
  - LTR: anchored to LEFT side
- Verify overlay stays vertically aligned across refreshes (anchored to title header, not parent)

## Quest rewards / label clipping
- In QuestMapFrame rewards:
  - Verify RIGHT-justified Arabic labels do not clip on the right edge
  - Verify widths include safe padding and respect insets

## Tooltips
- Verify tooltip fonts/layout are consistent.
- Confirm hooks are owned only by `common/Tooltips/*` (no duplicates firing).

## Hooks / tickers
- Verify no duplicated hook registration.
- Verify shared helpers from `common/Core/HookUtils.lua` are used.

---
