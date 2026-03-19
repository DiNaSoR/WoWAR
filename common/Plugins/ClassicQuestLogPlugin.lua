-- ClassicQuestLogPlugin.lua
-- Plugin for handling ClassicQuestLog addon integration

-- luacheck: globals ClassicQuestLog
---@diagnostic disable: undefined-global
local addonName, ns = ...
ns = ns or {}
ns.Quests = ns.Quests or {}
local ToggleButtons = ns.Quests and ns.Quests.Utils and ns.Quests.Utils.ToggleButtons

ClassicQuestLogPlugin = {}

function ClassicQuestLogPlugin.isClassicQuestLog()
   if (ClassicQuestLog ~= nil ) then
      if (QTR_ToggleButton3==nil) then
         QTR_ToggleButton3 = ToggleButtons.Ensure("classic")
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
