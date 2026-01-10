-- HookUtils.lua
-- Small helpers to reduce repetitive HookScript/StartTicker wiring.

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

-- Hook a frame script if possible.
function Core.HookScript(frame, script, handler)
  if not frame or type(frame.HookScript) ~= "function" then return end
  if type(handler) ~= "function" then return end
  frame:HookScript(script, handler)
end

-- Hook OnShow to start a Core ticker (or global StartTicker), matching legacy patterns.
function Core.HookOnShowTicker(frame, func, interval, tickerFrame)
  if not frame or type(frame.HookScript) ~= "function" then return end
  if type(func) ~= "function" or type(interval) ~= "number" then return end
  local tf = tickerFrame or frame
  frame:HookScript("OnShow", function()
    if Core.StartTicker then
      Core.StartTicker(tf, func, interval)
    elseif _G.StartTicker then
      StartTicker(tf, func, interval)
    end
  end)
end

-- Return a handler that runs only once (subsequent invocations are no-ops).
function Core.Once(fn)
  if type(fn) ~= "function" then
    return function() end
  end
  local ran = false
  return function(...)
    if ran then return end
    ran = true
    return fn(...)
  end
end

return Core


