-- RTL.lua
-- Arabic/right-to-left alignment utilities isolated in a module.

local addonName, ns = ...
ns = ns or {}
ns.RTL = ns.RTL or {}
local RTL = ns.RTL

-- Return true if current language should use RTL layout
function RTL.IsRTL()
   return (type(WoWTR_Localization) == "table" and WoWTR_Localization.lang == 'AR') or false
end

-- Safely justify a FontString: RIGHT for RTL, otherwise defaultJustify (LEFT if omitted)
function RTL.JustifyFontString(fontString, defaultJustify)
   if not fontString or not fontString.SetJustifyH then return end
   if RTL.IsRTL() then
      fontString:SetJustifyH("RIGHT")
   else
      fontString:SetJustifyH(defaultJustify or "LEFT")
   end
end

-- Align a gossip/option button (icon + text) based on RTL state
-- Works with Blizzard frames that expose .Icon and a FontString region.
function RTL.ApplyOptionButtonLayout(buttonFrame)
   if not buttonFrame or not buttonFrame.GetRegions then return end

   local fontStringRegion
   local regions = { buttonFrame:GetRegions() }
   for _, region in pairs(regions) do
      if region and region.GetObjectType and region:GetObjectType() == "FontString" then
         fontStringRegion = region
         break
      end
   end
   if not fontStringRegion then return end

   local iconRegion = buttonFrame.Icon
   if RTL.IsRTL() then
      if iconRegion then
         iconRegion:ClearAllPoints()
         iconRegion:SetPoint("TOPRIGHT", buttonFrame, "TOPRIGHT", -10, -2)
         fontStringRegion:ClearAllPoints()
         fontStringRegion:SetPoint("TOPRIGHT", iconRegion, "TOPLEFT", -5, 0)
      else
         fontStringRegion:ClearAllPoints()
         fontStringRegion:SetPoint("TOPRIGHT", buttonFrame, "TOPRIGHT", -10, -2)
      end
      fontStringRegion:SetJustifyH("RIGHT")
   else
      local leftPadding = 10
      if iconRegion then
         iconRegion:ClearAllPoints()
         iconRegion:SetPoint("TOPLEFT", buttonFrame, "TOPLEFT", 5, -2)
         if iconRegion.GetWidth then
            leftPadding = iconRegion:GetWidth() + 10
         end
      end
      fontStringRegion:ClearAllPoints()
      fontStringRegion:SetPoint("TOPLEFT", buttonFrame, "TOPLEFT", leftPadding, -2)
      fontStringRegion:SetJustifyH("LEFT")
   end
end

