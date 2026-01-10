-- StorylinePlugin.lua
-- Plugin for handling Storyline addon integration

-- luacheck: globals Storyline_NPCFrame Storyline_NPCFrameChat Storyline_NPCFrameObjectivesContent Storyline_NPCFrameRewards Storyline_NPCFrameChatText Storyline_API Storyline_NPCFrameModelsYou
---@diagnostic disable: undefined-global
StorylinePlugin = {}

local function IsArabicUI()
   if WOWTR and WOWTR.Fonts and type(WOWTR.Fonts.IsArabic) == "function" then
      return WOWTR.Fonts.IsArabic()
   end
   return (WOWTR_Localization and WOWTR_Localization.lang == "AR") and true or false
end

local function ApplyArabicStorylineFixes()
   if not IsArabicUI() then return end

   -- Ensure all Storyline FontStrings use an Arabic-capable font (fixes "□□□□" squares / missing labels).
   if WOWTR and WOWTR.Fonts and WOWTR.Fonts.Apply and Storyline_NPCFrame then
      WOWTR.Fonts.Apply(Storyline_NPCFrame)
   end

   -- Make Storyline dialog "typewriter" animation feel RTL by right-justifying the chat text box.
   if Storyline_NPCFrameChatText and Storyline_NPCFrameChatText.SetJustifyH then
      Storyline_NPCFrameChatText:SetJustifyH("RIGHT")
   end
end

local function EnsureStorylineEventInfo()
   if not Storyline_NPCFrameChat then return false end
   if Storyline_NPCFrameChat.eventInfo then return true end

   -- Try to (re)initialize the event structure if it hasn't been built yet.
   if (not _G.EVENT_INFO) and Storyline_API and type(Storyline_API.initEventsStructure) == "function" then
      pcall(Storyline_API.initEventsStructure)
   end

   -- Hydrate chat.eventInfo from Storyline's EVENT_INFO table if possible.
   if _G.EVENT_INFO and Storyline_NPCFrameChat.event then
      Storyline_NPCFrameChat.eventInfo = _G.EVENT_INFO[Storyline_NPCFrameChat.event]
   end

   return Storyline_NPCFrameChat.eventInfo ~= nil
end

local function SafePlayNext(targetModel, attempt)
   attempt = tonumber(attempt) or 0
   if not (Storyline_API and type(Storyline_API.playNext) == "function") then return end
   if not Storyline_NPCFrameChat then return end

   if not EnsureStorylineEventInfo() then
      -- Storyline hasn't finished initializing this dialog yet; retry briefly instead of crashing.
      if C_Timer and C_Timer.After and attempt < 20 then
         C_Timer.After(0.05, function()
            SafePlayNext(targetModel, attempt + 1)
         end)
      end
      return
   end

   pcall(Storyline_API.playNext, targetModel)
end

function StorylinePlugin.isStoryline()
   if (Storyline_NPCFrame ~= nil ) then         -- StoryLine addon is running
      if (QTR_ToggleButton5==nil) then
         -- button with quest ID
         QTR_ToggleButton5 = CreateFrame("Button",nil, Storyline_NPCFrameChat, "UIPanelButtonTemplate")
         QTR_ToggleButton5:SetWidth(150)
         QTR_ToggleButton5:SetHeight(20)
         QTR_ToggleButton5:SetText(QTR_ReverseIfAR(WOWTR_Localization.choiceQuestFirst))
         QTR_ToggleButton5:ClearAllPoints()
         QTR_ToggleButton5:SetPoint("BOTTOMLEFT", Storyline_NPCFrameChat, "BOTTOMLEFT", 244, -16)
         QTR_ToggleButton5:SetScript("OnClick", QTR_ON_OFF)
         Storyline_NPCFrameObjectivesContent:HookScript("OnShow", function() StorylinePlugin.QTR_Storyline_Objectives() end)
         Storyline_NPCFrameRewards:HookScript("OnShow", function() StorylinePlugin.QTR_Storyline_Rewards() end)
         Storyline_NPCFrameChat:HookScript("OnHide", function() StorylinePlugin.QTR_Storyline_Hide() end)
         QTR_ToggleButton5:Disable()

         -- Apply AR-only font + RTL animation tweaks whenever Storyline shows.
         if Storyline_NPCFrameChat and Storyline_NPCFrameChat.HookScript then
            Storyline_NPCFrameChat:HookScript("OnShow", ApplyArabicStorylineFixes)
         end
      end

      -- Ensure fixes apply even if we missed the first OnShow.
      ApplyArabicStorylineFixes()
      if (QTR_PS["storyline"]=="0") then       -- StoryLine active but translations disabled
         QTR_ToggleButton5:Hide()
         return false
      else
         QTR_ToggleButton5:Show()
         return true
      end
   else
      return false
   end
end

function StorylinePlugin.QTR_Storyline_Delay()
   StorylinePlugin.QTR_Storyline(1)
end

function StorylinePlugin.QTR_Storyline_Quest()
   if (QTR_PS["active"]=="1" and QTR_PS["storyline"]=="1" and Storyline_NPCFrame:IsVisible()) then
      QTR_QuestPrepare('')
   end
end

function StorylinePlugin.QTR_Storyline_Hide()
   if (QTR_PS["active"]=="1" and QTR_PS["storyline"]=="1") then
      QTR_ToggleButton5:Hide()
   end
end

function StorylinePlugin.QTR_Storyline_Objectives()
   if (QTR_PS["active"]=="1" and QTR_PS["storyline"]=="1" and QTR_quest_ID>0) then
      local string_ID= tostring(QTR_quest_ID)
      Storyline_NPCFrameObjectivesContent.Title:SetText(QTR_ReverseIfAR(WOWTR_Localization.objectives))
      Storyline_NPCFrameObjectivesContent.Title:SetFont(WOWTR_Font1, 13)
      if (QTR_QuestData[string_ID] ) then
         Storyline_NPCFrameObjectivesContent.Objectives:SetText(QTR_ExpandUnitInfo(QTR_QuestData[string_ID]["Objectives"],true,Storyline_NPCFrameObjectivesContent.Objectives,WOWTR_Font2,-40))
         Storyline_NPCFrameObjectivesContent.Objectives:SetFont(WOWTR_Font2, 13)
      end
      if (Storyline_RewardsHeader0) then
         Storyline_RewardsHeader0:SetText(QTR_ReverseIfAR(QTR_quest_LG[QTR_quest_ID].itemreceive))
         Storyline_RewardsHeader0:SetFont(WOWTR_Font1, 13)
      end
      if (Storyline_RewardsHeader1) then
         if (Storyline_RewardsHeader1:GetText() == REWARD_AURA) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_aura))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         elseif (Storyline_RewardsHeader1:GetText() == REWARD_SPELL) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_spell))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         elseif (Storyline_RewardsHeader1:GetText() == REWARD_COMPANION) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_companion))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         elseif (Storyline_RewardsHeader1:GetText() == REWARD_FOLLOWER) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_follower))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         elseif (Storyline_RewardsHeader1:GetText() == REWARD_REPUTATION) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_reputation))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         elseif (Storyline_RewardsHeader1:GetText() == REWARD_TITLE) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_title))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         elseif (Storyline_RewardsHeader1:GetText() == REWARD_TRADESKILL) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_tradeskill))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         elseif (Storyline_RewardsHeader1:GetText() == REWARD_UNLOCK) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_unlock))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         elseif (Storyline_RewardsHeader1:GetText() == REWARD_BONUS) then
            Storyline_RewardsHeader1:SetText(QTR_ReverseIfAR(QTR_Messages.reward_bonus))
            Storyline_RewardsHeader1:SetFont(WOWTR_Font1, 13)
         end
      end
   end
end

function StorylinePlugin.QTR_Storyline_Rewards()
   if (QTR_PS["active"]=="1" and QTR_PS["storyline"]=="1") then
      Storyline_NPCFrameRewards.Content.Title:SetText(QTR_ReverseIfAR(WOWTR_Localization.rewards))
   end
end

function StorylinePlugin.QTR_Storyline(nr)
   ApplyArabicStorylineFixes()
   if (QTR_PS["transtitle"]=="1") then
      Storyline_NPCFrame.Banner.Title:SetText(QTR_ReverseIfAR(QTR_quest_LG[QTR_quest_ID].title))
      Storyline_NPCFrame.Banner.Title:SetFont(WOWTR_Font1, 18)
   end
   local string_ID= tostring(QTR_quest_ID)
   local texts = { "" }
   local arRight = IsArabicUI() and true or nil
   if ((Storyline_NPCFrameChat.event ~= nil) and (QTR_QuestData[string_ID] ~= nil))then
      local event = Storyline_NPCFrameChat.event
      if (event=="QUEST_DETAIL") then
           texts = { strsplit("\n", QTR_ExpandUnitInfo(QTR_QuestData[string_ID]["Description"],false,Storyline_NPCFrameChatText,WOWTR_Font2,-15, arRight)) }
      end
      if (event=="QUEST_PROGRESS") then
           texts = { strsplit("\n", QTR_ExpandUnitInfo(QTR_QuestData[string_ID]["Progress"],false,Storyline_NPCFrameChatText,WOWTR_Font2, 0, arRight)) }
      end
      if (event=="QUEST_COMPLETE") then
           texts = { strsplit("\n", QTR_ExpandUnitInfo(QTR_QuestData[string_ID]["Completion"],false,Storyline_NPCFrameChatText,WOWTR_Font2, 0, arRight)) }
      end
   end
   local ileOry = #Storyline_NPCFrameChat.texts
   local indeks = 0
   for i=1,#texts do
      if texts[i]:len() > 0 then
         if (indeks<ileOry) then
            indeks=indeks+1
            Storyline_NPCFrameChat.texts[indeks]=texts[i]
         end
      end
   end
   Storyline_NPCFrameChatText:SetFont(WOWTR_Font2, 16)
   if (nr==1) then      -- Reload text
      Storyline_NPCFrameObjectivesContent:Hide()
      Storyline_NPCFrameChat.currentIndex = 0
      SafePlayNext(Storyline_NPCFrameModelsYou)   -- reload
   end
end

function StorylinePlugin.QTR_Storyline_Gossip()
   ApplyArabicStorylineFixes()
   Storyline_NPCFrameChatText:SetFont(WOWTR_Font2, 16)
   if (not txt0txt) then return; end
   local texts = { "" }
   texts = { strsplit("\n\n", txt0txt) }
   if (Storyline_NPCFrameChat.texts) then
      local ileOry = #Storyline_NPCFrameChat.texts
      local indeks = 0
      for i=1,#texts do
         if texts[i]:len() > 0 then
            if (indeks<ileOry) then
               indeks=indeks+1
               Storyline_NPCFrameChat.texts[indeks]=texts[i]
            end
         end
      end
      Storyline_NPCFrameObjectivesContent:Hide()
      Storyline_NPCFrameChat.currentIndex = 0
      SafePlayNext(Storyline_NPCFrameModelsYou)   -- reload
   end
end

function StorylinePlugin.QTR_Storyline_OFF(nr)
   ApplyArabicStorylineFixes()
   if (QTR_PS["transtitle"]=="1") then
      Storyline_NPCFrame.Banner.Title:SetText(QTR_quest_EN[QTR_quest_ID].title)
      Storyline_NPCFrame.Banner.Title:SetFont(Original_Font2, 18)
   end
   local string_ID= tostring(QTR_quest_ID)
   local texts = { "" }
   if ((Storyline_NPCFrameChat.event ~= nil) and (QTR_QuestData[string_ID] ~= nil))then
      local event = Storyline_NPCFrameChat.event
      if (event=="QUEST_DETAIL") then
           texts = { strsplit("\n", GetQuestText()) }
      end
      if (event=="QUEST_PROGRESS") then
           texts = { strsplit("\n", GetProgressText()) }
      end
      if (event=="QUEST_COMPLETE") then
           texts = { strsplit("\n", GetRewardText()) }
      end
   end
   local ileOry = #Storyline_NPCFrameChat.texts
   local indeks = 0
   for i=1,#texts do
      if texts[i]:len() > 0 then
         if (indeks<ileOry) then
            indeks=indeks+1
            Storyline_NPCFrameChat.texts[indeks]=texts[i]
         end
      end
   end
   Storyline_NPCFrameChatText:SetFont(Original_Font2, 16)
   if (nr==1) then      -- Reload text
      Storyline_NPCFrameObjectivesContent:Hide()
      Storyline_NPCFrameChat.currentIndex = 0
      SafePlayNext(Storyline_NPCFrameModelsYou)   -- reload
   end
end

return StorylinePlugin
