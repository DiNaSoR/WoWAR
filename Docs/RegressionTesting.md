# WoWAR Regression Testing

> Status: Maintained manual test plan
>
> Last verified against the working tree: 2026-07-31

WoWAR does not currently have a complete automated runtime test suite. Validate changes in the supported English WoW client with Lua errors enabled, and record the tested client build, addon revision, locale, optional addons, and result in the pull request or issue.

## Baseline Smoke Test

Run this for every runtime change:

1. Start or reload the client with WoWAR enabled and confirm no Lua error appears.
2. Open the Control Center with `/wowtr`.
3. Change one setting relevant to the work, close the panel, run `/reload`, and confirm it persisted.
4. Exercise the changed UI in Arabic mode.
5. Disable the feature or select an untranslated/fallback case and confirm the original LTR state returns.
6. Repeat the visible flow once to detect duplicate hooks, duplicate output, or accumulating timers.

Run `git diff --check` before committing to catch whitespace errors in tracked text files.

## Quest and Gossip Matrix

### QuestMapFrame and Details

- Toggle quest translation on and off while QuestMapFrame is open.
- Open a quest, scroll its details, select another quest, and return.
- Confirm the post-layout translation remains after Blizzard updates the frame.
- Confirm disabling translation restores visible original text without a forced Blizzard refresh.
- Confirm an English fallback does not change `QTR_curr_trans`.

### Data-Driven Direction

Test one quest with real Arabic QuestData and one without it.

Arabic data must produce:

- Arabic body and headers;
- Arabic fonts;
- RTL justification and owned layout;
- readable rewards and title decoration.

Missing Arabic data must produce:

- original English body and headers;
- original/LTR font and justification;
- no Arabic header mixed with an English body;
- no implicit change to the user's translation toggle.

### Rewards and Title Decorations

- Test item-choice, item-receive, money, currency, and XP rows.
- Confirm right-justified reward labels reach the intended right inset without clipping.
- Confirm values appear to the left of Arabic labels where required.
- Toggle to LTR and verify label widths, anchors, and justification reset.
- Test a title with a leading glyph and one with a hyperlink containing an atlas or texture.
- Confirm the decoration overlay uses the original font, remains visible, follows the current title frame, and switches anchor side with direction.

### Gossip and Optional Quest UIs

- Test a normal gossip greeting and at least one gossip option.
- If the change touches integration code, repeat the relevant flow with Immersion, Storyline, DialogueUI, or Classic Quest Log.
- Confirm enabling or disabling an optional integration does not register duplicate hooks.

## Arabic Text Pipeline Matrix

Render each applicable case in a short label and a wrapped text block:

| Case | Pass criteria |
| --- | --- |
| Logical Arabic and legacy Presentation Forms | Logical source gains contextual joining; legacy pre-shaped text is not shaped twice |
| Arabic with an English name | Arabic is shaped; the English segment remains readable |
| `20`, `1,234.56`, `12:34`, `10/10`, and Arabic-Indic digits | Digit and separator order is unchanged |
| `{1}`, `{12}` | Placeholders restore completely; no sentinel characters appear |
| `%s`, `%.2f`, `%1$s`, `%2$d` | Format tokens survive unchanged |
| `\|T...\|t` and `\|A...\|a` | Icons render and tags remain intact |
| Bracketed and generic `\|H...\|h...\|h` links | Link payload and visible label survive |
| `\|cAARRGGBB...\|r`, `\|cnNAME:...\|r`, and curly color spans | The intended visual segment keeps its color |
| Normal and reversed supported SimpleHTML tags | Tags are valid after preparation |
| Multiple protected tokens with index 10 or greater | Multi-digit sentinel indexes restore correctly |
| Nil, empty, pure English, or secret text | No error; non-Arabic text is not unnecessarily reversed |

For `QTR_ExpandUnitInfo`, also test:

- a measured positive target width;
- first-show behavior when width is initially zero;
- both normal and `AR_RIGHT` line preparation;
- repeated RTL -> LTR -> RTL transitions.

For Control Center Release Notes, open both the newest logical-Arabic entry and
an older presentation-form entry. Confirm their titles, paragraphs, and wrapped
bullets are joined, readable, right-aligned, and measured without overlap.

See [Arabic Text Rendering](QTR_ExpandUnitInfo_RTL_Bidi_Implementation_Prompt.md) for the caller contract.

## Configuration Matrix

- New install: defaults populate and legacy values migrate only when `WOWTR_DB` did not exist.
- Existing install: an existing AceDB profile is not overwritten by legacy values.
- Profile change, copy, and reset: legacy runtime tables update immediately.
- Minimap icon: visible and hidden states both persist; verify the inverted `minimap.hide` mapping.
- Bubble chat: if both English and translated output become true, normalization disables English output.
- Quest setting: visible quest UI follows the safe post-layout apply path.
- Tooltip setting: the current tooltip closes and reopens under the new rules.
- Persisted settings not exposed in Control Center retain their values across reloads.

See [Configuration Architecture and Settings Reference](ConfigSettingsAudit.md) for the mapping.

## Feature Checks

### Tooltips and UI

- Test item, spell, and talent tooltips when their settings are enabled.
- Test a short tooltip label and a long wrapped tooltip line.
- Confirm the current tooltip closes cleanly after changing a tooltip setting.
- Confirm tooltip fonts, hooks, and layout come only from `common/Tooltips`.
- If a Blizzard UI translation changed, test both translated and missing-string paths and verify the correct `tooltips.ui*` gate.

### Bubbles and Talking Heads

- Test a translated NPC bubble, missing bubble capture, and talking-head text.
- Confirm English and translated chat output do not duplicate each other.
- Verify configured size, display time, and dungeon behavior when those paths changed.

### Movies, Tutorials, Books, and Chat

- Movies: test the affected intro, movie, cinematic, or subtitle capture gate.
- Tutorials: test a translated entry and missing-entry capture; include dynamic placeholders if present.
- Books: test title and body, page changes, supported SimpleHTML, and missing-text capture.
- Arabic chat: test mixed Arabic/Latin input, font sizing, and reload persistence.

## Hooks, Timers, and Performance

- Enter the affected UI repeatedly and confirm each event produces one result.
- Reload with optional addons enabled and disabled.
- Confirm scheduled refreshes are deduplicated and intervals cannot reach an unintended zero.
- Check that no new unbounded `OnUpdate` path was introduced.
- For debug work, turn the selected `/wowardebug preset <name>` on and off and confirm normal play remains quiet.

## Test Record Template

Use this compact record in a pull request or issue:

```text
WoW build:
WoWAR revision:
Locale:
Optional addons:
Area changed:
Scenarios run:
RTL result:
LTR/fallback result:
Persistence result:
Lua errors:
Known untested cases:
```

If a scenario cannot be tested locally, state that explicitly instead of marking the whole area as passed.
