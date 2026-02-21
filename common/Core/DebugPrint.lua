-- DebugPrint.lua
-- Formatting + print pipeline for debug output.

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

Core.DebugPrint = Core.DebugPrint or {}
local P = Core.DebugPrint

local Schema = Core.DebugSchema or {}
local State = Core.DebugState or {}
local Categories = Schema.Categories or {}
local Verbosity = Schema.Verbosity or {}
local CategoryMeta = Schema.CategoryMeta or {}
local SeverityBadges = Schema.SeverityBadges or {}

local RESET = "|r"
local PREFIX = "|cFF00FF00[WoWAR]" .. RESET

-- Per-message dedupe for VERBOSE spam.
local _verboseDedupeLast = {}

local function _fmtVal(v)
  if type(v) == "boolean" then
    return v and ("|cFF00FF88true" .. RESET) or ("|cFFFF4444false" .. RESET)
  elseif type(v) == "number" then
    return "|cFFFFD700" .. tostring(v) .. RESET
  elseif v == nil then
    return "|cFFFFAA00nil" .. RESET
  end
  return tostring(v)
end

-- Highlight bare numeric IDs (>100) that are not already color-coded.
local function _highlightIds(msg)
  return (msg:gsub("([^|])(%d%d%d+)", function(pre, num)
    if tonumber(num) and tonumber(num) > 100 then
      return pre .. "|cFFFFD700" .. num .. RESET
    end
    return pre .. num
  end))
end

function P.Print(category, verbosity, ...)
  if not State.ShouldPrint(category, verbosity) then return end

  local catName = category or Categories.GENERAL or "general"
  local meta = CategoryMeta[catName] or {}
  local catColor = meta.color or "|cFFFFFFFF"
  local catTag = meta.tag or string.upper(catName)
  local catBadge = catColor .. "[" .. catTag .. "]" .. RESET
  local sev = SeverityBadges[verbosity] or SeverityBadges[Verbosity.NORMAL or 3] or { icon = "", label = "INF", color = "|cFF00FF88" }

  -- Build message from varargs.
  local args = { ... }
  local parts = {}
  for i = 1, #args do
    local a = args[i]
    if a == nil or type(a) == "boolean" or type(a) == "number" then
      parts[i] = _fmtVal(a)
    else
      parts[i] = tostring(a)
    end
  end
  local message = table.concat(parts, " ")

  -- Guard rapid VERBOSE spam.
  if verbosity == (Verbosity.VERBOSE or 4) then
    local now = (GetTime and GetTime()) or 0
    local key = tostring(catName) .. "\n" .. message
    local last = _verboseDedupeLast[key]
    if last and (now - last) < 0.35 then return end
    _verboseDedupeLast[key] = now
  end

  if not message:find("|c") then
    message = _highlightIds(message)
  end

  local icon = (sev.icon and sev.icon ~= "")
    and (sev.icon .. " ")
    or ((sev.color or "|cFFFFFFFF") .. "[" .. (sev.label or "?") .. "]" .. RESET .. " ")

  print(PREFIX .. " " .. catBadge .. " " .. icon .. message)
end

function P.Error(category, ...)
  P.Print(category, Verbosity.ERRORS or 1, ...)
end

function P.Minimal(category, ...)
  P.Print(category, Verbosity.MINIMAL or 2, ...)
end

function P.Normal(category, ...)
  P.Print(category, Verbosity.NORMAL or 3, ...)
end

function P.Verbose(category, ...)
  P.Print(category, Verbosity.VERBOSE or 4, ...)
end

-- Function entry/exit tracking
local functionStack = {}

function P.Enter(functionName, category, ...)
  if not State.ShouldPrint(category or Categories.GENERAL, Verbosity.VERBOSE or 4) then return end
  table.insert(functionStack, { name = functionName, time = GetTime() })
  P.Verbose(category or Categories.GENERAL, ">>>", functionName, "START", ...)
end

function P.Exit(functionName, category, ...)
  if not State.ShouldPrint(category or Categories.GENERAL, Verbosity.VERBOSE or 4) then return end
  local entry = table.remove(functionStack)
  if entry and entry.name == functionName then
    local duration = GetTime() - entry.time
    P.Verbose(category or Categories.GENERAL, "<<<", functionName, "END", ..., "| Duration:", string.format("%.3f", duration), "s")
  else
    P.Verbose(category or Categories.GENERAL, "<<<", functionName, "END", ...)
  end
end

-- Group related prints together (suppresses identical key repeats).
local lastGroupKey = nil
local groupSuppressCount = 0

function P.GroupStart(key, category, verbosity, ...)
  if not State.ShouldPrint(category or Categories.GENERAL, verbosity or Verbosity.NORMAL or 3) then return end
  if lastGroupKey == key then
    groupSuppressCount = groupSuppressCount + 1
    return false
  end
  lastGroupKey = key
  groupSuppressCount = 0
  P.Print(category or Categories.GENERAL, verbosity or Verbosity.NORMAL or 3, ...)
  return true
end

function P.GroupEnd()
  lastGroupKey = nil
  groupSuppressCount = 0
end

return P
