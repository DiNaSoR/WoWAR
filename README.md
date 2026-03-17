# WoWAR

WoWAR is an open-source World of Warcraft addon that localizes large parts of the game into Arabic. It focuses on readable right-to-left rendering, Arabic-capable fonts, and in-game capture of untranslated text so the translation database can keep growing over time.

The addon currently targets English game clients (`enUS` / `enGB`) and supports modern retail interface builds declared in [`WoWAR.toc`](WoWAR.toc): `110205`, `110207`, `120000`, and `120001`.

## What It Covers

- Quest text, quest details, gossip, and objective tracker text
- Tooltip translation for items, spells, talents, and selected UI surfaces
- NPC chat bubbles and talking-head text
- Movies, cinematics, and subtitle capture
- In-game books and tutorials
- Arabic chat helpers and font overrides
- Optional integrations for addons and alternate quest UIs such as Immersion, Storyline, DialogueUI, and Classic Quest Log
- A Control Center settings UI plus debug tooling for capture and troubleshooting

## How It Works

Runtime code lives under [`common/`](common). Translation databases live under [`Translations/`](Translations) as Lua tables that are loaded by the addon manifest. The addon also saves untranslated text into SavedVariables like `QTR_SAVED`, `QTR_GOSSIP`, `BB_PS`, `MF_PS`, `TT_TUTORIALS`, `BT_SAVED`, and `ST_PH` so contributors can collect missing strings while playing.

There are two main configuration layers:

- Modern profile-backed settings in `WOWTR_DB` via AceDB
- Legacy global tables such as `QTR_PS`, `TT_PS`, `BB_PM`, and `MF_PM` that runtime modules still read

The sync bridge between those systems lives in [`common/Config/Core.lua`](common/Config/Core.lua) and [`common/Core/LegacyBridge.lua`](common/Core/LegacyBridge.lua).

## Repository Layout

- [`WoWAR.toc`](WoWAR.toc): addon manifest, load order, metadata, SavedVariables
- [`common/Core/`](common/Core): bootstrap, events, compatibility, debug system
- [`common/Config/`](common/Config): AceDB defaults, settings sync, Control Center UI
- [`common/Quests/`](common/Quests): quest, gossip, tracker, and quest UI behavior
- [`common/Tooltips/`](common/Tooltips): tooltip translation and capture
- [`common/Bubbles/`](common/Bubbles): NPC bubble/chat translation flow
- [`common/Movies/`](common/Movies): movie and cinematic subtitle handling
- [`common/Books/`](common/Books): readable books translation
- [`common/UI/`](common/UI): UI-specific translation patches and welcome/config screens
- [`common/Text/`](common/Text) and [`common/RTL.lua`](common/RTL.lua): Arabic shaping and RTL helpers
- [`Translations/`](Translations): shipped Arabic translation data
- [`Images/`](Images) and [`Fonts/`](Fonts): bundled assets
- [`.github/workflows/release.yml`](.github/workflows/release.yml): packaging and GitHub release automation

## Installation

1. Download the latest release from [GitHub Releases](https://github.com/DiNaSoR/WoWAR/releases) or [CurseForge](https://www.curseforge.com/wow/addons/wowar-arabic).
2. Extract the `WoWAR` folder into your WoW addons directory:
   `World of Warcraft\_retail_\Interface\AddOns\WoWAR`
3. Start the game on an English client (`enUS` or `enGB`).
4. Open settings with `/wowtr` or the minimap icon.

## Local Development

The repo has no standalone build step for normal development. WoW loads the Lua/XML/asset files directly from the addon folder.

Typical workflow:

1. Clone this repository.
2. Place it in your WoW addons directory, or create a symlink/junction named `WoWAR` that points at the repo.
3. Launch the game, test changes, and use `/reload` between iterations.
4. Open the settings panel with `/wowtr`.
5. Use `/wowardebug` for debug presets and capture when investigating rendering issues.

Release packaging is automated by [`.github/workflows/release.yml`](.github/workflows/release.yml). It validates version tags, packages the addon, and publishes GitHub releases from `v*` tags.

## Contributing

Start with [`CONTRIBUTING.md`](CONTRIBUTING.md). The highest-value contribution areas today are:

- Filling missing Arabic translations in `Translations/*.lua`
- Fixing RTL layout, shaping, and mixed Arabic/Latin rendering edge cases
- Validating quest/gossip behavior against Blizzard UI changes
- Improving compatibility with Immersion, Storyline, DialogueUI, ElvUI, and other UI addons
- Improving contributor tooling and export/documentation workflows

## Current Open-Source Gaps

This README and the contributing guide cover the basics, but there are still a few project-level gaps that make outside contributions harder than they should be:

- No root `LICENSE` file. Contributors need an explicit project license before reuse and redistribution are fully clear.
- No issue templates or pull request template yet.
- No `CODE_OF_CONDUCT.md` or `SECURITY.md` yet.
- No automated regression suite or CI checks for Lua formatting, static analysis, or gameplay smoke tests.
- Some helper material currently lives only in ignored local folders like `Docs/` and `Tools/`, so outside contributors cannot rely on it from a fresh clone.
- Most validation is still manual inside the WoW client.

Those are good next additions if you want the project to feel fully contributor-ready.

## Useful References

- Project site: [wowar.co](https://www.wowar.co)
- GitHub: [DiNaSoR/WoWAR](https://github.com/DiNaSoR/WoWAR)
- CurseForge: [WoWAR Arabic](https://www.curseforge.com/wow/addons/wowar-arabic)
- Discord: <https://discord.gg/uW5NJ6y>
