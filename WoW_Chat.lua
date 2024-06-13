-- Addon: WoWinArabic-Chat (version: 0.40) 2024.04.07
-- Note: The addon supports chat for entering and displaying messages in Arabic.
-- ملاحظة: الإضافة تدعم اللغة العربية في الدردشة في لعبة والد اوف واركرافت
-- Autor: Platine  (e-mail: platine.wow@gmail.com)
-- Special thanks for DragonArab for helping to create letter reshaping rules.

local CH_on_debug = false;
-- General Variables
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local CH_version = GetAddOnMetadata("WoWinArabic_Chat", "Version");
local CH_ctrFrame = CreateFrame("FRAME", "WoWinArabic-Chat");
local CH_ED_mode = 0;           -- włączony tryb arabski, wyrównanie do prawej strony
local CH_ED_cursor_move = 0;    -- tryb przesuwania kursora po wpisaniu litery (0-w prawo, 1-w lewo)
local CH_BubblesArray = {};
local CH_BuforEditBox = {};
local CH_BuforLength = 0;
local CH_BuforCursor = 0;
local CH_last_letter = "";
local limit_chars1 = 35;        -- max. number of 1 line on bubble (one-line bubble)
local limit_chars2 = 60;        -- max. number of 2 line on bubble (two-lines bubble)
local CH_key_ctrl = false;
local CH_key_shift = false;
local CH_key_alt = false;
local CH_highlight_text = false;
local CH_BSize = 14;            -- default size of chat bubbles

-- fonty z arabskimi znakami
local CH_Font = WOWTR_Font2;

-- user interface in addon options
local CH_Interface = {   
   started     = "started",      -- started 
   active      = "قم بتفعيل الإضافة",   -- Activate the addon 
   settings    = "خيارات إضافية",      -- Addon settings 
   font_activ  = "تفعيل وظيفة تغيير حجم الخط في الفقاعات",  -- activate the function of changing the font size in the bubbles 
   font_size   = "حجم الخط",    -- font size  
   }; 

-------------------------------------------------------------------------------------------------------

local function CH_bubblizeText()
   for _, bubble in pairs(C_ChatBubbles.GetAllChatBubbles()) do
   -- Iterate the children, as the actual bubble content 
   -- has been placed in a nameless subframe in 9.0.1.
      for j = 1, bubble:GetNumChildren() do
         local child = select(j, select(j, bubble:GetChildren()));
         if (not child:IsForbidden()) then                           -- czy ramka nie jest zabroniona?
            if (child:GetObjectType() == "Frame") and (child.String) and (child.Center) then
            -- This is hopefully the frame with the content
               for i = 1, child:GetNumRegions() do
                  local region = select(i, child:GetRegions());
                  if (CH_PM["setsize"]=="1") then
                     act_font = tonumber(CH_PM["fontsize"]);
                  else
                     act_font = CH_BSize;
                  end
                  for idx, iArray in ipairs(CH_BubblesArray) do      -- sprawdź, czy dane są właściwe (tekst oryg. się zgadza z zapisaną w tablicy)
                     if (region and not region:GetName() and region:IsVisible() and region.GetText and (region:GetText() == iArray[1])) then
                        local newText = iArray[2];   -- text received
                        local okrWidth = AS_UTF8len(newText);
                        region:SetFont(CH_Font, act_font);     -- ustaw arabską czcionkę oraz wielkość
                        if ((okrWidth >= limit_chars2) or (region:GetHeight() > act_font*3)) then    -- 3 lines or more
                           region:SetJustifyH("RIGHT");              -- wyrównanie do prawej strony (domyślnie jest CENTER)
                           newText = CH_LineReverse(iArray[2], 3);
                           region:SetText(newText);
                        elseif ((okrWidth >= limit_chars1) or (region:GetHeight() > act_font*2)) then   -- 2 lines
                           region:SetJustifyH("RIGHT");              -- wyrównanie do prawej strony
                           newText = CH_LineReverse(iArray[2], 2);
                           region:SetText(newText);
                        else                                         -- bubble in 1-line
                           region:SetJustifyH("CENTER");             -- wyrównanie do środka
                           region:SetText(newText);                  -- wpisz tu nasze tłumaczenie
                        end
                        region:SetWidth(CH_SpecifyBubbleWidth(newText, region));  -- określ nową szer. okna
                        tremove(CH_BubblesArray, idx);               -- usuń zapamiętane dane z tablicy
                     end
                  end
               end
            end
         end
      end
   end

   for idx, iArray in ipairs(CH_BubblesArray) do            -- przeszukaj jeszcze raz tablicę
      if (iArray[3] >= 100) then                            -- licznik osiągnął 100
         tremove(CH_BubblesArray, idx);                     -- usuń zapamiętane dane z tablicy
      else
         iArray[3] = iArray[3]+1;                           -- zwiększ licznik (nie pokazał się dymek?)
      end;
   end;
   if (#(CH_BubblesArray) == 0) then
      CH_ctrFrame:SetScript("OnUpdate", nil);               -- wyłącz metodę Update, bo tablica pusta
   end;
end;

-------------------------------------------------------------------------------------------------------

local function CH_Usun_Linki(txt)       -- funkcja usuwa kody linków przedmiotów
   local pocz, koniec, final;
   local txt1 = txt;
   pocz = string.find(txt1, "|cffffffff|Hitem");
   while (pocz and pocz > 0) do         -- znalazł początek linku
      koniec = string.find(txt1, "|h");
      final = string.find(txt1, "|h|r");
      if (koniec and final and (koniec > 0) and (pocz < koniec) and (koniec < final)) then
         txt1 = string.sub(txt1, 1, pocz-1) .. string.sub(txt1, koniec+3, final-2) .. string.sub(txt1, final+4);
      else
         break;
      end
      pocz = string.find(txt1, "|cffffff|Hitem");
   end
   return txt1;
end

-------------------------------------------------------------------------------------------------------

local function CH_Hex2Char(txt)
   local ret = txt;
   if (strlen(ret) < 2) then
      ret = "0" .. ret;
   end
   return ret;
end

-------------------------------------------------------------------------------------------------------

local function CH_Check_Arabic_Letters(txt)
   local result = false;
   if (txt) then
      local bytes = strlen(txt);
      local pos = 1;
      local char0 = '';
      local charbytes0;
      while (pos <= bytes) do
         charbytes0 = AS_UTF8charbytes(txt, pos);         -- count of bytes (liczba bajtów znaku)
         char0 = strsub(txt, pos, pos + charbytes0 - 1);  -- current character
         pos = pos + charbytes0;
         if (char0 >= "؀") then      -- it is an arabic letter
            result = true;
            break;
         end
      end
   end
   return result;
end

-------------------------------------------------------------------------------------------------------

local function CH_ChatFilter(self, event, arg1, arg2, arg3, _, arg5, ...)
   local colorText = "";
   local colorR, colorG, colorB;
   if (event == "CHAT_MSG_SAY") then
      colorR =  CH_Hex2Char(string.format("%x",ChatTypeInfo.SAY.r * 255));
      colorG =  CH_Hex2Char(string.format("%x",ChatTypeInfo.SAY.g * 255));
      colorB =  CH_Hex2Char(string.format("%x",ChatTypeInfo.SAY.b * 255));
      colorText = "|cFF"..colorR..colorG..colorB;
   elseif (event == "CHAT_MSG_YELL") then
      colorR =  CH_Hex2Char(string.format("%x",ChatTypeInfo.YELL.r * 255));
      colorG =  CH_Hex2Char(string.format("%x",ChatTypeInfo.YELL.g * 255));
      colorB =  CH_Hex2Char(string.format("%x",ChatTypeInfo.YELL.b * 255));
      colorText = "|cFF"..colorR..colorG..colorB;
   elseif ((event == "CHAT_MSG_WHISPER") or (event == "CHAT_MSG_WHISPER_INFORM")) then
      colorR =  CH_Hex2Char(string.format("%x",ChatTypeInfo.WHISPER.r * 255));
      colorG =  CH_Hex2Char(string.format("%x",ChatTypeInfo.WHISPER.g * 255));
      colorB =  CH_Hex2Char(string.format("%x",ChatTypeInfo.WHISPER.b * 255));
      colorText = "|cFF"..colorR..colorG..colorB;
   elseif ((event == "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER")) then
      colorR =  CH_Hex2Char(string.format("%x",ChatTypeInfo.PARTY.r * 255));
      colorG =  CH_Hex2Char(string.format("%x",ChatTypeInfo.PARTY.g * 255));
      colorB =  CH_Hex2Char(string.format("%x",ChatTypeInfo.PARTY.b * 255));
      colorText = "|cFF"..colorR..colorG..colorB;
   elseif (event == "CHAT_MSG_RAID") then
      colorR =  CH_Hex2Char(string.format("%x",ChatTypeInfo.RAID.r * 255));
      colorG =  CH_Hex2Char(string.format("%x",ChatTypeInfo.RAID.g * 255));
      colorB =  CH_Hex2Char(string.format("%x",ChatTypeInfo.RAID.b * 255));
      colorText = "|cFF"..colorR..colorG..colorB;
   elseif (event == "CHAT_MSG_RAID_LEADER") then
      colorText = "|cFFFF0000";        -- red color
   elseif (event == "CHAT_MSG_RAID_WARNING") then
      colorText = "|cFFFF0000";        -- red color
   elseif ((event == "CHAT_MSG_GUILD") or (event == "CHAT_MSG_OFFICER")) then
      colorR =  CH_Hex2Char(string.format("%x",ChatTypeInfo.GUILD.r * 255));
      colorG =  CH_Hex2Char(string.format("%x",ChatTypeInfo.GUILD.g * 255));
      colorB =  CH_Hex2Char(string.format("%x",ChatTypeInfo.GUILD.b * 255));
      colorText = "|cFF"..colorR..colorG..colorB;
   elseif ((event == "CHAT_MSG_BATTLEGROUND") or (event == "CHAT_MSG_BATTLEGROUND_LEADER")) then
      colorR =  CH_Hex2Char(string.format("%x",ChatTypeInfo.BATTLEGROUND.r * 255));
      colorG =  CH_Hex2Char(string.format("%x",ChatTypeInfo.BATTLEGROUND.g * 255));
      colorB =  CH_Hex2Char(string.format("%x",ChatTypeInfo.BATTLEGROUND.b * 255));
      colorText = "|cFF"..colorR..colorG..colorB;
   end

   local is_arabic = CH_Check_Arabic_Letters(arg1);
   if (is_arabic) then
      local poz = string.find(arg2, "-");
      local output = "";
      local playerLen = AS_UTF8len(string.sub(arg2, 1, poz-1));
      local _, className = UnitClass(string.sub(arg2, 1, poz-1)); 
      local classColorTable = RAID_CLASS_COLORS[className];
		local playerLink = GetPlayerLink(arg2, ("[|c"..classColorTable.colorStr.."%s|r]"):format(string.sub(arg2, 1, poz-1)), arg11);
      local _fontC, _sizeC, _C = self:GetFont();   -- odczytaj aktualną czcionkę, rozmiar i typ
      self:SetFont(CH_Font, _sizeC, _C);           -- załaduj arabską czcionkę
      if (event == "CHAT_MSG_SAY") then
         output = arg1..AS_UTF8reverseRS(" يتحدث: ")..playerLink;   -- said (forma właściwa)
         local czystyArg = CH_Usun_Linki(arg1);
         tinsert(CH_BubblesArray, { [1] = czystyArg, [2] = czystyArg, [3] = 1 });
         CH_ctrFrame:SetScript("OnUpdate", CH_bubblizeText);      -- obsługa bubbles dla komunikatu SAY
      elseif (event == "CHAT_MSG_YELL") then
         output = arg1..AS_UTF8reverseRS(" يصرخ: ")..playerLink;    -- yelled
         local czystyArg = CH_Usun_Linki(arg1);
         tinsert(CH_BubblesArray, { [1] = czystyArg, [2] = czystyArg, [3] = 1 });
         CH_ctrFrame:SetScript("OnUpdate", CH_bubblizeText);      -- obsługa bubbles dla komunikatu SAY
      elseif (event == "CHAT_MSG_WHISPER") then          -- otrzymany szept od innego gracza
         if (self:GetName() == "ChatFrame1") then        -- jest komunikat WHISPER w głównym oknie czatu
            return true;                      -- nie wyświetlaj komunikatu WHISPER w głównym oknie czatu
         end
         output = arg1..AS_UTF8reverseRS(" همس: ")..playerLink;     -- whisped
      elseif (event == "CHAT_MSG_WHISPER_INFORM") then   -- wysyłany szept do innego gracza
         if (self:GetName() == "ChatFrame1") then        -- jest komunikat WHISPER w głównym oknie czatu
            return true;                      -- nie wyświetlaj komunikatu WHISPER w głównym oknie czatu
         end
         output = arg1.." :"..playerLink.." "..AS_UTF8reverseRS("إلى");    
      elseif ((event == "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER")) then
         if (event == "CHAT_MSG_PARTY_LEADER") then
            if (Prat) then       -- jest aktywny dodatek Prat
               output = arg1.." :"..playerLink.." [PL]";
            else
               output = arg1.." :"..playerLink.." [Party Leader]";
            end
         else
            if (Prat) then       -- jest aktywny dodatek Prat
               output = arg1.." :"..playerLink.." [P]";
            else
               output = arg1.." :"..playerLink.." [Party]";
            end
         end
         local czystyArg = CH_Usun_Linki(arg1);
         tinsert(CH_BubblesArray, { [1] = czystyArg, [2] = czystyArg, [3] = 1 });
         CH_ctrFrame:SetScript("OnUpdate", CH_bubblizeText);      -- obsługa bubbles dla komunikatu SAY
      elseif (event == "CHAT_MSG_RAID") then
         if (Prat) then       -- jest aktywny dodatek Prat
            output = arg1.." :"..playerLink.." [R]";
         else
            output = arg1.." :"..playerLink.." [Raid]";
         end
      elseif (event == "CHAT_MSG_RAID_LEADER") then
         if (Prat) then       -- jest aktywny dodatek Prat
            output = arg1.." :"..playerLink.." [RL]";
         else
            output = arg1.." :"..playerLink.." [Raid Leader]";
         end
      elseif (event == "CHAT_MSG_RAID_WARNING") then
         local _font1, _size1, _3 = RaidWarningFrameSlot1:GetFont(); -- odczytaj aktualną czcionkę i rozmiar
         RaidWarningFrameSlot1:SetFont(CH_Font, _size1);
         RaidWarningFrameSlot2:SetFont(CH_Font, _size1);
         if (Prat) then       -- jest aktywny dodatek Prat
            output = arg1.." :"..playerLink.." [RW]";
         else
            output = arg1.." :"..playerLink.." [Raid Warning]";
         end
      elseif ((event == "CHAT_MSG_GUILD") or (event == "CHAT_MSG_OFFICER")) then
         if (Prat) then       -- jest aktywny dodatek Prat
            output = arg1.." :"..playerLink.." [G]";
         else
            output = arg1.." :"..playerLink.." [Guild]";
         end
      elseif ((event == "CHAT_MSG_BATTLEGROUND") or (event == "CHAT_MSG_BATTLEGROUND_LEADER")) then
         output = arg1.." :"..playerLink;
      else
         return false;  -- wyświetlaj tekst oryginalny w oknie czatu
      end   

      self:AddMessage(colorText..CH_LineChat(output, _sizeC)); 
      return true;      -- nie wyświetlaj oryginalnego tekstu
   else
      return false;     -- wyświetlaj tekst oryginalny w oknie czatu
   end   
end

-------------------------------------------------------------------------------------------------------

local function CH_AR_ON_OFF()       -- funkcja włącz/wyłącza tryb arabski
   local txt = DEFAULT_CHAT_FRAME.editBox:GetText();
   if (CH_ED_mode == 0) then        -- mamy tryb EN - przełącz na tryb arabski
      DEFAULT_CHAT_FRAME.editBox:SetJustifyH("RIGHT");
      DEFAULT_CHAT_FRAME.editBox:SetCursorPosition(0);         -- przesuń kursor na skrajne lewo
      CH_ToggleButton:SetNormalFontObject("GameFontNormal");   -- litery AR żółte
      CH_ToggleButton:SetText("AR");
      CH_ToggleButton2:SetNormalFontObject("GameFontNormal");  -- litery AR żółte
      CH_ToggleButton2:SetText("AR");
      CH_ED_mode = 1;
      CH_BuforCursor = 0;
      CH_ED_cursor_move = 1;
      CH_InsertButton:SetText("←");
      CH_InsertButton:Show();
   else                             -- mamy tryb arabski - przełącz na tryb angielski
      DEFAULT_CHAT_FRAME.editBox:SetJustifyH("LEFT");
      CH_ToggleButton:SetNormalFontObject("GameFontRed");      -- litery EN czerwone
      CH_ToggleButton:SetText("EN");
      CH_ToggleButton2:SetNormalFontObject("GameFontRed");     -- litery EN czerwone
      CH_ToggleButton2:SetText("EN");
      CH_ED_mode = 0;
      if ((CH_BuforLength > 0) and (CH_BuforEditBox[CH_BuforLength] >= "؀")) then   -- pierwszym znakiem z prawej strony jest litera arabska
         DEFAULT_CHAT_FRAME.editBox:SetCursorPosition(0);      -- przesuń kursor na skrajne lewo
         CH_BuforCursor = 0;
         CH_ED_cursor_move = 1;
      else
         DEFAULT_CHAT_FRAME.editBox:SetCursorPosition(strlen(txt));      -- przesuń kursor na skrajne prawo
         CH_BuforCursor = CH_BuforLength;
         CH_ED_cursor_move = 0;
         CH_InsertButton:SetText("→");
         CH_InsertButton:Hide();
      end
   end
   if (strlen(txt) == 0) then    -- przy komendzie /w Player trzeba wyzerować tę komendę
      CH_BuforEditBox = {};
      CH_BuforLength = 0;
      CH_BuforCursor = 0;
   end
   ChatEdit_ActivateChat(DEFAULT_CHAT_FRAME.editBox);
   DEFAULT_CHAT_FRAME.editBox:SetFocus();
end

-------------------------------------------------------------------------------------------------------

local function CH_INS_ON_OFF()            -- funkcja przełącza przesuwanie kursora w zależności od wprowadzonej litery
   if (CH_ED_cursor_move == 1) then       -- mamy tryb przesuwania kursowa na lewo
      CH_InsertButton:SetText("→");
      CH_ED_cursor_move = 0;              -- włącz tryb przesuwania na prawo od wpisanego znaku
   else
      CH_InsertButton:SetText("←");
      CH_ED_cursor_move = 1;              -- włącz tryb przesuwania w lewo od wpisanego znaku
   end
   DEFAULT_CHAT_FRAME.editBox:SetFocus();
   CH_InsertButton:Show();
end

-------------------------------------------------------------------------------------------------------

function CH_Oblicz_Pozycje(curs)        -- oblicza pozycję (bytes) cursora w oknie edycji
   local pozycja = 0;
   if (CH_ED_cursor_move == 1) then    -- mamy tryb przesuwania w lewo (litera arabska)
      curs = curs - 1;
   end
   for i = 1, curs do
      pozycja = pozycja + strlen(CH_BuforEditBox[i]);   -- liczba bajtów znaku
   end
   return pozycja;
end

-------------------------------------------------------------------------------------------------------

local function CH_OnShow()       -- otworzony został editBox
   if (not CH_ToggleButton:IsVisible()) then
      CH_ToggleButton2:Show();
   end
   CH_BuforEditBox = {};
   CH_BuforLength = 0;
   CH_BuforCursor = 0;
   CH_last_letter = "";
   if (CH_ED_mode == 1) then     -- tryb arabski
      CH_ED_cursor_move = 1;     -- przesuwanie w lewo
      CH_InsertButton:SetText("←");
   else                          -- tryb angielski
      CH_ED_cursor_move = 0;     -- przesuwanie w prawo
      CH_InsertButton:SetText("→");
   end
end

-------------------------------------------------------------------------------------------------------

local function CH_OnHide()       -- został zamknięty editBox
   CH_ToggleButton2:Hide();
   CH_ToggleButton:Enable();
   CH_ToggleButton2:Enable();
end
   
-------------------------------------------------------------------------------------------------------

local function CH_GetIsolatedLetterForm(ch)
   local retu = ch;
   if (CH_IsolatedLetter[ch]) then
      retu = CH_IsolatedLetter[ch];
      if (AS_UTF8len(retu) > 1) then   -- mamy 2 litery arabskie w formie izolowanej
         CH_BuforLength = CH_BuforLength + 1;
         CH_BuforEditBox[CH_BuforLength] = AS_UTF8sub(retu,1,1);
         retu = AS_UTF8sub(retu,2,2);
      end
   end
   return retu;
end

-------------------------------------------------------------------------------------------------------

local function CH_Insert_Text_to_Buffer(s)
   CH_BuforEditBox = {};
   CH_BuforLength = 0;
   local bytes = strlen(s);
   local pos = 1;
   local char1, char2;
   local charbytes1, charbytes2;
   local is_link = false;
   local newstr = "";
   while (pos <= bytes) do
      charbytes1 = AS_UTF8charbytes(s, pos);         -- count of bytes (liczba bajtów znaku)
      char1 = strsub(s, pos, pos + charbytes1 - 1);  -- current character
      pos = pos + charbytes1;
      if (pos <= bytes) then
         charbytes2 = AS_UTF8charbytes(s, pos);         -- count of bytes (liczba bajtów znaku)
         char2 = strsub(s, pos, pos + charbytes2 - 1);  -- next character
      else
         char2 = "";
         charbytes2 = 0;
      end
      if (char1..char2 == "|c") then    -- zaczyna się link od definicji koloru
         is_link = true;
      end
      if (char1..char2 == "|r") then    -- kończy się link od przywrócenia koloru
         is_link = false;
         newstr = newstr .. '|r';
         CH_BuforLength = CH_BuforLength + 1;
         CH_BuforEditBox[CH_BuforLength] = newstr;
         newstr = "";
         pos = pos + charbytes2;
      end
      if (is_link) then       -- poszczegójne znaki linku
         newstr = newstr .. char1;
      else                    -- wprowadzamy do bufora poszczególne znaku w pola edycji
         CH_BuforLength = CH_BuforLength + 1;
         CH_BuforEditBox[CH_BuforLength] = CH_GetIsolatedLetterForm(char1);
      end
   end
end

-------------------------------------------------------------------------------------------------------

local function CH_OnChar(self, character)    -- wprowadzono znak litery z klawiatury
   if (CH_ToggleButton:IsEnabled()) then
      if (CH_highlight_text) then            -- mamy podświetlony tekst i wciśnięto cyfrę lub literę
         self:SetText(character);            -- wyzeruj pole edycji i wprowadź character
         self:SetCursorPosition(0);
         CH_BuforEditBox= {};
         CH_BuforLength = 0;
         CH_BuforCursor = 0;
         CH_highlight_text = false;
         if (CH_ED_mode == 0) then
            CH_ToggleButton:SetNormalFontObject("GameFontRed");      -- litery EN czerwone
         else
            CH_ToggleButton:SetNormalFontObject("GameFontNormal");   -- litery AR żółte
         end
      end
      CH_BuforLength = CH_BuforLength + 1;      -- bufor powiększył się o 1 element
      if (CH_BuforLength == 1) then             -- pierwsza litera w edytorze
         tinsert(CH_BuforEditBox, 1, character);
         CH_BuforCursor = 1;                    -- kursor na pierwszym znaku
         if (((character >= "؀") and (character <= "ݿ")) or ((string.sub(character,1,1) == "|") and (CH_ED_mode == 1))) then   -- mamy literę arabską
            self:SetCursorPosition(0);
            CH_ED_cursor_move = 1;              -- włącz przesuwanie w lewo
            CH_InsertButton:SetText("←");
            CH_InsertButton:Show();
         else
            self:SetCursorPosition(AS_UTF8charbytes(character));
            CH_ED_cursor_move = 0;              -- włącz przesuwanie w prawo
            if (CH_ED_mode == 1) then
               CH_InsertButton:SetText("→");
               CH_InsertButton:Show();
            end
         end
      else                                      -- wprowadzono kolejną literę
         if (CH_ED_cursor_move == 1) then       -- mamy tryb przesuwania w lewo (litera arabska)
            if (CH_BuforCursor == 0) then
               CH_BuforCursor = 1;              -- tylko gdy = 0
            end
            tinsert(CH_BuforEditBox, CH_BuforCursor, character);
         else                                   -- tu jest tryb przesuwania w prawo (litera łacińska)
            if (CH_BuforCursor < CH_BuforLength) then
               CH_BuforCursor = CH_BuforCursor + 1;   -- aktualna pozycja kursora
            end
            tinsert(CH_BuforEditBox, CH_BuforCursor, character);
         end
         local spaces = "( )?؟!,.;:،";             -- letters that we treat as a space
         if (AS_UTF8find(spaces, character) == false) then       -- nie wprowadzono znaku z listy spaces      
            if (((character >= "؀") and (character <= "ݿ")) or ((string.sub(character,1,1) == "|") and (CH_ED_mode == 1))) then  -- mamy literę arabską
               if (CH_ED_cursor_move == 0) then    -- mamy tryb przesuwania w prawo - przełącz na tryb przesuwania w lewo od wpisanego znaku
                  CH_INS_ON_OFF();                 -- zmień na przesuwanie w lewo
               end
            else                                                 -- wprowadzono literę inną niż arabska
               if (CH_ED_cursor_move == 1) then    -- mamy tryb przesuwania w lewo - przełącz na tryb przesuwania w prawo od wpisanego znaku
                  CH_INS_ON_OFF();
               end
            end
         end
         local newtext = "";
         if (CH_ED_mode == 1) then        -- tryb arabski: reshaping text into editBox
            for i = CH_BuforLength, 1, -1 do
               if (string.sub(CH_BuforEditBox[i],1,1) == "|") then           -- mamy tu link do przedmiotu
                  newtext = newtext .. CH_UTF8reverseRS(CH_BuforEditBox[i]);   -- trzeba odwrócić znaki w linku
               else
                  newtext = newtext .. CH_BuforEditBox[i];
               end
            end
            newtext = AS_UTF8reverseRS(newtext);     -- odwróć kolejność liter + ReShaping
         else
            for i = 1, CH_BuforLength do
               newtext = newtext .. CH_BuforEditBox[i];
            end
         end
         self:SetText(newtext);
         self:SetCursorPosition(CH_Oblicz_Pozycje(CH_BuforCursor));
      end
      CH_last_letter = character;
   end
end

-------------------------------------------------------------------------------------------------------

local function CH_OnKeyDown(self, key)    -- wciśnięto klawisz key: spradź czy wciśnięto BACKSPACE lub DELETE
   if ((key == "LCTRL") or (key == "RCTRL")) then        -- wciśnięta klawisz CONTROL
      CH_key_ctrl = true;
   elseif ((key == "LSHIFT") or (key == "RSHIFT")) then  -- wciśnięta klawisz SHIFT
      CH_key_shift = true;
   elseif ((key == "LALT") or (key == "RALT")) then      -- wciśnięta klawisz ALT
      CH_key_alt = true;
   end
   if (CH_key_ctrl and (key == "A") and (strlen(self:GetText())>0)) then  -- wciśnięto klawisze Ctrl+A: zaznaczono tekst w editBox
      CH_highlight_text = true;
      CH_ToggleButton:SetNormalFontObject("GameFontBlack");   -- litery EN/AR czarne
   end
   if (CH_ToggleButton:IsEnabled()) then                 -- obsługa bufora włączona?
      if (CH_ED_mode == 1) then        -- mamy tryb arabski
         if (key == "BACKSPACE") then  -- usuń znak poprzedzający, czyli 1 na prawo
            local buf = self:GetText();              -- cały tekst
            local pos = self:GetCursorPosition();    -- aktualna pozycja kursora
            if (strlen(buf) > 0) then                -- nie jest to pusty tekst
               if (pos < strlen(buf)) then           -- kursor nie jest na początku tekstu, skrajnie na prawo
                  local charbytes = AS_UTF8charbytes(buf, pos+1);   -- liczba bajtów 1 znaku w pozycji pos
                  self:SetCursorPosition(pos+charbytes);    -- przesuń kursor o 1 znak w prawo, aby usunięcie było tego znaku
               else                                         -- nic nie usuwaj, jesteś na początku tekstu, skrajnie na prawo
                  self:SetText(buf.." ");                   -- dodaj spację na początku, skrajnie na prawo
                  self:SetCursorPosition(strlen(buf)+1);    -- przesuń kursor na początek tekstu w prawo, aby usunąć tę spację
                  CH_BuforCursor = CH_BuforLength + 1;
               end
            end
  
            if (CH_BuforLength == 1) then               -- pierwszy znak z buforze
               tremove(CH_BuforEditBox, 1);
               CH_BuforCursor = 0;
               CH_BuforLength = 0;
            elseif (CH_BuforCursor <= CH_BuforLength) then
               if (CH_BuforCursor < 2) then
                  tremove(CH_BuforEditBox, 1);
               else
                  tremove(CH_BuforEditBox, CH_BuforCursor);
               end
               if (CH_BuforLength > 0) then
                  CH_BuforLength = CH_BuforLength - 1;
               end
            end
            
         elseif (key == "DELETE") then                -- usuń znak następujący, czyli 1 na lewo
            local buf = self:GetText();
            local pos = self:GetCursorPosition();
            if (pos > 0) then                         -- kursor nie jest na końcu tekstu, skrajnie w lewo
               -- ustal znak z lewej strony
--               if (pos == strlen(buf)) then           -- kursor jest skrajnie na prawo
                  pos = pos - 1;
                  if (pos > 0) then
                     local c = strbyte(buf, pos);
                     while (c >= 128 and c <= 191) do
                        pos = pos - 1;
                        c = strbyte(buf, pos);
                     end
                  end
--               end
               pos = pos - 1;
               if (pos > 0) then
                  local c = strbyte(buf, pos);
                  while (c >= 128 and c <= 191) do
                     pos = pos - 1;
                     c = strbyte(buf, pos);
                  end
               end
               self:SetCursorPosition(pos);    -- przesuń kursor o 1 znak w lewo, aby usunięcie było tego znaku
            else                             -- kursor jest na końcu tekstu, nie ma co usuwać - dodaj spację na końcu
               self:SetText(" "..buf);
               self:SetCursorPosition(0);    -- przesuń kursor na koniec tekstu w lewo, aby usunąć tę spację
               CH_BuforCursor = 1;
            end
            if (CH_BuforCursor > 1) then
               tremove(CH_BuforEditBox, CH_BuforCursor-1);
               CH_BuforCursor = CH_BuforCursor - 1;
               CH_BuforLength = CH_BuforLength - 1;
            end
         end
         
      else           -- mamy tryb angielski
         if (key == "DELETE") then                -- usuń bieżący znak z bufora
            if (CH_BuforLength > CH_BuforCursor) then
               if (self:GetCursorPosition() == 0) then
                  tremove(CH_BuforEditBox, 1);
               else
                  tremove(CH_BuforEditBox, CH_BuforCursor+1);
               end
               CH_BuforLength = CH_BuforLength - 1;
            elseif (CH_BuforLength == 0) then
               CH_BuforCursor = 0;
            end
         elseif (key == "BACKSPACE") then         -- usuń znak poprzedzający, czyli 1 na lewo
            if (CH_BuforCursor > 0) then
               tremove(CH_BuforEditBox, CH_BuforCursor);
               CH_BuforCursor = CH_BuforCursor - 1;
               CH_BuforLength = CH_BuforLength - 1;
            end
         end
      end
      if ((key == "ENTER") and (CH_ED_mode == 1)) then                    -- wciśnięto klawisz ENTER
         local newtext = "";
         for i = CH_BuforLength, 1, -1 do
            if (string.sub(CH_BuforEditBox[i],1,1) == "|") then           -- mamy tu link do przedmiotu
               newtext = newtext .. CH_UTF8reverseRS(CH_BuforEditBox[i]);   -- trzeba odwrócić znaki w linku przedmiotu
            else
               newtext = newtext .. CH_BuforEditBox[i];
            end
         end
         newtext = AS_UTF8reverseRS(newtext);       -- odwróć kolejność liter + ReShaping
         self:SetText(newtext);
      end
   end
end

-------------------------------------------------------------------------------------------------------

local function CH_OnKeyUp(self, key)      -- puszczono klawisz key: sprawdź czy wciśnięto HOME, END, LEFT i RIGHT
   if ((CH_key_shift and ((key == "LALT") or (key == "RALT"))) or (CH_key_alt and ((key == "LSHIFT") or (key == "RSHIFT")))) then
      CH_AR_ON_OFF();                                    -- wciśnięto jednocześnie klawisze SHIFT+ALT
   end
   if ((key == "LCTRL") or (key == "RCTRL")) then        -- puszczono klawisz CONTROL
      CH_key_ctrl = false;
   elseif ((key == "LSHIFT") or (key == "RSHIFT")) then  -- puszczono klawisz SHIFT
      CH_key_shift = false;
   elseif ((key == "LALT") or (key == "RALT")) then      -- puszczono klawisz ALT
      CH_key_alt = false;
   end
   if (CH_ToggleButton:IsEnabled()) then
      if (CH_key_ctrl and ((key == "V") or (key == "N"))) then    -- wklejono dane ze schowka, lub z historii bufora
      -- trzeba wprowadzić nowe dane do bufora
         local act_pos = self:GetCursorPosition();
         CH_Insert_Text_to_Buffer(self:GetText());
         if (CH_ED_cursor_move == 1) then       -- mamy tryb arabski
            CH_BuforCursor = 0;
            self:SetCursorPosition(0);          -- ustaw kursor skrajnie na lewo
         else
            self:SetCursorPosition(strlen(self:GetText()));
            CH_BuforCursor = CH_BuforLength + 1;
         end
         return;
      end
      if (CH_ED_mode == 1) then        -- mamy tryb arabski
         if (key == "HOME") then       -- skocz kursorem na początek tekstu, czyli na skrajne prawo
            self:SetCursorPosition(strlen(self:GetText()));
            CH_BuforCursor = CH_BuforLength + 1;
            CH_ED_cursor_move = 1;
            CH_InsertButton:SetText("←");
         elseif (key == "END") then    -- skocz kursorem na koniec tekstu, czyli na skrajne lewo
            self:SetCursorPosition(0);
            CH_BuforCursor = 1;
            CH_ED_cursor_move = 1;
            CH_InsertButton:SetText("←");
         end
      else                             -- mamy tryb angielski
         if (key == "HOME") then       -- skocz kursorem na początek tekstu, czyli na skreajne lewo
            CH_BuforCursor = 0;
            CH_ED_cursor_move = 0;
            CH_InsertButton:SetText("→");
         elseif (key == "END") then    -- skocz kursorem na koniec tekstu, czyli na skrajne prawo
            CH_BuforCursor = CH_BuforLength;
            CH_ED_cursor_move = 0;
            CH_InsertButton:SetText("→");
         end
      end
      if ((key == "LEFT") and (CH_BuforCursor > CH_ED_mode)) then       -- wciśnięto klawisz "strzałka w lewo" alt+LEFT
         CH_BuforCursor = CH_BuforCursor - 1;      -- dopuszczamy: Cursor == 0 dla CH_ED_mode == 0
      end
      if ((key == "RIGHT") and (CH_BuforCursor-CH_ED_mode < CH_BuforLength)) then    -- wciśnięto klawisz "strzałka w prawo" alt+RIGHT
         CH_BuforCursor = CH_BuforCursor + 1;      -- dopuszczamy: Cursor+1 od Length dla CH_ED_mode == 1
      end
   end
   if (strlen(self:GetText()) == 0) then    -- profilaktycznie trzeba wyzerować bufor
      CH_BuforEditBox = {};
      CH_BuforLength = 0;
      CH_BuforCursor = 0;
   end
   if (CH_on_debug) then
      local aaa = "";
      for i = 1, CH_BuforLength, 1 do
         aaa = aaa.." "..CH_BuforEditBox[i];
      end
      print("BuforLength="..CH_BuforLength,"BuforCursor="..CH_BuforCursor,"Data:"..aaa);
   end
end

-------------------------------------------------------------------------------------------------------

local function CH_CheckVars()
  if (not CH_PM) then
     CH_PM = {};
  end
  -- initialize check options
  if (not CH_PM["active"] ) then    -- dodatek aktywny
     CH_PM["active"] = "1";   
  end
  if (not CH_PM["setsize"] ) then   -- uaktywnij zmiany wielkości czcionki
     CH_PM["setsize"] = "0";   
  end
  if (not CH_PM["fontsize"] ) then  -- wielkość czcionki
     CH_PM["fontsize"] = "14";
  end
--  if (not CH_PM["fontname"] ) then  -- nazwa czcionki
--     CH_PM["fontname"] = "calibri.ttf";
--  end
end
  
-------------------------------------------------------------------------------------------------------

local function CH_SetCheckButtonState()
  CHCheckButton1:SetValue(CH_PM["active"]=="1");
  CHCheckSize:SetValue(CH_PM["setsize"]=="1");
  local fontsize = tonumber(CH_PM["fontsize"]);
  CHslider1:SetValue(fontsize);
  CHOpis1:SetFont(CH_Font, fontsize);
end

-------------------------------------------------------------------------------------------------------

local function CH_createDropdown(opts)
--- Opts:
---     name (string): Name of the dropdown (lowercase)
---     parent (Frame): Parent frame of the dropdown.
---     items (Table): String table of the dropdown options.
---     defaultVal (String): String value for the dropdown to default to (empty otherwise).
---     changeFunc (Function): A custom function to be called, after selecting a dropdown option.
   local dropdown_name = '$parent_' .. opts['name'] .. '_dropdown';
   local menu_items = opts['items'] or {};
   local title_text = opts['title'] or '';
   local dropdown_width = 0;
   local default_val = opts['defaultVal'] or '';
   local change_func = opts['changeFunc'] or function (dropdown_val) end;

   local dropdown = CreateFrame("Frame", dropdown_name, opts['parent'], 'UIDropDownMenuTemplate');
   local dd_title = dropdown:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
   dd_title:SetPoint("TOPLEFT", 20, 15);
   dd_title:SetFont(CH_Font, 16);

   for _, item in pairs(menu_items) do -- Sets the dropdown width to the largest item string width.
      dd_title:SetText(item);
      local text_width = dd_title:GetStringWidth() + 20;
      if (text_width > dropdown_width) then
         dropdown_width = text_width;
      end
   end

   UIDropDownMenu_SetWidth(dropdown, dropdown_width);
   UIDropDownMenu_SetSelectedValue(dropdown, default_val);
   UIDropDownMenu_SetText(dropdown, default_val);
   dd_title:SetText(title_text);

   UIDropDownMenu_Initialize(dropdown, function(self, level, _)
      local info = UIDropDownMenu_CreateInfo();
      for key, val in pairs(menu_items) do
         info.text = val;
         info.checked = false;
         info.menuList= key;
         info.hasArrow = false;
         info.func = function(b)
            UIDropDownMenu_SetSelectedValue(dropdown, b.value, b.value);
            UIDropDownMenu_SetText(dropdown, b.value);
            b.checked = true;
            change_func(dropdown, b.value);
         end
         UIDropDownMenu_AddButton(info);
      end
   end);

   return dropdown;
end

-------------------------------------------------------------------------------------------------------

local function CH_BlizzardOptions()

-- Create main frame for information text
local CHOptions = CreateFrame("FRAME", "WoWinArabicChatOptions");
CHOptions.refresh = function (self) CH_SetCheckButtonState() end;
CHOptions.name = "WoWinArabic-Chat";
InterfaceOptions_AddCategory(CHOptions);

local CHOptionsHeader = CHOptions:CreateFontString(nil, "ARTWORK");
CHOptionsHeader:SetFontObject(GameFontNormalLarge);
CHOptionsHeader:SetJustifyH("RIGHT"); 
CHOptionsHeader:SetJustifyV("TOP");
CHOptionsHeader:ClearAllPoints();
CHOptionsHeader:SetText("2023 ﺔﻨﺴﻟ Platine ﺭﻮﻄﻤﻟﺍ "..CH_version.." ﺔﺨﺴﻧ WoWinArabic-Chat ﺔﻓﺎﺿﺇ");
CHOptionsHeader:SetFont(CH_Font, 16);
CHOptionsHeader:SetPoint("TOPRIGHT", -20, -16);

local CHDateOfBase = CHOptions:CreateFontString(nil, "ARTWORK");
CHDateOfBase:SetFontObject(GameFontNormalLarge);
CHDateOfBase:SetJustifyH("RIGHT"); 
CHDateOfBase:SetJustifyV("TOP");
CHDateOfBase:ClearAllPoints();
CHDateOfBase:SetText("DragonArab ﺔﻴﺑﺮﻌﻟﺍ ﺔﻐﻠﻟﺍ ﻞﻴﻜﺸﺗ ﺭﻮﻄﻣ");
CHDateOfBase:SetFont(CH_Font, 16);
CHDateOfBase:SetPoint("TOPRIGHT", -20, -45);

local CHCheckButton1 = CreateFrame("CheckButton", "CHCheckButton1", CHOptions, "SettingsCheckBoxControlTemplate");
CHCheckButton1.Text:SetJustifyH("RIGHT");
CHCheckButton1.Text:SetFont(CH_Font, 18);
CHCheckButton1.Text:SetText(AS_UTF8reverseRS(CH_Interface.active));     -- dodatek aktywny
local okno_width = SettingsPanel.Container:GetWidth();
local text_width = CHCheckButton1.Text:GetWidth();
CHCheckButton1:SetPoint("TOPLEFT", okno_width-text_width-70, -90);     -- pozycja opisu przycisku CheckBox
CHCheckButton1.CheckBox:SetPoint("TOPLEFT", text_width+10, 2);    -- pozycja przycisku CheckBox
CHCheckButton1.CheckBox:SetScript("OnClick", function(self) if (CH_PM["active"]=="1") then CH_PM["active"]="0" else CH_PM["active"]="1" end; end);

local CHOptionsMode = CHOptions:CreateFontString(nil, "ARTWORK");
CHOptionsMode:SetFontObject(GameFontWhite);
CHOptionsMode:SetJustifyH("RIGHT");
CHOptionsMode:SetJustifyV("TOP");
CHOptionsMode:ClearAllPoints();
CHOptionsMode:SetPoint("TOPRIGHT", -70, -150);
CHOptionsMode:SetFont(CH_Font, 18);
CHOptionsMode:SetText(":"..AS_UTF8reverseRS(CH_Interface.settings));          -- Ustawienia dodatku

local CHCheckSize = CreateFrame("CheckButton", "CHCheckSize", CHOptions, "SettingsCheckBoxControlTemplate");
CHCheckSize.Text:SetJustifyH("RIGHT");
CHCheckSize.Text:SetFont(CH_Font, 18);
CHCheckSize.Text:SetText(AS_UTF8reverseRS(CH_Interface.font_activ));   
text_width = CHCheckSize.Text:GetWidth();
CHCheckSize:SetPoint("TOPLEFT", okno_width-text_width-105, -200);
CHCheckSize.CheckBox:SetPoint("TOPLEFT",  text_width+10, 2);
CHCheckSize.CheckBox:SetScript("OnClick", function(self) if (CH_PM["setsize"]=="1") then CH_PM["setsize"]="0" else CH_PM["setsize"]="1" end; end);

local CHslider1 = CreateFrame("Slider", "CHslider1", CHOptions, "OptionsSliderTemplate");
CHslider1:SetPoint("TOPRIGHT", CHCheckSize.CheckBox, "BOTTOMRIGHT", 0, -30);
CHslider1:SetMinMaxValues(10, 25);
CHslider1.minValue, CHslider1.maxValue = CHslider1:GetMinMaxValues();
CHslider1.Low:SetText(CHslider1.minValue);
CHslider1.High:SetText(CHslider1.maxValue);
getglobal(CHslider1:GetName() .. 'Text'):SetText(AS_UTF8reverseRS(CH_Interface.font_size));
getglobal(CHslider1:GetName() .. 'Text'):SetFont(CH_Font, 16);
getglobal(CHslider1:GetName() .. 'Text'):SetJustifyH("RIGHT");
CHslider1:SetValue(tonumber(CH_PM["fontsize"]));
CHslider1:SetValueStep(1);
CHslider1:SetScript("OnValueChanged", function(self,event,arg1) 
                                      CH_PM["fontsize"]=string.format("%d",event); 
                                      CHslider1Val:SetText(CH_PM["fontsize"]);
                                      CHOpis1:SetFont(CH_Font, event);
                                      end);
CHslider1Val = CHOptions:CreateFontString(nil, "ARTWORK");
CHslider1Val:SetFontObject(GameFontNormal);
CHslider1Val:SetJustifyH("CENTER");
CHslider1Val:SetJustifyV("TOP");
CHslider1Val:ClearAllPoints();
CHslider1Val:SetPoint("CENTER", CHslider1, "CENTER", 0, -12);
CHslider1Val:SetText(CH_PM["fontsize"]);   
CHslider1Val:SetFont(CH_Font, 16);

CHOpis1 = CHOptions:CreateFontString(nil, "ARTWORK");
CHOpis1:SetFontObject(GameFontNormalLarge);
CHOpis1:SetJustifyH("LEFT");
CHOpis1:SetJustifyV("TOP");
CHOpis1:ClearAllPoints();
CHOpis1:SetPoint("TOPLEFT", CHslider1, "BOTTOMLEFT", -260, 30);
local fontsize = tonumber(CH_PM["fontsize"]);
if (CH_PM["setsize"]=="1") then
   CHOpis1:SetFont(CH_Font, fontsize);
else
   CHOpis1:SetFont(CH_Font, 18);
end
CHOpis1:SetText(AS_UTF8reverseRS("نموذج نص حجم الخط"));       -- przykładowy tekst
CHOpis1:SetJustifyH("RIGHT");

local select_opts = 
   {
   ['name'] = 'CHfontChoice',
   ['parent'] = CHOptions,
   ['title'] = AS_UTF8reverseRS('ملف اختيار الخط العربي:'),
   ['items']= {'calibri.ttf', 'arial.ttf' },   -- nazwy plików z czcionkami arabskimi do wyboru przez gracza
   ['defaultVal'] = CH_PM["fontname"], 
   ['changeFunc'] = function(dropdown_frame, dropdown_val)
      CH_PM["fontname"] = dropdown_val;
      CH_Font = "Interface\\AddOns\\WoWinArabic_Chat\\Fonts\\" .. CH_PM["fontname"];
      CHOptionsHeader:SetFont(CH_Font, 16);
--      CHOptionsHeader:SetText("2023 ﺔﻨﺴﻟ Platine ﺭﻮﻄﻤﻟﺍ "..CH_version.." ﺔﺨﺴﻧ WoWinArabic-Chat ﺔﻓﺎﺿﺇ");
      CHDateOfBase:SetFont(CH_Font, 16);
--      CHDateOfBase:SetText("DragonArab ﺔﻴﺑﺮﻌﻟﺍ ﺔﻐﻠﻟﺍ ﻞﻴﻜﺸﺗ ﺭﻮﻄﻣ");
      CHCheckButton1.Text:SetFont(CH_Font, 18);
      CHCheckButton1.Text:SetText(AS_UTF8reverseRS(CH_Interface.active));
      CHOptionsMode:SetText(":"..AS_UTF8reverseRS(CH_Interface.settings));          -- Ustawienia dodatku
      CHOptionsMode:SetFont(CH_Font, 18);
      CHCheckSize.Text:SetFont(CH_Font, 18);
      CHCheckSize.Text:SetText(AS_UTF8reverseRS(CH_Interface.font_activ));   
      getglobal(CHslider1:GetName() .. 'Text'):SetFont(CH_Font, 16);
      getglobal(CHslider1:GetName() .. 'Text'):SetText(AS_UTF8reverseRS(CH_Interface.font_size));
      if (CH_PM["setsize"]=="1") then
         CHOpis1:SetFont(CH_Font, fontsize);
      else
         CHOpis1:SetFont(CH_Font, 18);
      end
      CHOpis1:SetText(AS_UTF8reverseRS("نموذج نص حجم الخط"));       -- przykładowy tekst
      local okno_width = SettingsPanel.Container:GetWidth();
      local text1_width = CHCheckButton1.Text:GetWidth();
      local text2_width = CHCheckSize.Text:GetWidth();
      CHCheckButton1:SetPoint("TOPLEFT", okno_width-text1_width-70, -90);
      CHCheckButton1.CheckBox:SetPoint("TOPLEFT", text1_width+10, 2);
      CHCheckSize:SetPoint("TOPLEFT", okno_width-text2_width-105, -200);
      CHCheckSize.CheckBox:SetPoint("TOPLEFT",  text2_width+10, 2);
      end
   }
local CHselectDD = CH_createDropdown(select_opts);    -- rozwijane w dół menu wyboru czcionki arabskiej
CHselectDD:ClearAllPoints();
CHselectDD:SetPoint("TOPRIGHT",  -50, -510);


local CHText0 = CHOptions:CreateFontString(nil, "ARTWORK");
CHText0:SetFontObject(GameFontWhite);
CHText0:SetJustifyH("LEFT");
CHText0:SetJustifyV("TOP");
CHText0:ClearAllPoints();
CHText0:SetPoint("BOTTOMLEFT", 16, 90);
CHText0:SetFont(CH_Font, 13);
CHText0:SetText("Quick commands from the chat line:");

local CHText7 = CHOptions:CreateFontString(nil, "ARTWORK");
CHText7:SetFontObject(GameFontWhite);
CHText7:SetJustifyH("LEFT");
CHText7:SetJustifyV("TOP");
CHText7:ClearAllPoints();
CHText7:SetPoint("TOPLEFT", CHText0, "BOTTOMLEFT", 0, -10);
CHText7:SetFont(CH_Font, 13);
CHText7:SetText("/archat   to bring up this addon settings window");

local CHText1 = CHOptions:CreateFontString(nil, "ARTWORK");
CHText1:SetFontObject(GameFontWhite);
CHText1:SetJustifyH("LEFT");
CHText1:SetJustifyV("TOP");
CHText1:ClearAllPoints();
CHText1:SetPoint("TOPLEFT", CHText7, "BOTTOMLEFT", 0, -10);
CHText1:SetFont(CH_Font, 13);
CHText1:SetText("/archat 1  or  /archat on   to activate the addon");

local CHText2 = CHOptions:CreateFontString(nil, "ARTWORK");
CHText2:SetFontObject(GameFontWhite);
CHText2:SetJustifyH("LEFT");
CHText2:SetJustifyV("TOP");
CHText2:ClearAllPoints();
CHText2:SetPoint("TOPLEFT", CHText1, "BOTTOMLEFT", 0, -4);
CHText2:SetFont(CH_Font, 13);
CHText2:SetText("/archat 0  or  /archat off   to deactivate the addon");

end

-------------------------------------------------------------------------------------------------------

local function CH_SlashCommand(msg)
  -- check the command
  if (msg) then
     local CH_command = string.lower(msg);                -- normalizacja, tylko małe litery
     if ((CH_command=="on") or (CH_command=="1")) then    -- włącz przełącznik aktywności
        CH_PM["active"]="1";
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00WoWinArabic-Chat is active now");
     elseif ((CH_command=="off") or (CH_command=="0")) then
        CH_PM["active"]="0";
        DEFAULT_CHAT_FRAME:AddMessage("|cffffff00WoWinArabic-Chat is inactive now");
     else
        Settings.OpenToCategory("WoWinArabic-Chat");
     end   
  end
end

-------------------------------------------------------------------------------------------------------

function CHAT_START()
   local _fontC, _sizeC, _C = DEFAULT_CHAT_FRAME:GetFont(); -- odczytaj aktualną czcionkę, rozmiar i typ
   DEFAULT_CHAT_FRAME:SetFont(CH_Font, _sizeC, _C);
   local _fontC, _sizeC, _C = DEFAULT_CHAT_FRAME.editBox:GetFont(); -- odczytaj aktualną czcionkę, rozmiar i typ
   DEFAULT_CHAT_FRAME.editBox:SetFont(CH_Font, _sizeC, _C);
   DEFAULT_CHAT_FRAME.editBox:SetScript("OnChar", CH_OnChar);       -- aby zmieniał pozycję kursora przy wprowadzaniu kolejnych liter
   DEFAULT_CHAT_FRAME.editBox:SetScript("OnKeyDown", CH_OnKeyDown); -- wciśnięto jakiś klawisz
   DEFAULT_CHAT_FRAME.editBox:SetScript("OnKeyUp", CH_OnKeyUp);     -- puszczono jakiś klawisz
   DEFAULT_CHAT_FRAME.editBox:SetScript("OnShow", CH_OnShow);       -- otworzono okno edycji tekstu
   DEFAULT_CHAT_FRAME.editBox:SetScript("OnHide", CH_OnHide);       -- zamknięto okno edycji tekstu
   
   for i=1, 10, 1 do       -- edit Boxes other Tabs
      getglobal("ChatFrame" .. tostring(i) .. "EditBox"):SetFont(CH_Font, _sizeC, _C);
      getglobal("ChatFrame" .. tostring(i) .. "EditBox"):SetScript("OnChar", CH_OnChar);       -- aby zmieniał pozycję kursora przy wprowadzaniu kolejnych liter
      getglobal("ChatFrame" .. tostring(i) .. "EditBox"):SetScript("OnKeyDown", CH_OnKeyDown); -- wciśnięto jakiś klawisz
      getglobal("ChatFrame" .. tostring(i) .. "EditBox"):SetScript("OnKeyUp", CH_OnKeyUp);     -- puszczono jakiś klawisz
      getglobal("ChatFrame" .. tostring(i) .. "EditBox"):SetScript("OnShow", CH_OnShow);       -- otworzono okno edycji tekstu
      getglobal("ChatFrame" .. tostring(i) .. "EditBox"):SetScript("OnHide", CH_OnHide);       -- zamknięto okno edycji tekstu
   end
   
   CH_ToggleButton = CreateFrame("Button", nil, DEFAULT_CHAT_FRAME, "UIPanelButtonTemplate");
   CH_ToggleButton:SetWidth(34);
   CH_ToggleButton:SetHeight(20);
   CH_ToggleButton:SetNormalFontObject("GameFontRed");      -- litery EN czerwone
   CH_ToggleButton:SetText("EN");
   CH_ToggleButton:Show();
   CH_ToggleButton:ClearAllPoints();
   CH_ToggleButton:SetPoint("TOPRIGHT", DEFAULT_CHAT_FRAME, "BOTTOMLEFT", 1, -8);
   CH_ToggleButton:SetScript("OnClick", CH_AR_ON_OFF);

   CH_ToggleButton2 = CreateFrame("Button", nil, DEFAULT_CHAT_FRAME.editBox, "UIPanelButtonTemplate");
   CH_ToggleButton2:SetWidth(34);
   CH_ToggleButton2:SetHeight(20);
   CH_ToggleButton2:SetNormalFontObject("GameFontRed");      -- litery EN czerwone
   CH_ToggleButton2:SetText("EN");
   CH_ToggleButton2:Hide();
   CH_ToggleButton2:ClearAllPoints();
   CH_ToggleButton2:SetPoint("TOPRIGHT", DEFAULT_CHAT_FRAME.editBox, "TOPLEFT", 4, -4);
   CH_ToggleButton2:SetScript("OnClick", CH_AR_ON_OFF);

   CH_InsertButton = CreateFrame("Button", nil, DEFAULT_CHAT_FRAME.editBox, "UIPanelButtonTemplate");
   CH_InsertButton:SetWidth(28);
   CH_InsertButton:SetHeight(20);
   CH_InsertButton.Text:SetFont(CH_Font, 14, _C);
   CH_InsertButton:SetText("←");
   CH_InsertButton:Hide();
   CH_InsertButton:ClearAllPoints();
   if (Prat) then       -- jest aktywny dodatek Prat
      CH_InsertButton:SetPoint("TOPLEFT", DEFAULT_CHAT_FRAME.editBox, "TOPRIGHT", -2, -1);
   else
      CH_InsertButton:SetPoint("TOPLEFT", DEFAULT_CHAT_FRAME.editBox, "TOPRIGHT", -9, -6);
   end
   CH_InsertButton:SetScript("OnClick", CH_INS_ON_OFF);

   ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", CH_ChatFilter);
   ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", CH_ChatFilter);
   
   SlashCmdList["WOWAR"] = function(msg) CH_SlashCommand(msg); end
   SLASH_WOWINARABIC_CHAT1 = "/archat";
   CH_CheckVars();
--   CH_BlizzardOptions();
   
end

-------------------------------------------------------------------------------------------------------

function CH_CreateTestLine()
   CH_TestLine = CreateFrame("Frame", "CH_TestLine", UIParent, "BasicFrameTemplateWithInset");
   CH_TestLine:SetHeight(150);
   CH_TestLine:SetWidth(DEFAULT_CHAT_FRAME:GetWidth()+50);
   CH_TestLine:ClearAllPoints();
   CH_TestLine:SetPoint("TOPLEFT", 20, -300);
   CH_TestLine.title = CH_TestLine:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
   CH_TestLine.title:SetPoint("CENTER", CH_TestLine.TitleBg);
   CH_TestLine.title:SetText("Frame for testing width of text");
   CH_TestLine.ScrollFrame = CreateFrame("ScrollFrame", nil, CH_TestLine, "UIPanelScrollFrameTemplate");
   CH_TestLine.ScrollFrame:SetPoint("TOPLEFT", CH_TestLine.InsetBg, "TOPLEFT", 10, -40);
   CH_TestLine.ScrollFrame:SetPoint("BOTTOMRIGHT", CH_TestLine.InsetBg, "BOTTOMRIGHT", -5, 10);
  
   CH_TestLine.ScrollFrame.ScrollBar:ClearAllPoints();
   CH_TestLine.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", CH_TestLine.ScrollFrame, "TOPRIGHT", -12, -18);
   CH_TestLine.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", CH_TestLine.ScrollFrame, "BOTTOMRIGHT", -7, 15);
   CHchild = CreateFrame("Frame", nil, CH_TestLine.ScrollFrame);
   CHchild:SetSize(552,100);
   CHchild.bg = CHchild:CreateTexture(nil, "BACKGROUND");
   CHchild.bg:SetAllPoints(true);
   CHchild.bg:SetColorTexture(0, 0.05, 0.1, 0.8);
   CH_TestLine.ScrollFrame:SetScrollChild(CHchild);
   CH_TestLine.text = CHchild:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
   CH_TestLine.text:SetPoint("TOPLEFT", CHchild, "TOPLEFT", 2, 0);
   CH_TestLine.text:SetText("");
   CH_TestLine.text:SetSize(DEFAULT_CHAT_FRAME:GetWidth(),0);
   CH_TestLine.text:SetJustifyH("LEFT");
   CH_TestLine.CloseButton:SetPoint("TOPRIGHT", CH_TestLine, "TOPRIGHT", 0, 0);
   CH_TestLine:Hide();     -- the frame is invisible in the game
end

-------------------------------------------------------------------------------------------------------

-- function formats arabic text for display in a left-justified chat line
function CH_LineChat(txt, font_size)
   local retstr = "";
  
   if (txt and font_size) then
      if (CH_TestLine == nil) then     -- a own frame for displaying the translation of texts and determining the length
         CH_CreateTestLine();
      end   
      local bytes = strlen(txt);
      local pos = bytes;
      local counter = 0;
      local second = 0;
      local link_start_stop = false;
      local newstr = "";
      local nextstr = "";
      local charbytes;
      local newstrR;
      local char1 = "";
      local char2 = "";
      local last_space = 0;
      while (pos > 0) do       -- UWAGA: tekst arabski jest podany wprost, od prawej: sprawdzaj długość od prawej
         c = strbyte(txt, pos);
         while (c >= 128) and (c <= 191) do
            pos = pos - 1;
            c = strbyte(txt, pos);
         end
      
         charbytes = AS_UTF8charbytes(txt, pos);
         char1 = strsub(txt, pos, pos + charbytes - 1);

         newstr = char1 .. newstr;        -- sprawdzamy znaki od ostatnich
         
         if ((char1..char2 == "|r") and (pos < bytes)) then          -- start of the link
            link_start_stop = true;
         elseif ((char1..char2 == "|c") and (pos < bytes)) then      -- end of the link
            link_start_stop = false;
         end
         
         if ((char1 == " ") and (link_start_stop == false)) then     -- mamy spację, nie wewnątrz linku
            last_space = 0;
            nextstr = "";
         else
            nextstr = char1 .. nextstr;
            last_space = last_space + 1;
         end
         if (link_start_stop == false) then           -- nie jesteśmy wewnątrz linku - można sprawdzać
            if (Prat) then       -- jest aktywny dodatek Prat
               CH_TestLine.text:SetWidth(DEFAULT_CHAT_FRAME:GetWidth()-(0.35*font_size+0.8)*10);     -- czas w dodatku Prat zabiera nam miejsce
            else
               CH_TestLine.text:SetWidth(DEFAULT_CHAT_FRAME:GetWidth());
            end
            CH_TestLine.text:SetText(newstr);
            if (CH_TestLine.text:GetHeight() > font_size*1.5) then   -- tekst nie mieści się już w 1 linii
               newstr = AS_UTF8sub(newstr, last_space+1);            -- tekst od ostatniej spacji
               newstrR = CH_AddSpaces(newstr, second);
               retstr = retstr .. newstrR .. "\n";
               newstr = nextstr;
               nextstr = "";
               counter = 0;
               second = 3;  
            end
         end
         char2 = char1;    -- zapamiętaj znak, potrzebne w następnej pętli
         pos = pos - 1;
      end
      newstrR = CH_AddSpaces(newstr, second);
      retstr = retstr .. newstrR;
      retstr = string.gsub(retstr, " \n", "\n");        -- space before newline code is useless
      retstr = string.gsub(retstr, "\n ", "\n");        -- space after newline code is useless
   end
   return retstr;
end

-------------------------------------------------------------------------------------------------------

-- the function appends spaces to the left of the given text so that the text is aligned to the right
function CH_AddSpaces(txt, snd)                                 -- snd = second or next line (interspace 2 on right)
   local _fontC, _sizeC, _C = DEFAULT_CHAT_FRAME:GetFont();     -- read current font, size and flag of the chat object
   local chars_limitC = 300;    -- so much max. characters can fit on one line
   
   if (CH_TestLine == nil) then     -- a own frame for displaying the translation of texts and determining the length
      CH_CreateTestLine();
   end   
   if ((Prat) and (snd==0)) then       -- jest aktywny dodatek Prat
      CH_TestLine.text:SetWidth(DEFAULT_CHAT_FRAME:GetWidth()-(0.35*_sizeC+0.8)*10);     -- czas w dodatku Prat zabiera nam miejsce
   else
      CH_TestLine.text:SetWidth(DEFAULT_CHAT_FRAME:GetWidth());
   end
   CH_TestLine.text:SetFont(_fontC, _sizeC, _C);
   CH_TestLine:Hide();     -- the frame is invisible in the game
   local count = 0;
   local text = txt;
   CH_TestLine.text:SetText(text);
   while ((CH_TestLine.text:GetHeight() < _sizeC*1.5) and (count < chars_limitC)) do
      count = count + 1;
      text = " "..text;
      CH_TestLine.text:SetText(text);
   end
   if (count < chars_limitC) then    -- failed to properly add leading spaces
      for i=4,count-snd,1 do         -- spaces are added to the left of the text
         txt = " "..txt;
      end
   end
   CH_TestLine.text:SetText(txt);
   
   return(txt);
end

-------------------------------------------------------------------------------------------------------

-- Reverses the order of UTF-8 letters, without arabic reshaping
function CH_UTF8reverse(s)
   local newstr = "";
   if (s) then                                   -- check if argument is not empty (nil)
      local bytes = strlen(s);
      local pos = 1;
      local char1;
      local charbytes1;

      while (pos <= bytes) do
         charbytes1 = AS_UTF8charbytes(s, pos);         -- count of bytes (liczba bajtów znaku)
         char1 = strsub(s, pos, pos + charbytes1 - 1);  -- current character
         pos = pos + charbytes1;
         newstr = char1 .. newstr;
      end
   end
   return newstr;
end

-------------------------------------------------------------------------------------------------------

function CH_mysplit(inputstr, sep)
   if (sep == nil) then
      sep = "%s";
   end
   local t={};
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str);
   end
   return t;
end

-------------------------------------------------------------------------------------------------------

function CH_SpecifyBubbleWidth(str_txt, reg)
   local vlines = CH_mysplit(str_txt,"\n");
   local _fontR, _sizeR, _R = reg:GetFont();   -- odczytaj aktualną czcionkę i rozmiar
   local max_width = 20;
   for _, v in ipairs(vlines) do 
      if (CH_TestLine == nil) then     -- a own frame for displaying the translation of texts and determining the length
         CH_CreateTestLine();
      end   
      CH_TestLine:Hide();     -- the frame is invisible in the game
      CH_TestLine.text:SetFont(_fontR, _sizeR, _R);
      local newTextWidth = (0.35*act_font+0.8)*AS_UTF8len(v)*1.5;  -- maksymalna szerokość okna dymku
      CH_TestLine.text:SetWidth(newTextWidth);
      CH_TestLine.text:SetText(v);
      local minTextWidth = (0.35*act_font+0.8)*AS_UTF8len(v)*0.8;  -- minimalna szerokość ograniczająca pętlę
      
      while ((CH_TestLine.text:GetHeight() < _sizeR*1.5) and (minTextWidth < newTextWidth)) do
         newTextWidth = newTextWidth - 5;
         CH_TestLine.text:SetWidth(newTextWidth);
      end
      if (newTextWidth > max_width) then
         max_width = newTextWidth;
      end
   end
   return max_width + 5;
end

-------------------------------------------------------------------------------------------------------

-- Reverses the order of UTF-8 letters in (limit) lines: 2 or 3 
function CH_LineReverse(s, limit)
   local retstr = "";
   if (s and limit) then                           -- check if arguments are not empty (nil)
      local bytes = strlen(s);
      local count_chars = AS_UTF8len(s);           -- number of characters in a string s
      local limit_chars = count_chars / limit;     -- limit characters on one line (+-)
      local pos = bytes;
      local charbytes;
      local newstr = "";
      local counter = 0;
      local char1;
      while (pos > 0) do
         c = strbyte(s, pos);                      -- read the character (odczytaj znak)
         while c >= 128 and c <= 191 do
            pos = pos - 1;                         -- cofnij się na początek litery UTF-8
            c = strbyte(s, pos);
         end
         charbytes = AS_UTF8charbytes(s, pos);    -- count of bytes (liczba bajtów znaku)
         char1 = strsub(s, pos, pos + charbytes - 1);
         newstr = char1 .. newstr;
         
         counter = counter + 1;
         if ((char1 >= "A") and (char1 <= "z")) then
            counter = counter + 1;        -- latin letters are 2x wider, then Arabic
         end
         if ((char1 == " ") and (counter>=limit_chars-3)) then      -- break line here
            retstr = retstr .. newstr .. "\n";
            newstr = "";
            counter = 0;
         end
      pos = pos - 1;
      end
      retstr = retstr .. newstr;
      retstr = string.gsub(retstr, "\n ", "\n");        -- space after newline code is useless
   end
	return retstr;
end 

-------------------------------------------------------------------------------------------------------

CH_IsolatedLetter = {
   ["form"] = "isolated",  -- form letters are in UTF-8 code > U+FE80,  isolated letters are in UTF-8 code < U+0650
   
   ["ﺍ"] = "ا",  ["ﺎ"] = "ا",  -- ALEF: isolated & initial, middle & final form
   ["ﺁ"] = "آ",  ["ﺂ"] = "آ",  -- ALEF WITH MADA ABOVE:  isolated & initial, middle & final form
   ["ﺃ"] = "أ",  ["ﺄ"] = "أ",  -- ALEF WITH HAMZA ABOVE: isolated & initial, middle & final form
   ["ﺇ"] = "إ",  ["ﺈ"] = "إ",  -- ALEF WITH HAMZA BELOW: isolated & initial, middle & final form
   ["ﺑ"] = "ب",  ["ﺒ"] = "ب",  ["ﺐ"] = "ب",  -- BA:  initial, middle, final form
   ["ﺗ"] = "ت",  ["ﺜ"] = "ت",  ["ﺚ"] = "ت",  -- THA: initial, middle, final form
   ["ﺟ"] = "ج",  ["ﺠ"] = "ج",  ["ﺞ"] = "ج",  -- JIM: initial, middle, final form
   ["ﺣ"] = "ح",  ["ﺤ"] = "ح",  ["ﺢ"] = "ح",  -- HAH: initial, middle, final form
   ["ﺧ"] = "خ",  ["ﺨ"] = "خ",  ["ﺦ"] = "خ",  -- KHAH:initial, middle, final form
   ["ﺩ"] = "د",  ["ﺪ"] = "د",  -- DAL:  isolated & initial, middle & final form
   ["ﺫ"] = "ذ",  ["ﺬ"] = "ذ",  -- DHAL: isolated & initial, middle & final form
   ["ﺭ"] = "ر",  ["ﺮ"] = "ر",  -- RA:   isolated & initial, middle & final form
   ["ﺯ"] = "ز",  ["ﺰ"] = "ز",  -- ZAIN: isolated & initial, middle & final form
   ["ﺳ"] = "س",  ["ﺴ"] = "س",  ["ﺲ"] = "س",  -- SIN: initial, middle, final form
   ["ﺷ"] = "ش",  ["ﺸ"] = "ش",  ["ﺶ"] = "ش",  -- SHIN: initial, middle, final form
   ["ﺻ"] = "ص",  ["ﺼ"] = "ص",  ["ﺺ"] = "ص",  -- SAD: initial, middle, final form
   ["ﺿ"] = "ض",  ["ﻀ"] = "ض",  ["ﺾ"] = "ض",  -- DAD: initial, middle, final form
   ["ﻃ"] = "ط",  ["ﻂ"] = "ط",  -- TAH: initial, middle & final form
   ["ﻇ"] = "ظ",  ["ﻈ"] = "ظ",  ["ﻆ"] = "ظ",  -- ZAH: initial, middle, final form
   ["ﻋ"] = "ع",  ["ﻌ"] = "ع",  ["ﻊ"] = "ع",  -- AIN: initial, middle, final form
   ["ﻏ"] = "غ",  ["ﻐ"] = "غ",  ["ﻎ"] = "غ",  -- GHAIN: initial, middle, final form
   ["ﻓ"] = "ف",  ["ﻔ"] = "ف",  ["ﻒ"] = "ف",  -- FEH: initial, middle, final form
   ["ﻗ"] = "ق",  ["ﻘ"] = "ق",  ["ﻖ"] = "ق",  -- QAF: initial, middle, final form
   ["ﻛ"] = "ك",  ["ﻜ"] = "ك",  ["ﻚ"] = "ك",  -- KAF: initial, middle, final form
   ["ﻟ"] = "ل",  ["ﻠ"] = "ل",  ["ﻞ"] = "ل",  -- LAM: initial, middle, final form
   ["ﻣ"] = "م",  ["ﻤ"] = "م",  ["ﻢ"] = "م",  -- MIM: initial, middle, final form
   ["ﻧ"] = "ن",  ["ﻨ"] = "ن",  ["ﻦ"] = "ن",  -- NUN: initial, middle, final form
   ["ﻳ"] = "ي",  ["ﻴ"] = "ي",  ["ﻲ"] = "ي",  -- YA: initial, middle, final form
   ["ﺉ"] = "ئ",  ["ﺋ"] = "ئ",  ["ﺌ"] = "ئ",  ["ﺊ"] = "ئ",  -- YEH WITH HAMZA ABOVE: isolated, initial, middle, final form
   ["ﻯ"] = "ى",  ["ﻰ"] = "ى",  -- ALEF MAKSURA: isolated & initial & middle, final form
   ["ﻭ"] = "و",  ["ﻮ"] = "و",  -- WAW: isolated & initial, middle & final form
   ["ﺅ"] = "ؤ",  ["ﺆ"] = "ؤ",  -- WAW WITH HAMZA ABOVE: isolated & initial, middle & final form
   ["ﻩ"] = "ه",  ["ﻫ"] = "ه", ["ﻬ"] = "ه", ["ﻪ"] = "ه",  -- HAH: isolated, initial, middle, final form
   ["ﺓ"] = "ة",  ["ﺔ"] = "ة",  -- TAH: isolated & initial & middle, final form
   ["ﻼ"] = "ﻻ",  -- LAM WITH ALEF: middle & final form
   ["ﻶ"] = "ﻵ",  -- LAM WITH ALEF WITH MADDA: middle & final form
   ["ﻸ"] = "لأ",  -- LAM WITH ALEF WITH HAMZA ABOVE: middle & final form
   ["ﻺ"] = "لإ",  -- LAM WITH ALEF WITH HAMZA BELOW: middle & final form
   ["ﺀ"] = "ء",  -- HAMZA: initial & middle & final form

   ["ﻻ"] = "ل".."ا",  ["ﻼ"] = "ل".."ا",  -- Arabic ligature LAM with ALEF: isolated & initial, middle & final form
   ["ﻷ"] = "ل".."أ",  ["ﻸ"] = "ل".."أ",  -- Arabic ligature LAM with ALEF with HAMZA above: isolated & initial, middle & final form
   ["ﻹ"] = "ل".."إ",  ["ﻺ"] = "ل".."إ",  -- Arabic ligature LAM with ALEF with HAMZA below: isolated & initial, middle & final form
   ["ﻵ"] = "ل".."آ",  ["ﻶ"] = "ل".."آ",  -- Arabic ligature LAM with ALEF with MADDA: isolated & initial, middle & final form

   };
   
