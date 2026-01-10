local addonName, ns = ...

ns.Bubbles = ns.Bubbles or {}
local Bubbles = ns.Bubbles
local S = Bubbles.State

function Bubbles.DetectAndReplacePlayerNameForBubble(txt, target, part)
  if (txt == nil) then return "" end
  local text = string.gsub(txt, '\r', "")
  if (part == nil) or (part == '$B') then
    text = string.gsub(text, '\n', "$B")
  end
  return text
end

local function ensureMeasureFontString()
  if S and S.measureFontString then
    return S.measureFontString
  end

  local frame = CreateFrame("Frame", nil, UIParent)
  frame:Hide()
  local fs = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fs:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
  fs:SetJustifyH("LEFT")
  fs:SetJustifyV("TOP")

  if S then
    S.measureFrame = frame
    S.measureFontString = fs
  else
    -- Fallback if State isn't available for some reason
    Bubbles._measureFrame = frame
    Bubbles._measureFontString = fs
  end
  return fs
end

local function clamp(n, minVal, maxVal)
  if maxVal and n > maxVal then n = maxVal end
  if minVal and n < minVal then n = minVal end
  return n
end

-- Measure the widest line (in pixels) of a given text when rendered with the provided font.
-- Uses a hidden FontString to get the actual rendered width (including textures/icons, excluding color codes).
function Bubbles.MeasureMaxLineWidth(text, fontFile, fontSize, fontFlags)
  local fs = (S and S.measureFontString) or Bubbles._measureFontString
  if not fs then fs = ensureMeasureFontString() end

  if fs.SetFont and fontFile and fontSize then
    pcall(fs.SetFont, fs, fontFile, fontSize, fontFlags)
  end

  -- Make it effectively "unbounded" so we measure the real line width.
  if fs.SetWidth then fs:SetWidth(2000) end

  local s = text or ""
  local maxWidth = 0
  for line in (s .. "\n"):gmatch("(.-)\n") do
    fs:SetText(line)
    local w = 0
    if fs.GetUnboundedStringWidth then
      w = fs:GetUnboundedStringWidth() or 0
    elseif fs.GetStringWidth then
      w = fs:GetStringWidth() or 0
    end
    if w > maxWidth then maxWidth = w end
  end
  return maxWidth
end

-- Compute a good bubble width for translated NPC chat bubbles.
-- We only EXPAND bubbles (never shrink) and clamp to a sensible maximum.
function Bubbles.ComputeIdealBubbleWidth(region, translatedText, minWidth, maxWidth)
  if not region or not region.GetFont or not region.GetWidth then
    return minWidth or 100
  end

  local fontFile, fontSize, fontFlags = region:GetFont()
  local baseWidth = region:GetWidth() or 0

  local displayText = translatedText or ""
  if type(_G.QTR_ReverseIfAR) == "function" then
    -- Reverse for display in AR locale (content-aware); keeps measurement aligned with what the user sees.
    displayText = QTR_ReverseIfAR(displayText)
  end

  local widest = Bubbles.MeasureMaxLineWidth(displayText, fontFile, fontSize, fontFlags)
  local padding = 20 -- allow some inner bubble padding so text isn't flush

  local desired = widest + padding
  desired = math.max(desired, minWidth or 100, baseWidth)
  desired = clamp(desired, nil, maxWidth)
  return desired
end


