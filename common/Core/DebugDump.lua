-- DebugDump.lua
-- Smart UI dump tools (strings + art/layout).

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

Core.DebugDump = Core.DebugDump or {}
local D = Core.DebugDump

local Agent = Core.DebugAgentLog or {}

-- Session-persistent deduplication set (survives multiple dumps until /reload)
local _dumpSeenHashes = {}

local function _isNoiseText(text)
  if not text or text == "" then return true end
  if text:match("^%s*$") then return true end
  if text:match("^%-?[%d,%.]+$") then return true end
  if text:match("^%(%d+%)$") then return true end
  if string.len(text) <= 2 then
    if text:match("^[%a]$") then return true end
    if not text:match("[%a]") then return true end
  end
  if text:match("UI%-GoldIcon") or text:match("UI%-SilverIcon") or text:match("UI%-CopperIcon") then return true end
  if text:match("^|c[%x]+|r$") then return true end
  if text:match("^%d+/%d+$") then return true end
  if text:match("^%s*%d+%s*/%s*%d+%s*$") then return true end
  if text:match("^%d+/%d+%s*$") then return true end
  if text:match("^[sc]%-[%w%+]+$") then return true end
  if text:match("^F%d+$") then return true end
  if text:match("^Mouse Button") or text:match("^Middle Mouse$") or text:match("^Num Pad") then return true end
  return false
end

local function _categorizeText(text, kind, path)
  if not text then return "unknown" end
  local lower = text:lower()
  if kind == "Button" then return "button" end
  if path then
    if path:match("Button") then return "button" end
    if path:match("Label") then return "label" end
    if path:match("Title") then return "title" end
    if path:match("Description") then return "description" end
    if path:match("Header") then return "header" end
    if path:match("Tab") then return "tab" end
    if path:match("Tooltip") then return "tooltip" end
  end
  if string.len(text) > 100 then return "description" end
  if lower:match("^click") or lower:match("^press") or lower:match("^open") then return "button" end
  if text:match(":$") then return "label" end
  return "text"
end

local function _suggestKey(text, category, rootName)
  if not text then return "" end
  local clean = text
    :gsub("|c%x%x%x%x%x%x%x%x", "")
    :gsub("|r", "")
    :gsub("|T.-|t", "")
    :gsub("|A.-|a", "")
    :gsub("|H.-|h(.-)|h", "%1")
    :gsub("[^%w%s]", "")
    :gsub("%s+", "_")
    :gsub("^_+", "")
    :gsub("_+$", "")
  if string.len(clean) > 40 then
    clean = string.sub(clean, 1, 40)
  end
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

function D.DumpVisibleUI(opts)
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
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
      DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WoWAR Dump]|r EnumerateFrames() not available in this client.")
    end
    return 0
  end

  local strataRank = {
    BACKGROUND = 1, LOW = 2, MEDIUM = 3, HIGH = 4,
    DIALOG = 5, FULLSCREEN = 6, FULLSCREEN_DIALOG = 7, TOOLTIP = 8,
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

  local roots, rootSet, rootNameSet = {}, {}, {}
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

  if Agent.AgentDumpLog then
    Agent.AgentDumpLog("DUMP", "DebugDump.DumpVisibleUI", "start_visible", {
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
  end

  local totalStrings, totalArt = 0, 0
  for i = 1, #roots do
    local r = roots[i]
    totalStrings = totalStrings + D.DumpFrameStrings(r.frame, {
      includeHidden = includeHidden,
      includeAll = includeAll,
      skipNoise = skipNoise,
      dedupe = dedupe,
      maxNodes = maxNodesPerRoot,
      maxDepth = maxDepth,
      silent = true,
    })

    if includeArt then
      totalArt = totalArt + D.DumpFrameArt(r.frame, {
        includeHidden = includeHidden,
        maxNodes = maxNodesPerRoot,
        maxDepth = maxDepth,
        maxEntries = maxArtEntries,
        silent = true,
      })
    end
  end

  if Agent.AgentDumpLog then
    Agent.AgentDumpLog("DUMP", "DebugDump.DumpVisibleUI", "end_visible", { roots = #roots, strings = totalStrings, artEntries = totalArt })
  end

  if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    local msg = "|cFF00FF00[WoWAR Dump]|r Visible UI dump: roots=" .. tostring(#roots) .. ", strings=" .. tostring(totalStrings)
    if includeArt then msg = msg .. ", art=" .. tostring(totalArt) end
    msg = msg .. " (export after /reload)"
    DEFAULT_CHAT_FRAME:AddMessage(msg)
  end
  return totalStrings
end

function D.DumpFrameStrings(rootFrame, opts)
  opts = opts or {}
  local silent = opts.silent and true or false
  local includeHidden = opts.includeHidden and true or false
  local includeAll = opts.includeAll and true or false
  local skipNoise = (opts.skipNoise == nil) and true or opts.skipNoise
  local dedupe = (opts.dedupe == nil) and true or opts.dedupe
  local maxNodes = (type(opts.maxNodes) == "number" and opts.maxNodes) or 10000
  local maxDepth = (type(opts.maxDepth) == "number" and opts.maxDepth) or 15
  local maxTextLen = (type(opts.maxTextLen) == "number" and opts.maxTextLen) or 500

  if not rootFrame then
    if Agent.AgentDumpLog then
      Agent.AgentDumpLog("DUMP", "DebugDump.DumpFrameStrings", "error", { reason = "rootFrame=nil" })
    end
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
      DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WoWAR Dump]|r Error: Frame not found or not loaded yet.")
    end
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

  local function logString(obj, path, text, kind)
    local t = normalizeText(text)
    if not t then return end

    local objName = safeName(obj)
    if objName and (objName:find("HotKey") or objName:find("ButtonCount") or objName:find("BackpackButtonCount") or objName:find("Count$")) then
      if skipNoise then
        skippedNoise = skippedNoise + 1
        return
      end
    end

    if skipNoise and _isNoiseText(t) then
      skippedNoise = skippedNoise + 1
      return
    end

    local nbsp = rawget(_G, "NONBREAKINGSPACE")
    if (not includeAll) and type(nbsp) == "string" and nbsp ~= "" and t:find(nbsp, 1, true) then
      skippedHasTranslation = skippedHasTranslation + 1
      return
    end

    if (not includeAll) and containsArabic(t) then
      skippedHasTranslation = skippedHasTranslation + 1
      return
    end

    local h = computeHash(t)
    local hasTrans = hasTranslation(h)
    if not includeAll and hasTrans then
      skippedHasTranslation = skippedHasTranslation + 1
      return
    end

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

    if Agent.AgentDumpLog then
      Agent.AgentDumpLog("DUMP", "DebugDump.DumpFrameStrings", "ui_string", {
        root = rootName,
        kind = kind,
        category = category,
        path = path,
        name = safeName(obj),
        text = t,
        hash = h,
        hasTranslation = hasTrans,
        suggestedKey = suggestedKey,
      })
    end
    count = count + 1
  end

  local function walk(obj, path, depth)
    if not obj or visited[obj] then return end
    visited[obj] = true
    if count >= maxNodes or depth > maxDepth then return end
    if not safeVisible(obj) then return end

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

    if obj.GetText then
      local okText, txt = pcall(obj.GetText, obj)
      if okText then
        local okType, ot = pcall(obj.GetObjectType, obj)
        logString(obj, path, txt, okType and ot or "Object")
      end
    end

    if obj.GetChildren then
      local children = { obj:GetChildren() }
      for i = 1, #children do
        walk(children[i], path .. ".children[" .. i .. "]", depth + 1)
        if count >= maxNodes then return end
      end
    end
  end

  if Agent.AgentDumpLog then
    Agent.AgentDumpLog("DUMP", "DebugDump.DumpFrameStrings", "start", {
      root = rootName, includeAll = includeAll, skipNoise = skipNoise, dedupe = dedupe,
    })
  end

  walk(rootFrame, rootName, 0)

  if Agent.AgentDumpLog then
    Agent.AgentDumpLog("DUMP", "DebugDump.DumpFrameStrings", "end", {
      root = rootName,
      strings = count,
      skippedNoise = skippedNoise,
      skippedDupe = skippedDupe,
      skippedHasTranslation = skippedHasTranslation,
    })
  end

  if not silent and DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    local msg = string.format(
      "|cFF00FF00[WoWAR Dump]|r %s: |cFFFFD700%d|r strings found (|cFF808080%d noise, %d dupes, %d translated skipped|r)",
      rootName, count, skippedNoise, skippedDupe, skippedHasTranslation
    )
    DEFAULT_CHAT_FRAME:AddMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Dump]|r Type |cFFFFD700/reload|r then run |cFFFFD700Tools/ExportAgentDebugLog.ps1|r to export.")
  end
  return count
end

function D.DumpFrameArt(rootFrame, opts)
  opts = opts or {}
  local includeHidden = opts.includeHidden and true or false
  local maxDepth = (type(opts.maxDepth) == "number" and opts.maxDepth) or 12
  local maxNodes = (type(opts.maxNodes) == "number" and opts.maxNodes) or 2000
  local maxEntries = (type(opts.maxEntries) == "number" and opts.maxEntries) or 6000
  local silent = opts.silent and true or false

  if not rootFrame then return 0 end

  local visited = {}
  local entries = 0
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

  local function resolveRelTo(relTo, currentObj)
    if not relTo then return "" end
    local name = safeName(relTo)
    if name then return name end
    local pathRef = objToPath[relTo]
    if pathRef then return pathRef end
    if currentObj and currentObj.GetParent then
      local okP, par = pcall(currentObj.GetParent, currentObj)
      if okP and par == relTo then return "$parent" end
    end
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
        parts[#parts + 1] = tostring(p) .. "," .. tostring(relRef) .. "," .. tostring(relPoint or "") .. "," .. tostring(x or 0) .. "," .. tostring(y or 0)
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
      tostring(e or ""), tostring(f or ""), tostring(g or ""), tostring(h or ""),
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
    if Agent.AgentDumpLog then
      Agent.AgentDumpLog("DUMP", "DebugDump.DumpFrameArt", "ui_art", extra)
    end
    entries = entries + 1
  end

  local rootName = safeName(rootFrame) or "root"
  objToPath[rootFrame] = rootName

  local function walk(obj, path, depth)
    if not obj or visited[obj] then return end
    visited[obj] = true
    objToPath[obj] = path
    if entries >= maxEntries then return end
    if depth > maxDepth then return end
    if not safeVisible(obj) then return end

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

    if obj.GetRegions then
      local regions = { obj:GetRegions() }
      for i = 1, #regions do
        local r = regions[i]
        if r and not visited[r] and safeVisible(r) then
          visited[r] = true
          local regionPath = path .. ".regions[" .. i .. "]"
          objToPath[r] = regionPath
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
            logArt("Texture", rootName, regionPath, r, extra)
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
            logArt("FontString", rootName, regionPath, r, extra)
          else
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
              logArt("Region", rootName, regionPath, r, extra)
            end
          end
        end
        if entries >= maxEntries then return end
      end
    end

    if obj.GetChildren then
      local children = { obj:GetChildren() }
      for i = 1, #children do
        if i > maxNodes then return end
        walk(children[i], path .. ".children[" .. i .. "]", depth + 1)
        if entries >= maxEntries then return end
      end
    end
  end

  if Agent.AgentDumpLog then
    Agent.AgentDumpLog("DUMP", "DebugDump.DumpFrameArt", "start_art", {
      root = rootName,
      includeHidden = includeHidden,
      maxDepth = maxDepth,
      maxNodes = maxNodes,
      maxEntries = maxEntries,
    })
  end

  walk(rootFrame, rootName, 0)

  if Agent.AgentDumpLog then
    Agent.AgentDumpLog("DUMP", "DebugDump.DumpFrameArt", "end_art", { root = rootName, entries = entries })
  end

  if not silent and DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Dump]|r UI art dump: root=" .. tostring(rootName) .. ", entries=" .. tostring(entries))
  end
  return entries
end

function D.ClearSeenCache()
  _dumpSeenHashes = {}
end

function D.ResetDumpCache(silent)
  D.ClearSeenCache()
  if not silent and DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Dump]|r Deduplication cache cleared.")
  end
end

return D
