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

## Findings / Decisions
- Reserved 30px for glyph in RTL title width; positioned glyph at RIGHT edge of title
- Merged DebugUI and DebugToolsUI into single tabbed panel
- RTL reversal now auto-protects plain numeric tokens inside `Text.HandleWoWSpecialCodes` to prevent digit order flipping (e.g., "27" staying "27" after reversal).

## Temporary Constraints
-

## Blockers
-