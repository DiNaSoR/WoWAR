-- Debug.lua
-- Centralized debug system with categories, verbosity levels, and filtering

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

-- Initialize category levels from config or defaults
function Debug.Initialize()
  if WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core then
    -- Load category levels from config if they exist
    local debugConfig = WOWTR.db.profile.core.debugConfig or {}
    for categoryKey, categoryValue in pairs(Debug.Categories) do
      -- Store using the category VALUE (lowercase string like "quests") to match what's passed to ShouldPrint
      -- Config also uses lowercase keys, so this matches both
      categoryLevels[categoryValue] = debugConfig[categoryValue] or defaultCategoryLevel
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
  -- Category is passed as the VALUE (e.g., "quests"), so look it up directly
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
  -- Check for success indicators
  if string.find(message, "%[OK%]") or string.find(message, "FOUND") or string.find(message, "completed") or string.find(message, "successfully") then
    return Colors.SUCCESS
  end
  -- Check for error indicators
  if string.find(message, "%[X%]") or string.find(message, "ERROR") or string.find(message, "failed") or string.find(message, "No translation") or string.find(message, "not found") then
    return Colors.ERROR
  end
  -- Check for warnings/skips
  if string.find(message, "SKIP") or string.find(message, "skipping") or string.find(message, "WARNING") then
    return Colors.WARNING
  end
  -- Default to info color
  return Colors.INFO
end

-- Format values with colors
local function FormatValue(value)
  if type(value) == "boolean" then
    if value then
      return Colors.BOOLEAN_TRUE .. "true" .. Colors.RESET
    else
      return Colors.BOOLEAN_FALSE .. "false" .. Colors.RESET
    end
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
  -- Highlight quest IDs (numbers after "quest" or "Quest ID:")
  message = string.gsub(message, "(quest%s+)(%d+)", "%1" .. Colors.VALUE .. "%2" .. Colors.RESET)
  message = string.gsub(message, "(Quest%s+ID:%s+)(%d+)", "%1" .. Colors.VALUE .. "%2" .. Colors.RESET)
  message = string.gsub(message, "(QTR_quest_ID:%s+)(%d+)", "%1" .. Colors.VALUE .. "%2" .. Colors.RESET)
  -- Highlight standalone large numbers (likely IDs) - but avoid double-coloring
  -- Only highlight numbers that aren't already part of a colored section
  message = string.gsub(message, "([^|])(%d%d%d+)", function(prefix, num)
    -- Skip if this number is already colored or part of a pattern we've already handled
    if string.find(prefix, Colors.VALUE) or string.find(prefix, Colors.RESET) then
      return prefix .. num
    end
    if tonumber(num) and tonumber(num) > 100 then -- Likely an ID
      return prefix .. Colors.VALUE .. num .. Colors.RESET
    end
    return prefix .. num
  end)
  return message
end

-- Main debug print function
-- Usage: Debug.Print(Debug.Categories.QUESTS, Debug.Verbosity.NORMAL, "message", arg1, arg2, ...)
function Debug.Print(category, verbosity, ...)
  if not Debug.ShouldPrint(category, verbosity) then return end
  
  local prefix = Colors.PREFIX .. "WoWTR Debug:" .. Colors.RESET
  local categoryName = category or "general"
  local categoryColor = CategoryColors[categoryName] or Colors.INFO
  
  -- Format the message with category prefix
  local args = {...}
  -- Convert all arguments to strings with color formatting
  local stringArgs = {}
  for i = 1, #args do
    local arg = args[i]
    if arg == nil then
      stringArgs[i] = Colors.WARNING .. "nil" .. Colors.RESET
    elseif type(arg) == "boolean" then
      stringArgs[i] = FormatValue(arg)
    elseif type(arg) == "number" then
      stringArgs[i] = FormatValue(arg)
    elseif type(arg) == "string" then
      stringArgs[i] = arg
    else
      stringArgs[i] = tostring(arg)
    end
  end
  local message = table.concat(stringArgs, " ")
  
  -- Add category tag if not already present at the start
  -- Check if message starts with [CATEGORY] pattern, not just any [
  if not string.match(message, "^%[[A-Z]+%]") then
    message = categoryColor .. "[" .. string.upper(categoryName) .. "]" .. Colors.RESET .. " " .. message
  else
    -- Replace existing category tag with colored version
    message = string.gsub(message, "^%[([A-Z]+)%]", categoryColor .. "[%1]" .. Colors.RESET)
  end
  
  -- Check if message already has color codes (like red [X] messages)
  local hasColorCodes = string.find(message, "|c")
  
  -- Highlight important values in the message (before applying message color)
  if not hasColorCodes then
    message = HighlightImportantValues(message)
  end
  
  -- Detect message type and apply color
  local messageColor = GetMessageColor(message)
  
  -- Apply message color to the main message (but preserve existing color codes)
  -- Only apply if message doesn't already have color codes
  if not hasColorCodes then
    message = messageColor .. message .. Colors.RESET
  end
  
  print(prefix, message)
end

-- Convenience functions for each verbosity level
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

-- Group related prints together (suppresses intermediate prints if same quest/object)
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

-- Global wrapper for backward compatibility
WOWTR = WOWTR or {}
WOWTR.Debug = Debug

-- Initialize on load
Debug.Initialize()

return Debug

