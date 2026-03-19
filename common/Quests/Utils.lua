-- Quests/Utils.lua
-- Utility helpers for quests and gossip (split out)

local addonName, ns = ...
ns = ns or {}
ns.Quests = ns.Quests or {}
local Quests = ns.Quests

Quests.Utils = Quests.Utils or {}

-- Debug print wrapper for quest module
-- Routes through the unified WOWTR.Debug system (quests category, NORMAL verbosity).
function Quests.Utils.DebugPrint(...)
  if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
    WOWTR.Debug.Normal(WOWTR.Debug.Categories.QUESTS, ...)
  end
end


-- Return the first FontString region from a frame
function Quests.Utils.GetFirstFontStringRegion(frame)
   if not frame or not frame.GetRegions then
      return nil
   end
   local regions = { frame:GetRegions() }
   for _, region in pairs(regions) do
      if (region and region.GetObjectType and region:GetObjectType()=="FontString") then
         return region
      end
   end
   return nil
end

-- Apply LTR/RTL layout for an option button (icon + text)
function Quests.Utils.ApplyOptionButtonLayout(buttonFrame, isRTL)
   if not buttonFrame then return end
   local fontStringRegion = Quests.Utils.GetFirstFontStringRegion(buttonFrame)
   if not fontStringRegion then return end
   local iconRegion = buttonFrame.Icon

   -- Normalize height: make icon and text share vertical center and similar height
   local _, currentFontSize = fontStringRegion:GetFont()
   local textHeight = fontStringRegion:GetStringHeight() or currentFontSize or 13
   local targetIconSize = math.max(currentFontSize or 13, 14)
   if iconRegion and iconRegion.SetSize then iconRegion:SetSize(targetIconSize, targetIconSize) end
   if fontStringRegion.SetJustifyV then fontStringRegion:SetJustifyV("MIDDLE") end

   if isRTL then
      if iconRegion then
         iconRegion:ClearAllPoints()
         iconRegion:SetPoint("RIGHT", buttonFrame, "RIGHT", -20, 0)
         fontStringRegion:ClearAllPoints()
         fontStringRegion:SetPoint("RIGHT", iconRegion, "LEFT", -5, 0)
         fontStringRegion:SetJustifyH("RIGHT")
      else
         fontStringRegion:ClearAllPoints()
         fontStringRegion:SetPoint("RIGHT", buttonFrame, "RIGHT", -20, 0)
         fontStringRegion:SetJustifyH("RIGHT")
      end
   else
      local leftPadding = 10
      if iconRegion then
         iconRegion:ClearAllPoints()
         iconRegion:SetPoint("LEFT", buttonFrame, "LEFT", 5, 0)
         leftPadding = (iconRegion.GetWidth and iconRegion:GetWidth() or 0) + 10
      end
      fontStringRegion:ClearAllPoints()
      fontStringRegion:SetPoint("LEFT", buttonFrame, "LEFT", leftPadding, 0)
      fontStringRegion:SetJustifyH("LEFT")
   end

   -- Ensure button height fits tallest element
   local finalHeight = math.max(textHeight, targetIconSize) + 4
   if buttonFrame.SetHeight then buttonFrame:SetHeight(finalHeight) end
end

-- Return current RTL state using centralized helper
function Quests.Utils.IsRTL()
  return ns and ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL() or false
end

-- Apply text with proper shaping/justification for RTL or LTR
-- fs: FontString; text: string; font: path or FontObject; size: number
-- rtlOffset: number (optional negative width correction); ltrJustify: "LEFT" or "CENTER" or "RIGHT" (defaults to LEFT)
function Quests.Utils.ApplyRTLText(fs, text, font, size, rtlOffset, ltrJustify)
  if not fs or not text then return end
  local isRTL = Quests.Utils.IsRTL()
  if font and size then fs:SetFont(font, size) end
  if isRTL then
    fs:SetText(QTR_ExpandUnitInfo(text, false, fs, font or WOWTR_Font2, rtlOffset or -5))
    if ns and ns.RTL and ns.RTL.JustifyFontString then
      ns.RTL.JustifyFontString(fs, "LEFT")
    else
      fs:SetJustifyH("RIGHT")
    end
  else
    fs:SetText(QTR_ExpandUnitInfo(text, false, fs, font or WOWTR_Font2))
    local justify = ltrJustify or "LEFT"
    if ns and ns.RTL and ns.RTL.JustifyFontString then
      ns.RTL.JustifyFontString(fs, justify)
    else
      fs:SetJustifyH(justify)
    end
  end
end

-- Create a simple UIPanelButton with common properties
-- Returns the created button
function Quests.Utils.CreateButton(parent, width, height, text, point, relativeTo, relativePoint, x, y, onClick)
  if not parent then return nil end
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  if width then btn:SetWidth(width) end
  if height then btn:SetHeight(height) end
  if text then btn:SetText(text) end
  btn:ClearAllPoints()
  if point and relativeTo and relativePoint then
    btn:SetPoint(point, relativeTo, relativePoint, x or 0, y or 0)
  end
  if type(onClick) == "function" then
    btn:SetScript("OnClick", onClick)
  end
  return btn
end

Quests.Utils.ToggleButtons = Quests.Utils.ToggleButtons or {}
local ToggleButtons = Quests.Utils.ToggleButtons

local function ToggleQuestTranslation(...)
  if Quests and Quests.ToggleTranslation then
    return Quests.ToggleTranslation(...)
  end
end

ToggleButtons.registry = ToggleButtons.registry or {}
ToggleButtons.order = ToggleButtons.order or {
  "quest",
  "popup",
  "map",
  "classic",
  "immersion",
  "storyline",
  "dui",
}

ToggleButtons.specs = ToggleButtons.specs or {
  quest = {
    globalName = "QTR_ToggleButton0",
    width = 150,
    height = 20,
    placeholderText = "QID?",
    parent = function() return _G.QuestFrame end,
    relativeTo = function() return _G.QuestFrame end,
    point = { "TOPLEFT", "TOPLEFT", 55, -20 },
    onClick = ToggleQuestTranslation,
  },
  popup = {
    globalName = "QTR_ToggleButton1",
    width = 150,
    height = 20,
    placeholderText = "QID?",
    parent = function() return _G.QuestLogPopupDetailFrame end,
    relativeTo = function() return _G.QuestLogPopupDetailFrame end,
    point = { "TOPLEFT", "TOPLEFT", 45, -31 },
    onClick = ToggleQuestTranslation,
  },
  map = {
    globalName = "QTR_ToggleButton2",
    width = 110,
    height = 22,
    placeholderText = "QID?",
    parent = function() return _G.QuestMapDetailsScrollFrame end,
    relativeTo = function() return _G.QuestMapDetailsScrollFrame end,
    point = { "TOPLEFT", "TOPLEFT", 96, 32 },
    onClick = ToggleQuestTranslation,
  },
  classic = {
    globalName = "QTR_ToggleButton3",
    width = 150,
    height = 20,
    placeholderText = "QID?",
    parent = function() return _G.ClassicQuestLog end,
    relativeTo = function() return _G.ClassicQuestLog end,
    point = { "TOPLEFT", "TOPLEFT", 330, -33 },
    onClick = ToggleQuestTranslation,
  },
  immersion = {
    globalName = "QTR_ToggleButton4",
    width = 150,
    height = 20,
    placeholderText = function()
      if _G.WOWTR_Localization and _G.WOWTR_Localization.choiceQuestFirst and _G.QTR_ReverseIfAR then
        return _G.QTR_ReverseIfAR(_G.WOWTR_Localization.choiceQuestFirst)
      end
      return "QID?"
    end,
    parent = function() return _G.ImmersionFrame and _G.ImmersionFrame.TalkBox end,
    relativeTo = function() return _G.ImmersionFrame and _G.ImmersionFrame.TalkBox end,
    point = { "TOPLEFT", "TOPRIGHT", -200, -116 },
    onClick = ToggleQuestTranslation,
  },
  storyline = {
    globalName = "QTR_ToggleButton5",
    width = 150,
    height = 20,
    placeholderText = function()
      if _G.WOWTR_Localization and _G.WOWTR_Localization.choiceQuestFirst and _G.QTR_ReverseIfAR then
        return _G.QTR_ReverseIfAR(_G.WOWTR_Localization.choiceQuestFirst)
      end
      return "QID?"
    end,
    parent = function() return _G.Storyline_NPCFrameChat end,
    relativeTo = function() return _G.Storyline_NPCFrameChat end,
    point = { "BOTTOMLEFT", "BOTTOMLEFT", 244, -16 },
    onClick = ToggleQuestTranslation,
  },
  dui = {
    globalName = "QTR_ToggleButton7",
    width = 120,
    height = 20,
    placeholderText = "QID?",
    parent = function() return rawget(_G, "DUIQuestFrame") end,
    relativeTo = function() return rawget(_G, "DUIQuestFrame") end,
    point = { "TOPLEFT", "TOPLEFT", 295, -16 },
    fontPath = "Fonts\\FRIZQT__.TTF",
    fontSize = 8,
    fontFlags = "OUTLINE",
  },
}

local function ToggleButtonsGetSpec(key)
  return key and ToggleButtons.specs and ToggleButtons.specs[key] or nil
end

local function ToggleButtonsResolveFrame(frameOrGetter)
  if type(frameOrGetter) == "function" then
    local ok, value = pcall(frameOrGetter)
    if ok then return value end
    return nil
  end
  return frameOrGetter
end

local function ToggleButtonsResolveText(value)
  if type(value) == "function" then
    local ok, text = pcall(value)
    if ok then return text end
    return nil
  end
  return value
end

function ToggleButtons.GetButton(key)
  local spec = ToggleButtonsGetSpec(key)
  if not spec then return nil end
  local button = ToggleButtons.registry[key]
  if not button and spec.globalName then
    button = rawget(_G, spec.globalName)
    if button then
      ToggleButtons.registry[key] = button
    end
  end
  return button
end

function ToggleButtons.GetSpec(key)
  return ToggleButtonsGetSpec(key)
end

function ToggleButtons.GetPlaceholderText(key)
  local spec = ToggleButtonsGetSpec(key)
  return ToggleButtonsResolveText(spec and spec.placeholderText) or "QID?"
end

function ToggleButtons.BuildQuestText(key, questID, modeTag)
  local spec = ToggleButtonsGetSpec(key)
  local prefix = (spec and spec.prefix) or "QID"
  local qid = tonumber(questID) or 0
  if qid > 0 and modeTag and modeTag ~= "" then
    return prefix .. "=" .. qid .. " (" .. tostring(modeTag) .. ")"
  end
  if qid > 0 then
    return prefix .. "=" .. qid
  end
  return ToggleButtons.GetPlaceholderText(key)
end

function ToggleButtons.ApplyStyle(key, button)
  local spec = ToggleButtonsGetSpec(key)
  if not (spec and button) then return end

  if spec.width then button:SetWidth(spec.width) end
  if spec.height then button:SetHeight(spec.height) end

  local fontString = button.GetFontString and button:GetFontString() or nil
  if fontString and (spec.fontPath or spec.fontSize or spec.fontFlags) then
    local currentFont, currentSize, currentFlags = fontString:GetFont()
    fontString:SetFont(
      spec.fontPath or currentFont,
      spec.fontSize or currentSize or 12,
      spec.fontFlags or currentFlags or ""
    )
  end
end

function ToggleButtons.ApplyAnchor(key, button)
  local spec = ToggleButtonsGetSpec(key)
  if not (spec and button and spec.point) then return end

  local parent = ToggleButtonsResolveFrame(spec.parent)
  local relativeTo = ToggleButtonsResolveFrame(spec.relativeTo) or parent
  if not (parent and relativeTo) then return end

  button:ClearAllPoints()
  button:SetPoint(spec.point[1], relativeTo, spec.point[2], spec.point[3] or 0, spec.point[4] or 0)
end

function ToggleButtons.ApplyOnClick(key, button)
  local spec = ToggleButtonsGetSpec(key)
  if not (spec and button and type(spec.onClick) == "function") then return end
  button:SetScript("OnClick", spec.onClick)
end

function ToggleButtons.Refresh(key)
  local button = ToggleButtons.GetButton(key)
  if not button then return nil end
  ToggleButtons.ApplyStyle(key, button)
  ToggleButtons.ApplyAnchor(key, button)
  ToggleButtons.ApplyOnClick(key, button)
  return button
end

function ToggleButtons.Ensure(key, overrides)
  local spec = ToggleButtonsGetSpec(key)
  if not spec then return nil end

  if type(overrides) == "table" then
    ToggleButtons.Configure(key, overrides)
  end

  local parent = ToggleButtonsResolveFrame(spec.parent)
  if not parent then return nil end

  local button = ToggleButtons.GetButton(key)
  local isNew = false
  if not button then
    button = CreateFrame("Button", nil, parent, spec.template or "UIPanelButtonTemplate")
    isNew = true
  end

  ToggleButtons.registry[key] = button
  if spec.globalName then
    rawset(_G, spec.globalName, button)
  end

  ToggleButtons.Refresh(key)
  if isNew then
    button:SetText(ToggleButtons.GetPlaceholderText(key))
  end

  return button
end

function ToggleButtons.Configure(key, overrides)
  local spec = ToggleButtonsGetSpec(key)
  if not (spec and type(overrides) == "table") then return nil end

  for name, value in pairs(overrides) do
    spec[name] = value
  end

  return ToggleButtons.Refresh(key)
end

function ToggleButtons.SetWidth(key, width)
  local spec = ToggleButtonsGetSpec(key)
  width = tonumber(width)
  if not (spec and width and width > 0) then return nil end

  spec.width = width
  local button = ToggleButtons.GetButton(key)
  if button then
    button:SetWidth(width)
  end
  return width
end

function ToggleButtons.SetHeight(key, height)
  local spec = ToggleButtonsGetSpec(key)
  height = tonumber(height)
  if not (spec and height and height > 0) then return nil end

  spec.height = height
  local button = ToggleButtons.GetButton(key)
  if button then
    button:SetHeight(height)
  end
  return height
end

function ToggleButtons.SetSize(key, width, height)
  if width ~= nil then
    ToggleButtons.SetWidth(key, width)
  end
  if height ~= nil then
    ToggleButtons.SetHeight(key, height)
  end
  return ToggleButtons.GetButton(key)
end

function ToggleButtons.SetWidths(widths)
  if type(widths) ~= "table" then return end
  for key, width in pairs(widths) do
    ToggleButtons.SetWidth(key, width)
  end
end

function ToggleButtons.SetSizes(sizes)
  if type(sizes) ~= "table" then return end
  for key, value in pairs(sizes) do
    if type(value) == "table" then
      ToggleButtons.SetSize(key, value.width, value.height)
    end
  end
end

function ToggleButtons.SetPosition(key, point, relativePoint, x, y, relativeTo)
  local spec = ToggleButtonsGetSpec(key)
  if not spec then return nil end

  if type(point) == "table" then
    spec.point = {
      point[1],
      point[2],
      point[3] or 0,
      point[4] or 0,
    }
    if point[5] ~= nil then
      spec.relativeTo = point[5]
    elseif relativeTo ~= nil then
      spec.relativeTo = relativeTo
    end
  else
    spec.point = {
      point,
      relativePoint,
      x or 0,
      y or 0,
    }
    if relativeTo ~= nil then
      spec.relativeTo = relativeTo
    end
  end

  local button = ToggleButtons.GetButton(key)
  if button then
    ToggleButtons.ApplyAnchor(key, button)
  end
  return spec.point
end

function ToggleButtons.SetPositions(positions)
  if type(positions) ~= "table" then return end
  for key, value in pairs(positions) do
    if type(value) == "table" then
      ToggleButtons.SetPosition(key, value)
    end
  end
end

function ToggleButtons.SetLabel(key, questID, modeTag)
  local button = ToggleButtons.GetButton(key)
  if not button then return nil end
  local text = ToggleButtons.BuildQuestText(key, questID, modeTag)
  button:SetText(text)
  return text
end

function ToggleButtons.SyncLabels(questID, modeTag, keys)
  local list = keys or ToggleButtons.order
  for _, key in ipairs(list) do
    ToggleButtons.SetLabel(key, questID, modeTag)
  end
end

function ToggleButtons.SetEnabled(key, enabled)
  local button = ToggleButtons.GetButton(key)
  if not button then return end
  if enabled then
    button:Enable()
  else
    button:Disable()
  end
end

function ToggleButtons.SyncEnabled(enabled, keys)
  local list = keys or ToggleButtons.order
  for _, key in ipairs(list) do
    ToggleButtons.SetEnabled(key, enabled)
  end
end

function ToggleButtons.BindOnClick(key, onClick)
  local spec = ToggleButtonsGetSpec(key)
  if not (spec and type(onClick) == "function") then return end
  spec.onClick = onClick
  local button = ToggleButtons.GetButton(key)
  if button then
    button:SetScript("OnClick", onClick)
  end
end

-- Bronze Timekeeper number formatting and placeholder substitution ($1..$6)
function Quests.Utils.FormatBronzeTimekeeper(sourceText, messageText)
   local src = strtrim(sourceText or "")
   local msg = messageText or ""
   local wartab = {0,0,0,0,0,0}
   local arg0 = 0
   for w in string.gmatch(src, "%d+") do
      arg0 = arg0 + 1
      local num = tonumber(w) or 0
      if (num>999999) then
         wartab[arg0] = tostring(math.floor(num)):reverse():gsub("(%d%d%d)(%d%d%d)", "%1.%2."):gsub("(%-?)$", "%1"):reverse()
      elseif (num>99999) then
         wartab[arg0] = tostring(math.floor(num)):reverse():gsub("(%d%d%d)(%d%d%d)", "%1.%2"):gsub("(%-?)$", "%1"):reverse()
      elseif (num>999) then
         wartab[arg0] = tostring(math.floor(num)):reverse():gsub("(%d%d%d)", "%1."):gsub("(%-?)$", "%1"):reverse()
      else
         wartab[arg0] = w
      end
      if arg0>=6 then break end
   end
   if (arg0>5 and wartab[6]) then msg = string.gsub(msg, "$6", wartab[6]) end
   if (arg0>4 and wartab[5]) then msg = string.gsub(msg, "$5", wartab[5]) end
   if (arg0>3 and wartab[4]) then msg = string.gsub(msg, "$4", wartab[4]) end
   if (arg0>2 and wartab[3]) then msg = string.gsub(msg, "$3", wartab[3]) end
   if (arg0>1 and wartab[2]) then msg = string.gsub(msg, "$2", wartab[2]) end
   if (arg0>0 and wartab[1]) then msg = string.gsub(msg, "$1", wartab[1]) end
   return msg
end
