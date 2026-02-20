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
