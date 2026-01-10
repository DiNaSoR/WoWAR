local addonName, ns = ...

ns = ns or {}
ns.Tooltips = ns.Tooltips or {}
local Tooltips = ns.Tooltips
local State = (Tooltips and Tooltips.State) or {}

Tooltips.Hooks = Tooltips.Hooks or {}
local Hooks = Tooltips.Hooks
local Core = ns.Core
-- NOTE: ns.RTL is accessed dynamically at runtime, NOT cached here, because RTL.lua loads after Hooks.lua in the TOC.

-- Hook tooltip frames to use WOWTR_Font2 for Arabic (moved from common/Config/Core.lua)
local TooltipsHooked = false
-- Cache to track processed frames and prevent excessive processing
local processedFrames = {}
local function ApplyTooltipFonts(tt)
  if not tt or not tt.GetRegions then return end
  if not (WOWTR_Localization and WOWTR_Localization.lang == 'AR' and WOWTR_Font2) then return end

  -- For Arabic tooltips, enforce RTL-feeling layout via justification (no anchor mirroring).
  -- This ensures shaped Arabic lines render aligned to the RIGHT edge of the tooltip.
  -- Resets to LEFT for non-Arabic tooltips (justification persists between shows).
  local function ApplyRTLJustifyToTooltipLines(tooltipFrame)
    if not tooltipFrame or not tooltipFrame.GetName then return end
    -- Access ns.RTL at runtime (not cached at load time) because RTL.lua loads after this file
    local RTL = ns and ns.RTL
    if not (RTL and RTL.IsRTL and RTL.IsRTL()) then return end
    local name = tooltipFrame:GetName()
    if not name or name == "" then return end
    
    -- First check if any line contains Arabic text
    local hasArabic = false
    local TextModule = _G.Text or (ns and ns.Text)
    local ContainsArabic = TextModule and TextModule.ContainsArabic
    for i = 1, 40 do
      local left = _G[name .. "TextLeft" .. i]
      if left and left.GetText then
        local lineText = left:GetText()
        if lineText and ContainsArabic and ContainsArabic(lineText) then
          hasArabic = true
          break
        end
      end
    end
    
    -- Apply RIGHT for Arabic, LEFT for English (must reset because justification persists)
    local justify = hasArabic and "RIGHT" or "LEFT"
    for i = 1, 40 do
      local left = _G[name .. "TextLeft" .. i]
      if left and left.SetJustifyH then
        pcall(left.SetJustifyH, left, justify)
      end
      local right = _G[name .. "TextRight" .. i]
      if right and right.SetJustifyH then
        pcall(right.SetJustifyH, right, justify)
      end
    end
  end
  
  -- Helper function to get original WoW font
  local function GetOriginalWoWFont()
    if _G.ST_GetOriginalWoWFont then
      return _G.ST_GetOriginalWoWFont()
    end
    -- Fallback to default WoW font
    return "Fonts\\FRIZQT__.TTF", 12, ""
  end
  
  -- Count processed FontStrings for debugging
  local checkedCount = 0      -- Total FontStrings checked
  local processedCount = 0   -- FontStrings that had fonts changed
  local translationCount = 0 -- FontStrings with translations
  local restoreCount = 0     -- FontStrings restored to original font
  local skippedCount = 0     -- FontStrings skipped (empty or cached)
  
  local function setFS(fs)
    if not fs or not fs.SetFont then return end
    local ok, currentFont, size, flags = pcall(fs.GetFont, fs)
    if not ok or not size then size = 13 end
    local f = type(flags) == "string" and flags or ""
    local frameName = fs.GetName and fs:GetName() or "unknown"
    local textOk, textResult = pcall(function() 
      if fs.GetText then
        return fs:GetText()
      end
      return nil
    end)
    
    -- Count all FontStrings checked
    checkedCount = checkedCount + 1
    
    -- Test if we can actually use the text value (secret values fail here)
    local text = nil
    if textOk and textResult ~= nil then
      -- Try to use the value as a string - secret values will fail this test
      -- We test the actual operations we'll need: comparison and length
      local canUse, usableText = pcall(function()
        -- Test comparison (secret values fail here)
        local isEmpty = (textResult == "")
        -- Test length (secret values fail here)
        local len = string.len(textResult)
        -- If we got here, the value is usable - return it
        return textResult
      end)
      
      if canUse and usableText ~= nil then
        -- Double-check it's actually a string type
        if type(usableText) == "string" then
          text = usableText
        else
          -- Not a string type - skip
          skippedCount = skippedCount + 1
          return
        end
      else
        -- Secret value detected - skip this frame
        skippedCount = skippedCount + 1
        return
      end
    end
    
    -- Skip empty frames
    if not text or text == "" then
      skippedCount = skippedCount + 1
      return
    end
    
    -- Check if text already has NONBREAKINGSPACE (processed marker)
    local isProcessed = string.find(text, NONBREAKINGSPACE) ~= nil
    
    -- Create cache key for this frame+text combination
    local cacheKey = frameName .. "|" .. text
    local cached = processedFrames[cacheKey]
    
    -- If cached and font is already correct, skip
    if cached and cached.font == currentFont then
      skippedCount = skippedCount + 1
      return
    end
    
    -- Check if text has a translation in hash table
    local hasTranslation = false
    local translationReason = ""
    local hash = nil
    
    if text and text ~= "" and _G.StringHash and _G.ST_UsunZbedneZnaki then
      -- Remove NONBREAKINGSPACE for hash lookup (it's just a processing marker)
      local textForHash = string.gsub(text, NONBREAKINGSPACE, "")
      hash = StringHash(ST_UsunZbedneZnaki(textForHash))
      local hs = rawget(_G, "ST_TooltipsHS")
      if hs and hs[hash] then
        hasTranslation = true
        translationReason = "Hash:" .. tostring(hash)
      end
    end
    
    -- Special case: If text has NONBREAKINGSPACE and font is already WOWTR_Font2,
    -- keep it as WOWTR_Font2 (it was already translated, don't restore)
    -- This prevents restoring font when checking translated Arabic text
    if isProcessed and currentFont == _G.WOWTR_Font2 and not hasTranslation then
      -- Text is processed but hash check failed (likely translated text being re-checked)
      -- Keep WOWTR_Font2 if it's already set
      hasTranslation = true
      translationReason = "Processed with WOWTR_Font2 (keep)"
    end
    
    -- NONBREAKINGSPACE alone is NOT enough to mark as translated
    -- We need either a hash translation OR the font is already WOWTR_Font2 with NONBREAKINGSPACE
    
    -- Determine target font
    local targetFont, targetSize, targetFlags
    if hasTranslation then
      targetFont, targetSize, targetFlags = WOWTR_Font2, size, f
    else
      targetFont, targetSize, targetFlags = GetOriginalWoWFont()
      targetSize = targetSize or size
      targetFlags = targetFlags or f
    end
    
    -- Only process if font needs to change or if not cached
    local fontNeedsChange = (currentFont ~= targetFont) or 
                           (currentFont == WOWTR_Font2 and not hasTranslation) or
                           (currentFont ~= WOWTR_Font2 and hasTranslation)
    
    if fontNeedsChange or not cached then
      -- Only restore if current font is WOWTR_Font2 and no translation, or if translation exists and font is not WOWTR_Font2
      if (not hasTranslation and (currentFont == WOWTR_Font2 or (type(currentFont) == "string" and (string.find(currentFont, "WoWAR") or string.find(currentFont, "WOWTR"))))) or
         (hasTranslation and currentFont ~= WOWTR_Font2) then
        pcall(fs.SetFont, fs, targetFont, targetSize, targetFlags)
        
        -- If translation found and text doesn't already have NONBREAKINGSPACE, translate the text
        -- NOTE: GT.OnShow() handles most translations, so ApplyTooltipFonts should only translate
        -- if GT.OnShow() hasn't already done it (i.e., text doesn't have NONBREAKINGSPACE yet)
        if hasTranslation and hash and not string.find(text, NONBREAKINGSPACE) then
          local hs = rawget(_G, "ST_TooltipsHS")
          if hs and hs[hash] and fs.SetText then
            local ST_tlumaczenie = hs[hash]
            -- Use ST_TranslatePrepare if available
            if _G.ST_TranslatePrepare then
              ST_tlumaczenie = ST_TranslatePrepare(text, ST_tlumaczenie)
            end
            -- For short text (like "Back", "Chest", etc.), use simple RTL reverse instead of QTR_ExpandUnitInfo
            -- QTR_ExpandUnitInfo does line-breaking/shaping that can truncate short labels
            local isShortText = text and string.len(text) <= 15
            local translatedText
            if isShortText and _G.QTR_ReverseIfAR then
              -- Use simple RTL reverse for short labels to avoid truncation
              translatedText = QTR_ReverseIfAR(ST_tlumaczenie) .. NONBREAKINGSPACE
              -- Debug: Log the translation attempt
              if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
                WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                  "[ApplyTooltipFonts] Translating text (short, using QTR_ReverseIfAR)",
                  "| Frame:", frameName,
                  "| Original:", string.sub(text or "", 1, 50),
                  "| Translation:", string.sub(ST_tlumaczenie or "", 1, 50),
                  "| Result:", string.sub(translatedText or "", 1, 50))
              end
            elseif _G.QTR_ExpandUnitInfo then
              -- Use QTR_ExpandUnitInfo for longer text
              translatedText = QTR_ExpandUnitInfo(ST_tlumaczenie, false, fs, WOWTR_Font2, -5) .. NONBREAKINGSPACE
              -- Debug: Log the translation attempt
              if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
                WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
                  "[ApplyTooltipFonts] Translating text",
                  "| Frame:", frameName,
                  "| Original:", string.sub(text or "", 1, 50),
                  "| Translation:", string.sub(ST_tlumaczenie or "", 1, 50),
                  "| Expanded:", string.sub(translatedText or "", 1, 50))
              end
            else
              translatedText = ST_tlumaczenie .. NONBREAKINGSPACE
            end
            pcall(fs.SetText, fs, translatedText)
          end
        end
        
        -- Debug: Log font changes (only when actually changing)
        if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
          local afterFont, afterSize, afterFlags = fs:GetFont()
          local afterText = fs.GetText and fs:GetText() or text
          local setSuccess = (afterFont == targetFont) and (math.abs((afterSize or 0) - (targetSize or 0)) < 0.1)
          
          if hasTranslation then
            WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
              "[ApplyTooltipFonts] Translation found, setting WOWTR_Font2",
              "| Frame:", frameName,
              "| Reason:", translationReason,
              "| Hash:", hash or "nil",
              "| Before Font:", currentFont or "nil",
              "| After Font:", afterFont or "nil",
              "| SetFont Success:", setSuccess and "YES" or "NO",
              "| Before Text:", string.sub(text or "", 1, 50) .. (string.len(text or "") > 50 and "..." or ""),
              "| After Text:", string.sub(afterText or "", 1, 50) .. (string.len(afterText or "") > 50 and "..." or ""))
          else
            WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
              "[ApplyTooltipFonts] No translation, restoring original font",
              "| Frame:", frameName,
              "| Hash:", hash or "nil",
              "| Before Font:", currentFont or "nil",
              "| Restored Font:", targetFont or "nil",
              "| After Font:", afterFont or "nil",
              "| SetFont Success:", setSuccess and "YES" or "NO",
              "| Text:", string.sub(text or "", 1, 50) .. (string.len(text or "") > 50 and "..." or ""))
          end
        end
        
        -- Cache this frame+text combination
        processedFrames[cacheKey] = {
          font = targetFont,
          hasTranslation = hasTranslation,
          time = GetTime()
        }
        
        -- Increment counters for summary
        processedCount = processedCount + 1
        if hasTranslation then
          translationCount = translationCount + 1
        else
          restoreCount = restoreCount + 1
        end
      end
    end
  end

  local regions = { tt:GetRegions() }
  for _, r in pairs(regions) do
    if r and r.GetObjectType and r:GetObjectType() == "FontString" then
      local oldCount = processedCount
      setFS(r)
      if processedCount > oldCount then
        -- Count was incremented in setFS
      end
    end
  end

  local name = tt.GetName and tt:GetName() or nil
  if name then
    for i = 1, 40 do
      setFS(_G[name .. "TextLeft" .. i])
      setFS(_G[name .. "TextRight" .. i])
    end
  end

  -- Apply RTL justification after any font/text updates.
  ApplyRTLJustifyToTooltipLines(tt)
  
  -- Debug: Log summary only when fonts are actually changed (to reduce spam)
  if processedCount > 0 and WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
    local tooltipName = name or (tt.GetName and tt:GetName()) or "unknown"
    WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
      "[ApplyTooltipFonts] Summary",
      "| Tooltip:", tooltipName,
      "| Checked FontStrings:", checkedCount,
      "| Changed Fonts:", processedCount,
      "| With Translation:", translationCount,
      "| Restored:", restoreCount,
      "| Skipped (empty/cached):", skippedCount)
  end
end

local function HookTooltipFonts()
  if TooltipsHooked then return end
  -- Ensure base tooltip FontObjects use WOWTR_Font2
  -- NOTE: These FontObjects are templates - new tooltip lines inherit from them
  -- They are ALWAYS set to WOWTR_Font2 (not conditional on translations)
  -- Individual FontStrings are then checked and restored if no translation exists
  if WOWTR_Localization and WOWTR_Localization.lang == 'AR' and WOWTR_Font2 then
    local function SetFO(obj, objName)
      if not obj then return end
      local ok, currentFont, size, flags = pcall(obj.GetFont, obj)
      if not ok or not size then size = 13 end
      local f = type(flags) == "string" and flags or ""
      pcall(obj.SetFont, obj, WOWTR_Font2, size, f)
      
      -- Debug: Log FontObject changes
      if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
        WOWTR.Debug.Normal(WOWTR.Debug.Categories.TOOLTIPS,
          "[HookTooltipFonts] Setting FontObject template",
          "| FontObject:", objName or "unknown",
          "| Before Font:", currentFont or "nil",
          "| Set to: WOWTR_Font2",
          "| Size:", size or "nil",
          "| Note: This is a template - individual FontStrings are checked separately")
      end
    end
    SetFO(_G.GameTooltipHeaderText, "GameTooltipHeaderText")
    SetFO(_G.GameTooltipText, "GameTooltipText")
    SetFO(_G.GameTooltipTextSmall, "GameTooltipTextSmall")
    SetFO(_G.Tooltip_Med, "Tooltip_Med")
    SetFO(_G.Tooltip_Small, "Tooltip_Small")
  end

  local names = { "GameTooltip", "ItemRefTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ShoppingTooltip3", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "ItemRefShoppingTooltip3", "ST_MyGameTooltip" }
  for _, n in ipairs(names) do
    local tt = _G[n]
    if tt and tt.HookScript then
      tt:HookScript("OnShow", ApplyTooltipFonts)
      if tt:HasScript("OnTooltipSetText") then tt:HookScript("OnTooltipSetText", ApplyTooltipFonts) end
      if tt:HasScript("OnTooltipSetItem") then tt:HookScript("OnTooltipSetItem", ApplyTooltipFonts) end
      if tt:HasScript("OnTooltipSetSpell") then tt:HookScript("OnTooltipSetSpell", ApplyTooltipFonts) end
      if tt:HasScript("OnTooltipSetUnit") then tt:HookScript("OnTooltipSetUnit", ApplyTooltipFonts) end
      -- Clear cache and reset justification when tooltip is hidden
      if tt:HasScript("OnHide") then
        tt:HookScript("OnHide", function()
          -- Clear cache for this tooltip's frames
          local ttName = tt:GetName()
          if ttName then
            for key, _ in pairs(processedFrames) do
              if string.find(key, "^" .. ttName) then
                processedFrames[key] = nil
              end
            end
            -- Reset justification to LEFT on hide so next tooltip starts fresh
            -- This fixes the "sticky RIGHT" issue when switching from Arabic to English tooltips
            if WOWTR_Localization and WOWTR_Localization.lang == 'AR' then
              for i = 1, 40 do
                local left = _G[ttName .. "TextLeft" .. i]
                if left and left.SetJustifyH then
                  pcall(left.SetJustifyH, left, "LEFT")
                end
                local right = _G[ttName .. "TextRight" .. i]
                if right and right.SetJustifyH then
                  pcall(right.SetJustifyH, right, "LEFT")
                end
              end
            end
          end
        end)
      end
      -- Throttle OnUpdate to prevent excessive calls (only run every 0.1 seconds)
      if tt:HasScript("OnUpdate") then
        local lastUpdate = 0
        tt:HookScript("OnUpdate", function(self, elapsed)
          if self:IsShown() then
            lastUpdate = lastUpdate + elapsed
            if lastUpdate >= 0.1 then
              ApplyTooltipFonts(self)
              lastUpdate = 0
            end
          else
            lastUpdate = 0
          end
        end)
      end
    end
  end
  TooltipsHooked = true
end

function Hooks.OnEvent(_, event, addonName)
  if (QTR_PS) then
    C_Timer.After(1, function()
      if QTR_ObjectiveTrackerFrame_Titles then
        QTR_ObjectiveTrackerFrame_Titles()
      end
    end)
  end

  if (addonName == 'Blizzard_PlayerSpells') then
    ST_load1 = true
    if PlayerSpellsFrame and PlayerSpellsFrame.SpecFrame then
      PlayerSpellsFrame.SpecFrame:HookScript("OnShow", ST_updateSpecContentsHook)
    end
    if PlayerSpellsFrame and PlayerSpellsFrame.TalentsFrame then
      PlayerSpellsFrame.TalentsFrame:HookScript("OnShow", ST_TalentsTranslate)
    end
    if HeroTalentsSelectionDialog and HeroTalentsSelectionDialog.SpecOptionsContainer then
      HeroTalentsSelectionDialog.SpecOptionsContainer:HookScript("OnShow", ST_updateHeroTalentHook)
    end
    if PlayerSpellsFrame and PlayerSpellsFrame.SpecFrame then
      local success, err = pcall(hooksecurefunc, PlayerSpellsFrame.SpecFrame, "UpdateSpecContents", ST_updateSpecContentsHook)
      if success and _G.StartPlayerSpellsFrameCheck then
        _G.StartPlayerSpellsFrameCheck()
      end
    end
  elseif (addonName == 'Blizzard_EncounterJournal') then
    ST_load2 = true
    EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:HookScript("OnShow", ST_clickBosses)
    if Core and Core.HookOnShowTicker then
      Core.HookOnShowTicker(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription, ST_ShowAbility, 0.1)
      Core.HookOnShowTicker(EncounterJournal, ST_SuggestTabClick, 0)
    else
      EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:HookScript("OnShow", function()
        StartTicker(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription, ST_ShowAbility, 0.1)
      end)
      EncounterJournal:HookScript("OnShow", function() StartTicker(EncounterJournal, ST_SuggestTabClick, 0) end)
    end
    EncounterJournal:HookScript("OnShow", ST_AdventureGuidebutton)
    EncounterJournalEncounterFrameInstanceFrame.LoreScrollingFont:HookScript("OnShow", ST_showLoreDescription)
  elseif (addonName == 'Blizzard_Collections') then
    ST_load4 = true
    if Core and Core.HookOnShowTicker then
      Core.HookOnShowTicker(CollectionsJournalTitleText, ST_MountJournal, 0.1)
      Core.HookOnShowTicker(WardrobeCollectionFrame, ST_HelpPlateTooltip, 0.2)
    else
      CollectionsJournalTitleText:HookScript("OnShow", function() StartTicker(CollectionsJournalTitleText, ST_MountJournal, 0.1) end)
      WardrobeCollectionFrame:HookScript("OnShow", function() StartTicker(WardrobeCollectionFrame, ST_HelpPlateTooltip, 0.2) end)
    end
    MountJournalName:HookScript("OnShow", ST_MountJournalbutton)
  elseif (addonName == 'Blizzard_PVPUI') then
    ST_load5 = true
    if Core and Core.HookOnShowTicker then
      Core.HookOnShowTicker(PVPQueueFrameCategoryButton1, ST_GroupPVPFinder, 0.02)
    else
      PVPQueueFrameCategoryButton1:HookScript("OnShow", function() StartTicker(PVPQueueFrameCategoryButton1, ST_GroupPVPFinder, 0.02) end)
    end
  elseif (addonName == 'Blizzard_ChallengesUI') then
    ST_load6 = true
    if Core and Core.HookOnShowTicker then
      Core.HookOnShowTicker(ChallengesFrame, ST_GroupMplusFinder, 0)
    else
      ChallengesFrame:HookScript("OnShow", function() StartTicker(ChallengesFrame, ST_GroupMplusFinder, 0) end)
    end
  elseif (addonName == 'Blizzard_DelvesDifficultyPicker') then
    ST_load7 = true
    if Core and Core.HookOnShowTicker then
      Core.HookOnShowTicker(DelvesDifficultyPickerFrame, ST_showDelveDifficultFrame, 0.2)
    else
      DelvesDifficultyPickerFrame:HookScript("OnShow", function() StartTicker(DelvesDifficultyPickerFrame, ST_showDelveDifficultFrame, 0.2) end)
    end
  elseif (addonName == 'Blizzard_ItemUpgradeUI') then
    ST_load8 = true
    if Core and Core.HookOnShowTicker then
      Core.HookOnShowTicker(ItemUpgradeFrame, ST_ItemUpgradeFrm, 0.2)
    else
      ItemUpgradeFrame:HookScript("OnShow", function() StartTicker(ItemUpgradeFrame, ST_ItemUpgradeFrm, 0.2) end)
    end
  elseif (addonName == 'Blizzard_WeeklyRewards') then
    ST_load9 = true
    if Core and Core.HookOnShowTicker then
      Core.HookOnShowTicker(WeeklyRewardsFrame, ST_WeeklyRewardsFrame, 0.2)
    else
      WeeklyRewardsFrame:HookScript("OnShow", function() StartTicker(WeeklyRewardsFrame, ST_WeeklyRewardsFrame, 0.2) end)
    end
  elseif (addonName == 'Blizzard_AdventureMap') then
    ST_load10 = true
    if AdventureMapQuestChoiceDialog and AdventureMapQuestChoiceDialog.Details and AdventureMapQuestChoiceDialog.Details.Child and AdventureMapQuestChoiceDialog.Details.Child.DescriptionText then
      AdventureMapQuestChoiceDialog.Details.Child.DescriptionText:HookScript("OnShow", function()
        if ST_AdvantureMapFrm then
          if Core and Core.StartTicker then
            Core.StartTicker(AdventureMapQuestChoiceDialog.Details.Child.DescriptionText, ST_AdvantureMapFrm, 0.2)
          else
            StartTicker(AdventureMapQuestChoiceDialog.Details.Child.DescriptionText, ST_AdvantureMapFrm, 0.2)
          end
        end
      end)
    end
  end

  if (ST_load1 and ST_load2 and ST_load4 and ST_load5 and ST_load6 and ST_load7 and ST_load8 and ST_load9 and ST_load10) then
    if WOWSTR and WOWSTR.UnregisterEvent then
      WOWSTR:UnregisterEvent("ADDON_LOADED")
    end
  end
end

function Hooks.Enable()
  -- Tooltip font templates + per-tooltip FontString pass (moved from common/Config/Core.lua).
  HookTooltipFonts()

  -- Hook GameTooltip updates to namespaced handler if legacy global is absent
  if _G.GameTooltip and _G.GameTooltip.HookScript then
    if not _G.ST_GameTooltipOnShow then
      _G.GameTooltip:HookScript("OnUpdate", function()
        if ns.Tooltips and ns.Tooltips.GameTooltip and ns.Tooltips.GameTooltip.OnShow then
          ns.Tooltips.GameTooltip.OnShow()
        end
      end)
    end
  end

  -- Compare item tooltips
  local compareFunc = rawget(_G, "GameTooltip_ShowCompareItem")
  if type(compareFunc) == "function" and hooksecurefunc and ns.Tooltips and ns.Tooltips.GameTooltip and ns.Tooltips.GameTooltip.CurrentEquipped then
    hooksecurefunc("GameTooltip_ShowCompareItem", function(self)
      if (ShoppingTooltip1 and ShoppingTooltip1:IsVisible()) then
        ns.Tooltips.GameTooltip.CurrentEquipped(ShoppingTooltip1)
      end
      if (ShoppingTooltip2 and ShoppingTooltip2:IsVisible()) then
        ns.Tooltips.GameTooltip.CurrentEquipped(ShoppingTooltip2)
      end
    end)
  end

  -- SpellBookFrame_Update hook
  if SpellBookFrame_Update and hooksecurefunc then
    hooksecurefunc("SpellBookFrame_Update", ST_updateSpellBookFrame)
  end

  -- Create event frame for ADDON_LOADED
  if ((GetLocale() == "enUS") or (GetLocale() == "enGB")) then
    WOWSTR = CreateFrame("Frame")
    WOWSTR:SetScript("OnEvent", Hooks.OnEvent)
    WOWSTR:RegisterEvent("ADDON_LOADED")
  end
end

-- Global wrapper
_G.WOWSTR_onEvent = function(...) return Hooks.OnEvent(...) end

return Hooks


