---
id: L-012
title: Debug presets via /wowardebug preset <name>
status: Active
tags: [Debug, DX, Architecture]
introduced: 2026-02-20
applies_to:
  - *
triggers:
  - TODO: add error messages or keywords
rule: Use /wowardebug preset <name> to switch between off/minimal/quest-investigation/ui-dump/full-trace. Each preset sets Debug.IsEnabled and per-category verbosity levels atomically. Debug.SetPreset() persists to AceDB profile. Never hardcode local debug flags in modules; always gate on WOWTR.Debug.ShouldPrint(category, verbosity).
---

# L-012 - Debug presets via /wowardebug preset <name>

## Symptom

TODO: Describe what happened

## Root Cause

TODO: Describe why it happened

## Wrong Approach (DO NOT REPEAT)

- TODO: What not to do

## Correct Approach

- TODO: What to do instead

## References

- Files: `TODO`
- Journal: `journal/2026-02.md#2026-02-20`