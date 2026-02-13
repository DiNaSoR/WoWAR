# Memory System (Mnemo)

This project uses Mnemo for structured AI memory.
Memory location: `.cursor/memory/`

## Retrieval Order
1. Read `.cursor/memory/hot-rules.md` first (tiny, <20 lines)
2. Read `.cursor/memory/active-context.md` for current session
3. Read `.cursor/memory/memo.md` for project truth + ownership
4. Search `.cursor/memory/lessons/index.md` before creating new patterns
5. Check `.cursor/memory/digests/` before raw journal archaeology

## Authority Order (highest to lowest)
1. Lessons override EVERYTHING
2. active-context.md overrides memo/journal (but NOT lessons)
3. memo.md is long-term project truth
4. Journal is history
5. Existing codebase
6. New suggestions (lowest priority)

## After Any Feature/Fix
- Update active-context.md during work (scratchpad)
- Add journal entry to journal/YYYY-MM.md when done
- Create lessons/L-XXX-title.md if you discovered a pitfall
- Update memo.md if project truth changed
- Clear active-context.md when task is merged