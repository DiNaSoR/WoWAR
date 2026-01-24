# Memo Update Checklist (copy/paste into PR/commit notes, not into memo)

When the change affects “current truth” (stable behavior, invariants, ownership, architecture):

- [ ] Update `.cursor/memory/memo.md` `Last updated: YYYY-MM-DD`
- [ ] Add/update a bullet under the correct section:
  - Current state / ownership / invariants / load order
- [ ] Remove or revise any memo bullet that is no longer true
  - (Memo is allowed to change; it is not append-only)
- [ ] If this change encodes a “never repeat” mistake:
  - [ ] Add a new entry to `.cursor/memory/lessons.md`
- [ ] Add a journal entry:
  - [ ] What changed / why / key files / regression checks run

Memo style constraints:
- Keep memo short and high-signal (avoid journaling in the memo).
- Prefer “ownership + invariants + safe patterns” over implementation details.
