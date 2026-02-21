-- ImmersionPlugin.lua
-- Plugin for handling Immersion addon integration

-- luacheck: globals ImmersionFrame ImmersionContentFrame
---@diagnostic disable: undefined-global
ImmersionPlugin = {}

function ImmersionPlugin.isImmersion()
   if (ImmersionFrame ~= nil ) then            -- Immersion addon is running
      if (QTR_ToggleButton4==nil) then
         -- button with quest ID
         QTR_ToggleButton4 = CreateFrame("Button",nil, ImmersionFrame.TalkBox, "UIPanelButtonTemplate")
         QTR_ToggleButton4:SetWidth(150)
         QTR_ToggleButton4:SetHeight(20)
         QTR_ToggleButton4:SetText(QTR_ReverseIfAR(WOWTR_Localization.choiceQuestFirst))
         QTR_ToggleButton4:ClearAllPoints()
         QTR_ToggleButton4:SetPoint("TOPLEFT", ImmersionFrame.TalkBox, "TOPRIGHT", -200, -116)
         QTR_ToggleButton4:SetScript("OnClick", QTR_ON_OFF)
         ImmersionFrame.TalkBox:HookScript("OnHide",function() QTR_ToggleButton4:Hide() end)
         QTR_ToggleButton4:Disable()          -- disable button initially
      end
      if (QTR_PS["immersion"]=="0") then       -- Immersion active but translations disabled
         QTR_ToggleButton4:Hide()
         return false
      else
         QTR_ToggleButton4:Show()
         return true
      end
   else
      return false
   end
end

function ImmersionPlugin.QTR_Immersion()
   ImmersionContentFrame.ObjectivesText:SetFont(WOWTR_Font2, 14)
   ImmersionContentFrame.ObjectivesText:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].objectives,true,ImmersionContentFrame.ObjectivesText,WOWTR_Font2))
   ImmersionFrame.TalkBox.NameFrame.Name:SetFont(WOWTR_Font1, 20)
   ImmersionFrame.TalkBox.NameFrame.Name:SetText(QTR_ReverseIfAR(QTR_quest_LG[QTR_quest_ID].title))
   ImmersionFrame.TalkBox.TextFrame.Text:SetFont(WOWTR_Font2, 14)
   if (QTR_quest_EN[QTR_quest_ID].completion and (strlen(QTR_quest_LG[QTR_quest_ID].completion)>1)) then
      ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].completion,false,ImmersionFrame.TalkBox.TextFrame.Text,WOWTR_Font2))
   elseif (QTR_quest_EN[QTR_quest_ID].progress and (strlen(QTR_quest_LG[QTR_quest_ID].progress)>1)) then
      ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].progress,false,ImmersionFrame.TalkBox.TextFrame.Text,WOWTR_Font2))
   elseif (QTR_quest_EN[QTR_quest_ID].details and (strlen(QTR_quest_LG[QTR_quest_ID].details)>1)) then
      ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].details,false,ImmersionFrame.TalkBox.TextFrame.Text,WOWTR_Font2))
   end
   ImmersionPlugin.QTR_Immersion_Static()
end

function ImmersionPlugin.QTR_Immersion_Static()
   ImmersionContentFrame.ObjectivesHeader:SetFont(WOWTR_Font1, 18)
   ImmersionContentFrame.ObjectivesHeader:SetText(QTR_ReverseIfAR(QTR_Messages.objectives))
   ImmersionContentFrame.RewardsFrame.Header:SetFont(WOWTR_Font1, 18)
   ImmersionContentFrame.RewardsFrame.Header:SetText(QTR_ReverseIfAR(QTR_Messages.rewards))
   ImmersionContentFrame.RewardsFrame.ItemChooseText:SetFont(WOWTR_Font2, 13)
   ImmersionContentFrame.RewardsFrame.ItemChooseText:SetText(QTR_ReverseIfAR(QTR_quest_LG[QTR_quest_ID].itemchoose))
   ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetFont(WOWTR_Font2, 13)
   ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetText(QTR_ReverseIfAR(QTR_quest_LG[QTR_quest_ID].itemreceive))
   ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetFont(WOWTR_Font2, 13)
   ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetText(QTR_ReverseIfAR(QTR_Messages.experience))
   ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetFont(WOWTR_Font1, 18)
   ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetText(QTR_ReverseIfAR(QTR_Messages.reqitems))
   for fontString in ImmersionContentFrame.RewardsFrame.spellHeaderPool:EnumerateActive() do
      if (fontString:GetText() == REWARD_AURA) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_aura))
         fontString:SetFont(WOWTR_Font2, 13)
      end
      if (fontString:GetText() == REWARD_SPELL) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_spell))
         fontString:SetFont(WOWTR_Font2, 13)
      end
      if (fontString:GetText() == REWARD_COMPANION) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_companion))
         fontString:SetFont(WOWTR_Font2, 13)
      end
      if (fontString:GetText() == REWARD_FOLLOWER) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_follower))
         fontString:SetFont(WOWTR_Font2, 13)
      end
      if (fontString:GetText() == REWARD_REPUTATION) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_reputation))
         fontString:SetFont(WOWTR_Font2, 13)
      end
      if (fontString:GetText() == REWARD_TITLE) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_title))
         fontString:SetFont(WOWTR_Font2, 13)
      end
      if (fontString:GetText() == REWARD_TRADESKILL) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_tradeskill))
         fontString:SetFont(WOWTR_Font2, 13)
      end
      if (fontString:GetText() == REWARD_UNLOCK) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_unlock))
         fontString:SetFont(WOWTR_Font2, 13)
      end
      if (fontString:GetText() == REWARD_BONUS) then
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reward_bonus))
         fontString:SetFont(WOWTR_Font2, 13)
      end
   end
end

function ImmersionPlugin.QTR_Immersion_OFF()
   ImmersionContentFrame.ObjectivesText:SetFont(Original_Font2, 14)
   ImmersionContentFrame.ObjectivesText:SetText(QTR_quest_EN[QTR_quest_ID].objectives)
   ImmersionFrame.TalkBox.NameFrame.Name:SetFont(Original_Font1, 20)
   ImmersionFrame.TalkBox.NameFrame.Name:SetText(QTR_quest_EN[QTR_quest_ID].title)
   ImmersionFrame.TalkBox.TextFrame.Text:SetFont(Original_Font2, 14)
   if (QTR_quest_EN[QTR_quest_ID].completion and (strlen(QTR_quest_EN[QTR_quest_ID].completion)>0)) then
      ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN[QTR_quest_ID].completion)
   elseif (QTR_quest_EN[QTR_quest_ID].progress and (strlen(QTR_quest_EN[QTR_quest_ID].progress)>0)) then
      ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN[QTR_quest_ID].progress)
   else
      ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_quest_EN[QTR_quest_ID].details)
   end
   ImmersionPlugin.QTR_Immersion_OFF_Static()
end

function ImmersionPlugin.QTR_Immersion_OFF_Static()
   ImmersionContentFrame.ObjectivesHeader:SetFont(Original_Font1, 18)
   ImmersionContentFrame.ObjectivesHeader:SetText(QTR_MessOrig.objectives)
   ImmersionContentFrame.RewardsFrame.Header:SetFont(Original_Font1, 18)
   ImmersionContentFrame.RewardsFrame.Header:SetText(QTR_MessOrig.rewards)
   ImmersionContentFrame.RewardsFrame.ItemChooseText:SetFont(Original_Font2, 13)
   ImmersionContentFrame.RewardsFrame.ItemChooseText:SetText(QTR_quest_EN[QTR_quest_ID].itemchoose)
   ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetFont(Original_Font2, 13)
   ImmersionContentFrame.RewardsFrame.ItemReceiveText:SetText(QTR_quest_EN[QTR_quest_ID].itemreceive)
   ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetFont(Original_Font2, 13)
   ImmersionContentFrame.RewardsFrame.XPFrame.ReceiveText:SetText(QTR_MessOrig.experience)
   ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetFont(Original_Font1, 18)
   ImmersionFrame.TalkBox.Elements.Progress.ReqText:SetText(QTR_MessOrig.reqitems)
end

return ImmersionPlugin
