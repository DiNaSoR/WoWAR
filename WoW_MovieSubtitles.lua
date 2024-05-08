-- Addon: WoWTR-Movies (version: 10.C15) 2024.05.08
-- Description: The AddOn displays the translated text information in chosen language
-- Author: Platine
-- E-mail: platine.wow@gmail.com

-------------------------------------------------------------------------------------------------------------------

-- General Variables
MF_race = UnitRace("player");
MF_class = UnitClass("player");
local MF_movieID, MF_SubTitle, MF_lp, MF_ID, MF_playing, MF_showing, MF_timer, MF_time1, MF_last_ST, MF_pytanie1, MF_pytanie2;
if (MF_class == "Death Knight") then
   MF_race = MF_class;
end

-- wielkość czcionki ze znakami diakrytycznymi
MF_Size = 16;

-------------------------------------------------------------------------------------------------------------------

function BB_FindProS(text)                 -- znajdź, czy jest tekst '%s' w podanym tłumaczeniu
   local dl_txt = string.len(text)-1;
   for i_j=1,dl_txt,1 do
      if (strsub(text,i_j,i_j+1)=="%s") then       
         return i_j;
      end
   end
   return 0;
end

-------------------------------------------------------------------------------------------------------------------

function MF_ShowMovieSubtitles()       -- wyświetlanie napisów w MOVIES
   local MF_readed_ST = SubtitlesFrame.Subtitle1:GetText();
   if (MF_readed_ST and (MF_readed_ST ~= MF_last_ST) and (string.find(MF_readed_ST," ")==nil)) then   -- napis jest inny niż ostatni
      MF_readed_ST = WOWTR_DetectAndReplacePlayerName(MF_readed_ST);
      local MF_readed_HS = WOWTR_DeleteSpecialCodes(MF_readed_ST);
      MF_lp = MF_lp + 1;                                                             -- oraz nie jest to tekst tłumaczenia
      local MF_lpSTR = tostring(MF_lp);
      if (MF_lp<10) then
         MF_lpSTR = "0"..MF_lpSTR;
      end
      MF_last_ST = MF_readed_ST;             -- zapisz jako ostatni napis
      MF_hash2 = StringHash(MF_readed_HS);
      if (MF_Hash[MF_hash2] or BB_Bubbles[MF_hash2]) then   -- jest w bazie tłumaczenie napisu
         SubtitlesFrame.Subtitle1:SetText(QTR_ExpandUnitInfo(MF_Hash[MF_hash2],false,SubtitlesFrame.Subtitle1,WOWTR_Font2,-20 or BB_Bubbles[MF_hash2],false,SubtitlesFrame.Subtitle1,WOWTR_Font2,-20) .. " ");  -- twarda spacja na końcu
         SubtitlesFrame.Subtitle1:SetFont(WOWTR_Font2, MF_Size); 
      else           -- nie ma tego Hasha - zapisz dane
         if (MF_PM["save"] == "1") then
            MF_PS[MF_ID..":"..MF_lpSTR..":"..MF_hash2] = MF_readed_ST;
         end;
      end
   end
end

-------------------------------------------------------------------------------------------------------------------

function MF_ShowCinematicSubtitles()            -- wyświetlanie napisów w CINEMATIC
   if (GetTime() - MF_time1 > 0.1) then         -- minęło conajmniej 0.1 sek.
      if (SubtitlesFrame.Subtitle1 and SubtitlesFrame.Subtitle1:IsVisible()) then        -- jest widoczny napis
         local MF_napis = SubtitlesFrame.Subtitle1:GetText();     -- odczytaj aktualny napis
         if (MF_napis and (string.len(MF_napis)>0) and (string.find(MF_napis," ")==nil)) then  -- znak ' ' wskazuje na tekst turecki (twarda spacja)
            MF_time1 = GetTime() + 1;                             -- +1 sek. nie trzeba sprawdzać
            local MF_zapisz_EN = true;
            MF_napis = WOWTR_DetectAndReplacePlayerName(MF_napis);   -- przeszukaj tekst i zamien na kody $x
            local MF_napis_HS = WOWTR_DeleteSpecialCodes(MF_napis);
            local MF_hash = StringHash(MF_napis_HS);                 -- zrób Hash z tego tekstu
            local p1, p2 = string.find(MF_napis,":");             -- poszukaj znaku ':'
            if (p1 and (p1>0) and (p1<30)) then                   -- jest znak ':' w początkowej części napisu (NPC says:)
               local MF_napis2 = WOWTR_DetectAndReplacePlayerName(string.sub(MF_napis, p1+2));
               local MF_napis2_HS = WOWTR_DeleteSpecialCodes(MF_napis2);
               local MF_hash2 = StringHash(MF_napis2_HS);
               if (BB_Bubbles[MF_hash2] or MF_Hash[MF_hash2]) then                           -- istnieje tłumaczenie w dymkach
                  if (WoWTR_Localization.lang == 'AR') then
                     local MF_output = "r|"..WOWTR_AnsiReverse(string.sub(MF_napis,1,p1-1)).." :0099FFFFc| "..WOW_ZmienKody(BB_Bubbles[MF_hash2] or MF_Hash[MF_hash2]);
                     SubtitlesFrame.Subtitle1:SetText(QTR_ExpandUnitInfo((MF_output),false,SubtitlesFrame.Subtitle1,WOWTR_Font1).." ");         -- podmień wyświetlany tekst dodając twardą spację
                     MF_zapisz_EN = false;
                  else
                     local MF_output = "|cFFFF9900"..string.sub(MF_napis,1,p1-1).." :|r "..WOW_ZmienKody(BB_Bubbles[MF_hash2] or MF_Hash[MF_hash2]);
                     SubtitlesFrame.Subtitle1:SetText(MF_output.." ");         -- podmień wyświetlany tekst dodając twardą spację
                     MF_zapisz_EN = false;
                  end
               else
                  if ((MF_zapisz_EN) and (MF_PM["save"] == "1")) then       -- zapisz oryginalny tekst wraz z kodem Hash
                     MF_PS[tostring(MF_hash2)] = MF_napis2.."@"..WOWTR_player_name..":"..WOWTR_player_race..":"..WOWTR_player_class;       
                  end
               end
            else
               if (BB_Bubbles[MF_hash] or MF_Hash[MF_hash]) then            -- istnieje tłumaczenie w dymkach
                  local MF_tekst = WOW_ZmienKody(BB_Bubbles[MF_hash] or MF_Hash[MF_hash]);
                  local nr_poz = BB_FindProS(MF_tekst,1);   -- znajdź tekst '%s'
                  if (strsub(MF_tekst,1,2)=="%o") then 
                     MF_tekst = strsub(MF_tekst, 3):gsub("^%s*", "");
                  elseif (nr_poz>0) then           -- mamy formę opisową dymku %s np. NPC_name wpada w szał!
                     if (nr_poz==1) then
                        MF_tekst = name_NPC..strsub(MF_tekst, 3);
                     else
                        MF_tekst = strsub(MF_tekst,1,nr_poz-1)..name_NPC..strsub(MF_tekst, nr_poz+2);
                     end
                  end
                  local MF_output = MF_tekst.."";
                  local _font, _size, _3 = SubtitlesFrame.Subtitle1:GetFont();         -- odczytaj wielkość czcionki
                  SubtitlesFrame.Subtitle1:SetText(QTR_ExpandUnitInfo(MF_output,false,SubtitlesFrame.Subtitle1,WOWTR_Font1,-200).." ");   -- podmień wyświetlany tekst dodając twardą spację
                  SubtitlesFrame.Subtitle1:SetJustifyH("CENTER");
                  MF_zapisz_EN = false;
               else
                  if ((MF_zapisz_EN) and (MF_PM["save"] == "1")) then             -- zapisz oryginalny tekst wraz z kodem Hash
                     MF_PS[tostring(MF_hash)] = MF_napis.."@"..WOWTR_player_name..":"..WOWTR_player_race..":"..WOWTR_player_class;       
                  end
               end
            end
         end
      end
   end
end

-------------------------------------------------------------------------------------------------------------------

function MF_ShowCinematicIntro()    -- wyświetlanie własnych napisów w INTRO
   if (MF_playing==false) then         
      MF_timer = GetTime();         -- wystartuj zegar filmu
      MF_playing=true;
   end
   if ((MF_showing==false) and (GetTime() > (MF_timer + MF_sub1))) then      -- czas wystartować napis
      MF_SubTitle:SetText(QTR_ReverseIfAR(MF_sub3));
      MF_showing=true;
   end      
   if ((MF_showing==true) and (GetTime() > (MF_timer + MF_sub2))) then       -- czas zatrzymać napis
      MF_SubTitle:SetText("");
      -- ładuj następny
      MF_showing=false;
      MF_lp = MF_lp + 1;
      local MF_lpSTR = tostring(MF_lp);
      if (MF_lp<10) then
         MF_lpSTR = "0"..MF_lpSTR;
      end
      if (MF_Data[MF_race..":"..MF_lpSTR]) then
         MF_sub1 = MF_Data[MF_race..":"..MF_lpSTR]["START"];
         MF_sub2 = MF_Data[MF_race..":"..MF_lpSTR]["STOP"];
         MF_sub3 = WOW_ZmienKody(MF_Data[MF_race..":"..MF_lpSTR]["NAPIS"]);
      else
         MF_sub1=1000;
         MF_sub2=1000;
      end
   end          
end

-------------------------------------------------------------------------------------------------------------------

function MF_PlayMovie(movieID)      -- fired by PLAY_MOVIE event
--print("Uruchamiam movie ID="..movieID);
   MF_movieID = movieID;
   if (MF_pytanie1 == nil) then
      MF_pytanie1 = MovieFrame.CloseDialog:CreateFontString(nil, "ARTWORK");
      MF_pytanie1:SetFontObject(GameFontNormal);
--      MF_pytanie1:SetJustifyH("CENTER");
--      MF_pytanie1:SetJustifyV("CENTER");
      MF_pytanie1:ClearAllPoints();
      MF_pytanie1:SetPoint("CENTER", MovieFrame.CloseDialog, "CENTER", 0, 6);
      MF_pytanie1:SetFont(WOWTR_Font2, 13);
      MF_pytanie1:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovie));
   end
   MovieFrame.CloseDialog.ConfirmButton:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieYes));
   MovieFrame.CloseDialog.ResumeButton:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieNo));
   local regions = { MovieFrame.CloseDialog.ConfirmButton:GetRegions() };
   for index = 1, #regions do
      local region = regions[index];
      if (region:GetObjectType() == "FontString") then
         region:SetFont(WOWTR_Font2, 15);
      end
   end
   local regions = { MovieFrame.CloseDialog.ResumeButton:GetRegions() };
   for index = 1, #regions do
      local region = regions[index];
      if (region:GetObjectType() == "FontString") then
         region:SetFont(WOWTR_Font2, 15);
      end
   end
   MovieFrame:EnableSubtitles(true);      -- włącz wyświetlanie napisów
   MF_last_ST = "";
   MF_lp = 0;
   MF_ID = tostring(MF_movieID);
   while (string.len(MF_ID)<3) do
      MF_ID = "0"..MF_ID;
   end
   local _font, _size, _3 = SubtitlesFrame.Subtitle1:GetFont();
   SubtitlesFrame.Subtitle1:SetFont(WOWTR_Font2, _size);           -- przetłumaczona czcionka do napisów
   SubtitlesFrame:HookScript("OnEvent", MF_ShowMovieSubtitles);
   MF_Size = _size;
end

-------------------------------------------------------------------------------------------------------------------

function MF_CinematicStart()             -- fired by CINEMATIC_START event
--print("Uruchamiam Cinematic");
   if (MF_pytanie2 == nil) then
      MF_pytanie2 = CinematicFrameCloseDialog:CreateFontString(nil, "ARTWORK");
      MF_pytanie2:SetFontObject(GameFontNormal);
--      MF_pytanie2:SetJustifyH("CENTER");
--      MF_pytanie2:SetJustifyV("CENTER");
      MF_pytanie2:ClearAllPoints();
      MF_pytanie2:SetPoint("CENTER", CinematicFrameCloseDialog, "CENTER", 0, 6);
      MF_pytanie2:SetFont(WOWTR_Font2, 13);
      MF_pytanie2:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovie));
   end
   CinematicFrameCloseDialogConfirmButton:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieYes));
   CinematicFrameCloseDialogResumeButton:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieNo));
   local regions = { CinematicFrameCloseDialogConfirmButton:GetRegions() };
   for index = 1, #regions do
      local region = regions[index];
      if (region:GetObjectType() == "FontString") then
         region:SetFont(WOWTR_Font2, 15);
      end
   end
   local regions = { CinematicFrameCloseDialogResumeButton:GetRegions() };
   for index = 1, #regions do
      local region = regions[index];
      if (region:GetObjectType() == "FontString") then
         region:SetFont(WOWTR_Font2, 15);
      end
   end
   MovieFrame:EnableSubtitles(false);      -- wyłącz wyświetlanie napisów oryginalnych?
   local _font, _size, _3 = SubtitlesFrame.Subtitle1:GetFont();   -- odczytaj wielkość czcionki
   _size = math.floor(_size+.5);
   SubtitlesFrame.Subtitle1:SetFont(WOWTR_Font2, _size);              -- zmień czcionkę na turecką
   if (((UnitLevel("player")==1) and (C_Map.GetBestMapForUnit("player")~=1409) and (C_Map.GetBestMapForUnit("player")~=1726) and (C_Map.GetBestMapForUnit("player")~=1727)) or ((MF_class == "Death Knight") and (UnitLevel("player")==8))) then
      MF_SubTitle = CinematicFrame:CreateFontString(nil, "ARTWORK");    -- mamy Cinematic INTRO, ale nie z nowego zone: Exile's Reach, ani The North Sea                                      kraina: 124
      MF_SubTitle:SetFontObject(GameFontWhite);
      MF_SubTitle:SetJustifyH("CENTER"); 
      MF_SubTitle:SetJustifyV("MIDDLE");
      MF_SubTitle:ClearAllPoints();
      MF_SubTitle:SetPoint("CENTER", CinematicFrame, "BOTTOM", 0, 100);
      MF_SubTitle:SetHeight(50);
      MF_SubTitle:SetText("");
      MF_SubTitle:SetFont(WOWTR_Font2, 22);
      MF_playing = false;
      MF_lp = 1;
      MF_showing = false;
      if ((MF_Data[MF_race..":01"]) and (MF_PM["active"] == "1") and (MF_PM["intro"] == "1")) then      -- jest zezwolenie na wyświetlanie napisów w Intro
         MF_sub1 = MF_Data[MF_race..":01"]["START"];
         MF_sub2 = MF_Data[MF_race..":01"]["STOP"];
         MF_sub3 = MF_Data[MF_race..":01"]["NAPIS"];
         SubtitlesFrame.showSubtitles = false;     -- hide english subtitles
         CinematicFrame:HookScript("OnUpdate", MF_ShowCinematicIntro);
      end
   else                                      -- mamy cinematic on game
      if  ((MF_PM["active"] == "1") and (MF_PM["cinematic"] == "1")) then      -- jest zezwolenie na wyświetlanie napisów w Cinematic
         SubtitlesFrame:HookScript("OnUpdate", MF_ShowCinematicSubtitles);
         MF_time1 = GetTime();
      end
   end      
end

-------------------------------------------------------------------------------------------------------------------

function MF_CinematicStop()             -- fired by CINEMATIC_STOP event
   CinematicFrame:SetScript("OnUpdate", nil);
   -- wyłącz napisy
   if (MF_SubTitle) then
      MF_SubTitle:Hide();
   end
end
