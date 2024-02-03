-- Addon: WoWAR (version: 10.2.5.01) 2024.01.22
-- Description: The AddOn displays the translated text information in Arabic
-- Autor: Platine
-- E-mail: platine.wow@gmail.com

---------------------------------------------------------------------------------------------------------

-- General Variables
WOWTR_player_name = UnitName("player");
WOWTR_player_race = UnitRace("player");
WOWTR_player_class = UnitClass("player");
WOWTR_player_sex = UnitSex("player");     -- 1:neutral,  2:male,  3:female
WOWTR_waitTable = {};
WOWTR_waitFrame = nil;

---------------------------------------------------------------------------------------------------------

function StringHash(text)           -- funkcja tworząca Hash (32-bitowa liczba) podanego tekstu
   local counter = 1;
   local pomoc = 0;
   local dlug = string.len(text);
   for i = 1, dlug, 3 do 
      counter = math.fmod(counter*8161, 4294967279);  -- 2^32 - 17: Prime!
      pomoc = (string.byte(text,i)*16776193);
      counter = counter + pomoc;
      pomoc = ((string.byte(text,i+1) or (dlug-i+256))*8372226);
      counter = counter + pomoc;
      pomoc = ((string.byte(text,i+2) or (dlug-i+256))*3932164);
      counter = counter + pomoc;
   end
   return math.fmod(counter, 4294967291) -- 2^32 - 5: Prime (and different from the prime in the loop)
end

----------------------------------------------------------------------------------------------------------------------------------------

function WOWTR_wait(delay, func, ...)           -- można też użyć funkcji systemowej: C_Timer.After(sekundy, funkcja)
   if(type(delay)~="number" or type(func)~="function") then
      return false;
   end
   if (WOWTR_waitFrame == nil) then
      WOWTR_waitFrame = CreateFrame("Frame", "WOWTR_WaitFrame", UIParent);
      WOWTR_waitFrame:SetScript("onUpdate", function (self,elapse)
         local count = #WOWTR_waitTable;
         local i = 1;
         while(i<=count) do
            local waitRecord = tremove(WOWTR_waitTable,i);
            local d = tremove(waitRecord,1);
            local f = tremove(waitRecord,1);
            local p = tremove(waitRecord,1);
            if(d>elapse) then
               tinsert(WOWTR_waitTable,i,{d-elapse,f,p});
               i = i + 1;
            else
               count = count - 1;
               f(unpack(p));
            end
         end
      end);
   end
   tinsert(WOWTR_waitTable,{delay,func,{...}});
   return true;
end

----------------------------------------------------------------------------------------------------------------------------------------

-- Addon Variables saved in computer
function WOWTR_CheckVars()
   -- initialisation of tables
   if (not QTR_PS) then
      QTR_PS = {};
   end
   if (not QTR_SAVED) then
      QTR_SAVED = {};
   end
   if (not QTR_MISSING) then
      QTR_MISSING = {};
   end
   if (not QTR_GOSSIP) then
      QTR_GOSSIP = {};
   end
   
   if (not BB_PM) then
      BB_PM = {};
   end
   if (not BB_PS) then
      BB_PS = {};
   end
  if (not BB_TR) then
     BB_TR = {};
  end
   
   if (not MF_PM) then
      MF_PM = {};
   end
   if (not MF_PS) then
      MF_PS = {};
   end
   
   -- table for original gossip texts
   QTR_GS = {};
   

   -- show addon icon next to minimap
   if (not QTR_PS["icon"]) then
      QTR_PS["icon"] = "1";
   end
   -- activate the translations of quests
   if (not QTR_PS["active"]) then
      QTR_PS["active"] = "1";
   end
   -- activate the translations of quest TITLE
   if (not QTR_PS["transtitle"] ) then
      QTR_PS["transtitle"] = "1";   
   end
   -- activate the gossip translation
   if (not QTR_PS["gossip"] ) then
      QTR_PS["gossip"] = "1";   
   end
   -- gossip translation font size
   if (not QTR_PS["fontsize"] ) then
      QTR_PS["fontsize"] = "13";   
   end
   -- display own names in translation language
--   if (not QTR_PS["ownnames"] ) then
      QTR_PS["ownnames"] = "0";   
--   end
   -- activate the quest tracker translation ONLINE
   if (not QTR_PS["tracker"] ) then
      QTR_PS["tracker"] = "0";         -- Quest Tracker jest wyłączony w wersji AR
   end
   -- save of untranslated quests
   if (not QTR_PS["saveQS"] ) then
      QTR_PS["saveQS"] = "1";   
   end
   -- save of untranslated gossip texts
   if (not QTR_PS["saveGS"] ) then
      QTR_PS["saveGS"] = "1";   
   end
   -- activate translations in Classic Quest Log addon
   if (not QTR_PS["questlog"] ) then
      QTR_PS["questlog"] = "1";   
   end
   -- activate translations in Immersion addon
   if (not QTR_PS["immersion"] ) then
      QTR_PS["immersion"] = "1";   
   end
   -- activate translations in StoryLine addon
   if (not QTR_PS["storyline"] ) then
      QTR_PS["storyline"] = "1";   
   end

   if (not QTR_PS.firstTimeLoaded) then   -- Automatic log cleaning (reset saved texts)
      QTR_PS.firstTimeLoaded = true;
      WOWTR_ResetVariables(1);
   end

   -- initialize check options
   if (not BB_PM["active"] ) then    -- dodatek aktywny
      BB_PM["active"] = "1";   
   end
   if (not BB_PM["chat-en"] ) then   -- pokaż tekst angielski w oknie czatu
      BB_PM["chat-en"] = "0";   
   end
   if (not BB_PM["chat-tr"] ) then   -- pokaż tekst przetłumaczony w oknie czatu
      BB_PM["chat-tr"] = "1";   
   end
   if (not BB_PM["saveNB"] ) then    -- zapisz nieprzetłumaczone dymki
      BB_PM["saveNB"] = "1";   
   end
   if (not BB_PM["TRonline"] ) then  -- tłumaczenie online
      BB_PM["TRonline"] = "0";   
   end
   if (not BB_PM["setsize"] ) then   -- uaktywnij zmiany wielkości czcionki
      BB_PM["setsize"] = "0";   
   end
   if (not BB_PM["fontsize"] ) then  -- wielkość czcionki
      BB_PM["fontsize"] = "13";   
   end
   if (not BB_PM["sex"] ) then       -- wybór płci wypowiedzi do gracza
      BB_PM["sex"] = "4";            -- zależne od płci postaci
   end
   if (not BB_PM["dungeon"] ) then   -- pokaż dumek w lochach
      BB_PM["dungeon"] = "0";   
   end
   BB_PM["dungeonF"] = "0";
   if (not BB_PM["dungeonF1"] ) then   -- pozycja pionowa okna 1
      BB_PM["dungeonF1"] = 270;
   end
   if (not BB_PM["dungeonF2"] ) then   -- pozycja pionowa okna 2
      BB_PM["dungeonF2"] = 270;
   end
   if (not BB_PM["dungeonF3"] ) then   -- pozycja pionowa okna 3
      BB_PM["dungeonF3"] = 270;
   end
   if (not BB_PM["dungeonF4"] ) then   -- pozycja pionowa okna 4
      BB_PM["dungeonF4"] = 270;
   end
   if (not BB_PM["dungeonF5"] ) then   -- pozycja pionowa okna 5
      BB_PM["dungeonF5"] = 270;
   end
   WOWBB1.vertical = BB_PM["dungeonF1"];
   WOWBB2.vertical = BB_PM["dungeonF2"];
   WOWBB3.vertical = BB_PM["dungeonF3"];
   WOWBB4.vertical = BB_PM["dungeonF4"];
   WOWBB5.vertical = BB_PM["dungeonF5"];

   -- initialize check options
   if (not MF_PM["active"] ) then      -- dodatek aktywny
      MF_PM["active"] = "1";   
   end
   if (not MF_PM["intro"] ) then       -- pokaż przetłumaczone napisy tekstów startowych Intro
      MF_PM["intro"] = "1";   
   end
   if (not MF_PM["movie"] ) then       -- pokaż przetłumzaczone napisy tekstów Filmów
      MF_PM["movie"] = "1";   
   end
   if (not MF_PM["cinematic"] ) then   -- pokaż przetłumaczone napisy tekstów Cinematic
      MF_PM["cinematic"] = "1";   
   end
   if (not MF_PM["save"] ) then        -- zapisz nieprzetłumaczone napisy
      MF_PM["save"] = "1";   
   end

   if (not TT_PS) then
      TT_PS = {};
   end
   if (not TT_PS["active"] ) then      -- dodatek tutorial aktywny
      TT_PS["active"] = "1";   
   end
   if (not TT_PS["save"] ) then        -- zapisz nieprzetłumaczony tutorial
      TT_PS["save"] = "1";   
   end
   if (not TT_PS["saveui"] ) then      -- zapisz nieprzetłumaczony elementy UI
      TT_PS["saveui"] = "1";   
   end
   if (not TT_PS["ui1"] ) then         -- wyświetlaj tłumaczenia Game Menu
      TT_PS["ui1"] = "1";   
   end   
   if (not TT_PS["ui2"] ) then         -- wyświetlaj tłumaczenia Character Info
      TT_PS["ui2"] = "1";   
   end
   if (not TT_PS["ui3"] ) then         -- wyświetlaj tłumaczenia Group Finder
      TT_PS["ui3"] = "1";   
   end
   if (not TT_PS["ui4"] ) then         -- wyświetlaj tłumaczenia Collections
      TT_PS["ui4"] = "1";   
   end
   if (not TT_PS["ui5"] ) then         -- wyświetlaj tłumaczenia Adventure Guide
      TT_PS["ui5"] = "1";   
   end
   if (not TT_PS["ui6"] ) then         -- wyświetlaj tłumaczenia Friend List
      TT_PS["ui6"] = "1";   
   end
   if (not TT_PS["ui7"] ) then         -- wyświetlaj tłumaczenia Profession
      TT_PS["ui7"] = "1";   
   end
   if (not TT_PS["ui8"] ) then         -- wyświetlaj tłumaczenia UI (filter_openlist)
      TT_PS["ui8"] = "1";   
   end   
   if (not TT_TUTORIALS) then
      TT_TUTORIALS = {};
   end   

   if (not BT_PM) then
      BT_PM = {};
   end
   if (not BT_PM["active"] ) then      -- dodatek aktywny
      BT_PM["active"] = "1";   
   end
   if (not BT_PM["title"] ) then
      BT_PM["title"] = "1";   
   end
   if (not BT_PM["showID"] ) then
      BT_PM["showID"] = "1";   
   end
   if (not BT_PM["setsize"] ) then
      BT_PM["setsize"] = "0";   
   end
   if (not BT_PM["fontsize"] ) then
      BT_PM["fontsize"] = 15;          -- wielkość czcionki książek
   end
   if (not BT_PM["saveNW"] ) then      -- zapisz nieprzetłumaczony teksty książek
      BT_PM["saveNW"] = "1";   
   end
   if (not BT_SAVED) then
      BT_SAVED = {};
   end

   if (not ST_PM) then
      ST_PM = {};
   end
   if (not ST_PS) then         -- tablica informacji o obiekcie (item, spell, talent)
      ST_PS = {};
   end
   if (not ST_PH) then         -- tablica nieprzetłumaczonych tekstów
      ST_PH = {};
   end
   -- initialize check options
   if (not ST_PM["active"] ) then    -- dodatek aktywny
      ST_PM["active"] = "1";   
   end
   if (not ST_PM["item"] ) then      -- pokaż tłumaczenia przedmiotów
      ST_PM["item"] = "1";   
   end
   if (not ST_PM["spell"] ) then     -- pokaż tłumaczenia spelli
      ST_PM["spell"] = "1";   
   end
   if (not ST_PM["talent"] ) then    -- pokaż tłumaczenia talentów
      ST_PM["talent"] = "1";   
   end
   if (not ST_PM["transtitle"] ) then   -- pokaż tłumaczenie tytułu przedniotu, czaru lub talentu
      ST_PM["transtitle"] = "0";   
   end
   if (not ST_PM["showID"] ) then    -- pokaż ID przedmiotu,spellu,talentu
      ST_PM["showID"] = "0";   
   end
   if (not ST_PM["showHS"] ) then    -- pokaż Hash tekstu przedmiotu,spellu,talentu
      ST_PM["showHS"] = "0";   
   end
   if (not ST_PM["saveNW"] ) then    -- zapisz nieprzetłumaczone
      ST_PM["saveNW"] = "1";   
   end
   if (not ST_PM["sellprice"] ) then    -- ukryj cene skupu itemu
      ST_PM["sellprice"] = "0";   
   end
   if (not ST_PM["constantly"] ) then   -- wyświetlaj tłumaczenie stale
      ST_PM["constantly"] = "1";   
   end
   if (not ST_PM["timer"] ) then        -- uaktywnij zmiany timera przywracania oryginalnego tekstu
      ST_PM["timer"] = "10";   
   end

   if (not WoWTR_minimapDB) then        -- inicjalizacja zmiennej globalnej na pozycję ikonki minimap
      WoWTR_minimapDB = {};
   end

   -- save the version of the WoW Patch and current Locale
   QTR_PS["patch"] = GetBuildInfo();
   QTR_PS["locale"] = GetLocale();
   
end

----------------------------------------------------------------------------------------------------------------------------------------

function WOWTR_onEvent(self, event, name, ...)
   if (event=="ADDON_LOADED" and name==WoWTR_Localization.addonName) then
      self:UnregisterEvent("ADDON_LOADED");
      self:RegisterEvent("QUEST_ACCEPTED");
      self:RegisterEvent("QUEST_DETAIL");
      self:RegisterEvent("QUEST_PROGRESS");
      self:RegisterEvent("QUEST_COMPLETE");
      self:RegisterEvent("GOSSIP_SHOW");
      self:RegisterEvent("PLAY_MOVIE");
      self:RegisterEvent("CINEMATIC_START");
      self:RegisterEvent("CINEMATIC_STOP");
      self:RegisterEvent("TUTORIAL_TRIGGER");
      self:RegisterEvent("PLAYER_ENTERING_WORLD");
      self:RegisterEvent("MODIFIER_STATE_CHANGED");

      ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", BB_ChatFilter)
      ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_PARTY", BB_ChatFilter)
      ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", BB_ChatFilter)
      ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_WHISPER", BB_ChatFilter)
      ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_EMOTE", BB_ChatFilter)

      SlashCmdList["WOWTR"] = function(msg) WOWTR_SlashCommand(msg); end
      SLASH_WOWTR_BUBBLES1 = "/wowtr";
      SLASH_WOWTR_BUBBLES2 = "/qtr";
      SLASH_WOWTR_BUBBLES3 = "/bbtr";
      SLASH_WOWTR_BUBBLES4 = "/mtr";
      SLASH_WOWTR_BUBBLES5 = "/btr";
      SLASH_WOWTR_BUBBLES6 = "/str";
      WOWTR_CheckVars();
      QTR_START();
      Config_OnEnable();
      TutorialFrame:HookScript("OnShow", TT_onTutorialShow);
      if (not PlayerChoiceFrame) then
         PlayerChoice_LoadUI();
      end
      PlayerChoiceFrame:HookScript("OnShow", TT_onChoiceDelay);      -- tablica z zadaniami
      ItemTextFrame:HookScript("OnShow", function() BookTranslator_ShowTranslation() end);
      ItemTextNextPageButton:HookScript("OnClick", function() BookTranslator_ShowTranslation() end);
      ItemTextPrevPageButton:HookScript("OnClick", function() BookTranslator_ShowTranslation() end);
      BT_ToggleButton0 = CreateFrame("Button",nil, ItemTextFrame, "UIPanelButtonTemplate");
      BT_ToggleButton0:SetWidth(40);
      BT_ToggleButton0:SetHeight(20);
      BT_ToggleButton0:SetText("EN");
      BT_ToggleButton0:Show();
      BT_ToggleButton0:ClearAllPoints();
      BT_ToggleButton0:SetPoint("BOTTOMRIGHT", ItemTextFrame, "BOTTOMRIGHT", -29, 5);
      BT_ToggleButton0:SetScript("OnClick", BT_ON_OFF);
      
      if (_G.ElvUISpellBookTooltip) then
         _G.ElvUISpellBookTooltip:HookScript("OnShow", function(self, ...)
            if (not WOWTR_wait(0.02, ST_ElvSpellBookTooltipOnShow)) then
            -- opóźnienie 0.02 sek
            end
         end );
      end
      
      -- przycisk do przełączania wersji TR - EN dla talentów
      WOWTR_ToggleButtonS = CreateFrame("Button", nil, SpellBookFrame, "UIPanelButtonTemplate");
      WOWTR_ToggleButtonS:SetWidth(150);
      WOWTR_ToggleButtonS:SetHeight(22);
      WOWTR_ToggleButtonS:SetFrameStrata("HIGH")
      if (ST_PM["spell"] == "1") then
         WOWTR_ToggleButtonS:SetText(WoWTR_Localization.WoWTR_Spellbook_trDESC);
      else
         WOWTR_ToggleButtonS:SetText(WoWTR_Localization.WoWTR_Spellbook_enDESC);
      end
      WOWTR_ToggleButtonS:ClearAllPoints();
      WOWTR_ToggleButtonS:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", 210, -1);
      WOWTR_ToggleButtonS:SetScript("OnClick", STspell_ON_OFF);

      SpellBookFrame:HookScript("OnShow", function()
         if (ST_PM["active"] == "1") then
            WOWTR_ToggleButtonS:Show();
         else
            WOWTR_ToggleButtonS:Hide();
         end
      end);
      
      StaticPopup1:HookScript("OnShow", ST_StaticPopup1);
      StaticPopup2:HookScript("OnShow", ST_StaticPopup1);
      DropDownList1:HookScript("OnShow", ST_FilterandButtons);
      DropDownList2:HookScript("OnShow", ST_FilterandButtons);
      GameMenuFrame:HookScript("OnShow", ST_GameMenuTranslate);
      MerchantFrame:HookScript("OnShow", ST_MerchantFrame);
      PVEFrame:HookScript("OnShow", ST_GroupFinder);
      WorldMapFrame.NavBar.overlay:HookScript("OnUpdate", ST_WorldMapFunc);
      CharacterFrame:HookScript("OnShow", ST_CharacterFrame);
      FriendsFrame:HookScript("OnShow", ST_FriendsFrame);
      HelpPlateTooltip:HookScript("OnShow", ST_HelpPlateTooltip);  
      ReputationDetailFrame:HookScript("OnShow", ST_CharacterFrame);
      SplashFrame:HookScript("OnShow", ST_SplashFrame);
      PingSystemTutorialTitleText:HookScript("OnShow", ST_PingSystemTutorial);
      BB_OknoTRonline();
      DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WoWTR_Localization.addonName.."  ver. "..WOWTR_version.." - "..WoWTR_Localization.started);
      if ((not QTR_PS["welcome"]) and (string.len(WoWTR_Config_Interface.welcomeText) > 1)) then
         WOWTR_WelcomePanel();
      end
   elseif (event=="PLAYER_ENTERING_WORLD") then
      TT_onTutorialShow();
   elseif (event=="QUEST_DETAIL" or event=="QUEST_PROGRESS" or event=="QUEST_COMPLETE") then
      if (event=="QUEST_DETAIL" and QTR_quest_ID>0) then      -- zapisz przypisanie questu do krainy
         local QTR_mapID = C_Map.GetBestMapForUnit("player");
         local QTR_mapINFO = C_Map.GetMapInfo(QTR_mapID);
         QTR_SAVED[QTR_quest_ID.." MAPID"]=QTR_mapID.."@"..QTR_mapINFO.name.."@"..QTR_mapINFO.mapType.."@"..QTR_mapINFO.parentMapID;     -- save mapID to locale place of this quest
      end
      if ( QuestFrame:IsVisible() or isImmersion()) then
         QTR_QuestPrepare(event);
      elseif (isStoryline()) then
         if (not WOWTR_wait(1,QTR_Storyline_Quest)) then
         -- opóźnienie 1 sek
         end
      end	-- QuestFrame is Visible
      if (not WOWTR_wait(1,QTR_ObjectiveTracker_Check)) then
         -- opóźnienie 1 sek
      end
   elseif (event=="GOSSIP_SHOW") then
      if (QTR_PS["gossip"] == "1") then
         if (ElvUI) then
            if (not WOWTR_wait(0.5, QTR_Gossip_Show)) then
            -- opóźnienie 0.5 sek
            end
         else
            QTR_Gossip_Show();
         end
      end
   elseif (event=="PLAY_MOVIE") then
      local WOWTR_movieID = name ;
      if ((WOWTR_movieID) and (MF_PM["active"] == "1") and (MF_PM["movie"] == "1")) then
         MF_PlayMovie(WOWTR_movieID);
      end
   elseif (event=="CINEMATIC_START") then
      MF_CinematicStart();
   elseif (event=="CINEMATIC_STOP") then
      MF_CinematicStop();
   elseif (event=="TUTORIAL_TRIGGER") then
      TT_onTutorialShow();
   elseif (isImmersion() and event=="QUEST_ACCEPTED") then
      QTR_delayed3();
   elseif (GameTooltip:IsShown() and (event=="MODIFIER_STATE_CHANGED") and (name == "LSHIFT" or name == "RSHIFT") and (ST_PM["active"]=="1")) then
      if (GameTooltip.processingInfo and GameTooltip.processingInfo.tooltipData.id and (ST_PM["item"] == "1")) then
         if (GameTooltip.processingInfo.tooltipData.type == 0) then           -- items
            if (ShoppingTooltip1 and ShoppingTooltip1:IsVisible()) then
               ShoppingTooltip1:Hide();
               if (ShoppingTooltip2 and ShoppingTooltip2:IsVisible()) then
                   ShoppingTooltip2:Hide();
               end
            else
               GameTooltip_ShowCompareItem();
            end
         end
      end
   end
   if (TT_onTutorialShow) then
      TT_onTutorialShow();
   end
end

-------------------------------------------------------------------------------------------------------

function STspell_ON_OFF()
   if (ST_PM["spell"] == "1") then
      ST_PM["spell"] = "0";
      WOWTR_ToggleButtonS:SetText(WoWTR_Localization.WoWTR_Spellbook_enDESC);
   else
      ST_PM["spell"] = "1";
      WOWTR_ToggleButtonS:SetText(WoWTR_Localization.WoWTR_Spellbook_trDESC);
   end
end

----------------------------------------------------------------------------------------------------------------------------------------

if ((GetLocale()=="enUS") or (GetLocale()=="enGB")) then
-- main frame of the addon
   WOWTR = CreateFrame("Frame");
   WOWTR:SetScript("OnEvent", WOWTR_onEvent);
   WOWTR:RegisterEvent("ADDON_LOADED");
else
   DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..WoWTR_Localization.addonName.."|r  ver. "..WOWTR_version.." - add-on is not active because it was run in Locale |cffffff00"..GetLocale());
end