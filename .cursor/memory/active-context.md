# Active Context (Session Scratchpad)

Priority: this overrides older journal history *for this session only*.

CLEAR this file when the task is done:
- Run `scripts/memory/clear-active.ps1`

## Current Goal
- Quest rewards RTL alignment improvements.

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
- **NEW**: `ItemReceiveText` ("أيضاً سوف تأخذ:") and `ItemChooseText` ("ستستلم:") had hardcoded `SetWidth(260)` with Blizzard's left-anchor intact → text was right-justified inside a 260px box that doesn't reach the frame's right edge → visible gap vs XP label.
- Fixed by computing `rewardLabelW = max(200, frameWidth - 8)` dynamically so the box right edge matches the XP label's right edge (RIGHT, frame, RIGHT, -8).
- Added `SetWidth(0)` reset for `ItemChooseText` in both the LTR else-branch and `TranslateOff` (was missing).

## Temporary Constraints
-

## Blockers
-