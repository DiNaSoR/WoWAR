---
id: L-010
title: UTF-8 char-byte helpers must never return nil
status: Active
tags: [Text, RTL, Reliability]
introduced: 2026-01-24
applies_to:
  - common/Text/**
  - WoWAR/WoW_Arabic_Reshaper.lua
triggers:
  - attempt to perform arithmetic on a nil value
  - AS_UTF8charbytes
rule: Ensure all paths in UTF-8 byte-length helpers return a number; for invalid/unexpected bytes return 1.
---

# L-010 - UTF-8 char-byte helpers must never return nil

## Symptom

Random crash: “attempt to perform arithmetic on a nil value” during UTF-8 iteration (e.g., `pos = pos + AS_UTF8charbytes(...)`).

## Root cause

`AS_UTF8charbytes` had a control-flow path that fell through without returning a numeric byte length, yielding `nil`.

## Wrong approach (DO NOT REPEAT)

Having a final `else` branch that logs/prints but does not return a number.

## Correct approach

Ensure all code paths return a number; for unexpected/invalid bytes, return `1` as a safe single-byte fallback.

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-010)
