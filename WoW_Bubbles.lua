-- Addon: WoWTR-Bubbles (version: 10.B15) 2024.02.01
-- Description: The AddOn displays the translated text information in chosen language
-- Author: Platine
-- E-mail: platine.wow@gmail.com

-------------------------------------------------------------------------------------------------------

-- General Variables
BB_ctrFrame = CreateFrame("FRAME", "WoWTR-BubblesFrame");
BB_BubblesArray = {};
Y_Race1=UnitRace("player");
Y_Race2=string.lower(UnitRace("player"));
Y_Race3=string.upper(UnitRace("player"));
Y_Class1=UnitClass("player");
Y_Class2=string.lower(UnitClass("player"));
Y_Class3=string.upper(UnitClass("player"));
local BB_TRvisible= 0;
local BB_Zatrzask = 0;
local BB_name_NPC = "";
local BB_hash_Code= "";
local BB_bufor = {};
local BB_gotowe= {};
local BB_ile_got = 0;

-------------------------------------------------------------------------------------------------------

function BB_FindProS(text)                 -- znajdź, czy jest tekst '%s' w podanym tłumaczeniu
   local dl_txt = string.len(text)-1;
   for i_j=1,dl_txt,1 do
      if (strsub(text,i_j,i_j+1)=="%s") then       
         return i_j;
      end
   end
   return 0;
end

-------------------------------------------------------------------------------------------------------

function BB_bubblizeText()
   if (TalkingHeadFrame and TalkingHeadFrame:IsVisible()) then
      for idx, iArray in ipairs(BB_BubblesArray) do      -- sprawdź, czy dane są właściwe (tekst oryg. się zgadza z zapisaną w tablicy)
         if (TalkingHeadFrame.TextFrame.Text:GetText() ==  iArray[1]) then
            local _font1, _size1, _3 = TalkingHeadFrame.TextFrame.Text:GetFont(); -- odczytaj aktualną czcionkę i rozmiar
            TalkingHeadFrame.TextFrame.Text:SetFont(WOWTR_Font2, _size1);         -- wpisz czcionkę
            TalkingHeadFrame.TextFrame.Text:SetText(QTR_ExpandUnitInfo(iArray[2],false,TalkingHeadFrame.TextFrame.Text,WOWTR_Font2));  -- wpisz tłumaczenie
            tremove(BB_BubblesArray, idx);               -- usuń zapamiętane dane z tablicy
         end
      end
   else
      if (#C_ChatBubbles.GetAllChatBubbles(true) == #C_ChatBubbles.GetAllChatBubbles()) then      -- normalny dymek, nie w lochach
         for _, bubble in pairs(C_ChatBubbles.GetAllChatBubbles(true)) do
         -- Iterate the children, as the actual bubble content 
         -- has been placed in a nameless subframe in 9.0.1.
            for i = 1, bubble:GetNumChildren() do
               local child = select(i, select(i, bubble:GetChildren()))
               if not child:IsForbidden() then                       -- czy ramka nie jest zabroniona?
                  if child and (child:GetObjectType() == "Frame") and (child.String) and (child.Center) then
                  -- This is hopefully the frame with the content
                     for i = 1, child:GetNumRegions() do
                        local region = select(i, child:GetRegions());
                        for idx, iArray in ipairs(BB_BubblesArray) do      -- sprawdź, czy dane są właściwe (tekst oryg. się zgadza z zapisaną w tablicy)
                           if region and not region:GetName() and region:IsVisible() and region.GetText and (region:GetText() == iArray[1]) then
                              local oldTextWidth = region:GetStringWidth() -- dotychczasowa szerokość okna dymku
                              local oldBubbleWidth = region:GetWidth();
                              local _font1, _size1, _3 = region:GetFont(); -- odczytaj aktualną czcionkę i rozmiar
                              if (BB_PM["setsize"]=="1") then              -- jest włączona wielkość czcionki dymku
                                 region:SetFont(WOWTR_Font2, tonumber(BB_PM["fontsize"]));   -- ustaw turecką czcionkę oraz zmienioną wielkość
--                                 region:SetWidth(region:GetWidth() * (region:GetStringWidth() / oldTextWidth) * (tonumber(_size1) / tonumber(BB_PM["fontsize"])));  -- określ nową szer. okna
                              else
                                 region:SetFont(WOWTR_Font2, _size1);             -- ustaw turecką czcionkę oraz niezmienioną wielkość (13)
                              end
                              if (region:GetWidth() < 100) then
                                 region:SetWidth(100);
                              end
                              if (region:GetWidth()>200) then
                                 region:SetText(QTR_ExpandUnitInfo(iArray[2],false,region,WOWTR_Font2,-50));         -- wpisz tu nasze tłumaczenie
                              else
                                 region:SetText(QTR_ReverseIfAR(iArray[2]));             -- wpisz tu nasze krótkie tłumaczenie
                              end
                              region:SetJustifyH("CENTER");
--                              print(oldTextWidth, region:GetStringWidth());
--                              region:SetWidth(region:GetWidth() * (region:GetStringWidth() / oldTextWidth));  -- określ nową szer. okna
--                              if (region:GetWidth() < region:GetHeight()) then
--                                 region:SetWidth(oldBubbleWidth);
--                              end
                              tremove(BB_BubblesArray, idx);               -- usuń zapamiętane dane z tablicy
                           end
                        end
                     end
                  end
               end
            end
         end
      elseif (BB_PM["dungeon"] == "1") then           -- dymek w lochach, trzeba użyć własnych okien do wyświetlenia tłumaczenia, jest pozwolenie
         for idx, iArray in ipairs(BB_BubblesArray) do      -- pobierz zapisane w tablicy teksty
            if (not WOWBB1:IsVisible()) then
               WOWBB1:SetOwner(UIParent, "ANCHOR_NONE" );
               WOWBB1:ClearAllPoints();
               WOWBB1:SetPoint("CENTER", 0, WOWBB1.vertical);
               WOWBB1:ClearLines();
               WOWBB1:AddLine(QTR_ExpandUnitInfo(iArray[2],false,WOWBB1,WOWTR_Font2), 1, 1, 1, true);
               if (BB_PM["setsize"]=="1") then              -- jest włączona wielkość czcionki dymku
                  _G["WOWBB1TextLeft1"]:SetFont(WOWTR_Font2, tonumber(BB_PM["fontsize"]));      -- wielkość czcionki
               else
                  _G["WOWBB1TextLeft1"]:SetFont(WOWTR_Font2, 13);   -- ustaw turecką czcionkę oraz niezmienioną wielkość (13)
               end
               WOWBB1:Show();
               if (WoWTR_Localization.lang == 'AR') then
                  _G["WOWBB1TextLeft1"]:SetText(QTR_ExpandUnitInfo(iArray[2],false,_G["WOWBB1TextLeft1"],WOWTR_Font2));     -- jeszcze raz ustaw tekst w szerokości ramki
--                  WOWBB1:Show();
               end
               WOWBB1.header:SetText(iArray[4]..":");
               WOWBB1.header:ClearAllPoints();
               WOWBB1.header:SetPoint("CENTER", 0, WOWBB1:GetHeight()/2+6);
               C_Timer.After(tonumber(BB_PM["timeDisplay"]), function() WOWBB1:Hide(); end);
            elseif (not WOWBB2:IsVisible()) then
               WOWBB2:SetOwner(UIParent, "ANCHOR_NONE" );
               WOWBB2:ClearAllPoints();
               WOWBB2:SetPoint("CENTER", 250, WOWBB2.vertical);
               WOWBB2:ClearLines();
               WOWBB2:AddLine(QTR_ExpandUnitInfo(iArray[2],false,WOWBB1,WOWTR_Font2), 1, 1, 1, true);
               if (BB_PM["setsize"]=="1") then              -- jest włączona wielkość czcionki dymku
                  _G["WOWBB2TextLeft1"]:SetFont(WOWTR_Font2, tonumber(BB_PM["fontsize"]));      -- wielkość czcionki
               else
                  _G["WOWBB2TextLeft1"]:SetFont(WOWTR_Font2, 13);   -- ustaw turecką czcionkę oraz niezmienioną wielkość (13)
               end
               WOWBB2:Show();
               if (WoWTR_Localization.lang == 'AR') then
                  _G["WOWBB2TextLeft1"]:SetText(QTR_ExpandUnitInfo(iArray[2],false,_G["WOWBB1TextLeft1"],WOWTR_Font2));     -- jeszcze raz ustaw tekst w szerokości ramki
--                  WOWBB2:Show();
               end
               WOWBB2.header:SetText(iArray[4]..":");
               WOWBB2.header:ClearAllPoints();
               WOWBB2.header:SetPoint("CENTER", 0, WOWBB2:GetHeight()/2+6);
               C_Timer.After(tonumber(BB_PM["timeDisplay"]), function() WOWBB2:Hide(); end);
            elseif (not WOWBB3:IsVisible()) then
               WOWBB3:SetOwner(UIParent, "ANCHOR_NONE" );
               WOWBB3:ClearAllPoints();
               WOWBB3:SetPoint("CENTER", -250, WOWBB3.vertical);
               WOWBB3:ClearLines();
               WOWBB3:AddLine(QTR_ExpandUnitInfo(iArray[2],false,WOWBB1,WOWTR_Font2), 1, 1, 1, true);
               if (BB_PM["setsize"]=="1") then              -- jest włączona wielkość czcionki dymku
                  _G["WOWBB3TextLeft1"]:SetFont(WOWTR_Font2, tonumber(BB_PM["fontsize"]));      -- wielkość czcionki
               else
                  _G["WOWBB3TextLeft1"]:SetFont(WOWTR_Font2, 13);   -- ustaw turecką czcionkę oraz niezmienioną wielkość (13)
               end
               WOWBB3:Show();
               if (WoWTR_Localization.lang == 'AR') then
                  _G["WOWBB3TextLeft1"]:SetText(QTR_ExpandUnitInfo(iArray[2],false,_G["WOWBB1TextLeft1"],WOWTR_Font2));     -- jeszcze raz ustaw tekst w szerokości ramki
--                  WOWBB3:Show();
               end
               WOWBB3.header:SetText(iArray[4]..":");
               WOWBB3.header:ClearAllPoints();
               WOWBB3.header:SetPoint("CENTER", 0, WOWBB3:GetHeight()/2+6);
               C_Timer.After(tonumber(BB_PM["timeDisplay"]), function() WOWBB3:Hide(); end);
            elseif (not WOWBB4:IsVisible()) then
               WOWBB4:SetOwner(UIParent, "ANCHOR_NONE" );
               WOWBB4:ClearAllPoints();
               WOWBB4:SetPoint("CENTER", 500, WOWBB4.vertical);
               WOWBB4:ClearLines();
               WOWBB4:AddLine(QTR_ExpandUnitInfo(iArray[2],false,WOWBB1,WOWTR_Font2), 1, 1, 1, true);
               if (BB_PM["setsize"]=="1") then              -- jest włączona wielkość czcionki dymku
                  _G["WOWBB4TextLeft1"]:SetFont(WOWTR_Font2, tonumber(BB_PM["fontsize"]));      -- wielkość czcionki
               else
                  _G["WOWBB4TextLeft1"]:SetFont(WOWTR_Font2, 13);   -- ustaw turecką czcionkę oraz niezmienioną wielkość (13)
               end
               WOWBB4:Show();
               if (WoWTR_Localization.lang == 'AR') then
                  _G["WOWBB4TextLeft1"]:SetText(QTR_ExpandUnitInfo(iArray[2],false,_G["WOWBB1TextLeft1"],WOWTR_Font2));     -- jeszcze raz ustaw tekst w szerokości ramki
--                  WOWBB4:Show();
               end
               WOWBB4.header:SetText(iArray[4]..":");
               WOWBB4.header:ClearAllPoints();
               WOWBB4.header:SetPoint("CENTER", 0, WOWBB4:GetHeight()/2+6);
               C_Timer.After(tonumber(BB_PM["timeDisplay"]), function() WOWBB4:Hide(); end);
            elseif (not WOWBB5:IsVisible()) then
               WOWBB5:SetOwner(UIParent, "ANCHOR_NONE" );
               WOWBB5:ClearAllPoints();
               WOWBB5:SetPoint("CENTER", -500, WOWBB5.vertical);
               WOWBB5:ClearLines();
               WOWBB5:AddLine(QTR_ExpandUnitInfo(iArray[2],false,WOWBB1,WOWTR_Font2), 1, 1, 1, true);
               if (BB_PM["setsize"]=="1") then              -- jest włączona wielkość czcionki dymku
                  _G["WOWBB5TextLeft1"]:SetFont(WOWTR_Font2, tonumber(BB_PM["fontsize"]));      -- wielkość czcionki
               else
                  _G["WOWBB5TextLeft1"]:SetFont(WOWTR_Font2, 13);   -- ustaw turecką czcionkę oraz niezmienioną wielkość (13)
               end
               WOWBB5:Show();
               if (WoWTR_Localization.lang == 'AR') then
                  _G["WOWBB5TextLeft1"]:SetText(QTR_ExpandUnitInfo(iArray[2],false,_G["WOWBB1TextLeft1"],WOWTR_Font2));     -- jeszcze raz ustaw tekst w szerokości ramki
--                  WOWBB5:Show();
               end
               WOWBB5.header:SetText(iArray[4]..":");
               WOWBB5.header:ClearAllPoints();
               WOWBB5.header:SetPoint("CENTER", 0, WOWBB5:GetHeight()/2+6);
               C_Timer.After(tonumber(BB_PM["timeDisplay"]), function() WOWBB5:Hide(); end);
            end
            tremove(BB_BubblesArray, idx);               -- usuń zapamiętane dane z tablicy
         end
      end
   end

   for idx, iArray in ipairs(BB_BubblesArray) do            -- przeszukaj jeszcze raz tablicę
      if (iArray[3] >= 100) then                            -- licznik osiągnął 100
         tremove(BB_BubblesArray, idx);                     -- usuń zapamiętane dane z tablicy
      else
         iArray[3] = iArray[3]+1;                           -- zwiększ licznik (nie pokazał się dymek?)
      end;
   end;
   if (#(BB_BubblesArray) == 0) then
      BB_ctrFrame:SetScript("OnUpdate", nil);               -- wyłącz metodę Update, bo tablica pusta
   end;
end;

-------------------------------------------------------------------------------------------------------

function BB_ChatFilter(self, event, arg1, arg2, arg3, _, arg5, ...)     -- wywoływana, gdy na chat ma pojawić się tekst od NPC
   if (TT_onTutorialShow) then
      TT_onTutorialShow();
   end
   local changeBubble = false;
   local colorText = "";
   local original_txt = strtrim(arg1);
   local name_NPC = string.gsub(arg2, " says:", "");
   local target = arg5;

   if (event == "CHAT_MSG_MONSTER_SAY") then          -- określ kolor tekstu do okna chat
      colorText = "|cFFFFFF9F";
      if (GetCVar("ChatBubbles")) then
         changeBubble = true;
      end
   elseif (event == "CHAT_MSG_MONSTER_PARTY") then
      colorText = "|cFFAAAAFF";
   elseif (event == "CHAT_MSG_MONSTER_YELL") then
      colorText = "|cFFFF4040";
      if (GetCVar("ChatBubbles")) then
         changeBubble = true;
      end
   elseif (event == "CHAT_MSG_MONSTER_WHISPER") then
      colorText = "|cFFFFB5EB";
   elseif (event == "CHAT_MSG_MONSTER_EMOTE") then
      colorText = "|cFFFF8040";
   end

   BB_is_translation = "0";      
   if (BB_PM["active"] == "1") then                       -- dodatek aktywny - szukaj tłumaczenia
      local Origin_Text = original_txt;
      if (arg5 and (arg5 ~= "")) then
         Origin_Text = WOWTR_DetectAndReplacePlayerName(Origin_Text, arg5);
      else
         Origin_Text = WOWTR_DetectAndReplacePlayerName(Origin_Text);
      end
      local Czysty_Text = WOWTR_DeleteSpecialCodes(Origin_Text);
      if (string.sub(name_NPC,1,17) == "Bronze Timekeeper") then    -- wyścigi na smokach - wyjątek z sekundami
         Czysty_Text = string.gsub(Czysty_Text, "0", "");
         Czysty_Text = string.gsub(Czysty_Text, "1", "");
         Czysty_Text = string.gsub(Czysty_Text, "2", "");
         Czysty_Text = string.gsub(Czysty_Text, "3", "");
         Czysty_Text = string.gsub(Czysty_Text, "4", "");
         Czysty_Text = string.gsub(Czysty_Text, "5", "");
         Czysty_Text = string.gsub(Czysty_Text, "6", "");
         Czysty_Text = string.gsub(Czysty_Text, "7", "");
         Czysty_Text = string.gsub(Czysty_Text, "8", "");
         Czysty_Text = string.gsub(Czysty_Text, "9", "");
      end
      local HashCode = StringHash(Czysty_Text);
      if (BB_Bubbles[HashCode]) then         -- jest tłumaczenie tureckie
         newMessage = BB_Bubbles[HashCode];
         newMessage = WOW_ZmienKody(newMessage,arg5);
         if (string.sub(name_NPC,1,17) == "Bronze Timekeeper") then       -- wyścigi na smokach - wyjątej z sekundami: $1.$2 oraz $3.$4
            local wartab = {0,0,0,0,0,0};                                 -- max. 6 liczb całkowitych w tekście
            local arg0 = 0;
            for w in string.gmatch(strtrim(arg1), "%d+") do
               arg0 = arg0 + 1;
               if (math.floor(w)>999999) then
                  wartab[arg0] = tostring(math.floor(w)):reverse():gsub("(%d%d%d)(%d%d%d)", "%1.%2."):gsub("(%-?)$", "%1"):reverse();   -- tu mamy kolejne cyfry z oryginału
               elseif (math.floor(w)>99999) then
                  wartab[arg0] = tostring(math.floor(w)):reverse():gsub("(%d%d%d)(%d%d%d)", "%1.%2"):gsub("(%-?)$", "%1"):reverse();   -- tu mamy kolejne cyfry z oryginału
               elseif (math.floor(w)>999) then
                  wartab[arg0] = tostring(math.floor(w)):reverse():gsub("(%d%d%d)", "%1."):gsub("(%-?)$", "%1"):reverse();   -- tu mamy kolejne cyfry z oryginału
               else   
                  wartab[arg0] = w;      -- tu mamy kolejne liczby całkowite z oryginału
               end
            end;
            if (arg0>5) then
               newMessage=string.gsub(newMessage, "$6", wartab[6]);
            end
            if (arg0>4) then
               newMessage=string.gsub(newMessage, "$5", wartab[5]);
            end
            if (arg0>3) then
               newMessage=string.gsub(newMessage, "$4", wartab[4]);
            end
            if (arg0>2) then
               newMessage=string.gsub(newMessage, "$3", wartab[3]);
            end
            if (arg0>1) then
               newMessage=string.gsub(newMessage, "$2", wartab[2]);
            end
            if (arg0>0) then
               newMessage=string.gsub(newMessage, "$1", wartab[1]);
            end
         end
         BB_is_translation="1";      
         nr_poz=BB_FindProS(newMessage,1);
         local mark_AI = "";
         if (BB_AI and BB_AI[HashCode]) then
            mark_AI = " |c0000FFFF(AI)|r";
         end
         if (BB_PM["chat-tr"] == "1") then                -- wyświetlaj tłumaczenie w linii czatu
            local _fontC, _sizeC, _C = DEFAULT_CHAT_FRAME:GetFont();   -- odczytaj aktualną czcionkę, rozmiar i typ
            if (WoWTR_Localization.lang ~= 'TR') then
               DEFAULT_CHAT_FRAME:SetFont(WOWTR_Font2, _sizeC, _C);       -- załaduj narodową czcionkę
            end
            if (nr_poz>0) then           -- mamy formę opisową dymku %s np. NPC_name wpada w szał!
               if (nr_poz==1) then
                  newMessage = name_NPC..strsub(newMessage, 3);
               else
                  newMessage = strsub(newMessage,1,nr_poz-1)..name_NPC..strsub(newMessage, nr_poz+2);
               end
               DEFAULT_CHAT_FRAME:AddMessage(colorText..QTR_ExpandUnitInfo(newMessage,false,DEFAULT_CHAT_FRAME,WOWTR_Font2,-50)..mark_AI);
            elseif (strsub(newMessage,1,2)=="%o") then         -- jest forma '%o'
               newMessage = strsub(newMessage, 3);
               DEFAULT_CHAT_FRAME:AddMessage(colorText..QTR_ExpandUnitInfo(newMessage:gsub("^%s*", ""),false,DEFAULT_CHAT_FRAME,WOWTR_Font2,-50)..mark_AI); -- usuń białe spacje na początku
            else
               if (WoWTR_Localization.lang == 'AR') then
                  DEFAULT_CHAT_FRAME:AddMessage(colorText..QTR_ExpandUnitInfo("{r}"..WOWTR_AnsiReverse(name_NPC)..":{cFFFFFFFF} "..newMessage,false,DEFAULT_CHAT_FRAME,WOWTR_Font2,-10));
               else
                  DEFAULT_CHAT_FRAME:AddMessage(colorText.."|cCCDDEEFF"..name_NPC..":|r "..QTR_ExpandUnitInfo(newMessage,false,DEFAULT_CHAT_FRAME,WOWTR_Font2,-100)..mark_AI);   -- mówi (diyor ki)
               end
            end
         else   
            if (nr_poz>0) then        -- mamy formę opisową dymku np. NPC_name coś robi.
               if (nr_poz==1) then
                  newMessage = name_NPC..strsub(newMessage, 3);
               else
                  newMessage = strsub(newMessage,1,nr_poz-1)..name_NPC..strsub(newMessage, nr_poz+2);
               end
            elseif (strsub(newMessage,1,2)=="%o") then         -- jest forma '%o'
               newMessage = strsub(newMessage, 3);
            end
         end
         if (changeBubble) then                          -- wyświetlaj dymek po turecku (jeśli istnieje)
            tinsert(BB_BubblesArray, { [1] = arg1, [2] = newMessage, [3] = 1, [4] = name_NPC });
            BB_ctrFrame:SetScript("OnUpdate", BB_bubblizeText);
         end
      else                                               -- nie mamy tłumaczenia
         if (BB_PM["saveNB"] == "1") then                -- zapisz oryginalny tekst - jest pozwolenie
            local Origin_Text = strtrim(arg1);                   -- jeszcze raz wczytaj pełny tekst angielski
            if (arg5 and (arg5 ~= "")) then
               Origin_Text = WOWTR_DetectAndReplacePlayerName(Origin_Text, arg5);
            else
               Origin_Text = WOWTR_DetectAndReplacePlayerName(Origin_Text);
            end
            BB_PS[name_NPC..":"..tostring(HashCode)] = Origin_Text.."@"..target..":"..WOWTR_player_name..":"..WOWTR_player_race..":"..WOWTR_player_class;
         end
         if (BB_PM["TRonline"] == "1") then              -- tłumaczenie online
            local pomoc = name_NPC.."@"..tostring(HashCode).."@"..original_txt;
            local jest = 0;
            for ind=1,BB_ile_got,1 do             -- sprawdź czy taki dymek jest już w gotowych
               if (BB_gotowe[ind] == pomoc) then
                  jest = 1;
               end
            end
            if (jest == 0) then
               if (BB_Zatrzask == 0) then                   -- bufor pusty
                  BB_Input1:SetText(original_txt);
                  BB_Input2:SetText("");
                  BB_Zatrzask = 1;
                  BB_ButtonZatrz:SetText("X");
                  BB_name_NPC = name_NPC;
                  BB_hash_Code= tostring(HashCode);
                  BB_bufor[BB_Zatrzask] = name_NPC.."@"..tostring(HashCode).."@"..original_txt;
               else
                  for ind=1,BB_Zatrzask,1 do             -- sprawdź czy jest już taki dymek w buforze
                     if (BB_bufor[ind] == pomoc) then
                        jest = 1;
                     end
                  end
                  if (jest == 0) then        -- nie ma jeszcze w buforze
                     BB_Zatrzask = BB_Zatrzask + 1;
                     BB_bufor[BB_Zatrzask] = pomoc;
                     BB_ButtonZatrz:SetText(tostring(BB_Zatrzask));
                  end
               end
            end
         end
      end
   end

   TT_onTutorialShow();
   if ((BB_PM["chat-en"] == "1") or (BB_is_translation ~= "1")) then     -- gdy nie ma także tłumaczenia                 
      return false;     -- wyświetlaj tekst oryginalny w oknie czatu
   else
      return true;      -- nie wyświetlaj oryginalnego tekstu
   end   
   
end

-------------------------------------------------------------------------------------------------------

function BB_ShowTRonline()
   if (BB_TRvisible == 0) then
      BB_TRvisible = 1;
      BB_Button8Save:Show();
      BB_Input1:Show();
      BB_Input2:Show();
      BB_ButtonZatrz:Show();
   else
      BB_TRvisible = 0;
      BB_Button8Save:Hide();
      BB_Input1:Hide();
      BB_Input2:Hide();
      BB_ButtonZatrz:Hide();
   end   
end

-------------------------------------------------------------------------------------------------------

function BB_TRzatrzask()                  -- wciśnięto przycisk zwolnienia zatrzasku
   if (BB_Zatrzask > 0) then
      BB_Zatrzask = BB_Zatrzask - 1;
      if (BB_Zatrzask == 0) then
         BB_ButtonZatrz:SetText("O");
      else
         for ind=1,BB_Zatrzask,1 do
            BB_bufor[ind] = BB_bufor[ind+1];
         end
         BB_bufor[BB_Zatrzask+1] = "";
         local p1,p2,p3 = strsplit("@",BB_bufor[1]);
         BB_Input1:SetText(p3);
         if (BB_Zatrzask == 1) then
            BB_ButtonZatrz:SetText("X");
         else
            BB_ButtonZatrz:SetText(tostring(BB_Zatrzask));
         end
      end
   else   
      BB_Input1:SetText("czekam na tekst oryginalny z nieprzetlumaczonego dymku");
   end
   BB_Input2:SetText("");
end
  
-------------------------------------------------------------------------------------------------------

function BB_ShowTRsave()
   if (BB_Input2:GetText() == "") then
      BB_Input2:SetText("?? - a gdzie tłumaczenie - ??");
   else
      local p1,p2,p3 = strsplit("@",BB_bufor[1]);
      BB_TR[p1.."@"..p2] = BB_Input1:GetText().."@"..BB_Input2:GetText();
      BB_Input2:SetText("OK - zapisano tłumaczenie - OK");
      BB_Input1:SetText("czekam na tekst oryginalny z nieprzetlumaczonego dymku");
      BB_ile_got = BB_ile_got + 1;
      BB_gotowe[BB_ile_got] = BB_bufor[1];
      BB_TRzatrzask();
   end
end

-------------------------------------------------------------------------------------------------------
  
function BB_OknoTRonline()
  BB_TRframe = CreateFrame("Frame","DragFrame1", UIParent);
  BB_TRframe:SetMovable(true);
  BB_TRframe:EnableMouse(true);
  BB_TRframe:RegisterForDrag("LeftButton");
  BB_TRframe:SetScript("OnDragStart", BB_TRframe.StartMoving);
  BB_TRframe:SetScript("OnDragStop", BB_TRframe.StopMovingOrSizing);

  BB_TRframe:SetWidth(500);
  BB_TRframe:SetHeight(46);
  BB_TRframe:ClearAllPoints();
  BB_TRframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 250, 0);
  if (BB_PM["TRonline"] == "1") then
     BB_TRframe:Show();
  else
     BB_TRframe:Hide();
  end;

  BB_Button8 = CreateFrame("Button",nil, BB_TRframe, "UIPanelButtonTemplate");
  BB_Button8:SetWidth(60);
  BB_Button8:SetHeight(20);
  BB_Button8:SetText("BBTR");
  BB_Button8:ClearAllPoints();
  BB_Button8:SetPoint("TOPLEFT", BB_TRframe, "TOPLEFT", 3, -3);
  BB_Button8:SetScript("OnClick", BB_ShowTRonline);
  if (BB_PM["TRonline"] == "1") then
     BB_Button8:Show();
  end;

  BB_Button8Save = CreateFrame("Button",nil, BB_TRframe, "UIPanelButtonTemplate");
  BB_Button8Save:SetWidth(60);
  BB_Button8Save:SetHeight(20);
  BB_Button8Save:SetText("Zapisz");
  BB_Button8Save:ClearAllPoints();
  BB_Button8Save:SetPoint("TOPLEFT", BB_Button8, "BOTTOMLEFT", 0, 1);
  BB_Button8Save:SetScript("OnClick", BB_ShowTRsave);
  BB_Button8Save:Hide();

  BB_Input1 = CreateFrame("EditBox", "BB_Input1", BB_TRframe, "InputBoxTemplate");
  BB_Input1:ClearAllPoints();
  BB_Input1:SetPoint("TOPLEFT", BB_Button8, "TOPRIGHT", 4, 0);
  BB_Input1:SetHeight(20);
  BB_Input1:SetWidth(400);
  BB_Input1:SetAutoFocus(false);
  BB_Input1:SetFontObject(GameFontGreen);
  BB_Input1:SetText("tutaj bedzie tekst oryginalny");
  BB_Input1:SetCursorPosition(0);
  BB_Input1:Hide();
  
  BB_Input2 = CreateFrame("EditBox", "BB_Input2", BB_TRframe, "InputBoxTemplate");
  BB_Input2:ClearAllPoints();
  BB_Input2:SetPoint("TOPLEFT", BB_Button8Save, "TOPRIGHT", 4, 0);
  BB_Input2:SetHeight(20);
  BB_Input2:SetWidth(400);
  BB_Input2:SetAutoFocus(false);
  BB_Input2:SetFontObject(GameFontWhite);
  BB_Input2:SetText("a tutaj będzie polskie tłumaczenie");
  local _font1, _size2, _flag3 = BB_Input2:GetFont(); -- odczytaj aktualną czcionkę i rozmiar
  BB_Input2:SetFont(WOWTR_Font2, _size2, _flag3);
  BB_Input2:SetCursorPosition(0);
  BB_Input2:Hide();
  
  BB_ButtonZatrz = CreateFrame("Button",nil, BB_TRframe, "UIPanelButtonTemplate");
  BB_ButtonZatrz:SetWidth(30);
  BB_ButtonZatrz:SetHeight(20);
  BB_ButtonZatrz:SetText("O");
  BB_ButtonZatrz:ClearAllPoints();
  BB_ButtonZatrz:SetPoint("TOPLEFT", BB_Input1, "TOPRIGHT", -1, 0);
  BB_ButtonZatrz:SetScript("OnClick", BB_TRzatrzask);
  BB_ButtonZatrz:Hide();

end

-------------------------------------------------------------------------------------------------------

function WOWBB_OnMouseDown(obj)
   obj:StartMoving();
   _,_,_,_,WOWBB_vert1 = obj:GetPoint();
end

-------------------------------------------------------------------------------------------------------

function WOWBB_OnMouseUp(obj)
   _,_,_,_,WOWBB_vert2 = obj:GetPoint();
   obj:StopMovingOrSizing();
   obj.vertical = obj.vertical + math.floor(WOWBB_vert2 - WOWBB_vert1);
   if (obj:GetName()=="WOWBB1") then
      WOWBB1:ClearAllPoints();
      WOWBB1:SetPoint("CENTER", 0, obj.vertical);
   elseif (obj:GetName()=="WOWBB2") then
      WOWBB2:ClearAllPoints();
      WOWBB2:SetPoint("CENTER", 250, obj.vertical);
   elseif (obj:GetName()=="WOWBB3") then
      WOWBB3:ClearAllPoints();
      WOWBB3:SetPoint("CENTER", -250, obj.vertical);
   elseif (obj:GetName()=="WOWBB4") then
      WOWBB4:ClearAllPoints();
      WOWBB4:SetPoint("CENTER", 500, obj.vertical);
   elseif (obj:GetName()=="WOWBB5") then
      WOWBB5:ClearAllPoints();
      WOWBB5:SetPoint("CENTER", -500, obj.vertical);
   end
end

-------------------------------------------------------------------------------------------------------

WOWBB1 = CreateFrame( "GameTooltip", "WOWBB1", UIParent, "GameTooltipTemplate" );   -- nasz własny dymek1 wyświetlany w lochach
WOWBB1:SetOwner(UIParent, "ANCHOR_NONE" );
WOWBB1:SetWidth(250);
WOWBB1:SetHeight(100);
WOWBB1.header = WOWBB1:CreateFontString(nil, "OVERLAY", "GameFontWhite");
WOWBB1.header:SetWidth(200);
--WOWBB1:SetMovable(true);
--WOWBB1:SetScript("OnMouseDown", function() WOWBB_OnMouseDown(WOWBB1); end);
--WOWBB1:SetScript("OnMouseUp", function() WOWBB_OnMouseUp(WOWBB1); end);
WOWBB1.vertical = 270;

WOWBB2 = CreateFrame( "GameTooltip", "WOWBB2", UIParent, "GameTooltipTemplate" );   -- nasz własny dymek2 wyświetlany w lochach
WOWBB2:SetOwner(UIParent, "ANCHOR_NONE" );
WOWBB2:SetWidth(250);
WOWBB2:SetHeight(100);
WOWBB2.header = WOWBB2:CreateFontString(nil, "OVERLAY", "GameFontWhite");
WOWBB2.header:SetWidth(200);
--WOWBB2:SetMovable(true);
--WOWBB2:SetScript("OnMouseDown", function() WOWBB_OnMouseDown(WOWBB2); end);
--WOWBB2:SetScript("OnMouseUp", function() WOWBB_OnMouseUp(WOWBB2); end);
WOWBB2.vertical = 270;

WOWBB3 = CreateFrame( "GameTooltip", "WOWBB3", UIParent, "GameTooltipTemplate" );   -- nasz własny dymek3 wyświetlany w lochach
WOWBB3:SetOwner(UIParent, "ANCHOR_NONE" );
WOWBB3:SetWidth(250);
WOWBB3:SetHeight(100);
WOWBB3.header = WOWBB3:CreateFontString(nil, "OVERLAY", "GameFontWhite");
WOWBB3.header:SetWidth(200);
--WOWBB3:SetMovable(true);
--WOWBB3:SetScript("OnMouseDown", function() WOWBB_OnMouseDown(WOWBB3); end);
--WOWBB3:SetScript("OnMouseUp", function() WOWBB_OnMouseUp(WOWBB3); end);
WOWBB3.vertical = 270;

WOWBB4 = CreateFrame( "GameTooltip", "WOWBB4", UIParent, "GameTooltipTemplate" );   -- nasz własny dymek4 wyświetlany w lochach
WOWBB4:SetOwner(UIParent, "ANCHOR_NONE" );
WOWBB4:SetWidth(250);
WOWBB4:SetHeight(100);
WOWBB4.header = WOWBB4:CreateFontString(nil, "OVERLAY", "GameFontWhite");
WOWBB4.header:SetWidth(200);
--WOWBB4:SetMovable(true);
--WOWBB4:SetScript("OnMouseDown", function() WOWBB_OnMouseDown(WOWBB4); end);
--WOWBB4:SetScript("OnMouseUp", function() WOWBB_OnMouseUp(WOWBB4); end);
WOWBB4.vertical = 270;

WOWBB5 = CreateFrame( "GameTooltip", "WOWBB5", UIParent, "GameTooltipTemplate" );   -- nasz własny dymek5 wyświetlany w lochach
WOWBB5:SetOwner(UIParent, "ANCHOR_NONE" );
WOWBB5:SetWidth(250);
WOWBB5:SetHeight(100);
WOWBB5.header = WOWBB5:CreateFontString(nil, "OVERLAY", "GameFontWhite");
WOWBB5.header:SetWidth(200);
--WOWBB5:SetMovable(true);
--WOWBB5:SetScript("OnMouseDown", function() WOWBB_OnMouseDown(WOWBB5); end);
--WOWBB5:SetScript("OnMouseUp", function() WOWBB_OnMouseUp(WOWBB5); end);
WOWBB5.vertical = 270;
