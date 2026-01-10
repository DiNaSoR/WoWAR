local addonName, ns = ...

ns = ns or {}
ns.Tooltips = ns.Tooltips or {}
local Tooltips = ns.Tooltips

-- Centralized runtime state for tooltips and UI caches.
-- Mirrors legacy globals to avoid breaking existing code paths.

Tooltips.State = Tooltips.State or {}
local S = Tooltips.State

-- Expose and align legacy caches used across UI modules
ST_OriginalTextCache = ST_OriginalTextCache or {}
ST_OriginalFontCache = ST_OriginalFontCache or {}
ST_OriginalJustifyCache = ST_OriginalJustifyCache or {}

S.originalTextCache = ST_OriginalTextCache
S.originalFontCache = ST_OriginalFontCache
S.originalJustifyCache = ST_OriginalJustifyCache

-- Module-level state variables (migrated from WoW_Tooltips.lua locals)
S.miasto = ""
S.gameGossipShow = false
S.width2 = math.floor(UIParent:GetWidth() / 2 + 0.5)
S.height2 = math.floor(UIParent:GetHeight() / 2 + 0.5)
S.lastNumLines = 0
S.load1 = false
S.load2 = false
S.load4 = false
S.load5 = false
S.load6 = false
S.load7 = false
S.load8 = false
S.load9 = false
S.load10 = false
S.firstBoss = true
S.nameBoss = {}
S.navBar1, S.navBar2, S.navBar3, S.navBar4, S.navBar5 = false, false, false, false, false

-- Expose globals for back-compat
ST_lastNumLines = 0
ST_load1 = false
ST_load2 = false
ST_load4 = false
ST_load5 = false
ST_load6 = false
ST_load7 = false
ST_load8 = false
ST_load9 = false
ST_load10 = false
ST_firstBoss = true
ST_nameBoss = {}
ST_navBar1, ST_navBar2, ST_navBar3, ST_navBar4, ST_navBar5 = false, false, false, false, false
ST_miasto = ""

-- Settings accessors (AceDB profile via Config mirrors to TT_PS/ST_PM)
local function s2b(v)
  if v == true then return true end
  if v == false then return false end
  return tostring(v) == "1"
end

function S:GetTT()
  -- TT_PS is mirrored from WOWTR.db.profile.tooltips by common/Config/Core.lua
  TT_PS = TT_PS or {}
  return TT_PS
end

function S:GetST()
  -- ST_PM is mirrored from WOWTR.db.profile.tooltips by common/Config/Core.lua
  ST_PM = ST_PM or {}
  return ST_PM
end

function S:IsActive()
  local st = self:GetST()
  return s2b(st["active"]) or false
end

function S:IsUIEnabled(key)
  local tt = self:GetTT()
  if not key then return false end
  return s2b(tt[key]) or false
end

-- Simple wait helper passthrough (if available)
function S:Wait(delay, fn)
  if _G.WOWTR_wait then return WOWTR_wait(delay, fn) end
  if C_Timer and C_Timer.After and type(fn) == "function" then
    C_Timer.After(delay, fn)
    return true
  end
  return false
end

-- Create ST_MyGameTooltip frame for buff/debuff translation display
if ((GetLocale() == "enUS") or (GetLocale() == "enGB")) then
  ST_MyGameTooltip = CreateFrame("GameTooltip", "ST_MyGameTooltip", UIParent, "GameTooltipTemplate")
  ST_MyGameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
  S.myGameTooltip = ST_MyGameTooltip
end

-- Version display frame (migrated from WoW_Tooltips.lua)
local firstloginframe = CreateFrame("Frame", nil, UIParent)
firstloginframe:SetSize(100, 50)
firstloginframe:SetPoint("BOTTOMLEFT", 12, 5)
local addonlogintext = firstloginframe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addonlogintext:SetPoint("LEFT")
addonlogintext:SetText(WoWTR_Localization and WoWTR_Localization.addonName or "WoWTR")
addonlogintext:SetTextColor(1, 1, 1, 0.1)
addonlogintext:SetFont(WOWTR_Font1, 20)
local addonlogintext2 = firstloginframe:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addonlogintext2:SetPoint("LEFT", 0, -15)
addonlogintext2:SetText("ver. " .. (WOWTR_version or "11.x"))
addonlogintext2:SetTextColor(1, 1, 1, 0.1)
addonlogintext2:SetFont(WOWTR_Font2, 15)
local function OnLogin()
  firstloginframe:Show()
  C_Timer.After(15, function() firstloginframe:Hide() end)
end
firstloginframe:RegisterEvent("PLAYER_LOGIN")
firstloginframe:SetScript("OnEvent", OnLogin)
S.loginFrame = firstloginframe

return S


