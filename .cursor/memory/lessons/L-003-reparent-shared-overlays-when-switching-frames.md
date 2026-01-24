---
id: L-003
title: Re-parent shared overlay elements when switching parent frames
status: Active
tags: [Quests, UI]
introduced: 2026-01-24
applies_to:
  - common/Quests/**
triggers:
  - overlay disappears after switching frames
  - works only on first-open UI
rule: If an overlay is reused across multiple parent frames, call `SetParent(currentParent)` each time you position/apply it.
---

# L-003 - Re-parent shared overlay elements when switching parent frames

## Symptom

A UI element (e.g., quest title decoration glyph) appears only on whichever frame opens first (QuestMapFrame or QuestFrame); switching to the other frame makes it disappear until `/reload`.

## Root cause

The overlay FontString/Frame was created once and parented to the first frame's parent. When that parent is hidden, WoW hides all children.

## Wrong approach (DO NOT REPEAT)

Create the overlay element once and never update the parent.

## Correct approach

When the shared overlay may be used across multiple parent frames, call `SetParent(currentParent)` each time the overlay is positioned—not just during initial creation.

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-003)
