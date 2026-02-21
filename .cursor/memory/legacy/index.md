# WoWLang / WoWAR – Memory Index

## Read order (fast + reliable)
1) `memo.md` (current truth)
2) `lessons.md` (hard rules)
3) `regression-checklist.md` (when touching Quests/RTL/Text/Tooltips)
4) Latest monthly journal (why/when history)

## Memory map
- Current truth: `memo.md`
- Never-break rules: `lessons.md`
- Change history (monthly): `journal/`
- Journal index: `journal.md`
- Regression checks: `regression-checklist.md`

## Hotspots (where bugs tend to happen)
- QuestMapFrame / Quest details behavior:
  - `common/Quests/Details.lua`
- RTL shaping + WoW special codes preservation:
  - `common/Text.lua`
  - `ns.RTL.*` (central RTL detection)
- Fonts / Arabic font ownership:
  - `common/UI/Fonts.lua`
- Tooltips ownership (avoid duplicates):
  - `common/Tooltips/*`
- Hook/ticker wiring helpers:
  - `common/Core/HookUtils.lua`
- Legacy globals compat:
  - `common/Core/Compat.lua`
- Data-driven UI translation helper:
  - `common/UI/Translate.lua`
- Config tabs patterns:
  - `common/Config/*`
  - `common/Config/Helpers.lua` (`WOWTR.Config.MakeTab()`)

## “If you only remember one thing”
- Never call Blizzard QuestMapFrame refresh APIs to control translation state.
- RTL depends on real Arabic QuestData (data-driven), not user preference alone.
- Tooltip hooks must have exactly one owning subsystem.
