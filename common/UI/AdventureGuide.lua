local addonName, ns = ...

ns = ns or {}
ns.UI = ns.UI or {}
ns.UI.AdventureGuide = ns.UI.AdventureGuide or {}
local M = ns.UI.AdventureGuide

-- Adventure Guide / Encounter Journal module (migrated from WoW_Tooltips.lua)

local T = (ns.UI and ns.UI.Translate) or nil

local isEJournalButtonCreated = false
local EncounterJournalupdateVisibility

local function isRTL()
  return ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()
end

local function getTutorialsFrame()
  local ej = rawget(_G, "EncounterJournal")
  return rawget(_G, "EncounterJournalTutorialsFrame") or (ej and ej.TutorialsFrame) or nil
end

local function getBestWidth(...)
  local best = 0
  for i = 1, select("#", ...) do
    local obj = select(i, ...)
    if obj and obj.GetWidth then
      local ok, width = pcall(obj.GetWidth, obj)
      if ok and type(width) == "number" and width > best then
        best = width
      end
    end
  end
  return best
end

local OVERVIEW_TEXT_TYPES = { "body", "BODY", "p", "P", "h1", "H1", "h2", "H2", "h3", "H3" }
local overviewDescriptionStyleCache = setmetatable({}, { __mode = "k" })

local function getTooltipHashTranslation(text)
  if not text or not _G.StringHash or not _G.ST_UsunZbedneZnaki then return nil end
  local hs = rawget(_G, "ST_TooltipsHS")
  if not hs then return nil end
  local hash = StringHash(ST_UsunZbedneZnaki(text))
  return hs[hash]
end

local function captureOverviewDescriptionStyle(descText)
  if not descText then return nil end
  local cached = overviewDescriptionStyleCache[descText]
  if cached then return cached end

  local info = {
    fonts = {},
    fontObjects = {},
  }

  if descText.GetFont then
    for _, textType in ipairs(OVERVIEW_TEXT_TYPES) do
      local ok, font, size, flags = pcall(descText.GetFont, descText, textType)
      if ok and font then
        info.fonts[textType] = { font, size or 12, flags or "" }
      end
    end
  end

  if descText.GetFontObject then
    for _, textType in ipairs(OVERVIEW_TEXT_TYPES) do
      local ok, fontObj = pcall(descText.GetFontObject, descText, textType)
      if ok then
        info.fontObjects[textType] = fontObj
      end
    end
  end

  overviewDescriptionStyleCache[descText] = info
  return info
end

local function applyOverviewDescriptionLayout(descText, width)
  if not descText then return end

  local alignment = isRTL() and "RIGHT" or "LEFT"

  if width and width > 0 then
    if descText.SetWidth then
      pcall(descText.SetWidth, descText, width)
    end
  end

  if descText.SetJustifyH then
    for _, textType in ipairs(OVERVIEW_TEXT_TYPES) do
      pcall(descText.SetJustifyH, descText, textType, alignment)
    end
  end

  if descText.SetIndentedWordWrap then
    pcall(descText.SetIndentedWordWrap, descText, false)
  end

  if descText.GetRegions then
    local regions = { descText:GetRegions() }
    for _, region in ipairs(regions) do
      if region and region.GetObjectType and region:GetObjectType() == "FontString" then
        if width and width > 0 and region.SetWidth then
          pcall(region.SetWidth, region, width)
        end
        if region.SetJustifyH then
          pcall(region.SetJustifyH, region, alignment)
        end
        if region.SetIndentedWordWrap then
          pcall(region.SetIndentedWordWrap, region, false)
        end
      end
    end
  end
end

local function restoreOverviewDescriptionLayout(descText, width)
  if not descText then return end

  local cached = captureOverviewDescriptionStyle(descText)
  local alignment = "LEFT"

  if width and width > 0 and descText.SetWidth then
    pcall(descText.SetWidth, descText, width)
  end

  if descText.SetJustifyH then
    for _, textType in ipairs(OVERVIEW_TEXT_TYPES) do
      pcall(descText.SetJustifyH, descText, textType, alignment)
    end
  end

  if descText.SetIndentedWordWrap then
    pcall(descText.SetIndentedWordWrap, descText, false)
  end

  if cached then
    for _, textType in ipairs(OVERVIEW_TEXT_TYPES) do
      local fontObj = cached.fontObjects[textType]
      local fontData = cached.fonts[textType]
      if fontObj and descText.SetFontObject then
        pcall(descText.SetFontObject, descText, textType, fontObj)
      elseif fontData and fontData[1] and descText.SetFont then
        pcall(descText.SetFont, descText, textType, fontData[1], fontData[2], fontData[3])
      end
    end
  end

  if descText.GetRegions then
    local regions = { descText:GetRegions() }
    for _, region in ipairs(regions) do
      if region and region.GetObjectType and region:GetObjectType() == "FontString" then
        if width and width > 0 and region.SetWidth then
          pcall(region.SetWidth, region, width)
        end
        if region.SetJustifyH then
          pcall(region.SetJustifyH, region, alignment)
        end
        if region.SetIndentedWordWrap then
          pcall(region.SetIndentedWordWrap, region, false)
        end
      end
    end
  end
end

local function restoreEncounterFontStringLayout(fs)
  if not fs then return end
  if fs.SetJustifyH then
    pcall(fs.SetJustifyH, fs, "LEFT")
  end
  if fs.SetIndentedWordWrap then
    pcall(fs.SetIndentedWordWrap, fs, false)
  end
end

local function applyEncounterFontStringLayout(fs, translated)
  if not fs then return end
  local justify = (translated and isRTL()) and "RIGHT" or "LEFT"
  if fs.SetJustifyH then
    pcall(fs.SetJustifyH, fs, justify)
  end
  if fs.SetIndentedWordWrap then
    pcall(fs.SetIndentedWordWrap, fs, false)
  end
end

local function isTranslatedDisplayText(text)
  if type(text) ~= "string" or text == "" then return false end
  if string.find(text, NONBREAKINGSPACE, 1, true) ~= nil then
    return true
  end
  return getTooltipHashTranslation(text) ~= nil
end

local function saveMissingTutorialText(text, hash)
  if not text or text == "" then return end
  if string.find(text, NONBREAKINGSPACE, 1, true) ~= nil then return end
  if not (TT_PS and TT_PS["save"] == "1") then return end

  TT_TUTORIALS = TT_TUTORIALS or {}
  TT_TUTORIALS[tostring(hash or StringHash(text))] = text
end

local function applyTutorialTranslation(obj, opts)
  if not (obj and obj.GetText and obj.SetText) then return false end

  local originalText = obj:GetText()
  if not originalText or originalText == "" then return false end
  if string.find(originalText, NONBREAKINGSPACE, 1, true) ~= nil then return false end

  local normalizedText = string.gsub(originalText, "\r", "")
  local hash = StringHash(normalizedText)
  local translated = _G.Tut_Data and _G.Tut_Data[hash]
  if not translated then
    saveMissingTutorialText(normalizedText, hash)
    return false
  end

  local size, flags = 12, nil
  if obj.GetFont then
    local ok, _, currentSize, currentFlags = pcall(obj.GetFont, obj)
    if ok then
      size, flags = currentSize or 12, currentFlags
    end
  end

  if isRTL() and opts and opts.offset then
    obj:SetText(QTR_ExpandUnitInfo(translated, false, obj, WOWTR_Font2, opts.offset) .. NONBREAKINGSPACE)
  else
    obj:SetText(QTR_ReverseIfAR(WOW_ZmienKody(translated)) .. NONBREAKINGSPACE)
  end

  if obj.SetFont and WOWTR_Font2 then
    pcall(obj.SetFont, obj, WOWTR_Font2, size or 12, flags)
  end

  if opts and opts.justify and obj.SetJustifyH then
    pcall(obj.SetJustifyH, obj, opts.justify)
  end

  return true
end

function M.SuggestTabClick()
  if not (T and T.Enabled("ui5")) then return end

  local rtl = isRTL()
  local font = rtl and _G.WOWTR_Font1 or nil

  -- EJ suggest title
  T.ApplyUI({
    function()
      local inst = rawget(_G, "EncounterJournalInstanceSelect")
      return inst and inst.Title
    end,
  }, { sav = true, prefix = "Dungeon&Raid:Suggest:SuggestTittle", font = font })

  -- Suggestions 1..3 use dynamic prefix based on the suggestion title
  for i = 1, 3 do
    local suggestFrame = rawget(_G, "EncounterJournalSuggestFrame")
    local suggest = suggestFrame and suggestFrame["Suggestion" .. i]
    local desc = suggest and suggest.centerDisplay and suggest.centerDisplay.description and suggest.centerDisplay.description.text
    local titleFS = suggest and suggest.centerDisplay and suggest.centerDisplay.title and suggest.centerDisplay.title.text
    local title = (titleFS and titleFS.GetText and titleFS:GetText()) or "?"
    if desc then
      ST_CheckAndReplaceTranslationTextUI(desc, true, "Dungeon&Raid:Suggest:" .. title, font)
    end
  end

  -- Remaining UI elements in Suggest tab (same prefix + font selection)
  T.ApplyUI({
    function()
      local maf = rawget(_G, "EncounterJournalMonthlyActivitiesFrame")
      return maf and maf.BarComplete and maf.BarComplete.AllRewardsCollectedText
    end,
    function() return rawget(_G, "EncounterJournalTitleText") end,
    function()
      local maf = rawget(_G, "EncounterJournalMonthlyActivitiesFrame")
      return maf and maf.HeaderContainer and maf.HeaderContainer.Month
    end,
    function()
      local maf = rawget(_G, "EncounterJournalMonthlyActivitiesFrame")
      return maf and maf.HeaderContainer and maf.HeaderContainer.Title
    end,
    function()
      local maf = rawget(_G, "EncounterJournalMonthlyActivitiesFrame")
      return maf and maf.HeaderContainer and maf.HeaderContainer.TimeLeft
    end,
    function()
      local sf = rawget(_G, "EncounterJournalSuggestFrame")
      local s1 = sf and sf.Suggestion1
      return s1 and s1.button and s1.button.Text
    end,
    function()
      local sf = rawget(_G, "EncounterJournalSuggestFrame")
      local s2 = sf and sf.Suggestion2
      return s2 and s2.centerDisplay and s2.centerDisplay.button and s2.centerDisplay.button.Text
    end,
    function()
      local sf = rawget(_G, "EncounterJournalSuggestFrame")
      local s3 = sf and sf.Suggestion3
      return s3 and s3.centerDisplay and s3.centerDisplay.button and s3.centerDisplay.button.Text
    end,
    function()
      local sf = rawget(_G, "EncounterJournalSuggestFrame")
      local s1 = sf and sf.Suggestion1
      return s1 and s1.reward and s1.reward.text
    end,
    function()
      local maf = rawget(_G, "EncounterJournalMonthlyActivitiesFrame")
      return maf and maf.BarComplete and maf.BarComplete.PendingRewardsText
    end,
    function()
      local t = rawget(_G, "EncounterJournalMonthlyActivitiesTab")
      return t and t.Text
    end,
    function()
      local t = rawget(_G, "EncounterJournalSuggestTab")
      return t and t.Text
    end,
    function()
      local t = rawget(_G, "EncounterJournalDungeonTab")
      return t and t.Text
    end,
    function()
      local t = rawget(_G, "EncounterJournalRaidTab")
      return t and t.Text
    end,
    function()
      local t = rawget(_G, "EncounterJournalLootJournalTab")
      return t and t.Text
    end,
    function()
      local t = rawget(_G, "EncounterJournalTutorialsTab")
      return t and t.Text
    end,
  }, { sav = true, prefix = "ui", font = font })

  M.ShowTutorialsFrame()
end

function M.ShowTutorialsFrame()
  if not (T and T.Enabled("ui5")) then return end

  local rtl = isRTL()
  local tutorialsFrame = getTutorialsFrame()
  if not (tutorialsFrame and tutorialsFrame.IsVisible and tutorialsFrame:IsVisible()) then return end

  local contents = tutorialsFrame.Contents
  if not contents then return end

  ST_CheckAndReplaceTranslationTextUI(contents.Header, true, "ui", rtl and _G.WOWTR_Font1 or nil)
  ST_CheckAndReplaceTranslationText(contents.Description, true, "ui", rtl and _G.WOWTR_Font1 or _G.WOWTR_Font2, false, -20, rtl and "RIGHT" or "LEFT")
  applyTutorialTranslation(contents.Header, { offset = -10, justify = rtl and "RIGHT" or "LEFT" })
  applyTutorialTranslation(contents.Description, { offset = -20, justify = rtl and "RIGHT" or "LEFT" })

  if contents.Header and contents.Header.SetJustifyH then
    pcall(contents.Header.SetJustifyH, contents.Header, rtl and "RIGHT" or "LEFT")
  end
  if contents.Description and contents.Description.SetJustifyH then
    pcall(contents.Description.SetJustifyH, contents.Description, rtl and "RIGHT" or "LEFT")
  end

  T.ApplyUI({
    function() return tutorialsFrame and tutorialsFrame.Title end,
    function() return contents and contents.Button and contents.Button.Text end,
    function() return contents and contents.StartButton and contents.StartButton.Text end,
    function() return contents and contents.Start and contents.Start.Text end,
  }, { sav = true, prefix = "ui", font = rtl and _G.WOWTR_Font1 or nil, justify = rtl and "RIGHT" or nil })
end

function M.ShowLoreDescription()
  if not (T and T.Enabled("ui5")) then return end

  local rtl = isRTL()
  local inst = rawget(_G, "EncounterJournalEncounterFrameInstanceFrame")
  local zoneTitle = inst
    and inst.title
    and inst.title.GetText
    and inst.title:GetText()
    or "?"
  local lore = inst
    and inst.LoreScrollingFont
    and inst.LoreScrollingFont.ScrollBox
    and inst.LoreScrollingFont.ScrollBox.FontStringContainer
    and inst.LoreScrollingFont.ScrollBox.FontStringContainer.FontString
  local hasLoreTranslation = lore and lore.GetText and isTranslatedDisplayText(lore:GetText())

  if rtl then
    ST_CheckAndReplaceTranslationText(lore, true, "Dungeon&Raid:Zone:" .. zoneTitle, false, false, -5, "RIGHT")
  else
    ST_CheckAndReplaceTranslationText(lore, true, "Dungeon&Raid:Zone:" .. zoneTitle)
  end
  if lore and lore.GetText then
    hasLoreTranslation = hasLoreTranslation or isTranslatedDisplayText(lore:GetText())
  end
  applyEncounterFontStringLayout(lore, hasLoreTranslation)

  local showMap = rawget(_G, "EncounterJournalEncounterFrameInstanceFrameMapButtonText")
  ST_CheckAndReplaceTranslationText(showMap, true, "ui")
end

function M.ShowDelveDifficultFrame()
  local rtl = isRTL()
  local df = rawget(_G, "DelvesDifficultyPickerFrame")
  local desc = df and df.Description
  if rtl then
    ST_CheckAndReplaceTranslationText(desc, true, "Dungeon&Raid:Zone:DelvesFrame", false, false)
  else
    ST_CheckAndReplaceTranslationTextUI(desc, true, "Dungeon&Raid:Zone:DelvesFrame")
  end

  if T then
    T.ApplyUI({
      function() return df and df.EnterDelveButton and df.EnterDelveButton.Text end,
      function() return df and df.DelveRewardsContainerFrame and df.DelveRewardsContainerFrame.RewardText end,
      function() return df and df.ScenarioLabel end,
    }, { sav = false, prefix = "ui" })

    T.ApplyUI({
      function() return df and df.Title end,
    }, { sav = true, prefix = "Dungeon&Raid:Zone:DelvesFrame" })
  end
end

function M.UpdateJournalEncounterBossInfo(ST_bossName)
  if not ST_bossName or (TT_PS and TT_PS["ui5"] ~= "1") then return end
  local rtl = isRTL()

  local function updateElement(element, prefix, ST_corr, justifyAlign)
    if not element or not element.GetText then return end
    local hasTranslation = isTranslatedDisplayText(element:GetText())
    ST_CheckAndReplaceTranslationText(element, true, prefix .. ST_bossName, WOWTR_Font2, false, ST_corr, justifyAlign)
    hasTranslation = hasTranslation or isTranslatedDisplayText(element:GetText())
    applyEncounterFontStringLayout(element, hasTranslation)
  end

  local elementsToUpdate = {
    { EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription, "Dungeon&Raid:Boss:", -5, rtl and "RIGHT" or nil },
    { EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription, "Dungeon&Raid:Boss:", nil, rtl and "RIGHT" or nil },
    { EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle, "ui", nil, nil }
  }

  for _, elementData in ipairs(elementsToUpdate) do
    updateElement(elementData[1], elementData[2], elementData[3], elementData[4])
  end

  local overviewDesc = EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription
  if overviewDesc then
    local descText = overviewDesc.Text
    local originalText = overviewDesc.textString

    if originalText and descText then
      captureOverviewDescriptionStyle(descText)
      M.SaveOriginalText(ST_bossName, originalText)
      local hasOverviewTranslation = getTooltipHashTranslation(originalText) ~= nil

      local tempObj = {
        GetText = function() return originalText end,
        SetText = function(self, text)
          local wrapWidth = getBestWidth(overviewDesc, descText, overviewDesc.GetParent and overviewDesc:GetParent() or nil)
          local targetWidth = (wrapWidth > 0) and math.max(wrapWidth - 4, 1) or nil
          applyOverviewDescriptionLayout(descText, targetWidth)
          descText:SetText(text)
          applyOverviewDescriptionLayout(descText, targetWidth)
          M.UpdateBossDescriptionFont(descText)
        end,
        GetFont = function() return descText:GetFont("p") end,
        SetFont = function(self, font, size, flags)
          pcall(function() descText:SetFont("p", font, size, flags) end)
        end,
        GetWidth = function()
          local wrapWidth = getBestWidth(overviewDesc, descText, overviewDesc.GetParent and overviewDesc:GetParent() or nil)
          if wrapWidth > 0 then
            return math.max(wrapWidth - 4, 1)
          end
          return wrapWidth
        end,
        SetJustifyH = function(self, align)
          for _, textType in ipairs(OVERVIEW_TEXT_TYPES) do
            pcall(function() descText:SetJustifyH(textType, align) end)
          end
          applyOverviewDescriptionLayout(descText)
        end
      }

      ST_CheckAndReplaceTranslationText(tempObj, true, "Dungeon&Raid:Boss:" .. ST_bossName, WOWTR_Font2, false, -10, rtl and "RIGHT" or nil)
      if not hasOverviewTranslation then
        local wrapWidth = getBestWidth(overviewDesc, descText, overviewDesc.GetParent and overviewDesc:GetParent() or nil)
        local targetWidth = (wrapWidth > 0) and math.max(wrapWidth - 4, 1) or nil
        restoreOverviewDescriptionLayout(descText, targetWidth)
      end
    end
  end

  local rootButton = EncounterJournalEncounterFrameInfoRootButton
  if rootButton then
    rootButton:SetText(rtl and ">" or "<")
  end

  M.BossHeaderTabText()
end

function M.SaveOriginalText(bossName, text)
  ST_OriginalTexts = ST_OriginalTexts or {}
  ST_OriginalTexts[bossName] = text
end

function M.BossHeaderTabText()
  if (TT_PS and TT_PS["ui5"] == "1") then
    local ST_bossName = EncounterJournalNavBarButton3Text:GetText()

    local headers = {
      EncounterJournalOverviewInfoHeader1,
      EncounterJournalOverviewInfoHeader2,
      EncounterJournalOverviewInfoHeader3
    }

    for index, header in ipairs(headers) do
      if header then
        local bulletsTable = header.Bullets
        if bulletsTable then
          for _, bulletData in ipairs(bulletsTable) do
            if bulletData.Text and bulletData.Text.GetTextData then
              local textData = bulletData.Text:GetTextData()
              if textData then
                for text_index, textInfo in ipairs(textData) do
                  if textInfo.text then
                    local metin = textInfo.text
                    local tempObj = {
                      GetText = function() return metin end,
                      SetText = function(self, text)
                        bulletData.Text:SetText(text)
                        M.UpdateBossDescriptionFont(bulletData.Text)
                      end
                    }
                    local prefix = "Dungeon&Raid:Boss:" .. ST_bossName
                    ST_CheckAndReplaceTranslationText(tempObj, true, prefix, nil, false, nil)
                  end
                end
              end
            end
          end
        end
      end
    end

    local HeaderTitle1 = EncounterJournalOverviewInfoHeader1HeaderButtonTitle
    ST_CheckAndReplaceTranslationText(HeaderTitle1, true, "ui")
    local HeaderTitle2 = EncounterJournalOverviewInfoHeader2HeaderButtonTitle
    ST_CheckAndReplaceTranslationText(HeaderTitle2, true, "ui")
    local HeaderTitle3 = EncounterJournalOverviewInfoHeader3HeaderButtonTitle
    ST_CheckAndReplaceTranslationText(HeaderTitle3, true, "ui")
  end
end

function M.UpdateBossDescriptionFont(descText)
  if not descText then return end
  for _, textType in ipairs(OVERVIEW_TEXT_TYPES) do
    local alignment = isRTL() and "RIGHT" or "LEFT"
    if descText.SetJustifyH then
      pcall(descText.SetJustifyH, descText, textType, alignment)
    end
    if descText.SetFont then
      pcall(descText.SetFont, descText, textType, WOWTR_Font2, 12, "")
    end
    if descText.SetFontObject then
      local fontName = "WOWTRBossDescFont_" .. textType
      local fontObj = _G[fontName] or CreateFont(fontName)
      if fontObj and fontObj.SetFont then
        pcall(fontObj.SetFont, fontObj, WOWTR_Font2, 12, "")
      end
      if fontObj and fontObj.SetJustifyH then
        pcall(fontObj.SetJustifyH, fontObj, alignment)
      end
      pcall(descText.SetFontObject, descText, textType, fontObj)
    end
  end
  applyOverviewDescriptionLayout(descText)
end

function M.ClickBosses()
  local previousText = ""
  local function OnUpdateHandler()
    local currentText = EncounterJournalEncounterFrameInfoEncounterTitle:GetText()
    if currentText and currentText ~= previousText then
      local ST_bossName = EncounterJournalNavBarButton3Text:GetText()
      M.UpdateJournalEncounterBossInfo(ST_bossName)
      previousText = currentText
      if not string.find(currentText, " $") then
        local modifiedText = currentText .. " "
        EncounterJournalEncounterFrameInfoEncounterTitle:SetText(modifiedText)
      end
    end
  end

  local frame = CreateFrame("Frame")
  frame:SetScript("OnUpdate", OnUpdateHandler)
end

function M.AdventureGuideButton()
  if not isEJournalButtonCreated then
    TT_PS = TT_PS or { ui5 = "1" }

    EncounterJournalupdateVisibility = CreateToggleButton(
      EncounterJournal,
      TT_PS,
      "ui5",
      WOWTR_Localization.WoWTR_enDESC,
      WOWTR_Localization.WoWTR_trDESC,
      { "TOPLEFT", EncounterJournal, "TOPRIGHT", -170, 0 },
      function()
        M.ClickBosses()
        if EncounterJournal then
          EncounterJournal:Hide()
          EncounterJournal:Show()
        end
      end
    )

    isEJournalButtonCreated = true
  end

  if EncounterJournalupdateVisibility then
    EncounterJournalupdateVisibility()
  end
end

function M.ShowAbility()
  if (TT_PS and TT_PS["ui5"] == "1") then
    for i = 1, 99, 1 do
      if (_G["EncounterJournalInfoHeader" .. i .. "Description"]) then
        local obj = _G["EncounterJournalInfoHeader" .. i .. "Description"]
        local obj1 = _G["EncounterJournalInfoHeader" .. i]
        local obj2 = _G["EncounterJournalInfoHeader" .. i .. "DescriptionBG"]
        local txt = obj:GetText()

        ST_CheckAndReplaceTranslationText(obj, true, "Dungeon&Raid:Ability:" .. _G["EncounterJournalInfoHeader" .. i .. "HeaderButton"].title:GetText())
        local ST_bossDescription2 = EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription
        ST_CheckAndReplaceTranslationText(ST_bossDescription2, false)
      end
    end
  end
end

return M
