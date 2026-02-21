---
id: L-007
title: Number extraction patterns must require at least one digit
status: Active
tags: [Tooltips]
introduced: 2026-01-24
applies_to:
  - common/Tooltips/**
triggers:
  - placeholder substituted with comma
rule: Use number patterns that require a digit (e.g. `%-?%d[%d,]*%.?%d*`), not patterns that match commas alone.
---

# L-007 - Number extraction patterns must require at least one digit

## Symptom

A placeholder like `{3}` shows a comma `,` or other punctuation instead of the expected number.

## Root cause

Pattern `[%d,]+` matches one or more digits OR commas, so a lone comma in the original text can be extracted as a "number".

## Wrong approach (DO NOT REPEAT)

Using `%-?[%d,]+%.?%d*` to extract numbers.

## Correct approach

Use `%-?%d[%d,]*%.?%d*` which requires at least one digit before allowing optional commas.

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-007)
