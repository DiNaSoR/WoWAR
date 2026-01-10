-- WoW_Quests_Gossip.lua
-- Gossip toggle handlers (modularized)

-- luacheck: globals QTR_display_constants

local addonName, ns = ...
ns = ns or {}
ns.Quests = ns.Quests or {}
local Quests = ns.Quests
local S = ns.Quests.State or {}

Quests.Gossip = Quests.Gossip or {}

local function isRTL()
   return (Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL()) or false
end

-- Store original fonts so we can restore when switching back to EN
local OriginalGossipFonts = setmetatable({}, { __mode = "k" })
local function RememberFont(fs)
   if fs and fs.GetFont and not OriginalGossipFonts[fs] then
      local font, size, flags = fs:GetFont()
      OriginalGossipFonts[fs] = { font = font, size = size, flags = flags }
   end
end

local function RestoreOriginalFont(fs)
   if not fs then return end
   local o = OriginalGossipFonts[fs]
   if o and o.font then fs:SetFont(o.font, o.size, o.flags) end
end

local function ApplyFontToGossipScrollTarget()
   local size = tonumber(QTR_PS and QTR_PS["fontsize"] or 13)
   local fontPath = WOWTR_Font2
   local target = GossipFrame and GossipFrame.GreetingPanel and GossipFrame.GreetingPanel.ScrollBox and GossipFrame.GreetingPanel.ScrollBox.ScrollTarget
   if not (target and fontPath and size) then return end
   local function setFonts(frame)
      if not (frame and frame.GetRegions) then return end
      local regions = { frame:GetRegions() }
      for _, region in pairs(regions) do
         if region and region.GetObjectType and region:GetObjectType() == "FontString" then
            RememberFont(region)
            region:SetFont(fontPath, size)
         end
      end
   end
   setFonts(target)
   local children = { target:GetChildren() }
   for _, child in ipairs(children) do setFonts(child) end
end

local function RestoreFontInGossipScrollTarget()
   local target = GossipFrame and GossipFrame.GreetingPanel and GossipFrame.GreetingPanel.ScrollBox and GossipFrame.GreetingPanel.ScrollBox.ScrollTarget
   if not target then return end
   local function restoreFonts(frame)
      if not (frame and frame.GetRegions) then return end
      local regions = { frame:GetRegions() }
      for _, region in pairs(regions) do
         if region and region.GetObjectType and region:GetObjectType() == "FontString" then
            RestoreOriginalFont(region)
         end
      end
   end
   restoreFonts(target)
   local children = { target:GetChildren() }
   for _, child in ipairs(children) do restoreFonts(child) end
end

function Quests.Gossip.ToggleNPCGossip()
   if (QTR_curr_goss=="1") then         -- turn off translation, show original
      QTR_curr_goss="0"
      if GossipGreetingText and QTR_GS then
         GossipGreetingText:SetText(QTR_GS[QTR_curr_hash])
         GossipGreetingText:SetJustifyH("LEFT")
         RestoreOriginalFont(GossipGreetingText) -- Restore original font instead of using WOWTR_Font2
      end
      do local ui = S and S.ui and S.ui.gossip; if ui and ui.toggleGS then ui.toggleGS:SetText("GH="..tostring(QTR_curr_hash).." EN") end end
      if (QTR_goss_optionsEN) then
         for k, v in pairs(QTR_goss_optionsEN) do
            if k and k.SetText then
               k:SetText(v)
               if Quests.Utils and Quests.Utils.ApplyOptionButtonLayout then Quests.Utils.ApplyOptionButtonLayout(k, false) end
               local fr = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(k)
               if fr then RestoreOriginalFont(fr) end -- Restore original font instead of using WOWTR_Font2
               if k.Resize then k:Resize() end
            end
         end
      end
      -- Also restore any ScrollBox choice strings we cached
      if QTR_goss_optionsEN then
         for frame, original in pairs(QTR_goss_optionsEN) do
            if frame and frame.SetText then frame:SetText(original or "") end
            if frame and frame.Resize then frame:Resize() end
         end
      end
      RestoreFontInGossipScrollTarget()
   else                                   -- show translation
      QTR_curr_goss="1"
      local Greeting_TR = GS_Gossip and GS_Gossip[QTR_curr_hash]
      -- Ensure local NPC name is available in this scope
      local Nazwa_NPC = GossipFrameTitleText and GossipFrameTitleText:GetText() or UnitName("target")
      if (string.sub((Nazwa_NPC or ""),1,17) == "Bronze Timekeeper") then
         if Quests.Utils and Quests.Utils.FormatBronzeTimekeeper then
            Greeting_TR = Quests.Utils.FormatBronzeTimekeeper(QTR_GS[QTR_curr_hash], Greeting_TR)
         end
      end
      if GossipGreetingText and Quests.Utils and Quests.Utils.ApplyRTLText then
         Quests.Utils.ApplyRTLText(GossipGreetingText, (Greeting_TR or "") .. NONBREAKINGSPACE, WOWTR_Font2, tonumber(QTR_PS and QTR_PS["fontsize"] or 13), -5, "LEFT")
      end
      do local ui = S and S.ui and S.ui.gossip; if ui and ui.toggleGS then ui.toggleGS:SetText("GH="..tostring(QTR_curr_hash).." "..WOWTR_Localization.lang) end end
      if (QTR_goss_optionsTR) then
         for k, v in pairs(QTR_goss_optionsTR) do
            if k and k.SetText then
               k:SetText(v)
               if Quests.Utils and Quests.Utils.ApplyOptionButtonLayout then Quests.Utils.ApplyOptionButtonLayout(k, isRTL()) end
               local fr = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(k)
               if fr and WOWTR_Font2 and QTR_PS then fr:SetFont(WOWTR_Font2, tonumber(QTR_PS["fontsize"])) end
               if k.Resize then k:Resize() end
            end
         end
      end
      -- Ensure fonts applied for pooled children after this toggle
      ApplyFontToGossipScrollTarget()
      StartDelayedFunction(ApplyFontToGossipScrollTarget, 0.02)
      StartDelayedFunction(ApplyFontToGossipScrollTarget, 0.10)
   end
end

function Quests.Gossip.ToggleQuestFrame()
   if (QTR_curr_goss=="1") then         -- switch to English (LTR)
      -- Display constants wrapper lives in Details; call if present
      do local dc = rawget(_G, "QTR_display_constants"); if dc then dc(0) end end
      QTR_curr_goss="0"
      if GreetingText then
         GreetingText:SetText(QTR_GS[QTR_curr_hash] or "")
         GreetingText:SetJustifyH("LEFT")
         RestoreOriginalFont(GreetingText)
      end
      -- Ensure headers return to original Blizzard labels, fonts, and LTR alignment when translation is off
      if CurrentQuestsText then
         if CurrentQuestsText.SetText then CurrentQuestsText:SetText(CURRENT_QUESTS or "Current Quests") end
         if CurrentQuestsText.SetJustifyH then CurrentQuestsText:SetJustifyH("LEFT") end
         RestoreOriginalFont(CurrentQuestsText)
      end
      if AvailableQuestsText then
         if AvailableQuestsText.SetText then AvailableQuestsText:SetText(AVAILABLE_QUESTS or "Available Quests") end
         if AvailableQuestsText.SetJustifyH then AvailableQuestsText:SetJustifyH("LEFT") end
         RestoreOriginalFont(AvailableQuestsText)
      end
      do local uiq = S and S.ui and S.ui.quest; if uiq and uiq.toggleEN then uiq.toggleEN:SetText("GH="..tostring(QTR_curr_hash).." EN") end end
      -- Restore options to English LTR layout
      if (QTR_goss_optionsEN) then
         for k, v in pairs(QTR_goss_optionsEN) do
            if k and k.SetText then
               k:SetText(v or "")
               if Quests.Utils and Quests.Utils.ApplyOptionButtonLayout then Quests.Utils.ApplyOptionButtonLayout(k, false) end
               local fr = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(k)
               if fr then RestoreOriginalFont(fr) end
               if k.Resize then k:Resize() end
            end
         end
      end
      RestoreFontInGossipScrollTarget()
   else                                   -- switch to translated (potentially RTL)
      -- Display constants wrapper lives in Details; call if present
      do local dc = rawget(_G, "QTR_display_constants"); if dc then dc(1) end end
      QTR_curr_goss="1"
      local Greeting_TR = (GS_Gossip and GS_Gossip[QTR_curr_hash]) or (QTR_GS[QTR_curr_hash] or "")
      -- Ensure local NPC name is available in this scope
      local Nazwa_NPC = GossipFrameTitleText and GossipFrameTitleText:GetText() or UnitName("target")
      if (string.sub((Nazwa_NPC or ""),1,17) == "Bronze Timekeeper") then
         if Quests.Utils and Quests.Utils.FormatBronzeTimekeeper then
            Greeting_TR = Quests.Utils.FormatBronzeTimekeeper(QTR_GS[QTR_curr_hash], Greeting_TR)
         end
      end
      if GreetingText and Quests.Utils and Quests.Utils.ApplyRTLText then
         RememberFont(GreetingText)
         Quests.Utils.ApplyRTLText(GreetingText, (Greeting_TR or "") .. NONBREAKINGSPACE, WOWTR_Font2, tonumber(QTR_PS and QTR_PS["fontsize"] or 13), -5, "LEFT")
      end
      do local uiq = S and S.ui and S.ui.quest; if uiq and uiq.toggleEN then uiq.toggleEN:SetText("GH="..tostring(QTR_curr_hash).." "..WOWTR_Localization.lang) end end
      if (QTR_goss_optionsTR) then
         for k, v in pairs(QTR_goss_optionsTR) do
            if k and k.SetText then
               k:SetText(v or "")
               local fontStringRegion = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(k)
               if fontStringRegion and WOWTR_Font2 and QTR_PS then
                  RememberFont(fontStringRegion)
                  fontStringRegion:SetFont(WOWTR_Font2, tonumber(QTR_PS["fontsize"]))
               end
               if Quests.Utils and Quests.Utils.ApplyOptionButtonLayout then Quests.Utils.ApplyOptionButtonLayout(k, isRTL()) end
               if k.Resize then k:Resize() end
            end
         end
      end
   end
end

-- Show gossip on Blizzard GossipFrame, handling translations and options
function Quests.Gossip.Show()
   -- Early exit if translations are disabled
   if not QTR_PS or QTR_PS["active"] ~= "1" or QTR_PS["gossip"] ~= "1" then
      -- If gossip frame is visible but active is off, ensure it's showing original text
      if GossipFrame and GossipFrame:IsVisible() then
         -- If currently translated, toggle off to restore everything
         if QTR_curr_goss == "1" and GS_ON_OFF then
            GS_ON_OFF() -- This will restore fonts, alignment, and text
         else
            -- Even if not translated, ensure fonts are restored
            -- Restore greeting text font if it exists
            for _, GTxtframe in GossipFrame.GreetingPanel.ScrollBox:EnumerateFrames() do
               if GTxtframe.GreetingText then
                  RestoreOriginalFont(GTxtframe.GreetingText)
                  if GTxtframe.GreetingText.SetJustifyH then
                     GTxtframe.GreetingText:SetJustifyH("LEFT")
                  end
               end
            end
            -- Restore all option button fonts
            RestoreFontInGossipScrollTarget()
         end
         do local ui = S and S.ui and S.ui.gossip; if ui and ui.toggleGS then ui.toggleGS:Disable() end end
      end
      return
   end
   -- print("QTR_Gossip_Show")
   local Nazwa_NPC -- forward declare so ProcessOPT captures the local
   local function ProcessOPT(buttonString)
      local fontString = buttonString.Content.Name
      local GOptionText = WOWTR_DetectAndReplacePlayerName(fontString:GetText())
      local prefix, sufix = "", ""
      table.insert(Gossip2DUI_EN, fontString:GetText())
      local _font1, _size1 = fontString:GetFont()
      fontString:SetFont(WOWTR_Font2, _size1)
      if (string.sub(GOptionText,1,2) == "|c") then
         prefix = string.sub(GOptionText, 1, 10)
         sufix = "|r"
         GOptionText = string.gsub(GOptionText, prefix, "")
         GOptionText = string.gsub(GOptionText, sufix, "")
      end
      if (string.sub(GOptionText,2,2)==".") then
         GOptionText = string.sub(GOptionText,4)
      end
      local OptHash = StringHash(GOptionText)
      if (GS_Gossip[OptHash]) then
         local transLN = prefix .. QTR_ExpandUnitInfo(GS_Gossip[OptHash], false, fontString, WOWTR_Font2, -40) .. sufix .. NONBREAKINGSPACE
         fontString:SetText(transLN)
      else
         -- Save missing DUI/Immersion option if saving is enabled
         if (QTR_PS and QTR_PS["saveGS"] == "1") then
            local orig = WOWTR_DetectAndReplacePlayerName(fontString:GetText())
            orig = string.gsub(orig, '"', '\\"')
            orig = WOWTR_StripUEColorMarker(orig)
            local mapId = C_Map.GetBestMapForUnit("player") or 0
            QTR_GOSSIP[(Nazwa_NPC or "Unknown").."@"..tostring(OptHash).."@"..tostring(mapId)] = orig.."@"..WOWTR_player_name..":"..WOWTR_player_race..":"..WOWTR_player_class
         end
      end
      table.insert(Gossip2DUI_LN, fontString:GetText())
   end

   do local ui = S and S.ui and S.ui.gossip; if ui and ui.iconAI then ui.iconAI:Hide() end end
   do local uiq = S and S.ui and S.ui.quest; if uiq and uiq.iconAI then uiq.iconAI:Hide() end end
   Nazwa_NPC = GossipFrameTitleText and GossipFrameTitleText:GetText() or nil
   if (isImmersion and isImmersion()) then
      if (not Nazwa_NPC) then
         Nazwa_NPC = ImmersionFrame.TalkBox.NameFrame.Name:GetText()
      end
      if QTR_ToggleButton4 then
         QTR_ToggleButton4:SetText(QTR_ReverseIfAR(WOWTR_Localization.gossipText))
         QTR_ToggleButton4:Disable()
      end
   elseif (isStoryline and isStoryline()) then
      if (not Nazwa_NPC) then
         -- Guard Storyline globals; fall back if unavailable
         local chatName = rawget(_G, "Storyline_NPCFrameChatName")
         if chatName and chatName.GetText then
            Nazwa_NPC = chatName:GetText()
         end
      end
      if QTR_ToggleButton5 then
         QTR_ToggleButton5:SetText(QTR_ReverseIfAR(WOWTR_Localization.gossipText))
      end
   end
   if (not Nazwa_NPC) then Nazwa_NPC = UnitName("target") end
   QTR_curr_hash = 0
   local QTR_first_ok = false
   if (Nazwa_NPC) then
      local GossipTextFrame
      local Greeting_Text = C_GossipInfo:GetText()
      local GO_resized = 0
      QTR_goss_optionsEN = {}
      QTR_goss_optionsTR = {}
      for _, GTxtframe in GossipFrame.GreetingPanel.ScrollBox:EnumerateFrames() do
         if (GTxtframe.GreetingText) then GossipTextFrame = GTxtframe end
      end

      -- Remember original fonts BEFORE applying translation (so we can restore them later)
      if GossipTextFrame and GossipTextFrame.GreetingText then
         RememberFont(GossipTextFrame.GreetingText)
      end

      if (Greeting_Text and (string.find(Greeting_Text, NONBREAKINGSPACE) == nil)) then
         Nazwa_NPC = string.gsub(Nazwa_NPC, '"', '\\"')
         local Origin_Text = WOWTR_DetectAndReplacePlayerName(Greeting_Text)
         local Czysty_Text = WOWTR_NormalizeForHash(Origin_Text)
         if (string.sub(Nazwa_NPC,1,17) == "Bronze Timekeeper") then
            Czysty_Text = (Czysty_Text or ""):gsub("%d", "")
         end
         local Hash = StringHash(Czysty_Text)
         QTR_curr_hash = Hash
         QTR_GS[Hash] = Greeting_Text
         if (GS_Gossip[Hash] == nil) then
            Origin_Text = string.gsub(Origin_Text, ' (low level)', '')
            Czysty_Text = string.gsub(Czysty_Text, ' (low level)', '')
            Hash = StringHash(Czysty_Text)
            QTR_curr_hash = Hash
         end

         if (GS_Gossip[Hash]) then
            local Greeting_TR = GS_Gossip[Hash]
            if (string.sub(Nazwa_NPC,1,17) == "Bronze Timekeeper") then
               Greeting_TR = Quests.Utils and Quests.Utils.FormatBronzeTimekeeper and Quests.Utils.FormatBronzeTimekeeper(Greeting_Text, Greeting_TR) or Greeting_TR
            end
            if (GossipTextFrame) then
               do local ui = S and S.ui and S.ui.gossip; if ui and ui.toggleGS then ui.toggleGS:SetText("GH="..tostring(Hash).." "..WOWTR_Localization.lang); ui.toggleGS:Enable() end end
               GossipGreetingText = GossipTextFrame.GreetingText
               local GO_height = GossipGreetingText:GetHeight()
               local isRTL = Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL() or false
               if (isRTL and Quests.Utils and Quests.Utils.ApplyRTLText) then
                  Quests.Utils.ApplyRTLText(GossipGreetingText, Greeting_TR .. NONBREAKINGSPACE, WOWTR_Font2, tonumber(QTR_PS and QTR_PS["fontsize"] or 13), -5, "LEFT")
               else
                  GossipGreetingText:SetText(QTR_ExpandUnitInfo(Greeting_TR..NONBREAKINGSPACE,false,GossipGreetingText,WOWTR_Font2))
                  if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(GossipGreetingText, "LEFT") end
                  GossipGreetingText:SetFont(WOWTR_Font2, tonumber(QTR_PS and QTR_PS["fontsize"] or 13))
               end
               QTR_curr_goss = "1"
               if (GossipGreetingText:GetHeight() > GO_height+1) then
                  GO_resized = GO_resized + GossipGreetingText:GetHeight() - GO_height
               end
            do
               local gsAI = rawget(_G, "GS_AI")
               do local ui = S and S.ui and S.ui.gossip; if (gsAI and gsAI[Hash] and ui and ui.iconAI) then ui.iconAI:Show() end end
            end
            end
            if (isImmersion and isImmersion()) then
               ImmersionFrame.TalkBox.TextFrame.Text:SetFont(WOWTR_Font2, 14)
               ImmersionFrame.TalkBox.TextFrame.Text:SetText(QTR_ExpandUnitInfo(Greeting_TR,false,ImmersionFrame.TalkBox.TextFrame.Text,WOWTR_Font2))
            elseif (isStoryline and isStoryline()) then
               -- Interact with Storyline via integration wrapper only; avoid undeclared globals
               local function setStorylineText()
                  local chat = rawget(_G, "Storyline_NPCFrameChat")
                  local chatText = rawget(_G, "Storyline_NPCFrameChatText")
                  local isArabic = (WOWTR and WOWTR.Fonts and WOWTR.Fonts.IsArabic and WOWTR.Fonts.IsArabic()) or (WOWTR_Localization and WOWTR_Localization.lang == "AR")

                  if QTR_Storyline_Gossip then
                     local fallbackRegion = (ImmersionFrame and ImmersionFrame.TalkBox and ImmersionFrame.TalkBox.TextFrame and ImmersionFrame.TalkBox.TextFrame.Text) or GossipGreetingText
                     local region = chatText or fallbackRegion
                     local prepared = QTR_ExpandUnitInfo(Greeting_TR, false, region, WOWTR_Font2, -15, isArabic and true or nil)
                     _G.txt0txt = prepared
                     QTR_Storyline_Gossip()
                  end
               end
               do
                  local chat = rawget(_G, "Storyline_NPCFrameChat")
                  if not (chat and chat.texts) then
                     C_Timer.After(1.0, setStorylineText)
                  else
                     setStorylineText()
                  end
               end
            end
            if (IsDUIQuestFrame and IsDUIQuestFrame()) then
               if QTR_ToggleButton6 then
                  QTR_ToggleButton6:SetText("GH="..tostring(Hash).." ("..WOWTR_Localization.lang..")")
                  QTR_ToggleButton6:Enable()
               end
               if QTR_DUIGossipFrame then QTR_DUIGossipFrame() end
            end
            if (QTR_PS and QTR_PS["en_first"] == "1") then
               QTR_first_ok = true
            end
            -- Note: Fonts are applied individually to translated elements only, not blanket-applied
         else
            -- No translation found: restore original fonts, size, and alignment
            if GossipTextFrame and GossipTextFrame.GreetingText then
               RestoreOriginalFont(GossipTextFrame.GreetingText)
               if GossipTextFrame.GreetingText.SetJustifyH then
                  GossipTextFrame.GreetingText:SetJustifyH("LEFT")
               end
            end
            RestoreFontInGossipScrollTarget()
            do local ui = S and S.ui and S.ui.gossip; if ui and ui.toggleGS then ui.toggleGS:SetText("GH="..tostring(Hash).." (EN)"); ui.toggleGS:Disable() end end
            if (IsDUIQuestFrame and IsDUIQuestFrame()) then
               if QTR_ToggleButton6 then
                  QTR_ToggleButton6:SetText("GH="..tostring(Hash).." (EN)")
                  QTR_ToggleButton6:Show(); QTR_ToggleButton6:Disable()
               end
               if QTR_ToggleButton7 then QTR_ToggleButton7:Hide() end
               if (TT_PS and TT_PS["ui1"] == "1") then
                  if QTR_DUIbuttons then QTR_DUIbuttons() end
                  DUIQuestFrame.optionButtonPool:ProcessActiveObjects(ProcessOPT)
               end
            end
            if (QTR_PS and QTR_PS["saveGS"] == "1") then
               Origin_Text = string.gsub(Origin_Text, '"', '\\"')
               Origin_Text = WOWTR_StripUEColorMarker(Origin_Text)
               local map = C_Map.GetBestMapForUnit("player") or 0
               QTR_GOSSIP[Nazwa_NPC.."@"..tostring(Hash).."@"..tostring(map)] = Origin_Text.."@"..WOWTR_player_name..":"..WOWTR_player_race..":"..WOWTR_player_class
            end
         end
      end

      for _, GTxtframe in GossipFrame.GreetingPanel.ScrollBox:EnumerateFrames() do
         local GTtype = GTxtframe.GetElementData and GTxtframe.GetElementData().buttonType
         if (GTxtframe.GreetingText) then
            GossipTextFrame = GTxtframe
         else
            -- Try to read option text from the button or its first FontString region
            local rawText = (GTxtframe.GetText and GTxtframe:GetText()) or nil
            if (not rawText) and GTxtframe.GetRegions then
               local regions = { GTxtframe:GetRegions() }
               for _, r in pairs(regions) do
                  if r and r.GetObjectType and r:GetObjectType() == "FontString" and r.GetText then rawText = r:GetText(); break end
               end
            end
            if (rawText and QTR_PS and QTR_PS["active"] == "1" and QTR_PS["gossip"]=="1" and (string.find(rawText,NONBREAKINGSPACE)==nil)) then
               -- Remember original font BEFORE processing translation
               local fontStringRegion = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(GTxtframe)
               if fontStringRegion then
                  RememberFont(fontStringRegion)
               end
               local GOptionText = WOWTR_DetectAndReplacePlayerName(rawText, nil, '$N')
               local prefix, sufix = "", ""
               -- Strip both |cXXXXXXXX and |cnNAME: wrappers for hashing, preserve for display
               if (string.sub(GOptionText,1,2) == "|c") or (string.sub(GOptionText,1,3) == "|cn") then
                  local stripped = WOWTR_StripWoWColors(GOptionText)
                  -- Try to capture visible prefix/suffix for rendering if desired
                  if (string.sub(GOptionText,1,2) == "|c") then
                     prefix = string.sub(GOptionText, 1, 10); sufix = "|r"
                  elseif (string.sub(GOptionText,1,3) == "|cn") then
                     local start = string.match(GOptionText, "^(|cn[%w_]+:)")
                     if start then prefix = start; sufix = "|r" end
                  end
                  GOptionText = stripped
               end
               local Czysty_Text = WOWTR_DeleteSpecialCodes(GOptionText, '$N')
               local OptHash = StringHash(Czysty_Text)
               local transTR
               if (GS_Gossip[OptHash]) then
                  local fontStringRegion = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(GTxtframe)
                  local clean = QTR_ExpandUnitInfo(GS_Gossip[OptHash], false, fontStringRegion or GTxtframe, WOWTR_Font2, -40)
                  transTR = prefix .. clean .. sufix .. NONBREAKINGSPACE
               end
               if transTR then
                  local GO_height = GTxtframe:GetHeight()
                  -- Cache original and translated texts for toggling
                  QTR_goss_optionsEN[GTxtframe] = GTxtframe:GetText()
                  QTR_goss_optionsTR[GTxtframe] = transTR
                  GTxtframe:SetText(transTR)
                  -- Apply translation font ONLY to translated option buttons
                  local fontStringRegion = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(GTxtframe)
                  if fontStringRegion and WOWTR_Font2 and QTR_PS then
                     fontStringRegion:SetFont(WOWTR_Font2, tonumber(QTR_PS["fontsize"] or 13))
                  end
                  if GTxtframe.Resize then GTxtframe:Resize() end
                  if (GossipTextFrame and GO_resized > 0) then
                     local point, relativeTo, relativePoint, xOfs, yOfs = GTxtframe:GetPoint(1)
                     GTxtframe:ClearAllPoints()
                     GTxtframe:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs-GO_resized)
                  end
                  if (GTxtframe:GetHeight() > GO_height+1) then
                     GO_resized = GO_resized + GTxtframe:GetHeight() - GO_height
                  end
                  local isRTL = Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL() or false
                  if Quests.Utils and Quests.Utils.ApplyOptionButtonLayout then
                     Quests.Utils.ApplyOptionButtonLayout(GTxtframe, isRTL)
                  end
               else
                  -- No translation available: restore original font, size, and alignment
                  local fontStringRegion = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(GTxtframe)
                  if fontStringRegion then
                     RestoreOriginalFont(fontStringRegion)
                     if fontStringRegion.SetJustifyH then
                        fontStringRegion:SetJustifyH("LEFT")
                     end
                  end
                  if Quests.Utils and Quests.Utils.ApplyOptionButtonLayout then
                     Quests.Utils.ApplyOptionButtonLayout(GTxtframe, false)
                  end
                  -- Save original option text if enabled
                  if (QTR_PS and QTR_PS["saveGS"] == "1") then
                     local origText = WOWTR_DetectAndReplacePlayerName(rawText)
                     origText = string.gsub(origText, '"', '\\"')
                     origText = WOWTR_StripUEColorMarker(origText)
                     local mapId = C_Map.GetBestMapForUnit("player") or 0
                     QTR_GOSSIP[(Nazwa_NPC or "Unknown").."@"..tostring(OptHash).."@"..tostring(mapId)] = origText.."@"..WOWTR_player_name..":"..WOWTR_player_race..":"..WOWTR_player_class
                  end
               end
            end
         end
      end
   end

   local GFGoodbyeBtext = GossipFrame.GreetingPanel.GoodbyeButton.Text
   ST_CheckAndReplaceTranslationText(GFGoodbyeBtext, true, "ui", false, true)
end

-- Process translations for the QuestFrame gossip section
function Quests.Gossip.OnQuestFrame()
   do local ui = S and S.ui and S.ui.gossip; if ui and ui.iconAI then ui.iconAI:Hide() end end
   do local uiq = S and S.ui and S.ui.quest; if uiq and uiq.iconAI then uiq.iconAI:Hide() end end
   if ((GreetingText and GreetingText:IsVisible()) and QTR_PS and QTR_PS["active"] == "1" and QTR_PS["gossip"]=="1") then
      do local uiq = S and S.ui and S.ui.quest; if uiq and uiq.toggleEN then uiq.toggleEN:Disable(); uiq.toggleEN:SetWidth(150) end end
      local Greeting_Text = GreetingText:GetText()
      if (Greeting_Text and (string.find(Greeting_Text,NONBREAKINGSPACE)==nil)) then
         -- Remember original font BEFORE applying translation
         RememberFont(GreetingText)
         local GO_resized = 0
         QTR_goss_optionsEN = {}
         QTR_goss_optionsTR = {}
         local Origin_Text = WOWTR_DetectAndReplacePlayerName(Greeting_Text)
         local Czysty_Text = WOWTR_NormalizeForHash(Origin_Text)
         local Hash = StringHash(Czysty_Text)
         QTR_curr_hash = Hash
         QTR_GS[Hash] = Greeting_Text
         if (GS_Gossip[Hash]) then
            do local uiq = S and S.ui and S.ui.quest; if uiq and uiq.toggleEN then uiq.toggleEN:SetText("GH="..tostring(Hash).." "..WOWTR_Localization.lang); uiq.toggleEN:SetScript("OnClick", GS_ON_OFF2); uiq.toggleEN:Enable() end end
            local Greeting_TR = GS_Gossip[Hash]
            local GO_height = GreetingText:GetHeight()
            if Quests.Utils and Quests.Utils.ApplyRTLText then
               Quests.Utils.ApplyRTLText(GreetingText, Greeting_TR..NONBREAKINGSPACE, WOWTR_Font2, tonumber(QTR_PS and QTR_PS["fontsize"] or 13), -5, "LEFT")
            else
               GreetingText:SetText(QTR_ExpandUnitInfo(Greeting_TR..NONBREAKINGSPACE,false,GreetingText,WOWTR_Font2))
               GreetingText:SetFont(WOWTR_Font2, tonumber(QTR_PS and QTR_PS["fontsize"] or 13))
               if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(GreetingText, "LEFT") end
            end
            QTR_curr_goss="1"
            if (GreetingText:GetHeight() > GO_height+1) then
               GO_resized = GO_resized + GreetingText:GetHeight() - GO_height
            end
            do
               local gsAI = rawget(_G, "GS_AI")
               do local uiq = S and S.ui and S.ui.quest; if (gsAI and gsAI[Hash] and uiq and uiq.iconAI) then uiq.iconAI:Show() end end
            end
            if (IsDUIQuestFrame and IsDUIQuestFrame()) then
               if QTR_ToggleButton6 then
                 QTR_ToggleButton6:SetText("GH="..tostring(Hash).." ("..WOWTR_Localization.lang..")"); QTR_ToggleButton6:Enable()
               end
               if QTR_DUIGossipFrame then QTR_DUIGossipFrame() end
            end
         else
            -- No translation found: restore original font, size, and alignment
            RestoreOriginalFont(GreetingText)
            if GreetingText.SetJustifyH then
               GreetingText:SetJustifyH("LEFT")
            end
            do local uiq = S and S.ui and S.ui.quest; if uiq and uiq.toggleEN then uiq.toggleEN:SetText("GH="..tostring(Hash).." (EN)") end end
            if (QTR_PS and QTR_PS["saveGS"]=="1") then
               local Nazwa_NPC = QuestFrameTitleText:GetText()
               Origin_Text = string.gsub(Origin_Text, '"', '\\"')
               Origin_Text = WOWTR_StripUEColorMarker(Origin_Text)
               local map = C_Map.GetBestMapForUnit("player")
               QTR_GOSSIP[Nazwa_NPC..'@'..tostring(Hash)..'@'..map] = Origin_Text..'@'..WOWTR_player_name..':'..WOWTR_player_race..':'..WOWTR_player_class
            end
         end

        if (CurrentQuestsText and CurrentQuestsText:IsVisible()) then
           if Quests.Utils and Quests.Utils.ApplyRTLText then
              Quests.Utils.ApplyRTLText(CurrentQuestsText, QTR_Messages.currquests, WOWTR_Font1, 18, -30, "LEFT")
           else
              CurrentQuestsText:SetText(QTR_ExpandUnitInfo(QTR_Messages.currquests,false,CurrentQuestsText,WOWTR_Font1,-30))
              CurrentQuestsText:SetFont(WOWTR_Font1, 18)
              if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(CurrentQuestsText, "LEFT") end
           end
           if CurrentQuestsText.SetWidth then CurrentQuestsText:SetWidth(265) end
        end
        if (AvailableQuestsText and AvailableQuestsText:IsVisible()) then
           if Quests.Utils and Quests.Utils.ApplyRTLText then
              Quests.Utils.ApplyRTLText(AvailableQuestsText, QTR_Messages.avaiquests, WOWTR_Font1, 18, -30, "LEFT")
           else
              AvailableQuestsText:SetText(QTR_ExpandUnitInfo(QTR_Messages.avaiquests,false,AvailableQuestsText,WOWTR_Font1,-30))
              AvailableQuestsText:SetFont(WOWTR_Font1, 18)
              if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(AvailableQuestsText, "LEFT") end
           end
           if AvailableQuestsText.SetWidth then AvailableQuestsText:SetWidth(265) end
        end

         if (QTR_PS and QTR_PS["active"] == "1" and QTR_PS["gossip"]=="1") then
           for GText in QuestFrameGreetingPanel.titleButtonPool:EnumerateActive() do
               -- Remember original font BEFORE processing translation
               local fontStringRegion = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(GText)
               if fontStringRegion then
                  RememberFont(fontStringRegion)
               end
               local originalGossText = GText:GetText()
               local questID = GText.questID
               local transTR, prefix, sufix, isTranslated = nil, "", "", false
               if (string.sub(originalGossText,1,2) == "|c") then
                  prefix = string.sub(originalGossText, 1, 10); sufix = "|r"
               end
               if questID and questID ~= 0 and QTR_PS["transtitle"] == "1" then
                  local str_ID = tostring(questID)
                  if QTR_QuestData[str_ID] and QTR_QuestData[str_ID]["Title"] then
                     local translatedTitle = QTR_QuestData[str_ID]["Title"]
                     local cleanTransTR = QTR_ExpandUnitInfo(translatedTitle, false, GText, WOWTR_Font2, -40)
                     transTR = prefix .. cleanTransTR .. sufix .. " "
                     isTranslated = true
                  end
               end
               if not isTranslated then
                  local GOptionText = WOWTR_DetectAndReplacePlayerName(originalGossText, nil, '$N')
                  local cleanOptionText = GOptionText
                  if (string.sub(cleanOptionText,1,2) == "|c") or (string.sub(cleanOptionText,1,3) == "|cn") then
                     local detectedPrefix, detectedSuffix = "", ""
                     if (string.sub(cleanOptionText,1,2) == "|c") then
                        detectedPrefix = string.sub(cleanOptionText, 1, 10); detectedSuffix = "|r"
                     else
                        local start = string.match(cleanOptionText, "^(|cn[%w_]+:)")
                        if start then detectedPrefix = start; detectedSuffix = "|r" end
                     end
                     if detectedPrefix ~= "" then prefix = detectedPrefix; sufix = detectedSuffix end
                     cleanOptionText = WOWTR_StripWoWColors(cleanOptionText)
                  end
                  local Czysty_Text = WOWTR_DeleteSpecialCodes(cleanOptionText, '$N')
                  local TitleHash = StringHash(Czysty_Text)
                  if GS_Gossip[TitleHash] then
                  local cleanTransTR
                  if Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL() then
                     cleanTransTR = QTR_ExpandUnitInfo(GS_Gossip[TitleHash], false, GText, WOWTR_Font2, -40)
                  else
                     cleanTransTR = QTR_ExpandUnitInfo(GS_Gossip[TitleHash], false, GText, WOWTR_Font2, -40)
                  end
                  transTR = prefix .. cleanTransTR .. sufix .. " "
                     isTranslated = true
                  else
                     if (QTR_PS and QTR_PS["saveGS"]=="1") then
                        local Nazwa_NPC = QuestFrameTitleText:GetText()
                        local textToSave = WOWTR_DetectAndReplacePlayerName(originalGossText)
                        textToSave = string.gsub(textToSave, '"', '\\"')
                        textToSave = WOWTR_StripUEColorMarker(textToSave)
                        local mapId = C_Map.GetBestMapForUnit("player") or "0"
                        QTR_GOSSIP[Nazwa_NPC..'@'..tostring(TitleHash).."@"..mapId] = textToSave.."@"..WOWTR_player_name..":"..WOWTR_player_race..":"..WOWTR_player_class
                     end
                  end
               end
               if isTranslated and transTR then
                  if (GO_resized > 0) then
                     local point, relativeTo, relativePoint, xOfs, yOfs = GText:GetPoint(1)
                     GText:ClearAllPoints(); GText:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs - GO_resized)
                  end
                  local GO_height = GText:GetHeight()
                  QTR_goss_optionsEN[GText] = originalGossText
                  QTR_goss_optionsTR[GText] = transTR
                  GText:SetText(transTR)
                  if Quests.Utils and Quests.Utils.ApplyOptionButtonLayout then Quests.Utils.ApplyOptionButtonLayout(GText, (Quests.Utils.IsRTL and Quests.Utils.IsRTL() or false)) end
                  do
                     local fr = Quests.Utils and Quests.Utils.GetFirstFontStringRegion and Quests.Utils.GetFirstFontStringRegion(GText)
                     if fr and WOWTR_Font2 and QTR_PS then fr:SetFont(WOWTR_Font2, tonumber(QTR_PS["fontsize"])) end
                  end
                  if GText.Resize then GText:Resize() end
                  if (GText:GetHeight() > GO_height+1) then
                     GO_resized = GO_resized + GText:GetHeight() - GO_height
                  end
               else
                  -- No translation available: restore original font, size, and alignment
                  if (GO_resized > 0) then
                     local point, relativeTo, relativePoint, xOfs, yOfs = GText:GetPoint(1)
                     GText:ClearAllPoints(); GText:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs - GO_resized)
                  end
                  local GO_height = GText:GetHeight()
                  local fontStringRegion
                  local iconRegion = GText.Icon
                  local regions = { GText:GetRegions() }
                  for k, v in pairs(regions) do
                     if (v:GetObjectType() == "FontString") then fontStringRegion = v; break end
                  end
                  if fontStringRegion then
                     RestoreOriginalFont(fontStringRegion)
                     local leftPadding = 10
                     if iconRegion then
                        iconRegion:ClearAllPoints(); iconRegion:SetPoint("TOPLEFT", GText, "TOPLEFT", 5, -2)
                        if iconRegion.GetWidth then leftPadding = iconRegion:GetWidth() + 10 end
                     end
                     fontStringRegion:ClearAllPoints(); fontStringRegion:SetPoint("TOPLEFT", GText, "TOPLEFT", leftPadding, -2)
                     fontStringRegion:SetJustifyH("LEFT")
                  end
                  if Quests.Utils and Quests.Utils.ApplyOptionButtonLayout then
                     Quests.Utils.ApplyOptionButtonLayout(GText, false)
                  end
                  if GText.Resize then GText:Resize() end
                  if (GText:GetHeight() > GO_height+1) then
                     GO_resized = GO_resized + GText:GetHeight() - GO_height
                  end
               end
            end
         end
      end
   end

  -- QuestFrame buttons' text (guarded lookups via rawget to avoid luacheck field warnings)
  do local f=rawget(_G, "QuestFrameCompleteQuestButtonText"); if f then ST_CheckAndReplaceTranslationText(f, true, "ui", false, true) end end
  do local f=rawget(_G, "QuestFrameCompleteButtonText"); if f then ST_CheckAndReplaceTranslationText(f, true, "ui", false, true) end end
  do local f=rawget(_G, "QuestFrameAcceptButtonText"); if f then ST_CheckAndReplaceTranslationText(f, true, "ui", false, true) end end
  do local f=rawget(_G, "QuestFrameDeclineButtonText"); if f then ST_CheckAndReplaceTranslationText(f, true, "ui", false, true) end end
  do local f=rawget(_G, "QuestFrameContinueButtonText"); if f then ST_CheckAndReplaceTranslationText(f, true, "ui", false, true) end end
  do local f=rawget(_G, "QuestFrameGreetingGoodbyeButtonText"); if f then ST_CheckAndReplaceTranslationText(f, true, "ui", false, true) end end
  do local f=rawget(_G, "QuestFrameGoodbyeButtonText"); if f then ST_CheckAndReplaceTranslationText(f, true, "ui", false, true) end end
  do local f=rawget(_G, "QuestFrameCompleteButtonText"); if f then ST_CheckAndReplaceTranslationText(f, true, "ui", false, true) end end

   local notice = QuestFrame.AccountCompletedNotice and QuestFrame.AccountCompletedNotice.Text
   if notice then
      ST_CheckAndReplaceTranslationText(notice, true, "ui", false, true)
      notice:SetTextColor(0.5, 0, 0.5)
      if ns and ns.RTL and ns.RTL.JustifyFontString then ns.RTL.JustifyFontString(notice, "LEFT") end
      if ns and ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL() then
         local point, relativeTo, relativePoint, xOfs, yOfs = notice:GetPoint(1)
         notice:SetPoint(point, relativeTo, relativePoint, xOfs - 20, yOfs)
      end
   end
end

-- Back-compat global wrappers to override monolith definitions
function QTR_Gossip_Show() return Quests.Gossip.Show() end
function GossipOnQuestFrame() return Quests.Gossip.OnQuestFrame() end

-- Backward-compatible global wrappers (define only if absent)
if not GS_ON_OFF then
   function GS_ON_OFF()
      return Quests.Gossip.ToggleNPCGossip()
   end
end

if not GS_ON_OFF2 then
   function GS_ON_OFF2()
      return Quests.Gossip.ToggleQuestFrame()
   end
end
