---
id: L-004
title: Tooltip placeholder functions must actually substitute values
status: Active
tags: [Tooltips, Text]
introduced: 2026-01-24
applies_to:
  - common/Tooltips/**
triggers:
  - shows "{1}%" literally
  - shows "{2} seconds" literally
rule: When translation data contains `{1}`, `{2}`, etc., implement extraction from the original and substitute into the translation before RTL processing.
---

# L-004 - Tooltip placeholder functions must actually substitute values

## Symptom

Tooltip translations show literal `{1}%` or `{2} seconds` instead of actual values like `20%` or `8 seconds`.

## Root cause

`ST_TranslatePrepare(origin, tlumacz)` was intended to extract values from the original English and substitute into placeholders, but a stub implementation returned the translation unchanged.

## Wrong approach (DO NOT REPEAT)

Assuming the proxy function will be overridden elsewhere, or assuming pre-shaped translation data doesn't need runtime value substitution.

## Correct approach

Implement value extraction and substitution logic using the `(origin, tlumacz)` inputs. Substitute into `{1}`, `{2}`, `{3}` before returning.

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-004)
