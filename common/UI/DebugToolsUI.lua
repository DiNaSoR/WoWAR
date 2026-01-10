-- Debug Tools UI (floating helper panel)
-- Provides clickable actions for dump/clear commands (no need to type slash commands)

WOWTR = WOWTR or {}
WOWTR.DebugToolsUI = WOWTR.DebugToolsUI or {}

local UI = WOWTR.DebugToolsUI

local function _msg(text)
  if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
end

local function _getDumpCommand(frameOrShortcut, opts)
  local parts = {}
  parts[#parts + 1] = tostring(frameOrShortcut or "")
  if opts and opts.includeAll then parts[#parts + 1] = "all" end
  if opts and opts.includeNoise then parts[#parts + 1] = "noise" end
  if opts and opts.includeHidden then parts[#parts + 1] = "hidden" end
  return table.concat(parts, " ")
end

function UI.CreateFrame()
  if UI.frame then return UI.frame end

  local f = CreateFrame("Frame", "WOWTR_DebugToolsUIFrame", UIParent, "BackdropTemplate")
  f:SetSize(420, 260)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  f:Hide()
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

  local bg = f:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  bg:SetColorTexture(0.118, 0.114, 0.169, 0.95)

  f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
  })

  local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
  title:SetPoint("TOP", f, "TOP", 0, -18)
  title:SetText("WoWAR Debug Tools")
  title:SetJustifyH("CENTER")

  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -6)
  close:SetScript("OnClick", function() f:Hide() end)

  local hint = f:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  hint:SetPoint("TOP", title, "BOTTOM", 0, -6)
  hint:SetText("Click buttons instead of typing slash commands. (Export after /reload)")

  -- Frame/shortcut input
  local inputLabel = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  inputLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -60)
  inputLabel:SetText("Target frame/shortcut:")

  local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
  edit:SetAutoFocus(false)
  edit:SetSize(220, 20)
  edit:SetPoint("LEFT", inputLabel, "RIGHT", 10, 0)
  edit:SetText("prof")
  edit:SetCursorPosition(0)
  f.edit = edit

  -- Options checkboxes
  local opts = { includeAll = false, includeNoise = false, includeHidden = false }
  f.opts = opts

  local function mkCheck(text, x, y, field)
    local cb = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
    cb.text:SetText(text)
    cb:SetChecked(false)
    cb:SetScript("OnClick", function(self)
      opts[field] = self:GetChecked() and true or false
    end)
    return cb
  end

  f.cbAll = mkCheck("Include translated (all)", 20, -90, "includeAll")
  f.cbNoise = mkCheck("Include noise (numbers)", 20, -115, "includeNoise")
  f.cbHidden = mkCheck("Include hidden", 20, -140, "includeHidden")

  -- Buttons row
  local function mkBtn(label, x, y, w, onClick)
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(w or 120, 22)
    b:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
    b:SetText(label)
    b:SetScript("OnClick", onClick)
    return b
  end

  -- Dump action
  mkBtn("Dump", 260, -90, 130, function()
    if not (WOWTR and WOWTR.Debug and WOWTR.Debug.HandleDumpCommand) then
      _msg("|cFFFF0000[WoWAR]|r Dump system not available")
      return
    end
    local target = (f.edit and f.edit.GetText and f.edit:GetText()) or ""
    local cmd = _getDumpCommand(target, f.opts)
    WOWTR.Debug.HandleDumpCommand(cmd)
  end)

  mkBtn("Dump Professions", 260, -115, 130, function()
    if not (WOWTR and WOWTR.Debug and WOWTR.Debug.HandleDumpCommand) then
      _msg("|cFFFF0000[WoWAR]|r Dump system not available")
      return
    end
    local cmd = _getDumpCommand("prof", f.opts)
    WOWTR.Debug.HandleDumpCommand(cmd)
  end)

  mkBtn("Reset dedupe", 260, -140, 130, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ResetDumpCache then
      WOWTR.Debug.ResetDumpCache()
    end
  end)

  -- Clear logs section
  local clearLabel = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  clearLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -175)
  clearLabel:SetText("Clear agent logs:")

  mkBtn("Clear ALL", 20, -200, 120, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
      WOWTR.Debug.ClearAgentLogs("all")
    end
  end)
  mkBtn("Clear dump", 150, -200, 120, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
      WOWTR.Debug.ClearAgentLogs("dump")
    end
  end)
  mkBtn("Clear debug", 280, -200, 120, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
      WOWTR.Debug.ClearAgentLogs("debug")
    end
  end)

  mkBtn("Clear cache", 20, -228, 120, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
      WOWTR.Debug.ClearAgentLogs("cache")
    end
  end)
  mkBtn("/reload", 150, -228, 120, function()
    if ReloadUI then ReloadUI() end
  end)

  UI.frame = f
  return f
end

function UI.Show()
  local f = UI.CreateFrame()
  f:Show()
end

function UI.Hide()
  if UI.frame then UI.frame:Hide() end
end

function UI.Toggle()
  if UI.frame and UI.frame:IsVisible() then
    UI.Hide()
  else
    UI.Show()
  end
end

