-- Quests/UI.lua
-- UI helpers for quest panes and additional quest UI strings

local addonName, ns = ...
ns = ns or {}
ns.Quests = ns.Quests or {}
local Quests = ns.Quests

Quests.UI = Quests.UI or {}

function Quests.UI.QuestScrollFrame_OnShow()
   if (QTR_PS["active"]=="1" and QTR_PS["tracker"]=="1") then
      if (QuestScrollFrame.Contents.StoryHeader.Progress and QuestScrollFrame.Contents.StoryHeader.Progress:GetText()) then
         local txt = QuestScrollFrame.Contents.StoryHeader.Progress:GetText()
         txt = string.gsub(txt, "Story Progress", QTR_ReverseIfAR(WOWTR_Localization.storyLineProgress))
         txt = string.gsub(txt, "Chapters", QTR_ReverseIfAR(WOWTR_Localization.storyLineChapters))
         local _font1, _size1 = QuestScrollFrame.Contents.StoryHeader.Progress:GetFont()
         QuestScrollFrame.Contents.StoryHeader.Progress:SetText(txt)
         QuestScrollFrame.Contents.StoryHeader.Progress:SetFont(WOWTR_Font2, _size1)
         if Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL() then
            QuestScrollFrame.Contents.StoryHeader.Progress:ClearAllPoints()
            QuestScrollFrame.Contents.StoryHeader.Progress:SetPoint("TOPRIGHT", QuestScrollFrame.Contents.StoryHeader, "TOPRIGHT", -10, -40)
            QuestScrollFrame.Contents.StoryHeader.Progress:SetJustifyH("RIGHT")
         else
            QuestScrollFrame.Contents.StoryHeader.Progress:ClearAllPoints()
            QuestScrollFrame.Contents.StoryHeader.Progress:SetPoint("TOPLEFT", QuestScrollFrame.Contents.StoryHeader, "TOPLEFT", 10, -40)
            QuestScrollFrame.Contents.StoryHeader.Progress:SetJustifyH("LEFT")
         end
      end
   end
   if (TT_PS["ui1"]=="1") then
      local QuestScrollFrameText01 = QuestScrollFrame.EmptyText
      if QuestScrollFrameText01 then
         ST_CheckAndReplaceTranslationText(QuestScrollFrameText01, true, "ui")
      end
   end
end

function Quests.UI.QuestFrameButton_OnClick()
   if (not WOWTR_wait(0.5, Quests.UI.QuestFrameWithoutOpenQuestFrame)) then end
end

function Quests.UI.QuestFrameWithoutOpenQuestFrame()
   if (QuestFrame:IsVisible()) then
      if GossipOnQuestFrame then GossipOnQuestFrame() end
   end
end

-- Map Next Quest Objective
function Quests.UI.Quest_Next()
   if (TT_PS["ui1"] == "1") then
      local QuestMapNextObj = QuestScrollFrame.Contents
      local children = {QuestMapNextObj:GetChildren()}
      local foundQuestTexts = {}
      for i = 1, #children do
         if children[i] and children[i].NextObjective and children[i].NextObjective.Text then
            local questText = children[i].NextObjective.Text:GetText()
            if questText and questText ~= "" then
               table.insert(foundQuestTexts, children[i].NextObjective.Text)
            end
         end
      end
      for _, foundQuestText in ipairs(foundQuestTexts) do
         ST_CheckAndReplaceTranslationTextUI(foundQuestText, true, "Collections:Quest")
      end
   end
end

-- Back-compat wrappers
function QTR_QuestScrollFrame_OnShow() return Quests.UI.QuestScrollFrame_OnShow() end
function QTR_QuestFrameButton_OnClick() return Quests.UI.QuestFrameButton_OnClick() end
function QTR_QuestFrameWithoutOpenQuestFrame() return Quests.UI.QuestFrameWithoutOpenQuestFrame() end
function QTR_Quest_Next() return Quests.UI.Quest_Next() end
