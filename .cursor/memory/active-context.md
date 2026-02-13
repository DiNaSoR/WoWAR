# Active Context (Session Scratchpad)

Priority: this overrides older journal history *for this session only*.

CLEAR this file when the task is done:
- Run `scripts/memory/clear-active.ps1`

## Current Goal
- Fixed glyph overlap in RTL quest titles
- Updated DebugToolsUI with tabbed interface
- Remove vector smoke script and validate normal vector tools flow
- Enforce vector-first retrieval policy for future AI runs
- Enforce post-vector grounding so answers do not stay digest-only

## Files in Focus
- `common/Quests/Details.lua`
- `common/UI/DebugToolsUI.lua`
- `common/UI/Welcome.lua`
- `scripts/memory/mnemo_vector.py`
- `.cursor/rules/01-vector-search.mdc`

## Findings / Decisions
- Reserved 14px for glyph in RTL title width; positioned glyph at RIGHT edge of title
- Merged DebugUI and DebugToolsUI into single tabbed panel
- RTL reversal now auto-protects plain numeric tokens inside `Text.HandleWoWSpecialCodes` to prevent digit order flipping (e.g., "27" staying "27" after reversal).
- Consolidated quest header width adjustment to a single pass (glyph reserve applied once).
- Welcome screen: reduce RTL text width by 5px and use `WOWTR_Font1` for the title to improve bidi rendering.
- Welcome screen: center title shaping (no RIGHT expand) and apply `-40` width correction to body text.
- Removed `scripts/memory/vector-smoke.ps1` and switched back to normal vector tool validation (`vector_health`, `vector_sync`, `vector_search`).
- Normal vector tools currently pass with Gemini provider and return semantic hits.
- Updated `.cursor/rules/01-vector-search.mdc` to mandatory vector-first retrieval with fallback-only non-vector search.
- Updated `.cursor/rules/01-vector-search.mdc` with mandatory post-search grounding (read top refs, expand digest -> journal) before final answers.

## Temporary Constraints
-

## Blockers
-