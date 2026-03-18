-- Text.lua
-- Shared text processing helpers (special codes, expansion, RTL-aware shaping)

local addonName, ns = ...
ns = ns or {}
ns.Text = ns.Text or {}
local Text = ns.Text

-- In Arabic RTL mode we reverse the full string (AS_UTF8reverse / AS_ReverseAndPrepareLineText*).
-- Because of that, intuitive authoring like `{cFFFFD200}TEXT{r}` will often color the wrong
-- visual segment after reversal. The correct RTL-safe authoring is `{r}TEXT{cFFFFD200}`.
--
-- To keep locale strings readable, we automatically rewrite only the LTR-style spans:
--   `{cAARRGGBB}...{r}` -> `{r}...{cAARRGGBB}`
-- and we DO NOT touch spans already written in RTL-safe form.
local function FixCurlyColorSpansForRTL(msg)
  if type(msg) ~= "string" or msg == "" then return msg end
  -- Only rewrite the LTR-style pattern {cHEX}...{r}. Non-greedy match to stop at nearest {r}.
  return (msg:gsub("(%{c%x%x%x%x%x%x%x%x%})(.-)(%{r%})", function(cTag, inner)
    return "{r}" .. inner .. cTag
  end))
end

local KNOWN_SIMPLE_HTML_TAGS = {
  HTML = true, BODY = true, P = true, H1 = true, H2 = true, H3 = true,
  IMG = true, HR = true, BR = true,
}

local function normalizeHtmlTagToken(token)
  if type(token) ~= "string" or token == "" then return nil end

  local function isKnownHtmlTag(candidate)
    if type(candidate) ~= "string" or candidate == "" then return false end
    local tagName = candidate:match("^<%s*/?%s*([%a%d]+)")
    if not tagName then return false end
    return KNOWN_SIMPLE_HTML_TAGS[string.upper(tagName)] == true
  end

  if isKnownHtmlTag(token) then
    return token
  end

  if token:sub(1, 1) == ">" and token:sub(-1) == "<" then
    local reversed = string.reverse(token)
    if isKnownHtmlTag(reversed) then
      return reversed
    end
  end

  return nil
end

-- Handle special WoW codes by replacing them with placeholders, so the text can be reversed/shaped safely.
function Text.HandleWoWSpecialCodes(msg)
  local specialCodes = {}
  local index = 1
  local prefix = ""

  msg = msg:gsub("^(UE_COLOR:)", function(ueColor)
    prefix = ueColor
    return ""
  end)

  msg = msg:gsub("(|c%x%x%x%x%x%x%x%x)(.-)(|r)", function(colorStart, text, colorEnd)
    specialCodes[index] = colorStart
    local startPlaceholder = "\001" .. index .. "\002"
    index = index + 1
    specialCodes[index] = colorEnd
    local endPlaceholder = "\001" .. index .. "\002"
    index = index + 1
    return startPlaceholder .. text .. endPlaceholder
  end)

  msg = msg:gsub("(|cn[%w_]+:)(.-)(|r)", function(colorStart, text, colorEnd)
    specialCodes[index] = colorStart
    local startPlaceholder = "\001" .. index .. "\002"
    index = index + 1
    specialCodes[index] = colorEnd
    local endPlaceholder = "\001" .. index .. "\002"
    index = index + 1
    return startPlaceholder .. text .. endPlaceholder
  end)

  msg = msg:gsub("(|T.-|t)", function(code)
    specialCodes[index] = code
    index = index + 1
    return "\001" .. (index-1) .. "\002"
  end)

  msg = msg:gsub("(|A.-|a)", function(code)
    specialCodes[index] = code
    index = index + 1
    return "\001" .. (index-1) .. "\002"
  end)

  msg = msg:gsub("(|H.-|h%[.-%]|h)", function(code)
    specialCodes[index] = code
    index = index + 1
    return "\001" .. (index-1) .. "\002"
  end)

  -- Generic hyperlinks (quest/title tags sometimes use `|H...|h...|h` without `[...]`).
  -- Must be protected before RTL reversal, otherwise they break and any embedded icon text disappears.
  msg = msg:gsub("(|H.-|h.-|h)", function(code)
    specialCodes[index] = code
    index = index + 1
    return "\001" .. (index-1) .. "\002"
  end)

  -- Protect HTML/SimpleHTML tags used by books and UI rich text.
  -- Books AR data stores tags in reversed form (e.g. `>LMTH<`) so that a later
  -- whole-string RTL reversal restores them to valid HTML. Convert both normal
  -- and reversed tag tokens into placeholders before the RTL pipeline so line
  -- wrapping and shaping do not split them apart.
  msg = msg:gsub("(<[^<>\r\n]+>)", function(code)
    local html = normalizeHtmlTagToken(code)
    if not html then return code end
    specialCodes[index] = html
    index = index + 1
    return "\001" .. (index - 1) .. "\002"
  end)

  msg = msg:gsub("(>[^<>\r\n]+<)", function(code)
    local html = normalizeHtmlTagToken(code)
    if not html then return code end
    specialCodes[index] = html
    index = index + 1
    return "\001" .. (index - 1) .. "\002"
  end)

  -- Protect Blizzard dynamic placeholders {1}, {2}, {3}, etc.
  -- These are used in spell tooltips and other dynamic content where WoW substitutes values.
  -- Must be protected from RTL reversal to prevent {1} becoming }1{
  msg = msg:gsub("(%{%d+%})", function(code)
    specialCodes[index] = code
    index = index + 1
    return "\001" .. (index-1) .. "\002"
  end)

  -- Protect printf-style format tokens from RTL reversal corruption.
  -- These tokens (%s, %d, %f, etc.) would break under reversal (e.g., %s -> s%).
  -- Pattern matches: %s, %d, %i, %f, %e, %g, %x, %o, %c, %u and variants with width/precision like %.2f, %10d
  msg = msg:gsub("(%%%-?%d*%.?%d*[sdifFeEgGxXouc])", function(code)
    specialCodes[index] = code
    index = index + 1
    return "\001" .. (index-1) .. "\002"
  end)

  -- Protect positional printf tokens (%1$s, %2$d, etc.) used for argument reordering
  msg = msg:gsub("(%%%d+%$%-?%d*%.?%d*[sdifFeEgGxXouc])", function(code)
    specialCodes[index] = code
    index = index + 1
    return "\001" .. (index-1) .. "\002"
  end)

  -- Protect numeric values substituted by ST_TranslatePrepare (marked with \003...\004)
  -- This prevents substituted values like "20" from being reversed to "02" during RTL processing.
  -- The markers are stripped and only the actual value is stored/restored.
  msg = msg:gsub("\003([^\004]*)\004", function(value)
    specialCodes[index] = value
    index = index + 1
    return "\001" .. (index-1) .. "\002"
  end)

  -- Protect plain numeric tokens (hardcoded digits) from RTL reversal.
  -- We must skip existing \001...\002 placeholders (their indices contain digits and are restored later).
  -- Supports:
  -- - ASCII digits: 0-9
  -- - Arabic-Indic digits: U+0660..U+0669 (UTF-8: D9 A0..A9)
  -- - Eastern Arabic-Indic digits: U+06F0..U+06F9 (UTF-8: DB B0..B9)
  -- Token may include common separators (., , , :, /, -) and a trailing '%' (e.g., 27%, 12:34, 1,234.56).
  do
    local function readDigit(s, i)
      local b1 = s:byte(i)
      if not b1 then return nil end
      -- ASCII digit
      if b1 >= 48 and b1 <= 57 then
        return s:sub(i, i), i + 1
      end
      -- Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩): D9 A0..A9
      local b2 = s:byte(i + 1)
      if b2 then
        if (b1 == 217 and b2 >= 160 and b2 <= 169) or (b1 == 219 and b2 >= 176 and b2 <= 185) then
          return s:sub(i, i + 1), i + 2
        end
      end
      return nil
    end

    local function peekIsDigit(s, i)
      local _, nextI = readDigit(s, i)
      return nextI ~= nil
    end

    local len = #msg
    local out = {}
    local i = 1
    while i <= len do
      local b = msg:byte(i)
      -- Skip existing placeholders (\001...\002)
      if b == 1 then
        local j = msg:find("\002", i + 1, true)
        if not j then
          out[#out + 1] = msg:sub(i)
          break
        end
        out[#out + 1] = msg:sub(i, j)
        i = j + 1
      else
        local d, nextI = readDigit(msg, i)
        if d then
          local parts = { d }
          i = nextI
          while i <= len do
            local d2, nextI2 = readDigit(msg, i)
            if d2 then
              parts[#parts + 1] = d2
              i = nextI2
            else
              local ch = msg:sub(i, i)
              -- Allow a trailing percent sign right after a digit run.
              if ch == "%" then
                parts[#parts + 1] = ch
                i = i + 1
                break
              end
              -- Allow separators only when they are between digits (e.g., 12:34, 1,234.56, 10/10, 1-2)
              if (ch == "." or ch == "," or ch == ":" or ch == "/" or ch == "-") and peekIsDigit(msg, i + 1) then
                parts[#parts + 1] = ch
                i = i + 1
              else
                break
              end
            end
          end

          local token = table.concat(parts)
          specialCodes[index] = token
          index = index + 1
          out[#out + 1] = "\001" .. (index - 1) .. "\002"
        else
          out[#out + 1] = msg:sub(i, i)
          i = i + 1
        end
      end
    end
    msg = table.concat(out)
  end

  return msg, specialCodes, prefix
end

function Text.RestoreWoWSpecialCodes(msg, specialCodes)
  if not specialCodes then
    return msg
  end
  msg = msg:gsub("\001(%d+)\002", function(i)
    return specialCodes[tonumber(i)]
  end)
  msg = msg:gsub("\002(%d+)\001", function(i)
    -- If the text was reversed, the digit run inside the placeholder is reversed too (e.g. "\00112\002" -> "\00221\001").
    -- Reverse the digits back so multi-digit placeholder indices restore correctly.
    return specialCodes[tonumber(string.reverse(i))]
  end)
  return msg
end

-- Detect Arabic script in a UTF-8 string (base Arabic + Presentation Forms).
-- Used to avoid reversing pure English strings when running in AR locale.
function Text.ContainsArabic(txt)
  if type(txt) ~= "string" then return false end

  -- Secret values can raise errors on comparison or string ops; guard with pcall.
  local ok, hasArabic = pcall(function()
    if txt == "" then return false end

    -- Fast path: Arabic Presentation Forms-A/B live in UTF-8 sequences starting with 0xEF 0xAD..0xBB
    if (string.find(txt, "\239\173") ~= nil)
        or (string.find(txt, "\239\174") ~= nil)
        or (string.find(txt, "\239\175") ~= nil)
        or (string.find(txt, "\239\185") ~= nil)
        or (string.find(txt, "\239\186") ~= nil)
        or (string.find(txt, "\239\187") ~= nil) then
      return true
    end

    -- Fast path: most Arabic base letters live in 2-byte UTF-8 sequences starting with 0xD8..0xDB.
    if string.find(txt, "[\216\217\218\219]") ~= nil then
      return true
    end

    -- Fallback: use reshaper helper if available (base Arabic letters only).
    local fn = _G.AS_ContainsArabic
    if type(fn) == "function" then
      return fn(txt) == true
    end

    return false
  end)

  if ok then return hasArabic end
  return false
end

-- Normalize newline representations used across datasets to one internal token.
-- Canonical authoring remains {B}, but we accept legacy forms for compatibility.
local function normalizeLineBreakTokens(msg)
  if type(msg) ~= "string" or msg == "" then return msg end
  local text = msg

  -- Real line breaks.
  text = text:gsub("\r\n", "NEW_LINE")
  text = text:gsub("\r", "NEW_LINE")
  text = text:gsub("\n", "NEW_LINE")

  -- Escaped line breaks stored as literal backslash sequences in Lua strings.
  text = text:gsub("\\r\\n", "NEW_LINE")
  text = text:gsub("\\n", "NEW_LINE")
  text = text:gsub("\\r", "NEW_LINE")

  -- Addon/WoW newline tokens seen in translation data.
  text = text:gsub("%{B%}", "NEW_LINE")
  text = text:gsub("%$[Bb]", "NEW_LINE")
  text = text:gsub("%{n%}", "NEW_LINE")
  text = text:gsub("|n", "NEW_LINE")

  return text
end

-- Some imported locale strings mix pipe color starts with curly resets, e.g.:
-- "|cnNORMAL_FONT_COLOR:Text{R}".
-- Convert these hybrids to the native WoW pair ("|cn...|r") so RTL protection
-- logic can preserve them instead of exposing reversed color token text.
local function normalizeMixedColorResets(msg)
  if type(msg) ~= "string" or msg == "" then return msg end
  local text = msg
  text = text:gsub("(|cn[%w_]+:.-)%{[Rr]%}", "%1|r")
  text = text:gsub("(|c%x%x%x%x%x%x%x%x.-)%{[Rr]%}", "%1|r")
  return text
end

local function fallbackLinkText(linkRef)
  local label = linkRef or "link"
  if type(label) ~= "string" then
    label = tostring(label)
  end
  local afterType = label:match("^[^:]+:(.+)$")
  if afterType and afterType ~= "" then
    label = afterType
  end
  label = label:gsub("%[", ""):gsub("%]", "")
  label = label:gsub("^%s+", ""):gsub("%s+$", "")
  if label == "" then
    label = "link"
  end
  return label
end

-- Complete malformed links like "|Hspell:161767|h" to a clickable fallback:
-- "|Hspell:161767|h[161767]|h". Valid links remain unchanged.
local function autoCompleteHyperlinks(msg)
  if type(msg) ~= "string" or msg == "" then return msg end

  local out = {}
  local cursor = 1
  local len = #msg

  while cursor <= len do
    local openStart, openEnd, linkRef = msg:find("|H([^|]+)|h", cursor)
    if not openStart then
      out[#out + 1] = msg:sub(cursor)
      break
    end

    out[#out + 1] = msg:sub(cursor, openStart - 1)

    local closeStart, closeEnd = msg:find("|h", openEnd + 1, true)
    if closeStart then
      out[#out + 1] = msg:sub(openStart, closeEnd)
      cursor = closeEnd + 1
    else
      out[#out + 1] = "|H" .. linkRef .. "|h[" .. fallbackLinkText(linkRef) .. "]|h"
      cursor = openEnd + 1
    end
  end

  return table.concat(out)
end

-- Replace addon placeholders with game-friendly sequences and player data.
function Text.WOW_ZmienKody(message, target)
  local msg = message
  if type(msg) ~= "string" then
    if msg == nil then return "" end
    msg = tostring(msg)
  end

  msg = autoCompleteHyperlinks(msg)
  msg = normalizeLineBreakTokens(msg)
  msg = normalizeMixedColorResets(msg)

  -- Config: allow forcing player gender used for $G / YOUR_GENDER expansions (Male/Female/Character).
  -- Stored under bubbles config as BB_PM["sex"]: "2"=Male, "3"=Female, "4"=Character (use UnitSex("player")).
  local effectivePlayerSex = WOWTR_player_sex
  do
    local override = BB_PM and tonumber(BB_PM["sex"])
    if override == 2 or override == 3 then
      effectivePlayerSex = override
    end
  end
  if (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
    msg = string.gsub(msg, "{N}", "YOUR_NAME")
    msg = string.gsub(msg, "{B}", "NEW_LINE")
    msg = string.gsub(msg, "{R}", "YOUR_RACE")
    msg = string.gsub(msg, "{C}", "YOUR_CLASS")

    msg = string.gsub(msg, "{002DFFFFc}", "{cFFFFD200}")
    msg = string.gsub(msg, "{FFFF00FFc}", "{cFF00FFFF}")
    msg = string.gsub(msg, "{0000FFFFc}", "{cFFFF0000}")
    msg = string.gsub(msg, "{ffffffffc}", "{cffffffff}")
    msg = string.gsub(msg, "EU_ROLOC:", "UE_COLOR:")
  else
    msg = string.gsub(msg, "$b", "$B")
    msg = string.gsub(msg, "$n", "$N")
    msg = string.gsub(msg, "$r", "$R")
    msg = string.gsub(msg, "$c", "$C")
    msg = string.gsub(msg, "$g", "$G")
    msg = string.gsub(msg, "$p", "$P")
    msg = string.gsub(msg, "$o", "$O")

    msg = string.gsub(msg, "$B", "NEW_LINE")
    msg = string.gsub(msg, "$N", "YOUR_NAME")
    msg = string.gsub(msg, "$R", "YOUR_RACE")
    msg = string.gsub(msg, "$C", "YOUR_CLASS")
    msg = string.gsub(msg, "$G", "YOUR_GENDER")
    msg = string.gsub(msg, "$P", "NPC_GENDER")
    msg = string.gsub(msg, "$O", "OWN_NAME")
  end

  msg = string.gsub(msg, "NEW_LINE", "\n")

  if (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
    if (effectivePlayerSex == 3) then
      msg = string.gsub(msg, "YOUR_CLASS", player_class_table.F)
    else
      msg = string.gsub(msg, "YOUR_CLASS", player_class_table.M)
    end
    if (effectivePlayerSex == 3) then
      msg = string.gsub(msg, "YOUR_RACE", player_race_table.F)
    else
      msg = string.gsub(msg, "YOUR_RACE", player_race_table.M)
    end
  else
    if (effectivePlayerSex == 3) then
      msg = string.gsub(msg, "YOUR_RACE1", WOWTR_AnsiReverse(player_race_table.M2))
    else
      msg = string.gsub(msg, "YOUR_RACE1", WOWTR_AnsiReverse(player_race_table.M1))
    end
    if (effectivePlayerSex == 3) then
      msg = string.gsub(msg, "YOUR_RACE2", WOWTR_AnsiReverse(player_race_table.D2))
    else
      msg = string.gsub(msg, "YOUR_RACE2", WOWTR_AnsiReverse(player_race_table.D1))
    end
  end

  -- Substitute player/target names.
  -- In AR locale, many strings will be reversed later for RTL display. To keep LTR names readable,
  -- we pre-reverse them ONLY when the surrounding string contains Arabic (and therefore will be RTL-processed).
  local shouldAnsiReverse = (WOWTR_Localization and WOWTR_Localization.lang == 'AR') and Text.ContainsArabic(msg)
  local function maybeAnsiReverse(s)
    if not s then return "" end
    if shouldAnsiReverse then
      return WOWTR_AnsiReverse(s)
    end
    return s
  end

  if (target) then
    msg = string.gsub(msg, "$target", maybeAnsiReverse(target))
    msg = string.gsub(msg, "YOUR_NAME$", maybeAnsiReverse(string.upper(target)))
    msg = string.gsub(msg, "YOUR_NAME", maybeAnsiReverse(target))
  else
    msg = string.gsub(msg, "YOUR_NAME$", maybeAnsiReverse(string.upper(WOWTR_player_name or "")))
    msg = string.gsub(msg, "YOUR_NAME", maybeAnsiReverse(WOWTR_player_name or ""))
  end

  if (string.find(msg, "NPC_GENDER")) then
    if (WOWTR_Localization.lang == 'AR') then
      -- luacheck: globals QTR_NPC_GENDER
      ---@diagnostic disable-next-line: undefined-global
      if (QTR_NPC_GENDER == 'F') then
        msg = string.gsub(msg, "NPC_GENDER", "F")
      else
        msg = string.gsub(msg, "NPC_GENDER", "M")
      end
    else
      msg = string.gsub(msg, "NPC_GENDER", "NPC_GENDER")
    end
  end

  if (string.find(msg, "YOUR_GENDER")) then
    if (WOWTR_Localization.lang == 'AR') then
      if (effectivePlayerSex == 3) then
        msg = string.gsub(msg, "YOUR_GENDER", "F")
      else
        msg = string.gsub(msg, "YOUR_GENDER", "M")
      end
    else
      msg = string.gsub(msg, "YOUR_GENDER", "YOUR_GENDER")
    end
  end

  if (string.find(msg, "OWN_NAME")) then
    local nr_poz, nr_poz2 = string.find(msg, "OWN_NAME")
    local nr_1, nr_2, nr_3
    while (nr_poz and nr_poz2 > 0) do
      nr_1 = nr_poz2 + 1
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
        nr_1 = nr_1 + 1
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
        nr_2 = nr_1 + 1
        while ((string.sub(msg, nr_2, nr_2) ~= ";") and (nr_2 - nr_1 < 100)) do
          nr_2 = nr_2 + 1
        end
        if (string.sub(msg, nr_2, nr_2) == ";") then
          nr_3 = nr_2 + 1
          while ((string.sub(msg, nr_3, nr_3) ~= ")") and (nr_3 - nr_2 < 100)) do
            nr_3 = nr_3 + 1
          end
          if (string.sub(msg, nr_3, nr_3) == ")") then
            local QTR_forma
            if (QTR_PS and QTR_PS["ownnames"] == "1") then
              QTR_forma = string.sub(msg, nr_2 + 1, nr_3 - 1)
            else
              QTR_forma = string.sub(msg, nr_1 + 1, nr_2 - 1)
            end
            if (nr_poz > 1) then
              msg = string.sub(msg, 1, nr_poz - 1) .. QTR_forma .. string.sub(msg, nr_3 + 1)
            else
              msg = QTR_forma .. string.sub(msg, nr_3 + 1)
            end
          end
        end
      end
      nr_poz, nr_poz2 = string.find(msg, "OWN_NAME")
    end
  end

  return msg
end

-- Expand unit info and shape Arabic text for display in a FontString-like region.
local textMeasureFrame
local textMeasureFontString

local function normalizeFontPath(fontPath)
  if type(fontPath) ~= "string" or fontPath == "" then return nil end
  return (fontPath:gsub("/", "\\"):lower())
end

local function isFont1(fontPath)
  return normalizeFontPath(fontPath) == normalizeFontPath(rawget(_G, "WOWTR_Font1"))
end

local function ensureTextMeasureFontString()
  if textMeasureFontString then return textMeasureFontString end
  textMeasureFrame = CreateFrame("Frame", nil, UIParent)
  textMeasureFrame:SetSize(2048, 256)
  textMeasureFrame:Hide()
  textMeasureFontString = textMeasureFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  textMeasureFontString:SetPoint("TOPLEFT", textMeasureFrame, "TOPLEFT", 0, 0)
  textMeasureFontString:SetJustifyH("LEFT")
  return textMeasureFontString
end

local function measureFontLineHeight(fontPath, fontSize, fontFlags)
  if (not fontPath) or (not fontSize) then return nil end
  local fs = ensureTextMeasureFontString()
  fs:SetWidth(2048)
  if fs.SetSpacing then
    pcall(fs.SetSpacing, fs, 0)
  end
  pcall(fs.SetFont, fs, fontPath, fontSize, fontFlags or "")
  fs:SetText("Hg")
  local measuredHeight = fs:GetHeight()
  if measuredHeight and measuredHeight > 0 then
    return measuredHeight
  end
  return nil
end

local function resolveSpacingTarget(obj)
  if not obj then return nil end
  if obj.SetSpacing and obj.GetSpacing then
    return obj
  end
  if obj.Text and obj.Text.SetSpacing and obj.Text.GetSpacing then
    return obj.Text
  end
  if obj.GetRegions then
    local regions = { obj:GetRegions() }
    for _, region in ipairs(regions) do
      if region and region.GetObjectType and region:GetObjectType() == "FontString" and region.SetSpacing and region.GetSpacing then
        return region
      end
    end
  end
  return nil
end

local function applyDynamicFontSpacing(obj, sourceFont, targetFont, fontSize, fontFlags)
  local spacingTarget = resolveSpacingTarget(obj)
  if not spacingTarget then return end

  if spacingTarget.WoWAR_DefaultSpacing == nil then
    local ok, currentSpacing = pcall(spacingTarget.GetSpacing, spacingTarget)
    spacingTarget.WoWAR_DefaultSpacing = ok and currentSpacing or 0
  end

  local defaultSpacing = spacingTarget.WoWAR_DefaultSpacing or 0
  local desiredSpacing = defaultSpacing

  if isFont1(targetFont) then
    local spacingFromMetrics = 0
    local sourceLineHeight = measureFontLineHeight(sourceFont or targetFont, fontSize, fontFlags)
    local targetLineHeight = measureFontLineHeight(targetFont, fontSize, fontFlags)
    if sourceLineHeight and targetLineHeight and (targetLineHeight + 0.5 < sourceLineHeight) then
      spacingFromMetrics = math.floor((sourceLineHeight - targetLineHeight) + 0.5)
    end
    desiredSpacing = math.max(defaultSpacing, spacingFromMetrics + 2)
  end

  local ok, currentSpacing = pcall(spacingTarget.GetSpacing, spacingTarget)
  if (not ok) or (not currentSpacing) or (math.abs(currentSpacing - desiredSpacing) > 0.1) then
    pcall(spacingTarget.SetSpacing, spacingTarget, desiredSpacing)
  end
end

function Text.ExpandUnitInfo(msg, OnObjectives, AR_obj, AR_font, AR_corr, AR_RIGHT)
  if (msg == nil) then msg = "" end
  msg = Text.WOW_ZmienKody(msg)

  if ((WOWTR_Localization and WOWTR_Localization.lang == 'AR') and (AR_obj) and Text.ContainsArabic(msg)) then
    msg = FixCurlyColorSpansForRTL(msg)
    local _font = WOWTR_Font2
    local AR_size = 13
    local _flags = ""
    if AR_obj.GetFont then
      local ok, f, s, fl = pcall(AR_obj.GetFont, AR_obj, "P")
      if ok and f then _font = f; AR_size = s or AR_size; _flags = fl or _flags else
        ok, f, s, fl = pcall(AR_obj.GetFont, AR_obj)
        if ok and f then _font = f; AR_size = s or AR_size; _flags = fl or _flags end
      end
    elseif AR_obj.GetRegions then
      local regions = { AR_obj:GetRegions() }
      for _, v in pairs(regions) do
        if (v.GetObjectType and v:GetObjectType() == "FontString" and v.GetFont) then
          local ok, f, s, fl = pcall(v.GetFont, v)
          if ok and f then _font = f; AR_size = s or AR_size; _flags = fl or _flags; break end
        end
      end
    end

    local _corr = 0
    if (AR_corr and type(AR_corr) == "number") then _corr = AR_corr end

    local specialCodes, prefix
    msg, specialCodes, prefix = Text.HandleWoWSpecialCodes(msg)

    msg = string.gsub(msg, "{n}", "\n")
    msg = string.gsub(msg, "\n", "#")
    msg = string.gsub(msg, "{r}", "r|")

    local function handleCode(startCode, endCode)
      local nr_poz1 = string.find(msg, startCode)
      while (nr_poz1) do
        local nr_poz2 = string.find(msg, endCode, nr_poz1)
        if (nr_poz2) then
          local pomoc = string.sub(msg, nr_poz1 + 2, nr_poz2 - 1)
          msg = string.gsub(msg, startCode .. pomoc .. endCode, string.reverse(pomoc) .. string.sub(startCode, 2, 2) .. "|")
          nr_poz1 = string.find(msg, startCode, nr_poz2)
        else
          break
        end
      end
    end

    handleCode("{c", "}")
    handleCode("{T", "{t}")
    handleCode("{A", "{a}")
    handleCode("{H", "{h}")

    msg = string.gsub(msg, "{t}", "t|")
    msg = string.gsub(msg, "{a}", "a|")
    msg = string.gsub(msg, "{h}", "h|")

    if AR_RIGHT then
      msg = AS_ReverseAndPrepareLineText_RIGHT(msg, AR_obj:GetWidth() + _corr, AR_font or _font, AR_size)
    else
      msg = AS_ReverseAndPrepareLineText(msg, AR_obj:GetWidth() + _corr, AR_font or _font, AR_size)
    end

    applyDynamicFontSpacing(AR_obj, _font, AR_font or _font, AR_size, _flags)

    msg = Text.RestoreWoWSpecialCodes(msg, specialCodes)
    msg = (prefix or "") .. msg
  end

  return msg
end

function Text.ReverseIfAR(txt)
  if (txt and WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
    local msg = Text.WOW_ZmienKody(txt)
    if not Text.ContainsArabic(msg) then
      return msg
    end
    msg = FixCurlyColorSpansForRTL(msg)
    local specialCodes, prefix
    msg, specialCodes, prefix = Text.HandleWoWSpecialCodes(msg)

    msg = string.gsub(msg, "{n}", "\n")
    msg = string.gsub(msg, "{r}", "r|")
    msg = string.gsub(msg, "|n|n", "n|n|")

    local function handleCode(startCode, endCode)
      local nr_poz1 = string.find(msg, startCode)
      local iteration_count = 0
      local max_iterations = 100
      while (nr_poz1 and iteration_count < max_iterations) do
        iteration_count = iteration_count + 1
        local nr_poz2 = string.find(msg, endCode, nr_poz1)
        if (nr_poz2) then
          local pomoc = string.sub(msg, nr_poz1 + 2, nr_poz2 - 1)
          local old_pattern = startCode .. pomoc .. endCode
          local new_pattern = string.reverse(pomoc) .. string.sub(startCode, 2, 2) .. "|"
          msg = string.gsub(msg, old_pattern, new_pattern, 1)
          nr_poz1 = string.find(msg, startCode)
        else
          break
        end
      end
    end

    handleCode("{c", "}")
    handleCode("{cn", "}")

    msg = string.gsub(msg, "{t}", "t|")
    msg = string.gsub(msg, "{a}", "a|")
    msg = string.gsub(msg, "{h}", "h|")

    msg = AS_UTF8reverse(msg)
    msg = Text.RestoreWoWSpecialCodes(msg, specialCodes)
    if prefix and prefix ~= "" then msg = prefix .. msg end
    return msg
  end
  return txt
end

function Text.AnsiReverse(txt)
  if not txt then return "" end
  local text = txt
  if (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
    text = string.reverse(text)
  end
  return text
end

local function escapeLuaPatternLiteral(s)
  if type(s) ~= "string" or s == "" then
    return ""
  end
  return (s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"))
end

local function replaceLiteral(text, literal, replacer)
  if type(text) ~= "string" then
    return ""
  end
  if type(literal) ~= "string" or literal == "" then
    return text
  end
  local pattern = escapeLuaPatternLiteral(literal)
  if pattern == "" then
    return text
  end
  return (text:gsub(pattern, replacer))
end

function Text.ReplaceOnlyWholeWords(txt, finder, replacer)
  if type(txt) ~= "string" then
    return ""
  end
  if type(finder) ~= "string" or finder == "" then
    return txt
  end
  local result = txt
  local last = 1
  local finderPattern = escapeLuaPatternLiteral(finder)
  if finderPattern == "" then
    return result
  end
  local nr_poz, nr_end = string.find(result, finderPattern)
  while (nr_poz and nr_poz > 0) do
    if ((nr_poz == 1) or ((nr_poz > 1) and (string.sub(result, nr_poz - 1, nr_poz - 1) == ' ')) or ((nr_poz > 2) and (string.sub(result, nr_poz - 2, nr_poz - 1) == '$B'))) then
      local char_after = string.sub(result, nr_end + 1, nr_end + 1)
      if ((char_after == '') or (char_after == '.') or (char_after == ',') or (char_after == '?') or (char_after == '!') or (char_after == ' ') or (char_after == ';') or (char_after == ':') or (char_after == '>') or (char_after == '-')) then
        result = string.sub(result, 1, nr_poz - 1) .. replacer .. string.sub(result, nr_end + 1)
        last = nr_poz + strlen(replacer)
      else
        last = nr_end + 1
      end
    else
      last = nr_poz + strlen(finder)
    end
    nr_poz, nr_end = string.find(result, finderPattern, last)
  end
  return result
end

function Text.DetectAndReplacePlayerName(txt, target, part)
  if (txt == nil) then return "" end
  local text = string.gsub(txt, '\r', "")
  if (part == nil) or (part == '$B') then
    text = string.gsub(text, '\n', "$B")
  end
  if (part == nil) or (part == '$N') then
    local playerName = WOWTR_player_name or ""
    local upperCaseName = string.upper(playerName)
    text = replaceLiteral(text, playerName, "$N")
    text = replaceLiteral(text, upperCaseName, "$N")
  end
  if (part == nil) or (part == '$R') then
    text = Text.ReplaceOnlyWholeWords(text, WOWTR_player_race or "", '$R')
    text = Text.ReplaceOnlyWholeWords(text, string.lower(WOWTR_player_race or ""), '$R')
    text = Text.ReplaceOnlyWholeWords(text, string.upper(WOWTR_player_race or ""), '$R$')
  end
  if (part == nil) or (part == '$C') then
    text = Text.ReplaceOnlyWholeWords(text, WOWTR_player_class or "", '$C')
    text = Text.ReplaceOnlyWholeWords(text, string.lower(WOWTR_player_class or ""), '$C')
    text = Text.ReplaceOnlyWholeWords(text, string.upper(WOWTR_player_class or ""), '$C$')
  end
  if (target) then
    text = Text.ReplaceOnlyWholeWords(text, target, "$N")
  end
  return text
end

function Text.DeleteSpecialCodes(txt, part)
  if (txt == nil) then return "" end
  local text = txt
  if (part == nil) or (part == '$B') then
    text = string.gsub(text, '$B', '')
  end
  if (part == nil) or (part == '$N') then
    text = string.gsub(text, '$N$', '')
    text = string.gsub(text, '$N', '')
  end
  if (part == nil) or (part == '$R') then
    text = string.gsub(text, '$R$', '')
    text = string.gsub(text, '$R', '')
  end
  if (part == nil) or (part == '$C') then
    text = string.gsub(text, '$C$', '')
    text = string.gsub(text, '$C', '')
  end
  return text
end

-- Strip an internal color-prefix marker if present (added during RTL processing)
function Text.StripUEColorMarker(txt)
  if not txt then return "" end
  return (txt:gsub("^UE_COLOR:", ""))
end

-- Remove WoW color codes from text (both |cFFFFFFFF and |cnNAME: variants)
function Text.StripWoWColors(txt)
  if not txt then return "" end
  local text = txt
  -- Remove any color-start tokens and resets; leave inner text intact
  text = text:gsub("|c%x%x%x%x%x%x%x%x", "")
  text = text:gsub("|cn[%w_]+:", "")
  text = text:gsub("|r", "")
  return text
end

-- Normalize a string before hashing: drop UE_COLOR, remove color tags, then delete addon placeholders
function Text.NormalizeForHash(txt)
  if not txt then return "" end
  local s = Text.StripUEColorMarker(txt)
  s = Text.StripWoWColors(s)
  s = Text.DeleteSpecialCodes(s)
  s = s:gsub('\r', '')
  return s
end

-- Back-compat global wrappers
function HandleWoWSpecialCodes(msg) return Text.HandleWoWSpecialCodes(msg) end
function RestoreWoWSpecialCodes(msg, sc) return Text.RestoreWoWSpecialCodes(msg, sc) end
function WOW_ZmienKody(message, target) return Text.WOW_ZmienKody(message, target) end
function QTR_ExpandUnitInfo(msg, OnObjectives, AR_obj, AR_font, AR_corr, AR_RIGHT) return Text.ExpandUnitInfo(msg, OnObjectives, AR_obj, AR_font, AR_corr, AR_RIGHT) end
function QTR_ReverseIfAR(txt) return Text.ReverseIfAR(txt) end
function WOWTR_ContainsArabic(txt) return Text.ContainsArabic(txt) end
function WOWTR_AnsiReverse(txt) return Text.AnsiReverse(txt) end
function WOWTR_ReplaceOnlyWholeWords(txt, f, r) return Text.ReplaceOnlyWholeWords(txt, f, r) end
function WOWTR_DetectAndReplacePlayerName(txt, target, part) return Text.DetectAndReplacePlayerName(txt, target, part) end
function WOWTR_DeleteSpecialCodes(txt, part) return Text.DeleteSpecialCodes(txt, part) end
function WOWTR_StripUEColorMarker(txt) return Text.StripUEColorMarker(txt) end
function WOWTR_StripWoWColors(txt) return Text.StripWoWColors(txt) end
function WOWTR_NormalizeForHash(txt) return Text.NormalizeForHash(txt) end

