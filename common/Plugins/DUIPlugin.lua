-- DUIPlugin.lua
-- Plugin for handling Dialog UI functions

-- Global variables and functions
DUIPlugin = {}
--print("DUIPlugin loaded")

-------------------------------------------------------------------------------------------------------------------
-- Process font strings for gossip dialog UI
function DUIPlugin.ProcessGossipFontStrings(fontString, countFontString)
   if (QTR_curr_goss == "1") then   -- Show translations
      if (WoWTR_Localization.lang == 'AR') then
         fontString:SetText(GossipDUI_LN[countFontString])
         fontString:SetJustifyH("RIGHT")
      else
         fontString:SetText(GossipDUI_LN[countFontString])
         fontString:SetJustifyH("LEFT")
      end
   else                             -- Show original text
      fontString:SetText(GossipDUI_EN[countFontString])
      fontString:SetJustifyH("LEFT")
   end
   
   return countFontString + 1
end

-------------------------------------------------------------------------------------------------------------------
-- Process button strings for gossip dialog UI
function DUIPlugin.ProcessGossipButtonStrings(buttonString, count2FontString)
   local fontString = buttonString.Content.Name
   if (QTR_curr_goss == "1") then   -- Show translations
      if (WoWTR_Localization.lang == 'AR') then
         fontString:SetText(Gossip2DUI_LN[count2FontString])
         fontString:SetJustifyH("LEFT")
      else
         fontString:SetText(Gossip2DUI_LN[count2FontString])
         fontString:SetJustifyH("LEFT")
      end
   else                             -- Show original text
      fontString:SetText(Gossip2DUI_EN[count2FontString])
      fontString:SetJustifyH("LEFT")
   end
   
   return count2FontString + 1
end

-------------------------------------------------------------------------------------------------------------------
-- Handle gossip DUI on/off toggling
function DUIPlugin.GossipDUI_ON_OFF()
   if (QTR_curr_goss == "1") then      -- Turn off translation - show original text
      QTR_curr_goss = "0"
      QTR_ToggleButton6:SetText("GH="..tostring(QTR_curr_hash).." (EN)")
   else                                -- Show translation
      QTR_curr_goss = "1"
      QTR_ToggleButton6:SetText("GH="..tostring(QTR_curr_hash).." ("..WoWTR_Localization.lang..")")
   end
   
   local countFontString = 0
   local function ProcessOnOff(fontString)
      countFontString = DUIPlugin.ProcessGossipFontStrings(fontString, countFontString)
   end
   
   local count2FontString = 0
   local function Process2OnOff(buttonString)
      count2FontString = DUIPlugin.ProcessGossipButtonStrings(buttonString, count2FontString)
   end
   
   DUIQuestFrame.fontStringPool:ProcessActiveObjects(ProcessOnOff)
   DUIQuestFrame.optionButtonPool:ProcessActiveObjects(Process2OnOff)
end

-------------------------------------------------------------------------------------------------------------------
-- Handle DUI Gossip Frame
function DUIPlugin.QTR_DUIGossipFrame()
   QTR_ToggleButton6:Show()
   QTR_ToggleButton7:Hide()
   
   local function SplitParagraph(text)
      local tbl = {}
      if (text) then
         for v in string.gmatch(text, "[%%C]+") do
            table.insert(tbl, v)
         end
      end
      return tbl
   end

   local countFontString = 0
   local offset = 0
   local objectivesNow = false
   local gos = string.gsub(GS_Gossip[QTR_curr_hash] or '', 'NEW_LINE', '\n')
   gos = string.gsub(gos, '$b', '$B')
   gos = string.gsub(gos, '$B', '\n')
   gos = string.gsub(gos, '{B}', '\n')
   local gossip = SplitParagraph(gos)
   GossipDUI_LN = { }
   GossipDUI_EN = { }
   Gossip2DUI_LN = { }
   Gossip2DUI_EN = { }

   local function ProcessGS(fontString)
      if (string.find(fontString:GetText()," ") == nil) then   -- nie jest to przetłumaczony tekst (twarda spacja)
         countFontString = countFontString + 1
         table.insert(GossipDUI_EN, fontString:GetText())    -- english version
         local _font1, _size1, _1 = fontString:GetFont()     -- odczytaj aktualną czcionkę i rozmiar
         fontString:SetFont(WOWTR_Font2,_size1)
         local firstHeight = fontString:GetHeight()
         gossipX = gossip[countFontString] or ''
         if (WoWTR_Localization.lang == 'AR') then
            fontString:SetText(QTR_ExpandUnitInfo(gossipX.." ",false,fontString,WOWTR_Font2))
         else
            fontString:SetText(QTR_ExpandUnitInfo(gossipX.." ",false,fontString,WOWTR_Font2))
         end
         local secondHeight = fontString:GetHeight()
         offset = secondHeight - firstHeight
         local counter0 = 0
         while ((offset > 0) and (counter0<6)) do
            counter0 = counter0 + 1
            fontString:SetSpacing(fontString:GetSpacing()*firstHeight/secondHeight)  -- zmiana odstępu między wierszami
            secondHeight = fontString:GetHeight()
            offset = secondHeight - firstHeight
         end
         table.insert(GossipDUI_LN, fontString:GetText())    -- translated version
      end
   end
   
   local function ProcessOPT(buttonString)
      local fontString = buttonString.Content.Name
      local GOptionText = WOWTR_DetectAndReplacePlayerName(fontString:GetText())
      local prefix = ""
      local sufix = ""
      table.insert(Gossip2DUI_EN, fontString:GetText())   -- english version
      local _font1, _size1, _1 = fontString:GetFont()     -- odczytaj aktualną czcionkę i rozmiar
      fontString:SetFont(WOWTR_Font2,_size1)
      if (string.sub(GOptionText,2,2)==".") then           -- usuń liczby przed tekstem opcji
         GOptionText = string.sub(GOptionText,4)
      end
      if (string.sub(GOptionText,1,2) == "|c") then
         prefix = string.sub(GOptionText, 1, 10)
         sufix = "|r"
         GOptionText = string.gsub(GOptionText, prefix, "")
         GOptionText = string.gsub(GOptionText, sufix, "")
      end
      local OptHash = StringHash(GOptionText)
      if (GS_Gossip[OptHash]) then               -- jest tłumaczenie
         local transLN = prefix .. QTR_ExpandUnitInfo(GS_Gossip[OptHash],false,fontString,WOWTR_Font2,-40) .. sufix .. " "   -- twarda spacja na końcu
         fontString:SetText(transLN)
         fontString:SetJustifyH("LEFT")
      end
      table.insert(Gossip2DUI_LN, fontString:GetText())    -- translated version
   end

   QTR_curr_goss = "1"           -- aktualnie wyświetlane jest tłumaczenie
   
   DUIQuestFrame.fontStringPool:ProcessActiveObjects(ProcessGS)
   DUIQuestFrame.optionButtonPool:ProcessActiveObjects(ProcessOPT)
   
   if (TT_PS["ui1"] == "1") then
      QTR_DUIbuttons()
   end
end

-------------------------------------------------------------------------------------------------------------------
-- Check if the current frame is a DUI quest frame
function DUIPlugin.IsDUIQuestFrame()
   if (DUIQuestFrame ~= nil) then        -- jest uruchomiony dodatek DialogueUI
      if (QTR_ToggleButton6 == nil) then    -- przycisk w oknie tekstu gossip
         -- przycisk z Hash gossip
         QTR_ToggleButton6 = CreateFrame("Button", nil, DUIQuestFrame, "UIPanelButtonTemplate")
         QTR_ToggleButton6:SetWidth(150)
         QTR_ToggleButton6:SetHeight(20)
         QTR_ToggleButton6:SetText("GH=?")
         QTR_ToggleButton6:ClearAllPoints()
         QTR_ToggleButton6:SetPoint("TOPLEFT", DUIQuestFrame, "TOPLEFT", 25, -16)
         QTR_ToggleButton6:SetScript("OnClick", GossipDUI_ON_OFF)
         QTR_ToggleButton6:Disable()          -- nie można na razie przyciskać przycisku
         QTR_ToggleButton6:Hide()

         -- Set smaller font size by modifying the FontString
         local font = QTR_ToggleButton6:GetFontString()
         font:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
      end

      if (QTR_ToggleButton7 == nil) then    -- przycisk w oknie zadania
         -- przycisk z nr ID questu
         QTR_ToggleButton7 = CreateFrame("Button", nil, DUIQuestFrame, "UIPanelButtonTemplate")
         QTR_ToggleButton7:SetWidth(120)
         QTR_ToggleButton7:SetHeight(20)
         QTR_ToggleButton7:SetText("Quest ID=?")
         QTR_ToggleButton7:ClearAllPoints()
         QTR_ToggleButton7:SetPoint("TOPLEFT", DUIQuestFrame, "TOPLEFT", 295, -16)
         QTR_ToggleButton7:SetScript("OnClick", DUI_ON_OFF)
         QTR_ToggleButton7:Disable()          -- nie można na razie przyciskać przycisku
         QTR_ToggleButton7:Hide()

         -- Set smaller font size by modifying the FontString
         local font = QTR_ToggleButton7:GetFontString()
         font:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
         
      end
      
      DUIQuestFrame:HookScript("OnHide", function() QTR_ToggleButton6:Hide(); QTR_ToggleButton7:Hide(); end)
      
      if (QTR_PS["dialogueui"] == "0") then      -- jest aktywny DialogueUI, ale nie zezwolono na tłumaczenie
         return false
      else
         return true
      end
   else
      return false
   end
end

-------------------------------------------------------------------------------------------------------------------
-- Handle DUI buttons translation
function DUIPlugin.QTR_DUIbuttons()
   local DUI_AcceptButton = DUIQuestFrame.AcceptButton.Content.Name
   ST_CheckAndReplaceTranslationText(DUI_AcceptButton, true, "ui", false, true)

   local DUI_ExitButton = DUIQuestFrame.ExitButton.Content.Name
   ST_CheckAndReplaceTranslationText(DUI_ExitButton, true, "ui", false, true)
end

-------------------------------------------------------------------------------------------------------------------
-- Handle DUI quest frame dialog on/off toggling
function DUIPlugin.DUI_ON_OFF()
   if (QTR_curr_dialog == "1") then      -- Turn off translation - show original text
      QTR_curr_dialog = "0"
      QTR_ToggleButton7:SetText("Quest ID="..QTR_quest_ID.." (EN)")
      if (QTR_PS["transtitle"] == "1") then
         DUIQuestFrame.FrontFrame.Header.Title:SetFont(Original_Font1, 18)
         if (WoWTR_Localization.lang == 'AR') then
            DUIQuestFrame.FrontFrame.Header.Title:SetText(QTR_quest_EN[QTR_quest_ID].title)
            DUIQuestFrame.FrontFrame.Header.Title:SetJustifyH("LEFT")
         else
            DUIQuestFrame.FrontFrame.Header.Title:SetText(QTR_ExpandUnitInfo(QTR_quest_EN[QTR_quest_ID].title, false, QuestProgressTitleText, WOWTR_Font1))
            DUIQuestFrame.FrontFrame.Header.Title:SetJustifyH("LEFT")
         end         
      end
   else                                  -- Show translation
      QTR_curr_dialog = "1"
      QTR_ToggleButton7:SetText("Quest ID="..QTR_quest_ID.." ("..QTR_lang..")")
      if (QTR_PS["transtitle"] == "1") then
         DUIQuestFrame.FrontFrame.Header.Title:SetFont(WOWTR_Font1, 18)
         if (WoWTR_Localization.lang == 'AR') then
            DUIQuestFrame.FrontFrame.Header.Title:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].title, false, QuestProgressTitleText, WOWTR_Font1))
            DUIQuestFrame.FrontFrame.Header.Title:SetJustifyH("RIGHT")
         else
            DUIQuestFrame.FrontFrame.Header.Title:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].title, false, QuestProgressTitleText, WOWTR_Font1))
            DUIQuestFrame.FrontFrame.Header.Title:SetJustifyH("LEFT")
         end
      end
   end
   
   local countFontString = 0
   local function ProcessOnOff(fontString)
      countFontString = countFontString + 1
      if (QTR_curr_dialog == "1") then   -- Show translations
         fontString:SetText(DialogueUI_LN[countFontString])
         if (WoWTR_Localization.lang == 'AR') then
            fontString:SetJustifyH("RIGHT")
         else
            fontString:SetJustifyH("LEFT")
         end
      else                               -- Show original text
         fontString:SetText(DialogueUI_EN[countFontString])
         fontString:SetJustifyH("LEFT")
      end
   end
   DUIQuestFrame.fontStringPool:ProcessActiveObjects(ProcessOnOff)
end

-------------------------------------------------------------------------------------------------------------------
-- Handle DUI quest frame
function DUIPlugin.QTR_DUIQuestFrame(event)
   print("DUIPlugin.QTR_DUIQuestFrame called with event: " .. (event or "nil"))
   QTR_ToggleButton7:Show()
   QTR_ToggleButton6:Hide()
   
   print("QTR_quest_ID: " .. (QTR_quest_ID or "nil"))
   
   if (QTR_PS["transtitle"] == "1") then
      print("Setting title font and text")
      DUIQuestFrame.FrontFrame.Header.Title:SetFont(WOWTR_Font1, 18)
      if (WoWTR_Localization.lang == 'AR') then
         DUIQuestFrame.FrontFrame.Header.Title:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].title, false, QuestProgressTitleText, WOWTR_Font1))
         DUIQuestFrame.FrontFrame.Header.Title:SetJustifyH("RIGHT")
      else
         DUIQuestFrame.FrontFrame.Header.Title:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].title, false, QuestProgressTitleText, WOWTR_Font1))
         DUIQuestFrame.FrontFrame.Header.Title:SetJustifyH("LEFT")
      end
   end

   local function SplitParagraph(text)
      local tbl = {}
      if (text) then
         for v in string.gmatch(text, "[%C]+") do
            table.insert(tbl, v)
         end
      end
      return tbl
   end

   print("Processing quest text data")
   local countFontString = 0
   local offset = 0
   local objectivesNow = false
   local rewardsNow = false
   
   local det = string.gsub(QTR_quest_LG[QTR_quest_ID].details or '', 'NEW_LINE', '\n')
   det = string.gsub(det, '$b', '$B')
   det = string.gsub(det, '$B', '\n')
   det = string.gsub(det, '{B}', '\n')
   
   local pro = string.gsub(QTR_quest_LG[QTR_quest_ID].progress or '', 'NEW_LINE', '\n')
   pro = string.gsub(pro, '$b', '$B')
   pro = string.gsub(pro, '$B', '\n')
   pro = string.gsub(pro, '{B}', '\n')
   
   local com = string.gsub(QTR_quest_LG[QTR_quest_ID].completion or '', 'NEW_LINE', '\n')
   com = string.gsub(com, '$b', '$B')
   com = string.gsub(com, '$B', '\n')
   com = string.gsub(com, '{B}', '\n')
   
   print("Quest text processing completed")
   local details = SplitParagraph(det)
   local progress = SplitParagraph(pro)
   local completion = SplitParagraph(com)
   print("Details paragraphs: " .. #details)
   print("Progress paragraphs: " .. #progress)
   print("Completion paragraphs: " .. #completion)
   
   DialogueUI_LN = { }
   DialogueUI_EN = { }

   local function Process(fontString)
      print("Processing font string: " .. (fontString:GetText() or "nil"))
      countFontString = countFontString + 1
      fontString:SetSpacing(4.2)      -- Normal line spacing
      table.insert(DialogueUI_EN, fontString:GetText())    -- English version
      local _font1, _size1, _1 = fontString:GetFont()      -- Get current font and size
      fontString:SetFont(WOWTR_Font2, _size1)
      
      if (fontString:GetText() == "Objectives") then        -- "Objectives" header
         print("Found Objectives header")
         fontString:SetWidth(DUIQuestFrame.ContentFrame:GetWidth() - 70)
         fontString:SetFont(WOWTR_Font1, _size1)
         fontString:SetJustifyH("RIGHT")
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.objectives))
         objectivesNow = true
      elseif ((fontString:GetText() == "Rewards") or (fontString:GetText() == "Reward")) then       -- "Rewards" header
         print("Found Rewards header")
         fontString:SetWidth(DUIQuestFrame.ContentFrame:GetWidth() - 70)
         print("Rewards width: " .. fontString:GetWidth())
         fontString:SetFont(WOWTR_Font1, _size1)
         fontString:SetJustifyH("RIGHT")
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.rewards))
         rewardsNow = true
      elseif (fontString:GetText() == "Requirements") then       -- "Requirements" header
         print("Found Requirements header")
         fontString:SetWidth(DUIQuestFrame.ContentFrame:GetWidth() - 70)
         fontString:SetFont(WOWTR_Font1, _size1)
         fontString:SetJustifyH("RIGHT")
         fontString:SetText(QTR_ReverseIfAR(QTR_Messages.reqitems))
      else
         local firstHeight = fontString:GetHeight()
         DetailsX = details[countFontString]
         ProgressX = progress[countFontString]
         CompletionX = completion[countFontString]
         
         if (event == "QUEST_DETAIL" and DetailsX) then
            print("Processing QUEST_DETAIL text")
            if (WoWTR_Localization.lang == 'AR') then
               fontString:SetText(QTR_ExpandUnitInfo(DetailsX, false, fontString, WOWTR_Font2, -15))
               fontString:SetJustifyH("RIGHT")
            else
               fontString:SetText(QTR_ExpandUnitInfo(DetailsX, false, fontString, WOWTR_Font2))
               fontString:SetJustifyH("LEFT")
            end
         elseif (event == "QUEST_PROGRESS" and ProgressX) then
            print("Processing QUEST_PROGRESS text")
            if (WoWTR_Localization.lang == 'AR') then
               fontString:SetText(QTR_ExpandUnitInfo(ProgressX, false, fontString, WOWTR_Font2, -15))
               fontString:SetJustifyH("RIGHT")
            else
               fontString:SetText(QTR_ExpandUnitInfo(ProgressX, false, fontString, WOWTR_Font2))
               fontString:SetJustifyH("LEFT")
            end
         elseif (event == "QUEST_COMPLETE" and CompletionX) then
            print("Processing QUEST_COMPLETE text")
            if (WoWTR_Localization.lang == 'AR') then
               fontString:SetText(QTR_ExpandUnitInfo(CompletionX, false, fontString, WOWTR_Font2, -15))
               fontString:SetJustifyH("RIGHT")
            else
               fontString:SetText(QTR_ExpandUnitInfo(CompletionX, false, fontString, WOWTR_Font2))
               fontString:SetJustifyH("LEFT")
            end
         elseif (objectivesNow) then
            print("Processing Objectives text")
            if (WoWTR_Localization.lang == 'AR') then
               fontString:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].objectives, false, fontString, WOWTR_Font2, -15))
               fontString:SetJustifyH("RIGHT")
               objectivesNow = false        -- Objectives is in one long row?
            else
               fontString:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].objectives, false, fontString, WOWTR_Font2))
               fontString:SetJustifyH("LEFT")
               objectivesNow = false        -- Objectives is in one long row?
            end
         elseif (rewardsNow) then
            print("Processing Rewards text")
            if (WoWTR_Localization.lang == 'AR') then
               fontString:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].itemreceive, false, fontString, WOWTR_Font2))
               fontString:SetJustifyH("RIGHT")
               rewardsNow = false        -- Rewards is in one long row?
            else
               fontString:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].itemreceive, false, fontString, WOWTR_Font2))
               fontString:SetJustifyH("LEFT")
               rewardsNow = false        -- Rewards is in one long row?
            end
         end
         
         local secondHeight = fontString:GetHeight()
         offset = secondHeight - firstHeight
         local counter0 = 0
         while ((offset > 0) and (counter0 < 6)) do
            counter0 = counter0 + 1
            fontString:SetSpacing(fontString:GetSpacing() * firstHeight / secondHeight)  -- Change line spacing
            secondHeight = fontString:GetHeight()
            offset = secondHeight - firstHeight
         end
      end
      table.insert(DialogueUI_LN, fontString:GetText())    -- Translated version
   end
   
   print("Processing active font strings")
   DUIQuestFrame.fontStringPool:ProcessActiveObjects(Process)
   QTR_curr_dialog = "1"           -- Translation is currently displayed
   print("Font string processing complete")

   local function ProcessBG(element)
      element:SetWidth(DUIQuestFrame.ContentFrame:GetWidth() -70)
   end
   print("Processing background elements")
   DUIQuestFrame.textBackgroundPool:ProcessActiveObjects(ProcessBG)
   
   if (TT_PS["ui1"] == "1") then
      print("Calling QTR_DUIbuttons")
      DUIPlugin.QTR_DUIbuttons()
   end
   
   print("QTR_DUIQuestFrame function completed")
end

-- Return the plugin
return DUIPlugin