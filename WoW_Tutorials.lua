-- Addon: WoWTR-Tutorials (version: 10.T9) 2024.01.22
-- Description: The AddOn displays the translated text information in chosen language
-- Author: Platine
-- E-mail: platine.wow@gmail.com

-------------------------------------------------------------------------------------------------------

-- Zmienne Globalne
local _G = _G;
local tutMainFrameShow = 0;           -- znacznik przypisania skryptu od wyświetlenia okienka tutoriału
local tutWalkShow = 0;                -- znacznik przypisania skryptu od wyświetlenia okienka tutoriału
local tutKeyboardMouseFrameShow = 0;  -- znacznik przypisania skryptu od wyświetlenia okienka tutoriału
local tutSingleKeyShow = 0;           -- znacznik przypisania skryptu od wyświetlenia okienka tutoriału
local TT_firstUse = 0;
local aktShow = {};                   -- tablica aktualnie przypisanych zdarzeń OnShow do NPE_PointerFrame
for i=1,20,1 do
   aktShow[i] = 0;
end

-------------------------------------------------------------------------------------------------------

function TT_onTutorialShow()          -- główna funkcja wywoływana, gdy pojawi się tekst tutorial
   if (TT_PS["active"] == "1") then
      local obj,txt,id;
      obj = "TutorialMainFrame_Frame";
      if (_G[obj]) then
         if (tutMainFrameShow==0) then
            _G[obj].ContainerFrame:SetScript("OnUpdate", TT_onTutorialShow_Time);
            tutMainFrameShow = 1;
         end
      end
      
      obj = "TutorialWalk_Frame";
      if (_G[obj]) then
         if (tutWalkShow==0) then
            _G[obj]:SetScript("OnUpdate", TT_onTutorialShow_Time);
            tutWalkShow = 1;
         end
      end
      
      obj = "TutorialKeyboardMouseFrame_Frame";
      if (_G[obj]) then
         if (tutKeyboardMouseFrameShow==0) then
           _G[obj]:SetScript("OnUpdate", TT_onTutorialShow_Time);
            tutKeyboardMouseFrameShow = 1;
         end
      end
      
      obj = "TutorialSingleKey_Frame";
      if (_G[obj]) then
         if (tutSingleKeyShow==0) then
            _G[obj]:SetScript("OnUpdate", TT_onTutorialShow_Time);
            tutSingleKeyShow = 1;
         end
      end
      TT_SprawdzFrames();
      
      for i=1,20,1 do
         obj = "TutorialPointerFrame_"..tostring(i).."Content";
         if (_G[obj]) then
            if (aktShow[i]==0) then
               _G[obj]:SetScript("OnUpdate", TT_onTutorialShow);
               aktShow[i] = 1;
            end
            if ((_G[obj]:IsVisible()) and (_G[obj].Text)) then
               txt = _G[obj].Text:GetText();
               if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
                  id = StringHash(txt);
                  if (Tut_Data7[id]) then         -- jest tureckie tłumaczenie w bazie tłumaczeń
                     local _font5, _size5, _35 = _G[obj].Text:GetFont();
                     _G[obj].Text:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[id])).." ");  -- podmieniamy tekst na nasze tłumaczenie
                     _G[obj].Text:SetFont(WOWTR_Font2, _size5);      -- na końcu dodajemy twardą spację, jako znacznik tekstu tureckiego
                  elseif (TT_PS["save"] == "1") then
                     TT_TUTORIALS[tostring(id)] = txt;
                  end
               end
            end
         end
      end
   end
end

-------------------------------------------------------------------------------------------------------

function TT_SprawdzFrames()
   local obj,txt,id;
   obj = "TutorialMainFrame_Frame";
   if ((_G[obj]) and (_G[obj].ContainerFrame) and (_G[obj].ContainerFrame:IsVisible()) and (_G[obj].ContainerFrame.Text)) then
      txt = _G[obj].ContainerFrame.Text:GetText();            -- odczytaj tekst oryginalny
      if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
         id = StringHash(txt);
         if (Tut_Data7[id]) then                    -- jest tureckie tłumaczenie w bazie tłumaczeń
            local _font5, _size5, _35 = _G[obj].ContainerFrame.Text:GetFont();
            _G[obj].ContainerFrame.Text:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[id])).." ");  -- podmieniamy tekst na nasze tłumaczenie
            _G[obj].ContainerFrame.Text:SetFont(WOWTR_Font2, _size5);
            _G[obj].ContainerFrame.Text:SetHeight(150);
         elseif (TT_PS["save"] == "1") then
            TT_TUTORIALS[tostring(id)] = txt;
         end
      end
   end
   obj = "TutorialWalk_Frame";
   if ((_G[obj]) and (_G[obj].ContainerFrame) and (_G[obj].ContainerFrame:IsVisible()) and (_G[obj].ContainerFrame.Text)) then
      txt = _G[obj].ContainerFrame.Text:GetText();            -- odczytaj tekst oryginalny
      if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
         id = StringHash(txt);
         if (Tut_Data7[id]) then                    -- jest tureckie tłumaczenie w bazie tłumaczeń
            local _font5, _size5, _35 = _G[obj].ContainerFrame.Text:GetFont();
            _G[obj].ContainerFrame.Text:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[id])).." ");  -- podmieniamy tekst na nasze tłumaczenie
            _G[obj].ContainerFrame.Text:SetFont(WOWTR_Font2, _size5);
            _G[obj].ContainerFrame.Text:SetHeight(150);
         elseif (TT_PS["save"] == "1") then
            TT_TUTORIALS[tostring(id)] = txt;
         end
      end
   end
   obj = "TutorialKeyboardMouseFrame_Frame";
   if ((_G[obj]) and (_G[obj]:IsVisible()) and (_G[obj].Text)) then
      txt = _G[obj].Text:GetText();               -- odczytaj tekst oryginalny
      if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
         id = StringHash(txt);
         if (Tut_Data7[id]) then         -- jest tureckie tłumaczenie w bazie tłumaczeń
            local _font5, _size5, _35 = _G[obj].Text:GetFont();
            _G[obj].Text:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[id])).." ");                 -- podmieniamy tekst na nasze tłumaczenie
            _G[obj].Text:SetFont(WOWTR_Font2, _size5);
--            _G[obj].Text:SetHeight(150);
         elseif (TT_PS["save"] == "1") then
            TT_TUTORIALS[tostring(id)] = txt;
         end
      end
   end
   obj = "TutorialSingleKey_Frame";
   if ((_G[obj]) and (_G[obj].ContainerFrame) and (_G[obj].ContainerFrame:IsVisible()) and (_G[obj].ContainerFrame.Text)) then
      txt = _G[obj].ContainerFrame.Text:GetText();            -- odczytaj tekst oryginalny
      if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
         id = StringHash(txt);
         if (Tut_Data7[id]) then                    -- jest tureckie tłumaczenie w bazie tłumaczeń
            local _font5, _size5, _35 = _G[obj].ContainerFrame.Text:GetFont();
            _G[obj].ContainerFrame.Text:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[id])).." ");   -- podmieniamy tekst na nasze tłumaczenie
            _G[obj].ContainerFrame.Text:SetFont(WOWTR_Font2, _size5);
            _G[obj].ContainerFrame.Text:SetHeight(150);
         elseif (TT_PS["save"] == "1") then
            TT_TUTORIALS[tostring(id)] = txt;
         end
      end
   end
   
--   if (UIParent:GetNumChildren()>0) then
--      for i = 1, UIParent:GetNumChildren() do
--         local child = select(i, select(i, UIParent:GetChildren()))
--print(child:GetName());         
--         if (child:GetObjectType() == "Frame") and (child.String) and (child.Center) then
         -- This is hopefully the frame with the content
--            for i = 1, child:GetNumRegions() do
--               local region = select(i, child:GetRegions());
--               if (region and not region:GetName() and region:IsVisible() and region.GetText) then
--print(region:GetText());
--               end
--            end
--         end
--      end
--   end
               
--   for uiframe in UIParent:EnumerateActive() do
--      if (uiframe.Text) then
--print(uiparent.Text):GetText();
--      end
--   end
end

-------------------------------------------------------------------------------------------------------

function TT_onTutorialShow_Time()         -- wywoływane przez zdarzenia OnUpdate obiektów tutorial
   if (not WOWTR_wait(0.2,TT_onTutorialShow)) then
      -- opóźnienie 0.2 sek
   end
end

-------------------------------------------------------------------------------------------------------

function TT_onChoiceDelay()
   if (TT_PS["active"] == "1") then
      if (not WOWTR_wait(0.5,TT_onChoiceShow)) then
         -- opóźnienie 0.5 sek
      end
   end
end

-------------------------------------------------------------------------------------------------------

function TT_onChoiceOpen()
   PlayerChoiceFrame:Show();
end

-------------------------------------------------------------------------------------------------------

function TT_onChoiceShow()
   local txt = PlayerChoiceFrame.Title.Text:GetText();     -- tutuł tablicy wyboru
   if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
      local hash = StringHash(txt);
      if (Tut_Data7[hash]) then                  -- jest tureckie tłumaczenie w bazie tłumaczeń
         local _font6, _size6, _36 = PlayerChoiceFrame.Title.Text:GetFont();
         PlayerChoiceFrame.Title.Text:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash])).." ");  -- podmieniamy tekst na nasze tłumaczenie
         PlayerChoiceFrame.Title.Text:SetFont(WOWTR_Font2, _size6);     -- na końcu dodajemu twardą spację jako znacznik tekstu tureckiego
      elseif (TT_PS["save"] == "1") then
         TT_TUTORIALS[tostring(hash)] = txt;
      end
   end   
   if (PlayerChoiceFrame.Option1) then
      if (PlayerChoiceFrame.Option1.OptionText) then
         local obj = PlayerChoiceFrame.Option1.OptionText.HTML:GetRegions();
         txt = obj:GetText();
         if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
            txt = string.gsub(txt, '\r', '');         -- usuń \r, ale pozostaw \n
            hash= StringHash(txt);
            if (Tut_Data7[hash]) then       -- jest tłumacznie tego tekstu
               local _font7, _size7, _37 = obj:GetFont();
               obj:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash])).." ");  -- podmieniamy tekst na nasze tłumaczenie + twarda spacja
               obj:SetFont(WOWTR_Font2, _size7);
            elseif (TT_PS["save"] == "1") then
               TT_TUTORIALS[tostring(hash)] = txt;
            end
         end
      end
      if (PlayerChoiceFrame.Option1.OptionButtonsContainer.button1) then      -- przycisk
         local obj = PlayerChoiceFrame.Option1.OptionButtonsContainer.button1;
         txt = obj:GetText();
         if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
            hash= StringHash(txt);
            if (Tut_Data7[hash]) then       -- jest tłumacznie tego tekstu
               local _font7, _size7, _37 = obj.Text:GetFont();
               obj:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash])).." ");  -- podmieniamy tekst na nasze tłumaczenie + twarda spacja
               obj.Text:SetFont(WOWTR_Font2, _size7);
            elseif (TT_PS["save"] == "1") then
               TT_TUTORIALS[tostring(hash)] = txt;
            end
         end
      end
   end
   
   if (PlayerChoiceFrame.Option2) then
      if (PlayerChoiceFrame.Option2.OptionText) then
         local obj = PlayerChoiceFrame.Option2.OptionText.HTML:GetRegions();
         txt = obj:GetText();
         if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
            txt = string.gsub(txt, '\r', '');         -- usuń \r, ale pozostaw \n
            hash= StringHash(txt);
            if (Tut_Data7[hash]) then       -- jest tłumacznie tego tekstu
               local _font7, _size7, _37 = obj:GetFont();
               obj:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash])).." ");  -- podmieniamy tekst na nasze tłumaczenie + twarda spacja
               obj:SetFont(WOWTR_Font2, _size7);
            elseif (TT_PS["save"] == "1") then
               TT_TUTORIALS[tostring(hash)] = txt;
            end
         end
      end
      if (PlayerChoiceFrame.Option2.OptionButtonsContainer.button1) then      -- przycisk
         local obj = PlayerChoiceFrame.Option2.OptionButtonsContainer.button1;
         txt = obj:GetText();
         if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
            hash= StringHash(txt);
            if (Tut_Data7[hash]) then       -- jest tłumacznie tego tekstu
               local _font7, _size7, _37 = obj.Text:GetFont();
               obj:SetText(QTR_ReverseIfAR(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash]))).." ");  -- podmieniamy tekst na nasze tłumaczenie + twarda spacja
               obj.Text:SetFont(WOWTR_Font2, _size7);
            elseif (TT_PS["save"] == "1") then
               TT_TUTORIALS[tostring(hash)] = txt;
            end
         end
      end
   end
   
   if (PlayerChoiceFrame.Option3) then
      if (PlayerChoiceFrame.Option3.OptionText) then
         local obj = PlayerChoiceFrame.Option3.OptionText.HTML:GetRegions();
         txt = obj:GetText();
         if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
            txt = string.gsub(txt, '\r', '');         -- usuń \r, ale pozostaw \n
            hash= StringHash(txt);
            if (Tut_Data7[hash]) then       -- jest tłumacznie tego tekstu
               local _font7, _size7, _37 = obj:GetFont();
               obj:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash])).." ");  -- podmieniamy tekst na nasze tłumaczenie + twarda spacja
               obj:SetFont(WOWTR_Font2, _size7);
            elseif (TT_PS["save"] == "1") then
               TT_TUTORIALS[tostring(hash)] = txt;
            end
         end
      end
      if (PlayerChoiceFrame.Option3.OptionButtonsContainer.button1) then      -- przycisk
         local obj = PlayerChoiceFrame.Option3.OptionButtonsContainer.button1;
         txt = obj:GetText();
         if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
            hash= StringHash(txt);
            if (Tut_Data7[hash]) then       -- jest tłumacznie tego tekstu
               local _font7, _size7, _37 = obj.Text:GetFont();
               obj:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash])).." ");  -- podmieniamy tekst na nasze tłumaczenie + twarda spacja
               obj.Text:SetFont(WOWTR_Font2, _size7);
            elseif (TT_PS["save"] == "1") then
               TT_TUTORIALS[tostring(hash)] = txt;
            end
         end
      end  
   end
   if (TT_firstUse == 0) then      -- pierwsze uruchomienie - trzeba jeszcze raz przeładować ramkę
      TT_firstUse = 1;
      PlayerChoiceFrame:Hide();
      UIErrorsFrame:AddMessage(WoWTR_Localization.reopenBoard, 1,0.5,1);
      local regions = { UIErrorsFrame:GetRegions() };     -- poszukiwanie obiektu FontString do ustawienia własnej czcionki
      for k, v in pairs(regions) do
         if (v:GetObjectType() == "FontString") then
            v:SetFont(WOWTR_Font2, 15);
         end
      end
   else
      for frame in PlayerChoiceFrame.optionPools:EnumerateActive() do
         if (frame.OptionText) then
            local obj = frame.OptionText.HTML:GetRegions();
            if (obj) then
               txt = obj:GetText();
               if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
                  txt = string.gsub(txt, '\r', '');         -- usuń \r, ale pozostaw \n
                  hash= StringHash(txt);
                  if (Tut_Data7[hash]) then       -- jest tłumacznie tego tekstu
                     local _font7, _size7, _37 = obj:GetFont();
                     obj:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash])).." ");  -- podmieniamy tekst na nasze tłumaczenie + twarda spacja
                     obj:SetFont(WOWTR_Font2, _size7);
                  elseif (TT_PS["save"] == "1") then
                     TT_TUTORIALS[tostring(hash)] = txt;
                  end
               end
            end
         end
      end
   end
end

-------------------------------------------------------------------------------------------------------

function TT_Spr_Gender(msg)
   local nr_1, nr_2, nr_3 = 0;
   local TT_forma = "";
   
   msg = string.gsub(msg,"$g","$G");
   local nr_poz = string.find(msg, "$G");    -- gdy nie znalazł, jest: nil; liczy od 1
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do   -- szukaj nawiasu otwierającego
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do   -- szukaj średnika oddzielającego
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do   -- szykaj nawiasu zamykającego
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (WOWTR_player_sex==3) then        -- forma żeńska
                  TT_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma męska
                  TT_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. TT_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "$G");
   end

   msg = string.gsub(msg,"$o","$O");
   local nr_poz = string.find(msg, "$O");    -- gdy nie znalazł, jest: nil; liczy od 1
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (QTR_PS["ownname"] == "1") then        -- forma polska
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                                      -- forma angielska
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "$O");
   end

   return msg;
end

-------------------------------------------------------------------------------------------------------

function TT_CampaignOverview()
   local frame;
   local frames_tab = { };
   local height_tab = { };
   for frame in QuestMapFrame.CampaignOverview.linePool:EnumerateActive() do
      local txt = frame:GetText();
      local HashCode = StringHash(txt);
      local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1);
      if (Tut_Data7[HashCode]) then
         frame:SetText(QTR_ReverseIfAR(Tut_Data7[HashCode]));
         if (string.len(Tut_Data7[HashCode]) < 30) then
            frame:SetFont(WOWTR_Font2, 13);
         else
            frame:SetFont(WOWTR_Font2, 12);
         end
      elseif (TT_PS["save"] == "1") then
         TT_TUTORIALS[tostring(HashCode)] = txt;
      end
      frames_tab[yOfs] = frame;
      height_tab[yOfs] = frame:GetHeight();
   end
   
   -- Obliczanie nowych pozycji przesunięcie elementów
   local tkeys = { };
   for k in pairs(frames_tab) do table.insert(tkeys, k) end;
   table.sort(tkeys, function(a, b) return a > b; end);     -- sortuj tablicę malejąco
   local last_rel = 0;
   for _, k in ipairs(tkeys) do     -- przeglądaj poszczególne elementy
      if (last_rel == 0) then       -- pierwszy element
         last_rel = - height_tab[k] - 22;        -- pocz. przesun. - height elementu - 12px
      else
         local point, relativeTo, relativePoint, xOfs, yOfs = frames_tab[k]:GetPoint(1);
         frames_tab[k]:ClearAllPoints();
         frames_tab[k]:SetPoint(point, relativeTo, relativePoint, xOfs, last_rel);
         last_rel = last_rel - height_tab[k] - 12;
      end
   end;
end

-------------------------------------------------------------------------------------------------------

if ((GetLocale()=="enUS") or (GetLocale()=="enGB")) then
   hooksecurefunc(HelpTip,"Show", 
   function(self)
      if (TT_PS["active"] == "1") then
         local frame;
         for frame in self.framePool:EnumerateActive() do
            if frame.info.system == "MicroButtons" then
               local txt = frame.Text:GetText();
               if ((txt) and (string.find(txt," ")==nil)) then         -- nie jest to tekst po turecku (nie ma twardej spacji)
                  local hash= StringHash(txt);
                  if (Tut_Data7[hash]) then                  -- jest tłumacznie tego tekstu
                     local _font8, _size8, _38 = frame.Text:GetFont();
                     frame.Text:SetText(QTR_ReverseIfAR(TT_Spr_Gender(Tut_Data7[hash])).." ");  -- podmieniamy tekst na nasze tłumaczenie
                     frame.Text:SetFont(WOWTR_Font2, _size8);        -- na końcu dodajemy twardą spację, jako znacznik tekstu tureckiego
                  elseif (TT_PS["save"] == "1") then
                     TT_TUTORIALS[tostring(hash)] = txt;
                  end
               end
            end
         end
      end
   end
   );
end