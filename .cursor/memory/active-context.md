# Active Context (Session Scratchpad)

Priority: this overrides older journal history *for this session only*.

CLEAR this file when the task is done:
- Run `scripts/memory/clear-active.ps1`

## Current Goal
- Fix quest rewards XP field (`الخبرة`) to render true RTL (label/value order + alignment).

## Files in Focus
- `common/Quests/Details.lua`

## Findings / Decisions
- XP row was still LTR-anchored in AR (`ValueText` to the right of `ReceiveText`), so `الخبرة` looked non-RTL.
- Updated AR XP rows (`QuestInfoXPFrame`, `QuestInfoRewardsFrame.XPFrame`) to:
  - right-justify + apply width to label,
  - anchor value to the LEFT of label (`RIGHT` -> `LEFT` with negative gap).
- Added EN/off resets for XP widths/anchors/justification so toggles don't keep stale RTL anchors.
- Root cause refinement: value disappeared because label was still LEFT-anchored while value was moved to label's LEFT; this pushed value off the frame.
- Fixed by right-anchoring XP `ReceiveText` itself in AR (`SetPoint("RIGHT", frame, "RIGHT", -8, 0)`) before placing value to its left.
- Added explicit LTR reset for `QuestInfoRewardsFrame.XPFrame` in `TranslateOff` (label/value anchor + justify + width), not only `QuestInfoXPFrame`, to avoid persistent RTL after toggle OFF.

## Temporary Constraints
-

## Blockers
-