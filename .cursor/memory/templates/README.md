# Memory Templates (WoWLang / WoWAR)

Use these templates to keep memory consistent and easy for humans + AI to follow.

## Journal entries
- Copy `journal-entry.md` into the active monthly journal file (e.g. `.cursor/memory/journal/2026-01.md`).
- Journal is append-only. Never rewrite old entries.

## Lessons
- Copy `lesson.md` into `.cursor/memory/lessons.md`.
- Lessons are append-only. Never delete old lessons.
- If replacing an older lesson, write a NEW lesson and set "Supersedes:".

## ADRs (Architecture Decision Records)
- Use `adr.md` when a decision is “design/architecture” rather than “bug rule”.
- ADRs explain *why*, lessons explain *what not to repeat*.

## Memo updates
- Use `memo-update.md` as a checklist when the “current truth” changes.

## Regression notes
- Use `regression-note.md` to keep test coverage consistent in journal entries.
