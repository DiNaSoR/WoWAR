# Arabic Text Rendering and `QTR_ExpandUnitInfo`

> Status: Maintained implementation reference
>
> Scope: Arabic shaping, mixed-direction safety, WoW markup preservation, and UI integration
>
> Last verified against the working tree: 2026-07-31

The filename is retained for existing links. This document describes WoWAR's current implementation and caller contract; it is not a prompt for generating a new implementation.

## Owning Modules

| Responsibility | Code |
| --- | --- |
| Placeholder expansion, Arabic detection, special-code protection, public wrappers | [`common/Text.lua`](../common/Text.lua) |
| Arabic joining forms and width-aware visual line preparation | [`common/Text/Reshaper.lua`](../common/Text/Reshaper.lua) |
| Shared direction and alignment helpers | [`common/RTL.lua`](../common/RTL.lua) |
| Shared Arabic font registration/application | [`common/UI/Fonts.lua`](../common/UI/Fonts.lua) |

`Text.ExpandUnitInfo` is the module implementation. The compatibility wrapper is:

```lua
QTR_ExpandUnitInfo(msg, OnObjectives, AR_obj, AR_font, AR_corr, AR_RIGHT)
```

## API Contract

| Parameter | Contract |
| --- | --- |
| `msg` | Source string. `nil` becomes an empty string. |
| `OnObjectives` | Retained for call-site compatibility; currently unused. |
| `AR_obj` | Render object used for width and font discovery. Required for Arabic shaping and must provide `GetWidth()`. |
| `AR_font` | Optional font path passed to the width-aware reshaper. The target's font or `WOWTR_Font2` is used when omitted. |
| `AR_corr` | Optional numeric adjustment added to `AR_obj:GetWidth()`. Non-numeric values are ignored. |
| `AR_RIGHT` | Any truthy value selects `AS_ReverseAndPrepareLineText_RIGHT`; otherwise the normal width-aware variant is used. |

The function always performs project placeholder expansion through `WOW_ZmienKody`. It performs Arabic shaping and visual line preparation only when all of these are true:

- the active localization language is `AR`;
- `AR_obj` is present;
- the expanded result contains Arabic script.

If any gate fails, the expanded logical string is returned without the width-aware Arabic pass.

## Processing Pipeline

The order is deliberate:

1. Convert `nil` to an empty string.
2. Run `WOW_ZmienKody` to normalize project tokens and expand player, race, class, gender, name, color, and newline conventions.
3. Gate on Arabic localization, a target render object, and actual Arabic content.
4. Rewrite logical curly color spans into the order expected by the RTL reversal pass.
5. Discover the target font, size, and flags. The function tries the target itself and then a FontString region.
6. Replace WoW markup, dynamic placeholders, protected substituted values, and numeric runs with indexed sentinels.
7. Normalize internal newline and legacy curly-marker forms used by the reshaper.
8. Detect the source representation once. Logical Arabic is contextually shaped while each visual line is reversed; legacy text containing Arabic Presentation Forms is reversed without a second shaping pass.
9. Call the normal or right-mode width-aware line preparer with `AR_obj:GetWidth() + AR_corr`.
10. Adjust line spacing when the selected Arabic font has smaller metrics than the source font.
11. Restore all protected values, including sentinels whose delimiters and multi-digit indexes were reversed.
12. Reattach the optional `UE_COLOR:` prefix.

Changing this order can corrupt links, icons, format tokens, numbers, or color ownership.

## Protected Content

`Text.HandleWoWSpecialCodes` replaces protected content with `\001INDEX\002` and returns a lookup table.

| Content | Examples and notes |
| --- | --- |
| Pipe colors | `\|cAARRGGBB...\|r` |
| Named colors | `\|cnNORMAL_FONT_COLOR:...\|r` |
| Textures | `\|Tpath:size...\|t` |
| Atlases | `\|Aatlas:size...\|a` |
| Bracketed hyperlinks | `\|Htype:data\|h[label]\|h` |
| Generic hyperlinks | `\|Htype:data\|hlabel\|h` |
| Supported SimpleHTML tags | Normal `<TAG>` and legacy reversed `>GAT<` forms |
| Blizzard dynamic placeholders | `{1}`, `{2}`, `{12}`, and other numeric indexes |
| Standard `printf` tokens | `%s`, `%d`, `%10d`, `%.2f`, and supported conversion variants |
| Positional `printf` tokens | `%1$s`, `%2$d`, including width and precision variants |
| Resolved dynamic values | Values wrapped in `\003...\004` by the tooltip substitution path |
| Numeric runs | ASCII, Arabic-Indic, and Eastern Arabic-Indic digits with supported separators and a trailing percent sign |

Supported numeric separators are `.`, `,`, `:`, `/`, and `-` when a digit follows the separator. Examples such as `1,234.56`, `12:34`, `10/10`, `1-2`, and `27%` are restored in logical order.

The `UE_COLOR:` marker is stripped before shaping and returned separately because it is a prefix understood by other project code, not visible text.

## Sentinel Restoration

A normal protected token looks like:

```text
\00112\002
```

A full reversal can produce:

```text
\00221\001
```

`Text.RestoreWoWSpecialCodes` supports both forms. For the reversed form it reverses the digit string before indexing the lookup table. This is required once a line contains ten or more protected entries; treating `21` as the original index would restore the wrong token or nothing.

Visible sentinel characters or missing icons usually indicate one of these failures:

- a token pattern was not protected;
- a new transform ran after protection but before restoration and modified the sentinel;
- restoration handled only the normal orientation;
- a caller shaped the string a second time.

## Arabic Detection and Secret Values

`Text.ContainsArabic` recognizes base Arabic code points and Presentation Forms-A/B byte sequences. Its string operations run inside `pcall` because restricted WoW values may reject comparison or inspection.

The safe behavior on inspection failure is “not Arabic.” Do not replace this with a raw locale-only check: pure English content in an Arabic session must remain LTR and readable.

`Text.ContainsArabicPresentationForms` separates legacy pre-shaped content from logical Arabic source. Logical source goes through `AS_UTF8reverseRS`; legacy presentation-form strings stay on `AS_UTF8reverse` so they are not shaped twice. New player-facing copy should remain logical Arabic in source files; Presentation Forms are compatibility data, not an authoring format.

## Choosing the Rendering Helper

| Surface | Preferred helper | Reason |
| --- | --- | --- |
| Wrapped quest, gossip, tutorial, tooltip, book, or bubble body | `QTR_ExpandUnitInfo` | Uses the measured width to prepare visual lines |
| Short, single-line label or button | `QTR_ReverseIfAR` | Contextually shapes logical Arabic, preserves legacy presentation forms, and avoids paragraph wrapping |
| Pure English or untranslated fallback | Raw/expanded logical text | Arabic shaping is unnecessary |
| Hashing, storage, or lookup keys | Logical normalization helpers only | Display-time shaping must never enter persisted data |

`QTR_ReverseIfAR` still expands project tokens, detects actual Arabic, fixes colors, and protects special codes. It is not width-aware, so it is appropriate only where wrapping is not required.

Do not call `QTR_ExpandUnitInfo` without a valid `AR_obj` and expect Arabic shaping. A few legacy call sites omit the target; under the current contract those calls receive only `WOW_ZmienKody` expansion.

## Width and First-Show Behavior

`QTR_ExpandUnitInfo` reads the target width directly at the time of the call. The core function currently does not clamp a zero width or schedule a later render.

Callers must therefore do one of the following before preparing a wrapped block:

- set an explicit positive width on the target;
- compute a positive fallback from the containing frame;
- wait until layout completes, then render;
- re-render from an owned `OnSizeChanged` or post-layout path when the width changes.

[`common/UI/Welcome.lua`](../common/UI/Welcome.lua) is the reference for computing a safe first-show wrap width from progressively broader containers. Quest UI uses its owned post-layout scheduling because Blizzard can overwrite text or dimensions after an early pass.

`AR_corr` adjusts usable width, not alignment. Negative corrections reserve padding or adjacent UI space; they must be verified against the actual target frame.

## UI Integration

Text conversion alone does not produce a correct RTL surface. The owning feature must:

1. Apply the Arabic font.
2. Use right justification only when the rendered content is Arabic.
3. Give the FontString an explicit usable width that reaches the intended right inset.
4. Make targeted anchor changes for rows whose reading order changes.
5. Restore original font, anchors, width, and justification in the LTR/off path.

Example for an owned wrapped FontString:

```lua
local isArabic = ns.RTL.IsRTL() and WOWTR_ContainsArabic(translated)

if isArabic then
  text:SetFont(WOWTR_Font2, 13)
  text:SetJustifyH("RIGHT")
  text:SetWidth(availableWidth)
  text:SetText(QTR_ExpandUnitInfo(translated, false, text, WOWTR_Font2, -5))
else
  text:SetJustifyH("LEFT")
  text:SetWidth(originalWidth)
  text:SetText(original)
end
```

The exact font size, width, and anchors belong to the feature. Capture original layout or provide a deterministic reset; do not assume a UI reload will clear stale RTL state.

### Label and Value Rows

For rows such as an XP label and value:

- anchor the Arabic label to the frame's right inset;
- give the label enough width for right justification;
- anchor the value to the left of the label;
- restore both anchors and any temporary width in LTR mode.

Moving only the value can push it off-screen when the label remains left-anchored.

### Quest Title Decorations

Do not inject decoration hyperlinks, atlas tags, or font-only glyphs into an already shaped Arabic quest title. Keep the title text clean and render the decoration through a separate overlay using the original Blizzard-capable font. Reparent and re-anchor that overlay whenever the host title changes.

## Dynamic Placeholder Substitution

There are two separate responsibilities:

1. Resolve a placeholder such as `{1}` from the original source text when the translated tooltip needs the current value.
2. Protect the resolved value while the Arabic text is reversed.

The tooltip preparation path marks a resolved value as `\003VALUE\004`. `HandleWoWSpecialCodes` stores `VALUE` in the token table and removes the markers. This preserves English names and numeric values as indivisible logical segments.

Protecting `{1}` without substituting it leaves a literal placeholder visible. Substituting `20` without protecting it allows the visual reversal to produce `02`. Both steps are required.

## Known Limitations

- This is a game-specific shaping and visual reversal pipeline, not a general Unicode BiDi engine.
- Width is a snapshot. The caller must re-render after material size changes.
- Zero-width fallback is a caller responsibility.
- `OnObjectives` remains in the API but has no current behavior.
- Short labels can be damaged by width-aware paragraph preparation; use `QTR_ReverseIfAR`.
- Only recognized WoW markup and supported SimpleHTML tags are protected. Malformed or new tag families need an explicit pattern and regression case.
- The text helper does not mirror frame geometry. Layout remains the feature owner's responsibility.

## Change Procedure

When extending this pipeline:

1. Add the smallest protection or shaping change in the existing owner.
2. Preserve both normal and reversed sentinel restoration.
3. Verify pure English, nil, empty, and restricted-value paths.
4. Test at least ten protected tokens in one line.
5. Test standard and positional format tokens, substituted values, all three digit families, icons, links, and colors.
6. Test a short label and a wrapped block at positive and first-show widths.
7. Toggle RTL -> LTR -> RTL and inspect anchors, width, font, and justification.
8. Run the [Arabic text pipeline matrix](RegressionTesting.md#arabic-text-pipeline-matrix).

Store test evidence with the pull request or issue. Do not add a parallel session journal or generated memory database.
