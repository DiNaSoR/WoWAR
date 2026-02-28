# Active Context (Session Scratchpad)

Priority: this overrides older journal history *for this session only*.

CLEAR this file when the task is done:
- Run `scripts/memory/clear-active.ps1`

## Current Goal
- Investigate QuestMapFrame title icon disappearing after AR/EN toggle cycles for quest details.

## Files in Focus
- `common/Quests/Details.lua`

## Findings / Decisions
- Root cause likely state-loss of title decoration extraction during `__toggle__` passes when the current EN header text is plain.
- Added per-quest `_TitleDecorCache` fallback so glyph/tags/link metadata persists across toggle/reflow.
- On EN restore path (`TranslateOff`), prefer cached decorated EN title when available to keep UI consistent.
- Strengthened decoration detection to treat leading glyph icons (`!`, `?`, non-ASCII glyphs) as title decorations (not only `|H`/`|T`/`|A` tags).
- Normalized decoration/font cache keys to `tostring(questID)` for stability across numeric/string ID paths.
- New root-cause hypothesis confirmed in code path: title icon font cache was overwritten during AR `__post__` passes, causing glyph icons to render with `WOWTR_Font1` (missing glyph).
- Hardened icon font selection to ignore Arabic cached font and fall back to `Original_Font1`.
- Additional layout fix: icon position lock now resets on non-`__post__` passes and on `TranslateOff`, so stale coordinates cannot push icon outside/clipped after width/anchor restoration.
- Reduced RTL icon X offsets (`title: 0`, `progress: 4`) to keep overlay inside reserved header area.
- Added runtime RTL X-clamp against parent right edge (`GetRight` + icon string width) so title icon cannot render outside quest frame even if title width/anchors jitter.
- Added explicit RTL right padding for title width (`titleRightPadding = 8`) and increased icon right-edge clamp padding (`rightEdgePadding = 8`).

## Temporary Constraints
-

## Blockers
-