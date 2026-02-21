# Journal Index (generated)

Generated: 2026-02-20T16:42:53+03:00

Format: YYYY-MM-DD | [Tags] | Title | Files

2025-12-29 | [Fonts] | Centralized Arabic font application. | common/UI/Fonts.lua
2025-12-29 | [RTL] | Centralized RTL detection via `ns.RTL.IsRTL()`. | -
2025-12-29 | [Compat] | Consolidated legacy `ST_*` globals. | common/Core/Compat.lua
2025-12-29 | [Quests] | Corrected RTL and translation application logic. | -
2025-12-29 | [Core] | Deduplicated hook/ticker wiring. | common/Core/HookUtils.lua, common/Core/Main.lua
2025-12-29 | [Config][Fix] | Fixed AceDB persistence issue. | -
2025-12-29 | [UI] | Introduced shared data-driven UI translation helper. | common/UI/Translate.lua
2025-12-29 | [Bubbles] | Prevented double EN + AR chat bubble lines caused by enabling both Chat EN and Chat TR. | common/Config/Core.lua, common/Config/Tabs/Bubbles.lua
2025-12-29 | [Config] | Reduced config tab boilerplate. | common/Config/Helpers.lua
2025-12-29 | [Tooltips] | Removed duplicate tooltip font and hook logic from config. | common/Tooltips/Hooks.lua, common/Tooltips/Main.lua
2025-12-29 | [Quests] | Stabilized QuestMapFrame translation behavior. | -
2025-12-30 | [Quests][RTL] | Fixed “□1□” placeholders appearing in Arabic quest titles. | \0011\002, common/Quests/Details.lua
2025-12-30 | [Quests][QuestMapFrame Rewards][RTL] | Fixed AR reward/questline labels clipping on the right edge. | common/Quests/Details.lua
2025-12-30 | [Text][RTL] | Fixed missing inline quest icons (e.g. “!” / texture tags) in Arabic view. | \00112\002, \00221\001, common/Text.lua, common/Quests/Details.lua
2025-12-30 | [Quests][RTL] | Fixed missing quest title “!” icon when switching to Arabic fonts. | common/Quests/Details.lua
2025-12-30 | [Quests][RTL] | Moved quest title icon overlay to the RTL side (right) for Arabic. | common/Quests/Details.lua
2025-12-30 | [Text][RTL] | Preserved generic `|H...|h...|h` hyperlinks through reversal. | common/Text.lua
2025-12-30 | [Quests][RTL] | Quest title overlay icon: tooltip hover + stable placement in QuestMapFrame. | common/Quests/Details.lua, OnHyperlinkEnter/Leave
2025-12-30 | [Quests][RTL] | Quest title repeatable icon extraction now supports inline atlas/texture tags inside `|H...|h...|h` display text. | common/Quests/Details.lua
2025-12-30 | [Quests][RTL] | Unified quest text column widths for consistent wrapping. | common/Quests/Details.lua
2025-12-31 | [Docs][ControlCenter] | Added an HTML mockup of the ControlCenter panel for design review outside WoW. | Docs/Mockups/ControlCenter/*, Docs/Mockups/ControlCenter/assets/ExpansionBorder_TWW.png, WoWAR/Images/ExpansionLandingPage/ExpansionBorder_TWW.tga, regression-checklist.md
2025-12-31 | [Docs][ControlCenter][Mockup][CSS] | Fixed category header layering + fonts in the HTML mock. | Docs/Mockups/ControlCenter/styles.css, Docs/Mockups/ControlCenter/assets/font1.ttf, WoWAR/Fonts/font1.ttf, regression-checklist.md
2025-12-31 | [Docs][ControlCenter][Mockup] | Made the HTML mock match the in-game ControlCenter layout 1:1 (Modules + Release Notes). | common/Config/ControlCenter/*, Docs/Mockups/ControlCenter/index.html, Docs/Mockups/ControlCenter/styles.css, Docs/Mockups/ControlCenter/app.js, Docs/Mockups/ControlCenter/assets/*, regression-checklist.md
2025-12-31 | [Docs][ControlCenter][Mockup][CSS] | Persisted browser-preview layout tweaks (tabbar + border sizing). | Docs/Mockups/ControlCenter/styles.css, regression-checklist.md
2025-12-31 | [Config][ControlCenter] | Replaced AceConfig options UI with a Plumber-style ControlCenter settings panel. | WoWAR/WoWAR.toc, common/Config/Core.lua, common/Config/Minimap.lua, common/Config/ControlCenter/*, WoWAR/Images/*, Images/ControlCenter, Images/ExpansionLandingPage, WoWAR/WoW_Localization_AR.lua, regression-checklist.md
2025-12-31 | [Docs][ControlCenter][Mockup][CSS] | Restored 1:1 layout parity with in-game `common/Config/ControlCenter/*` (tabs outside frame). | common/Config/ControlCenter/*, Docs/Mockups/ControlCenter/styles.css, regression-checklist.md
2025-12-31 | [Config][ControlCenter][Changelog] | Updated Arabic changelog entries shown in Release Notes. | WoWAR/Changelog_AR.lua, regression-checklist.md
2026-01-01 | [Config][Localization] | Added Arabic (easy) descriptions for all config options (Summary + Tip) and wired them into the UI. | WoWAR/WoW_Localization_AR.lua, common/Config/ControlCenter/Registry.lua, common/Config/Tabs/*, regression-checklist.md
2026-01-01 | [Config][ControlCenter][Fix] | Fixed “Show minimap icon” toggle stuck ON in ControlCenter. | common/Config/ControlCenter/Registry.lua, regression-checklist.md
2026-01-01 | [Config][ControlCenter][RTL] | Fixed AR option descriptions not being shaped + colored. | common/Text.lua, common/Config/ControlCenter/SettingsPanel.lua, regression-checklist.md
2026-01-01 | [Plugins][Storyline][Fix][RTL] | Hardened Storyline integration and improved Arabic UI. | common/Plugins/StorylinePlugin.lua, common/Quests/Gossip.lua
2026-01-01 | [Config][ControlCenter][RTL] | Kept the changelog version/date header LTR in Arabic. | common/Config/ControlCenter/SettingsPanel.lua, regression-checklist.md
2026-01-01 | [Config][ControlCenter][RTL] | Made Release Notes (مذكرات الإصدار) render RTL for Arabic only. | common/Config/ControlCenter/SettingsPanel.lua, regression-checklist.md
2026-01-01 | [Assets][ControlCenter] | Removed unused `WoWAR/Images/ControlCenter/*` files. | WoWAR/Images/ControlCenter/*, common/Config/ControlCenter/*, regression-checklist.md
2026-01-01 | [Assets][ControlCenter] | Restored missing ExpansionLandingPage textures required for the in-game border. | Images\\ExpansionLandingPage\\ExpansionBorder_TWW, WoWAR/Images/ExpansionLandingPage/ExpansionBorder_TWW.tga, WoWAR/Images/ExpansionLandingPage/DropdownMenu.tga, WoWAR/Images/ExpansionLandingPage/HorizontalButtonHighlight.tga, regression-checklist.md
2026-01-02 | [Quests][Fix] | Fixed quest title decoration glyph disappearing when switching between QuestMapFrame and QuestFrame. | common/Quests/Details.lua
2026-01-03 | [Text][RTL][Fix] | Added Blizzard dynamic placeholder `{1}`, `{2}` protection for defensive RTL safety. | common/Text.lua
2026-01-03 | [Text][RTL][Fix] | Added printf-style format token protection to prevent RTL reversal corruption. | common/Text.lua
2026-01-03 | [Tooltips][Fix] | Fixed `{3}` placeholder showing comma instead of number. | common/Tooltips/Utils.lua
2026-01-03 | [Tooltips][Fix] | Fixed RTL justification applying to English tooltips without translation. | common/Tooltips/GameTooltip.lua, common/Tooltips/Hooks.lua
2026-01-03 | [Text][RTL][Fix] | Fixed RTL reversal of substituted numeric values ("20" → "02" bug). | \003...\004, \001INDEX\002, common/Tooltips/Utils.lua, common/Text.lua
2026-01-03 | [Text][RTL][Fix] | Implemented dynamic value substitution for `{1}`, `{2}`, `{3}` tooltip placeholders. | common/Tooltips/Utils.lua
2026-01-03 | [Tooltips][RTL] | Right-justified tooltip lines in Arabic to feel RTL. | common/Tooltips/Hooks.lua, common/Tooltips/GameTooltip.lua, common/Tooltips/Utils.lua, regression-checklist.md, common/Tooltips/*
2026-01-06 | [Text][RTL][Fix] | Corrected Persian/Urdu letter presentation-form mappings (پ/چ/ژ/گ/ک/ڌ/ی). | WoWAR/WoW_Arabic_Reshaper.lua, Tools/index.html, regression-checklist.md
2026-01-06 | [Text][RTL][Fix] | Fixed `AS_UTF8charbytes` returning nil for NUL bytes (0x00), causing arithmetic crashes. | WoWAR/WoW_Arabic_Reshaper.lua, regression-checklist.md
2026-01-06 | [Config][ControlCenter][Fix] | Fixed Release Notes dates showing “today” for all versions. | WoWAR/Changelog_AR.lua, common/Config/ControlCenter/Registry.lua, common/Config/ControlCenter/SettingsPanel.lua, regression-checklist.md
2026-01-09 | [Packaging][CI] | Fixed GitHub Actions release workflow to package `common/` as a folder. | common/, common/*, .github/workflows/release.yml
2026-01-10 | [Compat][Namespace] | Standardized on `WOWTR_*` as the primary namespace and kept `WoWTR_*` only as legacy aliases. | common/Locale/AR.lua, common/*
2026-01-11 | [Debug][DevX] | Added “Dump Visible UI” (dump everything currently visible on screen) + updated messaging to point to `/wowardebug`. | /wowardebug, common/Core/Debug.lua, common/UI/DebugToolsUI.lua, regression-checklist.md
2026-01-11 | [Debug][Dump][DevX] | Added “UI Art / Structure” dump (textures + layout manifest) to help recreate Blizzard-style UIs. | /fstack, /wowardebug, .cursor/ui-art.ndjson, .cursor/ui-textures.tsv, common/Core/Debug.lua, common/UI/DebugToolsUI.lua, Tools/ExportAgentDebugLog.ps1, regression-checklist.md
2026-01-11 | [Tools] | Added “Unshape” mode to convert presentation-form Arabic back to base (unshaped) text. | Tools/index.html
2026-01-11 | [UI][Welcome] | Added a first-run Welcome modal that matches the ControlCenter settings style. | common/UI/Welcome.lua, common/Config/Main.lua, regression-checklist.md
2026-01-11 | [Docs][Tools] | Added a WoWAR.lua SavedVariables explainer page (EN + Arabic notes). | Tools/wowar.html, Tools/index.html, regression-checklist.md
2026-01-11 | [Debug][Instrumentation] | Added agent NDJSON logging + Professions probes for runtime evidence. | common/Core/Debug.lua, common/UI/Professions.lua, Tools/ExportAgentDebugLog.ps1, .cursor/debug.log, regression-checklist.md
2026-01-11 | [Debug][Tools] | Added clickable Debug Tools UI (`/wowardebug`) with smart Dump Visible UI. | /wowardebug, common/UI/DebugToolsUI.lua, common/Core/Debug.lua, common/Core/Main.lua, regression-checklist.md
2026-01-11 | [Debug][DevX] | Added floating “Debug Tools” UI with clickable dump/clear actions; removed editor-only region markers. | /fstack, common/UI/DebugToolsUI.lua, common/Core/Main.lua, /wowardebug, common/Core/Debug.lua, common/UI/Professions.lua, regression-checklist.md
2026-01-11 | [Debug][DevX] | Added in-game command to clear agent SavedVariables logs to prevent dump buildup. | common/Core/Debug.lua, common/Core/Main.lua, /wowtrclearlogs, regression-checklist.md, /wowtrclearlogs all
2026-01-11 | [Debug][Tools][Professions] | Added Professions UI string dump command for bulk extraction. | /fstack, common/Core/Debug.lua, common/Core/Main.lua, /wowtrdumpprof, /dumpprof, Tools/ExportAgentDebugLog.ps1, regression-checklist.md
2026-01-11 | [Tools][UX] | Added tooltips with before/after examples for Options toggles. | Tools/index.html
2026-01-11 | [Text][RTL][AR] | Auto-fix curly color span direction so `{c...}TEXT{r}` colors the intended segment. | {c...}/{r}, common/Text.lua, common/Config/Helpers.lua
2026-01-11 | [UI][Perf][Professions][Fix] | Clamp `StartTicker(..., 0)` intervals to prevent per-frame churn. | common/Core/Main.lua, regression-checklist.md
2026-01-11 | [Tools][UX] | Clarified tooltips with explicit Checked vs Unchecked outcomes. | Tools/index.html
2026-01-11 | [DevX][Plugins] | Cleaned LuaLS “undefined global” noise in DialogueUI integration. | common/Plugins/DUIPlugin.lua, .vscode/settings.json, regression-checklist.md
2026-01-11 | [DevX][Quests] | Cleaned LuaLS diagnostics in quest details handling. | Translations/QuestData_AR.lua, common/Quests/Details.lua, regression-checklist.md
2026-01-11 | [Tools][RTL] | Ensure `/command` tokens aren’t treated as “protected” during reshaping. | /command, /..., /wowardebug, ^/[A-Za-z][A-Za-z0-9_]*$, Tools/index.html
2026-01-11 | [Debug][Dump] | Filtered numeric ratio noise like `0 / 1000`. | 0 / 1000, common/Core/Debug.lua, ^%d+ / %d+$, regression-checklist.md
2026-01-11 | [Tools][RTL] | Fix slash commands like `/wowardebug` to render correctly in WoW RTL. | /wowardebug, /, wowardebug/, gubedrawow/, Tools/index.html
2026-01-11 | [Tools][RTL] | Fixed "Keep Latin words LTR" to not re-reverse already-reversed Latin in shaped entries. | Tools/index.html, regression-checklist.md
2026-01-11 | [Tools][RTL][UI] | Fixed Arabic “Original” preview rendering in the reshaper tool. | Tools/index.html, regression-checklist.md
2026-01-11 | [Tools][RTL][Fix] | Fixed Latin runs (e.g. `WoWAR.lua`) not being pre-reversed for Mixed entries. | Tools/index.html, common/UI/Talents.lua, common/Bubbles/State.lua, common/Core/Main.lua, common/Core/Debug.lua, common/UI/DebugUI.lua, common/Tooltips/State.lua, regression-checklist.md
2026-01-11 | [Tools][UX] | Fixed option tooltips positioning so they stay within the visible page. | Tools/index.html
2026-01-11 | [Debug][Instrumentation] | Improve agent log run separation + add Professions call-rate metrics. | common/Core/Debug.lua, common/UI/Professions.lua, regression-checklist.md
2026-01-11 | [Debug][DumpFrameArt] | Improved anchor path resolution in UI art dumps. | common/Core/Debug.lua
2026-01-11 | [UI][Welcome][AR] | Localized Welcome UI strings (Arabic-only when RTL). | common/UI/Welcome.lua, common/Locale/AR.lua
2026-01-11 | [Refactor][Layout] | Moved legacy root `WoW_*.lua` files into `common/` (Option B layout). | common/, common/Locale/AR.lua, common/Locale/changelog.lua, common/Text/Reshaper.lua, common/Chat/Chat.lua, regression-checklist.md
2026-01-11 | [Tools][Fix][Unshape] | Prevented ALEF (FE8E) mapping collisions that produced “آ” in common words. | Tools/index.html
2026-01-11 | [DevX] | Reduced LuaLS noise for UI globals in `common/UI/Frames.lua`. | common/UI/Frames.lua, .vscode/settings.json, regression-checklist.md
2026-01-11 | [DevX][Lua Diagnostics] | Remove implicit globals for quest de-dupe markers. | _lastProcessedQuestID/_lastProcessedQuestTime, common/Quests/Main.lua, common/Quests/Details.lua, common/Core/Main.lua
2026-01-11 | [Debug][DevX] | Removed automatic ticker-driven agent instrumentation from Professions + ticker clamp. | common/UI/Professions.lua, common/Core/Main.lua, regression-checklist.md
2026-01-11 | [Debug][Cleanup] | Removed manual frame targeting from Debug Tools UI. | common/UI/DebugToolsUI.lua, common/Core/Debug.lua, regression-checklist.md
2026-01-11 | [Cleanup] | Removed orphaned `QTR_ObjectiveTracker_Check` hook call. | common/Core/Main.lua, regression-checklist.md
2026-01-11 | [UI][Changelog] | Removed standalone Changelog popup UI; keep only embedded ControlCenter “Release Notes”. | common/Core/Main.lua, common/UI/Changelog.lua, common/Config/ControlCenter/SettingsPanel.lua, common/Locale/changelog.lua, regression-checklist.md
2026-01-11 | [Cleanup][Tracker] | Removed unused “online translation” table `QTR_Tlumacz_Online` and its helper `pairsByKeys()`. | common/Quests/Tracker.lua, Translations/TlumaczOnline_AR.lua, regression-checklist.md
2026-01-11 | [Cleanup][Config] | Removed unused legacy AceConfig “Tabs” implementation files. | common/Config/Tabs/*.lua, common/Config/Tabs/*, regression-checklist.md
2026-01-11 | [UI][Welcome] | Re-skinned Welcome modal to match Blizzard SplashFrame art/layout. | common/UI/Welcome.lua
2026-01-11 | [UI][Welcome][RTL] | Switched Welcome modal border + Arabic rendering for correct bidi behavior. | common/UI/Welcome.lua
2026-01-11 | [UI][Welcome] | Switched Welcome text scrolling to use the same ScrollView/ScrollBar as ControlCenter. | common/UI/Welcome.lua
2026-01-11 | [Debug][Dump] | Treat Arabic UI text as “already localized” in missing-only dumps. | common/Core/Debug.lua, regression-checklist.md
2026-01-11 | [Debug][UI] | Tweaked `/wowardebug` panel spacing + hint text after adding “Include art”. | /wowardebug, common/UI/DebugToolsUI.lua
2026-01-24 | [DX][Debug] | Add /wowardebugsettings shortcut for debug toggles | common/Core/Main.lua
2026-01-24 | [Fix][Quests][RTL][UI] | Add spacing between quest title icon glyph and text | common/Quests/Details.lua
2026-01-24 | [Debug][Quests][UI] | Add width snapshot logs for quest translation passes | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][RTL] | Avoid overriding decorated title on QuestMapFrame toggle | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][Reliability] | Avoid QuestMapFrame forced reprocess spam; schedule single __post__ reapply | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][RTL] | Cache QuestMapFrame title glyph for toggle stability | common/Quests/Details.lua
2026-01-24 | [Quests][RTL][Layout][Fix] | Consolidated quest header width adjustment | common/Quests/Details.lua
2026-01-24 | [Quests][Fix][RTL] | Fix EN toggle showing blank text - prevent capturing Arabic as English | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][RTL] | Force quick __post__ after toggle to keep glyph inside QuestMapFrame | common/Quests/Details.lua
2026-01-24 | [Fix][Tooltips][Text][Reliability] | Guard Arabic detection against secret values | common/Text.lua
2026-01-24 | [DX][Debug][UI] | Make /wowardebug a tabbed settings/tools UI | common/UI/DebugUI.lua, common/Core/Main.lua
2026-01-24 | [DX][Debug] | Make /wowardebug open debug settings UI | common/Core/Main.lua, common/UI/DebugUI.lua
2026-01-24 | [Fix][Quests][RTL][Reliability] | Make QuestMapFrame __post__ translation reapply run once | common/Quests/Details.lua
2026-01-24 | [Feature][Debug][UI] | Merged DebugUI into DebugToolsUI with tabbed interface | common/UI/DebugToolsUI.lua
2026-01-24 | [Fix][Quests][RTL][UI] | Pad only ! title glyph overlay | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][RTL][UI] | Remove RTL title padding from quest headers | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][RTL][Debug] | Reserve quest title glyph space + add /wowardebug debug-print toggle | common/Quests/Details.lua, common/UI/DebugToolsUI.lua
2026-01-24 | [Fix][Quests][RTL][UI] | Reserve space for RTL quest title glyph to prevent overlap | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][RTL] | Schedule one __post__ after toggle when title glyph present (QuestMapFrame) | common/Quests/Details.lua
2026-01-24 | [UI][Quests][RTL] | Set quest title glyph offset X=20 and reserve width accordingly | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][RTL] | Stabilize QuestMapFrame title width when glyph offset changes | common/Quests/Details.lua
2026-01-24 | [Fix][Quests][Reliability] | Suppress rapid duplicate QuestMapFrame __force__ QuestPrepare calls | common/Quests/Details.lua
2026-01-24 | [Debug][UI][DX] | Tabbed /wowardebug UI with Settings + Tools tabs | common/UI/DebugToolsUI.lua
2026-01-25 | [UI][RTL][Text][Fix] | Centered welcome title shaping and narrowed body width | common/UI/Welcome.lua
2026-01-25 | [UI][RTL][Fonts][Fix] | Tuned welcome bidi width and title font | common/UI/Welcome.lua
2026-02-13 | [Tools][Reshaper][Update] | Added changelog.lua workflow support and unshaped changelog copy | Tools/index.html, Tools/changelog_Unshaped.lua
2026-02-13 | [UI][ControlCenter][Preview][Assets] | Added per-setting preview fallback chain and generated wowar-named placeholders | common/Config/ControlCenter/SettingsPanel.lua, Images/ControlCenter/preview_wowar_*.png, Images/ControlCenter/placeholder_temp.png
2026-02-13 | [UI][ControlCenter][Search][RTL] | Added shaped Arabic preview rendering in search EditBox | common/Config/ControlCenter/SettingsPanel.lua
2026-02-13 | [Process][DX][Reliability][Fix] | Added tiny vector smoke test script for Mnemo vector layer | scripts/memory/vector-smoke.ps1, scripts/memory/mnemo_vector.py
2026-02-13 | [UI][ControlCenter][Layout][Fix] | Corrected tab button anchoring so attach offset works | common/Config/ControlCenter/SettingsPanel.lua
2026-02-13 | [Process][DX] | Enforced mandatory vector-first retrieval policy in Cursor rules | .cursor/rules/01-vector-search.mdc, .cursor/memory/active-context.md
2026-02-13 | [Process][DX][Reliability] | Enforced post-vector grounding to prevent digest-only answers | .cursor/rules/01-vector-search.mdc, .cursor/memory/active-context.md
2026-02-13 | [Process][DX][Reliability][Fix] | Fixed Mnemo vector layer runtime compatibility and .env key loading | scripts/memory/mnemo_vector.py, .cursor/mcp.json
2026-02-13 | [UI][ControlCenter][Search][RTL] | Improved Arabic search matching across localization text forms | common/Config/ControlCenter/Registry.lua
2026-02-13 | [UI][ControlCenter][Changelog][Typography] | Increased changelog title size and applied Font1 | common/Config/ControlCenter/SettingsPanel.lua
2026-02-13 | [Process] | Initialized memory system (Memory v3.2.2) | .cursor/memory/*, .cursor/rules/00-memory-system.mdc, scripts/memory/*
2026-02-13 | [UI][ControlCenter][Changelog][RTL] | Mirrored date divider texture for Arabic layout | common/Config/ControlCenter/SettingsPanel.lua
2026-02-13 | [UI][ControlCenter][Changelog][Fix] | Prevented enlarged title font from leaking into body bullet lines | common/Config/ControlCenter/SettingsPanel.lua
2026-02-13 | [UI][Welcome][RTL][Tweak] | Reduced RTL orphan word/swap cases in welcome body text | common/UI/Welcome.lua
2026-02-13 | [UI][ControlCenter][Layout][Tweak] | Reduced visual gap between panel border and bottom tab strip | common/Config/ControlCenter/SettingsPanel.lua
2026-02-13 | [Process][DX] | Removed temporary vector smoke script and validated normal vector tool flow | scripts/memory/mnemo_vector.py, .cursor/memory/active-context.md
2026-02-13 | [Config][DX][Fix] | Resolved LuaLS undefined globals in Config Minimap/State with runtime-safe global lookups | common/Config/Minimap.lua, common/Config/State.lua
2026-02-13 | [Locale][Changelog][Style] | Reworded latest changelog entry to non-technical player-facing language | common/Locale/changelog.lua, .cursor/memory/memo.md
2026-02-13 | [Locale][Changelog][Content] | Rewrote pre-2026-02-13 entries in unshaped changelog copy | Tools/changelog_Unshaped.lua
2026-02-13 | [UI][Welcome][RTL][Fix] | Stabilized `welcomeText` wrapping by setting width before Arabic shaping | common/UI/Welcome.lua
2026-02-13 | [UI][ControlCenter][RTL][Text] | Switched version label ordering to version-first in Arabic | common/Config/ControlCenter/SettingsPanel.lua
2026-02-13 | [UI][ControlCenter][Changelog][UX] | Tuned changelog colors to accent-only readability mode | common/Config/ControlCenter/SettingsPanel.lua, .cursor/memory/memo.md
2026-02-13 | [Locale][Changelog][Update] | Updated latest release notes to match delivered Welcome RTL fixes | common/Locale/changelog.lua
2026-02-13 | [UI][ControlCenter][Changelog][Fix] | Wired locale changelog `color` field to Release Notes rendering | common/Locale/changelog.lua, common/Config/ControlCenter/Registry.lua, common/Config/ControlCenter/SettingsPanel.lua
2026-02-18 | [Quests][Rewards][RTL][Fix] | Mirrored receive-label/money anchors so Arabic reward header aligns right | common/Quests/Details.lua
2026-02-18 | [Quests][Rewards][Reliability][Fix] | Prevented intermittent English `ItemReceiveText` on translated quest pages | common/Quests/Details.lua
2026-02-18 | [Quests][Rewards][RTL][Fix] | Removed spacer-based reward-label hack that caused money/reward overlap | common/Quests/Details.lua
2026-02-18 | [Quests][Rewards][RTL][Fix] | Reworked reward label alignment without moving Blizzard reward-row origin | common/Quests/Details.lua
2026-02-18 | [Quests][Gossip][Fix] | Use questID-based QuestData title fallback for GossipFrame options | common/Quests/Gossip.lua
2026-02-19 | [Bubbles][Text][Fix] | Prevented `BB_PS` duplication for NPC lines containing player-realm names | common/Text.lua, common/Bubbles/Main.lua
2026-02-19 | [Bubbles][Architecture][Tweak] | Removed NPC-name hardcoding from honor-speech fallback path | common/Bubbles/Main.lua
2026-02-20 | [Packaging][CI][Fix] | Aligned GitHub release workflow with root `.toc` addon layout | WoWAR/, WoWPL/, .github/workflows/release.yml
2026-02-20 | [Packaging][CI][Enhancement] | Hardened release workflow logic and added manual test mode | gh release create/edit/upload --clobber, .github/workflows/release.yml
2026-02-20 | [Debug][DX][Refactor] | Smart Debug Unification - Regression Checklist | -
2026-02-20 | [Debug][Refactor][Architecture][DX] | Unified Smart Debug System — full implementation | /wowtrdump, /wowardebug on, /wowardebug off, /wowardebug toggle, /wowardebug status, /wowardebug preset quest-investigation, /wowardebug preset off, /wowardebug help, /wowardebug