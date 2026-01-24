-- Debug Tools UI (floating helper panel with tabs)
-- Provides debug toggles and dump/clear commands
-- Open with /wowardebug

WOWTR = WOWTR or {}
WOWTR.DebugToolsUI = WOWTR.DebugToolsUI or {}

local UI = WOWTR.DebugToolsUI

-- Debug categories definition
local categories = {
  { key = "quests", label = "Quests" },
  { key = "gossip", label = "Gossip" },
  { key = "tooltips", label = "Tooltips" },
  { key = "books", label = "Books" },
  { key = "movies", label = "Movies" },
  { key = "bubbles", label = "Bubbles" },
  { key = "chat", label = "Chat" },
  { key = "config", label = "Config" },
  { key = "general", label = "General" },
}

local function _msg(text)
  if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
end

-- Tab button creation helper
local function CreateTabButton(parent, tabIndex, text, onClick)
  local tab = CreateFrame("Button", nil, parent)
  tab:SetSize(90, 28)
  tab:SetNormalFontObject("GameFontNormalSmall")
  tab:SetHighlightFontObject("GameFontHighlightSmall")
  tab:SetDisabledFontObject("GameFontDisableSmall")
  tab:SetText(text)
  
  -- Tab background
  local bg = tab:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  bg:SetColorTexture(0.2, 0.2, 0.3, 0.8)
  tab.bg = bg
  
  -- Tab highlight
  local highlight = tab:CreateTexture(nil, "HIGHLIGHT")
  highlight:SetAllPoints()
  highlight:SetColorTexture(0.3, 0.3, 0.5, 0.5)
  
  -- Tab selected indicator
  local selected = tab:CreateTexture(nil, "OVERLAY")
  selected:SetPoint("BOTTOM", tab, "BOTTOM", 0, 0)
  selected:SetSize(90, 3)
  selected:SetColorTexture(0.4, 0.8, 0.4, 1)
  selected:Hide()
  tab.selected = selected
  
  tab:SetScript("OnClick", function()
    onClick(tabIndex)
  end)
  
  return tab
end

function UI.CreateFrame()
  if UI.frame then return UI.frame end

  local f = CreateFrame("Frame", "WOWTR_DebugToolsUIFrame", UIParent, "BackdropTemplate")
  f:SetSize(400, 420)
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

  -- Tab container
  local tabContainer = CreateFrame("Frame", nil, f)
  tabContainer:SetPoint("TOPLEFT", f, "TOPLEFT", 15, -45)
  tabContainer:SetPoint("TOPRIGHT", f, "TOPRIGHT", -15, -45)
  tabContainer:SetHeight(28)

  -- Content panels
  local settingsPanel = CreateFrame("Frame", nil, f)
  settingsPanel:SetPoint("TOPLEFT", tabContainer, "BOTTOMLEFT", 0, -5)
  settingsPanel:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -15, 15)
  f.settingsPanel = settingsPanel

  local toolsPanel = CreateFrame("Frame", nil, f)
  toolsPanel:SetPoint("TOPLEFT", tabContainer, "BOTTOMLEFT", 0, -5)
  toolsPanel:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -15, 15)
  toolsPanel:Hide()
  f.toolsPanel = toolsPanel

  -- Tab switching function
  local function SelectTab(tabIndex)
    f.currentTab = tabIndex
    for i, tab in ipairs(f.tabs) do
      if i == tabIndex then
        tab.selected:Show()
        tab.bg:SetColorTexture(0.3, 0.3, 0.4, 1)
      else
        tab.selected:Hide()
        tab.bg:SetColorTexture(0.2, 0.2, 0.3, 0.8)
      end
    end
    
    if tabIndex == 1 then
      settingsPanel:Show()
      toolsPanel:Hide()
    else
      settingsPanel:Hide()
      toolsPanel:Show()
    end
  end

  -- Create tabs
  f.tabs = {}
  local tab1 = CreateTabButton(tabContainer, 1, "Debug Settings", SelectTab)
  tab1:SetPoint("LEFT", tabContainer, "LEFT", 0, 0)
  f.tabs[1] = tab1

  local tab2 = CreateTabButton(tabContainer, 2, "Dump Tools", SelectTab)
  tab2:SetPoint("LEFT", tab1, "RIGHT", 5, 0)
  f.tabs[2] = tab2

  -- ============================================
  -- TAB 1: Debug Settings
  -- ============================================
  
  -- Debug Mode Toggle (Master Switch)
  local debugToggleLabel = settingsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  debugToggleLabel:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 10, -10)
  debugToggleLabel:SetText("Debug Mode (Master):")

  local debugToggle = CreateFrame("CheckButton", nil, settingsPanel, "UICheckButtonTemplate")
  debugToggle:SetPoint("LEFT", debugToggleLabel, "RIGHT", 10, 0)
  debugToggle:SetScript("OnClick", function(self)
    local checked = self:GetChecked()
    if WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core then
      WOWTR.db.profile.core.debug = checked
    end
    if WOWTR and WOWTR.Debug and WOWTR.Debug.Initialize then
      WOWTR.Debug.Initialize()
    end
    if checked then
      _msg("|cFF00FF00WoWAR Debug Mode:|r Enabled")
    else
      _msg("|cFF00FF00WoWAR Debug Mode:|r Disabled")
    end
    UI.UpdateSettings()
  end)
  f.debugToggle = debugToggle

  -- Category label
  local catLabel = settingsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  catLabel:SetPoint("TOPLEFT", debugToggleLabel, "BOTTOMLEFT", 0, -20)
  catLabel:SetText("Category Verbosity (requires Debug Mode ON):")
  catLabel:SetTextColor(0.8, 0.8, 0.8)

  -- Scroll frame for categories
  local scrollFrame = CreateFrame("ScrollFrame", nil, settingsPanel, "UIPanelScrollFrameTemplate")
  scrollFrame:SetPoint("TOPLEFT", catLabel, "BOTTOMLEFT", 0, -10)
  scrollFrame:SetPoint("BOTTOMRIGHT", settingsPanel, "BOTTOMRIGHT", -25, 5)

  local scrollBar = scrollFrame.ScrollBar or _G[scrollFrame:GetName().."ScrollBar"]
  if scrollBar then
    scrollBar:ClearAllPoints()
    scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 2, -16)
    scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 2, 16)
  end

  local scrollContent = CreateFrame("Frame", nil, scrollFrame)
  scrollContent:SetWidth(scrollFrame:GetWidth() - 30)
  scrollContent:SetHeight(1)
  scrollFrame:SetScrollChild(scrollContent)

  -- Create category toggles
  f.categoryToggles = {}
  local yOffset = 0
  for i, cat in ipairs(categories) do
    local checkbox = CreateFrame("CheckButton", "WOWTR_DebugUI_Cat_"..cat.key, scrollContent, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", scrollContent, "TOPLEFT", 5, -yOffset)
    checkbox.category = cat.key

    local label = scrollContent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    label:SetText(cat.label)
    checkbox.label = label

    checkbox:SetScript("OnClick", function(self)
      local checked = self:GetChecked()
      if WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core and WOWTR.db.profile.core.debugConfig then
        -- Toggle between None (0) and Verbose (4)
        WOWTR.db.profile.core.debugConfig[cat.key] = checked and 4 or 0
      end
      if WOWTR and WOWTR.Debug and WOWTR.Debug.Initialize then
        WOWTR.Debug.Initialize()
      end
      if checked then
        _msg("|cFF00FF00WOWTR Debug:|r [" .. cat.label .. "] Enabled")
      else
        _msg("|cFF00FF00WOWTR Debug:|r [" .. cat.label .. "] Disabled")
      end
    end)

    f.categoryToggles[cat.key] = checkbox
    yOffset = yOffset + 28
  end
  scrollContent:SetHeight(yOffset + 10)

  -- ============================================
  -- TAB 2: Dump Tools
  -- ============================================

  local hint = toolsPanel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  hint:SetPoint("TOPLEFT", toolsPanel, "TOPLEFT", 10, -10)
  hint:SetText("Dump visible UI strings + (optional) art/layout. Export after /reload.")

  -- Options checkboxes
  local opts = { includeAll = false, includeNoise = false, includeHidden = false, includeArt = false }
  f.opts = opts

  local function mkCheck(text, x, y, field)
    local cb = CreateFrame("CheckButton", nil, toolsPanel, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", toolsPanel, "TOPLEFT", x, y)
    cb.text:SetText(text)
    cb:SetChecked(false)
    cb:SetScript("OnClick", function(self)
      opts[field] = self:GetChecked() and true or false
    end)
    return cb
  end

  f.cbAll = mkCheck("Include translated (all)", 10, -35, "includeAll")
  f.cbNoise = mkCheck("Include noise (numbers)", 10, -60, "includeNoise")
  f.cbHidden = mkCheck("Include hidden", 10, -85, "includeHidden")
  f.cbArt = mkCheck("Include art (textures/layout)", 10, -110, "includeArt")

  -- Button helper
  local function mkBtn(label, x, y, w, onClick)
    local b = CreateFrame("Button", nil, toolsPanel, "UIPanelButtonTemplate")
    b:SetSize(w or 120, 22)
    b:SetPoint("TOPLEFT", toolsPanel, "TOPLEFT", x, y)
    b:SetText(label)
    b:SetScript("OnClick", onClick)
    return b
  end

  -- Dump button
  mkBtn("Dump Visible UI", 200, -50, 140, function()
    if not (WOWTR and WOWTR.Debug and WOWTR.Debug.DumpVisibleUI) then
      _msg("|cFFFF0000[WoWAR]|r DumpVisibleUI not available")
      return
    end
    WOWTR.Debug.DumpVisibleUI({
      includeAll = f.opts.includeAll,
      skipNoise = not f.opts.includeNoise,
      includeHidden = f.opts.includeHidden,
      includeArt = f.opts.includeArt,
      dedupe = true,
      maxRoots = 30,
      maxNodes = 2000,
      maxDepth = 12,
      maxArtEntries = 6000,
    })
  end)

  mkBtn("Reset dedupe", 200, -80, 140, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ResetDumpCache then
      WOWTR.Debug.ResetDumpCache()
    end
  end)

  -- Clear logs section
  local clearLabel = toolsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  clearLabel:SetPoint("TOPLEFT", toolsPanel, "TOPLEFT", 10, -145)
  clearLabel:SetText("Clear agent logs:")

  mkBtn("Clear ALL", 10, -165, 100, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
      WOWTR.Debug.ClearAgentLogs("all")
    end
  end)
  mkBtn("Clear dump", 120, -165, 100, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
      WOWTR.Debug.ClearAgentLogs("dump")
    end
  end)
  mkBtn("Clear debug", 230, -165, 100, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
      WOWTR.Debug.ClearAgentLogs("debug")
    end
  end)

  mkBtn("Clear cache", 10, -195, 100, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
      WOWTR.Debug.ClearAgentLogs("cache")
    end
  end)
  mkBtn("/reload", 120, -195, 100, function()
    if ReloadUI then ReloadUI() end
  end)

  -- Select first tab by default
  f.currentTab = 1
  SelectTab(1)

  UI.frame = f
  return f
end

-- Update settings panel with current values
function UI.UpdateSettings()
  if not UI.frame then return end

  local f = UI.frame
  local debugEnabled = false
  if WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core then
    debugEnabled = WOWTR.db.profile.core.debug or false
  end

  -- Update main toggle
  if f.debugToggle then
    f.debugToggle:SetChecked(debugEnabled)
  end

  -- Update category checkboxes
  if f.categoryToggles then
    for key, checkbox in pairs(f.categoryToggles) do
      local value = 0
      if WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core and WOWTR.db.profile.core.debugConfig then
        value = WOWTR.db.profile.core.debugConfig[key] or 0
      end
      -- Checkbox is checked if verbosity is > 0
      checkbox:SetChecked(value > 0)

      -- Disable checkboxes if debug mode is off
      if debugEnabled then
        checkbox:Enable()
        if checkbox.label then checkbox.label:SetTextColor(1, 1, 1) end
      else
        checkbox:Disable()
        if checkbox.label then checkbox.label:SetTextColor(0.5, 0.5, 0.5) end
      end
    end
  end
end

function UI.Show()
  local f = UI.CreateFrame()
  UI.UpdateSettings()
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
