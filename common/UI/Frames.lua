---@diagnostic disable: undefined-field

local addonName, ns = ...

ns = ns or {}
ns.UI = ns.UI or {}
ns.UI.Frames = ns.UI.Frames or {}
local M = ns.UI.Frames

-- Misc UI frames module (migrated from WoW_Tooltips.lua)

local T = (ns.UI and ns.UI.Translate) or nil

local isMountButtonCreated = false
local mountUpdateVisibility

-- SpellBook Frame
function M.UpdateSpellBookFrame()
  if (TT_PS and TT_PS["ui1"] == "1") then
    local ST_titleTextFontString = _G.SpellBookFrame:GetTitleText()
    if (ST_titleTextFontString and ST_titleTextFontString:GetText()) then
      local str_ID = StringHash(ST_UsunZbedneZnaki(ST_titleTextFontString:GetText()))
      if (ST_TooltipsHS and ST_TooltipsHS[str_ID]) then
        local text0 = QTR_ReverseIfAR(ST_titleTextFontString:GetText())
        ST_titleTextFontString:SetText(ST_SetText(text0))
      end
    end

    if (_G.SpellBookFrameTabButton1 and _G.SpellBookFrameTabButton1:GetText()) then
      local str_ID = StringHash(ST_UsunZbedneZnaki(_G.SpellBookFrameTabButton1:GetText()))
      if (ST_TooltipsHS and ST_TooltipsHS[str_ID]) then
        local text1 = QTR_ReverseIfAR(ST_SetText(_G.SpellBookFrameTabButton1:GetText()))
        local fo = _G.SpellBookFrameTabButton1:CreateFontString()
        fo:SetFont(WOWTR_Font2, 11)
        fo:SetText(text1)
        _G.SpellBookFrameTabButton1:SetFontString(fo)
        _G.SpellBookFrameTabButton1:SetText(text1)
      end
    end

    if (_G.SpellBookFrameTabButton2 and _G.SpellBookFrameTabButton2:GetText()) then
      local str_ID = StringHash(ST_UsunZbedneZnaki(_G.SpellBookFrameTabButton2:GetText()))
      if (ST_TooltipsHS and ST_TooltipsHS[str_ID]) then
        local text1 = QTR_ReverseIfAR(ST_SetText(_G.SpellBookFrameTabButton2:GetText()))
        local fo = _G.SpellBookFrameTabButton2:CreateFontString()
        fo:SetFont(WOWTR_Font2, 11)
        fo:SetText(text1)
        _G.SpellBookFrameTabButton2:SetFontString(fo)
        _G.SpellBookFrameTabButton2:SetText(text1)
      end
    end

    if (_G.SpellBookFrameTabButton3 and _G.SpellBookFrameTabButton3:GetText()) then
      local str_ID = StringHash(ST_UsunZbedneZnaki(_G.SpellBookFrameTabButton3:GetText()))
      if (ST_TooltipsHS and ST_TooltipsHS[str_ID]) then
        local text1 = QTR_ReverseIfAR(ST_SetText(_G.SpellBookFrameTabButton3:GetText()))
        local fo = _G.SpellBookFrameTabButton3:CreateFontString()
        fo:SetFont(WOWTR_Font2, 11)
        fo:SetText(text1)
        _G.SpellBookFrameTabButton3:SetFontString(fo)
        _G.SpellBookFrameTabButton3:SetText(text1)
      end
    end

    local SBPageText = _G.SpellBookPageText
    ST_CheckAndReplaceTranslationText(SBPageText, true, "ui")
  end
end

-- Static Popup
function M.StaticPopup1()
  if not (T and T.Enabled("ui1")) then return end

  T.ApplyUI({
    function() return _G.StaticPopup1Text end,
    function() return _G.StaticPopup2Text end,
  }, { sav = true, prefix = "h@popuptext-ui" })

  T.ApplyUI({
    function() return _G.StaticPopup1Button1Text end,
    function() return _G.StaticPopup1Button2Text end,
    function() return _G.StaticPopup1Button3Text end,
    function() return _G.StaticPopup1Button4Text end,
    function() return _G.StaticPopup2Button1Text end,
    function() return _G.StaticPopup2Button2Text end,
    function() return _G.StaticPopup2Button3Text end,
    function() return _G.StaticPopup2Button4Text end,
  }, { sav = true, prefix = "h@popupbutton-ui" })
end

-- World Map
function M.WorldMapFunc()
  local wmframe01 = WorldMapFrameTitleText
  ST_CheckAndReplaceTranslationText(wmframe01, true, "ui", false, 1)

  local wmframe02 = WorldMapFrameHomeButtonText
  ST_CheckAndReplaceTranslationText(wmframe02, true, "ui")
end

-- Merchant
function M.MerchantFrame()
  if not (T and T.Enabled("ui1")) then return end
  T.ApplyUI({
    function() return _G.MerchantFrameTab1 and _G.MerchantFrameTab1.Text end,
    function() return _G.MerchantFrameTab2 and _G.MerchantFrameTab2.Text end,
  }, { sav = true, prefix = "ui" })
end

-- Game Menu
function M.GameMenuTranslate()
  if not TT_PS or TT_PS["ui1"] ~= "1" then return end

  local function SafeUpdateText(textObject)
    if not textObject or not textObject.GetText then return end
    local originalText = textObject:GetText()
    if not originalText then return end

    local hash = StringHash(ST_UsunZbedneZnaki(originalText))
    if ST_TooltipsHS and ST_TooltipsHS[hash] then
      local translatedText = QTR_ReverseIfAR(ST_TooltipsHS[hash]) .. NONBREAKINGSPACE
      C_Timer.After(0.01, function()
        if textObject:GetText() == originalText then
          textObject:SetText(translatedText)
          if textObject.SetFont then
            textObject:SetFont(WOWTR_Font2, select(2, textObject:GetFont()))
          end
        end
      end)
    end
  end

  local function SafeUpdateButton(button)
    SafeUpdateText(button)

    local fontStates = { "Normal", "Highlight", "Disabled", "Pushed" }
    for _, state in ipairs(fontStates) do
      local getFontObject = button["Get" .. state .. "FontObject"]
      local setFontObject = button["Set" .. state .. "FontObject"]

      if getFontObject and setFontObject then
        local fontObject = getFontObject(button)
        if fontObject then
          fontObject:SetFont(WOWTR_Font2, select(2, fontObject:GetFont()))
          setFontObject(button, fontObject)
        end
      end
    end
  end

  SafeUpdateText(GameMenuFrame.Header.Text)

  local function SafeInitButtons()
    if GameMenuFrame.buttonPool then
      for buttonFrame in GameMenuFrame.buttonPool:EnumerateActive() do
        SafeUpdateButton(buttonFrame)
      end
    end
  end

  hooksecurefunc(GameMenuFrame, "InitButtons", SafeInitButtons)
  SafeInitButtons()
end

-- Mount Journal
function M.MountJournal()
  if (TT_PS and TT_PS["ui4"] == "1") then
    local CJobj01 = MountJournalLore
    local ST_MountName = MountJournalName:GetText()
    if (ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) then
      ST_CheckAndReplaceTranslationText(CJobj01, true, "Collections:Mount:" .. (ST_MountName or ''), false, false, -10)
    else
      ST_CheckAndReplaceTranslationTextUI(CJobj01, true, "Collections:Mount:" .. (ST_MountName or ''))
    end

    local CJobj02 = MountJournalSummonRandomFavoriteButtonSpellName
    ST_CheckAndReplaceTranslationText(CJobj02, false, "ui", false, false)

    local CJobj03 = MountJournal.BottomLeftInset.SlotLabel
    ST_CheckAndReplaceTranslationTextUI(CJobj03, false, "ui")

    local CJobj04 = MountJournal.MountDisplay.ModelScene.TogglePlayer.TogglePlayerText
    ST_CheckAndReplaceTranslationTextUI(CJobj04, false, "ui")

    local CJobj05 = MountJournal.MountCount.Label
    ST_CheckAndReplaceTranslationTextUI(CJobj05, false, "ui")

    local CJobj06 = CollectionsJournalTitleText
    ST_CheckAndReplaceTranslationTextUI(CJobj06, false, "ui")

    local CJobj07 = MountJournalMountButton.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj07, false, "ui")

    local CJobj13 = WardrobeCollectionFrameTab1.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj13, false, "ui")

    local CJobj14 = WardrobeCollectionFrameTab2.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj14, false, "ui")

    local CJobj15 = MountJournalSearchBox.Instructions
    ST_CheckAndReplaceTranslationTextUI(CJobj15, false, "ui")

    local CJobj16 = PetJournalSearchBox.Instructions
    ST_CheckAndReplaceTranslationTextUI(CJobj16, false, "ui")

    local CJobj17 = PetJournal.PetCount.Label
    ST_CheckAndReplaceTranslationTextUI(CJobj17, false, "ui")

    local CJobj18 = PetJournalSummonButton.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj18, false, "ui")

    local CJobj19 = PetJournalFindBattle.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj19, false, "ui")

    local CJobj20 = PetJournalSummonRandomFavoritePetButtonSpellName
    if (ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) then
      ST_CheckAndReplaceTranslationText(CJobj20, false, "ui", false, false)
    else
      ST_CheckAndReplaceTranslationTextUI(CJobj20, false, "ui")
    end

    local CJobj21 = PetJournalHealPetButtonSpellName
    if (ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) then
      ST_CheckAndReplaceTranslationText(CJobj21, false, "ui", false, false)
    else
      ST_CheckAndReplaceTranslationTextUI(CJobj21, false, "ui")
    end

    local CJobj22 = MountJournal.FilterDropdown.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj22, false, "ui")

    local CJobj23 = PetJournal.FilterDropdown.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj23, false, "ui")

    local CJobj24 = ToyBox.searchBox.Instructions
    ST_CheckAndReplaceTranslationTextUI(CJobj24, false, "ui")

    local CJobj25 = ToyBox.FilterDropdown.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj25, false, "ui")

    local CJobj26 = ToyBox.PagingFrame.PageText
    ST_CheckAndReplaceTranslationTextUI(CJobj26, false, "ui")

    local CJobj27 = HeirloomsJournalSearchBox.Instructions
    ST_CheckAndReplaceTranslationTextUI(CJobj27, false, "ui")

    local CJobj28 = HeirloomsJournal.FilterDropdown.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj28, false, "ui")

    local CJobj29 = HeirloomsJournal.PagingFrame.PageText
    ST_CheckAndReplaceTranslationTextUI(CJobj29, false, "ui")

    local CJobj30 = WardrobeCollectionFrameSearchBox.Instructions
    ST_CheckAndReplaceTranslationTextUI(CJobj30, false, "ui")

    local CJobj31 = WardrobeCollectionFrame.FilterButton.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj31, false, "ui")

    local CJobj32 = WardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame.PageText
    ST_CheckAndReplaceTranslationTextUI(CJobj32, false, "ui")

    for i = 1, 18 do
      local CJToys = ToyBox.iconsFrame["spellButton" .. i].name
      ST_CheckAndReplaceTranslationTextUI(CJToys, true, "toyname")
    end
  end

  if (TT_PS and TT_PS["ui5"] == "1") then
    local CJobj08 = CollectionsJournalTab1.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj08, false, "ui")

    local CJobj09 = CollectionsJournalTab2.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj09, false, "ui")

    local CJobj10 = CollectionsJournalTab3.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj10, false, "ui")

    local CJobj11 = CollectionsJournalTab4.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj11, false, "ui")

    local CJobj12 = CollectionsJournalTab5.Text
    ST_CheckAndReplaceTranslationTextUI(CJobj12, false, "ui")
  end
end

function M.MountJournalButton()
  if not isMountButtonCreated then
    TT_PS = TT_PS or { ui4 = "1" }

    mountUpdateVisibility = CreateToggleButton(
      MountJournal,
      TT_PS,
      "ui4",
      WOWTR_Localization.WoWTR_enDESC,
      WOWTR_Localization.WoWTR_trDESC,
      { "TOPLEFT", MountJournal, "TOPRIGHT", -170, 0 },
      function()
        M.MountJournal()
      end
    )

    isMountButtonCreated = true
  end

  if mountUpdateVisibility then
    mountUpdateVisibility()
  end
end

-- Character Frame
function M.CharacterFrame()
  if not (T and T.Enabled("ui2")) then return end

  T.ApplyUI({
    function() return _G.CharacterStatsPane and _G.CharacterStatsPane.ItemLevelCategory and _G.CharacterStatsPane.ItemLevelCategory.Title end,
    function() return _G.CharacterStatsPane and _G.CharacterStatsPane.AttributesCategory and _G.CharacterStatsPane.AttributesCategory.Title end,
    function() return _G.CharacterStatsPane and _G.CharacterStatsPane.EnhancementsCategory and _G.CharacterStatsPane.EnhancementsCategory.Title end,
    function() return _G.CharacterFrameTab1 and _G.CharacterFrameTab1.Text end,
    function() return _G.CharacterFrameTab2 and _G.CharacterFrameTab2.Text end,
    function() return _G.CharacterFrameTab3 and _G.CharacterFrameTab3.Text end,
    function() return _G.ReputationDetailAtWarCheckBoxText end,
    function() return _G.ReputationDetailInactiveCheckBoxText end,
    function() return _G.ReputationDetailMainScreenCheckBoxText end,
  }, { sav = true, prefix = "ui" })

  -- Reputation detail description: keep existing child FontString resolution + dynamic prefix.
  local scrollTarget = _G.ReputationFrame
    and _G.ReputationFrame.ReputationDetailFrame
    and _G.ReputationFrame.ReputationDetailFrame.ScrollingDescription
    and _G.ReputationFrame.ReputationDetailFrame.ScrollingDescription.ScrollBox
    and _G.ReputationFrame.ReputationDetailFrame.ScrollingDescription.ScrollBox.ScrollTarget
  if scrollTarget and scrollTarget.GetChildren then
    local childFrame = select(1, scrollTarget:GetChildren())
    if childFrame and childFrame.FontString and childFrame.FontString.GetText then
      local RDFactionName = _G.ReputationFrame.ReputationDetailFrame.Title and _G.ReputationFrame.ReputationDetailFrame.Title:GetText()
      if RDFactionName then
        ST_CheckAndReplaceTranslationTextUI(childFrame.FontString, true, "Factions:" .. ST_RenkKoduSil(RDFactionName))
      end
    end
  end
end

-- Friends Frame
function M.FriendsFrame()
  if not (T and T.Enabled("ui6")) then return end

  T.ApplyUI({
    function() return _G.FriendsFrameTitleText end,

    -- Some client versions expose friends tabs as FriendsTabHeaderTab* (newer UI),
    -- others as FriendsFrameTab* (older UI). Guard globals to avoid nil errors.
    function() return _G.FriendsTabHeaderTab1 and _G.FriendsTabHeaderTab1.Text end,
    function() return _G.FriendsTabHeaderTab2 and _G.FriendsTabHeaderTab2.Text end,
    function() return _G.FriendsTabHeaderTab3 and _G.FriendsTabHeaderTab3.Text end,

    function() return _G.FriendsFrameTab1 and _G.FriendsFrameTab1.Text end,
    function() return _G.FriendsFrameTab2 and _G.FriendsFrameTab2.Text end,
    function() return _G.FriendsFrameTab3 and _G.FriendsFrameTab3.Text end,
    function() return _G.FriendsFrameTab4 and _G.FriendsFrameTab4.Text end,

    function() return _G.FriendsFrameAddFriendButtonText end,
    function() return _G.FriendsFrameSendMessageButtonText end,
    function() return _G.FriendsFrameIgnorePlayerButtonText end,
    function() return _G.FriendsFrameUnsquelchButtonText end,
    function() return _G.WhoFrameWhoButtonText end,
    function() return _G.WhoFrameAddFriendButtonText end,
    function() return _G.WhoFrameGroupInviteButtonText end,
    function() return _G.WhoFrameTotals end,
    function() return _G.RaidFrameConvertToRaidButtonText end,
    function() return _G.RaidFrameRaidInfoButtonText end,
    function() return _G.RaidFrameRaidDescription end,

    function() return _G.RecruitAFriendRecruitmentFrame and _G.RecruitAFriendRecruitmentFrame.Title end,
    function() return _G.RecruitAFriendRecruitmentFrame and _G.RecruitAFriendRecruitmentFrame.Description end,
    function() return _G.RecruitAFriendRecruitmentFrame and _G.RecruitAFriendRecruitmentFrame.FactionAndRealm end,
    function() return _G.RecruitAFriendFrame and _G.RecruitAFriendFrame.RecruitList and _G.RecruitAFriendFrame.RecruitList.Header and _G.RecruitAFriendFrame.RecruitList.Header.RecruitedFriends end,
    function() return _G.RecruitAFriendFrame and _G.RecruitAFriendFrame.RecruitmentButton and _G.RecruitAFriendFrame.RecruitmentButton.Text end,
    function() return _G.RecruitAFriendFrame and _G.RecruitAFriendFrame.RewardClaiming and _G.RecruitAFriendFrame.RewardClaiming.MonthCount and _G.RecruitAFriendFrame.RewardClaiming.MonthCount.Text end,
    function() return _G.RecruitAFriendFrameText end,
    function() return _G.RecruitAFriendRecruitmentFrame and _G.RecruitAFriendRecruitmentFrame.EditBox and _G.RecruitAFriendRecruitmentFrame.EditBox.Instructions end,
    function() return _G.RecruitAFriendRecruitmentFrameText end,
    function() return _G.RecruitAFriendRecruitmentFrame and _G.RecruitAFriendRecruitmentFrame.InfoText1 end,
    function() return _G.RecruitAFriendRecruitmentFrame and _G.RecruitAFriendRecruitmentFrame.InfoText2 end,
    function() return _G.RecruitAFriendFrame and _G.RecruitAFriendFrame.RewardClaiming and _G.RecruitAFriendFrame.RewardClaiming.EarnInfo end,
  }, { sav = true, prefix = "ui" })
end

-- Help Plate Tooltip
function M.HelpPlateTooltip()
  if not (T and T.Enabled("active")) then return end
  T.ApplyUI({
    function() return _G.HelpPlateTooltip and _G.HelpPlateTooltip.Text end,
  }, { sav = true, prefix = "ui" })
end

-- Splash Frame
function M.SplashFrame()
  if not (T and T.Enabled("active")) then return end

  T.ApplyUI({
    function() return _G.SplashFrame and _G.SplashFrame.Header end,
    function() return _G.SplashFrame and _G.SplashFrame.Label end,
    function() return _G.SplashFrame and _G.SplashFrame.BottomCloseButton and _G.SplashFrame.BottomCloseButton.Text end,
    function() return _G.SplashFrame and _G.SplashFrame.TopLeftFeature and _G.SplashFrame.TopLeftFeature.Title end,
    function() return _G.SplashFrame and _G.SplashFrame.BottomLeftFeature and _G.SplashFrame.BottomLeftFeature.Title end,
    function() return _G.SplashFrame and _G.SplashFrame.RightFeature and _G.SplashFrame.RightFeature.Title end,
  }, { sav = true, prefix = "ui" })

  local rtl = ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()
  if rtl then
    local d1 = _G.SplashFrame and _G.SplashFrame.TopLeftFeature and _G.SplashFrame.TopLeftFeature.Description
    local d2 = _G.SplashFrame and _G.SplashFrame.BottomLeftFeature and _G.SplashFrame.BottomLeftFeature.Description
    local d3 = _G.SplashFrame and _G.SplashFrame.RightFeature and _G.SplashFrame.RightFeature.Description

    T.ApplyText({
      { obj = d1, corr = -10 },
      { obj = d2, corr = -15 },
      { obj = d3, corr = -10 },
    }, { sav = true, prefix = "ui" })

    -- Preserve explicit justification from original implementation.
    if d1 and d1.SetJustifyH then d1:SetJustifyH("RIGHT") end
    if d2 and d2.SetJustifyH then d2:SetJustifyH("RIGHT") end
  else
    T.ApplyUI({
      function() return _G.SplashFrame and _G.SplashFrame.TopLeftFeature and _G.SplashFrame.TopLeftFeature.Description end,
      function() return _G.SplashFrame and _G.SplashFrame.BottomLeftFeature and _G.SplashFrame.BottomLeftFeature.Description end,
      function() return _G.SplashFrame and _G.SplashFrame.RightFeature and _G.SplashFrame.RightFeature.Description end,
    }, { sav = true, prefix = "ui" })
  end
end

-- Ping System Tutorial
function M.PingSystemTutorial()
  if not (T and T.Enabled("active")) then return end
  T.ApplyUI({
    function() return _G.PingSystemTutorialTitleText end,
    function() return _G.PingSystemTutorial and _G.PingSystemTutorial.Tutorial1 and _G.PingSystemTutorial.Tutorial1.TutorialHeader end,
    function() return _G.PingSystemTutorial and _G.PingSystemTutorial.Tutorial2 and _G.PingSystemTutorial.Tutorial2.TutorialHeader end,
    function() return _G.PingSystemTutorial and _G.PingSystemTutorial.Tutorial3 and _G.PingSystemTutorial.Tutorial3.TutorialHeader end,
    function() return _G.PingSystemTutorial and _G.PingSystemTutorial.Tutorial4 and _G.PingSystemTutorial.Tutorial4.TutorialHeader end,
    function()
      return _G.PingSystemTutorial
        and _G.PingSystemTutorial.Tutorial4
        and _G.PingSystemTutorial.Tutorial4.ImageBounds
        and _G.PingSystemTutorial.Tutorial4.ImageBounds.TutorialBody1
    end,
    function()
      return _G.PingSystemTutorial
        and _G.PingSystemTutorial.Tutorial4
        and _G.PingSystemTutorial.Tutorial4.ImageBounds
        and _G.PingSystemTutorial.Tutorial4.ImageBounds.TutorialBody2
    end,
    function()
      return _G.PingSystemTutorial
        and _G.PingSystemTutorial.Tutorial4
        and _G.PingSystemTutorial.Tutorial4.ImageBounds
        and _G.PingSystemTutorial.Tutorial4.ImageBounds.TutorialBody3
    end,
  }, { sav = true, prefix = "ui" })
end

-- Warband Bank
function M.WarbandBankFrame()
  if not (T and T.Enabled("active")) then return end
  T.ApplyUI({
    function() return _G.AccountBankPanel and _G.AccountBankPanel.PurchasePrompt and _G.AccountBankPanel.PurchasePrompt.Title end,
    function() return _G.AccountBankPanel and _G.AccountBankPanel.PurchasePrompt and _G.AccountBankPanel.PurchasePrompt.PromptText end,
    function()
      return _G.AccountBankPanel
        and _G.AccountBankPanel.PurchasePrompt
        and _G.AccountBankPanel.PurchasePrompt.TabCostFrame
        and _G.AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton
        and _G.AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton.Text
    end,
    function()
      return _G.AccountBankPanel
        and _G.AccountBankPanel.PurchasePrompt
        and _G.AccountBankPanel.PurchasePrompt.TabCostFrame
        and _G.AccountBankPanel.PurchasePrompt.TabCostFrame.TabCost
    end,
    function() return _G.AccountBankPanel and _G.AccountBankPanel.MoneyFrame and _G.AccountBankPanel.MoneyFrame.WithdrawButton and _G.AccountBankPanel.MoneyFrame.WithdrawButton.Text end,
    function() return _G.AccountBankPanel and _G.AccountBankPanel.MoneyFrame and _G.AccountBankPanel.MoneyFrame.DepositButton and _G.AccountBankPanel.MoneyFrame.DepositButton.Text end,
    function() return _G.AccountBankPanel and _G.AccountBankPanel.ItemDepositFrame and _G.AccountBankPanel.ItemDepositFrame.DepositButton and _G.AccountBankPanel.ItemDepositFrame.DepositButton.Text end,
    function() return _G.AccountBankPanel and _G.AccountBankPanel.ItemDepositFrame and _G.AccountBankPanel.ItemDepositFrame.IncludeReagentsCheckbox and _G.AccountBankPanel.ItemDepositFrame.IncludeReagentsCheckbox.Text end,
    function() return _G.BankItemSearchBox and _G.BankItemSearchBox.Instructions end,
  }, { sav = false, prefix = "ui" })
end

-- ItemRef Tooltip
local ignoreList = {}
if WOWTR_Localization.lang == 'TR' then
  ignoreList = {
    "Head", "Neck", "Shoulder", "Back", "Chest", "Tabard", "Wrist", "Hands", "Waist", "Legs", "Feet", "Finger", "Trinket"
  }
end

local function shouldIgnore(text)
  for _, ignoreText in ipairs(ignoreList) do
    if text:find(ignoreText) then
      return true
    end
  end
  return false
end

function M.ItemRefTooltip()
  for i = 2, 30 do
    local itemRefLeft = _G["ItemRefTooltipTextLeft" .. i]
    if itemRefLeft and itemRefLeft:GetText() then
      local text = itemRefLeft:GetText()
      if not shouldIgnore(text) then
        ST_CheckAndReplaceTranslationTextUI(itemRefLeft, true, "other")
      end
    end

    local itemRefRight = _G["ItemRefTooltipTextRight" .. i]
    if itemRefRight and itemRefRight:GetText() then
      local text = itemRefRight:GetText()
      if not shouldIgnore(text) then
        ST_CheckAndReplaceTranslationTextUI(itemRefRight, true, "other")
      end
    end
  end
end

-- Item Upgrade Frame
function M.ItemUpgradeFrame()
  if not (T and T.Enabled("ui1")) then return end
  T.ApplyUI({
    function() return _G.ItemUpgradeFrameTitleText end,
    function() return _G.ItemUpgradeFrame and _G.ItemUpgradeFrame.ItemInfo and _G.ItemUpgradeFrame.ItemInfo.MissingItemText end,
    function() return _G.ItemUpgradeFrame and _G.ItemUpgradeFrame.MissingDescription end,
    function() return _G.ItemUpgradeFrame and _G.ItemUpgradeFrame.UpgradeButton and _G.ItemUpgradeFrame.UpgradeButton.Text end,
    function() return _G.ItemUpgradeFrame and _G.ItemUpgradeFrame.UpgradeCostFrame and _G.ItemUpgradeFrame.UpgradeCostFrame.Label end,
    function() return _G.ItemUpgradeFrame and _G.ItemUpgradeFrame.ItemInfo and _G.ItemUpgradeFrame.ItemInfo.UpgradeTo end,
    function() return _G.ItemUpgradeFrameLeftItemPreviewFrameTextLeft1 end,
    function() return _G.ItemUpgradeFrameRightItemPreviewFrameTextLeft1 end,
  }, { sav = false, prefix = "ui" })
end

-- Weekly Rewards Frame
function M.WeeklyRewardsFrame()
  if not (T and T.Enabled("ui1")) then return end

  local rtl = ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()
  local rtlFont = rtl and _G.WOWTR_Font1 or nil

  local headerText = _G.WeeklyRewardsFrame and _G.WeeklyRewardsFrame.HeaderFrame and _G.WeeklyRewardsFrame.HeaderFrame.Text
  if rtl then
    T.ApplyText({
      { obj = headerText, font = _G.WOWTR_Font1, corr = 5 },
    }, { sav = false, prefix = "ui" })
  else
    T.ApplyUI({ headerText }, { sav = false, prefix = "ui" })
  end

  T.ApplyUI({
    { obj = function() return _G.WeeklyRewardsFrame and _G.WeeklyRewardsFrame.RaidFrame and _G.WeeklyRewardsFrame.RaidFrame.Name end, font = rtlFont },
    { obj = function() return _G.WeeklyRewardsFrame and _G.WeeklyRewardsFrame.MythicFrame and _G.WeeklyRewardsFrame.MythicFrame.Name end, font = rtlFont },
    { obj = function() return _G.WeeklyRewardsFrame and _G.WeeklyRewardsFrame.WorldFrame and _G.WeeklyRewardsFrame.WorldFrame.Name end, font = rtlFont },
  }, { sav = false, prefix = "ui" })

  local overlay = _G.WeeklyRewardsFrame and _G.WeeklyRewardsFrame.Overlay
  if overlay then
    T.ApplyUI({
      { obj = overlay.Title, font = rtlFont },
      { obj = overlay.Text, font = rtlFont },
    }, { sav = true, prefix = "ui" })
  end
end

-- Event Toast Manager Frame
function M.EventToastManagerFrame()
  if not (T and T.Enabled("ui1")) then return end
  local toast = _G.EventToastManagerFrame and _G.EventToastManagerFrame.currentDisplayingToast
  if not toast then return end

  T.ApplyUI({
    { obj = toast.Title, font = _G.WOWTR_Font1 },
    toast.SubTitle,
    toast.Description,
  }, { sav = true, prefix = "Collections:TextEvent" })

  if toast.Contents then
    T.ApplyUI({
      { obj = toast.Contents.Title, font = _G.WOWTR_Font1 },
      toast.Contents.SubTitle,
      toast.Contents.Description,
    }, { sav = true, prefix = "Collections:TextEvent" })
  end
end

-- Raid Boss Emote Frame
function M.RaidBossEmoteFrame()
  if not (T and T.Enabled("ui1")) then return end
  local emote = _G.RaidBossEmoteFrame
  if not emote then return end

  T.ApplyUI({
    emote.slot1Text,
    emote.slot2Text,
    emote.slot3Text,
  }, { sav = false, prefix = "Collections:Emote" })

  T.ApplyUI({
    emote.slot1,
    emote.slot2,
    emote.slot3,
  }, { sav = true, prefix = "Collections:Emote" })
end

return M