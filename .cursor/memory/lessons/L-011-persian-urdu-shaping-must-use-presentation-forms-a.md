---
id: L-011
title: Persian/Urdu shaping must use Presentation Forms-A for extended letters
status: Active
tags: [Text, RTL]
introduced: 2026-01-24
applies_to:
  - common/Text/**
  - WoWAR/WoW_Arabic_Reshaper.lua
triggers:
  - Persian letters become wrong Arabic letters
  - FB50 FDFF mapping
rule: For Persian/Urdu extended letters, map to the correct Presentation Forms-A (FB50–FDFF) code points, not Forms-B (FE70–FEFF).
---

# L-011 - Persian/Urdu shaping must use Presentation Forms-A for extended letters

## Symptom

Persian/Urdu letters reshape into completely different Arabic letters (e.g., پ becomes ح-like forms, ی becomes Lam-Alef ligatures).

## Root cause

Using Arabic Presentation Forms-B code points (FE70–FEFF) for Persian/Urdu extension letters whose correct glyph forms are defined in Arabic Presentation Forms-A (FB50–FDFF).

## Wrong approach (DO NOT REPEAT)

“Guessing” presentation form ranges for extended letters or copying unrelated FE** forms from similar-looking Arabic letters.

## Correct approach

For extended letters, verify exact Unicode presentation forms and use correct FB** mappings, e.g.:

- PEH: FB56–FB59
- TCHEH: FB7A–FB7D
- JEH: FB8A–FB8B (isolated/final)
- KEHEH: FB8E–FB91
- GAF: FB92–FB95
- DAHAL: FB84–FB85 (isolated/final)
- FARSI YEH: FBFC–FBFF

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-011)
