local addonName, ns = ...

ns = ns or {}
ns.Tooltips = ns.Tooltips or {}
local Tooltips = ns.Tooltips

local State = Tooltips.State or {}

-- Public API table
Tooltips.API = Tooltips.API or {}

-- Initialize module (called on ADDON_LOADED or PLAYER_LOGIN)
function Tooltips.Init()
  -- Initialize original font cache early (before HookTooltipFonts runs)
  if Tooltips.Utils and Tooltips.Utils.InitializeOriginalFontCache then
    Tooltips.Utils.InitializeOriginalFontCache()
  end
  -- Reserved for future initialization steps when progressively migrating
  -- the logic out of common/WoW_Tooltips.lua into namespaced modules.
  return true
end

-- Open hook to (re)wire handlers; the real hooks live in Tooltips/Hooks.lua
function Tooltips.Enable()
  if Tooltips.Hooks and Tooltips.Hooks.Enable then
    Tooltips.Hooks.Enable()
  end
end

-- Thin back-compat attach: allow legacy globals to call into namespaced API
function Tooltips.AttachGlobals()
  -- GameTooltip handlers
  if Tooltips.GameTooltip then
    if Tooltips.GameTooltip.OnShow then
      _G.ST_GameTooltipOnShow = function(...) return Tooltips.GameTooltip.OnShow(...) end
    end
    if Tooltips.GameTooltip.BuffOrDebuff then
      _G.ST_BuffOrDebuff = function(...) return Tooltips.GameTooltip.BuffOrDebuff(...) end
    end
    if Tooltips.GameTooltip.CurrentEquipped then
      _G.ST_CurrentEquipped = function(...) return Tooltips.GameTooltip.CurrentEquipped(...) end
    end
    if Tooltips.GameTooltip.ElvSpellBookTooltipOnShow then
      _G.ST_ElvSpellBookTooltipOnShow = function(...) return Tooltips.GameTooltip.ElvSpellBookTooltipOnShow(...) end
    end
  end
end

-- Minimal event loader for this module
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
  Tooltips.Init()
  Tooltips.Enable()
  Tooltips.AttachGlobals()
end)

return Tooltips


