# Tag Vocabulary (fixed set)

Use a small vocabulary so retrieval stays reliable.
Linter validates tags against this list.

- [UI] - UI behavior, rendering, interaction
- [Layout] - layout groups, anchors, sizing, rects
- [Input] - mouse/keyboard/controller input rules
- [Data] - parsing, payloads, formats, state sync
- [Server] - server-side logic and lifecycle
- [Init] - initialization / load order / startup
- [Build] - compilation, MSBuild, project files
- [CI] - automation, pipelines
- [Release] - packaging, artifacts, uploads
- [Compat] - IL2CPP, runtime constraints, environment quirks
- [Integration] - optional plugins, reflection bridges, external systems
- [Docs] - documentation and changelog work
- [Architecture] - module boundaries, refactors, ownership
- [DX] - developer experience, tooling, maintainability
- [Reliability] - crash prevention, guardrails, self-healing
- [Process] - workflow, memory system, tooling changes

# WoWAR domain tags
- [Quests] - quest UI translation, QuestMapFrame/QuestFrame behavior
- [RTL] - directionality, bidi constraints, RTL-specific layout rules
- [Text] - shaping/reshaping, token protection, string pipelines
- [Tooltips] - tooltip hooks, translation, formatting
- [Config] - settings persistence/UI (ControlCenter, AceDB)
- [Fonts] - font ownership/application, glyph availability issues
- [Bubbles] - chat bubble translation/rendering
- [Chat] - chat input/output translation, Storyline chat, etc.
- [Debug] - debug tools, instrumentation, dumps/exports

# Common "type" tags (used by templates/examples)
- [Fix] - bug fixes, regressions, patches
- [Feature] - new behavior/capability
- [Refactor] - restructuring without behavior changes