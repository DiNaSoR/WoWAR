---
id: L-008
title: RTL justification must check for actual Arabic content, not just locale
status: Active
tags: [Tooltips, RTL]
introduced: 2026-01-24
applies_to:
  - common/Tooltips/**
triggers:
  - English tooltip right-aligned
rule: Apply RTL justification only when the tooltip actually contains Arabic characters, not merely when the addon is in Arabic mode.
---

# L-008 - RTL justification must check for actual Arabic content, not just locale

## Symptom

English tooltips (without Arabic translation) appear right-aligned in Arabic mode, making them hard to read.

## Root cause

RTL justification code checked only the locale/language setting but didn't verify the tooltip actually contained Arabic text.

## Wrong approach (DO NOT REPEAT)

Applying RTL layout based solely on the addon's current language setting.

## Correct approach

Before applying RTL justification, check if any tooltip line contains Arabic characters (e.g., via `ContainsArabic()` / Unicode range checks). Apply RTL only when Arabic content exists.

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-008)
