---
id: L-009
title: Changelog dates must be data, not runtime time()
status: Active
tags: [Config]
introduced: 2026-01-24
applies_to:
  - common/Config/**
  - common/Locale/**
triggers:
  - release notes show today's date
rule: Store historical changelog dates as stable data strings (or parsed stable timestamps), never `date()`/`time()` at load/build time.
---

# L-009 - Changelog dates must be data, not runtime time()

## Symptom

Release Notes show today’s date for every historical version entry.

## Root cause

Using runtime `date()`/`time()` when building changelog metadata stamps entries at addon load/build time, not at the actual release time.

## Wrong approach (DO NOT REPEAT)

`date = date("%d %b %Y")` or `timestamp = time()` for historical changelog entries.

## Correct approach

Store a hardcoded release date string in the changelog entry and have the UI display that string (or parse it into a stable timestamp once) instead of calling `date()`/`time()` for past releases.

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-009)
