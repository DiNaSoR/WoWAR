# WoWAR Engineering Guidelines

> Status: Normative project guidance
>
> Scope: First-party Lua, XML, translation data, configuration, and UI integration
>
> Last verified against the working tree: 2026-07-31

These rules capture durable project knowledge. Follow them unless the current code and an explicitly documented replacement design establish a newer contract.

## Work from Existing Ownership

- Read [`WoWAR.toc`](../WoWAR.toc) and the owning module before adding a helper, hook, global, timer, or state table.
- Extend the existing subsystem instead of creating a parallel implementation.
- Keep compatibility globals thin and route new logic through module-owned APIs.
- Do not edit embedded libraries under `common/Libs` for project behavior.
- Treat load order, optional frame availability, and `/reload` re-entry as normal runtime constraints.

## Lua Correctness and Runtime Safety

- Do not use `condition and value or fallback` when `value` may legitimately be `false`. Use an explicit conditional or a boolean-safe expression. This is especially important for inverted settings such as `minimap.hide`.
- Type-check SavedVariables and optional API results before use.
- WoW can expose secret values that reject normal string operations. Guard text inspection with `pcall` and fail safely.
- UTF-8 byte helpers must always return a numeric advance. Invalid or incomplete input must use a safe fallback such as one byte, never `nil`.
- Numeric extraction patterns must require at least one digit. Avoid patterns whose entire numeric body can match an empty string.
- Clamp timer intervals and deduplicate scheduled work. Never turn a zero interval into per-frame churn accidentally.

## Localization Data and Text Transformation

- Store localization and Control Center metadata as raw logical strings. Apply Arabic shaping and reversal when the text is rendered.
- Use [`ns.RTL.IsRTL()`](../common/RTL.lua) for direction decisions instead of scattering raw locale checks.
- Direction alone is not proof that a specific string is Arabic. Apply RTL justification or shaping only when the resolved content contains Arabic.
- Keep source strings and persisted captures in logical form. Display-time shaping must not mutate translation tables or saved source text.
- Protect WoW markup, placeholders, substituted values, and numbers before reversal. See [Arabic Text Rendering](QTR_ExpandUnitInfo_RTL_Bidi_Implementation_Prompt.md).
- Standard and positional `printf` tokens both require protection.
- Values substituted into tooltip strings must be resolved from the original text before shaping. Wrap resolved values in the pipeline's protected-value markers so values such as `20` cannot become `02`.
- Persian and Urdu letters that are supported by the reshaper must use their Presentation Forms-A mappings, including PEH, TCHEH, JEH, KEHEH, GAF, DAHAL, and FARSI YEH.

## RTL Layout

- Do not mirror an entire frame globally. Prefer right justification, an explicit usable width, and targeted anchor changes for the few rows whose reading order changes.
- Every RTL anchor, width, font, or justification mutation must have a deterministic LTR/off reset.
- Give right-justified Arabic labels enough width and right padding to avoid glyph clipping.
- For label/value rows, anchor the Arabic label to the right edge and place the value to its left. Restore the original label and value anchors in LTR mode.
- Reparent shared overlays every time they move to a different host frame; changing anchors does not change the parent or draw hierarchy.
- If a FontString is constrained by both left and right anchors, `SetWidth` alone may not change its effective width. Adjust the appropriate anchor inset.
- Use `QTR_ReverseIfAR` for short, non-wrapping labels when width-aware paragraph processing would be unnecessary or unstable.

## Quest UI Invariants

- `QTR_curr_trans` is the authoritative quest translation toggle state. Fallback logic must not flip it.
- Apply QuestMapFrame translation after Blizzard has finished its layout pass.
- Do not call Blizzard force-refresh APIs during translation toggles.
- Enable Arabic quest headers, fonts, and RTL layout only when the current quest has real Arabic QuestData.
- When Arabic quest data is missing, show the original English body with original headers and LTR layout.
- Render quest-title decorations separately from the shaped Arabic title:
  - keep the Arabic title string free of decoration hyperlinks;
  - use an overlay FontString with the original font for glyph or atlas/texture decorations;
  - reparent the overlay to the current host;
  - anchor it to the right in RTL and to the left in LTR;
  - tie its vertical position to the title FontString, not only the parent frame.
- Quest reward labels need explicit width and inset handling. Verify item-choice, item-receive, money, currency, and XP rows together.

## Configuration Invariants

- AceDB profile data in `WOWTR_DB` is the durable source of truth.
- [`common/Core/LegacyBridge.lua`](../common/Core/LegacyBridge.lua) is the only source of truth for profile-to-legacy mapping.
- Migrate legacy settings into AceDB only when the AceDB table does not already exist. Re-running migration can overwrite a user's saved profile.
- Synchronize legacy runtime tables after any setting mutation and after profile change, copy, or reset.
- The active presentation is the Control Center under [`common/Config/ControlCenter`](../common/Config/ControlCenter). Do not revive separate configuration UIs without an explicit design decision.
- Keep mutually exclusive values normalized. The bubble configuration prefers translated chat output when both English and translated chat flags are true.

## Shared UI and Hook Ownership

- Tooltip hooks, tooltip fonts, and tooltip layout belong only to [`common/Tooltips`](../common/Tooltips).
- Arabic font registration and general application belong to [`common/UI/Fonts.lua`](../common/UI/Fonts.lua).
- Prefer data-driven Blizzard UI translation through [`common/UI/Translate.lua`](../common/UI/Translate.lua) over ad hoc frame patches.
- Register legacy `ST_*` wrappers in [`common/Core/Compat.lua`](../common/Core/Compat.lua), not throughout feature files.
- Use [`common/Core/HookUtils.lua`](../common/Core/HookUtils.lua) for shared hook and ticker patterns.
- Hooks must be idempotent. A reload, repeated `OnShow`, or optional-addon activation must not double output or register duplicate handlers.
- Guard protected UI work with `InCombatLockdown()` when relevant and defer unsafe mutations.

## Debugging and Player-Facing Content

- Route debug output through `WOWTR.Debug.ShouldPrint` and the shared debug modules.
- Prefer `/wowardebug preset <name>` for repeatable diagnostic configurations. Do not add one-off local debug booleans.
- Keep debug capture bounded and disabled during normal play.
- Changelog dates in [`common/Locale/changelog.lua`](../common/Locale/changelog.lua) are static content. Do not compute them with `date()` or `time()` at addon load.
- Changelog text should be player-facing and avoid internal API or function names.
- Use changelog color tokens sparingly: dates and headings may carry accents while body text stays readable.

## Completion Checklist

Before considering a runtime change complete:

1. Confirm the change lives in the existing owner and respects `WoWAR.toc` order.
2. Verify both Arabic and fallback/LTR paths.
3. Toggle the affected feature off and on to expose stale state.
4. Check markup, numbers, mixed Arabic/Latin text, and first-show sizing when text rendering changed.
5. Confirm hooks and timers are not duplicated.
6. Run the applicable scenarios in [Regression Testing](RegressionTesting.md).
7. Update maintained documentation if a contract, mapping, ownership boundary, or test requirement changed.
