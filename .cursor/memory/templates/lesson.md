## L-XXX — <Short, specific title>

### Status
- Active | Superseded by L-YYY

### Tags
- [Quests] [RTL] [Text] [Tooltips] [Config] [Hooks] [Compat] (add what applies)

### Introduced
- YYYY-MM-DD

### Supersedes (optional)
- L-YYY — <why it is superseded>

### Symptom
- <What the user sees / what breaks>
- <Where it shows up (frame, module, UI path)>

### Root cause
- <The real underlying reason (timing, anchors, placeholder reversal, Blizzard refresh, etc.)>

### Wrong approach (DO NOT REPEAT)
- <The tempting fix that caused regressions or didn’t work>
- <Any specific API calls or patterns that are unsafe>

### Correct approach
- <The safe pattern that actually works>
- <Where it should live (which module “owns” it)>
- <Any constraints (post-layout pass, no anchor mirroring, data-driven RTL, etc.)>

### Rule
> <One-sentence invariant that future code must obey.>

### References
- Files:
  - `<path/file.lua>`
  - `<path/file.lua>`
- Related journal entry:
  - `journal/YYYY-MM.md#YYYY-MM-DD`
