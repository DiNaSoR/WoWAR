# WoWAR Project Documentation

> Status: Maintained
>
> Scope: Runtime architecture, contributor rules, configuration, Arabic rendering, and manual validation
>
> Last verified against the working tree: 2026-07-31

This directory contains the maintained technical documentation for WoWAR. The code and `WoWAR.toc` remain authoritative; update the relevant document in the same change whenever a public contract, ownership boundary, setting, or required validation step changes.

## Start Here

| Document | Use it for |
| --- | --- |
| [Architecture](Architecture.md) | Runtime structure, load order, subsystem ownership, state, and translation flow |
| [Engineering Guidelines](EngineeringGuidelines.md) | Project invariants and implementation rules that should survive individual tasks |
| [Configuration Architecture and Settings Reference](ConfigSettingsAudit.md) | AceDB lifecycle, legacy bridge, Control Center mappings, and change procedure |
| [Arabic Text Rendering](QTR_ExpandUnitInfo_RTL_Bidi_Implementation_Prompt.md) | `QTR_ExpandUnitInfo`, BiDi token safety, width contracts, and call-site guidance |
| [Regression Testing](RegressionTesting.md) | Manual smoke tests and feature-specific acceptance criteria |
| [Control Center mockup](Mockups/ControlCenter/README.md) | Visual reference for the settings panel |

The long filenames of the configuration and Arabic-rendering documents are retained to avoid breaking existing links. Their contents describe the current project; they are no longer an audit report or a prompt for another tool.

## Documentation Rules

- Describe the current system, not a task transcript or intended future state.
- Link to the owning code instead of duplicating implementation details that are likely to drift.
- Record durable contracts, invariants, decisions, and test criteria. Keep temporary investigation notes out of maintained documentation.
- Use repository-relative Markdown links so the docs work on GitHub and in local editors.
- Mark limitations explicitly. Do not describe a caller-side workaround as a guarantee of the core API.
- Update mapping tables and examples when the corresponding code changes.
- Keep release history in Git, pull requests, and `common/Locale/changelog.lua`; do not maintain a parallel engineering journal.

## Reference Material

Large directories such as `Docs/DialogueUI`, `Docs/Immersion`, `Docs/Plumber`, `Docs/Storyline`, and `Docs/WoWUkrainDoc` are local upstream references and are intentionally ignored by Git. They are useful for comparison, but they are not WoWAR runtime dependencies or project authority.

## Migration from Cursor Memory

The former `.cursor/memory` archive mixed durable rules with session scratchpads, journals, generated indexes, and local vector databases. Its useful content has been curated as follows:

| Former material | Maintained destination |
| --- | --- |
| Project memo and ownership rules | [Architecture](Architecture.md) and [Engineering Guidelines](EngineeringGuidelines.md) |
| Reusable implementation lessons | [Engineering Guidelines](EngineeringGuidelines.md) |
| Regression checklist | [Regression Testing](RegressionTesting.md) |
| Configuration notes | [Configuration Architecture and Settings Reference](ConfigSettingsAudit.md) |
| RTL and special-code notes | [Arabic Text Rendering](QTR_ExpandUnitInfo_RTL_Bidi_Implementation_Prompt.md) |

Session context, journals, digests, generated indexes, and vector databases were deliberately not converted. Git history is the durable record of what changed; these documents explain how the project works now.
