-- Debug UI Popup Frame
-- Accessible via /wdebug command

WOWTR = WOWTR or {}
WOWTR.DebugUI = WOWTR.DebugUI or {}

local DebugUI = WOWTR.DebugUI

local categories = {
  { key = "quests", label = "Quests" },
  { key = "gossip", label = "Gossip" },
  { key = "tooltips", label = "Tooltips" },
  { key = "books", label = "Books" },
  { key = "movies", label = "Movies" },
  { key = "bubbles", label = "Bubbles" },
  { key = "chat", label = "Chat" },
  { key = "general", label = "General" },
}

-- Create the debug popup frame
function DebugUI.CreateFrame()
  if DebugUI.frame then
    return DebugUI.frame
  end

  local f = CreateFrame("Frame", "WOWTR_DebugUIFrame", UIParent, "BackdropTemplate")
  f:SetSize(400, 400)
  f:SetPoint("CENTER")
  f:Hide()
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

  -- Background
  local bg = f:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  bg:SetColorTexture(0.118, 0.114, 0.169, 0.95)

  -- Border
  f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
  })

  -- Title
  local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
  title:SetPoint("TOP", f, "TOP", 0, -20)
  title:SetText("Debug Settings")
  title:SetJustifyH("CENTER")

  -- Close button
  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -6)
  close:SetScript("OnClick", function() f:Hide() end)

  -- Debug Mode Toggle
  local debugToggleLabel = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  debugToggleLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -60)
  debugToggleLabel:SetText("Debug Mode:")

  local debugToggle = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
  debugToggle:SetPoint("LEFT", debugToggleLabel, "RIGHT", 10, 0)
  debugToggle:SetScript("OnClick", function(self)
    local checked = self:GetChecked()
    WOWTR.db.profile.core.debug = checked
    if WOWTR and WOWTR.Debug and WOWTR.Debug.Initialize then
      WOWTR.Debug.Initialize()
    end
    if checked then
      DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00WoWTR Debug Mode:|r Enabled")
    else
      DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00WoWTR Debug Mode:|r Disabled")
    end
    DebugUI.UpdateFrame()
  end)

  -- Category toggles container
  local scrollFrame = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
  scrollFrame:SetPoint("TOPLEFT", debugToggleLabel, "BOTTOMLEFT", 0, -30)
  scrollFrame:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -30, 50)

  local scrollBar = scrollFrame.ScrollBar or _G[scrollFrame:GetName().."ScrollBar"]
  if scrollBar then
    scrollBar:ClearAllPoints()
    scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 0, -16)
    scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 0, 16)
  end

  local content = CreateFrame("Frame", nil, scrollFrame)
  content:SetWidth(350)
  content:SetHeight(1)
  scrollFrame:SetScrollChild(content)

  -- Store toggles for updates
  f.toggles = {}
  f.debugToggle = debugToggle
  f.scrollContent = content

  -- Create checkboxes for each category
  local yOffset = 0
  for i, cat in ipairs(categories) do
    local checkbox = CreateFrame("CheckButton", "WOWTR_DebugUI_Checkbox_"..cat.key, content, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", content, "TOPLEFT", 20, -yOffset)
    checkbox.category = cat.key
    
    local label = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    label:SetText(cat.label)
    checkbox.label = label

    checkbox:SetScript("OnClick", function(self)
      local checked = self:GetChecked()
      -- Toggle between None (0) and Verbose (4)
      WOWTR.db.profile.core.debugConfig[cat.key] = checked and 4 or 0
      if WOWTR and WOWTR.Debug and WOWTR.Debug.Initialize then
        WOWTR.Debug.Initialize()
      end
      -- Show feedback message
      if checked then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00WOWTR Debug:|r [" .. cat.label .. "] Enabled")
      else
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00WOWTR Debug:|r [" .. cat.label .. "] Disabled")
      end
    end)

    f.toggles[cat.key] = checkbox
    yOffset = yOffset + 30
  end

  content:SetHeight(yOffset)

  DebugUI.frame = f
  DebugUI.UpdateFrame()
  return f
end

-- Update frame with current values
function DebugUI.UpdateFrame()
  if not DebugUI.frame then return end

  local f = DebugUI.frame
  local debugEnabled = WOWTR.db.profile.core.debug or false

  -- Update main toggle
  f.debugToggle:SetChecked(debugEnabled)

  -- Update category checkboxes
  for key, checkbox in pairs(f.toggles) do
    local value = WOWTR.db.profile.core.debugConfig[key] or 0
    -- Checkbox is checked if verbosity is Verbose (4)
    checkbox:SetChecked(value == 4)
    
    -- Disable checkboxes if debug is off
    if debugEnabled then
      checkbox:Enable()
      checkbox.label:SetTextColor(1, 1, 1)
    else
      checkbox:Disable()
      checkbox.label:SetTextColor(0.5, 0.5, 0.5)
    end
  end
end

-- Show the debug frame
function DebugUI.Show()
  local f = DebugUI.CreateFrame()
  DebugUI.UpdateFrame()
  f:Show()
end

-- Hide the debug frame
function DebugUI.Hide()
  if DebugUI.frame then
    DebugUI.frame:Hide()
  end
end

-- Toggle the debug frame
function DebugUI.Toggle()
  if DebugUI.frame and DebugUI.frame:IsVisible() then
    DebugUI.Hide()
  else
    DebugUI.Show()
  end
end

