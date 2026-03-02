local addonName, ns = ...

ns.Tutorials = ns.Tutorials or {}
local Tutorials = ns.Tutorials
local S = Tutorials.State
local U = Tutorials.Utils

local function setOnShowOnce(frame, handler, flagRef)
  if frame and frame.SetScript and flagRef and (flagRef[1] == 0) then
    frame:SetScript("OnShow", handler)
    flagRef[1] = 1
  end
end

local function isRTL()
  return (ns and ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL())
      or ((WOWTR_Localization and WOWTR_Localization.lang == 'AR') and true or false)
end

local function applyTutorialTextRTL(fs, defaultJustify)
  if not fs then return end
  if ns and ns.RTL and ns.RTL.JustifyFontString then
    ns.RTL.JustifyFontString(fs, defaultJustify or "LEFT")
  elseif fs.SetJustifyH then
    if isRTL() then
      fs:SetJustifyH("RIGHT")
    else
      fs:SetJustifyH(defaultJustify or "LEFT")
    end
  end
end

function Tutorials.OnTutorialShow()
  local function repeater(iter)
    if (TT_PS and TT_PS["active"] == "1") then
      local obj, txt

      obj = _G["TutorialMainFrame_Frame"]
      if obj and obj.ContainerFrame then
        if (S.tutMainFrameShow == 0) then
          obj.ContainerFrame:SetScript("OnShow", Tutorials.OnTutorialShow)
          S.tutMainFrameShow = 1
        end
      end

      obj = _G["TutorialWalk_Frame"]
      if obj then
        if (S.tutWalkShow == 0) then
          obj:SetScript("OnShow", Tutorials.OnTutorialShow)
          S.tutWalkShow = 1
        end
      end

      obj = _G["TutorialKeyboardMouseFrame_Frame"]
      if obj then
        if (S.tutKeyboardMouseFrameShow == 0) then
          obj:SetScript("OnShow", Tutorials.OnTutorialShow)
          S.tutKeyboardMouseFrameShow = 1
        end
      end

      obj = _G["TutorialSingleKey_Frame"]
      if obj then
        if (S.tutSingleKeyShow == 0) then
          obj:SetScript("OnShow", Tutorials.OnTutorialShow)
          S.tutSingleKeyShow = 1
        end
      end

      Tutorials.CheckFrames()

      for i = 2, 20, 1 do
        local content = _G["TutorialPointerFrame_" .. tostring(i) .. "Content"]
        if content then
          if (S.assignedShow[i] == 0) then
            content:SetScript("OnShow", Tutorials.OnTutorialShow)
            S.assignedShow[i] = 1
          end
          if (content:IsVisible() and content.Text) then
            txt = content.Text:GetText()
            if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
              local id = StringHash(txt)
              if (_G["Tut_Data7"] and _G["Tut_Data7"][id]) then
                local _, size = content.Text:GetFont()
                if (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
                  content.Text:SetText(QTR_ExpandUnitInfo(_G["Tut_Data7"][id], false, content.Text, WOWTR_Font2, -5) .. NONBREAKINGSPACE)
                  content.Text:SetFont(WOWTR_Font2, size)
                else
                  content.Text:SetText(QTR_ReverseIfAR(WOW_ZmienKody(_G["Tut_Data7"][id])) .. NONBREAKINGSPACE)
                  content.Text:SetFont(WOWTR_Font2, size)
                end
                applyTutorialTextRTL(content.Text, "LEFT")
              elseif (TT_PS and TT_PS["save"] == "1") then
                TT_TUTORIALS[tostring(id)] = txt
              end
            end
          end
        end
      end

      for i = 1, 1, 1 do
        local content = _G["TutorialPointerFrame_" .. tostring(i) .. "Content"]
        if content then
          if (S.assignedShow[i] == 0) then
            content:SetScript("OnShow", Tutorials.OnTutorialShow)
            S.assignedShow[i] = 1
          end
          if (content:IsVisible() and content.Text) then
            txt = content.Text:GetText()
            if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
              local id = StringHash(txt)
              if (_G["Tut_Data7"] and _G["Tut_Data7"][id]) then
                local _, size = content.Text:GetFont()
                if (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
                  content.Text:SetText(QTR_ExpandUnitInfo(_G["Tut_Data7"][id], false, content.Text, WOWTR_Font2, -30) .. NONBREAKINGSPACE)
                  content.Text:SetFont(WOWTR_Font2, size)
                else
                  content.Text:SetText(QTR_ReverseIfAR(WOW_ZmienKody(_G["Tut_Data7"][id])) .. NONBREAKINGSPACE)
                  content.Text:SetFont(WOWTR_Font2, size)
                end
                applyTutorialTextRTL(content.Text, "LEFT")
              elseif (TT_PS and TT_PS["save"] == "1") then
                TT_TUTORIALS[tostring(id)] = txt
              end
            end
          end
        end
      end
    end

    if iter < 10 then
      C_Timer.After(0.2, function() repeater(iter + 1) end)
    end
  end
  repeater(1)
end

function Tutorials.CheckFrames()
  local obj, txt

  obj = _G["TutorialMainFrame_Frame"]
  if (obj and obj.ContainerFrame and obj.ContainerFrame:IsVisible() and obj.ContainerFrame.Text) then
    txt = obj.ContainerFrame.Text:GetText()
    if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
      local id = StringHash(txt)
      if (_G["Tut_Data7"] and _G["Tut_Data7"][id]) then
        local _, size = obj.ContainerFrame.Text:GetFont()
        if (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
          obj.ContainerFrame.Text:SetText(QTR_ExpandUnitInfo(_G["Tut_Data7"][id], false, obj.ContainerFrame.Text, WOWTR_Font2, -15) .. NONBREAKINGSPACE)
        else
          obj.ContainerFrame.Text:SetText(QTR_ReverseIfAR(WOW_ZmienKody(_G["Tut_Data7"][id])) .. NONBREAKINGSPACE)
        end
        obj.ContainerFrame.Text:SetFont(WOWTR_Font2, size)
        applyTutorialTextRTL(obj.ContainerFrame.Text, "LEFT")
        obj.ContainerFrame.Text:SetHeight(150)
      elseif (TT_PS and TT_PS["save"] == "1") then
        TT_TUTORIALS[tostring(id)] = txt
      end
    end
  end

  obj = _G["TutorialWalk_Frame"]
  if (obj and obj.ContainerFrame and obj.ContainerFrame:IsVisible() and obj.ContainerFrame.Text) then
    txt = obj.ContainerFrame.Text:GetText()
    if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
      local id = StringHash(txt)
      if (_G["Tut_Data7"] and _G["Tut_Data7"][id]) then
        local _, size = obj.ContainerFrame.Text:GetFont()
        if (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
          obj.ContainerFrame.Text:SetText(QTR_ExpandUnitInfo(_G["Tut_Data7"][id], false, obj.ContainerFrame.Text, WOWTR_Font2) .. NONBREAKINGSPACE)
        else
          obj.ContainerFrame.Text:SetText(QTR_ReverseIfAR(WOW_ZmienKody(_G["Tut_Data7"][id])) .. NONBREAKINGSPACE)
        end
        obj.ContainerFrame.Text:SetFont(WOWTR_Font2, size)
        applyTutorialTextRTL(obj.ContainerFrame.Text, "LEFT")
        obj.ContainerFrame.Text:SetHeight(150)
      elseif (TT_PS and TT_PS["save"] == "1") then
        TT_TUTORIALS[tostring(id)] = txt
      end
    end
  end

  obj = _G["TutorialKeyboardMouseFrame_Frame"]
  if (obj and obj:IsVisible() and obj.Text) then
    txt = obj.Text:GetText()
    if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
      local id = StringHash(txt)
      if (_G["Tut_Data7"] and _G["Tut_Data7"][id]) then
        local _, size = obj.Text:GetFont()
        obj.Text:SetText(QTR_ReverseIfAR(WOW_ZmienKody(_G["Tut_Data7"][id])) .. NONBREAKINGSPACE)
        obj.Text:SetFont(WOWTR_Font2, size)
        applyTutorialTextRTL(obj.Text, "LEFT")
      elseif (TT_PS and TT_PS["save"] == "1") then
        TT_TUTORIALS[tostring(id)] = txt
      end
    end
  end

  obj = _G["TutorialSingleKey_Frame"]
  if (obj and obj.ContainerFrame and obj.ContainerFrame:IsVisible() and obj.ContainerFrame.Text) then
    txt = obj.ContainerFrame.Text:GetText()
    if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
      local id = StringHash(txt)
      if (_G["Tut_Data7"] and _G["Tut_Data7"][id]) then
        local _, size = obj.ContainerFrame.Text:GetFont()
        obj.ContainerFrame.Text:SetText(QTR_ReverseIfAR(WOW_ZmienKody(_G["Tut_Data7"][id])) .. NONBREAKINGSPACE)
        obj.ContainerFrame.Text:SetFont(WOWTR_Font2, size)
        applyTutorialTextRTL(obj.ContainerFrame.Text, "LEFT")
        obj.ContainerFrame.Text:SetHeight(150)
      elseif (TT_PS and TT_PS["save"] == "1") then
        TT_TUTORIALS[tostring(id)] = txt
      end
    end
  end
end

function Tutorials.OnTutorialShow_Time()
  C_Timer.After(0.5, Tutorials.OnTutorialShow)
end

function Tutorials.OnChoiceDelay()
  if (TT_PS and TT_PS["active"] == "1") then
    if (not WOWTR_wait(0.5, Tutorials.OnChoiceShow)) then
    end
  end
end

function Tutorials.OnChoiceOpen()
  if PlayerChoiceFrame and PlayerChoiceFrame.Show then PlayerChoiceFrame:Show() end
end

function Tutorials.OnChoiceShow()
  local isRTL = (ns and ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL()) or ((WOWTR_Localization and WOWTR_Localization.lang == 'AR') and true or false)
  local function applyRTL(fs, defaultJustify)
    if (not isRTL) or (not fs) then return end
    if ns and ns.RTL and ns.RTL.JustifyFontString then
      ns.RTL.JustifyFontString(fs, defaultJustify or "LEFT")
    elseif fs.SetJustifyH then
      fs:SetJustifyH("RIGHT")
    end
  end
  local function applyChoiceHTMLRTL(optionFrame, htmlRegion)
    if (not isRTL) or (not optionFrame) then return end
    local html = optionFrame.OptionText and optionFrame.OptionText.HTML
    if html and html.SetJustifyH then
      -- SimpleHTML API supports per-text-type alignment; set common body tags to RIGHT.
      pcall(html.SetJustifyH, html, "p", "RIGHT")
      pcall(html.SetJustifyH, html, "P", "RIGHT")
      pcall(html.SetJustifyH, html, "body", "RIGHT")
      pcall(html.SetJustifyH, html, "BODY", "RIGHT")
    end
    applyRTL(htmlRegion, "LEFT")
  end

  local txt = PlayerChoiceFrame and PlayerChoiceFrame.Title and PlayerChoiceFrame.Title.Text and PlayerChoiceFrame.Title.Text:GetText()
  if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
    local hash = StringHash(txt)
    if (_G["Tut_Data7"] and _G["Tut_Data7"][hash]) then
      local _, size = PlayerChoiceFrame.Title.Text:GetFont()
      PlayerChoiceFrame.Title.Text:SetText(QTR_ReverseIfAR(WOW_ZmienKody(_G["Tut_Data7"][hash])) .. NONBREAKINGSPACE)
      PlayerChoiceFrame.Title.Text:SetFont(WOWTR_Font2, size)
      applyRTL(PlayerChoiceFrame.Title.Text, "LEFT")
    elseif (TT_PS and TT_PS["save"] == "1") then
      TT_TUTORIALS[tostring(hash)] = txt
    end
  end
  applyRTL(PlayerChoiceFrame and PlayerChoiceFrame.Title and PlayerChoiceFrame.Title.Text, "LEFT")

  if (PlayerChoiceFrame and PlayerChoiceFrame.Option1 and PlayerChoiceFrame.Option1.OptionText) then
    local obj = PlayerChoiceFrame.Option1.OptionText.HTML:GetRegions()
    txt = obj and obj:GetText()
    if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
      txt = string.gsub(txt, '\r', '')
      local hash = StringHash(txt)
      if (_G["Tut_Data7"] and _G["Tut_Data7"][hash]) then
        local _, size = obj:GetFont()
        obj:SetText(QTR_ExpandUnitInfo(WOW_ZmienKody(_G["Tut_Data7"][hash]), false, obj, WOWTR_Font2) .. NONBREAKINGSPACE)
        obj:SetFont(WOWTR_Font2, size)
        applyChoiceHTMLRTL(PlayerChoiceFrame.Option1, obj)
      elseif (TT_PS and TT_PS["save"] == "1") then
        TT_TUTORIALS[tostring(hash)] = txt
      end
    end
    applyChoiceHTMLRTL(PlayerChoiceFrame.Option1, obj)

    if (PlayerChoiceFrame.Option1.OptionButtonsContainer and PlayerChoiceFrame.Option1.OptionButtonsContainer.button1) then
      local btn = PlayerChoiceFrame.Option1.OptionButtonsContainer.button1
      txt = btn:GetText()
      if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
        local hash = StringHash(txt)
        if (_G["Tut_Data7"] and _G["Tut_Data7"][hash]) then
          local _, size = btn.Text:GetFont()
          btn:SetText(QTR_ExpandUnitInfo(WOW_ZmienKody(_G["Tut_Data7"][hash]), false, btn, WOWTR_Font2) .. NONBREAKINGSPACE)
          btn.Text:SetFont(WOWTR_Font2, size)
          applyRTL(btn.Text, "LEFT")
        elseif (TT_PS and TT_PS["save"] == "1") then
          TT_TUTORIALS[tostring(hash)] = txt
        end
      end
      applyRTL(btn.Text, "LEFT")
    end
  end

  if (PlayerChoiceFrame and PlayerChoiceFrame.Option2 and PlayerChoiceFrame.Option2.OptionText) then
    local obj = PlayerChoiceFrame.Option2.OptionText.HTML:GetRegions()
    txt = obj and obj:GetText()
    if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
      txt = string.gsub(txt, '\r', '')
      local hash = StringHash(txt)
      if (_G["Tut_Data7"] and _G["Tut_Data7"][hash]) then
        local _, size = obj:GetFont()
        obj:SetText(QTR_ExpandUnitInfo(WOW_ZmienKody(_G["Tut_Data7"][hash]), false, obj, WOWTR_Font2) .. NONBREAKINGSPACE)
        obj:SetFont(WOWTR_Font2, size)
        applyChoiceHTMLRTL(PlayerChoiceFrame.Option2, obj)
      elseif (TT_PS and TT_PS["save"] == "1") then
        TT_TUTORIALS[tostring(hash)] = txt
      end
    end
    applyChoiceHTMLRTL(PlayerChoiceFrame.Option2, obj)

    if (PlayerChoiceFrame.Option2.OptionButtonsContainer and PlayerChoiceFrame.Option2.OptionButtonsContainer.button1) then
      local btn = PlayerChoiceFrame.Option2.OptionButtonsContainer.button1
      txt = btn:GetText()
      if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
        local hash = StringHash(txt)
        if (_G["Tut_Data7"] and _G["Tut_Data7"][hash]) then
          local _, size = btn.Text:GetFont()
          btn:SetText(QTR_ExpandUnitInfo(WOW_ZmienKody(_G["Tut_Data7"][hash]), false, btn, WOWTR_Font2) .. NONBREAKINGSPACE)
          btn.Text:SetFont(WOWTR_Font2, size)
          applyRTL(btn.Text, "LEFT")
        elseif (TT_PS and TT_PS["save"] == "1") then
          TT_TUTORIALS[tostring(hash)] = txt
        end
      end
      applyRTL(btn.Text, "LEFT")
    end
  end

  if (PlayerChoiceFrame and PlayerChoiceFrame.Option3 and PlayerChoiceFrame.Option3.OptionText) then
    local obj = PlayerChoiceFrame.Option3.OptionText.HTML:GetRegions()
    txt = obj and obj:GetText()
    if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
      txt = string.gsub(txt, '\r', '')
      local hash = StringHash(txt)
      if (_G["Tut_Data7"] and _G["Tut_Data7"][hash]) then
        local _, size = obj:GetFont()
        obj:SetText(QTR_ExpandUnitInfo(WOW_ZmienKody(_G["Tut_Data7"][hash]), false, obj, WOWTR_Font2) .. NONBREAKINGSPACE)
        obj:SetFont(WOWTR_Font2, size)
        applyChoiceHTMLRTL(PlayerChoiceFrame.Option3, obj)
      elseif (TT_PS and TT_PS["save"] == "1") then
        TT_TUTORIALS[tostring(hash)] = txt
      end
    end
    applyChoiceHTMLRTL(PlayerChoiceFrame.Option3, obj)

    if (PlayerChoiceFrame.Option3.OptionButtonsContainer and PlayerChoiceFrame.Option3.OptionButtonsContainer.button1) then
      local btn = PlayerChoiceFrame.Option3.OptionButtonsContainer.button1
      txt = btn:GetText()
      if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
        local hash = StringHash(txt)
        if (_G["Tut_Data7"] and _G["Tut_Data7"][hash]) then
          local _, size = btn.Text:GetFont()
          btn:SetText(QTR_ExpandUnitInfo(WOW_ZmienKody(_G["Tut_Data7"][hash]), false, btn, WOWTR_Font2) .. NONBREAKINGSPACE)
          btn.Text:SetFont(WOWTR_Font2, size)
          applyRTL(btn.Text, "LEFT")
        elseif (TT_PS and TT_PS["save"] == "1") then
          TT_TUTORIALS[tostring(hash)] = txt
        end
      end
      applyRTL(btn.Text, "LEFT")
    end
  end

  if (S.firstUse == 0) then
    -- Old behavior forced close/reopen on first open. Keep board visible and do one delayed
    -- stabilization pass instead, so first interaction feels natural.
    S.firstUse = 1
    if C_Timer and C_Timer.After then
      C_Timer.After(0.12, function()
        if PlayerChoiceFrame and PlayerChoiceFrame.IsVisible and PlayerChoiceFrame:IsVisible() then
          Tutorials.OnChoiceShow()
        end
      end)
    end
  end

  if PlayerChoiceFrame and PlayerChoiceFrame.optionPools and PlayerChoiceFrame.optionPools.EnumerateActive then
    for frame in PlayerChoiceFrame.optionPools:EnumerateActive() do
      if (frame.OptionText) then
        local obj = frame.OptionText.HTML:GetRegions()
        if obj then
          txt = obj:GetText()
          if (txt and string.find(txt, NONBREAKINGSPACE) == nil) then
            txt = string.gsub(txt, '\r', '')
            local hash = StringHash(txt)
            if (_G["Tut_Data7"] and _G["Tut_Data7"][hash]) then
              local _, size = obj:GetFont()
              obj:SetText(QTR_ExpandUnitInfo(WOW_ZmienKody(_G["Tut_Data7"][hash]), false, obj, WOWTR_Font2) .. NONBREAKINGSPACE)
              obj:SetFont(WOWTR_Font2, size)
              applyChoiceHTMLRTL(frame, obj)
            elseif (TT_PS and TT_PS["save"] == "1") then
              TT_TUTORIALS[tostring(hash)] = txt
            end
          end
        end
        applyChoiceHTMLRTL(frame, obj)
      end
    end
  end
end

function Tutorials.CampaignOverview()
  local frames_tab = {}
  local height_tab = {}
  local linePool
  local _, _, _, versionString = GetBuildInfo()
  local versionNumber = tonumber(versionString)

  if versionNumber then
    if versionNumber <= 110007 then
      linePool = QuestMapFrame.CampaignOverview.linePool
    else
      linePool = QuestMapFrame.QuestsFrame.CampaignOverview.linePool
    end
  end

  for frame in linePool:EnumerateActive() do
    local txt = frame:GetText()
    local HashCode = StringHash(txt)
    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1)
    if (_G["Tut_Data7"] and _G["Tut_Data7"][HashCode]) then
      frame:SetText(QTR_ReverseIfAR(_G["Tut_Data7"][HashCode]))
      if (string.len(_G["Tut_Data7"][HashCode]) < 30) then
        if (WOWTR_Localization and WOWTR_Localization.lang == 'TR') then
          frame:SetFont(WOWTR_Font2, 12)
        else
          frame:SetFont(WOWTR_Font2, 13)
        end
      else
        frame:SetFont(WOWTR_Font2, 12)
      end
      applyTutorialTextRTL(frame, "LEFT")
    elseif (TT_PS and TT_PS["save"] == "1") then
      TT_TUTORIALS[tostring(HashCode)] = txt
    end
    frames_tab[yOfs] = frame
    height_tab[yOfs] = frame:GetHeight()
  end

  local tkeys = {}
  for k in pairs(frames_tab) do table.insert(tkeys, k) end
  table.sort(tkeys, function(a, b) return a > b end)
  local last_rel = 0
  for _, k in ipairs(tkeys) do
    if (last_rel == 0) then
      last_rel = -height_tab[k] - 22
    else
      local point, relativeTo, relativePoint, xOfs, yOfs = frames_tab[k]:GetPoint(1)
      frames_tab[k]:ClearAllPoints()
      frames_tab[k]:SetPoint(point, relativeTo, relativePoint, xOfs, last_rel)
      last_rel = last_rel - height_tab[k] - 12
    end
  end
end

-- Back-compat global wrappers
function TT_onTutorialShow() return Tutorials.OnTutorialShow() end
function TT_SprawdzFrames() return Tutorials.CheckFrames() end
function TT_onTutorialShow_Time() return Tutorials.OnTutorialShow_Time() end
function TT_onChoiceDelay() return Tutorials.OnChoiceDelay() end
function TT_onChoiceOpen() return Tutorials.OnChoiceOpen() end
function TT_onChoiceShow() return Tutorials.OnChoiceShow() end
function TT_CampaignOverview() return Tutorials.CampaignOverview() end
