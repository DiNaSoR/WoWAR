-- Debug.lua
-- Facade module that preserves WOWTR.Debug public API while delegating
-- schema/state/print/dump/agent-log responsibilities to focused modules.

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

Core.Debug = Core.Debug or {}
local Debug = Core.Debug

local Schema = Core.DebugSchema or {}
local State = Core.DebugState or {}
local Print = Core.DebugPrint or {}
local Agent = Core.DebugAgentLog or {}
local Dump = Core.DebugDump or {}

-- Expose canonical schema so UI/router/modules can use one source of truth.
Debug.Schema = Schema
Debug.Categories = Schema.Categories or {}
Debug.CategoryOrder = Schema.CategoryOrder or {}
Debug.CategoryMeta = Schema.CategoryMeta or {}
Debug.Verbosity = Schema.Verbosity or {}
Debug.VerbosityMeta = Schema.VerbosityMeta or {}
Debug.Presets = Schema.Presets or {}
Debug.PresetOrder = Schema.PresetOrder or {}

-- State API
Debug.Initialize = function(...) if State.Initialize then return State.Initialize(...) end end
Debug.IsEnabled = function(...) if State.IsEnabled then return State.IsEnabled(...) end return false end
Debug.SetEnabled = function(...) if State.SetEnabled then return State.SetEnabled(...) end end
Debug.ShouldPrint = function(...) if State.ShouldPrint then return State.ShouldPrint(...) end return false end
Debug.GetCategoryLevel = function(...) if State.GetCategoryLevel then return State.GetCategoryLevel(...) end return 0 end
Debug.SetCategoryLevel = function(...) if State.SetCategoryLevel then return State.SetCategoryLevel(...) end return false end
Debug.SetPreset = function(...) if State.SetPreset then return State.SetPreset(...) end return false end
Debug.GetPresetNames = function(...)
  if State.GetPresetNames then return State.GetPresetNames(...) end
  if Schema.GetPresetNames then return Schema.GetPresetNames(...) end
  return {}
end
Debug.GetStatusLine = function(...) if State.GetStatusLine then return State.GetStatusLine(...) end return "|cFF00FF00[WoWAR]|r Debug: |cFF666666OFF|r" end
Debug.Status = function(...) if State.Status then return State.Status(...) end end

-- Print API
Debug.Print = function(...) if Print.Print then return Print.Print(...) end end
Debug.Error = function(...) if Print.Error then return Print.Error(...) end end
Debug.Minimal = function(...) if Print.Minimal then return Print.Minimal(...) end end
Debug.Normal = function(...) if Print.Normal then return Print.Normal(...) end end
Debug.Verbose = function(...) if Print.Verbose then return Print.Verbose(...) end end
Debug.Enter = function(...) if Print.Enter then return Print.Enter(...) end end
Debug.Exit = function(...) if Print.Exit then return Print.Exit(...) end end
Debug.GroupStart = function(...) if Print.GroupStart then return Print.GroupStart(...) end return false end
Debug.GroupEnd = function(...) if Print.GroupEnd then return Print.GroupEnd(...) end end

-- Agent log API
Debug.AgentLog = function(...) if Agent.AgentLog then return Agent.AgentLog(...) end end
Debug.AgentDumpLog = function(...) if Agent.AgentDumpLog then return Agent.AgentDumpLog(...) end end
Debug.ClearAgentLogs = function(...) if Agent.ClearAgentLogs then return Agent.ClearAgentLogs(...) end end

-- Dump API
Debug.DumpVisibleUI = function(...) if Dump.DumpVisibleUI then return Dump.DumpVisibleUI(...) end return 0 end
Debug.DumpFrameStrings = function(...) if Dump.DumpFrameStrings then return Dump.DumpFrameStrings(...) end return 0 end
Debug.DumpFrameArt = function(...) if Dump.DumpFrameArt then return Dump.DumpFrameArt(...) end return 0 end
Debug.ResetDumpCache = function(...) if Dump.ResetDumpCache then return Dump.ResetDumpCache(...) end end

-- Global wrapper for backward compatibility.
WOWTR = WOWTR or {}
WOWTR.Debug = Debug

-- Initialize state snapshot for early callers; Config/Core.lua re-initializes after AceDB is ready.
if Debug.Initialize then Debug.Initialize() end

return Debug
