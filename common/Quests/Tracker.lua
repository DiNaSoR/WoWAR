-- Quests/Tracker.lua
-- Objective tracker related logic

local addonName, ns = ...
ns = ns or {}
ns.Quests = ns.Quests or {}
local Quests = ns.Quests

Quests.Tracker = Quests.Tracker or {}

-- Translation of Objective Tracker category titles
function Quests.Tracker.ObjectiveTrackerFrame_Titles()
   if (QTR_PS["active"]=="1" and QTR_PS["tracker"]=="1") then
      ObjectiveTrackerFrame.Header.Text:SetText(QTR_ReverseIfAR(WOWTR_Localization.objectives))
      ObjectiveTrackerFrame.Header.Text:SetFont(WOWTR_Font2, 14)
      QuestObjectiveTracker.Header.Text:SetText(QTR_ReverseIfAR(WOWTR_Localization.quests))
      QuestObjectiveTracker.Header.Text:SetFont(WOWTR_Font2, 14)
      WorldQuestObjectiveTracker.Header.Text:SetText(QTR_ReverseIfAR(WOWTR_Localization.worldquests))
      WorldQuestObjectiveTracker.Header.Text:SetFont(WOWTR_Font2, 14)
      CampaignQuestObjectiveTracker.Header.Text:SetText(QTR_ReverseIfAR(WOWTR_Localization.campaignquests))
      CampaignQuestObjectiveTracker.Header.Text:SetFont(WOWTR_Font2, 14)
      BonusObjectiveTracker.Header.Text:SetText(QTR_ReverseIfAR(WOWTR_Localization.bonusobjective))
      BonusObjectiveTracker.Header.Text:SetFont(WOWTR_Font2, 14)
      MonthlyActivitiesObjectiveTracker.Header.Text:SetText(QTR_ReverseIfAR(WOWTR_Localization.travelerlog))
      MonthlyActivitiesObjectiveTracker.Header.Text:SetFont(WOWTR_Font2, 14)
      ScenarioObjectiveTracker.Header.Text:SetText(QTR_ReverseIfAR(WOWTR_Localization.scenariodung))
      ScenarioObjectiveTracker.Header.Text:SetFont(WOWTR_Font2, 14)

      if Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL() then
         ObjectiveTrackerFrame.Header.Text:SetFont(WOWTR_Font1, 14)
         QuestObjectiveTracker.Header.Text:SetFont(WOWTR_Font1, 14)
         WorldQuestObjectiveTracker.Header.Text:SetFont(WOWTR_Font1, 14)
         CampaignQuestObjectiveTracker.Header.Text:SetFont(WOWTR_Font1, 14)
         BonusObjectiveTracker.Header.Text:SetFont(WOWTR_Font1, 14)
         MonthlyActivitiesObjectiveTracker.Header.Text:SetFont(WOWTR_Font1, 14)
         ScenarioObjectiveTracker.Header.Text:SetFont(WOWTR_Font1, 14)
         ns.RTL.JustifyFontString(ObjectiveTrackerFrame.Header.Text, "LEFT")
         ns.RTL.JustifyFontString(QuestObjectiveTracker.Header.Text, "LEFT")
         ns.RTL.JustifyFontString(WorldQuestObjectiveTracker.Header.Text, "LEFT")
         ns.RTL.JustifyFontString(CampaignQuestObjectiveTracker.Header.Text, "LEFT")
         ns.RTL.JustifyFontString(BonusObjectiveTracker.Header.Text, "LEFT")
         ns.RTL.JustifyFontString(MonthlyActivitiesObjectiveTracker.Header.Text, "LEFT")
         ns.RTL.JustifyFontString(ScenarioObjectiveTracker.Header.Text, "LEFT")
      end
   end
end

-- Overwrite quest titles inside tracker blocks on updates
function Quests.Tracker.OverrideObjectiveTrackerHeader(tracker, quest, directID)
   local questID
   if directID then
      questID = quest
   else
      questID = quest and tonumber(quest:GetID())
   end
   if not questID or questID == 0 then return end

   local template = tracker.blockTemplate or "ObjectiveTrackerBlockTemplate"
   local questBlocks = tracker.usedBlocks and tracker.usedBlocks[template]
   if not questBlocks then return end

   local block = questBlocks[questID]
   if not (block and block.HeaderText) then return end

   if ( QTR_QuestData[tostring(questID)] ) and (QTR_PS["transtitle"] == "1") then
      local questDataTitle = QTR_QuestData[tostring(questID)]["Title"]
      if questDataTitle then
         local size = 12
         if Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL() then size = 14 end
         if Quests.Utils and Quests.Utils.ApplyRTLText then
            Quests.Utils.ApplyRTLText(block.HeaderText, questDataTitle, (Quests.Utils.IsRTL() and WOWTR_Font1 or WOWTR_Font2), size, -50, "LEFT")
         else
            block.HeaderText:SetText(QTR_ExpandUnitInfo(questDataTitle, false, block.HeaderText, WOWTR_Font1, -50))
            block.HeaderText:SetJustifyH((ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) and "RIGHT" or "LEFT")
         end
      end
   end
end

-- Update QuestLog/Map list entries and objective summaries
function Quests.Tracker.QuestLogQuests_Update()
   if not (QTR_PS["active"] == "1" and QTR_PS["tracker"] == "1") then return end

   local isRTL = Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL() or false
   local defaultJustification = "LEFT"
   local rtlJustification = "RIGHT"

   local function ApplyFormatting(element, textToSet, fontToSet, size, justification)
       local oldH = element:GetHeight()
       element:SetText(textToSet)
       element:SetFont(fontToSet, size)
       element:SetJustifyH(justification)
       element:SetHeight(oldH)
   end

   for button in QuestScrollFrame.titleFramePool:EnumerateActive() do
       local questID = button.questID
       local str_ID = tostring(questID)
       local textElement = button.Text
       local originalFont, originalSize = textElement:GetFont()
       local textToSet, fontToSet = nil, originalFont
       local justification = defaultJustification
       local applyReversal = false

       local hasQuestDataTranslation = (QTR_QuestData and QTR_QuestData[str_ID] and QTR_QuestData[str_ID]["Title"]) ~= nil
       if QTR_PS["transtitle"] == "1" and hasQuestDataTranslation then
           textToSet = QTR_QuestData[str_ID]["Title"]
           fontToSet = WOWTR_Font2
           justification = isRTL and rtlJustification or defaultJustification
           applyReversal = isRTL
       end
       if applyReversal and textToSet then
           textToSet = QTR_ExpandUnitInfo(textToSet, false, textElement, fontToSet, -5)
       end
       ApplyFormatting(textElement, textToSet or textElement:GetText(), fontToSet, originalSize, justification)
   end

   for frame in QuestScrollFrame.objectiveFramePool:EnumerateActive() do
       local questID = frame.questID
       local str_ID = tostring(questID)
       local textElement = frame.Text
       local originalText = textElement:GetText()
       local originalFont, originalSize = textElement:GetFont()

       local textToSet = nil
       local fontToSet = originalFont
       local justification = defaultJustification
       local translationSourceIsQuestData = false
       local applyTranslationFormatting = false

       if ((originalText == QUEST_WATCH_QUEST_READY) or (originalText == "Ready for turn-in")) then
           textToSet = QTR_ExpandUnitInfo(WOWTR_Localization.readyForTurnIn, false, textElement, WOWTR_Font2, -5)
           applyTranslationFormatting = true
       else
           if QTR_QuestData and QTR_QuestData[str_ID] and QTR_QuestData[str_ID]["Objectives"] then
               textToSet = QTR_QuestData[str_ID]["Objectives"]
               translationSourceIsQuestData = true
               applyTranslationFormatting = true
           end
       end

       if applyTranslationFormatting then
            fontToSet = WOWTR_Font2
            justification = isRTL and rtlJustification or defaultJustification
       end

       if textToSet then
           local cleanedText = string.gsub(textToSet, "\r", "")
           cleanedText = string.gsub(cleanedText, "\n", " ")
           cleanedText = string.gsub(cleanedText, "$B", " ")
           local finalText = cleanedText
           if translationSourceIsQuestData and isRTL then
                finalText = QTR_ExpandUnitInfo(cleanedText, false, textElement, fontToSet, -5)
           end
           ApplyFormatting(textElement, finalText, fontToSet, originalSize, justification)
       else
           ApplyFormatting(textElement, originalText, originalFont, originalSize, defaultJustification)
       end
   end

   Quests.UI = Quests.UI or {}
   if Quests.UI.QuestScrollFrame_OnShow then
      Quests.UI.QuestScrollFrame_OnShow()
   end
end

-- Back-compat global wrappers
function QTR_ObjectiveTrackerFrame_Titles() return Quests.Tracker.ObjectiveTrackerFrame_Titles() end
function QTR_QuestLogQuests_Update() return Quests.Tracker.QuestLogQuests_Update() end
function QTR_OverrideObjectiveTrackerHeader(tracker, quest, directID) return Quests.Tracker.OverrideObjectiveTrackerHeader(tracker,quest,directID) end
