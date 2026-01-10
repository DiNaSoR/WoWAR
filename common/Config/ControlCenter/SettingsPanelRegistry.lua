-- common/Config/ControlCenter/SettingsPanelRegistry.lua
-- Registers the ControlCenter settings panel with Blizzard Settings (Retail) and wires Escape-to-close behavior.

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.ControlCenter = WOWTR.Config.ControlCenter or {}

local ControlCenter = WOWTR.Config.ControlCenter

local MainFrame = ControlCenter and ControlCenter.SettingsPanel
if not MainFrame then
  -- SettingsPanel.lua must be loaded before this file (see WoWAR.toc order).
  return
end

local function SafeReverseIfAR(text)
  local f = _G.QTR_ReverseIfAR
  if type(f) == "function" then
    return f(text)
  end
  return text
end

local function GetOptionTitle()
  return SafeReverseIfAR((WoWTR_Localization and WoWTR_Localization.optionTitle) or "WoWLang")
end

-- Blizzard Settings integration (Retail Settings API)
local BlizzardPanel = CreateFrame("Frame", nil, UIParent)
BlizzardPanel:Hide()

local function RegisterBlizzardCategory()
  if not (Settings and Settings.RegisterCanvasLayoutCategory) then return end
  if ControlCenter._blizzardCategoryRegistered then return end
  ControlCenter._blizzardCategoryRegistered = true

  local category = Settings.RegisterCanvasLayoutCategory(BlizzardPanel, GetOptionTitle())
  Settings.RegisterAddOnCategory(category)

  -- Keep a reference so other code can open the correct category
  local id = category
  if type(category) == "table" and category.GetID then
    id = category:GetID()
  end
  WOWTR.ControlCenterCategoryID = id

  BlizzardPanel:SetScript("OnShow", function(self)
    MainFrame:Hide()
    MainFrame:SetParent(BlizzardPanel)
    MainFrame:ClearAllPoints()
    MainFrame:SetPoint("TOPLEFT", self, "TOPLEFT", -10, 6)
    MainFrame:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
    MainFrame:ShowUI("blizzard")
  end)

  BlizzardPanel:SetScript("OnHide", function(self)
    self:Hide()
    MainFrame:Hide()
  end)
end

-- Delay registration until the next frame if QTR_ReverseIfAR isn't ready yet (defined later in `common/Text.lua`).
if Settings and Settings.RegisterCanvasLayoutCategory then
  if type(_G.QTR_ReverseIfAR) == "function" then
    RegisterBlizzardCategory()
  elseif C_Timer and C_Timer.After then
    C_Timer.After(0, RegisterBlizzardCategory)
  else
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(self)
      self:SetScript("OnUpdate", nil)
      RegisterBlizzardCategory()
    end)
  end
end

-- Press Escape to close (standalone mode only)
do
  local CloseDummy = CreateFrame("Frame", "WOWTRSettingsPanelSpecialFrame", UIParent)
  CloseDummy:Hide()
  table.insert(UISpecialFrames, CloseDummy:GetName())

  CloseDummy:SetScript("OnHide", function()
    if MainFrame and MainFrame.HandleEscape then
      if MainFrame:HandleEscape() then
        CloseDummy:Show()
      end
    end
  end)

  MainFrame:HookScript("OnShow", function()
    if MainFrame.mode == "standalone" then
      CloseDummy:Show()
    end
  end)

  MainFrame:HookScript("OnHide", function()
    CloseDummy:Hide()
  end)
end

-- Public toggles
do
  local function ToggleSettings()
    if BlizzardPanel:IsShown() then
      -- If the user is already inside Blizzard Settings, don't spawn the standalone panel.
      return
    end

    if MainFrame:IsShown() then
      MainFrame:Hide()
    else
      MainFrame:ClearAllPoints()
      MainFrame:SetParent(UIParent)
      MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
      MainFrame:ShowUI("standalone")
    end
  end

  ControlCenter.ToggleSettings = ToggleSettings
  _G.WOWTR_ToggleSettings = ToggleSettings
end


