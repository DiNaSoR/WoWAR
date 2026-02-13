# Project Memory (Mnemo)

This project uses [Mnemo](https://github.com/DiNaSoR/Mnemo) for structured AI memory.
Memory lives in `.cursor/memory/` as the single source of truth.

## Read Order (ALWAYS)
1. `.cursor/memory/hot-rules.md` - tiny invariants (<20 lines)
2. `.cursor/memory/active-context.md` - current session state
3. `.cursor/memory/memo.md` - long-term project truth + ownership

## Search First, Then Fetch
- `.cursor/memory/lessons/index.md` â†’ find lesson ID â†’ open only that lesson file
- `.cursor/memory/digests/YYYY-MM.digest.md` â†’ before raw journal archaeology
- `.cursor/memory/journal/YYYY-MM.md` â†’ only for deep history

## After Any Feature/Fix
1. Update `active-context.md` during work
2. Add journal entry when done
3. Create lesson if you discovered a pitfall
4. Update `memo.md` if project truth changed
5. Clear `active-context.md` when task is merged