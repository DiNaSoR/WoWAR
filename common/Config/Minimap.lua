-- Minimap button setup using Ace/LDB
-------------------------------------------------------------------------------------------------------

local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)

if LDB and LDBIcon then
  local dropdownFrame
  local function EnsureDropdown()
    if dropdownFrame then return dropdownFrame end
    dropdownFrame = CreateFrame("Frame", "WOWTR_MinimapDropdown", UIParent, "UIDropDownMenuTemplate")
    dropdownFrame.displayMode = "MENU"
    return dropdownFrame
  end

  local function ToggleMinimapIcon(show)
    if not (WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.minimap) then return end
    WOWTR.db.profile.minimap.hide = not show
    if WOWTR.Config and WOWTR.Config.SyncGlobalsFromDB then
      WOWTR.Config.SyncGlobalsFromDB()
    end
    local iconLib = LibStub("LibDBIcon-1.0", true)
    if iconLib then
      if WOWTR.db.profile.minimap.hide then iconLib:Hide("WOWTR_LDB") else iconLib:Show("WOWTR_LDB") end
    end
    if WOWTR.Config and WOWTR.Config.NotifyChange then
      WOWTR.Config.NotifyChange()
    end
  end

  local function OpenConfig()
    if WOWTR and WOWTR.Config and WOWTR.Config.Open then
      WOWTR.Config.Open()
    end
  end

  local function OpenMinimapMenu(ownerButton)
    local menu = {
      { text = QTR_ReverseIfAR((WoWTR_Localization and WoWTR_Localization.optionTitle) or "WoWLang"), isTitle = true, notCheckable = true },
      { text = QTR_ReverseIfAR("Open"), notCheckable = true, func = OpenConfig },
      {
        text = WOWTR.Config and WOWTR.Config.Label and WOWTR.Config.Label("showMinimapIcon", "Show minimap icon") or QTR_ReverseIfAR("Show minimap icon"),
        keepShownOnClick = true,
        checked = function() return WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.minimap and (not WOWTR.db.profile.minimap.hide) end,
        func = function()
          local shown = WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.minimap and (not WOWTR.db.profile.minimap.hide)
          ToggleMinimapIcon(not shown)
        end,
      },
      { text = CLOSE or QTR_ReverseIfAR("Close"), notCheckable = true },
    }

    local dd = EnsureDropdown()
    if WOWTR and WOWTR.Fonts and WOWTR.Fonts.HookDropdownLists then
      WOWTR.Fonts.HookDropdownLists()
    end
    if EasyMenu then
      EasyMenu(menu, dd, "cursor", 0, 0, "MENU", 2)
    elseif ToggleDropDownMenu then
      UIDropDownMenu_Initialize(dd, function(self, level)
        for _, item in ipairs(menu) do
          UIDropDownMenu_AddButton(item, level)
        end
      end, "MENU")
      ToggleDropDownMenu(1, nil, dd, "cursor", 0, 0)
    end
  end

  WOWTR_minimapButton = LDB:NewDataObject("WOWTR_LDB", {
    type = "data source",
    text = "WOWTR_LDB",
    icon = WoWTR_Localization.mainFolder .. "\\Images\\icon.png",
    OnClick = function(btn, mouseButton)
      if mouseButton == "RightButton" then
        OpenMinimapMenu(btn)
      else
        OpenConfig()
      end
    end,
    OnTooltipShow = function(tooltip)
      if (WoWTR_Localization.lang == 'AR') then
        tooltip:SetText("|cff8080ff" .. WOWTR_version .. "|r " .. QTR_ReverseIfAR(WoWTR_Localization.optionTitle));
      else
        tooltip:SetText(QTR_ReverseIfAR(WoWTR_Localization.optionTitle) .. " |cff8080ff" .. WOWTR_version .. "|r");
      end
      tooltip:AddLine("|cffffffff" .. QTR_ReverseIfAR(WoWTR_Localization.addonIconDesc) .. "|r");
      if WOWTR and WOWTR.Fonts and WOWTR.Fonts.Apply then
        WOWTR.Fonts.Apply(tooltip)
      end
      tooltip:Show();
    end,
  })

  -- Register icon using unified AceDB when available (set in Config/Main.lua)
  local function TryRegisterIcon()
    if WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.minimap then
      LDBIcon:Register("WOWTR_LDB", WOWTR_minimapButton, WOWTR.db.profile.minimap)
      if WOWTR.db.profile.minimap.hide then
        LDBIcon:Hide("WOWTR_LDB")
      else
        LDBIcon:Show("WOWTR_LDB")
      end
      return true
    end
    return false
  end

  -- Attempt now; if DB not ready yet, retry shortly after ADDON_LOADED
  if not TryRegisterIcon() then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if TryRegisterIcon() then
        self:UnregisterEvent("ADDON_LOADED")
      end
    end)
  end
end
