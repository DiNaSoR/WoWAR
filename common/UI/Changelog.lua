local addonName, ns = ...

WOWTR = WOWTR or {}
WOWTR.Changelog = WOWTR.Changelog or {}

local Changelog = WOWTR.Changelog

-- Entries should be provided by locale packs (e.g., WoWAR/Changelog_AR.lua)
Changelog.entries = Changelog.entries or {}

local function colorRGBA(name)
  if name == "red" then return 0.902, 0.035, 0.369, 1.0 end
  if name == "green" then return 0.271, 0.561, 0.094, 1.0 end
  if name == "blue" then return 0.188, 0.412, 0.996, 1.0 end
  if name == "purple" then return 0.541, 0.212, 0.706, 1.0 end
  if name == "legendary" then return 0.922, 0.502, 0, 1.0 end
  return 0.216, 0.208, 0.31, 1.0
end

-- Internal: ensure frame exists
local function EnsureFrame()
  if Changelog.frame then return Changelog.frame end

  local f = CreateFrame("Frame", "WOWTR_ChangelogFrame", UIParent, "BackdropTemplate")
  f:SetSize(800, 600)
  f:SetPoint("CENTER")
  f:Hide()
  f:SetFrameStrata("DIALOG")

  -- background
  local bg = f:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  bg:SetColorTexture(0.118, 0.114, 0.169, 1)

  -- title
  local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
  local isRTL = (ns and ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) and true or false
  title:SetPoint("TOP", f, "TOP", 0, -8)
  if isRTL then
    title:SetText(QTR_ReverseIfAR("ﻣﺎﻫﻮ اﻟﺠﺪﻳﺪ"))
  else
    title:SetText("What's New?")
  end
  title:SetJustifyH("CENTER")
  -- Apply custom font for AR title
  if isRTL and WOWTR_Font2 then
    pcall(title.SetFont, title, WOWTR_Font2, 22, "")
  end

  -- close button (top-right)
  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -6)
  close:SetScript("OnClick", function() f:Hide() end)

  -- divider
  local line = f:CreateTexture(nil, "ARTWORK")
  line:SetColorTexture(0.216, 0.208, 0.31, 1)
  line:SetHeight(2)
  line:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -32)
  line:SetPoint("TOPRIGHT", f, "TOPRIGHT", -20, -32)

  -- scroll frame
  local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -40)
  scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 20)

  local content = CreateFrame("Frame", nil, scroll)
  content:SetSize(scroll:GetWidth(), 1)
  scroll:SetScrollChild(content)

  f.Title = title
  f.Scroll = scroll
  f.ScrollChild = content
  scroll:SetScript("OnSizeChanged", function(self)
    if f and f.ScrollChild and self and self.GetWidth then
      f.ScrollChild:SetWidth(self:GetWidth())
    end
  end)
  Changelog.frame = f
  return f
end

local function SetTextFS(fs, text, size)
  if not fs then return end
  local ok, font, currentSize, flags = pcall(fs.GetFont, fs)
  local useSize = size or currentSize or 13
  if WOWTR_Font2 and WoWTR_Localization and WoWTR_Localization.lang == 'AR' then
    pcall(fs.SetFont, fs, WOWTR_Font2, useSize, flags)
  end
  fs:SetText(text)
end

local function CreateEntry(parent, data, prev)
  local frame = CreateFrame("Frame", nil, parent)
  if prev then
    frame:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -8)
    frame:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT", 0, -8)
  else
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -4)
    frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -4)
  end

  local check = frame:CreateTexture(nil, "OVERLAY")
  check:SetSize(16, 16)
  local isRTL = (ns and ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) and true or false
  if isRTL then
    check:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
  else
    check:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
  end
  check:SetTexture([[Interface\COMMON\Indicator-Blue]])
  check:SetVertexColor(colorRGBA(data.color))

  -- Version line
  local versionFS = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  versionFS:ClearAllPoints()
  if isRTL then
    versionFS:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -32, -6)
  else
    versionFS:SetPoint("TOPLEFT", frame, "TOPLEFT", 32, -6)
  end
  local versionText = "v" .. tostring(data.version or "")
  SetTextFS(versionFS, versionText, 16)
  if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(versionFS, "LEFT") end

  -- Title line (reversed for AR only)
  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  title:ClearAllPoints()
  if isRTL then
    title:SetPoint("TOPRIGHT", versionFS, "BOTTOMRIGHT", 0, -4)
  else
    title:SetPoint("TOPLEFT", versionFS, "BOTTOMLEFT", 0, -4)
  end
  local titleText = tostring(data.title or "")
  if WoWTR_Localization and WoWTR_Localization.lang == 'AR' then
    titleText = QTR_ReverseIfAR(titleText)
  end
  SetTextFS(title, titleText, 16)
  if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(title, "LEFT") end

  local dateFS = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  dateFS:ClearAllPoints()
  if isRTL then
    dateFS:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -2)
  else
    dateFS:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
  end
  SetTextFS(dateFS, tostring(data.date or ""), 13)
  if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(dateFS, "LEFT") end

  local typeFS = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  if isRTL then
    typeFS:SetPoint("TOPRIGHT", dateFS, "BOTTOMRIGHT", -4, -12)
  else
    typeFS:SetPoint("TOPLEFT", dateFS, "BOTTOMLEFT", 4, -12)
  end
  local r,g,b,a = colorRGBA(data.color)
  local typeText = tostring(data.type or "")
  -- colorize and underline type text
  typeText = string.format("|c%02X%02X%02X%02X%s|r", math.floor(a*255), math.floor(r*255), math.floor(g*255), math.floor(b*255), typeText)
  SetTextFS(typeFS, typeText, 13)
  if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(typeFS, "LEFT") end
  -- underline
  local underline = frame:CreateTexture(nil, "ARTWORK")
  underline:SetColorTexture(r,g,b,1)
  underline:SetHeight(1)
  underline:SetPoint("TOPLEFT", typeFS, "BOTTOMLEFT", 0, -1)
  underline:SetPoint("TOPRIGHT", typeFS, "BOTTOMRIGHT", 0, -1)

  local authorFS = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  if isRTL then
    authorFS:SetPoint("TOPRIGHT", typeFS, "BOTTOMRIGHT", 0, -6)
  else
    authorFS:SetPoint("TOPLEFT", typeFS, "BOTTOMLEFT", 0, -6)
  end
  SetTextFS(authorFS, "Author: " .. tostring(data.author or ""), 13)
  if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(authorFS, "LEFT") end

  local body = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  body:ClearAllPoints()
  -- Anchor top to author line, and stretch horizontally across the entry
  body:SetPoint("TOP", authorFS, "BOTTOM", 0, -8)
  body:SetPoint("LEFT", frame, "LEFT", 12, 0)
  body:SetPoint("RIGHT", frame, "RIGHT", -12, 0)
  if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(body, "LEFT") end
  body:SetWordWrap(true)
  local desc = tostring(data.description or "")
  if WoWTR_Localization and WoWTR_Localization.lang == 'AR' then
    if ns and ns.Quests and ns.Quests.Utils and ns.Quests.Utils.ApplyRTLText then
      local shaped = ns.Quests.Utils.ApplyRTLText(desc)
      if shaped and shaped ~= "" then
        desc = shaped
      else
        desc = QTR_ReverseIfAR(desc)
      end
    else
      desc = QTR_ReverseIfAR(desc)
    end
  end
  SetTextFS(body, desc, 14)
  body:SetHeight(1)
  local textH = body:GetStringHeight() or 0
  if textH < 1 then textH = 14 end
  body:SetHeight(textH)

  local vH = versionFS:GetStringHeight() or 16
  local tH = title:GetStringHeight() or 16
  local tyH = typeFS:GetStringHeight() or 14
  local aH = authorFS:GetStringHeight() or 14
  local bH = body:GetHeight() or 16
  local totalH = math.floor(vH + tH + tyH + aH + bH + 48)
  frame:SetHeight(totalH)
  return frame
end

function Changelog.Build()
  local f = EnsureFrame()
  local parent = f.ScrollChild
  if f.Scroll and f.Scroll.GetWidth then
    parent:SetWidth(f.Scroll:GetWidth())
  end

  -- clear
  local kids = { parent:GetChildren() }
  for _, k in ipairs(kids) do k:Hide(); k:SetParent(nil) end

  local total = 8
  local prev
  local entries = Changelog.entries or {}
  for idx = 1, #entries do
    local data = entries[idx]
    local entry = CreateEntry(parent, data, prev)
    total = total + (entry:GetHeight() or 0) + 8
    prev = entry
  end

  parent:SetHeight(total)
  if f.Scroll and f.Scroll.UpdateScrollChildRect then
    f.Scroll:UpdateScrollChildRect()
  end
end

function Changelog.ToggleUI()
  local f = EnsureFrame()
  if not f:IsShown() then
    f:Show()
    C_Timer.After(0, function()
      Changelog.Build()
    end)
  else
    f:Hide()
  end
end

function WOWTR_ShowChangelog()
  Changelog.ToggleUI()
end

function Changelog.ShouldShow()
  if not WOWTR or not WOWTR.db or not WOWTR.db.profile then return false end
  local latest = (Changelog.entries and Changelog.entries[1] and Changelog.entries[1].version) or ""
  local shown = WOWTR.db.profile.core and WOWTR.db.profile.core.lastShownChangelogVersion or ""
  return latest ~= "" and latest ~= shown
end

function Changelog.MarkShown()
  if not WOWTR or not WOWTR.db or not WOWTR.db.profile then return end
  local latest = (Changelog.entries and Changelog.entries[1] and Changelog.entries[1].version) or ""
  WOWTR.db.profile.core = WOWTR.db.profile.core or {}
  WOWTR.db.profile.core.lastShownChangelogVersion = latest
end


