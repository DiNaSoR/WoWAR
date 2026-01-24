# Mnemo Memory Customization Prompt (paste into an AI)

You are an AI coding agent. Your task is to **customize the Mnemo memory system** created by running `memory.ps1` in the root of THIS repository.

## Non-negotiable rules

- **Do not lose legacy memory.** If you find an older memory system (e.g. `Archive/`, `.cursor_old/`, `docs/memory/`, etc.), copy it into:
  - `.cursor/memory/legacy/<source-name>/`
- **Do not overwrite** the new Mnemo structure unless explicitly required. Prefer merge + preserve.
- Keep the always-read layer token-safe:
  - `.cursor/memory/hot-rules.md` stays ~20 lines (hard invariants only).
  - `.cursor/memory/memo.md` is â€œcurrent truthâ€, not history (move history into journals).
- Mnemo authority order (highest â†’ lowest):
  - Lessons > active-context > memo > journal.

## Deliverable (what you must produce)

1) Project-customized memory in `.cursor/memory/` (memo + index + regression checklist updated).  
2) Legacy memory preserved in `.cursor/memory/legacy/...`.  
3) Lint passes for the memory system.

## Required steps

### 1) Inventory this repo

- Identify the project type, main entrypoints, key modules, build/test commands, and â€œhotâ€ folders.

### 2) Update `.cursor/memory/memo.md` (project truth)

Fill it with high-signal bullets:
- Ownership map (which folder/module owns what)
- Invariants/constraints (forbidden APIs, timing constraints, state ownership rules)
- Load order requirements (if relevant)
- Integration points (plugins, external systems)

Keep it short; no journaling here.

### 3) Update `.cursor/memory/index.md` (orientation)

- Add a â€œHotspotsâ€ section listing the most bug-prone or most-edited files/dirs.
- Add a short â€œIf you only remember one thingâ€ section (max 3 bullets).

### 4) Update `.cursor/memory/regression-checklist.md`

Make it match this repoâ€™s reality:
- Build/test commands
- Runtime/manual checks
- Areas that commonly regress

### 5) Import legacy journals

- Merge/copy legacy monthly journals into `.cursor/memory/journal/YYYY-MM.md`
- Ensure each date header appears once per month (`## YYYY-MM-DD`)

### 6) Convert legacy lessons into atomic lessons (if needed)

If legacy has a single `lessons.md`:
- Convert it into individual files:
  - `.cursor/memory/lessons/L-001-*.md`, `L-002-*.md`, â€¦
- Each lesson must have valid YAML frontmatter required by the linter.
- If you introduce new tags, add them to `.cursor/memory/tag-vocabulary.md`.

### 7) Rules cleanup (recommended)

If `.cursor/rules/` contains duplicated always-apply rules:
- Merge into a single rule file (keep it readable with headings).
- Remove duplicates to avoid conflicting instructions.

### 8) Ensure SQLite index build works (Windows)

If `scripts/memory/rebuild-memory-index.ps1` tries to use `python` but Windows has the Microsoft Store stub:
- Make Python detection robust by trying `python`, then `py -3`, then `py`.

Expected SQLite output:
- `.cursor/memory/memory.sqlite`

### 9) Rebuild indexes + lint

Run:

`powershell
powershell -ExecutionPolicy Bypass -File scripts/memory/rebuild-memory-index.ps1
powershell -ExecutionPolicy Bypass -File scripts/memory/lint-memory.ps1
`

Fix any lint errors you introduced.

## Final response format

- What you changed (files + why)
- Where legacy memory is preserved
- Lint result (pass/fail + any warnings)