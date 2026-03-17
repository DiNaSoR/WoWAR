# Contributing to WoWAR

WoWAR is a live World of Warcraft addon, so most changes are validated in the game client rather than through a separate build system. This guide is meant to lower the barrier for contributors who want to help with Arabic localization, RTL rendering, UI fixes, or compatibility work.

## Good First Contribution Areas

- Add or correct Arabic translation entries in [`Translations/`](Translations)
- Fix RTL, reshaping, punctuation, or mixed Arabic/English layout bugs
- Patch Blizzard UI regressions caused by new WoW releases
- Improve optional addon integrations in [`common/Plugins/`](common/Plugins)
- Improve contributor docs and capture/export tooling

## Development Setup

1. Clone the repository.
2. Make the repo available to WoW as `Interface\AddOns\WoWAR`.
3. Run the game on an English client (`enUS` or `enGB`), because the addon bootstraps only on those locales.
4. Use `/reload` after edits.
5. Open the addon settings with `/wowtr`.

If you prefer not to duplicate files, create a directory junction or symlink from the WoW AddOns folder to this repository.

## Repo Map

- [`WoWAR.toc`](WoWAR.toc): manifest and load order
- [`common/Core/`](common/Core): bootstrap, event routing, debug
- [`common/Config/`](common/Config): settings defaults, DB sync, Control Center UI
- [`common/Quests/`](common/Quests): quests, gossip, tracker, quest frame behavior
- [`common/Tooltips/`](common/Tooltips): tooltip translation/capture
- [`common/Bubbles/`](common/Bubbles): NPC bubble translation
- [`common/Movies/`](common/Movies): subtitles and cinematics
- [`common/Books/`](common/Books): readable books
- [`common/UI/`](common/UI): Blizzard UI translation hooks
- [`Translations/`](Translations): shipped Arabic data

## Project Conventions

- Prefer targeted changes inside the feature module you are touching instead of adding cross-cutting globals.
- Keep backward compatibility in mind. Many runtime modules still read legacy globals like `QTR_PS`, `TT_PS`, `BB_PM`, and `MF_PM`.
- If you change config behavior, verify the AceDB profile values still sync through [`common/Config/Core.lua`](common/Config/Core.lua) and [`common/Core/LegacyBridge.lua`](common/Core/LegacyBridge.lua).
- Avoid editing vendored libraries under [`common/Libs/`](common/Libs) unless the change is necessary and isolated.
- Keep Arabic text rendering fixes aware of RTL helpers in [`common/RTL.lua`](common/RTL.lua) and reshaping helpers in [`common/Text/Reshaper.lua`](common/Text/Reshaper.lua).

## Testing Checklist

There is no automated test suite yet, so use a manual checklist appropriate to your change:

- Load the addon without Lua errors.
- Open `/wowtr` and confirm the settings UI still opens.
- If you touched quests or gossip, test normal quest frames plus at least one alternate flow if relevant:
  `Immersion`, `Storyline`, `DialogueUI`, `Classic Quest Log`.
- If you touched tooltips, test item, spell, and talent tooltips.
- If you touched bubbles, test NPC chat bubbles and talking head text.
- If you touched movies/books/tutorials, test capture and translation fallback behavior.
- If you touched fonts or RTL layout, verify Arabic text, mixed Arabic/Latin strings, icons, and numbers still render correctly.
- If you changed config defaults, confirm both new profiles and existing SavedVariables migrate cleanly after `/reload`.

## Collecting Missing Text

One of the easiest ways to help is to collect untranslated content while playing.

The addon can save missing content into SavedVariables such as:

- `QTR_SAVED` and `QTR_GOSSIP` for quests and gossip
- `BB_PS` for NPC bubbles
- `MF_PS` for movies/cinematics
- `TT_TUTORIALS` and `ST_PH` for tutorials and UI strings
- `BT_SAVED` for books

If you have local helper docs or export scripts in ignored folders such as `Tools/`, do not assume other contributors have them. Either document the workflow in the repository or include the needed details in your pull request.

## Reporting Bugs Well

If you open an issue or send a bug report, include:

- WoW client version and interface build
- WoWAR version
- Locale (`enUS` or `enGB`)
- Whether Immersion, Storyline, DialogueUI, ElvUI, or other UI addons were enabled
- Exact screen or game flow where the problem happened
- Screenshot if the issue is visual
- SavedVariables excerpt or exported debug log when relevant

## Pull Requests

Until a formal PR template exists, small focused pull requests are easiest to review. Please keep each PR scoped to one of these:

- One feature area
- One translation dataset
- One rendering bug
- One tooling/documentation improvement

If your change affects visible Arabic output, add before/after screenshots when possible.
