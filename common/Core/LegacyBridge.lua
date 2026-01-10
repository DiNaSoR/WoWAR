-- common/Core/LegacyBridge.lua
-- Single source of truth for legacy SavedVariables <-> AceDB profile mapping.
-- This removes duplicated per-key defaulting/migration logic spread across Core.CheckVars and Config/Core.
-------------------------------------------------------------------------------------------------------

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}

WOWTR = WOWTR or {}

local LB = ns.Core.LegacyBridge or {}
ns.Core.LegacyBridge = LB
WOWTR.LegacyBridge = LB

-- Helpers
local function boolTo01(v) return v and "1" or "0" end
local function s2b(v) return v == true or v == 1 or v == "1" end

local function getAt(root, path)
  local cur = root
  for i = 1, #path do
    if type(cur) ~= "table" then return nil end
    cur = cur[path[i]]
  end
  return cur
end

local function setAt(root, path, value)
  local cur = root
  for i = 1, (#path - 1) do
    local k = path[i]
    if type(cur[k]) ~= "table" then cur[k] = {} end
    cur = cur[k]
  end
  cur[path[#path]] = value
end

local function isArabic()
  return (WoWTR_Localization and WoWTR_Localization.lang == "AR") and true or false
end

local function asValue(v)
  if type(v) == "function" then return v() end
  return v
end

-- Spec rows:
-- lt: legacy table global name (string)
-- lk: legacy key (string)
-- path: profile path under WOWTR.db.profile (array), e.g. {"quests","active"}
-- toLegacy(profileValue, profile): legacyValue
-- toProfile(legacyValue, profile): profileValue
-- defaultLegacy: value|function -> legacy default if legacy key missing
-- defaultProfile: value|function -> profile default used only as a fallback during Sync
-- cond(): boolean (optional)
LB.Spec = LB.Spec or {}

local function add(row) table.insert(LB.Spec, row) end
local function condAR() return isArabic() end

-- QTR_PS (quests + minimap icon)
add({
  lt = "QTR_PS", lk = "icon", path = { "minimap", "hide" },
  toLegacy = function(v) return boolTo01(not v) end,
  toProfile = function(v) return not s2b(v) end,
  defaultLegacy = "1", defaultProfile = false,
})
add({ lt = "QTR_PS", lk = "active", path = { "quests", "active" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "transtitle", path = { "quests", "transtitle" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "gossip", path = { "quests", "gossip" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "tracker", path = { "quests", "tracker" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "saveQS", path = { "quests", "saveQS" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "saveGS", path = { "quests", "saveGS" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "immersion", path = { "quests", "immersion" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "storyline", path = { "quests", "storyline" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "questlog", path = { "quests", "questlog" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "dialogueui", path = { "quests", "dialogueui" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "QTR_PS", lk = "ownnames", path = { "quests", "ownnames" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({ lt = "QTR_PS", lk = "en_first", path = { "quests", "en_first" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({
  lt = "QTR_PS", lk = "FontFile", path = { "quests", "FontFile" },
  toLegacy = function(v) return v end,
  toProfile = function(v) return v end,
  defaultLegacy = function()
    return (WOWTR_Fonts and WOWTR_Fonts[1]) or nil
  end,
  defaultProfile = function()
    return (WOWTR_Fonts and WOWTR_Fonts[1]) or nil
  end,
})
add({
  lt = "QTR_PS", lk = "fontsize", path = { "quests", "fontsize" },
  toLegacy = function(v) return tostring(v) end,
  toProfile = function(v) return tonumber(v) end,
  defaultLegacy = "13", defaultProfile = 13,
})

-- TT_PS (UI translation toggles + tutorial save)
add({ lt = "TT_PS", lk = "active", path = { "tooltips", "active" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "TT_PS", lk = "save", path = { "tooltips", "save" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "TT_PS", lk = "saveui", path = { "tooltips", "saveui" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
for i = 1, 8 do
  add({ lt = "TT_PS", lk = "ui" .. i, path = { "tooltips", "ui" .. i }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
end
add({ lt = "TT_PS", lk = "ui_talents", path = { "tooltips", "ui_talents" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })

-- ST_PM (tooltip translation engine)
add({ lt = "ST_PM", lk = "active", path = { "tooltips", "active" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "ST_PM", lk = "item", path = { "tooltips", "item" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "ST_PM", lk = "spell", path = { "tooltips", "spell" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "ST_PM", lk = "talent", path = { "tooltips", "talent" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "ST_PM", lk = "transtitle", path = { "tooltips", "transtitle" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({ lt = "ST_PM", lk = "showID", path = { "tooltips", "showID" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({ lt = "ST_PM", lk = "showHS", path = { "tooltips", "showHS" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({ lt = "ST_PM", lk = "saveNW", path = { "tooltips", "saveNW" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "ST_PM", lk = "sellprice", path = { "tooltips", "sellprice" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({ lt = "ST_PM", lk = "constantly", path = { "tooltips", "constantly" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({
  lt = "ST_PM", lk = "timer", path = { "tooltips", "timer" },
  toLegacy = function(v) return tostring(v) end,
  toProfile = function(v) return tonumber(v) end,
  defaultLegacy = "10", defaultProfile = 10,
})

-- BB_PM (bubbles)
add({ lt = "BB_PM", lk = "active", path = { "bubbles", "active" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "BB_PM", lk = "chat-en", path = { "bubbles", "chat_en" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({ lt = "BB_PM", lk = "chat-tr", path = { "bubbles", "chat_tr" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "BB_PM", lk = "saveNB", path = { "bubbles", "saveNB" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "BB_PM", lk = "setsize", path = { "bubbles", "setsize" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({
  lt = "BB_PM", lk = "fontsize", path = { "bubbles", "fontsize" },
  toLegacy = function(v) return tostring(v) end,
  toProfile = function(v) return tonumber(v) end,
  defaultLegacy = "13", defaultProfile = 13,
})
add({
  lt = "BB_PM", lk = "sex", path = { "bubbles", "sex" },
  toLegacy = function(v) return tostring(v) end,
  toProfile = function(v) return tonumber(v) end,
  defaultLegacy = "4", defaultProfile = 4,
})
add({ lt = "BB_PM", lk = "dungeon", path = { "bubbles", "dungeon" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({
  lt = "BB_PM", lk = "timeDisplay", path = { "bubbles", "timeDisplay" },
  toLegacy = function(v) return tostring(v) end,
  toProfile = function(v) return tonumber(v) end,
  defaultLegacy = "5", defaultProfile = 5,
})
for i = 1, 5 do
  add({
    lt = "BB_PM", lk = "dungeonF" .. i, path = { "bubbles", "dungeonF" .. i },
    toLegacy = function(v) return tonumber(v) end,
    toProfile = function(v) return tonumber(v) end,
    defaultLegacy = 270, defaultProfile = 270,
  })
end

-- MF_PM (movies/subtitles)
add({ lt = "MF_PM", lk = "active", path = { "movies", "active" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "MF_PM", lk = "intro", path = { "movies", "intro" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "MF_PM", lk = "movie", path = { "movies", "movie" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "MF_PM", lk = "cinematic", path = { "movies", "cinematic" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "MF_PM", lk = "save", path = { "movies", "save" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })

-- BT_PM (books)
add({ lt = "BT_PM", lk = "active", path = { "books", "active" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "BT_PM", lk = "title", path = { "books", "title" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "BT_PM", lk = "showID", path = { "books", "showID" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })
add({ lt = "BT_PM", lk = "setsize", path = { "books", "setsize" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false })
add({
  lt = "BT_PM", lk = "fontsize", path = { "books", "fontsize" },
  toLegacy = function(v) return tonumber(v) end,
  toProfile = function(v) return tonumber(v) end,
  defaultLegacy = 15, defaultProfile = 15,
})
add({ lt = "BT_PM", lk = "saveNW", path = { "books", "saveNW" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true })

-- CH_PM (AR chat) — only present in AR locale
add({ lt = "CH_PM", lk = "active", path = { "chatAR", "active" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "1", defaultProfile = true, cond = condAR })
add({ lt = "CH_PM", lk = "setsize", path = { "chatAR", "setsize" }, toLegacy = boolTo01, toProfile = s2b, defaultLegacy = "0", defaultProfile = false, cond = condAR })
add({
  lt = "CH_PM", lk = "fontsize", path = { "chatAR", "fontsize" },
  toLegacy = function(v) return tostring(v) end,
  toProfile = function(v) return tonumber(v) end,
  defaultLegacy = "13", defaultProfile = 13,
  cond = condAR,
})

function LB.EnsureLegacyTables()
  for _, row in ipairs(LB.Spec) do
    if (not row.cond) or row.cond() then
      if row.lt and type(_G[row.lt]) ~= "table" then
        _G[row.lt] = {}
      end
    end
  end
end

function LB.EnsureLegacyDefaults()
  LB.EnsureLegacyTables()
  for _, row in ipairs(LB.Spec) do
    if (not row.cond) or row.cond() then
      local t = _G[row.lt]
      if t and t[row.lk] == nil then
        local dv = asValue(row.defaultLegacy)
        if dv ~= nil then
          t[row.lk] = dv
        end
      end
    end
  end
end

function LB.SyncLegacyFromProfile(profile)
  if type(profile) ~= "table" then return end
  LB.EnsureLegacyTables()
  for _, row in ipairs(LB.Spec) do
    if row.path and ((not row.cond) or row.cond()) then
      local t = _G[row.lt]
      if t then
        local pv = getAt(profile, row.path)
        if pv == nil then
          pv = asValue(row.defaultProfile)
        end
        local lv = row.toLegacy and row.toLegacy(pv, profile) or pv
        if lv ~= nil then
          t[row.lk] = lv
        end
      end
    end
  end
end

function LB.MigrateLegacyToProfile(profile)
  if type(profile) ~= "table" then return end
  for _, row in ipairs(LB.Spec) do
    if row.path and ((not row.cond) or row.cond()) then
      local t = _G[row.lt]
      local lv = t and t[row.lk] or nil
      if lv ~= nil then
        local pv = row.toProfile and row.toProfile(lv, profile) or lv
        if pv ~= nil then
          setAt(profile, row.path, pv)
        end
      end
    end
  end
end


