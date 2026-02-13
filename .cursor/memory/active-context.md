# Active Context (Session Scratchpad)

Priority: this overrides older journal history *for this session only*.

CLEAR this file when the task is done:
- Run `scripts/memory/clear-active.ps1`

## Current Goal
- Fixed glyph overlap in RTL quest titles
- Updated DebugToolsUI with tabbed interface

## Files in Focus
- `common/Quests/Details.lua`
- `common/UI/DebugToolsUI.lua`
- `common/UI/Welcome.lua`

## Findings / Decisions
- Reserved 14px for glyph in RTL title width; positioned glyph at RIGHT edge of title
- Merged DebugUI and DebugToolsUI into single tabbed panel
- RTL reversal now auto-protects plain numeric tokens inside `Text.HandleWoWSpecialCodes` to prevent digit order flipping (e.g., "27" staying "27" after reversal).
- Consolidated quest header width adjustment to a single pass (glyph reserve applied once).
- Welcome screen: reduce RTL text width by 5px and use `WOWTR_Font1` for the title to improve bidi rendering.
- Welcome screen: center title shaping (no RIGHT expand) and apply `-40` width correction to body text.

## Temporary Constraints
-

## Blockers
-