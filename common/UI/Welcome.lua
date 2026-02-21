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

local function LabelRaw(key, fallback)
  if WOWTR and WOWTR.Config and WOWTR.Config.LabelRaw then
    return WOWTR.Config.LabelRaw(key, fallback)
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

-- QTR_ExpandUnitInfo line-wrapping depends on the target object's width.
-- On first show that width can still be 0, so compute a safe fallback width.
local function ComputeWelcomeWrapWidth(frame, isRTL)
  local width = 0

  if frame and frame.ScrollView and frame.ScrollView.GetWidth then
    width = frame.ScrollView:GetWidth() or 0
    if width > 0 then
      local padX = 4
      width = width - (2 * padX) - (isRTL and 5 or 0)
    end
  end

  if width <= 0 and frame and frame.ScrollFrame and frame.ScrollFrame.GetWidth then
    width = frame.ScrollFrame:GetWidth() or 0
    if width > 0 then
      width = width + (isRTL and -5 or 0)
    end
  end

  if width <= 0 and frame and frame.GetWidth then
    -- Frame(720) - side margins(80) - scrollbar reserve(24) - inner padding(8)
    width = (frame:GetWidth() or 720) - 112 - (isRTL and 5 or 0)
  end

  return math.max(1, math.floor(width))
end

local function ConfigureWrappedFontString(obj)
  if not obj then return end
  if obj.SetWordWrap then obj:SetWordWrap(true) end
  if obj.SetNonSpaceWrap then obj:SetNonSpaceWrap(false) end
end

local function ApplyFonts(obj)
  if WOWTR and WOWTR.Fonts and WOWTR.Fonts.Apply then
    WOWTR.Fonts.Apply(obj)
  end
end

local function EnsureFrame()
  if Welcome.frame then return Welcome.frame end

  local f = CreateFrame("Frame", "WOWTR_WelcomeFrame", UIParent, "BackdropTemplate")
  f:SetSize(720, 480)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
  f:Hide()
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

  ---------------------------------------------------------------------------
  -- Background: Use ControlCenter art if available, else a nice gradient
  ---------------------------------------------------------------------------
  local CC = WOWTR and WOWTR.Config and WOWTR.Config.ControlCenter
  local backgroundFile = CC and CC.Assets and CC.Assets.ControlCenterBackground

  -- Base solid color (dark blue-purple tone matching ControlCenter)
  local baseBg = f:CreateTexture(nil, "BACKGROUND", nil, -8)
  baseBg:SetAllPoints()
  baseBg:SetColorTexture(0.08, 0.075, 0.12, 1.0)

  -- Main art background (ControlCenter style)
  if type(backgroundFile) == "string" and backgroundFile ~= "" then
    local art = f:CreateTexture(nil, "BACKGROUND", nil, -7)
    art:SetAllPoints()
    art:SetTexture(backgroundFile)
    art:SetAlpha(0.92)
    f.BackgroundArt = art
  end

  -- Top gradient overlay (subtle darkening at top for title contrast)
  local topGrad = f:CreateTexture(nil, "BACKGROUND", nil, -6)
  topGrad:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
  topGrad:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
  topGrad:SetHeight(100)
  topGrad:SetColorTexture(0, 0, 0, 1)
  topGrad:SetGradient("VERTICAL", CreateColor(0, 0, 0, 0), CreateColor(0, 0, 0, 0.7))

  -- Bottom gradient overlay (for button area contrast)
  local botGrad = f:CreateTexture(nil, "BACKGROUND", nil, -6)
  botGrad:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
  botGrad:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
  botGrad:SetHeight(80)
  botGrad:SetColorTexture(0, 0, 0, 1)
  botGrad:SetGradient("VERTICAL", CreateColor(0, 0, 0, 0.8), CreateColor(0, 0, 0, 0))

  ---------------------------------------------------------------------------
  -- Border: Use the same ControlCenter NineSlice border
  ---------------------------------------------------------------------------
  do
    local LandingPageUtil = CC and CC.LandingPageUtil
    if LandingPageUtil and type(LandingPageUtil.CreateExpansionThemeFrame) == "function" then
      local nine = LandingPageUtil.CreateExpansionThemeFrame(f, 10)
      nine:CoverParent(0)
      if nine.Background then
        nine.Background:Hide()
      end
      nine:SetUsingParentLevel(false)
      nine:SetFrameLevel((f.GetFrameLevel and f:GetFrameLevel() or 0) + 20)
      nine:ShowCloseButton(true)
      nine:SetCloseButtonOwner(f)
      f.NineSlice = nine
    else
      -- Fallback: simple dark border
      f:SetBackdrop({
        bgFile = nil,
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
      })
    end
  end

  ---------------------------------------------------------------------------
  -- Title area
  ---------------------------------------------------------------------------
  local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
  title:SetPoint("TOP", f, "TOP", 0, -24)
  title:SetJustifyH("CENTER")
  title:SetText("Welcome to WoWAR") -- overwritten in Welcome.Show() for Arabic
  ApplyFonts(title)
  local titleFont = WOWTR_Font1 or WOWTR_Font2
  if titleFont then
    pcall(title.SetFont, title, titleFont, 26, "")
  end
  if title.SetTextColor then
    pcall(title.SetTextColor, title, 1, 0.82, 0, 1) -- Gold
  end

  local sub = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  sub:SetPoint("TOP", title, "BOTTOM", 0, -6)
  sub:SetJustifyH("CENTER")
  sub:SetText("Quick start + settings") -- overwritten in Welcome.Show() for Arabic
  ApplyFonts(sub)
  if sub.SetTextColor then
    pcall(sub.SetTextColor, sub, 0.7, 0.7, 0.7, 1)
  end

  -- Decorative line under title
  local line = f:CreateTexture(nil, "ARTWORK")
  line:SetColorTexture(0.9, 0.75, 0.2, 0.6)
  line:SetHeight(2)
  line:SetPoint("LEFT", f, "LEFT", 60, 0)
  line:SetPoint("RIGHT", f, "RIGHT", -60, 0)
  line:SetPoint("TOP", sub, "BOTTOM", 0, -10)

  ---------------------------------------------------------------------------
  -- Scrollable welcome text
  ---------------------------------------------------------------------------
  local scrollArea = CreateFrame("Frame", nil, f)
  scrollArea:SetPoint("TOPLEFT", f, "TOPLEFT", 40, -100)
  scrollArea:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 90)

  -- We'll store raw (already expanded) texts here; Reflow() builds the scroll content.
  f._welcomeBodyText = ""
  f._welcomeTipsText = ""

  local body, tips

  -- Prefer ControlCenter's ScrollView + ScrollBar so scrolling looks/feels identical.
  local function TryCreateControlCenterScroll()
    local CC2 = WOWTR and WOWTR.Config and WOWTR.Config.ControlCenter
    local API = CC2 and CC2.API
    if not (CC2 and API and CC2.CreateScrollBarWithDynamicSize and API.CreateScrollView) then
      return false
    end

    local ScrollBar = CC2.CreateScrollBarWithDynamicSize(f)
    ScrollBar:SetPoint("TOPRIGHT", scrollArea, "TOPRIGHT", 10, 0)
    ScrollBar:SetPoint("BOTTOMRIGHT", scrollArea, "BOTTOMRIGHT", 10, 0)
    ScrollBar:SetFrameLevel((f.GetFrameLevel and f:GetFrameLevel() or 0) + 30)
    ScrollBar:UpdateThumbRange()

    local ScrollView = API.CreateScrollView(f, ScrollBar)
    ScrollBar.ScrollView = ScrollView
    ScrollView:SetPoint("TOPLEFT", scrollArea, "TOPLEFT", 0, 0)
    -- Leave room for the scrollbar.
    ScrollView:SetPoint("BOTTOMRIGHT", scrollArea, "BOTTOMRIGHT", -24, 0)
    ScrollView:SetStepSize(64)
    ScrollView:OnSizeChanged()
    if ScrollView.EnableMouseBlocker then
      ScrollView:EnableMouseBlocker(true)
    end
    if ScrollView.SetAlwaysShowScrollBar then
      ScrollView:SetAlwaysShowScrollBar(false)
    end
    ScrollView.renderAllObjects = true

    local function CreateFontString()
      local obj = ScrollView:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      obj:SetJustifyV("TOP")
      obj:SetSpacing(5)
      ConfigureWrappedFontString(obj)
      if ns and ns.RTL and ns.RTL.JustifyFontString then
        ns.RTL.JustifyFontString(obj, IsRTL() and "RIGHT" or "LEFT")
      end
      ApplyFonts(obj)
      return obj
    end

    local function RemoveFontString(obj)
      obj:SetText(nil)
      obj:Hide()
      obj:ClearAllPoints()
    end

    ScrollView:AddTemplate("FontString", CreateFontString, RemoveFontString, function(obj)
      obj:SetSpacing(5)
    end)

    -- Measurement FontStrings (not in the ScrollView pool) to compute heights for content layout.
    local measureBody = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    measureBody:Hide()
    measureBody:SetJustifyV("TOP")
    measureBody:SetSpacing(5)
    ConfigureWrappedFontString(measureBody)
    if ns and ns.RTL and ns.RTL.JustifyFontString then
      ns.RTL.JustifyFontString(measureBody, IsRTL() and "RIGHT" or "LEFT")
    end
    ApplyFonts(measureBody)

    local measureTips = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    measureTips:Hide()
    measureTips:SetJustifyV("TOP")
    measureTips:SetSpacing(5)
    ConfigureWrappedFontString(measureTips)
    if ns and ns.RTL and ns.RTL.JustifyFontString then
      ns.RTL.JustifyFontString(measureTips, IsRTL() and "RIGHT" or "LEFT")
    end
    ApplyFonts(measureTips)

    body = measureBody
    tips = measureTips

    local function Reflow()
      if not ScrollView then return end

      local isRTL = IsRTL()
      local edgePoint = isRTL and "TOPRIGHT" or "TOPLEFT"
      local padX = 4
      local width = (ScrollView.GetWidth and ScrollView:GetWidth()) or 0
      local textWidth = math.max(1, width - 2 * padX - (isRTL and 5 or 0))

      -- Measure heights using the same wrapping width.
      measureBody:SetWidth(textWidth)
      measureTips:SetWidth(textWidth)
      measureBody:SetText(f._welcomeBodyText or "")
      measureTips:SetText(f._welcomeTipsText or "")

      local bodyH = (measureBody.GetStringHeight and measureBody:GetStringHeight()) or 0
      local tipsH = (measureTips.GetStringHeight and measureTips:GetStringHeight()) or 0
      local gap = 18

      local content = {}
      local top = 0
      local bottom = top + bodyH
      content[1] = {
        dataIndex = 1,
        templateKey = "FontString",
        top = top,
        bottom = bottom,
        point = edgePoint,
        relativePoint = edgePoint,
        offsetX = isRTL and -padX or padX,
        setupFunc = function(obj)
          obj:SetWidth(textWidth)
          obj:SetFontObject("GameFontHighlight")
          obj:SetText(f._welcomeBodyText or "")
          ConfigureWrappedFontString(obj)
          obj:SetJustifyH(isRTL and "RIGHT" or "LEFT")
          ApplyFonts(obj)
          obj:Show()
        end,
      }

      top = bottom + gap
      bottom = top + tipsH + 6
      content[2] = {
        dataIndex = 2,
        templateKey = "FontString",
        top = top,
        bottom = bottom,
        point = edgePoint,
        relativePoint = edgePoint,
        offsetX = isRTL and -padX or padX,
        setupFunc = function(obj)
          obj:SetWidth(textWidth)
          obj:SetFontObject("GameFontNormal")
          obj:SetText(f._welcomeTipsText or "")
          ConfigureWrappedFontString(obj)
          obj:SetJustifyH(isRTL and "RIGHT" or "LEFT")
          ApplyFonts(obj)
          obj:Show()
        end,
      }

      ScrollView:SetContent(content)
      ScrollBar:UpdateThumbRange()
    end

    ScrollView:SetScript("OnSizeChanged", function()
      ScrollView:OnSizeChanged(true)
      ScrollBar:OnSizeChanged()
      Reflow()
    end)

    f.ScrollView = ScrollView
    f.ScrollBar = ScrollBar
    f.Reflow = Reflow
    return true
  end

  local function CreateFallbackScroll()
    -- Fallback to the default scroll frame if ControlCenter is not available.
    local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", scrollArea, "TOPLEFT", 0, 0)
    scroll:SetPoint("BOTTOMRIGHT", scrollArea, "BOTTOMRIGHT", 0, 0)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)

    local b = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    b:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
    b:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, 0)
    b:SetJustifyV("TOP")
    b:SetSpacing(5)
    ConfigureWrappedFontString(b)
    if ns and ns.RTL and ns.RTL.JustifyFontString then
      ns.RTL.JustifyFontString(b, IsRTL() and "RIGHT" or "LEFT")
    end
    ApplyFonts(b)

    local t = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    t:SetPoint("TOPLEFT", b, "BOTTOMLEFT", 0, -18)
    t:SetPoint("TOPRIGHT", b, "BOTTOMRIGHT", 0, -18)
    t:SetJustifyV("TOP")
    ConfigureWrappedFontString(t)
    if ns and ns.RTL and ns.RTL.JustifyFontString then
      ns.RTL.JustifyFontString(t, IsRTL() and "RIGHT" or "LEFT")
    end
    ApplyFonts(t)

    body = b
    tips = t

    local function Reflow()
      local w = scroll:GetWidth()
      if w and w > 0 then
        content:SetWidth(math.max(1, w + (IsRTL() and -5 or 0)))
      end
      b:SetWidth(content:GetWidth())
      t:SetWidth(content:GetWidth())

      local bodyH = (b.GetStringHeight and b:GetStringHeight()) or 0
      local tipsH = (t.GetStringHeight and t:GetStringHeight()) or 0
      content:SetHeight(math.max(1, bodyH + tipsH + 50))
    end

    scroll:SetScript("OnSizeChanged", function() Reflow() end)
    f.Reflow = Reflow
    f.ScrollFrame = scroll
  end

  if not TryCreateControlCenterScroll() then
    CreateFallbackScroll()
  end

  ---------------------------------------------------------------------------
  -- Bottom buttons
  ---------------------------------------------------------------------------
  local function mkBtn(label, anchor, relTo, relAnchor, x, y, w, onClick)
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(w or 160, 26)
    b:SetPoint(anchor, relTo, relAnchor, x, y)
    b:SetText(label)
    b:SetScript("OnClick", onClick)
    ApplyFonts(b)
    return b
  end

  local btnOpen = mkBtn("Open Settings", "BOTTOMLEFT", f, "BOTTOMLEFT", 40, 30, 160, function()
    if WOWTR and WOWTR.Config and WOWTR.Config.Open then
      WOWTR.Config.Open()
    end
  end)

  local btnOk = mkBtn("OK - I read", "BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 30, 180, function()
    f:Hide()
  end)

  local showAgain = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
  showAgain:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
  local showAgainLabel = showAgain.text or showAgain.Text
  if showAgainLabel and showAgainLabel.SetText then
    showAgainLabel:SetText("Show again next login")
  end
  showAgain:SetChecked(false)
  showAgain:SetScript("OnClick", function()
    -- Preference is persisted when user confirms with "OK - I read".
  end)

  local function PersistWelcomePreference()
    QTR_PS = QTR_PS or {}
    if showAgain:GetChecked() then
      QTR_PS["welcome"] = nil
    else
      QTR_PS["welcome"] = "1"
    end
  end

  btnOk:SetScript("OnClick", function()
    PersistWelcomePreference()
    f:Hide()
  end)
  ApplyFonts(showAgain)

  ---------------------------------------------------------------------------
  -- Store refs
  ---------------------------------------------------------------------------
  f.Title = title
  f.Subtitle = sub
  f.Body = body
  f.Tips = tips
  f.BtnOpenSettings = btnOpen
  f.BtnOk = btnOk
  f.CBShowAgain = showAgain

  Welcome.frame = f
  return f
end

function Welcome.Show()
  local f = EnsureFrame()

  local isRTL = IsRTL()

  local titleText = LabelRaw("welcomeTitle", "Welcome to WoWAR")
  local subText = LabelRaw("welcomeSubtitle", "Quick start + settings")
  local openText = LabelRaw("welcomeOpenSettings", "Open Settings")
  local okText = LabelRaw("welcomeButton", "OK - I read")
  local showAgainText = LabelRaw("welcomeShowAgain", "Show again next login")

  local text = LabelRaw("welcomeText", "Welcome!")
  local tipsText = LabelRaw("welcomeTipsText",
    "|cffffd200Tips:|r\n" ..
    "- Use the minimap icon to open settings anytime.\n" ..
    "- /wowardebug can dump visible UI strings for missing translations.\n" ..
    "- If something is untranslated, save/export and send it on Discord.")

  -- Title/subtitle/buttons: Arabic uses QTR_ExpandUnitInfo (keeps embedded English LTR).
  if f.Title then
    f.Title:SetText(ExpandIfArabic(titleText, f.Title, _G.WOWTR_Font1 or _G.WOWTR_Font2, -10, false))
  end
  if f.Subtitle then
    f.Subtitle:SetText(ExpandIfArabic(subText, f.Subtitle, _G.WOWTR_Font2, -5, false))
  end
  if f.BtnOpenSettings and f.BtnOpenSettings.SetText then
    -- Do NOT run QTR_ExpandUnitInfo on buttons (can cause odd wrapping/width issues).
    f.BtnOpenSettings:SetText(isRTL and Label("welcomeOpenSettings", openText) or openText)
  end
  if f.BtnOk and f.BtnOk.SetText then
    -- Do NOT run QTR_ExpandUnitInfo on buttons.
    f.BtnOk:SetText(isRTL and Label("welcomeButton", okText) or okText)
  end
  local cbLabel = f.CBShowAgain and (f.CBShowAgain.text or f.CBShowAgain.Text)
  if cbLabel and cbLabel.SetText then
    -- Do NOT run QTR_ExpandUnitInfo on checkbox labels.
    cbLabel:SetText(isRTL and Label("welcomeShowAgain", showAgainText) or showAgainText)
  end

  -- Arabic: use QTR_ExpandUnitInfo so embedded English stays LTR and bidi is stable.
  -- Ensure target width is valid before shaping, otherwise wrapping can be wrong.
  local wrapWidth = ComputeWelcomeWrapWidth(f, isRTL)
  if f.Body and f.Body.SetWidth then f.Body:SetWidth(wrapWidth) end
  if f.Tips and f.Tips.SetWidth then f.Tips:SetWidth(wrapWidth) end
  local bodyText = ExpandIfArabic(text, f.Body, _G.WOWTR_Font2, -10)
  local tipsOut = ExpandIfArabic(tipsText, f.Tips, _G.WOWTR_Font2, -5)

  -- Store for ControlCenter-style scroll content builder, and update fallback text if used.
  f._welcomeBodyText = bodyText
  f._welcomeTipsText = tipsOut
  if f.Body and f.Body.SetText then
    f.Body:SetText(bodyText)
  end
  if f.Tips and f.Tips.SetText then
    f.Tips:SetText(tipsOut)
  end

  QTR_PS = QTR_PS or {}
  if f.CBShowAgain and f.CBShowAgain.SetChecked then
    f.CBShowAgain:SetChecked(QTR_PS["welcome"] ~= "1")
  end

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
