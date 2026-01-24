---
id: L-001
title: Avoid Lua "a and b or default" for booleans
status: Active
tags: [Config]
introduced: 2026-01-24
applies_to:
  - common/Config/**
triggers:
  - checkbox stuck ON
  - checkbox stuck OFF
rule: For boolean values, do not use `a and b or default`; use explicit conditionals or boolean-safe expressions.
---

# L-001 - Avoid Lua "a and b or default" for booleans

## Symptom

A checkbox/toggle appears stuck ON (or stuck OFF) even though click handlers run.

## Root cause

Using the Lua idiom `a and b or default` where `b` can be `false` causes the expression to fall through to `default`.

## Wrong approach (DO NOT REPEAT)

`return p and p.minimap and (not p.minimap.hide) or true`

## Correct approach

- Use an explicit conditional:
  - `if p and p.minimap then return not p.minimap.hide end; return true`
- Or a boolean-safe expression:
  - `return not (p and p.minimap and p.minimap.hide)`

## References

- Legacy source: `.cursor/memory/legacy/lessons.md` (L-001)
