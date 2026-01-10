local addonName, ns = ...

ns = ns or {}
ns.UI = ns.UI or {}
ns.UI.Translate = ns.UI.Translate or {}
local T = ns.UI.Translate

local RTL = (ns and ns.RTL) or nil

local function isRTL()
  if RTL and RTL.IsRTL then
    return RTL.IsRTL()
  end
  return (type(WoWTR_Localization) == "table" and WoWTR_Localization.lang == "AR") or false
end

-- Return true if a given TT_PS UI toggle key is enabled (e.g. "ui3").
function T.Enabled(uiKey)
  return (TT_PS and uiKey and TT_PS[uiKey] == "1") and true or false
end

-- Preferred font for UI labels that want RTL-specific font selection.
-- Mirrors existing ad-hoc usage in modules (AR -> WOWTR_Font1, else WOWTR_Font2).
function T.Font()
  if isRTL() then
    return _G.WOWTR_Font1 or _G.WOWTR_Font2
  end
  return _G.WOWTR_Font2 or _G.WOWTR_Font1
end

-- Preferred horizontal justification based on RTL.
function T.Justify(defaultJustify)
  if isRTL() then
    return "RIGHT"
  end
  return defaultJustify or "LEFT"
end

local function resolveObj(spec)
  if type(spec) == "function" then
    return spec(), nil
  end
  if type(spec) == "table" then
    local obj = spec.obj
    if type(obj) == "function" then obj = obj() end
    return obj, spec
  end
  return spec, nil
end

-- Apply ST_CheckAndReplaceTranslationTextUI over a list of objects/specs.
-- Each list entry may be:
--   - a FontString-like object
--   - a function returning the object (safer for chained globals)
--   - { obj = <object|function>, font = <font|function>, justify = "LEFT"/"RIGHT"/... }
function T.ApplyUI(list, opts)
  if type(list) ~= "table" then return end
  local sav = (opts and opts.sav)
  if sav == nil then sav = true end
  local prefix = (opts and opts.prefix) or "ui"
  local defaultFont = opts and opts.font
  local defaultJustify = opts and opts.justify

  for _, spec in ipairs(list) do
    local obj, meta = resolveObj(spec)
    if obj then
      local font = (meta and meta.font) or defaultFont
      if type(font) == "function" then font = font() end
      if _G.ST_CheckAndReplaceTranslationTextUI then
        ST_CheckAndReplaceTranslationTextUI(obj, sav, prefix, font)
      end
      local justify = (meta and meta.justify) or defaultJustify
      if justify and obj.SetJustifyH then
        pcall(obj.SetJustifyH, obj, justify)
      end
    end
  end
end

-- Apply ST_CheckAndReplaceTranslationText over a list of objects/specs.
-- Each list entry may be:
--   - a FontString-like object
--   - a function returning the object
--   - {
--       obj = <object|function>,
--       font = <font|function>,
--       onlyReverse = <bool>,
--       corr = <number|nil>,
--       justify = "LEFT"/"RIGHT"/...
--     }
function T.ApplyText(list, opts)
  if type(list) ~= "table" then return end
  local sav = (opts and opts.sav)
  if sav == nil then sav = true end
  local prefix = (opts and opts.prefix) or "ui"
  local defaultFont = opts and opts.font
  local defaultOnlyReverse = opts and opts.onlyReverse
  local defaultCorr = opts and opts.corr
  local defaultJustify = opts and opts.justify

  for _, spec in ipairs(list) do
    local obj, meta = resolveObj(spec)
    if obj then
      local font = (meta and meta.font) or defaultFont
      if type(font) == "function" then font = font() end
      local onlyReverse = (meta and meta.onlyReverse)
      if onlyReverse == nil then onlyReverse = defaultOnlyReverse end
      local corr = (meta and meta.corr)
      if corr == nil then corr = defaultCorr end
      local justify = (meta and meta.justify) or defaultJustify

      if _G.ST_CheckAndReplaceTranslationText then
        ST_CheckAndReplaceTranslationText(obj, sav, prefix, font, onlyReverse, corr, justify)
      end
    end
  end
end

return T


