-- common/Config/ControlCenter/Apply.lua
-- Safe runtime apply hooks for ControlCenter settings changes.
-- IMPORTANT: Must avoid forbidden Blizzard "force refresh" calls (see lessons.md).

local addonName, ns = ...

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.ControlCenter = WOWTR.Config.ControlCenter or {}

local ControlCenter = WOWTR.Config.ControlCenter

ControlCenter.Apply = ControlCenter.Apply or {}
local Apply = ControlCenter.Apply

local function SyncGlobals()
  if WOWTR and WOWTR.Config and WOWTR.Config.SyncGlobalsFromDB then
    WOWTR.Config.SyncGlobalsFromDB()
  end
end

local function IsQuestSetting(dbKey)
  if type(dbKey) ~= "string" then return false end
  return dbKey == "WOWTR_Quests" or dbKey:find("^WOWTR_Quests_") ~= nil
end

local function IsTooltipSetting(dbKey)
  if type(dbKey) ~= "string" then return false end
  return dbKey == "WOWTR_Tooltips" or dbKey:find("^WOWTR_Tooltips_") ~= nil
end

function Apply.OnSettingChanged(dbKey, value)
  -- Always keep legacy globals (QTR_PS, TT_PS, ...) in sync.
  SyncGlobals()

  -- Quests / QuestMapFrame: re-apply safely using the post-layout ticker.
  if IsQuestSetting(dbKey) then
    -- Turning OFF the master quest translation should immediately revert visible UI (safe, no forced refresh APIs).
    if dbKey == "WOWTR_Quests" and value == false then
      if type(_G.QTR_Translate_Off) == "function" then
        _G.QTR_Translate_Off(1)
      end

      -- If Gossip is open and was translated, restore it back.
      if _G.GossipFrame and _G.GossipFrame.IsVisible and _G.GossipFrame:IsVisible() then
        if type(_G.GS_ON_OFF) == "function" then
          pcall(_G.GS_ON_OFF)
        end
      end
    end

    if ns and ns.Quests and ns.Quests.Details and ns.Quests.Details.SchedulePostLayoutRefresh then
      ns.Quests.Details.SchedulePostLayoutRefresh()
    end
  end

  -- Tooltips: safest immediate feedback is to close the current tooltip (it will reopen with new rules).
  if IsTooltipSetting(dbKey) then
    if _G.GameTooltip and _G.GameTooltip.Hide then
      _G.GameTooltip:Hide()
    end
  end
end


