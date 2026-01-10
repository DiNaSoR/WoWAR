local addonName, ns = ...

ns.Movies = ns.Movies or {}
local Movies = ns.Movies
Movies.Utils = Movies.Utils or {}
local U = Movies.Utils

function U.findPercentS(text)
  if not text then return 0 end
  local length = string.len(text) - 1
  for i = 1, length, 1 do
    if (strsub(text, i, i + 1) == "%s") then
      return i
    end
  end
  return 0
end

function U.leftPad2(n)
  local s = tostring(n or 0)
  if (#s < 2) then return "0" .. s end
  return s
end

function U.applyFontToButtonFontStrings(button, font, size)
  if not button then return end
  local regions = { button:GetRegions() }
  for i = 1, #regions do
    local region = regions[i]
    if (region and region.GetObjectType and region:GetObjectType() == "FontString") then
      region:SetFont(font, size)
    end
  end
end
