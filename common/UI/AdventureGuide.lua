local addonName, ns = ...

ns = ns or {}
ns.UI = ns.UI or {}
ns.UI.AdventureGuide = ns.UI.AdventureGuide or {}
local M = ns.UI.AdventureGuide

-- Adventure Guide / Encounter Journal module (migrated from WoW_Tooltips.lua)

local T = (ns.UI and ns.UI.Translate) or nil

local isEJournalButtonCreated = false
local EncounterJournalupdateVisibility

function M.SuggestTabClick()
  if not (T and T.Enabled("ui5")) then return end

  local rtl = ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()
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
  }, { sav = true, prefix = "ui", font = font })
end

function M.ShowLoreDescription()
  if not (T and T.Enabled("ui5")) then return end

  local rtl = ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()
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

  if rtl then
    ST_CheckAndReplaceTranslationText(lore, true, "Dungeon&Raid:Zone:" .. zoneTitle, false, false, -5, "RIGHT")
  else
    ST_CheckAndReplaceTranslationText(lore, true, "Dungeon&Raid:Zone:" .. zoneTitle)
  end

  local showMap = rawget(_G, "EncounterJournalEncounterFrameInstanceFrameMapButtonText")
  ST_CheckAndReplaceTranslationText(showMap, true, "ui")
end

function M.ShowDelveDifficultFrame()
  local rtl = ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()
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
  local rtl = ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()

  local function updateElement(element, prefix, ST_corr, justifyAlign)
    if not element or not element.GetText then return end
    ST_CheckAndReplaceTranslationText(element, true, prefix .. ST_bossName, WOWTR_Font2, false, ST_corr, justifyAlign)
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
      M.SaveOriginalText(ST_bossName, originalText)

      local tempObj = {
        GetText = function() return originalText end,
        SetText = function(self, text)
          descText:SetText(text)
          M.UpdateBossDescriptionFont(descText)
        end,
        GetFont = function() return descText:GetFont("p") end,
        SetFont = function(self, font, size, flags)
          pcall(function() descText:SetFont("p", font, size, flags) end)
        end,
        GetWidth = function() return descText:GetWidth() end,
        SetJustifyH = function(self, align)
          local textTypes = { "p", "h1", "h2", "h3" }
          for _, textType in ipairs(textTypes) do
            pcall(function() descText:SetJustifyH(textType, align) end)
          end
        end
      }

      ST_CheckAndReplaceTranslationText(tempObj, true, "Dungeon&Raid:Boss:" .. ST_bossName, WOWTR_Font2, false, -120, rtl and "RIGHT" or nil)
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
  local textTypes = { "p", "h1", "h2", "h3" }
  for _, textType in ipairs(textTypes) do
    local alignment = (ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) and "RIGHT" or "LEFT"
    if descText.SetJustifyH then
      descText:SetJustifyH(textType, alignment)
    end
    if descText.SetFont then
      descText:SetFont(textType, WOWTR_Font2, 12, "")
    end
    if descText.SetFontObject then
      local fontName = "WOWTRBossDescFont_" .. textType
      local fontObj = CreateFont(fontName)
      fontObj:SetFont(WOWTR_Font2, 12, "")
      fontObj:SetJustifyH(alignment)
      descText:SetFontObject(textType, fontObj)
    end
  end
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