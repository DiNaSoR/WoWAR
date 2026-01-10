-- Config UI helper functions
-------------------------------------------------------------------------------------------------------

function CreateToggleButton(parentFrame, settingsTable, settingKey, onText, offText, point, onClick)
   local buttonOFF = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")
   local buttonON = CreateFrame("Button", nil, parentFrame, "UIPanelButtonTemplate")

   local function SetupButton(button, text)
      button:SetSize(120, 22)
      if (WoWTR_Localization and WoWTR_Localization.lang == 'AR' and text == (WoWTR_Localization.WoWTR_trDESC or text)) then
         button:SetText(QTR_ReverseIfAR(text))
         button:GetFontString():SetFont(WOWTR_Font2, 13)
      else
         button:SetText(text)
         local font, size = button:GetFontString():GetFont()
         button:GetFontString():SetFont(font, 13)
      end
      button:SetPoint(unpack(point))
      button:SetFrameStrata("TOOLTIP")
   end

   SetupButton(buttonOFF, offText)
   SetupButton(buttonON, onText)

   local function UpdateVisibility()
      if settingsTable[settingKey] == "1" then
         buttonOFF:Show(); buttonON:Hide()
      else
         buttonOFF:Hide(); buttonON:Show()
      end
   end

   buttonOFF:SetScript("OnClick", function()
      settingsTable[settingKey] = "0"
      UpdateVisibility()
      if onClick then onClick() end
   end)

   buttonON:SetScript("OnClick", function()
      settingsTable[settingKey] = "1"
      UpdateVisibility()
      if onClick then onClick() end
   end)

   UpdateVisibility()
   return UpdateVisibility
end




-- Lightweight label helper for Ace3 options
-- Uses WoWTR_Config_Interface key when present (and reverses only then),
-- otherwise returns the provided English fallback without reversal.
WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
function WOWTR.Config.Label(key, fallback)
  local v = (WoWTR_Config_Interface and WoWTR_Config_Interface[key]) or nil
  if v and v ~= "" then
    local rev = _G.QTR_ReverseIfAR
    if type(rev) == "function" then
      return rev(v)
    end
    -- Load-order safety: `QTR_ReverseIfAR` is defined later in `common/Text.lua`.
    -- Return raw localized text rather than hard-crashing during early file loads.
    return v
  end
  return fallback
end

-- Return localized text without RTL reversal (used when the caller handles reversing).
function WOWTR.Config.LabelRaw(key, fallback)
  local v = (WoWTR_Config_Interface and WoWTR_Config_Interface[key]) or nil
  if v and v ~= "" then
    return v
  end
  return fallback
end

-- Factory for Ace3 config tabs that bind directly to WOWTR.db.profile.<profileSection>.
-- Reduces duplicated get/set + SyncGlobalsFromDB/NotifyChange boilerplate across tabs.
function WOWTR.Config.MakeTab(profileSection, spec)
  spec = spec or {}
  local group = {
    type = "group",
    order = spec.order,
    name = spec.name,
    args = spec.args or {},
  }

  if spec.hidden ~= nil then group.hidden = spec.hidden end
  if spec.disabled ~= nil then group.disabled = spec.disabled end

  group.get = spec.get or function(info)
    local key = info[#info]
    return WOWTR.db.profile[profileSection][key]
  end

  group.set = spec.set or function(info, val)
    local key = info[#info]
    WOWTR.db.profile[profileSection][key] = val
    WOWTR.Config.SyncGlobalsFromDB()
    if spec.afterSet then
      spec.afterSet(key, val, info)
    end
    WOWTR.Config.NotifyChange()
  end

  return group
end
