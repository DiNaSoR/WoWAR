-- common/Config/ControlCenter/Util.lua
-- Minimal UI utility layer ported from Plumber (Docs/Plumber) for our ControlCenter settings panel.
-- NOTE: Intentionally namespaced under WOWTR.Config.ControlCenter to avoid collisions with the Plumber addon.

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.ControlCenter = WOWTR.Config.ControlCenter or {}

local CC = WOWTR.Config.ControlCenter

CC.API = CC.API or {}
local API = CC.API

CC.LandingPageUtil = CC.LandingPageUtil or {}
local LandingPageUtil = CC.LandingPageUtil

-- -----------------------------------------------------------------------------
-- Paths / Assets
-- -----------------------------------------------------------------------------

local function GetBaseFolder()
  return (WOWTR_Localization and WOWTR_Localization.mainFolder) or "Interface\\AddOns\\WoWAR"
end

local function PathJoin(base, rel)
  rel = tostring(rel or ""):gsub("/", "\\")
  if rel:sub(1, 1) ~= "\\" then rel = "\\" .. rel end
  return base .. rel
end

CC.Assets = CC.Assets or {}
CC.Assets.BaseFolder = GetBaseFolder()
CC.Assets.Path = function(rel)
  return PathJoin(GetBaseFolder(), rel)
end

-- ControlCenter textures (some are PNG/JPG and require extension)
CC.Assets.ControlCenterSprite = CC.Assets.Path("Images\\ControlCenter\\SettingsPanel.png")
CC.Assets.ControlCenterWidget = CC.Assets.Path("Images\\ControlCenter\\SettingsPanelWidget.png")
CC.Assets.ControlCenterBackground = CC.Assets.Path("Images\\ControlCenter\\SettingsPanelBackground.jpg")
CC.Assets.ControlCenterPreviewMask = CC.Assets.Path("Images\\ControlCenter\\PreviewMask.tga")

-- ExpansionLandingPage textures (TGA; extension optional, but keep consistent with Plumber)
CC.Assets.ExpansionBorderTWW = CC.Assets.Path("Images\\ExpansionLandingPage\\ExpansionBorder_TWW")
CC.Assets.DropdownMenuTex = CC.Assets.Path("Images\\ExpansionLandingPage\\DropdownMenu")
CC.Assets.HorizontalButtonHighlight = CC.Assets.Path("Images\\ExpansionLandingPage\\HorizontalButtonHighlight")

-- -----------------------------------------------------------------------------
-- API helpers (ported from Plumber/API.lua in small pieces)
-- -----------------------------------------------------------------------------

API.Mixin = Mixin

local floor = math.floor
local gsub = string.gsub

function API.Round(n)
  return floor((n or 0) + 0.5)
end

function API.Clamp(value, minValue, maxValue)
  if value > maxValue then
    return maxValue
  elseif value < minValue then
    return minValue
  end
  return value
end

function API.Lerp(startValue, endValue, amount)
  return (1 - amount) * startValue + amount * endValue
end

local function Saturate(value)
  return API.Clamp(value, 0.0, 1.0)
end

function API.DeltaLerp(startValue, endValue, amount, timeSec)
  return API.Lerp(startValue, endValue, Saturate((amount or 0) * (timeSec or 0) * 60.0))
end

function API.StringTrim(text)
  if text then
    text = gsub(text, "^(%s+)", "")
    text = gsub(text, "(%s+)$", "")
    if text ~= "" then
      return text
    end
  end
end

function API.SecondsToDate(seconds)
  if not seconds then return "" end
  return date("%d %b %Y", seconds)
end

function API.GetScaledCursorPosition()
  local x, y = GetCursorPosition()
  local scale = (UIParent and UIParent.GetEffectiveScale and UIParent:GetEffectiveScale()) or 1
  return x / scale, y / scale
end

function API.DisableSharpening(texture)
  if not texture then return end
  if texture.SetTexelSnappingBias then texture:SetTexelSnappingBias(0) end
  if texture.SetSnapToPixelGrid then texture:SetSnapToPixelGrid(false) end
end

-- -----------------------------------------------------------------------------
-- Easing (ported from Plumber/API.lua)
-- -----------------------------------------------------------------------------

CC.EasingFunctions = CC.EasingFunctions or {}
local Easing = CC.EasingFunctions

local sin = math.sin
local cos = math.cos
local pow = math.pow
local pi = math.pi

function Easing.linear(t, b, e, d)
  return (e - b) * t / d + b
end

function Easing.outSine(t, b, e, d)
  return (e - b) * sin(t / d * (pi / 2)) + b
end

function Easing.inOutSine(t, b, e, d)
  return -(e - b) / 2 * (cos(pi * t / d) - 1) + b
end

function Easing.outQuart(t, b, e, d)
  t = t / d - 1
  return (b - e) * (pow(t, 4) - 1) + b
end

function Easing.outQuint(t, b, e, d)
  t = t / d
  return (b - e) * (pow(1 - t, 5) - 1) + b
end

function Easing.inQuad(t, b, e, d)
  t = t / d
  return (e - b) * pow(t, 2) + b
end

-- -----------------------------------------------------------------------------
-- Object pool (ported from Plumber/Modules/ExpansionLandingPage/Basic.lua)
-- -----------------------------------------------------------------------------

do
  local tinsert = table.insert
  local tremove = table.remove
  local ipairs = ipairs

  local ObjectPoolMixin = {}

  function ObjectPoolMixin:ReleaseAll()
    for _, obj in ipairs(self.activeObjects) do
      if obj.Hide then obj:Hide() end
      if obj.ClearAllPoints then obj:ClearAllPoints() end
      if self.onRemoved then
        self.onRemoved(obj)
      end
    end

    local tbl = {}
    for k, object in ipairs(self.objects) do
      tbl[k] = object
    end
    self.unusedObjects = tbl
    self.activeObjects = {}
  end

  function ObjectPoolMixin:ReleaseObject(object)
    if object.Hide then object:Hide() end
    if object.ClearAllPoints then object:ClearAllPoints() end

    if self.onRemoved then
      self.onRemoved(object)
    end

    local found
    for k, obj in ipairs(self.activeObjects) do
      if obj == object then
        found = true
        tremove(self.activeObjects, k)
        break
      end
    end

    if found then
      tinsert(self.unusedObjects, object)
    end
  end

  function ObjectPoolMixin:Acquire()
    local object = tremove(self.unusedObjects)
    if not object then
      object = self.create()
      object.Release = self.Object_Release
      tinsert(self.objects, object)
    end
    tinsert(self.activeObjects, object)
    if self.onAcquired then
      self.onAcquired(object)
    end
    if object.Show then object:Show() end
    return object
  end

  function ObjectPoolMixin:CallMethod(method, ...)
    for _, object in ipairs(self.activeObjects) do
      if object[method] then
        object[method](object, ...)
      end
    end
  end

  function ObjectPoolMixin:CallMethodByPredicate(predicate, method, ...)
    for _, object in ipairs(self.activeObjects) do
      if predicate(object) and object[method] then
        object[method](object, ...)
      end
    end
  end

  function ObjectPoolMixin:EnumerateActive()
    return ipairs(self.activeObjects)
  end

  function ObjectPoolMixin:ProcessActiveObjects(processFunc)
    for _, object in ipairs(self.activeObjects) do
      if processFunc(object) then
        return
      end
    end
  end

  local function CreateObjectPool(create, onAcquired, onRemoved)
    local pool = {}
    API.Mixin(pool, ObjectPoolMixin)

    pool.objects = {}
    pool.activeObjects = {}
    pool.unusedObjects = {}

    pool.create = create
    pool.onAcquired = onAcquired
    pool.onRemoved = onRemoved

    function pool.Object_Release(obj)
      pool:ReleaseObject(obj)
    end

    return pool
  end

  LandingPageUtil.CreateObjectPool = CreateObjectPool
end

-- -----------------------------------------------------------------------------
-- UI Sounds (ported from Plumber/Modules/ExpansionLandingPage/Basic.lua)
-- -----------------------------------------------------------------------------

do
  local PlaySound = PlaySound

  local SoundEffects = {
    SwitchTab = SOUNDKIT.IG_CHARACTER_INFO_TAB,
    ScrollBarThumbDown = SOUNDKIT.U_CHAT_SCROLL_BUTTON,
    ScrollBarStep = SOUNDKIT.SCROLLBAR_STEP,
    CheckboxOn = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON,
    CheckboxOff = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF,
    DropdownOpen = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON,
    DropdownClose = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF,
    PageOpen = SOUNDKIT.IG_QUEST_LOG_OPEN,
    PageClose = SOUNDKIT.IG_QUEST_LOG_CLOSE,
  }

  function LandingPageUtil.PlayUISound(key)
    if SoundEffects[key] then
      PlaySound(SoundEffects[key])
    end
  end
end

-- -----------------------------------------------------------------------------
-- Minimal NineSlice helper (small port of Plumber's SliceFrame behavior)
-- -----------------------------------------------------------------------------

do
  local function CreateNineSliceFrame(parent)
    local f = CreateFrame("Frame", nil, parent or UIParent)

    f.pieces = {}
    for i = 1, 9 do
      local tex = f:CreateTexture(nil, "BORDER")
      API.DisableSharpening(tex)
      f.pieces[i] = tex
    end

    function f:SetUsingParentLevel(state)
      for i = 1, 9 do
        local tex = self.pieces[i]
        if tex and tex.SetUsingParentLevel then
          tex:SetUsingParentLevel(state)
        end
      end
    end

    function f:SetDisableSharpening(disable)
      for i = 1, 9 do
        local tex = self.pieces[i]
        if tex and tex.SetSnapToPixelGrid then
          tex:SetSnapToPixelGrid(not disable)
        end
        if disable then
          API.DisableSharpening(tex)
        end
      end
    end

    function f:SetTexture(texture)
      for i = 1, 9 do
        self.pieces[i]:SetTexture(texture)
      end
    end

    function f:SetCornerSize(w, h)
      w = w or 16
      h = h or 16

      local p = self.pieces
      for i = 1, 9 do
        p[i]:ClearAllPoints()
      end

      p[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
      p[1]:SetSize(w, h)

      p[3]:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
      p[3]:SetSize(w, h)

      p[7]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
      p[7]:SetSize(w, h)

      p[9]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
      p[9]:SetSize(w, h)

      p[2]:SetPoint("TOPLEFT", p[1], "TOPRIGHT", 0, 0)
      p[2]:SetPoint("TOPRIGHT", p[3], "TOPLEFT", 0, 0)
      p[2]:SetHeight(h)

      p[8]:SetPoint("BOTTOMLEFT", p[7], "BOTTOMRIGHT", 0, 0)
      p[8]:SetPoint("BOTTOMRIGHT", p[9], "BOTTOMLEFT", 0, 0)
      p[8]:SetHeight(h)

      p[4]:SetPoint("TOPLEFT", p[1], "BOTTOMLEFT", 0, 0)
      p[4]:SetPoint("BOTTOMLEFT", p[7], "TOPLEFT", 0, 0)
      p[4]:SetWidth(w)

      p[6]:SetPoint("TOPRIGHT", p[3], "BOTTOMRIGHT", 0, 0)
      p[6]:SetPoint("BOTTOMRIGHT", p[9], "TOPRIGHT", 0, 0)
      p[6]:SetWidth(w)

      p[5]:SetPoint("TOPLEFT", p[4], "TOPRIGHT", 0, 0)
      p[5]:SetPoint("BOTTOMRIGHT", p[6], "BOTTOMLEFT", 0, 0)
    end

    function f:CoverParent(padding)
      padding = padding or 0
      local parentFrame = self:GetParent()
      if not parentFrame then return end
      self:ClearAllPoints()
      self:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", -padding, padding)
      self:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", padding, -padding)
    end

    -- default geometry
    f:SetCornerSize(16, 16)

    return f
  end

  CC.CreateNineSliceFrame = CreateNineSliceFrame
end

-- -----------------------------------------------------------------------------
-- Three-slice helpers (for buttons)
-- -----------------------------------------------------------------------------

local function CreateThreeSliceTextures(frame, layer, leftKey, centerKey, rightKey, textureFile, leftOffset, rightOffset)
  local Left = frame[leftKey]
  if not Left then
    Left = frame:CreateTexture(nil, layer)
    frame[leftKey] = Left
  end
  Left:SetPoint("LEFT", frame, "LEFT", leftOffset or 0, 0)
  Left:SetTexture(textureFile)

  local Right = frame[rightKey]
  if not Right then
    Right = frame:CreateTexture(nil, layer)
    frame[rightKey] = Right
  end
  Right:SetPoint("RIGHT", frame, "RIGHT", rightOffset or 0, 0)
  Right:SetTexture(textureFile)

  local Center = frame[centerKey]
  if not Center then
    Center = frame:CreateTexture(nil, layer)
    frame[centerKey] = Center
    Center:SetPoint("TOPLEFT", Left, "TOPRIGHT", 0, 0)
    Center:SetPoint("BOTTOMRIGHT", Right, "BOTTOMLEFT", 0, 0)
  end
  Center:SetTexture(textureFile)
end

local function SetupThreeSliceBackground(frame, textureFile, leftOffset, rightOffset)
  CreateThreeSliceTextures(frame, "BACKGROUND", "Left", "Center", "Right", textureFile, leftOffset, rightOffset)
end

local function SetupThressSliceHighlight(frame, textureFile, leftOffset, rightOffset)
  CreateThreeSliceTextures(frame, "HIGHLIGHT", "HighlightLeft", "HighlightCenter", "HighlightRight", textureFile, leftOffset, rightOffset)
  local alpha = 0.25
  frame.HighlightLeft:SetBlendMode("ADD")
  frame.HighlightLeft:SetAlpha(alpha)
  frame.HighlightCenter:SetBlendMode("ADD")
  frame.HighlightCenter:SetAlpha(alpha)
  frame.HighlightRight:SetBlendMode("ADD")
  frame.HighlightRight:SetAlpha(alpha)
end

-- -----------------------------------------------------------------------------
-- Expansion-theme NineSlice frame (ported from Plumber/Modules/ExpansionLandingPage/Basic.lua)
-- -----------------------------------------------------------------------------

do
  local ExpansionThemeFrameMixin = {}

  function ExpansionThemeFrameMixin:ShowCloseButton(state)
    if state then
      self.pieces[3]:SetTexCoord(518 / 1024, 646 / 1024, 48 / 1024, 176 / 1024)
    else
      self.pieces[3]:SetTexCoord(384 / 1024, 512 / 1024, 0 / 1024, 128 / 1024)
    end
    self.CloseButton:SetShown(state)
  end

  function ExpansionThemeFrameMixin:SetCloseButtonOwner(frameToClose)
    self.CloseButton.frameToClose = frameToClose
  end

  function LandingPageUtil.CreateExpansionThemeFrame(parent, _expansionID)
    local tex = CC.Assets.ExpansionBorderTWW

    local f = CC.CreateNineSliceFrame(parent or UIParent)
    f:SetUsingParentLevel(true)
    f:SetCornerSize(64, 64)
    f:SetDisableSharpening(false)
    f:CoverParent(-30)

    local Background = f:CreateTexture(nil, "BACKGROUND")
    f.Background = Background
    Background:SetPoint("TOPLEFT", f.pieces[1], "TOPLEFT", 4, -4)
    Background:SetPoint("BOTTOMRIGHT", f.pieces[9], "BOTTOMRIGHT", -4, 4)
    Background:SetColorTexture(0.067, 0.040, 0.024)

    f:SetTexture(tex)
    f.pieces[1]:SetTexCoord(0 / 1024, 128 / 1024, 0 / 1024, 128 / 1024)
    f.pieces[2]:SetTexCoord(128 / 1024, 384 / 1024, 0 / 1024, 128 / 1024)
    f.pieces[3]:SetTexCoord(384 / 1024, 512 / 1024, 0 / 1024, 128 / 1024)
    f.pieces[4]:SetTexCoord(0 / 1024, 128 / 1024, 128 / 1024, 384 / 1024)
    f.pieces[5]:SetTexCoord(128 / 1024, 384 / 1024, 128 / 1024, 384 / 1024)
    f.pieces[6]:SetTexCoord(384 / 1024, 512 / 1024, 128 / 1024, 384 / 1024)
    f.pieces[7]:SetTexCoord(0 / 1024, 128 / 1024, 384 / 1024, 512 / 1024)
    f.pieces[8]:SetTexCoord(128 / 1024, 384 / 1024, 384 / 1024, 512 / 1024)
    f.pieces[9]:SetTexCoord(384 / 1024, 512 / 1024, 384 / 1024, 512 / 1024)

    local CloseButton = CreateFrame("Button", nil, f)
    f.CloseButton = CloseButton
    CloseButton:Hide()
    CloseButton:SetSize(32, 32)
    CloseButton:SetPoint("CENTER", f.pieces[3], "TOPRIGHT", -20.5, -20.5)
    CloseButton.Texture = CloseButton:CreateTexture(nil, "OVERLAY")
    CloseButton.Texture:SetPoint("CENTER", CloseButton, "CENTER", 0, 0)
    CloseButton.Texture:SetSize(24, 24)
    CloseButton.Texture:SetTexture(tex)
    CloseButton.Texture:SetTexCoord(646 / 1024, 694 / 1024, 48 / 1024, 96 / 1024)
    CloseButton.Highlight = CloseButton:CreateTexture(nil, "HIGHLIGHT")
    CloseButton.Highlight:SetPoint("CENTER", CloseButton, "CENTER", 0, 0)
    CloseButton.Highlight:SetSize(24, 24)
    CloseButton.Highlight:SetTexture(tex)
    CloseButton.Highlight:SetTexCoord(646 / 1024, 694 / 1024, 48 / 1024, 96 / 1024)
    CloseButton.Highlight:SetBlendMode("ADD")
    CloseButton.Highlight:SetAlpha(0.5)

    CloseButton:SetScript("OnClick", function(self)
      if self.frameToClose then
        if self.frameToClose.Close then
          self.frameToClose:Close()
        else
          self.frameToClose:Hide()
        end
      end
    end)

    API.Mixin(f, ExpansionThemeFrameMixin)

    return f
  end
end

-- -----------------------------------------------------------------------------
-- Red button (used by SettingsPanel minimized UI)
-- -----------------------------------------------------------------------------

do
  local RedButtonMixin = {}

  function RedButtonMixin:SetButtonText(text)
    self.ButtonText:SetText(text)
  end

  function RedButtonMixin:UpdateVisual()
    -- Minimal: keep the look from the three-slice background + highlight.
    if self.buttonState == 3 then
      self.ButtonText:SetTextColor(0.5, 0.5, 0.5)
    elseif self.buttonState == 2 then
      self.ButtonText:SetTextColor(1, 1, 1)
    else
      self.ButtonText:SetTextColor(0.922, 0.871, 0.761)
    end
  end

  function RedButtonMixin:OnMouseDown()
    if not self:IsEnabled() then return end
    self.buttonState = 2
    self:UpdateVisual()
  end

  function RedButtonMixin:OnMouseUp()
    if not self:IsEnabled() then return end
    self.buttonState = 1
    self:UpdateVisual()
  end

  function RedButtonMixin:OnEnter()
    self.buttonState = self:IsEnabled() and 2 or 3
    self:UpdateVisual()
  end

  function RedButtonMixin:OnLeave()
    self.buttonState = self:IsEnabled() and 1 or 3
    self:UpdateVisual()
  end

  function RedButtonMixin:OnEnable()
    self.buttonState = 1
    self:UpdateVisual()
  end

  function RedButtonMixin:OnDisable()
    self.buttonState = 3
    self:UpdateVisual()
  end

  local function CreateRedButton(parent)
    local f = CreateFrame("Button", nil, parent)
    API.Mixin(f, RedButtonMixin)

    f.buttonState = 1
    f:SetSize(240, 24)

    f.ButtonText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.ButtonText:SetPoint("CENTER", f, "CENTER", 0, 0)
    f.ButtonText:SetJustifyH("CENTER")
    f.ButtonText:SetTextColor(0.922, 0.871, 0.761)

    local tex = CC.Assets.ExpansionBorderTWW
    SetupThreeSliceBackground(f, tex, -2.5, 2.5)
    f.Left:SetSize(16, 32)
    f.Left:SetTexCoord(768 / 1024, 800 / 1024, 448 / 1024, 512 / 1024)
    f.Right:SetSize(16, 32)
    f.Right:SetTexCoord(972 / 1024, 1004 / 1024, 448 / 1024, 512 / 1024)
    f.Center:SetTexCoord(800 / 1024, 972 / 1024, 448 / 1024, 512 / 1024)

    SetupThressSliceHighlight(f, tex, -2.5, 2.5)
    f.HighlightLeft:SetSize(16, 32)
    f.HighlightLeft:SetTexCoord(768 / 1024, 800 / 1024, 448 / 1024, 512 / 1024)
    f.HighlightRight:SetSize(16, 32)
    f.HighlightRight:SetTexCoord(972 / 1024, 1004 / 1024, 448 / 1024, 512 / 1024)
    f.HighlightCenter:SetTexCoord(800 / 1024, 972 / 1024, 448 / 1024, 512 / 1024)

    f:SetScript("OnEnter", f.OnEnter)
    f:SetScript("OnLeave", f.OnLeave)
    f:SetScript("OnMouseDown", f.OnMouseDown)
    f:SetScript("OnMouseUp", f.OnMouseUp)
    f:SetScript("OnEnable", f.OnEnable)
    f:SetScript("OnDisable", f.OnDisable)

    f:UpdateVisual()

    return f
  end

  LandingPageUtil.CreateRedButton = CreateRedButton
end

-- -----------------------------------------------------------------------------
-- Button highlight helper (used by DropdownMenu)
-- -----------------------------------------------------------------------------

do
  local function CreateButtonHighlight(parent)
    local f = CreateFrame("Frame", nil, parent)
    f:Hide()
    f:SetUsingParentLevel(true)
    f:SetSize(232, 40)
    local tex = f:CreateTexture(nil, "BACKGROUND")
    f.Texture = tex
    tex:SetAllPoints()
    tex:SetTexture(CC.Assets.HorizontalButtonHighlight)
    tex:SetBlendMode("ADD")
    tex:SetVertexColor(51 / 255, 29 / 255, 17 / 255)
    return f
  end
  LandingPageUtil.CreateButtonHighlight = CreateButtonHighlight
end

-- -----------------------------------------------------------------------------
-- Text redactor (minimal stub)
-- -----------------------------------------------------------------------------
-- Plumber uses a fancy redaction effect in changelogs. WoWLang does not need the effect,
-- but the SettingsPanel code expects the object and method names to exist.
do
  local function CreateTextRedactor(parent)
    local f = CreateFrame("Frame", nil, parent or UIParent)
    f:Hide()

    function f:SetColor()
      -- no-op
    end

    function f:RedactFontString()
      -- no-op: do not redact in WoWLang
    end

    return f
  end

  CC.CreateTextRedactor = CreateTextRedactor
end

-- -----------------------------------------------------------------------------
-- Dropdown menu (ported from Plumber/Modules/ExpansionLandingPage/Basic.lua)
-- -----------------------------------------------------------------------------

do
  local Mixin = API.Mixin
  local GameTooltip = GameTooltip
  local ipairs = ipairs

  local SharedMenuMixin = {}
  local MenuButtonMixin = {}

  function MenuButtonMixin:OnEnter()
    self.Text:SetTextColor(1, 1, 1)
    self.parent:HighlightButton(self)
    if self.tooltip then
      local tooltip = GameTooltip
      tooltip:SetOwner(self, "ANCHOR_NONE")
      tooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, 4)
      tooltip:SetText(self.Text:GetText(), 1, 1, 1, 1, true)
      tooltip:AddLine(self.tooltip, 1, 0.82, 0, true)
      tooltip:Show()
    end
  end

  function MenuButtonMixin:OnLeave()
    self:UpdateVisual()
    self.parent:HighlightButton(nil)
    GameTooltip:Hide()
  end

  function MenuButtonMixin:UpdateVisual()
    if self.isHeader then
      self.Text:SetTextColor(148 / 255, 124 / 255, 102 / 255)
      return
    end

    if self:IsEnabled() then
      if self.isDangerousAction then
        self.Text:SetTextColor(1.000, 0.125, 0.125)
      else
        self.Text:SetTextColor(215 / 255, 192 / 255, 163 / 255)
      end
      self.LeftTexture:SetDesaturated(false)
      self.LeftTexture:SetVertexColor(1, 1, 1)
    else
      self.Text:SetTextColor(0.5, 0.5, 0.5)
      self.LeftTexture:SetDesaturated(true)
      self.LeftTexture:SetVertexColor(0.6, 0.6, 0.6)
    end
  end

  function MenuButtonMixin:OnClick(button)
    if self.onClickFunc then
      self.onClickFunc(button)
    end

    if self.closeAfterClick then
      self.parent:HideMenu()
    elseif self.refreshAfterClick then
      self.parent:RefreshMenu()
    end
  end

  function MenuButtonMixin:SetLeftText(text)
    self.Text:SetText(text)
  end

  function MenuButtonMixin:SetRightTexture(icon)
    self.RightTexture:SetTexture(icon)
    if icon then
      self.rightOffset = 20
    else
      self.rightOffset = 4
    end
  end

  function MenuButtonMixin:SetRegular()
    self.leftOffset = 4
    self.selected = nil
    self.isHeader = nil
    self.LeftTexture:Hide()
    self:Layout()
  end

  function MenuButtonMixin:SetHeader(text)
    self.leftOffset = 4
    self.selected = nil
    self.isHeader = true
    self.LeftTexture:Hide()
    self.Text:SetText(text)
    self:Disable()
    self:Layout()
  end

  function MenuButtonMixin:SetRadio(selected)
    self.leftOffset = 20
    self.selected = selected
    self.isHeader = nil
    self.refreshAfterClick = true
    self.LeftTexture:SetTexture(CC.Assets.DropdownMenuTex, nil, nil, "LINEAR")
    if selected then
      self.LeftTexture:SetTexCoord(32 / 512, 64 / 512, 0 / 512, 32 / 512)
    else
      self.LeftTexture:SetTexCoord(0 / 512, 32 / 512, 0 / 512, 32 / 512)
    end
    self.LeftTexture:Show()
    self:Layout()
  end

  function MenuButtonMixin:SetCheckbox(selected)
    self.leftOffset = 20
    self.selected = selected
    self.isHeader = nil
    self.refreshAfterClick = true
    self.LeftTexture:SetTexture(CC.Assets.DropdownMenuTex, nil, nil, "LINEAR")
    if selected then
      self.LeftTexture:SetTexCoord(96 / 512, 128 / 512, 0 / 512, 32 / 512)
    else
      self.LeftTexture:SetTexCoord(64 / 512, 96 / 512, 0 / 512, 32 / 512)
    end
    self.LeftTexture:Show()
    self:Layout()
  end

  function MenuButtonMixin:Layout()
    self.Text:SetPoint("LEFT", self, "LEFT", self.paddingH + self.leftOffset, 0)
  end

  function MenuButtonMixin:GetContentWidth()
    return self.Text:GetWrappedWidth() + self.leftOffset + self.rightOffset + 2 * self.paddingH
  end

  local function CreateMenuButton(parent)
    local f = CreateFrame("Button", nil, parent)
    f:SetSize(240, 24)
    Mixin(f, MenuButtonMixin)
    f.leftOffset = 0
    f.rightOffset = 0
    f.paddingH = 8

    f.Text = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.Text:SetPoint("LEFT", f, "LEFT", f.paddingH, 0)
    f.Text:SetJustifyH("LEFT")
    f.Text:SetTextColor(0.922, 0.871, 0.761)

    f.LeftTexture = f:CreateTexture(nil, "OVERLAY")
    f.LeftTexture:SetSize(16, 16)
    f.LeftTexture:SetPoint("LEFT", f, "LEFT", f.paddingH, 0)
    f.LeftTexture:Hide()

    f.RightTexture = f:CreateTexture(nil, "OVERLAY")
    f.RightTexture:SetSize(18, 18)
    f.RightTexture:SetPoint("RIGHT", f, "RIGHT", -f.paddingH, 0)

    f:SetScript("OnEnter", f.OnEnter)
    f:SetScript("OnLeave", f.OnLeave)
    f:SetScript("OnClick", f.OnClick)

    -- Ensure Arabic font is applied for our custom dropdown menu (not a Blizzard DropDownList frame).
    if WOWTR and WOWTR.Fonts and WOWTR.Fonts.Apply then
      WOWTR.Fonts.Apply(f)
    end

    return f
  end

  function SharedMenuMixin:SetSize(width, height)
    if width < 40 then width = 40 end
    if height < 40 then height = 40 end
    if self.Frame then
      self.Frame:SetSize(width, height)
    end
  end

  function SharedMenuMixin:SetPaddingV(paddingV)
    self.paddingV = paddingV
  end

  function SharedMenuMixin:SetContentSize(width, height)
    local padding = 2 * (self.paddingV or 0)
    self:SetSize(width, height + padding)
  end

  function SharedMenuMixin:IsShown()
    return self.Frame and self.Frame:IsShown()
  end

  function SharedMenuMixin:ReleaseAllObjects()
    self.buttonPool:ReleaseAll()
    self.texturePool:ReleaseAll()
  end

  function SharedMenuMixin:HideMenu()
    if self.Frame then
      self.Frame:Hide()
      self.Frame:ClearAllPoints()
      if not self.keepContentOnHide then
        self:ReleaseAllObjects()
      end
    end
    self.menuInfoGetter = nil
  end

  function SharedMenuMixin:HighlightButton(button)
    self.Highlight:Hide()
    self.Highlight:ClearAllPoints()
    if button then
      self.Highlight:SetParent(button)
      self.Highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
      self.Highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
      self.Highlight:Show()
    end
  end

  function SharedMenuMixin:AnchorToObject(object)
    local f = self.Frame
    if not f then return end
    f:ClearAllPoints()
    f:SetParent(object)
    f:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, -6)
  end

  function SharedMenuMixin:AnchorToCursor(owner, offsetX, offsetY)
    local f = self.Frame
    if not f then return end
    f:ClearAllPoints()
    f:SetParent(UIParent)
    local x, y = API.GetScaledCursorPosition()
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x + offsetX, y + offsetY)
  end

  function SharedMenuMixin:ShowMenu(owner, menuInfo)
    if self.Init then
      self:Init()
    end

    self.buttonPool:ReleaseAll()
    self.owner = owner

    if not owner then return end

    if menuInfo and menuInfo.widgets then
      self.NoContentAlert:Hide()

      local f = self.Frame
      if self.openAtCursorPosition or menuInfo.openAtCursorPosition then
        self:AnchorToCursor(owner, 16, 8)
      else
        self:AnchorToObject(owner)
      end

      local buttonHeight = 24
      local n = 0
      local widget
      local offsetX = 0
      local offsetY = self.paddingV or 6
      local contentWidth = ((menuInfo.fitToOwner or self.fitToOwner) and owner:GetWidth()) or 0
      local contentHeight = 0
      local widgetWidth
      local widgets = {}

      for _, v in ipairs(menuInfo.widgets) do
        n = n + 1
        if v.type == "Checkbox" or v.type == "Radio" or v.type == "Button" or v.type == "Header" then
          widget = self.buttonPool:Acquire()
          widget:SetRightTexture(v.rightTexture)
          widget:SetPoint("TOPLEFT", f, "TOPLEFT", offsetX, -offsetY)
          offsetY = offsetY + buttonHeight
          contentHeight = contentHeight + buttonHeight
          widget.onClickFunc = v.onClickFunc
          widget.closeAfterClick = v.closeAfterClick
          widget.refreshAfterClick = v.refreshAfterClick
          widget.isDangerousAction = v.isDangerousAction
          widget:SetLeftText(v.text)
          if v.type == "Radio" then
            widget:SetRadio(v.selected)
          elseif v.type == "Checkbox" then
            widget:SetCheckbox(v.selected)
          elseif v.type == "Header" then
            widget:SetHeader(v.text)
          else
            widget:SetRegular()
          end
          if v.disabled then
            widget:Disable()
          end
          widget:UpdateVisual()
        elseif v.type == "Divider" then
          widget = self.texturePool:Acquire()
          widget:SetTexture(CC.Assets.DropdownMenuTex)
          widget:SetTexCoord(0 / 512, 128 / 512, 32 / 512, 48 / 512)
          widget:SetSize(64, 8)
          local dividerHeight = 8
          local gap = 2
          offsetY = offsetY + gap
          widget:SetPoint("TOPLEFT", f, "TOPLEFT", offsetX, -offsetY)
          offsetY = offsetY + dividerHeight + gap
          contentHeight = contentHeight + dividerHeight + 2 * gap
        end

        widget.parent = self
        widget.tooltip = v.tooltip
        widgets[n] = widget

        if widget.GetContentWidth then
          widgetWidth = widget:GetContentWidth()
          if widgetWidth > contentWidth then
            contentWidth = widgetWidth
          end
        end
      end

      if contentWidth < 96 then
        contentWidth = 96
      end
      contentWidth = API.Round(contentWidth)
      contentHeight = API.Round(contentHeight)

      for _, w in ipairs(widgets) do
        w:SetWidth(contentWidth)
      end

      self:SetContentSize(contentWidth, contentHeight)
      f:Show()
      self.visible = true
    else
      if self.useNoContentAlert then
        self.NoContentAlert:Show()
        local contentWidth = owner:GetWidth()
        local contentHeight = 24
        contentWidth = API.Round(contentWidth)
        contentHeight = API.Round(contentHeight)
        self:SetContentSize(contentWidth, contentHeight)
        self:AnchorToObject(owner)
        self.Frame:Show()
        self.visible = true
      end
    end
  end

  function SharedMenuMixin:ToggleMenu(owner, menuInfoGetter)
    if self.owner == owner and (self.Frame and self.Frame:IsShown()) then
      self:HideMenu()
    else
      self.menuInfoGetter = owner.menuInfoGetter or menuInfoGetter
      local menuInfo = self.menuInfoGetter and self.menuInfoGetter() or nil
      self:ShowMenu(owner, menuInfo)
    end
  end

  function SharedMenuMixin:RefreshMenu()
    if self.owner and self.owner:IsVisible() and self:IsShown() and self.menuInfoGetter then
      local menuInfo = self.menuInfoGetter and self.menuInfoGetter() or nil
      self:ShowMenu(self.owner, menuInfo)
    end
  end

  function SharedMenuMixin:Init()
    self.Init = nil

    local Frame = CreateFrame("Frame", nil, self.parent or UIParent)
    self.Frame = Frame
    Frame:Hide()
    Frame:SetSize(112, 112)
    Frame:SetFrameStrata("FULLSCREEN_DIALOG")
    Frame:SetFixedFrameStrata(true)
    Frame:EnableMouse(true)
    Frame:EnableMouseMotion(true)
    Frame:SetClampedToScreen(true)
    self:SetPaddingV(6)

    local bg = CC.CreateNineSliceFrame(Frame)
    Frame.Background = bg
    bg:SetUsingParentLevel(true)
    bg:SetCornerSize(16, 16)
    bg:SetDisableSharpening(false)
    bg:CoverParent(0)
    bg:SetTexture(CC.Assets.ExpansionBorderTWW)
    bg.pieces[1]:SetTexCoord(512 / 1024, 544 / 1024, 320 / 1024, 352 / 1024)
    bg.pieces[2]:SetTexCoord(544 / 1024, 736 / 1024, 320 / 1024, 352 / 1024)
    bg.pieces[3]:SetTexCoord(736 / 1024, 768 / 1024, 320 / 1024, 352 / 1024)
    bg.pieces[4]:SetTexCoord(512 / 1024, 544 / 1024, 352 / 1024, 544 / 1024)
    bg.pieces[5]:SetTexCoord(544 / 1024, 736 / 1024, 352 / 1024, 544 / 1024)
    bg.pieces[6]:SetTexCoord(736 / 1024, 768 / 1024, 352 / 1024, 544 / 1024)
    bg.pieces[7]:SetTexCoord(512 / 1024, 544 / 1024, 544 / 1024, 576 / 1024)
    bg.pieces[8]:SetTexCoord(544 / 1024, 736 / 1024, 544 / 1024, 576 / 1024)
    bg.pieces[9]:SetTexCoord(736 / 1024, 768 / 1024, 544 / 1024, 576 / 1024)

    local NoContentAlert = Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.NoContentAlert = NoContentAlert
    NoContentAlert:Hide()
    NoContentAlert:SetPoint("LEFT", Frame, "LEFT", 16, 0)
    NoContentAlert:SetPoint("RIGHT", Frame, "RIGHT", -16, 0)
    NoContentAlert:SetTextColor(0.5, 0.5, 0.5)
    NoContentAlert:SetJustifyH("CENTER")
    if self.noContentAlertText then
      NoContentAlert:SetText(self.noContentAlertText)
    end

    local function MenuButton_Create()
      return CreateMenuButton(Frame)
    end
    local function MenuButton_OnAcquire(obj)
      obj:Enable()
    end
    self.buttonPool = LandingPageUtil.CreateObjectPool(MenuButton_Create, nil, MenuButton_OnAcquire)

    local function Texture_Create()
      return Frame:CreateTexture(nil, "OVERLAY")
    end
    self.texturePool = LandingPageUtil.CreateObjectPool(Texture_Create)

    self.Highlight = LandingPageUtil.CreateButtonHighlight(Frame)
    self.Highlight.Texture:SetTexture(CC.Assets.DropdownMenuTex)
    self.Highlight.Texture:SetTexCoord(368 / 512, 512 / 512, 0 / 512, 48 / 512)
    self.Highlight.Texture:SetVertexColor(119 / 255, 96 / 255, 74 / 255)
    self.Highlight.Texture:SetBlendMode("ADD")

    Frame:SetScript("OnShow", function()
      Frame:RegisterEvent("GLOBAL_MOUSE_DOWN")
      LandingPageUtil.PlayUISound("DropdownOpen")
    end)

    Frame:SetScript("OnHide", function()
      self:HideMenu()
      Frame:UnregisterEvent("GLOBAL_MOUSE_DOWN")
      LandingPageUtil.PlayUISound("DropdownClose")
    end)

    Frame:SetScript("OnEvent", function()
      if not (Frame:IsMouseOver() or (self.owner and self.owner:IsMouseMotionFocus())) then
        Frame:Hide()
      end
    end)
  end

  local function CreateMenuFrame(parent, obj)
    obj = obj or {}
    Mixin(obj, SharedMenuMixin)
    obj.parent = parent
    return obj
  end

  LandingPageUtil.CreateMenuFrame = CreateMenuFrame

  local MainDropdownMenu = CreateMenuFrame(UIParent, { name = "WOWTR_ControlCenter_MainDropdownMenu" })
  MainDropdownMenu.fitToOwner = true
  LandingPageUtil.DropdownMenu = MainDropdownMenu
end


