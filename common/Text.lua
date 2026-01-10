-- Text.lua
-- Shared text processing helpers (special codes, expansion, RTL-aware shaping)

local addonName, ns = ...
ns = ns or {}
ns.Text = ns.Text or {}
local Text = ns.Text

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
  if not txt or txt == "" then return false end

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
  if type(_G.AS_ContainsArabic) == "function" then
    return AS_ContainsArabic(txt) == true
  end

  return false
end

-- Replace addon placeholders with game-friendly sequences and player data.
function Text.WOW_ZmienKody(message, target)
  local msg = message
  -- Config: allow forcing player gender used for $G / YOUR_GENDER expansions (Male/Female/Character).
  -- Stored under bubbles config as BB_PM["sex"]: "2"=Male, "3"=Female, "4"=Character (use UnitSex("player")).
  local effectivePlayerSex = WOWTR_player_sex
  do
    local override = BB_PM and tonumber(BB_PM["sex"])
    if override == 2 or override == 3 then
      effectivePlayerSex = override
    end
  end
  if (WoWTR_Localization and WoWTR_Localization.lang == 'AR') then
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

  if (WoWTR_Localization and WoWTR_Localization.lang == 'AR') then
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
  local shouldAnsiReverse = (WoWTR_Localization and WoWTR_Localization.lang == 'AR') and Text.ContainsArabic(msg)
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
    if (WoWTR_Localization.lang == 'AR') then
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
    if (WoWTR_Localization.lang == 'AR') then
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
function Text.ExpandUnitInfo(msg, OnObjectives, AR_obj, AR_font, AR_corr, AR_RIGHT)
  if (msg == nil) then msg = "" end
  msg = Text.WOW_ZmienKody(msg)

  if ((WoWTR_Localization and WoWTR_Localization.lang == 'AR') and (AR_obj) and Text.ContainsArabic(msg)) then
    local _font = WOWTR_Font2
    local AR_size = 13
    if AR_obj.GetFont then
      local ok, f, s = pcall(AR_obj.GetFont, AR_obj, "P")
      if ok and f then _font = f; AR_size = s or AR_size else
        ok, f, s = pcall(AR_obj.GetFont, AR_obj)
        if ok and f then _font = f; AR_size = s or AR_size end
      end
    elseif AR_obj.GetRegions then
      local regions = { AR_obj:GetRegions() }
      for _, v in pairs(regions) do
        if (v.GetObjectType and v:GetObjectType() == "FontString" and v.GetFont) then
          local ok, f, s = pcall(v.GetFont, v)
          if ok and f then _font = f; AR_size = s or AR_size; break end
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

    msg = Text.RestoreWoWSpecialCodes(msg, specialCodes)
    msg = (prefix or "") .. msg
  end

  return msg
end

function Text.ReverseIfAR(txt)
  if (txt and WoWTR_Localization and WoWTR_Localization.lang == 'AR') then
    local msg = Text.WOW_ZmienKody(txt)
    if not Text.ContainsArabic(msg) then
      return msg
    end
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
  if (WoWTR_Localization and WoWTR_Localization.lang == 'AR') then
    text = string.reverse(text)
  end
  return text
end

function Text.ReplaceOnlyWholeWords(txt, finder, replacer)
  local result = txt
  local last = 1
  local nr_poz, nr_end = string.find(result, finder)
  while (nr_poz and nr_poz > 0) do
    if ((nr_poz == 1) or ((nr_poz > 1) and (string.sub(result, nr_poz - 1, nr_poz - 1) == ' ')) or ((nr_poz > 2) and (string.sub(result, nr_poz - 2, nr_poz - 1) == '$B'))) then
      local char_after = string.sub(result, nr_end + 1, nr_end + 1)
      if ((char_after == '.') or (char_after == ',') or (char_after == '?') or (char_after == '!') or (char_after == ' ') or (char_after == ';') or (char_after == ':') or (char_after == '>') or (char_after == '-')) then
        result = string.sub(result, 1, nr_poz - 1) .. replacer .. string.sub(result, nr_end + 1)
        last = nr_poz + strlen(replacer)
      else
        last = nr_end + 1
      end
    else
      last = nr_poz + strlen(finder)
    end
    nr_poz, nr_end = string.find(result, finder, last)
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
    local upperCaseName = string.upper(WOWTR_player_name or "")
    text = string.gsub(text, WOWTR_player_name or "", "$N")
    text = string.gsub(text, upperCaseName, "$N")
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
function WOWTR_AnsiReverse(txt) return Text.AnsiReverse(txt) end
function WOWTR_ReplaceOnlyWholeWords(txt, f, r) return Text.ReplaceOnlyWholeWords(txt, f, r) end
function WOWTR_DetectAndReplacePlayerName(txt, target, part) return Text.DetectAndReplacePlayerName(txt, target, part) end
function WOWTR_DeleteSpecialCodes(txt, part) return Text.DeleteSpecialCodes(txt, part) end
function WOWTR_StripUEColorMarker(txt) return Text.StripUEColorMarker(txt) end
function WOWTR_StripWoWColors(txt) return Text.StripWoWColors(txt) end
function WOWTR_NormalizeForHash(txt) return Text.NormalizeForHash(txt) end

