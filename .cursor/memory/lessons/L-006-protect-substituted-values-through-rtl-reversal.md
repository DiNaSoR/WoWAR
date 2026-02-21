---
id: L-006
title: Values substituted before RTL reversal must be marked for protection
status: Active
tags: [Text, RTL]
introduced: 2026-01-24
applies_to:
  - common/Text.lua
  - common/Tooltips/**
triggers:
  - number reversed (20 -> 02)
rule: When substituting values into text that will be RTL-reversed, wrap values with markers so the special-code protector preserves them.
---

# L-006 - Values substituted before RTL reversal must be marked for protection

## Symptom

Numbers like "20" appear reversed as "02" in Arabic tooltips after `{1}` placeholder substitution.

## Root cause

`ST_TranslatePrepare` substitutes `{1}` → `20` before RTL reversal/protection runs, so the number is treated as normal text and gets reversed.

## Wrong approach (DO NOT REPEAT)

Directly substituting values into translation text without considering it will go through RTL reversal.

## Correct approach

Wrap substituted values with marker characters (e.g., `\003VALUE\004`) that `HandleWoWSpecialCodes` recognizes and protects, restoring the value intact after reversal.

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-006)
