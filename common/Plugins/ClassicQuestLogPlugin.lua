-- ClassicQuestLogPlugin.lua
-- Plugin for handling ClassicQuestLog addon integration

-- luacheck: globals ClassicQuestLog
---@diagnostic disable: undefined-global
ClassicQuestLogPlugin = {}

function ClassicQuestLogPlugin.isClassicQuestLog()
   if (ClassicQuestLog ~= nil ) then
      if (QTR_ToggleButton3==nil) then
         -- button with quest ID in ClassicQuestLog
         QTR_ToggleButton3 = CreateFrame("Button",nil, ClassicQuestLog, "UIPanelButtonTemplate")
         QTR_ToggleButton3:SetWidth(150)
         QTR_ToggleButton3:SetHeight(20)
         QTR_ToggleButton3:SetText("Quest ID=?")
         QTR_ToggleButton3:ClearAllPoints()
         QTR_ToggleButton3:SetPoint("TOPLEFT", ClassicQuestLog, "TOPLEFT", 330, -33)
         QTR_ToggleButton3:SetScript("OnClick", QTR_ON_OFF)
         --ClassicQuestLog:HookScript("OnUpdate", function() QTR_PrepareDelay(1) end)
         ClassicQuestLog:HookScript("OnUpdate", function() QTR_PrepareDelay(1) end)
      end
      if (QTR_PS["questlog"]=="0") then       -- ClassicQuestLog active, but translation disabled
         QTR_ToggleButton3:Hide()
         return false
      else
         QTR_ToggleButton3:Show()
         return true
      end
   else
      return false
   end
end

return ClassicQuestLogPlugin
