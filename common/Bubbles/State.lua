local addonName, ns = ...

ns.Bubbles = ns.Bubbles or {}
local Bubbles = ns.Bubbles

Bubbles.State = Bubbles.State or {}
local S = Bubbles.State

-- Runtime state used by bubble processing
S.ctrFrame = CreateFrame("FRAME", "WOWTR-BubblesFrame")
S.bubblesQueue = {}
S.trVisible = 0
S.latchCount = 0
S.latchNameNPC = ""
S.latchHashCode = ""
S.buffer = {}
S.ready = {}
S.readyCount = 0

local function ensureDungeonTooltips()
  if WOWBB1 then return end
  WOWBB1 = CreateFrame("GameTooltip", "WOWBB1", UIParent, "GameTooltipTemplate")
  WOWBB1:SetOwner(UIParent, "ANCHOR_NONE")
  WOWBB1:SetWidth(250)
  WOWBB1:SetHeight(100)
  WOWBB1.header = WOWBB1:CreateFontString(nil, "OVERLAY", "GameFontWhite")
  WOWBB1.header:SetWidth(200)
  WOWBB1.vertical = 270

  WOWBB2 = CreateFrame("GameTooltip", "WOWBB2", UIParent, "GameTooltipTemplate")
  WOWBB2:SetOwner(UIParent, "ANCHOR_NONE")
  WOWBB2:SetWidth(250)
  WOWBB2:SetHeight(100)
  WOWBB2.header = WOWBB2:CreateFontString(nil, "OVERLAY", "GameFontWhite")
  WOWBB2.header:SetWidth(200)
  WOWBB2.vertical = 270

  WOWBB3 = CreateFrame("GameTooltip", "WOWBB3", UIParent, "GameTooltipTemplate")
  WOWBB3:SetOwner(UIParent, "ANCHOR_NONE")
  WOWBB3:SetWidth(250)
  WOWBB3:SetHeight(100)
  WOWBB3.header = WOWBB3:CreateFontString(nil, "OVERLAY", "GameFontWhite")
  WOWBB3.header:SetWidth(200)
  WOWBB3.vertical = 270

  WOWBB4 = CreateFrame("GameTooltip", "WOWBB4", UIParent, "GameTooltipTemplate")
  WOWBB4:SetOwner(UIParent, "ANCHOR_NONE")
  WOWBB4:SetWidth(250)
  WOWBB4:SetHeight(100)
  WOWBB4.header = WOWBB4:CreateFontString(nil, "OVERLAY", "GameFontWhite")
  WOWBB4.header:SetWidth(200)
  WOWBB4.vertical = 270

  WOWBB5 = CreateFrame("GameTooltip", "WOWBB5", UIParent, "GameTooltipTemplate")
  WOWBB5:SetOwner(UIParent, "ANCHOR_NONE")
  WOWBB5:SetWidth(250)
  WOWBB5:SetHeight(100)
  WOWBB5.header = WOWBB5:CreateFontString(nil, "OVERLAY", "GameFontWhite")
  WOWBB5.header:SetWidth(200)
  WOWBB5.vertical = 270
end

ensureDungeonTooltips()


