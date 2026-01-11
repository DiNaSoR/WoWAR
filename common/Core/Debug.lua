-- Debug.lua
-- Centralized debug system with categories, verbosity levels, and filtering

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

Core.Debug = Core.Debug or {}
local Debug = Core.Debug

-- Agent debug logging (NDJSON) for Cursor debug-mode runs.
-- Stores compact JSON lines under WOWTR_DB.global.agentDebugNDJSON so they can be exported from SavedVariables.
local function _agentJsonEscape(v)
  local s = tostring(v)
  s = s:gsub("\\", "\\\\")
       :gsub("\"", "\\\"")
       :gsub("\n", "\\n")
       :gsub("\r", "\\r")
       :gsub("\t", "\\t")
  return s
end

local function _agentJsonValue(v)
  local t = type(v)
  if v == nil then return "null" end
  if t == "number" then return tostring(v) end
  if t == "boolean" then return v and "true" or "false" end
  if t == "string" then return "\"" .. _agentJsonEscape(v) .. "\"" end
  -- Keep it safe and compact for non-primitive values.
  return "\"" .. _agentJsonEscape(tostring(v)) .. "\""
end

local function _agentJsonObject(obj)
  if type(obj) ~= "table" then return "{}" end
  local parts = {}
  for k, v in pairs(obj) do
    if type(k) == "string" then
      parts[#parts + 1] = "\"" .. _agentJsonEscape(k) .. "\":" .. _agentJsonValue(v)
    end
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function _agentGetRunId()
  local db = rawget(_G, "WOWTR_DB")
  local rid = db and db.global and db.global.agentDebugRunId
  if type(rid) == "string" and rid ~= "" then return rid end
  return "run1"
end

local function _agentEnsureStore()
  _G.WOWTR_DB = _G.WOWTR_DB or {}
  _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
  _G.WOWTR_DB.global.agentDebugNDJSON = _G.WOWTR_DB.global.agentDebugNDJSON or {}
  _G.WOWTR_DB.global.agentDebugNDJSONMax = _G.WOWTR_DB.global.agentDebugNDJSONMax or 250
  return _G.WOWTR_DB.global.agentDebugNDJSON, _G.WOWTR_DB.global.agentDebugNDJSONMax
end

local function _agentEnsureDumpStore()
  _G.WOWTR_DB = _G.WOWTR_DB or {}
  _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
  _G.WOWTR_DB.global.agentDumpNDJSON = _G.WOWTR_DB.global.agentDumpNDJSON or {}
  _G.WOWTR_DB.global.agentDumpNDJSONMax = _G.WOWTR_DB.global.agentDumpNDJSONMax or 10000
  return _G.WOWTR_DB.global.agentDumpNDJSON, _G.WOWTR_DB.global.agentDumpNDJSONMax
end

-- Session-persistent deduplication set (survives multiple dumps until /reload)
local _dumpSeenHashes = {}

-- Public agent log helper: writes one NDJSON line into SavedVariables (exportable later).
function Debug.AgentLog(hypothesisId, location, message, data)
  local store, maxN = _agentEnsureStore()
  if type(store) ~= "table" then return end

  local ts = time and (time() * 1000) or 0
  local payload = {
    sessionId = "debug-session",
    runId = _agentGetRunId(),
    hypothesisId = hypothesisId or "UNKNOWN",
    location = location or "unknown",
    message = message or "",
    timestamp = ts,
  }

  local json =
    "{" ..
    "\"sessionId\":" .. _agentJsonValue(payload.sessionId) .. "," ..
    "\"runId\":" .. _agentJsonValue(payload.runId) .. "," ..
    "\"hypothesisId\":" .. _agentJsonValue(payload.hypothesisId) .. "," ..
    "\"location\":" .. _agentJsonValue(payload.location) .. "," ..
    "\"message\":" .. _agentJsonValue(payload.message) .. "," ..
    "\"data\":" .. _agentJsonObject(data) .. "," ..
    "\"timestamp\":" .. _agentJsonValue(payload.timestamp) ..
    "}"

  store[#store + 1] = json
  if #store > maxN then
    table.remove(store, 1)
  end
end

-- Public agent dump helper: larger store for bulk exports (UI string dumps, etc.)
function Debug.AgentDumpLog(hypothesisId, location, message, data)
  local store, maxN = _agentEnsureDumpStore()
  if type(store) ~= "table" then return end

  local ts = time and (time() * 1000) or 0
  local payload = {
    sessionId = "debug-session",
    runId = _agentGetRunId(),
    hypothesisId = hypothesisId or "DUMP",
    location = location or "unknown",
    message = message or "",
    timestamp = ts,
  }

  local json =
    "{" ..
    "\"sessionId\":" .. _agentJsonValue(payload.sessionId) .. "," ..
    "\"runId\":" .. _agentJsonValue(payload.runId) .. "," ..
    "\"hypothesisId\":" .. _agentJsonValue(payload.hypothesisId) .. "," ..
    "\"location\":" .. _agentJsonValue(payload.location) .. "," ..
    "\"message\":" .. _agentJsonValue(payload.message) .. "," ..
    "\"data\":" .. _agentJsonObject(data) .. "," ..
    "\"timestamp\":" .. _agentJsonValue(payload.timestamp) ..
    "}"

  store[#store + 1] = json
  if #store > maxN then
    table.remove(store, 1)
  end
end

-------------------------------------------------------------------------------
-- Smart UI String Dumper (auto-dumps all visible frames)
-- Use /wowardebug and click "Dump Visible UI" to capture everything on screen
-------------------------------------------------------------------------------

-- Noise patterns to skip (pure numbers, money, dynamic counts, etc.)
local function _isNoiseText(text)
  if not text or text == "" then return true end
  -- Pure whitespace
  if text:match("^%s*$") then return true end
  -- Pure number (with optional comma/decimal)
  if text:match("^%-?[%d,%.]+$") then return true end
  -- Parenthesized count like "(33)"
  if text:match("^%(%d+%)$") then return true end
  -- Very short (1-2 chars) unless special
  if string.len(text) <= 2 then
    -- Single-letter hotkeys (E, Q, Z, etc.) and short tokens are not translation targets.
    if text:match("^[%a]$") then return true end
    if not text:match("[%a]") then return true end
  end
  -- Money strings (Gold/Silver/Copper icons)
  if text:match("UI%-GoldIcon") or text:match("UI%-SilverIcon") or text:match("UI%-CopperIcon") then return true end
  -- Pure color codes with no text
  if text:match("^|c[%x]+|r$") then return true end
  -- Reagent counts like "85/1" or "7/5"
  if text:match("^%d+/%d+$") then return true end
  -- Reagent/progress counts with spaces like "0 / 1000"
  if text:match("^%s*%d+%s*/%s*%d+%s*$") then return true end
  -- Level/skill numbers like "100/100" or "1000/1000"
  if text:match("^%d+/%d+%s*$") then return true end
  -- Common keybind/hotkey patterns (Shift/Ctrl shown as s-/c- in some UIs)
  if text:match("^[sc]%-[%w%+]+$") then return true end
  -- Function keys
  if text:match("^F%d+$") then return true end
  -- Mouse button labels / numpad labels
  if text:match("^Mouse Button") or text:match("^Middle Mouse$") or text:match("^Num Pad") then return true end
  return false
end

-- Dump everything currently visible on screen (auto-detect visible root frames).
-- Intended to replace manual /fstack and manual frame targeting during UI exploration.
function Debug.DumpVisibleUI(opts)
  opts = opts or {}
  local includeHidden = opts.includeHidden and true or false
  local includeAll = opts.includeAll and true or false
  local skipNoise = (opts.skipNoise == nil) and true or opts.skipNoise
  local dedupe = (opts.dedupe == nil) and true or opts.dedupe
  local includeArt = opts.includeArt and true or false
  local maxRoots = (type(opts.maxRoots) == "number" and opts.maxRoots) or 30
  local maxNodesPerRoot = (type(opts.maxNodes) == "number" and opts.maxNodes) or 2000
  local maxDepth = (type(opts.maxDepth) == "number" and opts.maxDepth) or 12
  local maxArtEntries = (type(opts.maxArtEntries) == "number" and opts.maxArtEntries) or 6000

  if type(_G.EnumerateFrames) ~= "function" then
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WoWAR Dump]|r EnumerateFrames() not available in this client.")
    return 0
  end

  local strataRank = {
    BACKGROUND = 1,
    LOW = 2,
    MEDIUM = 3,
    HIGH = 4,
    DIALOG = 5,
    FULLSCREEN = 6,
    FULLSCREEN_DIALOG = 7,
    TOOLTIP = 8,
  }

  local function safeVisible(obj)
    if includeHidden then return true end
    if obj and obj.IsVisible then
      local ok, v = pcall(obj.IsVisible, obj)
      if ok then return v and true or false end
    end
    return true
  end

  local function safeName(obj)
    if obj and obj.GetName then
      local ok, n = pcall(obj.GetName, obj)
      if ok and n and n ~= "" then return n end
    end
    return nil
  end

  local roots = {}
  local rootSet = {}
  local rootNameSet = {}

  local f = _G.EnumerateFrames()
  while f do
    if f ~= UIParent and safeVisible(f) then
      local name = safeName(f)
      if name then
        local top = f
        local guard = 0
        while top and top.GetParent and top:GetParent() and top:GetParent() ~= UIParent and guard < 25 do
          top = top:GetParent()
          guard = guard + 1
        end
        if top and top ~= UIParent and safeVisible(top) and not rootSet[top] then
          local topName = safeName(top)
          if topName then
            -- Don't include our own debug tools frame in dumps (it will always be visible during dumping).
            if topName == "WOWTR_DebugToolsUIFrame" then
              rootSet[top] = true
            elseif rootNameSet[topName] then
              rootSet[top] = true
            else
            local okS, s = pcall(top.GetFrameStrata, top)
            local okL, lvl = pcall(top.GetFrameLevel, top)
            local sr = (okS and strataRank[s]) or 0
            local lv = (okL and tonumber(lvl)) or 0
            roots[#roots + 1] = { frame = top, name = topName, score = (sr * 10000) + lv }
            rootSet[top] = true
            rootNameSet[topName] = true
            end
          end
        end
      end
    end
    f = _G.EnumerateFrames(f)
  end

  table.sort(roots, function(a, b) return a.score > b.score end)
  if #roots > maxRoots then
    for i = maxRoots + 1, #roots do roots[i] = nil end
  end

  Debug.AgentDumpLog("DUMP", "Debug.DumpVisibleUI", "start_visible", {
    roots = #roots,
    includeAll = includeAll,
    skipNoise = skipNoise,
    dedupe = dedupe,
    includeHidden = includeHidden,
    includeArt = includeArt,
    maxNodesPerRoot = maxNodesPerRoot,
    maxDepth = maxDepth,
    maxArtEntries = maxArtEntries,
  })

  local totalStrings = 0
  local totalArt = 0
  for i = 1, #roots do
    local r = roots[i]
    totalStrings = totalStrings + Debug.DumpFrameStrings(r.frame, {
      includeHidden = includeHidden,
      includeAll = includeAll,
      skipNoise = skipNoise,
      dedupe = dedupe,
      maxNodes = maxNodesPerRoot,
      maxDepth = maxDepth,
      silent = true,
    })

    if includeArt and Debug.DumpFrameArt then
      totalArt = totalArt + Debug.DumpFrameArt(r.frame, {
        includeHidden = includeHidden,
        maxNodes = maxNodesPerRoot,
        maxDepth = maxDepth,
        maxEntries = maxArtEntries,
        silent = true,
      })
    end
  end

  Debug.AgentDumpLog("DUMP", "Debug.DumpVisibleUI", "end_visible", { roots = #roots, strings = totalStrings, artEntries = totalArt })
  local msg = "|cFF00FF00[WoWAR Dump]|r Visible UI dump: roots=" .. tostring(#roots) .. ", strings=" .. tostring(totalStrings)
  if includeArt then
    msg = msg .. ", art=" .. tostring(totalArt)
  end
  msg = msg .. " (export after /reload)"
  DEFAULT_CHAT_FRAME:AddMessage(msg)
  return totalStrings
end

-- Categorize text by its likely UI role
local function _categorizeText(text, kind, path)
  if not text then return "unknown" end
  local lower = text:lower()
  
  -- Buttons usually have action words
  if kind == "Button" then return "button" end
  
  -- Check path hints
  if path then
    if path:match("Button") then return "button" end
    if path:match("Label") then return "label" end
    if path:match("Title") then return "title" end
    if path:match("Description") then return "description" end
    if path:match("Header") then return "header" end
    if path:match("Tab") then return "tab" end
    if path:match("Tooltip") then return "tooltip" end
  end
  
  -- Long text is usually description
  if string.len(text) > 100 then return "description" end
  
  -- Check for common patterns
  if lower:match("^click") or lower:match("^press") or lower:match("^open") then return "button" end
  if text:match(":$") then return "label" end
  
  return "text"
end

-- Generate a suggested translation key from text
local function _suggestKey(text, category, rootName)
  if not text then return "" end
  -- Clean the text
  local clean = text
    :gsub("|c%x%x%x%x%x%x%x%x", "") -- remove color start
    :gsub("|r", "") -- remove color end
    :gsub("|T.-|t", "") -- remove textures
    :gsub("|A.-|a", "") -- remove atlases
    :gsub("|H.-|h(.-)|h", "%1") -- extract hyperlink text
    :gsub("[^%w%s]", "") -- remove punctuation
    :gsub("%s+", "_") -- spaces to underscores
    :gsub("^_+", "") -- trim leading
    :gsub("_+$", "") -- trim trailing
  
  -- Truncate and format
  if string.len(clean) > 40 then
    clean = string.sub(clean, 1, 40)
  end
  
  -- Prefix with root frame hint
  local prefix = ""
  if rootName then
    if rootName:match("Profession") then prefix = "Prof_"
    elseif rootName:match("Talent") then prefix = "Talent_"
    elseif rootName:match("Quest") then prefix = "Quest_"
    elseif rootName:match("Tooltip") then prefix = "TT_"
    else prefix = rootName:sub(1, 8) .. "_" end
  end
  
  return prefix .. (category or "") .. "_" .. clean
end

-- Smart dump: filters noise, dedupes, only logs missing translations by default
function Debug.DumpFrameStrings(rootFrame, opts)
  opts = opts or {}
  local silent = opts.silent and true or false
  local includeHidden = opts.includeHidden and true or false
  local includeAll = opts.includeAll and true or false -- false = missing only
  local skipNoise = (opts.skipNoise == nil) and true or opts.skipNoise
  local dedupe = (opts.dedupe == nil) and true or opts.dedupe
  local maxNodes = (type(opts.maxNodes) == "number" and opts.maxNodes) or 10000
  local maxDepth = (type(opts.maxDepth) == "number" and opts.maxDepth) or 15
  local maxTextLen = (type(opts.maxTextLen) == "number" and opts.maxTextLen) or 500

  if not rootFrame then
    Debug.AgentDumpLog("DUMP", "Debug.DumpFrameStrings", "error", { reason = "rootFrame=nil" })
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WoWAR Dump]|r Error: Frame not found or not loaded yet.")
    return 0
  end

  local visited = {}
  local count = 0
  local skippedNoise = 0
  local skippedDupe = 0
  local skippedHasTranslation = 0

  local function safeName(obj)
    if obj and obj.GetName then
      local ok, n = pcall(obj.GetName, obj)
      if ok and n then return n end
    end
    return nil
  end

  local function safeVisible(obj)
    if includeHidden then return true end
    if obj and obj.IsVisible then
      local ok, v = pcall(obj.IsVisible, obj)
      if ok then return v and true or false end
    end
    return true
  end

  local function normalizeText(s)
    if type(s) ~= "string" then return nil end
    if s == "" then return nil end
    if string.len(s) > maxTextLen then
      return string.sub(s, 1, maxTextLen) .. "..."
    end
    return s
  end

  local function computeHash(text)
    if type(text) ~= "string" then return nil end
    local norm = text
    if _G.ST_UsunZbedneZnaki then
      local ok, out = pcall(_G.ST_UsunZbedneZnaki, text)
      if ok and type(out) == "string" then norm = out end
    end
    if _G.StringHash then
      local ok, h = pcall(_G.StringHash, norm)
      if ok and type(h) == "number" then return h end
    end
    return nil
  end

  local function hasTranslation(hash)
    if not hash then return false end
    local hs = rawget(_G, "ST_TooltipsHS")
    return (type(hs) == "table" and hs[hash] ~= nil) or false
  end

  local rootName = safeName(rootFrame) or "root"

  local function containsArabic(text)
    if type(text) ~= "string" or text == "" then return false end
    if type(_G.AS_ContainsArabic) == "function" then
      local ok, v = pcall(_G.AS_ContainsArabic, text)
      if ok then return v == true end
    end
    return false
  end

  local function isArabicMode()
    local loc = rawget(_G, "WOWTR_Localization")
    return (type(loc) == "table" and loc.lang == "AR") or false
  end

  local function logString(obj, path, text, kind)
    local t = normalizeText(text)
    if not t then return end

    -- Skip common non-translation UI regions by name (hotkeys, counts)
    local objName = safeName(obj)
    if objName and (objName:find("HotKey") or objName:find("ButtonCount") or objName:find("BackpackButtonCount") or objName:find("Count$")) then
      if skipNoise then
        skippedNoise = skippedNoise + 1
        return
      end
    end
    
    -- Smart filter: skip noise
    if skipNoise and _isNoiseText(t) then
      skippedNoise = skippedNoise + 1
      return
    end

    -- If this text already looks translated by WoWAR (NONBREAKINGSPACE marker), treat as translated.
    local nbsp = rawget(_G, "NONBREAKINGSPACE")
    if (not includeAll) and type(nbsp) == "string" and nbsp ~= "" and t:find(nbsp, 1, true) then
      skippedHasTranslation = skippedHasTranslation + 1
      return
    end

    -- If the string already contains Arabic characters, treat as already-localized (not "missing").
    -- This avoids polluting missing lists with already-translated / Blizzard-localized Arabic UI text.
    if (not includeAll) and containsArabic(t) then
      skippedHasTranslation = skippedHasTranslation + 1
      return
    end
    
    local h = computeHash(t)
    local hasTrans = hasTranslation(h)
    
    -- Skip if already translated (unless includeAll)
    if not includeAll and hasTrans then
      skippedHasTranslation = skippedHasTranslation + 1
      return
    end
    
    -- Deduplication (per-session, persists across multiple dump calls)
    local dupeKey = tostring(h or 0) .. ":" .. t
    if dedupe and _dumpSeenHashes[dupeKey] then
      skippedDupe = skippedDupe + 1
      return
    end
    if dedupe then
      _dumpSeenHashes[dupeKey] = true
    end
    
    local category = _categorizeText(t, kind, path)
    local suggestedKey = _suggestKey(t, category, rootName)
    
    Debug.AgentDumpLog(
      "DUMP",
      "Debug.DumpFrameStrings",
      "ui_string",
      {
        root = rootName,
        kind = kind,
        category = category,
        path = path,
        name = safeName(obj),
        text = t,
        hash = h,
        hasTranslation = hasTrans,
        suggestedKey = suggestedKey,
      }
    )
    count = count + 1
  end

  local function walk(obj, path, depth)
    if not obj or visited[obj] then return end
    visited[obj] = true
    if count >= maxNodes or depth > maxDepth then return end
    if not safeVisible(obj) then return end

    -- Regions (FontStrings are usually in GetRegions())
    if obj.GetRegions then
      local regions = { obj:GetRegions() }
      for i = 1, #regions do
        local r = regions[i]
        if r and not visited[r] and safeVisible(r) then
          visited[r] = true
          local okType, ot = pcall(r.GetObjectType, r)
          if okType and ot == "FontString" and r.GetText then
            local okText, txt = pcall(r.GetText, r)
            if okText then
              logString(r, path .. ".regions[" .. i .. "]", txt, "FontString")
            end
          elseif r.GetText then
            local okText, txt = pcall(r.GetText, r)
            if okText then
              logString(r, path .. ".regions[" .. i .. "]", txt, ot or "Region")
            end
          end
        end
        if count >= maxNodes then return end
      end
    end

    -- Some frames/buttons expose GetText directly
    if obj.GetText then
      local okText, txt = pcall(obj.GetText, obj)
      if okText then
        local okType, ot = pcall(obj.GetObjectType, obj)
        logString(obj, path, txt, okType and ot or "Object")
      end
    end

    -- Children
    if obj.GetChildren then
      local children = { obj:GetChildren() }
      for i = 1, #children do
        local ch = children[i]
        walk(ch, path .. ".children[" .. i .. "]", depth + 1)
        if count >= maxNodes then return end
      end
    end
  end

  -- Log start
  Debug.AgentDumpLog("DUMP", "Debug.DumpFrameStrings", "start", {
    root = rootName,
    includeAll = includeAll,
    skipNoise = skipNoise,
    dedupe = dedupe,
  })
  
  walk(rootFrame, rootName, 0)
  
  -- Log end with stats
  Debug.AgentDumpLog("DUMP", "Debug.DumpFrameStrings", "end", {
    root = rootName,
    strings = count,
    skippedNoise = skippedNoise,
    skippedDupe = skippedDupe,
    skippedHasTranslation = skippedHasTranslation,
  })
  
  -- User feedback
  if not silent then
    local msg = string.format(
      "|cFF00FF00[WoWAR Dump]|r %s: |cFFFFD700%d|r strings found (|cFF808080%d noise, %d dupes, %d translated skipped|r)",
      rootName, count, skippedNoise, skippedDupe, skippedHasTranslation
    )
    DEFAULT_CHAT_FRAME:AddMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Dump]|r Type |cFFFFD700/reload|r then run |cFFFFD700Tools/ExportAgentDebugLog.ps1|r to export.")
  end
  
  return count
end

-- Dump UI structure + art for a frame tree (textures/atlases/layout).
-- Intended for recreating Blizzard-style layouts (e.g., SplashFrame "What's New") without /fstack.
function Debug.DumpFrameArt(rootFrame, opts)
  opts = opts or {}
  local includeHidden = opts.includeHidden and true or false
  local maxDepth = (type(opts.maxDepth) == "number" and opts.maxDepth) or 12
  local maxNodes = (type(opts.maxNodes) == "number" and opts.maxNodes) or 2000
  local maxEntries = (type(opts.maxEntries) == "number" and opts.maxEntries) or 6000 -- log lines budget
  local silent = opts.silent and true or false

  if not rootFrame then return 0 end

  local visited = {}
  local entries = 0

  -- Registry: map object → walk-path (so unnamed frames can be resolved)
  local objToPath = {}

  local function safeVisible(obj)
    if includeHidden then return true end
    if obj and obj.IsVisible then
      local ok, v = pcall(obj.IsVisible, obj)
      if ok then return v and true or false end
    end
    return true
  end

  local function safeName(obj)
    if obj and obj.GetName then
      local ok, n = pcall(obj.GetName, obj)
      if ok and n and n ~= "" then return n end
    end
    return nil
  end

  local function safeType(obj)
    if obj and obj.GetObjectType then
      local ok, t = pcall(obj.GetObjectType, obj)
      if ok and t then return t end
    end
    return "Object"
  end

  -- Helper: resolve relTo to a usable string (name or path)
  local function resolveRelTo(relTo, currentObj)
    if not relTo then return "" end
    -- 1) Has a global name?
    local name = safeName(relTo)
    if name then return name end
    -- 2) Is it in our registry? Use its walk-path
    local pathRef = objToPath[relTo]
    if pathRef then return pathRef end
    -- 3) Is it the parent of currentObj?
    if currentObj and currentObj.GetParent then
      local okP, par = pcall(currentObj.GetParent, currentObj)
      if okP and par == relTo then return "$parent" end
    end
    -- 4) Fallback: anonymous reference (better than raw table pointer)
    return "<unnamed>"
  end

  local function packPoints(obj)
    if not (obj and obj.GetNumPoints and obj.GetPoint) then return "" end
    local okN, n = pcall(obj.GetNumPoints, obj)
    n = (okN and tonumber(n)) or 0
    if not n or n <= 0 then return "" end
    local parts = {}
    for i = 1, math.min(n, 5) do
      local okP, p, relTo, relPoint, x, y = pcall(obj.GetPoint, obj, i)
      if okP and p then
        local relRef = resolveRelTo(relTo, obj)
        parts[#parts + 1] =
          tostring(p) .. "," ..
          tostring(relRef) .. "," ..
          tostring(relPoint or "") .. "," ..
          tostring(x or 0) .. "," ..
          tostring(y or 0)
      end
    end
    return table.concat(parts, ";")
  end

  local function packSize(obj)
    if not (obj and obj.GetSize) then return "" end
    local ok, w, h = pcall(obj.GetSize, obj)
    if not ok then return "" end
    return tostring(w or 0) .. "x" .. tostring(h or 0)
  end

  local function packTexCoord(tex)
    if not (tex and tex.GetTexCoord) then return "" end
    local ok, a, b, c, d, e, f, g, h = pcall(tex.GetTexCoord, tex)
    if not ok then return "" end
    if a and b and c and d and (e == nil) then
      return table.concat({ tostring(a), tostring(b), tostring(c), tostring(d) }, ",")
    end
    return table.concat({
      tostring(a or ""), tostring(b or ""), tostring(c or ""), tostring(d or ""),
      tostring(e or ""), tostring(f or ""), tostring(g or ""), tostring(h or "")
    }, ",")
  end

  local function packColor(obj)
    if not (obj and obj.GetVertexColor) then return "" end
    local ok, r, g, b, a = pcall(obj.GetVertexColor, obj)
    if not ok then return "" end
    return table.concat({ tostring(r or ""), tostring(g or ""), tostring(b or ""), tostring(a or "") }, ",")
  end

  local function logArt(kind, rootName, path, obj, extra)
    if entries >= maxEntries then return end
    extra = extra or {}
    extra.root = rootName
    extra.path = path
    extra.kind = kind
    extra.name = safeName(obj)
    extra.objectType = safeType(obj)
    extra.visible = safeVisible(obj)
    extra.points = packPoints(obj)
    extra.size = packSize(obj)
    Debug.AgentDumpLog("DUMP", "Debug.DumpFrameArt", "ui_art", extra)
    entries = entries + 1
  end

  local rootName = safeName(rootFrame) or "root"

  -- Pre-register root frame
  objToPath[rootFrame] = rootName

  local function walk(obj, path, depth)
    if not obj or visited[obj] then return end
    visited[obj] = true
    -- Register this object's path for resolveRelTo
    objToPath[obj] = path
    if entries >= maxEntries then return end
    if depth > maxDepth then return end
    if not safeVisible(obj) then return end

    -- Log the frame node itself (layout-ish)
    if entries < maxEntries then
      local extra = {}
      if obj.GetFrameStrata then
        local okS, s = pcall(obj.GetFrameStrata, obj)
        if okS then extra.strata = s end
      end
      if obj.GetFrameLevel then
        local okL, lvl = pcall(obj.GetFrameLevel, obj)
        if okL then extra.level = lvl end
      end
      if obj.GetAlpha then
        local okA, a = pcall(obj.GetAlpha, obj)
        if okA then extra.alpha = a end
      end
      if obj.GetScale then
        local okSc, sc = pcall(obj.GetScale, obj)
        if okSc then extra.scale = sc end
      end
      logArt("Frame", rootName, path, obj, extra)
    end

    -- Regions: Textures/FontStrings are returned here
    if obj.GetRegions then
      local regions = { obj:GetRegions() }
      for i = 1, #regions do
        local r = regions[i]
        if r and not visited[r] and safeVisible(r) then
          visited[r] = true
          local regionPath = path .. ".regions[" .. i .. "]"
          objToPath[r] = regionPath -- register for resolveRelTo
          local ot = safeType(r)

          if ot == "Texture" then
            local extra = {}
            if r.GetAtlas then
              local okAt, at = pcall(r.GetAtlas, r)
              if okAt and at then extra.atlas = at end
            end
            if r.GetTexture then
              local okTx, tx = pcall(r.GetTexture, r)
              if okTx and tx ~= nil then extra.texture = tostring(tx) end
            end
            if r.GetDrawLayer then
              local okDL, layer, sub = pcall(r.GetDrawLayer, r)
              if okDL then
                extra.drawLayer = layer
                extra.subLevel = sub
              end
            end
            if r.GetBlendMode then
              local okBM, bm = pcall(r.GetBlendMode, r)
              if okBM then extra.blendMode = bm end
            end
            if r.GetAlpha then
              local okA, a = pcall(r.GetAlpha, r)
              if okA then extra.alpha = a end
            end
            extra.texCoord = packTexCoord(r)
            extra.vertexColor = packColor(r)
            logArt("Texture", rootName, path .. ".regions[" .. i .. "]", r, extra)
          elseif ot == "FontString" then
            local extra = {}
            if r.GetFont then
              local okF, font, size, flags = pcall(r.GetFont, r)
              if okF then
                extra.font = tostring(font or "")
                extra.fontSize = size
                extra.fontFlags = tostring(flags or "")
              end
            end
            if r.GetTextColor then
              local okC, rr, gg, bb, aa = pcall(r.GetTextColor, r)
              if okC then extra.textColor = table.concat({ rr, gg, bb, aa }, ",") end
            end
            if r.GetJustifyH then
              local okJ, j = pcall(r.GetJustifyH, r)
              if okJ then extra.justifyH = j end
            end
            logArt("FontString", rootName, path .. ".regions[" .. i .. "]", r, extra)
          else
            -- Other regions can still carry a texture/atlas; record minimal if present.
            local extra = {}
            if r.GetAtlas then
              local okAt, at = pcall(r.GetAtlas, r)
              if okAt and at then extra.atlas = at end
            end
            if r.GetTexture then
              local okTx, tx = pcall(r.GetTexture, r)
              if okTx and tx ~= nil then extra.texture = tostring(tx) end
            end
            if extra.atlas or extra.texture then
              logArt("Region", rootName, path .. ".regions[" .. i .. "]", r, extra)
            end
          end
        end

        if entries >= maxEntries then return end
      end
    end

    -- Children
    if obj.GetChildren then
      local children = { obj:GetChildren() }
      for i = 1, #children do
        if i > maxNodes then return end
        walk(children[i], path .. ".children[" .. i .. "]", depth + 1)
        if entries >= maxEntries then return end
      end
    end
  end

  Debug.AgentDumpLog("DUMP", "Debug.DumpFrameArt", "start_art", {
    root = rootName,
    includeHidden = includeHidden,
    maxDepth = maxDepth,
    maxNodes = maxNodes,
    maxEntries = maxEntries,
  })

  walk(rootFrame, rootName, 0)

  Debug.AgentDumpLog("DUMP", "Debug.DumpFrameArt", "end_art", { root = rootName, entries = entries })

  if not silent then
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Dump]|r UI art dump: root=" .. tostring(rootName) .. ", entries=" .. tostring(entries))
  end
  return entries
end

-- Reset deduplication cache (useful if you want fresh dumps)
function Debug.ResetDumpCache()
  _dumpSeenHashes = {}
  DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Dump]|r Deduplication cache cleared.")
end

-- Clear agent SavedVariables stores (agentDebugNDJSON / agentDumpNDJSON) to avoid buildup.
-- NOTE: We intentionally write a small post-clear marker log so exports can prove the clear happened.
function Debug.ClearAgentLogs(msg)
  msg = (msg or ""):lower()
  local mode = msg:match("^%s*(%S+)")
  if mode == nil or mode == "" then mode = "all" end

  local function wipeTable(t)
    if type(t) ~= "table" then return 0 end
    local n = 0
    for k in pairs(t) do
      t[k] = nil
      n = n + 1
    end
    return n
  end

  local db = rawget(_G, "WOWTR_DB")
  local g = db and db.global
  local debugT = g and g.agentDebugNDJSON
  local dumpT = g and g.agentDumpNDJSON
  local beforeDebug = (type(debugT) == "table" and #debugT) or 0
  local beforeDump = (type(dumpT) == "table" and #dumpT) or 0

  Debug.AgentLog("H7", "common/Core/Debug.lua:Debug.ClearAgentLogs", "before_clear", { mode = mode, debugN = beforeDebug, dumpN = beforeDump })

  local clearedDebug, clearedDump, clearedCache = false, false, false

  if mode == "all" or mode == "debug" then
    _G.WOWTR_DB = _G.WOWTR_DB or {}
    _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
    if type(_G.WOWTR_DB.global.agentDebugNDJSON) ~= "table" then
      _G.WOWTR_DB.global.agentDebugNDJSON = {}
    else
      wipeTable(_G.WOWTR_DB.global.agentDebugNDJSON)
    end
    clearedDebug = true
  end

  if mode == "all" or mode == "dump" then
    _G.WOWTR_DB = _G.WOWTR_DB or {}
    _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
    if type(_G.WOWTR_DB.global.agentDumpNDJSON) ~= "table" then
      _G.WOWTR_DB.global.agentDumpNDJSON = {}
    else
      wipeTable(_G.WOWTR_DB.global.agentDumpNDJSON)
    end
    clearedDump = true
  end

  if mode == "all" or mode == "cache" or mode == "dedupe" then
    _dumpSeenHashes = {}
    clearedCache = true
  end

  local afterDebug = (_G.WOWTR_DB and _G.WOWTR_DB.global and type(_G.WOWTR_DB.global.agentDebugNDJSON) == "table" and #_G.WOWTR_DB.global.agentDebugNDJSON) or 0
  local afterDump = (_G.WOWTR_DB and _G.WOWTR_DB.global and type(_G.WOWTR_DB.global.agentDumpNDJSON) == "table" and #_G.WOWTR_DB.global.agentDumpNDJSON) or 0

  -- Post-clear marker (this will add 1 line to agentDebugNDJSON, by design).
  Debug.AgentLog("H7", "common/Core/Debug.lua:Debug.ClearAgentLogs", "after_clear", {
    mode = mode,
    clearedDebug = clearedDebug,
    clearedDump = clearedDump,
    clearedCache = clearedCache,
    debugN_before = beforeDebug,
    dumpN_before = beforeDump,
    debugN_after = afterDebug,
    dumpN_after = afterDump,
  })

  local parts = {}
  if clearedDebug then parts[#parts + 1] = "debug" end
  if clearedDump then parts[#parts + 1] = "dump" end
  if clearedCache then parts[#parts + 1] = "dedupeCache" end

  DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Logs]|r Cleared: " .. table.concat(parts, ", ") .. " (note: 1 post-clear marker log is written).")
  DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Logs]|r Run |cFFFFD700/reload|r to flush SavedVariables, then export via |cFFFFD700Tools/ExportAgentDebugLog.ps1|r.")
end

-- Clear prior agent logs at addon load; they are already flushed to disk on /reload before this runs.
do
  pcall(function()
    _G.WOWTR_DB = _G.WOWTR_DB or {}
    _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
    _G.WOWTR_DB.global.agentDebugNDJSON = {}
    _G.WOWTR_DB.global.agentDumpNDJSON = {}
    -- Per-load run id to help distinguish exports (exporter may include multiple sessions otherwise).
    _G.WOWTR_DB.global.agentDebugRunId = "t" .. tostring(time and time() or 0)
  end)
end

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
  PREFIX = "|cFF00FF00",      -- Green for "WOWTR Debug:"
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
  
  local prefix = Colors.PREFIX .. "WOWTR Debug:" .. Colors.RESET
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
