-- Config/Main.lua
-- Ace3-backed configuration orchestrator (moved from common/WoW_Config.lua)
-------------------------------------------------------------------------------------------------------

WOWTR = WOWTR or {}

function Config_OnEnable()
  if WOWTR.Config and WOWTR.Config.Init then
    WOWTR.Config.Init()
  end
end

function WOWTR_SlashCommand(msg)
  if WOWTR.Config and WOWTR.Config.Open then
    WOWTR.Config.Open()
  end
end

function WOWTR_WelcomePanel()
  QTR_PS = QTR_PS or {}
  QTR_PS["welcome"] = "1"
  if WOWTR.Config and WOWTR.Config.Open then
    WOWTR.Config.Open()
  end
end

