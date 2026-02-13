# Lessons Index (generated)

Generated: 2026-02-13T22:58:29+03:00

Format: ID | [Tags] | AppliesTo | Rule | File

L-001 | [Config] | common/Config/** | For boolean values, do not use `a and b or default`; use explicit conditionals or boolean-safe expressions. | `L-001-avoid-and-or-for-booleans.md`
L-002 | [Config][Text][RTL] | common/Config/**, common/Text.lua | Keep config metadata as raw strings and apply shaping/RTL at render time (or guarantee TOC load order for shaping helpers). | `L-002-do-not-bake-arabic-shaping-into-config-strings.md`
L-003 | [Quests][UI] | common/Quests/** | If an overlay is reused across multiple parent frames, call `SetParent(currentParent)` each time you position/apply it. | `L-003-reparent-shared-overlays-when-switching-frames.md`
L-004 | [Tooltips][Text] | common/Tooltips/** | When translation data contains `{1}`, `{2}`, etc., implement extraction from the original and substitute into the translation before RTL processing. | `L-004-tooltip-placeholder-functions-must-substitute-values.md`
L-005 | [Text][RTL] | common/Text.lua | In `HandleWoWSpecialCodes`, protect printf tokens (standard + positional) before running RTL reversal. | `L-005-protect-printf-tokens-before-rtl-reversal.md`
L-006 | [Text][RTL] | common/Text.lua, common/Tooltips/** | When substituting values into text that will be RTL-reversed, wrap values with markers so the special-code protector preserves them. | `L-006-protect-substituted-values-through-rtl-reversal.md`
L-007 | [Tooltips] | common/Tooltips/** | Use number patterns that require a digit (e.g. `%-?%d[%d,]*%.?%d*`), not patterns that match commas alone. | `L-007-number-extraction-must-require-a-digit.md`
L-008 | [Tooltips][RTL] | common/Tooltips/** | Apply RTL justification only when the tooltip actually contains Arabic characters, not merely when the addon is in Arabic mode. | `L-008-rtl-justification-only-when-arabic-content-exists.md`
L-009 | [Config] | common/Config/**, common/Locale/** | Store historical changelog dates as stable data strings (or parsed stable timestamps), never `date()`/`time()` at load/build time. | `L-009-changelog-dates-must-be-data-not-runtime.md`
L-010 | [Text][RTL][Reliability] | common/Text/**, WoWAR/WoW_Arabic_Reshaper.lua | Ensure all paths in UTF-8 byte-length helpers return a number; for invalid/unexpected bytes return 1. | `L-010-utf8-charbyte-helpers-must-never-return-nil.md`
L-011 | [Text][RTL] | common/Text/**, WoWAR/WoW_Arabic_Reshaper.lua | For Persian/Urdu extended letters, map to the correct Presentation Forms-A (FB50–FDFF) code points, not Forms-B (FE70–FEFF). | `L-011-persian-urdu-shaping-must-use-presentation-forms-a.md`