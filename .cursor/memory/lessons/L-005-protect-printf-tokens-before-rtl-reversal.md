---
id: L-005
title: printf-style format tokens must be protected before RTL reversal
status: Active
tags: [Text, RTL]
introduced: 2026-01-24
applies_to:
  - common/Text.lua
triggers:
  - "%s becomes s%"
  - "%1$s becomes corrupted"
rule: In `HandleWoWSpecialCodes`, protect printf tokens (standard + positional) before running RTL reversal.
---

# L-005 - printf-style format tokens must be protected before RTL reversal

## Symptom

Strings containing `%s`, `%d`, `%1$s`, `%.2f` become corrupted after Arabic RTL processing (e.g., `%s` → `s%`, `%1$s` → `s$1%`).

## Root cause

WoW escape codes were protected, but printf-style format tokens were not protected and are sensitive to character order reversal.

## Wrong approach (DO NOT REPEAT)

Assuming only WoW-specific codes need protection.

## Correct approach

Protect printf tokens in `HandleWoWSpecialCodes` using patterns for:
- Standard tokens: `%%%-?%d*%.?%d*[sdifFeEgGxXouc]`
- Positional tokens: `%%%d+%$%-?%d*%.?%d*[sdifFeEgGxXouc]`

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-005)
