local addonName, ns = ...

ns.Tutorials = ns.Tutorials or {}
local Tutorials = ns.Tutorials
Tutorials.Utils = Tutorials.Utils or {}
local U = Tutorials.Utils

function U.isTranslated(text)
  return text and string.find(text, NONBREAKINGSPACE) ~= nil
end

function U.translateIfAvailable(objFontString, originalText, hash, offset)
  if not objFontString or not originalText or originalText == "" then return false end
  if U.isTranslated(originalText) then return false end
  local translated = _G["Tut_Data7"] and _G["Tut_Data7"][hash]
  if translated then
    local _, size, flags = objFontString:GetFont()
    if (WoWTR_Localization and WoWTR_Localization.lang == 'AR') and offset then
      objFontString:SetText(QTR_ExpandUnitInfo(translated, false, objFontString, WOWTR_Font2, offset) .. NONBREAKINGSPACE)
    else
      objFontString:SetText(QTR_ReverseIfAR(WOW_ZmienKody(translated)) .. NONBREAKINGSPACE)
    end
    objFontString:SetFont(WOWTR_Font2, size, flags)
    return true
  end
  return false
end
