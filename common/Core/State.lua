local addonName, ns = ...

ns.Core = ns.Core or {}

-- Shared constants and runtime state (kept global for backward compatibility where widely used)
NONBREAKINGSPACE = " ";

-- Player info used across modules
WOWTR_player_name = UnitName("player");
WOWTR_player_race = UnitRace("player");
WOWTR_player_class = UnitClass("player");
WOWTR_player_sex = UnitSex("player"); -- 1:neutral,  2:male,  3:female

-- Wait helpers state
WOWTR_waitTable = {};
WOWTR_waitFrame = nil;

-- Version ping state
WOWTR_time_ver = GetTime() - 15 * 60;
WOWTR_lastNotificationTime = 0;
WOWTR_notificationCooldown = 10800; -- 3 hours

function ns.Core.UpdatePlayerInfo()
  WOWTR_player_name = UnitName("player");
  WOWTR_player_race = UnitRace("player");
  WOWTR_player_class = UnitClass("player");
  WOWTR_player_sex = UnitSex("player");
end


