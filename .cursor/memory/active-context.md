# Active Context (Session Scratchpad)

Priority: this overrides older journal history *for this session only*.

CLEAR this file when the task is done:
- Run `scripts/memory/clear-active.ps1`

## Current Goal
- Fix secret-value crash in `Text.ContainsArabic` during tooltip show.

## Files in Focus
- `common/Text.lua`
- `common/Tooltips/Hooks.lua`

## Findings / Decisions
- Tooltip line text can be a secret value; guard comparisons/string ops.

## Temporary Constraints
-

## Blockers
-