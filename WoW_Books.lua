-- Addon: WoWTR-Books (version: 10.E6) 2024.01.22
-- Description: The AddOn displays the translated text information in chosen language
-- Author: Platine
-- E-mail: platine.wow@gmail.com

-------------------------------------------------------------------------------------------------------

-- Local Variables
local BT_act_tr = "0";
local BT_bookID = "0";
local BT_tytul_en, BT_tytul_tr, BT_tekst_en, BT_tekst_tr = "";

-------------------------------------------------------------------------------------------------------

function BookTranslator_ShowTranslation()
   if (BT_PM["active"] == "1") then
      BT_ToggleButton0:Show();
      BT_ToggleButton0:Disable();
      BT_ToggleButton0:SetText("EN");
      BT_ToggleButton0:SetWidth(40);
      BT_act_tr = "0";
      BT_tytul_en=ItemTextGetItem();
      BT_tekst_en=ItemTextGetText();
      BT_nr_str=tostring(ItemTextGetPage());
      BT_bookID = 0;
      local par1, par2, par3 = GetItemInfo(ItemTextGetItem());
      if (par2) then
         local pa1, itemID, pa3 = strsplit(":",par2);
         BT_bookID = itemID;
      else
         local BT_beginTXT=string.gsub(BT_tekst_en,"\n","");
         local BT_znacznik=BT_tytul_en.."#"..BT_nr_str.."#"..string.sub(BT_beginTXT,1,15);
         if (BT_BooksID[BT_znacznik]) then                -- jest znacznik w bazie ID - pobierz bookID
            BT_bookID = BT_BooksID[BT_znacznik];          -- jako string
         end
      end
      if (BT_bookID and (tonumber(BT_bookID)>0)) then
         if (BT_Books[BT_bookID]) then	                   -- jest tłumaczenie tej książki
            if (BT_Books[BT_bookID][BT_nr_str]) then      -- jest tłumaczenie tej strony
               if ((BT_PM["title"] == "1") and (BT_Books[BT_bookID]["Title"]~='')) then            -- wyświetlaj tłumaczenie tytułu
                  BT_tytul_tr=BT_Books[BT_bookID]["Title"];
                  ItemTextFrameTitleText:SetText(QTR_ReverseIfAR(BT_tytul_tr));
                  ItemTextFrameTitleText:SetFont(WOWTR_Font2, 13);
               end
               BT_tekst_tr=string.gsub(BT_Books[BT_bookID][BT_nr_str],"$b","$B");
               BT_tekst_tr=string.gsub(BT_tekst_tr,"$B", "\n");
               BT_tekst_tr=string.gsub(BT_tekst_tr,"$N", WOWTR_player_name);
               
               -- obsługa kodu $O(EN;PL)
               BT_tekst_tr = string.gsub(BT_tekst_tr, "$o", "$O");
               local nr_1, nr_2, nr_3 = 0;
               local QTR_forma = "";
               local NPC_sex = UnitSex("npc");       -- 1:neutral,  2:męski,  3:żeński
               local nr_poz = string.find(BT_tekst_tr, "$O");    -- gdy nie znalazł, jest: nil
               while (nr_poz and nr_poz>0) do
                  nr_1 = nr_poz + 1;   
                  while (string.sub(BT_tekst_tr, nr_1, nr_1) ~= "(") do
                     nr_1 = nr_1 + 1;
                  end
                  if (string.sub(BT_tekst_tr, nr_1, nr_1) == "(") then
                     nr_2 =  nr_1 + 1;
                     while (string.sub(BT_tekst_tr, nr_2, nr_2) ~= ";") do
                        nr_2 = nr_2 + 1;
                     end
                     if (string.sub(BT_tekst_tr, nr_2, nr_2) == ";") then
                        nr_3 = nr_2 + 1;
                        while (string.sub(BT_tekst_tr, nr_3, nr_3) ~= ")") do
                           nr_3 = nr_3 + 1;
                        end
                        if (string.sub(BT_tekst_tr, nr_3, nr_3) == ")") then
                           if (QTR_PS["ownname"] == "1") then        -- forma polska
                              QTR_forma = string.sub(BT_tekst_tr,nr_2+1,nr_3-1);
                           else                                      -- forma angielska
                              QTR_forma = string.sub(BT_tekst_tr,nr_1+1,nr_2-1);
                           end
                           BT_tekst_tr = string.sub(BT_tekst_tr,1,nr_poz-1) .. QTR_forma .. string.sub(BT_tekst_tr,nr_3+1);
                        end   
                     end
                  end
                  nr_poz = string.find(BT_tekst_tr, "$O");
               end

               local a1, a2, a3 = ItemTextPageText:GetFont("P");
               if (BT_PM["setsize"]=="1") then
                  ItemTextPageText:SetFont("P", WOWTR_Font2, tonumber(BT_PM["fontsize"]), a3);
               else
                  ItemTextPageText:SetFont("P", WOWTR_Font2, a2, a3);
               end
               ItemTextPageText:SetText(QTR_ExpandUnitInfo(BT_tekst_tr,false,ItemTextPageText,WOWTR_Font2,-10));
               if (BT_PM["showID"]=="1") then             -- pokaż ID książki
                  local fo = BT_ToggleButton0:CreateFontString();
                  if (fo.SetFont) then
                     fo:SetFont(WOWTR_Font2, 13);
                     if (WoWTR_Localization.lang == 'AR') then
                        fo:SetText("("..WoWTR_Localization.lang..") "..BT_bookID.." "..QTR_ReverseIfAR(WoWTR_Localization.bookID));
                     else
                        fo:SetText(WoWTR_Localization.bookID.." "..BT_bookID.." ("..WoWTR_Localization.lang..")");
                     end
                     BT_ToggleButton0:SetFontString(fo);
                  end
                  if (WoWTR_Localization.lang == 'AR') then
                     BT_ToggleButton0:SetText("("..WoWTR_Localization.lang..") "..BT_bookID.." "..QTR_ReverseIfAR(WoWTR_Localization.bookID));
                  else
                     BT_ToggleButton0:SetText(WoWTR_Localization.bookID.." "..BT_bookID.." ("..WoWTR_Localization.lang..")");
                  end
                  BT_ToggleButton0:SetWidth(170);
               else
                  BT_ToggleButton0:SetText(WoWTR_Localization.lang);
               end
               BT_ToggleButton0:Enable();
               BT_act_tr = "1";                           -- aktualnie jest wyświetlane polskie tłumaczenie
            else                                          -- brak tłumaczenia
               if (BT_PM["showID"] == "1") then           -- pokaż ID książki
                  local fo = BT_ToggleButton0:CreateFontString();
                  if (fo.SetFont) then
                     fo:SetFont(WOWTR_Font2, 13);
                     fo:SetText(WoWTR_Localization.bookID.." "..BT_bookID.." ("..WoWTR_Localization.lang..")");
                     BT_ToggleButton0:SetFontString(fo);
                  end
                  BT_ToggleButton0:SetText(WoWTR_Localization.bookID.." "..BT_bookID.." (EN)");
                  BT_ToggleButton0:SetWidth(170);
               end  
               BT_save_original();
            end
         else
            BT_save_original();       -- jest ID pisma,listu, ale nie ma tłumaczenia - zapisz je
         end
      end
   else
      BT_ToggleButton0:Hide();
   end
end 

-------------------------------------------------------------------------------------------------------

function BT_save_original()
   if (BT_PM["saveNW"] == "1") then              -- zapisz tekst angielski do pliku
      if (not BT_nr_str or BT_nr_str == "0") then return; end
      if (strlen(BT_nr_str)==1) then
         BT_nr_str="0"..BT_nr_str;
      end
      BT_SAVED[BT_bookID.." STR"..BT_nr_str]=BT_tytul_en.."@"..BT_tekst_en;
   end
end

-------------------------------------------------------------------------------------------------------

function BT_ON_OFF()
   if (BT_act_tr == "0") then
      BT_act_tr = "1";
      if ((BT_PM["title"] == "1") and BT_tytul_tr) then            -- wyświetlaj tłumaczenie tytułu
         ItemTextFrameTitleText:SetText(BT_tytul_tr);
      end
      ItemTextPageText:SetText(QTR_ExpandUnitInfo(BT_tekst_tr,false,ItemTextPageText,WOWTR_Font2,-10));
      if (BT_PM["showID"]=="1") then             -- pokaż ID książki
         if (WoWTR_Localization.lang == 'AR') then
            BT_ToggleButton0:SetText("("..WoWTR_Localization.lang..") "..BT_bookID.." "..QTR_ReverseIfAR(WoWTR_Localization.bookID));
         else
            BT_ToggleButton0:SetText(WoWTR_Localization.bookID.." "..BT_bookID.." ("..WoWTR_Localization.lang..")");     -- Book ID:
         end
      else
         BT_ToggleButton0:SetText(WoWTR_Localization.lang);
      end
   else
      BT_act_tr = "0";
      if (BT_PM["title"] == "1") then            -- wyświetlaj tłumaczenie tytułu
         ItemTextFrameTitleText:SetText(BT_tytul_en);
      end
      ItemTextPageText:SetText(BT_tekst_en);
      if (BT_PM["showID"]=="1") then             -- pokaż ID książki
         if (WoWTR_Localization.lang == 'AR') then
            BT_ToggleButton0:SetText("(EN) "..BT_bookID.." "..QTR_ReverseIfAR(WoWTR_Localization.bookID));
         else
            BT_ToggleButton0:SetText(WoWTR_Localization.bookID.." "..BT_bookID.." (EN)");
         end
      else
         BT_ToggleButton0:SetText("EN");
      end   
   end  
end
