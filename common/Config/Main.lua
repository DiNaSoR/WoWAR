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
  -- First-run welcome: show a modal with the same visual language as the ControlCenter config UI.
  -- The user confirms via the welcome button; that marks QTR_PS["welcome"] so it doesn't re-open.
  if WOWTR and WOWTR.Welcome and WOWTR.Welcome.Show then
    WOWTR.Welcome.Show()
    return
  end

  -- Fallback (shouldn't happen): open settings like legacy behavior.
  QTR_PS = QTR_PS or {}
  QTR_PS["welcome"] = "1"
  if WOWTR and WOWTR.Config and WOWTR.Config.Open then
    WOWTR.Config.Open()
  end
end

