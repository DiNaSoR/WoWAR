-- DebugState.lua
-- Debug state + persistence service (AceDB-backed).

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

Core.DebugState = Core.DebugState or {}
local State = Core.DebugState

local Schema = Core.DebugSchema or {}
local Verbosity = Schema.Verbosity or {}
local Presets = Schema.Presets or {}
local CategoryOrder = Schema.CategoryOrder or {}
local PresetOrder = Schema.PresetOrder or {}
local VerbosityMeta = Schema.VerbosityMeta or {}

local RESET = "|r"
local PREFIX = "|cFF00FF00[WoWAR]" .. RESET

local defaultCategoryLevel = Verbosity.NORMAL or 3
local categoryLevels = {}

local function _getCoreProfile()
  return WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core
end

local function _syncUi()
  if WOWTR and WOWTR.DebugToolsUI and WOWTR.DebugToolsUI.UpdateSettings then
    WOWTR.DebugToolsUI.UpdateSettings()
  end
end

local function _clampVerbosity(level)
  level = tonumber(level) or defaultCategoryLevel
  if level < 0 then level = 0 end
  if level > 4 then level = 4 end
  return level
end

function State.Initialize()
  local core = _getCoreProfile()
  if core then
    local debugConfig = core.debugConfig or {}
    for _, key in ipairs(CategoryOrder) do
      categoryLevels[key] = _clampVerbosity(debugConfig[key] or defaultCategoryLevel)
    end
  else
    for _, key in ipairs(CategoryOrder) do
      categoryLevels[key] = defaultCategoryLevel
    end
  end
end

function State.IsEnabled()
  local core = _getCoreProfile()
  return core and core.debug or false
end

function State.SetEnabled(state, silent)
  local core = _getCoreProfile()
  if core then
    core.debug = state and true or false
  end
  State.Initialize()
  _syncUi()
end

function State.GetCategoryLevel(category)
  return categoryLevels[category] or defaultCategoryLevel
end

function State.SetCategoryLevel(category, level, silent)
  if type(category) ~= "string" or category == "" then return false end
  local core = _getCoreProfile()
  if core then
    core.debugConfig = core.debugConfig or {}
    core.debugConfig[category] = _clampVerbosity(level)
  end
  categoryLevels[category] = _clampVerbosity(level)
  _syncUi()
  if not silent and DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    local vm = VerbosityMeta[categoryLevels[category]]
    local name = vm and vm.name or tostring(categoryLevels[category])
    local meta = (Schema.CategoryMeta and Schema.CategoryMeta[category]) or {}
    local badge = (meta.color or "|cFFFFFFFF") .. "[" .. (meta.tag or string.upper(category)) .. "]" .. RESET
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. " " .. badge .. " => " .. ((vm and vm.color) or "|cFFFFFFFF") .. name .. RESET)
  end
  return true
end

function State.ShouldPrint(category, verbosity)
  if not State.IsEnabled() then return false end
  local v = tonumber(verbosity) or defaultCategoryLevel
  local level = State.GetCategoryLevel(category)
  return v <= level
end

function State.SetPreset(name, silent)
  local preset = Presets[name]
  if not preset then
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
      DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. " |cFFFF4444Unknown preset:|r " .. tostring(name))
      DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. " |cFF888888Valid presets: " .. table.concat(Schema.GetPresetNames and Schema.GetPresetNames() or {}, "  ") .. "|r")
    end
    return false
  end

  local core = _getCoreProfile()
  if core then
    if preset.enabled ~= nil then
      core.debug = preset.enabled and true or false
    end
    if preset.categories then
      core.debugConfig = core.debugConfig or {}
      for k, v in pairs(preset.categories) do
        core.debugConfig[k] = _clampVerbosity(v)
      end
    end
  end

  State.Initialize()
  _syncUi()

  if not silent and DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    local badge = State.IsEnabled() and "|cFF00FF88[ON]|r" or "|cFF666666[OFF]|r"
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. " Preset |cFFFFD700" .. tostring(name) .. "|r applied " .. badge)
  end
  return true
end

function State.GetPresetNames()
  if Schema.GetPresetNames then
    return Schema.GetPresetNames()
  end
  local out = {}
  for i = 1, #PresetOrder do
    out[i] = PresetOrder[i]
  end
  return out
end

function State.GetStatusLine()
  local enabled = State.IsEnabled()
  local onoff = enabled and "|cFF00FF88ON|r" or "|cFF666666OFF|r"
  if not enabled then
    return PREFIX .. " Debug: " .. onoff
  end

  local parts = {}
  for _, key in ipairs(CategoryOrder) do
    local lvl = State.GetCategoryLevel(key)
    if lvl > 0 then
      local c = (Schema.CategoryMeta and Schema.CategoryMeta[key]) or {}
      local vm = VerbosityMeta[lvl] or {}
      parts[#parts + 1] = (c.color or "|cFFFFFFFF") .. (c.tag or string.upper(key)) .. RESET .. ":" .. (vm.color or "|cFFFFFFFF") .. (vm.name or tostring(lvl)) .. RESET
    end
  end

  return PREFIX .. " Debug: " .. onoff .. (#parts > 0 and (" | " .. table.concat(parts, "  ")) or (" | |cFF666666(all OFF)|r"))
end

function State.Status()
  local CF = DEFAULT_CHAT_FRAME
  if not CF or not CF.AddMessage then return end

  CF:AddMessage(PREFIX .. " |cFFFFD700=== WoWAR Debug Status ===|r")
  local enabled = State.IsEnabled()
  CF:AddMessage("  Master: " .. (enabled and "|cFF00FF88● ENABLED|r" or "|cFF666666○ DISABLED|r"))

  if enabled then
    CF:AddMessage("  |cFF888888Categories:|r")
    for _, key in ipairs(CategoryOrder) do
      local lvl = State.GetCategoryLevel(key)
      local vm = VerbosityMeta[lvl] or {}
      local c = (Schema.CategoryMeta and Schema.CategoryMeta[key]) or {}
      local bar = ""
      for i = 1, 4 do
        bar = bar .. (i <= lvl and "|cFF00FF88█|r" or "|cFF333333░|r")
      end
      CF:AddMessage("    " .. (c.color or "|cFFFFFFFF") .. "[" .. (c.tag or string.upper(key)) .. "]|r  " .. (vm.color or "|cFFFFFFFF") .. (vm.name or tostring(lvl)) .. "|r  " .. bar)
    end
  end

  CF:AddMessage("  |cFF888888Presets: " .. table.concat(State.GetPresetNames(), "  ") .. "|r")
  CF:AddMessage("  |cFF888888/wowardebug <on|off|toggle|status|preset <name>>|r")
end

State.Initialize()

return State
