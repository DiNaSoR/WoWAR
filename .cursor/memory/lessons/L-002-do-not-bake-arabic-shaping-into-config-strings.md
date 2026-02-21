---
id: L-002
title: Don't bake Arabic shaping into config strings at load time
status: Active
tags: [Config, Text, RTL]
introduced: 2026-01-24
applies_to:
  - common/Config/**
  - common/Text.lua
triggers:
  - config description unshaped
  - RTL text looks wrong in settings UI
rule: Keep config metadata as raw strings and apply shaping/RTL at render time (or guarantee TOC load order for shaping helpers).
---

# L-002 - Don't bake Arabic shaping into config strings at load time

## Symptom

Arabic descriptions in the settings UI show without reshaping/RTL (letters look unjoined / order looks wrong), especially for newly added strings.

## Root cause

`QTR_ReverseIfAR` (and the reshaper) are loaded later in the TOC (`common/Text.lua`), so any localization resolved earlier can freeze unshaped text into module metadata.

## Wrong approach (DO NOT REPEAT)

Compute and store shaped/reversed description strings during addon file load.

## Correct approach

- Keep stored config metadata as raw strings and apply shaping/RTL at render time (e.g., when rendering the settings panel).
- Or ensure TOC load order guarantees shaping helpers exist before localization is resolved.

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-002)
