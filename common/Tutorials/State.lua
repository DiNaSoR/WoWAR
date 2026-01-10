local addonName, ns = ...

ns.Tutorials = ns.Tutorials or {}
local Tutorials = ns.Tutorials
Tutorials.State = Tutorials.State or {}
local S = Tutorials.State

-- Runtime flags for script attachments
S.tutMainFrameShow = 0
S.tutWalkShow = 0
S.tutKeyboardMouseFrameShow = 0
S.tutSingleKeyShow = 0
S.firstUse = 0

-- Table of OnShow assignments for pointer frames (index 1..20)
S.assignedShow = {}
for i = 1, 20 do
  S.assignedShow[i] = 0
end
