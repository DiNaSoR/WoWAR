-- common/UI/Welcome.lua
-- Welcome modal shown on first run (style aligned with ControlCenter config UI)
-------------------------------------------------------------------------------------------------------

local addonName, ns = ...

WOWTR = WOWTR or {}
WOWTR.Welcome = WOWTR.Welcome or {}

local Welcome = WOWTR.Welcome

local function Label(key, fallback)
  if WOWTR and WOWTR.Config and WOWTR.Config.Label then
    return WOWTR.Config.Label(key, fallback)
  end
  return fallback
end

local function IsRTL()
  return (ns and ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) and true or false
end

local function ExpandIfArabic(text, obj, font, offset, noWrap)
  if IsRTL() and type(_G.QTR_ExpandUnitInfo) == "function" then
    return _G.QTR_ExpandUnitInfo(text, false, obj, font or _G.WOWTR_Font2, offset, noWrap)
  end
  return text
end

local function ApplyFonts(obj)
  if WOWTR and WOWTR.Fonts and WOWTR.Fonts.Apply then
    WOWTR.Fonts.Apply(obj)
  end
end

local function EnsureFrame()
  if Welcome.frame then return Welcome.frame end

  local f = CreateFrame("Frame", "WOWTR_WelcomeFrame", UIParent, "BackdropTemplate")
  f:SetSize(780, 520)
  f:SetPoint("CENTER")
  f:Hide()
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

  -- Base background (ControlCenter uses a themed image; fall back to solid)
  local bg = f:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  bg:SetColorTexture(0.118, 0.114, 0.169, 1.0)

  local CC = WOWTR and WOWTR.Config and WOWTR.Config.ControlCenter
  local backgroundFile = CC and CC.Assets and CC.Assets.ControlCenterBackground
  if type(backgroundFile) == "string" and backgroundFile ~= "" then
    local art = f:CreateTexture(nil, "BACKGROUND", nil, 1)
    art:SetAllPoints()
    art:SetTexture(backgroundFile)
    art:SetAlpha(0.85)
    f.BackgroundArt = art
  end

  -- Use the same ControlCenter border (ExpansionLandingPage theme) for consistency.
  do
    local LandingPageUtil = CC and CC.LandingPageUtil
    if LandingPageUtil and type(LandingPageUtil.CreateExpansionThemeFrame) == "function" then
      local nine = LandingPageUtil.CreateExpansionThemeFrame(f, 10)
      nine:CoverParent(0)
      if nine.Background then
        -- We provide our own background art + base color.
        nine.Background:Hide()
      end
      nine:SetUsingParentLevel(false)
      nine:SetFrameLevel((f.GetFrameLevel and f:GetFrameLevel() or 0) + 20)
      nine:ShowCloseButton(true)
      nine:SetCloseButtonOwner(f)
      f.NineSlice = nine
    end
  end

  -- Title
  local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
  title:SetPoint("TOP", f, "TOP", 0, -16)
  title:SetJustifyH("CENTER")
  title:SetText("Welcome to WoWAR")
  ApplyFonts(title)
  if IsRTL() and WOWTR_Font2 then
    pcall(title.SetFont, title, WOWTR_Font2, 22, "")
  end

  local sub = f:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  sub:SetPoint("TOP", title, "BOTTOM", 0, -4)
  sub:SetJustifyH("CENTER")
  sub:SetText("Quick start + settings")
  ApplyFonts(sub)

  local line = f:CreateTexture(nil, "ARTWORK")
  line:SetColorTexture(0.216, 0.208, 0.31, 1)
  line:SetHeight(2)
  line:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -56)
  line:SetPoint("TOPRIGHT", f, "TOPRIGHT", -20, -56)

  -- Scrollable welcome text
  local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 24, -70)
  scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -34, 86)

  local content = CreateFrame("Frame", nil, scroll)
  content:SetSize(1, 1)
  scroll:SetScrollChild(content)

  local body = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  body:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
  body:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, 0)
  body:SetJustifyV("TOP")
  body:SetSpacing(4)

  if ns and ns.RTL and ns.RTL.JustifyFontString then
    ns.RTL.JustifyFontString(body, "LEFT")
  end
  ApplyFonts(body)

  -- Creative polish: a small “tips” block at the bottom of the text
  local tips = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  tips:SetPoint("TOPLEFT", body, "BOTTOMLEFT", 0, -14)
  tips:SetPoint("TOPRIGHT", body, "BOTTOMRIGHT", 0, -14)
  tips:SetJustifyV("TOP")
  if ns and ns.RTL and ns.RTL.JustifyFontString then
    ns.RTL.JustifyFontString(tips, "LEFT")
  end
  ApplyFonts(tips)

  local function Reflow()
    -- Keep content width in sync with scroll width
    local w = scroll:GetWidth()
    if w and w > 0 then
      content:SetWidth(w)
    end

    body:SetWidth(content:GetWidth())
    tips:SetWidth(content:GetWidth())

    local bodyH = (body.GetStringHeight and body:GetStringHeight()) or 0
    local tipsH = (tips.GetStringHeight and tips:GetStringHeight()) or 0
    content:SetHeight(math.max(1, bodyH + tipsH + 40))
  end

  scroll:SetScript("OnSizeChanged", function() Reflow() end)

  -- Bottom buttons (match “settings/config” vibe)
  local function mkBtn(label, anchor, x, y, w, onClick)
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(w or 160, 24)
    b:SetPoint(anchor, f, anchor, x, y)
    b:SetText(label)
    b:SetScript("OnClick", onClick)
    ApplyFonts(b)
    return b
  end

  local btnOpen = mkBtn("Open Settings", "BOTTOMLEFT", 24, 24, 160, function()
    if WOWTR and WOWTR.Config and WOWTR.Config.Open then
      WOWTR.Config.Open()
    end
  end)

  local btnOk = mkBtn(Label("welcomeButton", "OK - I read"), "BOTTOMRIGHT", -24, 24, 190, function()
    QTR_PS = QTR_PS or {}
    QTR_PS["welcome"] = "1"
    f:Hide()
  end)

  local showAgain = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
  showAgain:SetPoint("BOTTOM", f, "BOTTOM", 0, 28)
  showAgain.text:SetText("Show again next login")
  showAgain:SetChecked(false)
  showAgain:SetScript("OnClick", function(self)
    QTR_PS = QTR_PS or {}
    if self:GetChecked() then
      QTR_PS["welcome"] = nil
    else
      -- Keep current value unchanged when unchecked (user controls it via OK button)
    end
  end)
  ApplyFonts(showAgain)

  -- Store refs
  f.Title = title
  f.Subtitle = sub
  f.Body = body
  f.Tips = tips
  f.Reflow = Reflow
  f.BtnOpenSettings = btnOpen
  f.BtnOk = btnOk
  f.CBShowAgain = showAgain

  Welcome.frame = f
  return f
end

function Welcome.Show()
  local f = EnsureFrame()

  local text = (WOWTR_Config_Interface and WOWTR_Config_Interface.welcomeText) or "Welcome!"
  local tipsText =
    "|cffffd200Tips:|r\n" ..
    "- Use the minimap icon to open settings anytime.\n" ..
    "- /wowardebug can dump visible UI strings for missing translations.\n" ..
    "- If something is untranslated, save/export and send it on Discord."

  -- Arabic: use QTR_ExpandUnitInfo so embedded English stays LTR and bidi is stable.
  -- English/other: keep raw text LTR.
  f.Body:SetText(ExpandIfArabic(text, f.Body, _G.WOWTR_Font2, -5))
  f.Tips:SetText(tipsText)

  -- Default: if already welcomed, don’t show; caller can override
  QTR_PS = QTR_PS or {}
  f.CBShowAgain:SetChecked(false)

  f:Show()
  if f.Reflow then f:Reflow() end
end

function Welcome.Toggle()
  local f = EnsureFrame()
  if f:IsShown() then
    f:Hide()
  else
    Welcome.Show()
  end
end

