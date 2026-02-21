---
name: wow-addon-dev
description: Best practices for World of Warcraft AddOn development in Lua (frames, events, hooks, SavedVariables, .toc load order, and performance). Use when working on WoW addons, Lua addon code, .toc files, Blizzard UI frames, hooksecurefunc, secure frames, or SavedVariables.
---

# WoW AddOn Dev (Lua) Best Practices

## Quick Start (use this checklist)

- Read the repo’s memory first: `.cursor/memory/hot-rules.md`, `active-context.md`, `memo.md`.
- Identify the correct entrypoint(s): `.toc`, main init file(s), and SavedVariables.
- Confirm load order constraints (what must exist before what).
- Implement changes with:
  - defensive nil checks (frames may not exist yet)
  - idempotent hooks (never double-hook)
  - no forbidden “force refresh” APIs unless explicitly proven safe for this project
- After changes: update journal + run relevant regression checklist.

## Core patterns

### Namespacing (avoid globals)

Prefer the WoW namespace pattern:

```lua
local addonName, ns = ...
ns = ns or {}
ns.Feature = ns.Feature or {}
```

- Keep global wrappers thin (compat only) and delegate to `ns.*`.
- Never create new global state without checking for an existing pattern.

### `.toc` load order is architecture

- Treat `.toc` order as a hard dependency graph.
- Load shared utilities before feature modules that call them.
- If a helper is referenced at file load time, it must be loaded earlier in `.toc`.

### Events (safe init + re-init)

- Register events on a single frame (or a small owned dispatcher).
- Handle both:
  - `ADDON_LOADED` (initialize SavedVariables and module state)
  - `PLAYER_LOGIN` (safe UI access; more frames exist)
- Be resilient to reloads (`/reload`) and partial UI availability.

### Hooks (idempotent, owned, minimal)

- Prefer `hooksecurefunc` over overwriting functions.
- Ensure hooks are **idempotent**:
  - guard with a flag (e.g. `if self._hooked then return end`)
  - or centralize hook registration in one module
- Establish **ownership**: one subsystem owns a hook set (avoid duplicate behavior).

### UI safety (frames can be nil)

- Always nil-check frames/regions; don’t assume Blizzard UI is loaded.
- If a frame is created later, hook its `OnShow` or delay work using a timer.
- Avoid heavy work in `OnUpdate`; prefer throttled timers or event-driven updates.

### Secure/protected frames

- Never attempt to change protected attributes in combat.
- If a change could touch protected UI, guard with `InCombatLockdown()` and defer.

### SavedVariables

- Treat saved data as untrusted:
  - nil-check, type-check, and apply defaults
- Keep migration one-time and versioned.
- Avoid writing large logs into SavedVariables unless gated (debug only).

## RTL / Localization (when applicable)

- Don’t scatter raw locale checks (e.g. `lang == "AR"`). Centralize directionality.
- Protect WoW markup (`|c`, `|T`, `|A`, `|H...|h...|h`) through any text transformations.
- Do not inject hyperlinks/markup into already-shaped RTL text; render decorations separately.

## Performance rules

- Localize hot globals (`local gsub = string.gsub`, etc.) in hot paths.
- Avoid repeated string allocations in loops.
- Prefer caching and reusing frames/FontStrings.
- Clamp “zero interval” tickers; never run per-frame churn unless strictly necessary.

## What to write into memory after work

- Journal: `.cursor/memory/journal/YYYY-MM.md` (what changed, why, key files).
- Memo: `.cursor/memory/memo.md` only when “project truth” changes.
- Lessons: create a new `lessons/L-XXX-*.md` when you discover a pitfall that must never repeat.

## Minimal test plan template (edit per repo)

- Reload UI (`/reload`), open the impacted UI, verify no errors.
- Toggle the affected feature(s) on/off.
- Verify hooks are not duplicated (no double output, no repeated handlers).
- If combat-sensitive: verify behavior with `InCombatLockdown()` constraints.

