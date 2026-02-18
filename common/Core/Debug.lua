-- Debug.lua
-- Centralized debug system with categories, verbosity levels, filtering, and smart logging

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

Core.Debug = Core.Debug or {}
local Debug = Core.Debug

-- Debug categories
Debug.Categories = {
  QUESTS = "quests",
  GOSSIP = "gossip",
  TOOLTIPS = "tooltips",
  BOOKS = "books",
  MOVIES = "movies",
  BUBBLES = "bubbles",
  CHAT = "chat",
  CONFIG = "config",
  GENERAL = "general",
}

-- Verbosity levels
Debug.Verbosity = {
  NONE = 0,      -- No debug output
  ERRORS = 1,    -- Only errors
  MINIMAL = 2,   -- Key events only
  NORMAL = 3,    -- Standard debugging
  VERBOSE = 4,   -- Everything including detailed state
}

-- Default settings
local defaultCategoryLevel = Debug.Verbosity.NORMAL
local categoryLevels = {}

-- Smart Log Buffer
Debug.LogBuffer = {}
Debug.MaxLogSize = 500 -- Keep last 500 entries
Debug.Filters = {
    ID = nil,       -- Filter by ID (number or string)
    Text = nil,     -- Filter by text match
}

-- Runtime Settings (can be toggled without saving)
Debug.Settings = {
    PrintToChat = false, -- If true, prints to standard chat frame
    CaptureAll = true,   -- If true, captures to buffer even if PrintToChat is false
}

-- Initialize category levels from config or defaults
function Debug.Initialize()
  if WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core then
    -- Load category levels from config if they exist
    local debugConfig = WOWTR.db.profile.core.debugConfig or {}
    for categoryKey, categoryValue in pairs(Debug.Categories) do
      -- Store using the category VALUE (lowercase string like "quests")
      categoryLevels[categoryValue] = debugConfig[categoryValue] or defaultCategoryLevel
    end
    -- Load PrintToChat setting if exists (default to false to avoid spam if using window)
    if WOWTR.db.profile.core.printToChat ~= nil then
        Debug.Settings.PrintToChat = WOWTR.db.profile.core.printToChat
    end
  else
    -- Set defaults
    for categoryKey, categoryValue in pairs(Debug.Categories) do
      categoryLevels[categoryValue] = defaultCategoryLevel
    end
  end
end

-- Check if debug is enabled globally
function Debug.IsEnabled()
  return WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core and WOWTR.db.profile.core.debug or false
end

-- Check if a category should output at given verbosity
function Debug.ShouldPrint(category, verbosity)
  if not Debug.IsEnabled() then return false end
  local categoryLevel = categoryLevels[category] or defaultCategoryLevel
  return verbosity <= categoryLevel
end

-- Color codes for different message types
local Colors = {
  PREFIX = "|cFF00FF00",      -- Green for "WoWTR Debug:"
  SUCCESS = "|cFF00FF00",     -- Green for success messages
  ERROR = "|cFFFF0000",       -- Red for errors
  WARNING = "|cFFFFFF00",     -- Yellow for warnings
  INFO = "|cFF00BFFF",        -- Blue for info
  VALUE = "|cFFFFD700",       -- Gold for important values (IDs, numbers)
  BOOLEAN_TRUE = "|cFF00FF00", -- Green for true
  BOOLEAN_FALSE = "|cFFFF0000", -- Red for false
  RESET = "|r",
}

-- Category colors
local CategoryColors = {
  quests = "|cFF00BFFF",     -- Blue
  gossip = "|cFFFF69B4",     -- Pink
  tooltips = "|cFF9370DB",   -- Purple
  books = "|cFFFFA500",      -- Orange
  movies = "|cFF32CD32",      -- Lime
  bubbles = "|cFF87CEEB",    -- Sky Blue
  chat = "|cFFFFD700",       -- Gold
  config = "|cFFDDA0DD",     -- Plum
  general = "|cFFFFFFFF",    -- White
}

-- Detect message type and apply appropriate color
local function GetMessageColor(message)
  if string.find(message, "%[OK%]") or string.find(message, "FOUND") or string.find(message, "completed") or string.find(message, "successfully") then
    return Colors.SUCCESS
  end
  if string.find(message, "%[X%]") or string.find(message, "ERROR") or string.find(message, "failed") or string.find(message, "No translation") or string.find(message, "not found") then
    return Colors.ERROR
  end
  if string.find(message, "SKIP") or string.find(message, "skipping") or string.find(message, "WARNING") then
    return Colors.WARNING
  end
  return Colors.INFO
end

-- Format values with colors
local function FormatValue(value)
  if type(value) == "boolean" then
    if value then return Colors.BOOLEAN_TRUE .. "true" .. Colors.RESET
    else return Colors.BOOLEAN_FALSE .. "false" .. Colors.RESET end
  elseif type(value) == "number" then
    return Colors.VALUE .. tostring(value) .. Colors.RESET
  elseif value == nil then
    return Colors.WARNING .. "nil" .. Colors.RESET
  else
    return tostring(value)
  end
end

-- Highlight quest IDs and important numbers in the message
local function HighlightImportantValues(message)
  message = string.gsub(message, "(quest%s+)(%d+)", "%1" .. Colors.VALUE .. "%2" .. Colors.RESET)
  message = string.gsub(message, "(Quest%s+ID:%s+)(%d+)", "%1" .. Colors.VALUE .. "%2" .. Colors.RESET)
  message = string.gsub(message, "(QTR_quest_ID:%s+)(%d+)", "%1" .. Colors.VALUE .. "%2" .. Colors.RESET)
  message = string.gsub(message, "([^|])(%d%d%d+)", function(prefix, num)
    if string.find(prefix, Colors.VALUE) or string.find(prefix, Colors.RESET) then return prefix .. num end
    if tonumber(num) and tonumber(num) > 100 then return prefix .. Colors.VALUE .. num .. Colors.RESET end
    return prefix .. num
  end)
  return message
end

-- Helper: Get Player Location Text
local function GetPlayerContext()
    if not C_Map or not C_Map.GetBestMapForUnit then return nil end
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return "No Map" end
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return string.format("Map:%s [Unknown]", tostring(mapID)) end
    local x, y = pos.x, pos.y
    return string.format("Map:%s [%.1f, %.1f]", tostring(mapID), (x or 0)*100, (y or 0)*100)
end

-- Main debug print function
function Debug.Print(category, verbosity, ...)
  if not Debug.ShouldPrint(category, verbosity) then return end
  
  -- Check Filters (Early exit if filtered out by specific runtime filters)
  -- Note: We usually filter at display time, but if we want to save memory we could filter here.
  -- For now, we capture everything allowed by category/verbosity settings.

  local prefix = Colors.PREFIX .. "WoWTR Debug:" .. Colors.RESET
  local categoryName = category or "general"
  local categoryColor = CategoryColors[categoryName] or Colors.INFO
  
  local args = {...}
  local stringArgs = {}
  local rawMessage = "" -- For raw text filtering

  for i = 1, #args do
    local arg = args[i]
    local strVal = tostring(arg)
    rawMessage = rawMessage .. strVal .. " "

    if arg == nil then
      stringArgs[i] = Colors.WARNING .. "nil" .. Colors.RESET
    elseif type(arg) == "boolean" then
      stringArgs[i] = FormatValue(arg)
    elseif type(arg) == "number" then
      stringArgs[i] = FormatValue(arg)
    elseif type(arg) == "string" then
      stringArgs[i] = arg
    else
      stringArgs[i] = strVal
    end
  end
  local message = table.concat(stringArgs, " ")
  
  -- Smart ID Filtering (if active)
  if Debug.Filters.ID then
      local idStr = tostring(Debug.Filters.ID)
      if not string.find(rawMessage, idStr) then return end
  end

  -- Smart Text Filtering (if active)
  if Debug.Filters.Text then
      if not string.find(string.lower(rawMessage), string.lower(Debug.Filters.Text)) then return end
  end
  
  -- Format with Category
  local displayMessage = message
  if not string.match(displayMessage, "^%[[A-Z]+%]") then
    displayMessage = categoryColor .. "[" .. string.upper(categoryName) .. "]" .. Colors.RESET .. " " .. displayMessage
  else
    displayMessage = string.gsub(displayMessage, "^%[([A-Z]+)%]", categoryColor .. "[%1]" .. Colors.RESET)
  end
  
  local hasColorCodes = string.find(displayMessage, "|c")
  if not hasColorCodes then
    displayMessage = HighlightImportantValues(displayMessage)
  end
  
  local messageColor = GetMessageColor(displayMessage)
  if not hasColorCodes then
    displayMessage = messageColor .. displayMessage .. Colors.RESET
  end

  -- Create Log Entry Object
  local entry = {
      timestamp = GetTime(),
      date = date("%H:%M:%S"),
      category = categoryName,
      verbosity = verbosity,
      message = displayMessage,
      rawMessage = rawMessage, -- useful for uncolored filtering
      context = (verbosity >= Debug.Verbosity.VERBOSE) and GetPlayerContext() or nil
  }

  Debug.AddLog(entry)

  -- Print to Chat if enabled
  if Debug.Settings.PrintToChat then
      print(prefix, displayMessage)
  end
end

-- Log Buffer Management
function Debug.AddLog(entry)
  table.insert(Debug.LogBuffer, entry)
  if #Debug.LogBuffer > Debug.MaxLogSize then
      table.remove(Debug.LogBuffer, 1)
  end
  
  -- Notify UI Callback
  if Debug.OnLogAdded then
      Debug.OnLogAdded(entry)
  end
end

function Debug.GetLogBuffer()
    return Debug.LogBuffer
end

function Debug.ClearLogBuffer()
    Debug.LogBuffer = {}
    if Debug.OnClearLogs then Debug.OnClearLogs() end
end

-- Convenience functions
function Debug.Error(category, ...)
  Debug.Print(category, Debug.Verbosity.ERRORS, ...)
end

function Debug.Minimal(category, ...)
  Debug.Print(category, Debug.Verbosity.MINIMAL, ...)
end

function Debug.Normal(category, ...)
  Debug.Print(category, Debug.Verbosity.NORMAL, ...)
end

function Debug.Verbose(category, ...)
  Debug.Print(category, Debug.Verbosity.VERBOSE, ...)
end

-- Function entry/exit tracking
local functionStack = {}

function Debug.Enter(functionName, category, ...)
  if not Debug.ShouldPrint(category or Debug.Categories.GENERAL, Debug.Verbosity.VERBOSE) then return end
  table.insert(functionStack, {name = functionName, time = GetTime()})
  Debug.Verbose(category or Debug.Categories.GENERAL, ">>>", functionName, "START", ...)
end

function Debug.Exit(functionName, category, ...)
  if not Debug.ShouldPrint(category or Debug.Categories.GENERAL, Debug.Verbosity.VERBOSE) then return end
  local entry = table.remove(functionStack)
  if entry and entry.name == functionName then
    local duration = GetTime() - entry.time
    Debug.Verbose(category or Debug.Categories.GENERAL, "<<<", functionName, "END", ..., "| Duration:", string.format("%.3f", duration), "s")
  else
    Debug.Verbose(category or Debug.Categories.GENERAL, "<<<", functionName, "END", ...)
  end
end

-- Group related prints together
local lastGroupKey = nil
local groupSuppressCount = 0

function Debug.GroupStart(key, category, verbosity, ...)
  if not Debug.ShouldPrint(category or Debug.Categories.GENERAL, verbosity or Debug.Verbosity.NORMAL) then return end
  if lastGroupKey == key then
    groupSuppressCount = groupSuppressCount + 1
    return false -- Suppress this print
  else
    lastGroupKey = key
    groupSuppressCount = 0
    Debug.Print(category or Debug.Categories.GENERAL, verbosity or Debug.Verbosity.NORMAL, ...)
    return true
  end
end

function Debug.GroupEnd()
  lastGroupKey = nil
  groupSuppressCount = 0
end

-- Global wrapper
WOWTR = WOWTR or {}
WOWTR.Debug = Debug

-- Initialize on load
Debug.Initialize()

return Debug
