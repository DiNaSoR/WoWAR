local addonName, ns = ...

ns = ns or {}
ns.Tooltips = ns.Tooltips or {}
local Tooltips = ns.Tooltips
local State = (Tooltips and Tooltips.State) or {}

Tooltips.GameTooltip = Tooltips.GameTooltip or {}
local GT = Tooltips.GameTooltip
local Utils = (ns.Tooltips and ns.Tooltips.Utils) or {}
local ignoreSettings = (Utils and Utils.ignoreSettings) or { words = {}, pattern = "" }

-- Helper to check if text contains Arabic (access Text module at runtime since it loads later in TOC)
local function ContainsArabicText(txt)
  local TextModule = ns and ns.Text
  if TextModule and TextModule.ContainsArabic then
    return TextModule.ContainsArabic(txt)
  end
  -- Fallback: check for Arabic character ranges directly
  if not txt or txt == "" then return false end
  -- Arabic Presentation Forms-A/B (U+FB50-U+FDFF, U+FE70-U+FEFF) encoded in UTF-8
  if string.find(txt, "[\239][\173-187]") then return true end
  -- Base Arabic block (U+0600-U+06FF) encoded in UTF-8
  if string.find(txt, "[\216-\217][\128-\191]") then return true end
  return false
end

local function IsArabicLocale()
  local loc = rawget(_G, "WOWTR_Localization")
  return loc and loc.lang == "AR"
end

local function LocString(key, fallback)
  local loc = rawget(_G, "WOWTR_Localization")
  local v = loc and loc[key]
  if type(v) == "string" and v ~= "" then
    return v
  end
  return fallback
end

-- Placeholder handler; legacy global remains authoritative until full migration.
function GT.OnShow()
  if (ST_PM and ST_PM["active"] == "1") then
    ST_lastNumLines = 0
    local elvBuffs = rawget(_G, "ElvUIPlayerBuffs")
    local elvDebuffs = rawget(_G, "ElvUIPlayerDebuffs")
    local ST_BFisOver = (BuffFrame and BuffFrame:IsMouseOver()) or (elvBuffs and elvBuffs:IsMouseOver())
    local ST_DFisOver = (DebuffFrame and DebuffFrame:IsMouseOver()) or (elvDebuffs and elvDebuffs:IsMouseOver())
    if (ST_BFisOver or ST_DFisOver) then
      GT.BuffOrDebuff()
      return
    end

    GameTooltip.updateTooltipTimer = tonumber(ST_PM["timer"])
    -- Note: ST_orygText is initialized later at line 118, but we'll add title to it if needed
    local titleText
    local titleTextOk, titleTextResult = pcall(function() 
      local frame = _G["GameTooltipTextLeft1"]
      if frame and frame.GetText then
        return frame:GetText()
      end
      return nil
    end)
    -- Test if we can actually use the text value (secret values fail here)
    if titleTextOk and titleTextResult ~= nil then
      -- Try to use the value as a string - secret values will fail this test
      -- We test the actual operations we'll need: comparison and length
      local canUse, usableText = pcall(function()
        -- Test comparison (secret values fail here)
        local isEmpty = (titleTextResult == "")
        -- Test length (secret values fail here)
        local len = string.len(titleTextResult)
        -- If we got here, the value is usable - return it
        return titleTextResult
      end)
      
      if canUse and usableText ~= nil then
        -- Double-check it's actually a string type
        if type(usableText) == "string" then
          titleText = usableText
        else
          -- Not a string type - skip processing
          return
        end
      else
        -- Secret value detected - skip processing
        return
      end
    end
    
    if titleText then
      if (string.find(titleText, NONBREAKINGSPACE)) then
        return
      end
      -- Check if title has a translation in ST_TooltipsHS (for short words like "Currency")
      local titleTextForHash = string.gsub(titleText, NONBREAKINGSPACE, "")
      local titleHash = StringHash(ST_UsunZbedneZnaki(titleTextForHash))
      if (ST_TooltipsHS and ST_TooltipsHS[titleHash]) then
        -- Translation found, use it
        local ST_tlumaczenie = ST_TooltipsHS[titleHash]
        ST_tlumaczenie = ST_TranslatePrepare(titleText, ST_tlumaczenie)
        _G["GameTooltipTextLeft1"]:SetText(QTR_ExpandUnitInfo(ST_tlumaczenie, false, _G["GameTooltipTextLeft1"], WOWTR_Font2) .. NONBREAKINGSPACE)
        _font1, _size1, _1 = _G["GameTooltipTextLeft1"]:GetFont()
        _G["GameTooltipTextLeft1"]:SetFont(WOWTR_Font2, _size1)
        -- Debug: Log title translation
        if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
          WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
            "[GT.OnShow] Title translated",
            "| Original:", titleText,
            "| Hash:", titleHash,
            "| Translation:", ST_tlumaczenie)
        end
      else
        -- No translation, restore original font
        -- Add NONBREAKINGSPACE as processed marker to prevent reprocessing (ApplyTooltipFonts will check hash table to determine if translated)
        _G["GameTooltipTextLeft1"]:SetText(QTR_ExpandUnitInfo(titleText, false) .. NONBREAKINGSPACE)
        -- Restore original font
        local titleObj = _G["GameTooltipTextLeft1"]
        if titleObj and titleObj.SetFont then
          local currentFont, currentSize, currentFlags = titleObj:GetFont()
          if currentFont == _G.WOWTR_Font2 or (type(currentFont) == "string" and (string.find(currentFont, "WoWAR") or string.find(currentFont, "WOWTR"))) then
            local restoreFont, restoreSize, restoreFlags
            if Utils and Utils.GetOriginalWoWFont then
              restoreFont, restoreSize, restoreFlags = Utils.GetOriginalWoWFont()
              restoreSize = currentSize or restoreSize
            else
              restoreFont, restoreSize, restoreFlags = currentFont, currentSize, currentFlags
            end
            titleObj:SetFont(restoreFont, restoreSize, restoreFlags)
          end
        end
        -- Save untranslated title for later translation (if saveNW is enabled)
        -- Store it temporarily since ST_orygText isn't initialized yet
        if ST_PM["saveNW"] == "1" then
          _G.ST_untranslatedTitle = titleText
        end
        -- Debug: Log when title has no translation (only once per tooltip update)
        if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
          WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
            "[GT.OnShow] Title NOT translated, restoring original font",
            "| Text:", titleText,
            "| Hash:", titleHash,
            "| ST_TooltipsHS exists:", (ST_TooltipsHS ~= nil) and "YES" or "NO",
            "| Save enabled:", (ST_PM["saveNW"] == "1") and "YES" or "NO")
        end
      end
    else
      -- Secret value detected, skip processing
      return
    end

    local ST_prefix = "h"
    local gtProc = GameTooltip and rawget(GameTooltip, "processingInfo")
    local gtData = gtProc and gtProc.tooltipData or nil
    if (gtData and gtData.id) then
      if (gtData.type == 0) then
        ST_prefix = "i" .. gtData.id
        if (ST_PM["item"] == "0") then
          return
        end
      elseif (gtData.type == 1) then
        if ST_IsTalentTooltip and ST_IsTalentTooltip(gtData) then
          ST_prefix = "t" .. gtData.id
          if (ST_PM["talent"] == "0") then
            return
          end
        else
          ST_prefix = "s" .. gtData.id
          if (ST_PM["spell"] == "0") then
            return
          end
        end
      else
        ST_prefix = "s" .. gtData.id
        if (ST_PM["spell"] == "0") and (gtData.id == 9) then
          return
        end
      end
    end

    local numLines = GameTooltip:NumLines()
    if ((numLines == 1) and (ST_prefix ~= "h")) then
      return
    end

    local ST_kodKoloru
    local ST_leftText, ST_rightText, ST_tlumaczenie, ST_hash, ST_hash2, ST_pomoc5, ST_pomoc6, ST_pomoc7
    local _font1, _size1, _1
    local ST_odstep = true
    local ST_orygText = {}
    local ST_nh = 0
    -- Add untranslated title to ST_orygText if it was saved earlier
    if _G.ST_untranslatedTitle and ST_PM["saveNW"] == "1" then
      table.insert(ST_orygText, _G.ST_untranslatedTitle)
      _G.ST_untranslatedTitle = nil  -- Clear it after use
    end

    local moneyFrameLineNumber = {}
    local money = {}
    table.insert(moneyFrameLineNumber, 0)
    table.insert(money, 0)
    local shownMoneyFrames = GameTooltip and rawget(GameTooltip, "shownMoneyFrames")
    if (shownMoneyFrames) then
      for i = 1, shownMoneyFrames, 1 do
        local moneyFrameName = GameTooltip:GetName() .. "MoneyFrame" .. i
        _G[moneyFrameName .. "PrefixText"]:SetText(QTR_ReverseIfAR(LocString("sellPrice", ": Sell price")))
        _font1, _size1, _1 = _G[moneyFrameName .. "PrefixText"]:GetFont()
        _G[moneyFrameName .. "PrefixText"]:SetFont(WOWTR_Font2, _size1)
        if (ST_PM["sellprice"] == "1") then
          _G[moneyFrameName]:Hide()
          ST_odstep = false
        end
      end
    end

    local ST_fromLine = 2
    if (ST_prefix == "h") then
      ST_fromLine = 1
    end

    local ST_TooltipsID_gl = rawget(_G, "ST_TooltipsID")
    if (ST_TooltipsID_gl and (ST_PM["transtitle"] == "1") and ST_TooltipsID_gl[ST_prefix]) then
      _G["GameTooltipTextLeft1"]:SetText(QTR_ExpandUnitInfo(ST_TooltipsID_gl[ST_prefix], WOWTR_Font2) .. NONBREAKINGSPACE)
      _font1, _size1, _1 = _G["GameTooltipTextLeft1"]:GetFont()
      _G["GameTooltipTextLeft1"]:SetFont(WOWTR_Font2, _size1)
    elseif (ST_PM["transtitle"] == "1") then
      -- No title translation found, restore original font if it was set to WOWTR_Font2
      local titleObj = _G["GameTooltipTextLeft1"]
      if titleObj and titleObj.SetFont then
        local currentFont, currentSize, currentFlags = titleObj:GetFont()
        if currentFont == _G.WOWTR_Font2 or (type(currentFont) == "string" and (string.find(currentFont, "WoWAR") or string.find(currentFont, "WOWTR"))) then
          local restoreFont, restoreSize, restoreFlags
          if Utils and Utils.GetOriginalWoWFont then
            restoreFont, restoreSize, restoreFlags = Utils.GetOriginalWoWFont()
          else
            restoreFont, restoreSize, restoreFlags = currentFont, currentSize, currentFlags
          end
            titleObj:SetFont(restoreFont, restoreSize, restoreFlags)
            -- Debug: Log font restoration with detailed frame info
            if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
              local frameName = titleObj.GetName and titleObj:GetName() or "unknown"
              local afterFont, afterSize, afterFlags = titleObj:GetFont()
              local setSuccess = (afterFont == restoreFont) and (afterSize == restoreSize) and (afterFlags == restoreFlags)
              WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                "[Font Restored] Title line: No translation found",
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
                "| SetFont Success:", setSuccess and "YES" or "NO")
            end
        end
      end
    end

    for i = ST_fromLine, numLines, 1 do
      local leftTextOk, leftTextResult = pcall(function() return _G["GameTooltipTextLeft" .. i]:GetText() end)
      ST_leftText = (leftTextOk and leftTextResult and type(leftTextResult) == "string") and leftTextResult or nil
      if (ST_leftText and (string.find(ST_leftText, NONBREAKINGSPACE) == nil)) then
        leftColR, leftColG, leftColB = _G["GameTooltipTextLeft" .. i]:GetTextColor()
        ST_kodKoloru = OkreslKodKoloru(leftColR, leftColG, leftColB)
        local lineObj = _G["GameTooltipTextLeft" .. i]
        local originalFont, originalSize, originalFlags = lineObj:GetFont()
        
        -- Check if text meets criteria for translation (long text OR specific color codes)
        local shouldTranslate = (ST_leftText and (string.len(ST_leftText) > 15) and ((ST_kodKoloru == "c7") or (ST_kodKoloru == "c4") or (string.len(ST_leftText) > 30)))
        
        -- Also check for short text translations (for words like "Currency", "Reputation", etc.)
        local shortTextHash = nil
        if not shouldTranslate and ST_leftText and string.len(ST_leftText) > 0 and string.len(ST_leftText) <= 15 then
          shortTextHash = StringHash(ST_UsunZbedneZnaki(ST_leftText))
          if (ST_TooltipsHS and ST_TooltipsHS[shortTextHash]) then
            shouldTranslate = true
          end
        end
        
        if shouldTranslate then
          local gtProc2 = GameTooltip and rawget(GameTooltip, "processingInfo")
          local gtData2 = gtProc2 and gtProc2.tooltipData or nil
          if (gtData2 and gtData2.id and (gtData2.id == 6948)) then
            ST_pomoc5, _ = string.find(ST_leftText, ". Speak")
            if (ST_pomoc5 and (ST_pomoc5 > 22)) then
              ST_miasto = string.sub(ST_leftText, 21, ST_pomoc5 - 1)
            else
              ST_miasto = LocString("your_home", "your home")
            end
            ST_pomoc6, _ = string.find(ST_leftText, ' Min Cooldown)')
            if (ST_pomoc6) then
              ST_hash = 1336493626
            else
              ST_hash = 3076025968
            end
          else
            ST_hash = shortTextHash or StringHash(ST_UsunZbedneZnaki(ST_leftText))
          end
          if (((ST_kodKoloru == "c7") or (string.len(ST_leftText) > 30)) and (not ST_hash2)) then
            ST_hash2 = ST_hash
          end
          ST_pomoc7, _ = string.find(ST_leftText, "<Made by")
          if (ST_pomoc7) then
            ST_hash = 1381871427
          end
          if (ST_TooltipsHS and ST_TooltipsHS[ST_hash]) then
            if (ST_pomoc7) then
              local endBy = string.find(ST_leftText, ">")
              local nameBy = string.sub(ST_leftText, ST_pomoc7 + 9, endBy - 1)
              ST_tlumaczenie = ST_TooltipsHS[ST_hash]
              if IsArabicLocale() then
                ST_tlumaczenie = string.gsub(ST_tlumaczenie, "NAMEBY", string.reverse(nameBy))
                ST_tlumaczenie = string.gsub(ST_tlumaczenie, "{$M}", string.reverse(nameBy))
              else
                ST_tlumaczenie = string.gsub(ST_tlumaczenie, "$M", nameBy)
              end
            else
              ST_tlumaczenie = ST_TooltipsHS[ST_hash]
            end
            ST_tlumaczenie = ST_TranslatePrepare(ST_leftText, ST_tlumaczenie)
            _font1, _size1, _1 = _G["GameTooltipTextLeft" .. i]:GetFont()
            _G["GameTooltipTextLeft" .. i]:SetFont(WOWTR_Font2, _size1)
            
            -- For short text (like "Back", "Chest", etc.), use simple RTL reverse instead of QTR_ExpandUnitInfo
            -- QTR_ExpandUnitInfo does line-breaking/shaping that can truncate short labels
            local isShortText = ST_leftText and string.len(ST_leftText) <= 15
            local expanded
            if isShortText and _G.QTR_ReverseIfAR then
              -- Use simple RTL reverse for short labels to avoid truncation
              expanded = QTR_ReverseIfAR(ST_tlumaczenie)
              if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
                WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                  "[GT.OnShow] Using QTR_ReverseIfAR for short label",
                  "| Line:", i,
                  "| Original:", string.sub(ST_leftText or "", 1, 50),
                  "| Translation:", string.sub(ST_tlumaczenie or "", 1, 50),
                  "| Result:", string.sub(expanded or "", 1, 50))
              end
            else
              -- Use QTR_ExpandUnitInfo for longer text
              expanded = QTR_ExpandUnitInfo(ST_tlumaczenie, false, _G["GameTooltipTextLeft" .. i], WOWTR_Font2, -5)
              
              -- Debug: Log what QTR_ExpandUnitInfo returned
              if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
                WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                  "[GT.OnShow] QTR_ExpandUnitInfo result",
                  "| Line:", i,
                  "| Original:", string.sub(ST_leftText or "", 1, 50),
                  "| Translation:", string.sub(ST_tlumaczenie or "", 1, 50),
                  "| Translation Length:", string.len(ST_tlumaczenie or ""),
                  "| Expanded:", string.sub(expanded or "", 1, 50),
                  "| Expanded Length:", string.len(expanded or ""))
              end
              
              -- Fallback: If shaping returned an unexpectedly short string, use simple RTL reverse
              if expanded and ST_tlumaczenie and string.len(expanded) <= 3 and string.len(ST_tlumaczenie) >= 4 then
                if QTR_ReverseIfAR then
                  expanded = QTR_ReverseIfAR(ST_tlumaczenie)
                  if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
                    WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                      "[GT.OnShow] Arabic fallback used for short label",
                      "| Line:", i,
                      "| Original:", string.sub(ST_leftText or "", 1, 50),
                      "| Translation:", string.sub(ST_tlumaczenie or "", 1, 50))
                  end
                else
                  expanded = ST_tlumaczenie
                end
              end
            end
            _G["GameTooltipTextLeft" .. i]:SetText((expanded or ST_tlumaczenie or "") .. NONBREAKINGSPACE)
            _G["GameTooltipTextLeft" .. i].wrap = true
            -- Debug: Log line translation
            if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
              WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                "[GT.OnShow] Line translated",
                "| Line:", i,
                "| Original:", string.sub(ST_leftText or "", 1, 50),
                "| Hash:", ST_hash,
                "| Translation:", string.sub(ST_tlumaczenie or "", 1, 50))
            end
            local gtProc3 = GameTooltip and rawget(GameTooltip, "processingInfo")
            local gtData3 = gtProc3 and gtProc3.tooltipData or nil
            if (gtData3 and gtData3.id and (gtData3.id == 6948)) then
              break
            end
          else
            if lineObj.SetFont then
              -- Check if captured font is WOWTR_Font2 (translation font), if so restore to original WoW font
              local restoreFont, restoreSize, restoreFlags = originalFont, originalSize, originalFlags
              if originalFont == _G.WOWTR_Font2 or (type(originalFont) == "string" and (string.find(originalFont, "WoWAR") or string.find(originalFont, "WOWTR"))) then
                if Utils and Utils.GetOriginalWoWFont then
                  restoreFont, restoreSize, restoreFlags = Utils.GetOriginalWoWFont()
                end
              end
              
              -- Check current font before restoration
              local currentFont, currentSize, currentFlags = lineObj:GetFont()
              lineObj:SetFont(restoreFont, restoreSize, restoreFlags)
              -- Debug: Log font restoration when no translation found with detailed frame info
              if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
                local frameName = lineObj.GetName and lineObj:GetName() or ("GameTooltipTextLeft" .. i)
                local afterFont, afterSize, afterFlags = lineObj:GetFont()
                local setSuccess = (afterFont == restoreFont) and (afterSize == restoreSize) and (afterFlags == restoreFlags)
                local fontChanged = (currentFont ~= restoreFont) or (currentSize ~= restoreSize) or (currentFlags ~= restoreFlags)
                WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS, 
                  "[Font Restored] No translation found for line", i,
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
                  "| Text:", string.sub(ST_leftText or "", 1, 50) .. (string.len(ST_leftText or "") > 50 and "..." or ""))
              end
            end
            ST_nh = 1
            table.insert(ST_orygText, ST_leftText)
          end
        end
      end
    end

    if (((ST_PM["showID"] == "1") and (string.len(ST_prefix) > 1)) or ((ST_PM["showHS"] == "1") and ST_hash2)) then
      numLines = GameTooltip:NumLines()
      if (numLines > 0 and ST_odstep) then
        GameTooltip:AddLine(" ", 0, 0, 0)
      end
      local typName = " "
      if (string.sub(ST_prefix, 1, 1) == "i") then
        typName = "Item"
        ST_ID = string.sub(ST_prefix, 2)
      elseif (string.sub(ST_prefix, 1, 1) == "s") then
        typName = "Spell"
        ST_ID = string.sub(ST_prefix, 2)
      elseif (string.sub(ST_prefix, 1, 1) == "t") then
        typName = "Talent"
        ST_ID = string.sub(ST_prefix, 2)
      else
        ST_ID = nil
      end
      if ((ST_PM["showID"] == "1") and ST_ID) then
        GameTooltip:AddLine(typName .. " ID: " .. tostring(ST_ID), 0, 1, 1)
        numLines = GameTooltip:NumLines()
        _G["GameTooltipTextLeft" .. numLines]:SetFont(WOWTR_Font2, 12)
        _G["GameTooltipTextRight" .. numLines]:SetFont(WOWTR_Font2, 12)
      end
      if ((ST_PM["showHS"] == "1") and ST_hash2) then
        GameTooltip:AddLine("Hash: " .. tostring(ST_hash2), 0, 1, 1)
        numLines = GameTooltip:NumLines()
        _G["GameTooltipTextLeft" .. numLines]:SetFont(WOWTR_Font2, 12)
        _G["GameTooltipTextRight" .. numLines]:SetFont(WOWTR_Font2, 12)
      end
    end

    if ((ST_PM["constantly"] == "1") and (UnitLevel("player") > 60) and _G["GameTooltipTextLeft1"]) then
      local titleTextOk, titleTextResult = pcall(function() return _G["GameTooltipTextLeft1"]:GetText() end)
      local titleText = (titleTextOk and titleTextResult and type(titleTextResult) == "string") and titleTextResult or nil
      if titleText then
        -- Check if text has NONBREAKINGSPACE (processed marker)
        local hasMarker = string.find(titleText, NONBREAKINGSPACE) ~= nil
        
        if hasMarker then
          -- Text is processed, check if it's actually translated by checking hash table
          local titleTextForHash = string.gsub(titleText, NONBREAKINGSPACE, "")
          local titleHash = StringHash(ST_UsunZbedneZnaki(titleTextForHash))
          local titleObj = _G["GameTooltipTextLeft1"]
          
          if (ST_TooltipsHS and ST_TooltipsHS[titleHash]) then
            -- Translation exists, ensure font is WOWTR_Font2
            if titleObj and titleObj.SetFont then
              local currentFont, currentSize, currentFlags = titleObj:GetFont()
              if currentFont ~= _G.WOWTR_Font2 then
                titleObj:SetFont(WOWTR_Font2, currentSize or 12, currentFlags or "")
              end
            end
            -- Debug: Log that we skipped restoration because text is translated
            if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
              WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                "[Constantly mode] Title translated, keeping WOWTR_Font2",
                "| Title Text:", string.sub(titleText or "", 1, 50) .. (string.len(titleText or "") > 50 and "..." or ""),
                "| Hash:", titleHash)
            end
          else
            -- Text is processed but not translated, and font is WOWTR_Font2 - keep it (ApplyTooltipFonts will handle restoration)
            -- Don't restore here to avoid conflicts with ApplyTooltipFonts
            local titleObj = _G["GameTooltipTextLeft1"]
            if titleObj and titleObj.SetFont then
              local currentFont = titleObj:GetFont()
              if currentFont == _G.WOWTR_Font2 then
                -- Keep WOWTR_Font2, ApplyTooltipFonts will handle restoration if needed
              end
            end
          end
        else
          -- Text not translated yet, check if translation exists
          local titleTextForHash = string.gsub(titleText, NONBREAKINGSPACE, "")
          local titleHash = StringHash(ST_UsunZbedneZnaki(titleTextForHash))
          if (ST_TooltipsHS and ST_TooltipsHS[titleHash]) then
            -- Translation exists, use WOWTR_Font2 (text will be translated by main loop)
            local titleObj = _G["GameTooltipTextLeft1"]
            if titleObj and titleObj.SetFont then
              local currentFont, currentSize, currentFlags = titleObj:GetFont()
              if currentFont ~= _G.WOWTR_Font2 then
                titleObj:SetFont(WOWTR_Font2, currentSize or 12, currentFlags or "")
              end
            end
          else
            -- No translation, restore original font
            local titleObj = _G["GameTooltipTextLeft1"]
            if titleObj and titleObj.SetFont then
              local currentFont, currentSize, currentFlags = titleObj:GetFont()
              if currentFont == _G.WOWTR_Font2 or (type(currentFont) == "string" and (string.find(currentFont, "WoWAR") or string.find(currentFont, "WOWTR"))) then
                local restoreFont, restoreSize, restoreFlags
                if Utils and Utils.GetOriginalWoWFont then
                  restoreFont, restoreSize, restoreFlags = Utils.GetOriginalWoWFont()
                  -- Use current size if available (preserve original size), otherwise use restored size
                  restoreSize = currentSize or restoreSize
                else
                  restoreFont, restoreSize, restoreFlags = currentFont, currentSize, currentFlags
                end
                titleObj:SetFont(restoreFont, restoreSize, restoreFlags)
                -- Debug: Log font restoration with detailed frame info
                if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
                  local frameName = titleObj.GetName and titleObj:GetName() or "GameTooltipTextLeft1"
                  local afterFont, afterSize, afterFlags = titleObj:GetFont()
                  local setSuccess = (afterFont == restoreFont) and (afterSize == restoreSize) and (afterFlags == restoreFlags)
                  WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                    "[Font Restored] Constantly mode: No translation found for title",
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
                    "| Title Text:", string.sub(titleText or "", 1, 50) .. (string.len(titleText or "") > 50 and "..." or ""))
                end
              end
            end
          end
        end
      end
    end
    
    -- Apply or reset RTL justification for tooltips (must happen AFTER all text is set)
    -- Set RIGHT if Arabic text is found, otherwise reset to LEFT (justification persists between shows)
    if WOWTR_Localization and WOWTR_Localization.lang == 'AR' then
      local numLinesToJustify = GameTooltip:NumLines()
      local hasArabic = false
      -- Check if any line contains Arabic text
      for i = 1, numLinesToJustify do
        local leftLine = _G["GameTooltipTextLeft" .. i]
        if leftLine and leftLine.GetText then
          local lineText = leftLine:GetText()
          if lineText and ContainsArabicText(lineText) then
            hasArabic = true
            break
          end
        end
      end
      -- Apply RIGHT for Arabic, LEFT for English (must reset because justification persists)
      local justify = hasArabic and "RIGHT" or "LEFT"
      for i = 1, numLinesToJustify do
        local leftLine = _G["GameTooltipTextLeft" .. i]
        if leftLine and leftLine.SetJustifyH then
          leftLine:SetJustifyH(justify)
        end
        local rightLine = _G["GameTooltipTextRight" .. i]
        if rightLine and rightLine.SetJustifyH then
          rightLine:SetJustifyH(justify)
        end
      end
    end
    
    GameTooltip:Show()
    ST_lastNumLines = GameTooltip:NumLines()

    if ((ST_orygText or (ST_nh == 1)) and (ST_PM["saveNW"] == "1")) then
      for _, ST_origin in ipairs(ST_orygText) do
        local ST_hash = StringHash(ST_UsunZbedneZnaki(ST_origin))
        if (string.sub(ST_origin, 1, 11) ~= '|A:raceicon') then
          local shouldSave = true
          for _, word in ipairs(ignoreSettings.words) do
            if string.find(ST_origin, word) then
              shouldSave = false
              break
            end
          end
          if shouldSave and string.find(ST_origin, ignoreSettings.pattern) then
            shouldSave = false
          end
          if shouldSave then
            ST_PH[ST_hash] = ST_prefix .. "@" .. ST_PrzedZapisem(ST_origin)
          end
        end
      end
    end
  end
end

-- Migrate selected helpers for future use by Hooks when we switch over
function GT.IsBuffOrDebuffTooltip()
  local elvBuff = rawget(_G, "ElvUIPlayerBuffs")
  local elvDebuff = rawget(_G, "ElvUIPlayerDebuffs")
  local isBuff = BuffFrame and BuffFrame:IsMouseOver()
  local isDebuff = DebuffFrame and DebuffFrame:IsMouseOver()
  local isElvBuff = elvBuff and elvBuff:IsMouseOver()
  local isElvDebuff = elvDebuff and elvDebuff:IsMouseOver()
  return (isBuff or isDebuff or isElvBuff or isElvDebuff) and true or false
end

function GT.ElvSpellBookTooltipOnShow()
  local elvUI = rawget(_G, "ElvUI")
  if not elvUI then return end
  local E, L, V, P, G = unpack(elvUI)
  local ElvUISpellBookTooltip = E and E.SpellBookTooltip
  if not ElvUISpellBookTooltip then return end
  local numLines = ElvUISpellBookTooltip:NumLines()
  if (numLines == 1) then return end
  if (ST_PM and ST_PM["spell"] == "0") then return end

  local ST_kodKoloru
  local ST_leftText, ST_rightText, ST_tlumaczenie, ST_hash, ST_hash2
  local _font1, _size1, _1
  local ST_prefix = "s"
  local procInfo = rawget(ElvUISpellBookTooltip, "processingInfo")
  local ttData = procInfo and procInfo.tooltipData or nil
  if (ttData and ttData.id) then
    ST_prefix = ST_prefix .. ttData.id
  end
  ElvUISpellBookTooltip:HookScript("OnHide", function() ST_MyGameTooltip:Hide() end)
  ST_MyGameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
  ST_MyGameTooltip:ClearAllPoints()
  ST_MyGameTooltip:SetPoint("TOPLEFT", ElvUISpellBookTooltip, "BOTTOMLEFT", 0, 0)
  ST_MyGameTooltip:ClearLines()
  for i = 2, numLines - 1, 1 do
    local leftTextOk, leftTextResult = pcall(function() return _G[ElvUISpellBookTooltip:GetName() .. "TextLeft" .. i]:GetText() end)
    ST_leftText = (leftTextOk and leftTextResult and type(leftTextResult) == "string") and leftTextResult or nil
    if ST_leftText then
      leftColR, leftColG, leftColB = _G[ElvUISpellBookTooltip:GetName() .. "TextLeft" .. i]:GetTextColor()
      ST_kodKoloru = OkreslKodKoloru(leftColR, leftColG, leftColB)
      if ((string.len(ST_leftText) > 15) and ((ST_kodKoloru == "c7") or (ST_kodKoloru == "c4") or (string.len(ST_leftText) > 30))) then
        ST_hash = StringHash(ST_UsunZbedneZnaki(ST_leftText))
        if (((ST_kodKoloru == "c7") or (string.len(ST_leftText) > 30)) and (not ST_hash2)) then
          ST_hash2 = ST_hash
        end
        if (ST_TooltipsHS and ST_TooltipsHS[ST_hash]) then
          ST_tlumaczenie = ST_TooltipsHS[ST_hash]
          ST_tlumaczenie = ST_TranslatePrepare(ST_leftText, ST_tlumaczenie)
          ST_MyGameTooltip:AddLine(QTR_ReverseIfAR(ST_tlumaczenie), leftColR, leftColG, leftColB, true)
          numLines = ST_MyGameTooltip:NumLines()
          _font1, _size1, _1 = _G[ElvUISpellBookTooltip:GetName() .. "TextLeft" .. i]:GetFont()
          _G["ST_MyGameTooltipTextLeft" .. numLines]:SetFont(WOWTR_Font2, 11)
        end
      end
    end
  end

  if (((ST_PM["showID"] == "1") and (string.len(ST_prefix) > 1)) or ((ST_PM["showHS"] == "1") and ST_hash2)) then
    numLines = ST_MyGameTooltip:NumLines()
    if (numLines == 0) then
      local qtrMsg = rawget(_G, "QTR_Messages")
      ST_MyGameTooltip:AddLine((qtrMsg and qtrMsg.missing) or "Missing", 1, 1, 0.5)
      _G["ST_MyGameTooltipTextLeft1"]:SetFont(WOWTR_Font2, 11)
    end
    ST_MyGameTooltip:AddLine(" ", 0, 0, 0)
    local typName = "Spell"
    local ST_ID = string.sub(ST_prefix, 2)
    if ((ST_PM["showID"] == "1") and ST_ID) then
      ST_MyGameTooltip:AddLine(typName .. " ID: " .. tostring(ST_ID), 0, 1, 1)
      numLines = ST_MyGameTooltip:NumLines()
      _G["ST_MyGameTooltipTextLeft" .. numLines]:SetFont(WOWTR_Font2, 10)
    end
    if ((ST_PM["showHS"] == "1") and ST_hash2) then
      ST_MyGameTooltip:AddLine("Hash: " .. tostring(ST_hash2), 0, 1, 1)
      numLines = ST_MyGameTooltip:NumLines()
      _G["ST_MyGameTooltipTextLeft" .. numLines]:SetFont(WOWTR_Font2, 10)
    end
  end

  -- Apply or reset RTL justification for ElvUI SpellBook tooltip
  if WOWTR_Localization and WOWTR_Localization.lang == 'AR' then
    local numLinesToJustify = ST_MyGameTooltip:NumLines()
    local hasArabic = false
    for i = 1, numLinesToJustify do
      local leftLine = _G["ST_MyGameTooltipTextLeft" .. i]
      if leftLine and leftLine.GetText then
        local lineText = leftLine:GetText()
        if lineText and ContainsArabicText(lineText) then
          hasArabic = true
          break
        end
      end
    end
    local justify = hasArabic and "RIGHT" or "LEFT"
    for i = 1, numLinesToJustify do
      local leftLine = _G["ST_MyGameTooltipTextLeft" .. i]
      if leftLine and leftLine.SetJustifyH then
        leftLine:SetJustifyH(justify)
      end
    end
  end

  ST_MyGameTooltip:Show()
end

function GT.BuffOrDebuff()
  local leftText2Ok, leftText2Result = pcall(function() return _G["GameTooltipTextLeft2"] and _G["GameTooltipTextLeft2"]:GetText() end)
  local ST_leftText2 = (leftText2Ok and leftText2Result and type(leftText2Result) == "string") and leftText2Result or nil
  if ST_leftText2 then
    local ST_hash = StringHash(ST_UsunZbedneZnaki(ST_leftText2))
    if (ST_TooltipsHS and ST_TooltipsHS[ST_hash]) then
      local ST_tlumaczenie = ST_TooltipsHS[ST_hash]
      ST_tlumaczenie = ST_TranslatePrepare(ST_leftText2, ST_tlumaczenie)
      local leftColR, leftColG, leftColB = _G["GameTooltipTextLeft2"]:GetTextColor()

      if not GameTooltip.OnHideHooked then
        GameTooltip:HookScript("OnHide", function()
          C_Timer.After(0.01, function()
            ST_MyGameTooltip:Hide()
          end)
        end)
        GameTooltip.OnHideHooked = true
      end

      ST_MyGameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
      ST_MyGameTooltip:ClearAllPoints()
      ST_MyGameTooltip:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", 0, 0)
      ST_MyGameTooltip:ClearLines()
      if IsArabicLocale() then
        ST_MyGameTooltip:AddLine(QTR_ExpandUnitInfo(ST_tlumaczenie, false, ST_MyGameTooltip, WOWTR_Font2), leftColR, leftColG, leftColB, true)
      else
        ST_MyGameTooltip:AddLine(QTR_ReverseIfAR(ST_tlumaczenie), leftColR, leftColG, leftColB, true)
      end
      _G["ST_MyGameTooltipTextLeft1"]:SetFont(WOWTR_Font2, 12)
      if (ST_PM["showHS"] == "1") then
        ST_MyGameTooltip:AddLine(" ", 0, 0, 0)
        ST_MyGameTooltip:AddLine("Hash: " .. tostring(ST_hash), 0, 1, 1)
        _G["ST_MyGameTooltipTextLeft3"]:SetFont(WOWTR_Font2, 12)
      end
      -- Apply or reset RTL justification for buff/debuff tooltip
      if WOWTR_Localization and WOWTR_Localization.lang == 'AR' then
        local numLinesToJustify = ST_MyGameTooltip:NumLines()
        local hasArabic = false
        for i = 1, numLinesToJustify do
          local leftLine = _G["ST_MyGameTooltipTextLeft" .. i]
          if leftLine and leftLine.GetText then
            local lineText = leftLine:GetText()
            if lineText and ContainsArabicText(lineText) then
              hasArabic = true
              break
            end
          end
        end
        local justify = hasArabic and "RIGHT" or "LEFT"
        for i = 1, numLinesToJustify do
          local leftLine = _G["ST_MyGameTooltipTextLeft" .. i]
          if leftLine and leftLine.SetJustifyH then
            leftLine:SetJustifyH(justify)
          end
        end
      end
      ST_MyGameTooltip:Show()
    elseif ((ST_PM and ST_PM["saveNW"] == "1")) then
      local gtProc = GameTooltip and rawget(GameTooltip, "processingInfo")
      local gtData = gtProc and gtProc.tooltipData or nil
      local ST_prefix = (gtData and gtData.id) and ("s" .. tostring(gtData.id)) or "s0"
      ST_PH[ST_hash] = ST_prefix .. "@" .. ST_PrzedZapisem(ST_leftText2)
    end
  end
end

function GT.CurrentEquipped(obj)
  if ((ST_PM and ST_PM["active"] == "1") and (ST_PM["item"] == "1")) then
    local processingInfo = obj and rawget(obj, "processingInfo")
    local tooltipData = processingInfo and processingInfo.tooltipData or nil
    if (tooltipData and tooltipData.id) then
      ST_prefix = "i" .. tooltipData.id
      local ST_kodKoloru
      local ST_leftText, ST_rightText, ST_tlumaczenie, ST_hash, ST_hash2
      local _font1, _size1, _1
      local ST_odstep = true
      local ST_orygText = {}
      local ST_nh = 0
      local numLines = obj:NumLines()

      local moneyFrameLineNumber = {}
      local money = {}
      table.insert(moneyFrameLineNumber, 0)
      table.insert(money, 0)
      local objShown = rawget(obj, "shownMoneyFrames")
      if (objShown) then
        for i = 1, objShown, 1 do
          local moneyFrameName = obj:GetName() .. "MoneyFrame" .. i
          _G[moneyFrameName .. "PrefixText"]:SetText(QTR_ReverseIfAR(LocString("sellPrice", ": Sell price")))
          _font1, _size1, _1 = _G[moneyFrameName .. "PrefixText"]:GetFont()
          _G[moneyFrameName .. "PrefixText"]:SetFont(WOWTR_Font2, _size1)
          if (ST_PM["sellprice"] == "1") then
            _G[moneyFrameName]:Hide()
            ST_odstep = false
          end
        end
      end

      local leftText1Ok, leftText1Result = pcall(function() return _G[obj:GetName() .. "TextLeft1"]:GetText() end)
      ST_leftText = (leftText1Ok and leftText1Result and type(leftText1Result) == "string") and leftText1Result or nil
      if (ST_leftText) then
        if (string.find(ST_leftText, NONBREAKINGSPACE) == nil) then
          if (ST_leftText == "Currently Equipped") then
            ST_info = LocString("currentlyEquipped", "Currently Equipped")
          elseif (ST_leftText == "Equipped With") then
            ST_info = LocString("additionalEquipped", "Equipped With")
          else
            ST_info = ST_leftText
          end
          if ((ST_info == ST_leftText) and (string.len(ST_leftText) > 2) and (string.sub(ST_leftText, 1, 2) ~= "|T")) then
          else
            _font1, _size1, _1 = _G[obj:GetName() .. "TextLeft1"]:GetFont()
            _G[obj:GetName() .. "TextLeft1"]:SetText(QTR_ReverseIfAR(ST_info) .. NONBREAKINGSPACE)
            _G[obj:GetName() .. "TextLeft1"]:SetFont(WOWTR_Font2, _size1)
          end
        end
      end

      local leftText2Ok, leftText2Result = pcall(function() return _G[obj:GetName() .. "TextLeft2"]:GetText() end)
      local leftText2 = (leftText2Ok and leftText2Result and type(leftText2Result) == "string") and leftText2Result or ""
      ST_pomoc0, _ = string.find(leftText2, NONBREAKINGSPACE)
      local ST_TooltipID_gl = rawget(_G, "ST_TooltipID")
      local ST_TooltipsID_gl = rawget(_G, "ST_TooltipsID")
      local ST_itemID_gl = rawget(_G, "ST_itemID")
      if (ST_TooltipID_gl and (ST_pomoc0 == nil) and (ST_TooltipsID_gl and ST_TooltipsID_gl[ST_prefix .. tostring(ST_itemID_gl)]) and (ST_PM["transtitle"] == "1")) then
        _G[obj:GetName() .. "TextLeft2"]:SetText(QTR_ExpandUnitInfo(ST_TooltipsID_gl[ST_prefix .. tostring(ST_itemID_gl)]), WOWTR_Font2)
        _font1, _size1, _1 = _G[obj:GetName() .. "TextLeft2"]:GetFont()
        _G[obj:GetName() .. "TextLeft2"]:SetFont(WOWTR_Font2, _size1)
      end

      for i = 3, numLines, 1 do
        local leftTextOk, leftTextResult = pcall(function() return _G[obj:GetName() .. "TextLeft" .. i]:GetText() end)
        ST_leftText = (leftTextOk and leftTextResult and type(leftTextResult) == "string") and leftTextResult or nil
        if (ST_leftText and (string.find(ST_leftText, NONBREAKINGSPACE) == nil)) then
          leftColR, leftColG, leftColB = _G[obj:GetName() .. "TextLeft" .. i]:GetTextColor()
          ST_kodKoloru = OkreslKodKoloru(leftColR, leftColG, leftColB)
          if (ST_leftText and (string.len(ST_leftText) > 15) and ((ST_kodKoloru == "c7") or (ST_kodKoloru == "c4") or (string.len(ST_leftText) > 30))) then
            local lineObj = _G[obj:GetName() .. "TextLeft" .. i]
            local originalFont, originalSize, originalFlags = lineObj:GetFont()
            ST_hash = StringHash(ST_UsunZbedneZnaki(ST_leftText))
            if (((ST_kodKoloru == "c7") or (string.len(ST_leftText) > 30)) and (not ST_hash2)) then
              ST_hash2 = ST_hash
            end
            if (ST_TooltipsHS and ST_TooltipsHS[ST_hash]) then
              ST_tlumaczenie = ST_TooltipsHS[ST_hash]
              ST_tlumaczenie = ST_TranslatePrepare(ST_leftText, ST_tlumaczenie)
              _font1, _size1, _1 = _G[obj:GetName() .. "TextLeft" .. i]:GetFont()
              _G[obj:GetName() .. "TextLeft" .. i]:SetFont(WOWTR_Font2, _size1)
              _G[obj:GetName() .. "TextLeft" .. i]:SetText(QTR_ExpandUnitInfo(ST_tlumaczenie, false, _G["GameTooltipTextLeft" .. i], WOWTR_Font2) .. NONBREAKINGSPACE)
              _G[obj:GetName() .. "TextLeft" .. i].wrap = true
            else
              if lineObj.SetFont then
                -- Check if captured font is WOWTR_Font2 (translation font), if so restore to original WoW font
                local restoreFont, restoreSize, restoreFlags = originalFont, originalSize, originalFlags
                if originalFont == _G.WOWTR_Font2 or (type(originalFont) == "string" and (string.find(originalFont, "WoWAR") or string.find(originalFont, "WOWTR"))) then
                  if Utils and Utils.GetOriginalWoWFont then
                    restoreFont, restoreSize, restoreFlags = Utils.GetOriginalWoWFont()
                  end
                end
                
                -- Check current font before restoration
                local currentFont, currentSize, currentFlags = lineObj:GetFont()
                lineObj:SetFont(restoreFont, restoreSize, restoreFlags)
                -- Debug: Log font restoration when no translation found with detailed frame info
                if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
                  local frameName = lineObj.GetName and lineObj:GetName() or (obj:GetName() .. "TextLeft" .. i)
                  local afterFont, afterSize, afterFlags = lineObj:GetFont()
                  local setSuccess = (afterFont == restoreFont) and (afterSize == restoreSize) and (afterFlags == restoreFlags)
                  local fontChanged = (currentFont ~= restoreFont) or (currentSize ~= restoreSize) or (currentFlags ~= restoreFlags)
                  WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                    "[Font Restored] GT.CurrentEquipped: No translation found for line", i,
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
                    "| Text:", string.sub(ST_leftText or "", 1, 50) .. (string.len(ST_leftText or "") > 50 and "..." or ""))
                end
              end
              ST_nh = 1
              table.insert(ST_orygText, ST_leftText)
            end
          end
        end
      end

      if (((ST_PM["showID"] == "1") and (string.len(ST_prefix) > 1)) or ((ST_PM["showHS"] == "1") and ST_hash2)) then
        numLines = obj:NumLines()
        if (numLines > 0 and ST_odstep) then
          obj:AddLine(" ", 0, 0, 0)
        end
        local typName = " "
        if (string.sub(ST_prefix, 1, 1) == "i") then
          typName = "Item"
          ST_ID = string.sub(ST_prefix, 2)
        elseif (string.sub(ST_prefix, 1, 1) == "s") then
          typName = "Spell"
          ST_ID = string.sub(ST_prefix, 2)
        elseif (string.sub(ST_prefix, 1, 1) == "t") then
          typName = "Talent"
          ST_ID = string.sub(ST_prefix, 2)
        else
          ST_ID = nil
        end
        if ((ST_PM["showID"] == "1") and ST_ID) then
          obj:AddLine(typName .. " ID: " .. tostring(ST_ID), 0, 1, 1)
          numLines = obj:NumLines()
          _G[obj:GetName() .. "TextLeft" .. numLines]:SetFont(WOWTR_Font2, 12)
          _G[obj:GetName() .. "TextRight" .. numLines]:SetFont(WOWTR_Font2, 12)
        end
        if ((ST_PM["showHS"] == "1") and ST_hash2) then
          obj:AddLine("Hash: " .. tostring(ST_hash2), 0, 1, 1)
          numLines = obj:NumLines()
          _G[obj:GetName() .. "TextLeft" .. numLines]:SetFont(WOWTR_Font2, 12)
          _G[obj:GetName() .. "TextRight" .. numLines]:SetFont(WOWTR_Font2, 12)
        end
      end

      -- Apply or reset RTL justification for compare tooltips
      if WOWTR_Localization and WOWTR_Localization.lang == 'AR' then
        local objName = obj:GetName()
        local numLinesToJustify = obj:NumLines()
        local hasArabic = false
        for i = 1, numLinesToJustify do
          local leftLine = _G[objName .. "TextLeft" .. i]
          if leftLine and leftLine.GetText then
            local lineText = leftLine:GetText()
            if lineText and ContainsArabicText(lineText) then
              hasArabic = true
              break
            end
          end
        end
        local justify = hasArabic and "RIGHT" or "LEFT"
        for i = 1, numLinesToJustify do
          local leftLine = _G[objName .. "TextLeft" .. i]
          if leftLine and leftLine.SetJustifyH then
            leftLine:SetJustifyH(justify)
          end
          local rightLine = _G[objName .. "TextRight" .. i]
          if rightLine and rightLine.SetJustifyH then
            rightLine:SetJustifyH(justify)
          end
        end
      end

      obj:Show()

      if ((ST_orygText or (ST_nh == 1)) and (ST_PM["saveNW"] == "1")) then
        for _, ST_origin in ipairs(ST_orygText) do
          ST_hash = StringHash(ST_UsunZbedneZnaki(ST_origin))
          if ((not ST_TooltipsHS or not ST_TooltipsHS[ST_hash]) and (string.find(ST_origin, NONBREAKINGSPACE) == nil)) then
            ST_PH[ST_hash] = ST_prefix .. "@" .. ST_PrzedZapisem(ST_origin)
          end
        end
      end
    end
  end
end


return GT


