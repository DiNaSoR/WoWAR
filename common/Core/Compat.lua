-- Compat.lua
-- Central registry for legacy global entrypoints (ST_*), backed by namespaced modules.

local addonName, ns = ...
ns = ns or {}

local function bind(name, getter)
  if type(_G[name]) == "function" then return end
  _G[name] = function(...)
    local fn = getter and getter()
    if type(fn) == "function" then
      return fn(...)
    end
  end
end

-- UI: Group Finder
bind("ST_GroupFinder", function()
  return ns.UI and ns.UI.GroupFinder and ns.UI.GroupFinder.GroupFinder
end)
bind("ST_GroupPVPFinder", function()
  return ns.UI and ns.UI.GroupFinder and ns.UI.GroupFinder.GroupPVPFinder
end)
bind("ST_GroupMplusFinder", function()
  return ns.UI and ns.UI.GroupFinder and ns.UI.GroupFinder.GroupMplusFinder
end)

-- UI: Adventure Guide / Encounter Journal
bind("ST_SuggestTabClick", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.SuggestTabClick
end)
bind("ST_showLoreDescription", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.ShowLoreDescription
end)
bind("ST_showDelveDifficultFrame", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.ShowDelveDifficultFrame
end)
bind("ST_UpdateJournalEncounterBossInfo", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.UpdateJournalEncounterBossInfo
end)
bind("ST_SaveOriginalText", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.SaveOriginalText
end)
bind("ST_BossHeaderTabText", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.BossHeaderTabText
end)
bind("ST_UpdateBossDescriptionFont", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.UpdateBossDescriptionFont
end)
bind("ST_clickBosses", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.ClickBosses
end)
bind("ST_AdventureGuidebutton", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.AdventureGuideButton
end)
bind("ST_ShowAbility", function()
  return ns.UI and ns.UI.AdventureGuide and ns.UI.AdventureGuide.ShowAbility
end)

-- UI: Misc Frames
bind("ST_updateSpellBookFrame", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.UpdateSpellBookFrame
end)
bind("ST_StaticPopup1", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.StaticPopup1
end)
bind("ST_WorldMapFunc", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.WorldMapFunc
end)
bind("ST_MerchantFrame", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.MerchantFrame
end)
bind("ST_GameMenuTranslate", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.GameMenuTranslate
end)
bind("ST_MountJournal", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.MountJournal
end)
bind("ST_MountJournalbutton", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.MountJournalButton
end)
bind("ST_CharacterFrame", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.CharacterFrame
end)
bind("ST_FriendsFrame", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.FriendsFrame
end)
bind("ST_HelpPlateTooltip", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.HelpPlateTooltip
end)
bind("ST_SplashFrame", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.SplashFrame
end)
bind("ST_PingSystemTutorial", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.PingSystemTutorial
end)
bind("ST_WarbandBankFrm", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.WarbandBankFrame
end)
bind("ST_ItemRefTooltip", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.ItemRefTooltip
end)
bind("ST_ItemUpgradeFrm", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.ItemUpgradeFrame
end)
bind("ST_WeeklyRewardsFrame", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.WeeklyRewardsFrame
end)
bind("ST_EventToastManagerFrame", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.EventToastManagerFrame
end)
bind("ST_RaidBossEmoteFrame", function()
  return ns.UI and ns.UI.Frames and ns.UI.Frames.RaidBossEmoteFrame
end)

return true


