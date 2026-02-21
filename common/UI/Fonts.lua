-- common/UI/Fonts.lua
-- Centralized font handling (Arabic) for config UI, minimap menus, and Blizzard options lists
-------------------------------------------------------------------------------------------------------

WOWTR = WOWTR or {}
WOWTR.Fonts = WOWTR.Fonts or {}
local F = WOWTR.Fonts

local WOWTR_AceNormalFO, WOWTR_AceHighlightFO

function F.IsArabic()
  return (WOWTR_Localization and WOWTR_Localization.lang == "AR" and WOWTR_Font2) and true or false
end

function F.EnsureFontObjects()
  if not F.IsArabic() then return end
  if not WOWTR_AceNormalFO then
    WOWTR_AceNormalFO = CreateFont("WOWTR_AceNormal")
    WOWTR_AceNormalFO:SetFont(WOWTR_Font2, 13, "")
  end
  if not WOWTR_AceHighlightFO then
    WOWTR_AceHighlightFO = CreateFont("WOWTR_AceHighlight")
    WOWTR_AceHighlightFO:SetFont(WOWTR_Font2, 13, "")
  end
end

-- Apply Arabic font recursively to frames/regions created by AceConfig/AceGUI or Blizzard panels.
function F.Apply(obj)
  if not obj or not F.IsArabic() then return end
  F.EnsureFontObjects()

  local function setFontOnRegion(region)
    if not region or not region.SetFont then return end
    local ok, _, size, flags = pcall(region.GetFont, region)
    if not ok or not size then size = 13 end
    local f = type(flags) == "string" and flags or ""
    pcall(region.SetFont, region, WOWTR_Font2, size, f)
  end

  local function applyFontsRecursive(node)
    if not node then return end

    local objType = node.GetObjectType and node:GetObjectType() or nil
    if objType == "FontString" or objType == "EditBox" then
      setFontOnRegion(node)
    end

    if node.GetFontString then
      local fs = node:GetFontString()
      if fs then setFontOnRegion(fs) end
    end

    -- AceGUI widget internals commonly keep FontStrings on node.obj
    if node.obj then
      local w = node.obj
      local okText, textRegion = pcall(function() return rawget(w, "text") end)
      if okText and type(textRegion) == "table" and textRegion.SetFont then setFontOnRegion(textRegion) end
      local okLabel, labelRegion = pcall(function() return rawget(w, "label") end)
      if okLabel and type(labelRegion) == "table" and labelRegion.SetFont then setFontOnRegion(labelRegion) end
      local okDesc, descRegion = pcall(function() return rawget(w, "desc") end)
      if okDesc and type(descRegion) == "table" and descRegion.SetFont then setFontOnRegion(descRegion) end

      -- Only apply these font objects to AceGUI-owned button frames (avoid changing arbitrary Blizzard UI buttons)
      if node.SetNormalFontObject and WOWTR_AceNormalFO then
        pcall(node.SetNormalFontObject, node, WOWTR_AceNormalFO)
      end
      if node.SetHighlightFontObject and WOWTR_AceHighlightFO then
        pcall(node.SetHighlightFontObject, node, WOWTR_AceHighlightFO)
      end
      if node.SetDisabledFontObject and WOWTR_AceNormalFO then
        pcall(node.SetDisabledFontObject, node, WOWTR_AceNormalFO)
      end
    end

    if node.GetRegions then
      local regions = { node:GetRegions() }
      for _, r in pairs(regions) do
        if r and r.GetObjectType and r:GetObjectType() == "FontString" then
          setFontOnRegion(r)
        end
      end
    end

    if node.GetChildren then
      local children = { node:GetChildren() }
      for _, c in pairs(children) do
        applyFontsRecursive(c)
      end
    end
  end

  applyFontsRecursive(obj)
end

-- Hook AceConfigDialog to apply fonts both on initial open and on rebuilds (tab/tree switching).
local AceConfigDialogHooked = false
function F.HookAceConfigDialog(appName)
  if AceConfigDialogHooked then return end
  local AceConfigDialog = LibStub("AceConfigDialog-3.0", true)
  if not AceConfigDialog then return end

  appName = appName or "WOWTR"

  local function AfterOpen(self, app, container, ...)
    if app ~= appName or not F.IsArabic() then return end
    -- Blizzard Options uses a BlizOptionsGroup container and does not populate OpenFrames.
    local frameRef
    if type(container) == "table" and container.frame then
      frameRef = container.frame
    elseif self.OpenFrames and self.OpenFrames[app] and self.OpenFrames[app].frame then
      frameRef = self.OpenFrames[app].frame
    end
    if frameRef then F.Apply(frameRef) end
  end

  local function AfterFeedGroup(self, app, options, container, rootframe, path, isRoot)
    if app ~= appName or not F.IsArabic() then return end
    local frameRef = (rootframe and rootframe.frame) or (container and container.frame) or nil
    if frameRef then F.Apply(frameRef) end
  end

  if hooksecurefunc then
    if type(AceConfigDialog.Open) == "function" then
      hooksecurefunc(AceConfigDialog, "Open", AfterOpen)
    end
    if type(AceConfigDialog.FeedGroup) == "function" then
      hooksecurefunc(AceConfigDialog, "FeedGroup", AfterFeedGroup)
    end
  else
    -- Fallback for environments without hooksecurefunc (unlikely in WoW)
    if type(AceConfigDialog.Open) == "function" then
      local origOpen = AceConfigDialog.Open
      AceConfigDialog.Open = function(self, app, container, ...)
        local ret = origOpen(self, app, container, ...)
        pcall(AfterOpen, self, app, container, ...)
        return ret
      end
    end
    if type(AceConfigDialog.FeedGroup) == "function" then
      local origFeedGroup = AceConfigDialog.FeedGroup
      AceConfigDialog.FeedGroup = function(self, app, options, container, rootframe, path, isRoot)
        local ret = origFeedGroup(self, app, options, container, rootframe, path, isRoot)
        pcall(AfterFeedGroup, self, app, options, container, rootframe, path, isRoot)
        return ret
      end
    end
  end

  AceConfigDialogHooked = true
end

-- Hook Blizzard Options -> AddOns list/panel so Arabic addon names render correctly.
local AddOnsPanelHooked = false
function F.HookBlizzardAddOnsList()
  if AddOnsPanelHooked then return end
  AddOnsPanelHooked = true

  local function ApplyIfArabic(frame)
    if frame and F.IsArabic() then
      F.Apply(frame)
    end
  end

  -- Classic-era Options/AddOns frame
  local f = _G.InterfaceOptionsFrameAddOns
  if f and f.HookScript then
    f:HookScript("OnShow", function(self) ApplyIfArabic(self) end)
    if f.IsShown and f:IsShown() then ApplyIfArabic(f) end
  end
end

-- Apply Arabic fonts to Blizzard dropdown menu lists (used by EasyMenu/UIDropDownMenu).
local DropdownHooked = false
function F.HookDropdownLists()
  if DropdownHooked then return end
  DropdownHooked = true

  local function applyIfOwned()
    if not F.IsArabic() then return end
    for i = 1, 3 do
      local list = _G["DropDownList" .. i]
      if list and list:IsShown() then
        F.Apply(list)
      end
    end
  end

  -- Ensure dropdown list frames exist so we can hook them before the first open.
  if not _G.DropDownList1 and _G.UIDropDownMenu_CreateFrames then
    pcall(_G.UIDropDownMenu_CreateFrames, 3, 0)
  end

  for i = 1, 3 do
    local list = _G["DropDownList" .. i]
    if list and list.HookScript then
      list:HookScript("OnShow", applyIfOwned)
    end
  end
end


