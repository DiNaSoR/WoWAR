local addonName, ns = ...

ns.Bubbles = ns.Bubbles or {}
local Bubbles = ns.Bubbles
local S = Bubbles.State
local RTL = ns and ns.RTL
local Tutorials = ns and ns.Tutorials

S.trControls = S.trControls or {}
local function notifyTutorialSystem()
  if Tutorials and Tutorials.OnTutorialShow then
    Tutorials.OnTutorialShow()
  else
    local tt = rawget(_G, "TT_onTutorialShow")
    if tt then tt() end
  end
end


-- Utility: find position of '%s'
local function findPercentS(text)
  local length = string.len(text) - 1
  for i = 1, length, 1 do
    if (strsub(text, i, i + 1) == "%s") then
      return i
    end
  end
  return 0
end

function BB_FindProS(text) return findPercentS(text) end

local function setRegionFont(region)
  local _, size, flags = region:GetFont()
  region:SetFont(WOWTR_Font2, (BB_PM and BB_PM["setsize"] == "1") and tonumber(BB_PM["fontsize"]) or size, flags)
end

local function normalizeBubbleText(text)
  if text == nil then return "" end
  if WOWTR_DeleteSpecialCodes then
    return strtrim(WOWTR_DeleteSpecialCodes(text))
  end
  return strtrim(text)
end

local function applyBubbleTranslation(region, sourceText, translatedText)
  if not region or not region.GetText or not region.SetText then return false end
  if normalizeBubbleText(region:GetText()) ~= normalizeBubbleText(sourceText) then return false end
  setRegionFont(region)
  local minWidth = 100
  local uiWidth = (UIParent and UIParent.GetWidth) and UIParent:GetWidth() or 0
  local maxWidth = 420
  if uiWidth and uiWidth > 0 then
    -- keep bubbles readable but not absurdly wide on ultrawide screens
    maxWidth = math.min(450, math.max(250, uiWidth * 0.25))
  end

  if Bubbles and Bubbles.ComputeIdealBubbleWidth then
    local desiredWidth = Bubbles.ComputeIdealBubbleWidth(region, translatedText, minWidth, maxWidth)
    if region.SetWidth then region:SetWidth(desiredWidth) end
  else
    -- Fallback to old behavior
    region:SetWidth(math.max(region:GetWidth(), minWidth))
  end

  local widthNow = (region.GetWidth and region:GetWidth()) or 0
  if widthNow > 200 then
    region:SetText(QTR_ExpandUnitInfo(translatedText, false, region, WOWTR_Font2, -50))
  else
    region:SetText(QTR_ReverseIfAR(translatedText))
  end
  if region.SetJustifyH then region:SetJustifyH("CENTER") end
  return true
end

local function processVisibleBubbles()
  if (not S or #S.bubblesQueue == 0) then return end
  local bubbles = (C_ChatBubbles and C_ChatBubbles.GetAllChatBubbles and C_ChatBubbles.GetAllChatBubbles(true)) or {}
  if (#bubbles == 0) and C_ChatBubbles and C_ChatBubbles.GetAllChatBubbles then
    bubbles = C_ChatBubbles.GetAllChatBubbles()
  end
  for _, bubble in pairs(bubbles) do
    -- Validate bubble is a valid frame before calling methods on it
    if bubble and not bubble:IsForbidden() and bubble.GetNumChildren and bubble.GetChildren then
      local numChildren = bubble:GetNumChildren()
      for i = 1, numChildren do
        local child = select(i, bubble:GetChildren())
        if child and not child:IsForbidden() and child.GetObjectType and child:GetObjectType() == "Frame" then
          for r = 1, child:GetNumRegions() do
            local region = select(r, child:GetRegions())
            if region and region.IsVisible and region:IsVisible() and region.GetText and region.GetObjectType and region:GetObjectType() == "FontString" then
              for idx = #S.bubblesQueue, 1, -1 do
                local item = S.bubblesQueue[idx]
                local applied = applyBubbleTranslation(region, item[1], item[2])
                if applied then
                  table.remove(S.bubblesQueue, idx)
                end
              end
            end
          end
        end
      end
    end
  end
end

local function showDungeonTooltip(targetTooltip, xOffset, text, header)
  targetTooltip:SetOwner(UIParent, "ANCHOR_NONE")
  targetTooltip:ClearAllPoints()
  targetTooltip:SetPoint("CENTER", xOffset, targetTooltip.vertical)
  targetTooltip:ClearLines()
  targetTooltip:AddLine(QTR_ExpandUnitInfo(text, false, targetTooltip, WOWTR_Font2), 1, 1, 1, true)
  local fs = _G[targetTooltip:GetName() .. "TextLeft1"]
  if fs then fs:SetFont(WOWTR_Font2, (BB_PM and BB_PM["setsize"] == "1") and tonumber(BB_PM["fontsize"]) or 13) end
  targetTooltip:Show()
  if (RTL and RTL.IsRTL and RTL.IsRTL()) and fs then
    fs:SetText(QTR_ExpandUnitInfo(text, false, fs, WOWTR_Font2))
  end
  targetTooltip.header:SetText(header .. ":")
  targetTooltip.header:ClearAllPoints()
  targetTooltip.header:SetPoint("CENTER", 0, targetTooltip:GetHeight() / 2 + 6)
  C_Timer.After(tonumber(BB_PM and BB_PM["timeDisplay"] or 5), function() targetTooltip:Hide() end)
end

local function processDungeonBubbles()
  if (not BB_PM or BB_PM["dungeon"] ~= "1") then return end
  for idx = #S.bubblesQueue, 1, -1 do
    local item = S.bubblesQueue[idx]
    if not WOWBB1:IsVisible() then
      showDungeonTooltip(WOWBB1, 0, item[2], item[4])
    elseif not WOWBB2:IsVisible() then
      showDungeonTooltip(WOWBB2, 250, item[2], item[4])
    elseif not WOWBB3:IsVisible() then
      showDungeonTooltip(WOWBB3, -250, item[2], item[4])
    elseif not WOWBB4:IsVisible() then
      showDungeonTooltip(WOWBB4, 500, item[2], item[4])
    elseif not WOWBB5:IsVisible() then
      showDungeonTooltip(WOWBB5, -500, item[2], item[4])
    end
    table.remove(S.bubblesQueue, idx)
  end
end

local function processTalkingHead()
  if (TalkingHeadFrame and TalkingHeadFrame:IsVisible()) then
    for idx = #S.bubblesQueue, 1, -1 do
      local item = S.bubblesQueue[idx]
      if (normalizeBubbleText(TalkingHeadFrame.TextFrame.Text:GetText()) == normalizeBubbleText(item[1])) then
        local _, sz, fl = TalkingHeadFrame.TextFrame.Text:GetFont()
        TalkingHeadFrame.TextFrame.Text:SetFont(WOWTR_Font2, sz, fl)
        TalkingHeadFrame.TextFrame.Text:SetText(QTR_ExpandUnitInfo(item[2], false, TalkingHeadFrame.TextFrame.Text, WOWTR_Font2, -15))
        table.remove(S.bubblesQueue, idx)
      end
    end
  end
end

local function garbageCollectQueue()
  for idx = #S.bubblesQueue, 1, -1 do
    if (S.bubblesQueue[idx][3] >= 600) then
      table.remove(S.bubblesQueue, idx)
    else
      S.bubblesQueue[idx][3] = S.bubblesQueue[idx][3] + 1
    end
  end
end

function Bubbles.OnUpdate()
  processVisibleBubbles()
  processDungeonBubbles()
  processTalkingHead()
  garbageCollectQueue()
  if (#S.bubblesQueue == 0) then
    S.ctrFrame:SetScript("OnUpdate", nil)
  end
end

-- Public API
function Bubbles.EnqueueBubble(originalText, translatedText, npcName)
  table.insert(S.bubblesQueue, { [1] = originalText, [2] = translatedText, [3] = 1, [4] = npcName })
  S.ctrFrame:SetScript("OnUpdate", Bubbles.OnUpdate)
end

function Bubbles.ToggleTROnline()
  local controls = S.trControls
  if (S.trVisible == 0) then
    S.trVisible = 1
    if controls.buttonSave then controls.buttonSave:Show() end
    if controls.inputOriginal then controls.inputOriginal:Show() end
    if controls.inputTranslation then controls.inputTranslation:Show() end
    if controls.buttonLatch then controls.buttonLatch:Show() end
  else
    S.trVisible = 0
    if controls.buttonSave then controls.buttonSave:Hide() end
    if controls.inputOriginal then controls.inputOriginal:Hide() end
    if controls.inputTranslation then controls.inputTranslation:Hide() end
    if controls.buttonLatch then controls.buttonLatch:Hide() end
  end
end

function Bubbles.ReleaseLatch()
  local controls = S.trControls
  if (S.latchCount > 0) then
    S.latchCount = S.latchCount - 1
    if (S.latchCount == 0) then
      if controls.buttonLatch then controls.buttonLatch:SetText("O") end
    else
      for i = 1, S.latchCount, 1 do
        S.buffer[i] = S.buffer[i + 1]
      end
      S.buffer[S.latchCount + 1] = ""
      local _, _, p3 = strsplit("@", S.buffer[1])
      if controls.inputOriginal then controls.inputOriginal:SetText(p3) end
      if (S.latchCount == 1) then
        if controls.buttonLatch then controls.buttonLatch:SetText("X") end
      else
        if controls.buttonLatch then controls.buttonLatch:SetText(tostring(S.latchCount)) end
      end
    end
  else
    if controls.inputOriginal then controls.inputOriginal:SetText("czekam na tekst oryginalny z nieprzetlumaczonego dymku") end
  end
  if controls.inputTranslation then controls.inputTranslation:SetText("") end
end

function Bubbles.SaveTROnline()
  local controls = S.trControls
  if (controls.inputTranslation and controls.inputTranslation:GetText() == "") then
    controls.inputTranslation:SetText("?? - a gdzie tłumaczenie - ??")
  else
    local p1, p2, p3 = strsplit("@", S.buffer[1])
    if controls.inputOriginal and controls.inputTranslation then
      BB_TR[p1 .. "@" .. p2] = controls.inputOriginal:GetText() .. "@" .. controls.inputTranslation:GetText()
      controls.inputTranslation:SetText("OK - zapisano tłumaczenie - OK")
      controls.inputOriginal:SetText("czekam na tekst oryginalny z nieprzetlumaczonego dymku")
    end
    S.readyCount = S.readyCount + 1
    S.ready[S.readyCount] = S.buffer[1]
    Bubbles.ReleaseLatch()
  end
end

function Bubbles.CreateTROnlineWindow()
  local f = CreateFrame("Frame", "DragFrame1", UIParent)
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)

  f:SetWidth(500)
  f:SetHeight(46)
  f:ClearAllPoints()
  f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 250, 0)
  if (BB_PM and BB_PM["TRonline"] == "1") then f:Show() else f:Hide() end

  local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  btn:SetWidth(60)
  btn:SetHeight(20)
  btn:SetText("BBTR")
  btn:ClearAllPoints()
  btn:SetPoint("TOPLEFT", f, "TOPLEFT", 3, -3)
  btn:SetScript("OnClick", Bubbles.ToggleTROnline)
  if (BB_PM and BB_PM["TRonline"] == "1") then btn:Show() end
  S.trControls.toggleButton = btn

  local save = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  save:SetWidth(60)
  save:SetHeight(20)
  save:SetText("Zapisz")
  save:ClearAllPoints()
  save:SetPoint("TOPLEFT", btn, "BOTTOMLEFT", 0, 1)
  save:SetScript("OnClick", Bubbles.SaveTROnline)
  save:Hide()
  S.trControls.buttonSave = save

  local input1 = CreateFrame("EditBox", "BB_Input1", f, "InputBoxTemplate")
  input1:ClearAllPoints()
  input1:SetPoint("TOPLEFT", btn, "TOPRIGHT", 4, 0)
  input1:SetHeight(20)
  input1:SetWidth(400)
  input1:SetAutoFocus(false)
  input1:SetFontObject(GameFontGreen)
  input1:SetText("tutaj bedzie tekst oryginalny")
  input1:SetCursorPosition(0)
  input1:Hide()
  S.trControls.inputOriginal = input1

  local input2 = CreateFrame("EditBox", "BB_Input2", f, "InputBoxTemplate")
  input2:ClearAllPoints()
  input2:SetPoint("TOPLEFT", save, "TOPRIGHT", 4, 0)
  input2:SetHeight(20)
  input2:SetWidth(400)
  input2:SetAutoFocus(false)
  input2:SetFontObject(GameFontWhite)
  input2:SetText("a tutaj będzie polskie tłumaczenie")
  local _font1, _size2, _flag3 = input2:GetFont()
  input2:SetFont(WOWTR_Font2, _size2, _flag3)
  input2:SetCursorPosition(0)
  input2:Hide()
  S.trControls.inputTranslation = input2

  local toggleBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  toggleBtn:SetWidth(30)
  toggleBtn:SetHeight(20)
  toggleBtn:SetText("O")
  toggleBtn:ClearAllPoints()
  toggleBtn:SetPoint("TOPLEFT", input1, "TOPRIGHT", -1, 0)
  toggleBtn:SetScript("OnClick", Bubbles.ReleaseLatch)
  toggleBtn:Hide()
  S.trControls.buttonLatch = toggleBtn

  BB_TRframe = f
  BB_Button8 = btn
end

-- Movement handlers for dungeon tooltips
function WOWBB_OnMouseDown(obj)
  obj:StartMoving()
  _, _, _, _, WOWBB_vert1 = obj:GetPoint()
end

function WOWBB_OnMouseUp(obj)
  _, _, _, _, WOWBB_vert2 = obj:GetPoint()
  obj:StopMovingOrSizing()
  obj.vertical = obj.vertical + math.floor(WOWBB_vert2 - WOWBB_vert1)
  if (obj:GetName() == "WOWBB1") then
    WOWBB1:ClearAllPoints(); WOWBB1:SetPoint("CENTER", 0, obj.vertical)
  elseif (obj:GetName() == "WOWBB2") then
    WOWBB2:ClearAllPoints(); WOWBB2:SetPoint("CENTER", 250, obj.vertical)
  elseif (obj:GetName() == "WOWBB3") then
    WOWBB3:ClearAllPoints(); WOWBB3:SetPoint("CENTER", -250, obj.vertical)
  elseif (obj:GetName() == "WOWBB4") then
    WOWBB4:ClearAllPoints(); WOWBB4:SetPoint("CENTER", 500, obj.vertical)
  elseif (obj:GetName() == "WOWBB5") then
    WOWBB5:ClearAllPoints(); WOWBB5:SetPoint("CENTER", -500, obj.vertical)
  end
end

-- Chat filter implementation (back-compat signature)
function Bubbles.ChatFilter(self, event, arg1, arg2, arg3, _, arg5, ...)
  notifyTutorialSystem()

  local changeBubble = false
  local colorText = ""
  local original_txt = strtrim(arg1)
  local name_NPC = string.gsub(arg2 or "", " says:", "")
  local target = arg5

  if (event == "CHAT_MSG_MONSTER_SAY") then
    colorText = "|cFFFFFF9F"
    if (GetCVar("chatBubbles")) then changeBubble = true end
  elseif (event == "CHAT_MSG_MONSTER_PARTY") then
    colorText = "|cFFAAAAFF"
  elseif (event == "CHAT_MSG_MONSTER_YELL") then
    colorText = "|cFFFF4040"
    if (GetCVar("chatBubbles")) then changeBubble = true end
  elseif (event == "CHAT_MSG_MONSTER_WHISPER") then
    colorText = "|cFFFFB5EB"
  elseif (event == "CHAT_MSG_MONSTER_EMOTE") then
    colorText = "|cFFFF8040"
  end

  BB_is_translation = "0"
  if (BB_PM and BB_PM["active"] == "1") then
    local Origin_Text = original_txt
    if (arg5 and (arg5 ~= "")) then
      Origin_Text = WOWTR_DetectAndReplacePlayerName(Origin_Text, arg5)
    else
      Origin_Text = WOWTR_DetectAndReplacePlayerName(Origin_Text)
    end
    local Czysty_Text = WOWTR_DeleteSpecialCodes(Origin_Text)

    local exceptionHash
    if (string.sub(name_NPC, 1, 17) == "Bronze Timekeeper" or string.sub(name_NPC, 1, 16) == "Grimy Timekeeper") then
      Czysty_Text = string.gsub(Czysty_Text, "%d", "")
    elseif ((name_NPC == "General Hammond Clay") and (string.sub(Czysty_Text, 1, 27) == "For their courage, we honor")) then
      exceptionHash = 4192543970
    end

    local HashCode
    if (exceptionHash) then
      HashCode = exceptionHash
    else
      HashCode = StringHash(Czysty_Text)
    end

    local gl_BB_Bubbles = rawget(_G, "BB_Bubbles")
    if (gl_BB_Bubbles and gl_BB_Bubbles[HashCode]) then
      local NewMessage = gl_BB_Bubbles[HashCode]
      NewMessage = WOW_ZmienKody(NewMessage, arg5)

      if (string.sub(name_NPC, 1, 17) == "Bronze Timekeeper" or string.sub(name_NPC, 1, 16) == "Grimy Timekeeper") then
        local wartab = { 0, 0, 0, 0, 0, 0 }
        local arg0 = 0
        for w in string.gmatch(strtrim(arg1), "%d+") do
          arg0 = arg0 + 1
          local iw = tonumber(w) or 0
          if (iw > 999999) then
            wartab[arg0] = tostring(iw):reverse():gsub("(%d%d%d)(%d%d%d)", "%1.%2."):gsub("(%-?)$", "%1"):reverse()
          elseif (iw > 99999) then
            wartab[arg0] = tostring(iw):reverse():gsub("(%d%d%d)(%d%d%d)", "%1.%2"):gsub("(%-?)$", "%1"):reverse()
          elseif (iw > 999) then
            wartab[arg0] = tostring(iw):reverse():gsub("(%d%d%d)", "%1."):gsub("(%-?)$", "%1"):reverse()
          else
            wartab[arg0] = w
          end
        end
        if (arg0 > 5) then NewMessage = string.gsub(NewMessage, "$6", wartab[6]) end
        if (arg0 > 4) then NewMessage = string.gsub(NewMessage, "$5", wartab[5]) end
        if (arg0 > 3) then NewMessage = string.gsub(NewMessage, "$4", wartab[4]) end
        if (arg0 > 2) then NewMessage = string.gsub(NewMessage, "$3", wartab[3]) end
        if (arg0 > 1) then NewMessage = string.gsub(NewMessage, "$2", wartab[2]) end
        if (arg0 > 0) then NewMessage = string.gsub(NewMessage, "$1", wartab[1]) end
      end

      BB_is_translation = "1"
      local nr_poz = findPercentS(NewMessage)

      local mark_AI = ""
      do local gl_BB_AI = rawget(_G, "BB_AI"); if (gl_BB_AI and gl_BB_AI[HashCode]) then mark_AI = " |c0000FFFF(AI)|r" end end

      if (BB_PM["chat-tr"] == "1") then
        local _fontC, _sizeC, _C = DEFAULT_CHAT_FRAME:GetFont()
        if (WoWTR_Localization and WoWTR_Localization.lang ~= 'TR') then
          DEFAULT_CHAT_FRAME:SetFont(WOWTR_Font2, _sizeC, _C)
        end
        if (nr_poz > 0) then
          local fixed_message = ""
          if (nr_poz == 1) then
            fixed_message = WOWTR_AnsiReverse(name_NPC) .. strsub(NewMessage, 3)
          else
            fixed_message = strsub(NewMessage, 1, nr_poz - 1) .. WOWTR_AnsiReverse(name_NPC) .. strsub(NewMessage, nr_poz + 2)
          end
          if (RTL and RTL.IsRTL and RTL.IsRTL()) then
            local qtrOffset = -10
            if C_AddOns.IsAddOnLoaded("Prat-3.0") then qtrOffset = -50 end
            DEFAULT_CHAT_FRAME:AddMessage(colorText .. QTR_ExpandUnitInfo(fixed_message, false, DEFAULT_CHAT_FRAME, WOWTR_Font2, qtrOffset, true))
          else
            DEFAULT_CHAT_FRAME:AddMessage(colorText .. QTR_ExpandUnitInfo(NewMessage, false, DEFAULT_CHAT_FRAME, WOWTR_Font2, -50, true) .. mark_AI)
          end
        elseif (strsub(NewMessage, 1, 2) == "%o") then
          NewMessage = strsub(NewMessage, 3)
          DEFAULT_CHAT_FRAME:AddMessage(colorText .. QTR_ExpandUnitInfo(NewMessage:gsub("^%s*", ""), false, DEFAULT_CHAT_FRAME, WOWTR_Font2, -50, true) .. mark_AI)
        else
          if (RTL and RTL.IsRTL and RTL.IsRTL()) then
            local qtrOffset = -10
            if C_AddOns.IsAddOnLoaded("Prat-3.0") then qtrOffset = -50 end
            DEFAULT_CHAT_FRAME:AddMessage(colorText .. QTR_ExpandUnitInfo("{r}" .. WOWTR_AnsiReverse(name_NPC) .. ":{cFFFFFFFF} " .. NewMessage, false, DEFAULT_CHAT_FRAME, WOWTR_Font2, qtrOffset, true))
          else
            DEFAULT_CHAT_FRAME:AddMessage(colorText .. "|cCCDDEEFF" .. name_NPC .. ":|r " .. QTR_ExpandUnitInfo(NewMessage, false, DEFAULT_CHAT_FRAME, WOWTR_Font2, -100, true) .. mark_AI)
          end
        end
      else
        if (nr_poz > 0) then
          if (nr_poz == 1) then
            NewMessage = name_NPC .. strsub(NewMessage, 3)
          else
            NewMessage = strsub(NewMessage, 1, nr_poz - 1) .. name_NPC .. strsub(NewMessage, nr_poz + 2)
          end
        elseif (strsub(NewMessage, 1, 2) == "%o") then
          NewMessage = strsub(NewMessage, 3)
        end
      end

      if (changeBubble) then
        Bubbles.EnqueueBubble(arg1, NewMessage, name_NPC)
      end
    else
      if (BB_PM["saveNB"] == "1") then
        local Origin_Text = strtrim(arg1)
        if (arg5 and (arg5 ~= "")) then
          Origin_Text = WOWTR_DetectAndReplacePlayerName(Origin_Text, arg5)
        else
          Origin_Text = WOWTR_DetectAndReplacePlayerName(Origin_Text)
        end
        BB_PS[name_NPC .. ":" .. tostring(HashCode)] = Origin_Text .. "@" .. (target or "") .. ":" .. (WOWTR_player_name or "") .. ":" .. (WOWTR_player_race or "") .. ":" .. (WOWTR_player_class or "")
      end

      if (BB_PM["TRonline"] == "1") then
        local pomoc = name_NPC .. "@" .. tostring(HashCode) .. "@" .. original_txt
        local jest = 0
        for ind = 1, S.readyCount, 1 do
          if (S.ready[ind] == pomoc) then jest = 1 end
        end
        if (jest == 0) then
          if (S.latchCount == 0) then
            if S.trControls.inputOriginal then S.trControls.inputOriginal:SetText(original_txt) end
            if S.trControls.inputTranslation then S.trControls.inputTranslation:SetText("") end
            S.latchCount = 1
            if S.trControls.buttonLatch then S.trControls.buttonLatch:SetText("X") end
            S.latchNameNPC = name_NPC
            S.latchHashCode = tostring(HashCode)
            S.buffer[S.latchCount] = name_NPC .. "@" .. tostring(HashCode) .. "@" .. original_txt
          else
            local already = 0
            for ind = 1, S.latchCount, 1 do
              if (S.buffer[ind] == pomoc) then already = 1 end
            end
            if (already == 0) then
              S.latchCount = S.latchCount + 1
              S.buffer[S.latchCount] = pomoc
              if S.trControls.buttonLatch then S.trControls.buttonLatch:SetText(tostring(S.latchCount)) end
            end
          end
        end
      end
    end
  end

  notifyTutorialSystem()
  if ((BB_PM and BB_PM["chat-en"] == "1") or (BB_is_translation ~= "1")) then
    return false
  else
    return true
  end
end

function BB_ChatFilter(self, event, arg1, arg2, arg3, _, arg5, ...) return Bubbles.ChatFilter(self, event, arg1, arg2, arg3, _, arg5, ...) end

-- Back-compat global wrappers
function BB_bubblizeText() return Bubbles.OnUpdate() end
function BB_OknoTRonline() return Bubbles.CreateTROnlineWindow() end
function BB_TRzatrzask() return Bubbles.ReleaseLatch() end
function BB_ShowTRsave() return Bubbles.SaveTROnline() end
function BB_ShowTRonline() return Bubbles.ToggleTROnline() end


