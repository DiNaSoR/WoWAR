-- DebugUI.lua — legacy shim
-- All functionality has migrated to DebugToolsUI.lua.
-- This file exists only for backwards compatibility with any code that
-- still calls WOWTR.DebugUI.Show() / Hide() / Toggle() / UpdateFrame().

WOWTR = WOWTR or {}
WOWTR.DebugUI = WOWTR.DebugUI or {}
local DebugUI = WOWTR.DebugUI

function DebugUI.Show()
  if WOWTR.DebugToolsUI and WOWTR.DebugToolsUI.Show then WOWTR.DebugToolsUI.Show() end
end

function DebugUI.Hide()
  if WOWTR.DebugToolsUI and WOWTR.DebugToolsUI.Hide then WOWTR.DebugToolsUI.Hide() end
end

function DebugUI.Toggle()
  if WOWTR.DebugToolsUI and WOWTR.DebugToolsUI.Toggle then WOWTR.DebugToolsUI.Toggle() end
end

function DebugUI.UpdateFrame()
  if WOWTR.DebugToolsUI and WOWTR.DebugToolsUI.UpdateSettings then WOWTR.DebugToolsUI.UpdateSettings() end
end

-- CreateFrame is intentionally a no-op; DebugToolsUI owns the frame.
function DebugUI.CreateFrame() return nil end
