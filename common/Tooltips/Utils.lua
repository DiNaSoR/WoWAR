local addonName, ns = ...

ns = ns or {}
ns.Tooltips = ns.Tooltips or {}
local Tooltips = ns.Tooltips
local S = (ns.Tooltips and ns.Tooltips.State) or {}

ns.Tooltips.Utils = ns.Tooltips.Utils or {}
local U = ns.Tooltips.Utils

-- Cache for original WoW font (captured once at initialization)
local cachedOriginalFont, cachedOriginalSize, cachedOriginalFlags = nil, nil, nil

-- Initialize original font cache early (before HookTooltipFonts runs)
function U.InitializeOriginalFontCache()
  if cachedOriginalFont then return end -- Already initialized
  
  local defaultFont, defaultSize, defaultFlags
  
  -- Try to get font from GameTooltipText FontObject before it's modified
  -- This should be called before HookTooltipFonts runs
  if _G.GameTooltipText and _G.GameTooltipText.GetFont then
    local ok, font, size, flags = pcall(_G.GameTooltipText.GetFont, _G.GameTooltipText)
    if ok and font and size then
      local fontStr = tostring(font)
      -- Check if this font hasn't been modified (not WOWTR_Font2 and not WoWAR path)
      if font ~= _G.WOWTR_Font2 and not string.find(fontStr, "WoWAR") and not string.find(fontStr, "WOWTR") then
        defaultFont, defaultSize, defaultFlags = font, size, flags or ""
      end
    end
  end
  
  -- If we didn't get a good font, try GameTooltipTextSmall
  if not defaultFont and _G.GameTooltipTextSmall and _G.GameTooltipTextSmall.GetFont then
    local ok, font, size, flags = pcall(_G.GameTooltipTextSmall.GetFont, _G.GameTooltipTextSmall)
    if ok and font and size then
      local fontStr = tostring(font)
      if font ~= _G.WOWTR_Font2 and not string.find(fontStr, "WoWAR") and not string.find(fontStr, "WOWTR") then
        defaultFont, defaultSize, defaultFlags = font, size, flags or ""
      end
    end
  end
  
  -- Fallback to common WoW default fonts if still not found
  -- These are the standard WoW fonts used for tooltips
  if not defaultFont then
    -- Try common WoW default fonts in order of preference
    local wowFonts = {
      "Fonts\\FRIZQT__.TTF",  -- Friz Quadrata (most common WoW font)
      "Fonts\\ARIALN.TTF",   -- Arial Narrow
      "Fonts\\MORPHEUS.TTF", -- Morpheus
    }
    -- Use the first available font, or fallback to FRIZQT__
    defaultFont = wowFonts[1]
    defaultSize = 12
    defaultFlags = ""
  end
  
  -- Cache the result for future use
  cachedOriginalFont = defaultFont
  cachedOriginalSize = defaultSize
  cachedOriginalFlags = defaultFlags
end

-- Get original WoW font (before any modifications)
-- Returns the default WoW tooltip font, size, and flags
function U.GetOriginalWoWFont()
  -- Initialize cache if not already done
  if not cachedOriginalFont then
    U.InitializeOriginalFontCache()
  end
  
  return cachedOriginalFont, cachedOriginalSize, cachedOriginalFlags
end

-- Make GetOriginalWoWFont globally accessible for ApplyTooltipFonts
_G.ST_GetOriginalWoWFont = function()
  return U.GetOriginalWoWFont()
end

-- Ignore settings used when saving untranslated lines from tooltips
U.ignoreSettings = {
  words = {
    "Seller: |cffffffff",
    "Sellers: |cffffffff",
    "Equipment Sets: |cFFFFFFFF",
    "|cff00ff00<Made by ",
    "Leader: |cffffffff",
    "Realm: |cffffffff",
    "Waiting on: |cff",
    "Reagents: |n",
    "  |A:raceicon128",
    "Achievement in progress by",
    "Achievement earned by",
    "You completed this on ",
    "AllTheThings",
    "|cffb4b4ffATT|r",
    "|cff0070dd",
    "|Hachievement:",
    "  |T",
    "   |c"
  },
  pattern = "[Яа-яĄ-Źą-źŻ-żЀ-ӿΑ-Ωα-ω]"
}

-- Text preprocessing and application helpers extracted from WoW_Tooltips.lua

-- Remove color codes, numbers and normalize text before hashing
function ST_UsunZbedneZnaki(txt)
  if (not txt) then return "" end
  local text = string.gsub(txt, "|cFFFFFFFF", "")
  text = string.gsub(text, "|r", "")
  text = string.gsub(text, "\r", "")
  text = string.gsub(text, "\n", "")
  if _G.WOWTR_player_name then
    text = string.gsub(text, '%f[%a]' .. _G.WOWTR_player_name .. '%f[%A]', "$N")
  end
  text = string.gsub(text, "(%d),(%d)", "%1%2")
  text = string.gsub(text, "0", "")
  text = string.gsub(text, "1", "")
  text = string.gsub(text, "2", "")
  text = string.gsub(text, "3", "")
  text = string.gsub(text, "4", "")
  text = string.gsub(text, "5", "")
  text = string.gsub(text, "6", "")
  text = string.gsub(text, "7", "")
  text = string.gsub(text, "8", "")
  text = string.gsub(text, "9", "")
  return text
end

function ST_PrzedZapisem(txt)
  local text = string.gsub(txt or "", "(%d),(%d)", "%1%2")  -- Remove commas from numbers (1,000 → 1000)
  text = string.gsub(text, "\r", "")
  
  -- Replace player name with $N placeholder
  if _G.WOWTR_player_name then
    text = string.gsub(text, '%f[%a]' .. _G.WOWTR_player_name .. '%f[%A]', "$N")
  end
  
  -- Convert numeric values to {1}, {2}, {3} placeholders for easier translation
  -- This makes saved untranslated text ready for translation with dynamic values preserved.
  -- Even small numbers (like "3 sec" or "2 targets") are converted because they could be
  -- affected by talents/modifiers. Translator can hard-code values that are truly static.
  local placeholderIndex = 0
  text = string.gsub(text, "(%-?%d+%.?%d*)", function(num)
    placeholderIndex = placeholderIndex + 1
    return "{" .. placeholderIndex .. "}"
  end)
  
  return text
end

function ST_RenkKoduSil(txt)
  if (not txt) then return "" end
  local text = string.gsub(txt, "|r", "")
  text = string.gsub(text, "Dragon Isles ", "")
  text = string.gsub(text, " Specializations", "")
  text = string.gsub(text, "Classic ", "")
  text = string.gsub(text, "|cffffd100", "")
  text = string.gsub(text, "|cff0070dd", "")
  text = string.gsub(text, "|cffffffff", "")
  text = string.gsub(text, "|cff1eff00", "")
  text = string.gsub(text, "|cffa335ee", "")
  text = string.gsub(text, "|cffffd200", "")
  return text
end

function OkreslKodKoloru(k1, k2, k3)
  local kol1 = ('%.0f'):format(k1)
  local kol2 = ('%.0f'):format(k2)
  local kol3 = ('%.0f'):format(k3)
  local c_out = 'c?'
  if (kol1 == "0" and kol2 == "0" and kol3 == "0") then
    c_out = 'c1'
  elseif (kol1 == "0" and kol2 == "0" and kol3 == "1") then
    c_out = 'c2'
  elseif (kol1 == "0" and kol2 == "1" and kol3 == "0") then
    c_out = 'c3'
  elseif (kol1 == "0" and kol2 == "1" and kol3 == "1") then
    c_out = 'c4'
  elseif (kol1 == "1" and kol2 == "0" and kol3 == "0") then
    c_out = 'c5'
  elseif (kol1 == "1" and kol2 == "0" and kol3 == "1") then
    c_out = 'c6'
  elseif (kol1 == "1" and kol2 == "1" and kol3 == "0") then
    c_out = 'c7'
  else
    c_out = 'c8'
  end
  return c_out
end

-- Forwarders to ns.Text wrappers; keep global names for back-compat usage elsewhere
local function ExpandUnit(text, isTooltip, obj, font, offset, noWrap)
  if _G.QTR_ExpandUnitInfo then
    return QTR_ExpandUnitInfo(text, isTooltip, obj, font, offset, noWrap)
  end
  return text
end

local function ReverseIfAR(text)
  if _G.QTR_ReverseIfAR then
    return QTR_ReverseIfAR(text)
  end
  return text
end

-- Translate prepare: Extract dynamic values from original text and substitute into translation placeholders
-- This handles Blizzard's dynamic placeholders like {1}, {2}, {3} in tooltip translations.
-- The translation contains placeholders like "{1}% damage for {2} seconds" and the original
-- contains actual values like "20% damage for 8 seconds". We extract numbers from the original
-- and substitute them into the translation.
--
-- IMPORTANT: For Arabic RTL, substituted values are wrapped with \003...\004 markers so that
-- HandleWoWSpecialCodes can protect them from reversal. Without this, "20" would become "02".
function ST_TranslatePrepare(origin, tlumacz)
  if not origin or not tlumacz then return tlumacz or "" end
  
  -- Check if translation contains any numeric placeholders {1}, {2}, etc.
  if not string.find(tlumacz, "{%d+}") then
    return tlumacz
  end
  
  -- Extract all numeric values from the original text (supports decimals, negatives, formatted numbers)
  -- Pattern: requires at least one digit, optionally with commas (1,000), decimals (.5), or negative sign
  -- The pattern uses %d to ensure we don't match lone commas or other non-numeric characters
  local numbers = {}
  for num in string.gmatch(origin, "%-?%d[%d,]*%.?%d*") do
    -- Store the number as-is (preserving original formatting)
    -- Filter out any matches that are just punctuation (shouldn't happen with new pattern, but be safe)
    if num ~= "" and num:match("%d") then
      numbers[#numbers + 1] = num
    end
  end
  
  -- If no numbers found in original, return translation unchanged
  if #numbers == 0 then
    return tlumacz
  end
  
  -- If we're in RTL (Arabic), mark substituted values so the text pipeline can protect them from reversal.
  -- Use multiple fallbacks for RTL detection in case ns.RTL isn't loaded yet
  local isRTL = false
  if ns and ns.RTL and ns.RTL.IsRTL then
    isRTL = ns.RTL.IsRTL()
  elseif _G.WoWTR_Localization and _G.WoWTR_Localization.lang == 'AR' then
    isRTL = true
  end
  
  -- Substitute {1}, {2}, {3}, etc. with extracted values
  local result = tlumacz
  for i, val in ipairs(numbers) do
    -- Use plain string replacement to avoid pattern interpretation issues
    local placeholder = "{" .. i .. "}"
    -- For Arabic, wrap the value with \003...\004 markers so HandleWoWSpecialCodes
    -- can protect it from RTL reversal (otherwise "20" becomes "02")
    local substitution = isRTL and ("\003" .. val .. "\004") or val
    local startPos = 1
    while true do
      local foundPos = string.find(result, placeholder, startPos, true)
      if not foundPos then break end
      result = string.sub(result, 1, foundPos - 1) .. substitution .. string.sub(result, foundPos + #placeholder)
      startPos = foundPos + #substitution
    end
  end
  
  return result
end

-- Apply translation to a FontString-like object; mirrors original signature
function ST_CheckAndReplaceTranslationText(obj, sav, prefix, font1, onlyReverse, ST_corr, justifyAlign)
  if not (obj and obj.GetText) then return end
  local txt = obj:GetText()
  if not txt or string.find(txt, NONBREAKINGSPACE) ~= nil then return end

  -- Capture original font before checking for translation
  local originalFont, originalSize, originalFlags
  if obj.GetFont then
    originalFont, originalSize, originalFlags = obj:GetFont()
  end

  local hash = StringHash(ST_UsunZbedneZnaki(txt))
  local hs = rawget(_G, "ST_TooltipsHS")
  local tr = hs and hs[hash]
  if tr then
    local processed
    if onlyReverse then
      processed = ReverseIfAR(tr) .. NONBREAKINGSPACE
    else
      processed = ExpandUnit(ST_TranslatePrepare(txt, tr), true, obj, font1 or _G.WOWTR_Font2, ST_corr) .. NONBREAKINGSPACE
    end
    obj:SetText(processed)
    if obj.SetFont and _G.WOWTR_Font2 then
      local _, size, flags = obj:GetFont()
      obj:SetFont(font1 or _G.WOWTR_Font2, size or 12, flags)
    end
    if justifyAlign and obj.SetJustifyH then
      obj:SetJustifyH(justifyAlign)
    end
  else
    -- Restore original font when translation is missing
    if obj.SetFont and originalFont and originalSize then
      -- Check if captured font is WOWTR_Font2 (translation font), if so restore to original WoW font
      local restoreFont, restoreSize, restoreFlags = originalFont, originalSize, originalFlags
      if originalFont == _G.WOWTR_Font2 or (type(originalFont) == "string" and (string.find(originalFont, "WoWAR") or string.find(originalFont, "WOWTR"))) then
        restoreFont, restoreSize, restoreFlags = U.GetOriginalWoWFont()
      end
      
      -- Check current font before restoration
      local currentFont, currentSize, currentFlags = obj:GetFont()
      obj:SetFont(restoreFont, restoreSize, restoreFlags)
      -- Debug: Log font restoration when no translation found with detailed frame info
      if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
        local frameName = obj.GetName and obj:GetName() or "unknown"
        local afterFont, afterSize, afterFlags = obj:GetFont()
        local setSuccess = (afterFont == restoreFont) and (afterSize == restoreSize) and (afterFlags == restoreFlags)
        local fontChanged = (currentFont ~= restoreFont) or (currentSize ~= restoreSize) or (currentFlags ~= restoreFlags)
        WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
          "[Font Restored] ST_CheckAndReplaceTranslationText: No translation found",
          "| Frame:", frameName,
          "| Before Font:", currentFont or "nil",
          "| Before Size:", currentSize or "nil",
          "| Before Flags:", currentFlags or "nil",
          "| Restored Font:", restoreFont or "nil",
          "| Restored Size:", restoreSize or "nil",
          "| Restored Flags:", restoreFlags or "nil",
          "| After Font:", afterFont or "nil",
          "| After Size:", afterSize or "nil",
          "| After Flags:", afterFlags or "nil",
          "| SetFont Success:", setSuccess and "YES" or "NO",
          "| Text:", string.sub(txt or "", 1, 50) .. (string.len(txt or "") > 50 and "..." or ""))
      end
    end
    if sav and _G.ST_PM and _G.ST_PM["saveNW"] == "1" then
      _G.ST_PH = _G.ST_PH or {}
      _G.ST_PH[hash] = (prefix or "") .. "@" .. ST_PrzedZapisem(txt)
    end
  end
end

function ST_CheckAndReplaceTranslationTextUI(obj, sav, prefix, font1)
  if not (obj and obj.GetText) then return end
  local txt = obj:GetText()
  if not txt or string.find(txt, NONBREAKINGSPACE) ~= nil then return end
  
  -- Capture original font before checking for translation
  local originalFont, originalSize, originalFlags
  if obj.GetFont then
    originalFont, originalSize, originalFlags = obj:GetFont()
  end
  
  local hash = StringHash(ST_UsunZbedneZnaki(txt))
  local hs = rawget(_G, "ST_TooltipsHS")
  local tr = hs and hs[hash]
  if tr then
    obj:SetText(ReverseIfAR(ST_TranslatePrepare(txt, tr)) .. NONBREAKINGSPACE)
    if obj.SetFont and _G.WOWTR_Font2 then
      local _, size, flags = obj:GetFont()
      obj:SetFont(font1 or _G.WOWTR_Font2, size or 12, flags)
    end
  else
    -- Restore original font when translation is missing
    if obj.SetFont and originalFont and originalSize then
      -- Check if captured font is WOWTR_Font2 (translation font), if so restore to original WoW font
      local restoreFont, restoreSize, restoreFlags = originalFont, originalSize, originalFlags
      if originalFont == _G.WOWTR_Font2 or (type(originalFont) == "string" and (string.find(originalFont, "WoWAR") or string.find(originalFont, "WOWTR"))) then
        restoreFont, restoreSize, restoreFlags = U.GetOriginalWoWFont()
      end
      
      -- Check current font before restoration
      local currentFont, currentSize, currentFlags = obj:GetFont()
      obj:SetFont(restoreFont, restoreSize, restoreFlags)
      -- Debug: Log font restoration when no translation found with detailed frame info
      if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
        local frameName = obj.GetName and obj:GetName() or "unknown"
        local afterFont, afterSize, afterFlags = obj:GetFont()
        local setSuccess = (afterFont == restoreFont) and (afterSize == restoreSize) and (afterFlags == restoreFlags)
        local fontChanged = (currentFont ~= restoreFont) or (currentSize ~= restoreSize) or (currentFlags ~= restoreFlags)
        WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
          "[Font Restored] ST_CheckAndReplaceTranslationTextUI: No translation found",
          "| Frame:", frameName,
          "| Before Font:", currentFont or "nil",
          "| Before Size:", currentSize or "nil",
          "| Before Flags:", currentFlags or "nil",
          "| Restored Font:", restoreFont or "nil",
          "| Restored Size:", restoreSize or "nil",
          "| Restored Flags:", restoreFlags or "nil",
          "| After Font:", afterFont or "nil",
          "| After Size:", afterSize or "nil",
          "| After Flags:", afterFlags or "nil",
          "| SetFont Success:", setSuccess and "YES" or "NO",
          "| Text:", string.sub(txt or "", 1, 50) .. (string.len(txt or "") > 50 and "..." or ""))
      end
    end
    if sav and _G.TT_PS and _G.TT_PS["saveui"] == "1" then
      _G.ST_PH = _G.ST_PH or {}
      _G.ST_PH[hash] = (prefix or "") .. "@" .. ST_PrzedZapisem(txt)
    end
  end
end

-- Convenience wrapper retained for modules that call it directly
function ST_SetText(txt)
  local hash = StringHash(ST_UsunZbedneZnaki(txt or ""))
  local hs = rawget(_G, "ST_TooltipsHS")
  local tr = hs and hs[hash]
  if tr then
    return ST_TranslatePrepare(txt, tr)
  end
  return txt
end

-- Initialize font cache early (try immediately, and again after a delay if needed)
if _G.GameTooltipText then
  -- Font objects exist, initialize immediately
  U.InitializeOriginalFontCache()
else
  -- Font objects don't exist yet, try after a short delay
  if C_Timer then
    C_Timer.After(0.1, function()
      U.InitializeOriginalFontCache()
    end)
  end
end

return Tooltips


