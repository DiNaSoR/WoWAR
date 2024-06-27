-- Addon: WoWTR_Config (version: 10.Z25) 2024.06.27
-- Opis: The AddOn displays the translated text information in chosen language
-- Autor: Platine
-- E-mail: platine.wow@gmail.com

-------------------------------------------------------------------------------------------------------------------

local WOWTR_ConfigFirstTime = true;

-----------------------------------------------------------------------------------------------------------------

function WOWTR_SetCheckButtonState()
   WOWTR_CheckButton00:SetValue(QTR_PS["icon"]=="1");
 
   WOWTR_CheckButton11:SetValue(QTR_PS["active"]=="1");
   WOWTR_CheckButton12:SetValue(QTR_PS["transtitle"]=="1");
   WOWTR_CheckButton13:SetValue(QTR_PS["gossip"]=="1");
   WOWTR_CheckButton14:SetValue(QTR_PS["tracker"]=="1");
   WOWTR_CheckButton15:SetValue(QTR_PS["saveQS"]=="1");
   WOWTR_CheckButton16:SetValue(QTR_PS["saveGS"]=="1");
   WOWTR_CheckButton17:SetValue(QTR_PS["immersion"]=="1");
   WOWTR_CheckButton18:SetValue(QTR_PS["storyline"]=="1");
   WOWTR_CheckButton19:SetValue(QTR_PS["questlog"]=="1");
   WOWTR_CheckButton1a:SetValue(QTR_PS["ownnames"]=="1");
   WOWTR_CheckButton1b:SetValue(QTR_PS["dialogueui"]=="1");
 
   WOWTR_CheckButton21:SetValue(BB_PM["active"]=="1");
   WOWTR_CheckButton22:SetValue(BB_PM["chat-en"]=="1");
   WOWTR_CheckButton23:SetValue(BB_PM["chat-tr"]=="1");
   WOWTR_CheckButton24:SetValue(BB_PM["sex"]=="2");
   WOWTR_CheckButton25:SetValue(BB_PM["sex"]=="3");
   WOWTR_CheckButton26:SetValue(BB_PM["sex"]=="4");
   WOWTR_CheckButton27:SetValue(BB_PM["saveNB"]=="1");
   WOWTR_CheckButton28:SetValue(BB_PM["setsize"]=="1");
   WOWTR_CheckButton2d1:SetValue(BB_PM["dungeon"]=="1");
   WOWTR_CheckButton2d2:SetValue(false);
   BB_PM["dungeonF"] = "0";       -- setting dungeon frames
 
   WOWTR_CheckButton31:SetValue(MF_PM["active"]=="1");
   WOWTR_CheckButton32:SetValue(MF_PM["intro"]=="1");
   WOWTR_CheckButton33:SetValue(MF_PM["movie"]=="1");
   WOWTR_CheckButton34:SetValue(MF_PM["cinematic"]=="1");
   WOWTR_CheckButton35:SetValue(MF_PM["save"]=="1");
   
   if (WoWTR_Localization.lang == 'AR') then          -- part: Chat
      WOWTR_CheckButton36:SetValue(CH_PM["active"]=="1");
      WOWTR_CheckButton37:SetValue(CH_PM["setsize"]=="1");
      WOWTR_slider6:SetValue(tonumber(CH_PM["fontsize"]));
   end
   
   WOWTR_CheckButton40:SetValue(TT_PS["ui8"]=="1");
   WOWTR_CheckButton41:SetValue(TT_PS["active"]=="1");
   WOWTR_CheckButton42:SetValue(TT_PS["save"]=="1");
   WOWTR_CheckButton43:SetValue(TT_PS["ui1"]=="1");
   WOWTR_CheckButton44:SetValue(TT_PS["saveui"]=="1");
   WOWTR_CheckButton45:SetValue(TT_PS["ui2"]=="1");
   WOWTR_CheckButton46:SetValue(TT_PS["ui3"]=="1");
   WOWTR_CheckButton47:SetValue(TT_PS["ui4"]=="1");
   WOWTR_CheckButton48:SetValue(TT_PS["ui5"]=="1");
   WOWTR_CheckButton49:SetValue(TT_PS["ui6"]=="1");
   WOWTR_CheckButton50:SetValue(TT_PS["ui7"]=="1");
 
   WOWTR_CheckButton51:SetValue(BT_PM["active"]=="1");
   WOWTR_CheckButton52:SetValue(BT_PM["title"]=="1");
   WOWTR_CheckButton53:SetValue(BT_PM["showID"]=="1");
   WOWTR_CheckButton55:SetValue(BT_PM["saveNW"]=="1");
   WOWTR_CheckButton58:SetValue(BT_PM["setsize"]=="1");
 
   WOWTR_CheckButton61:SetValue(ST_PM["active"]=="1");
   WOWTR_CheckButton62:SetValue(ST_PM["item"]=="1");
   WOWTR_CheckButton63:SetValue(ST_PM["spell"]=="1");
   WOWTR_CheckButton64:SetValue(ST_PM["talent"]=="1");
   WOWTR_CheckButton65:SetValue(ST_PM["showID"]=="1");
   WOWTR_CheckButton66:SetValue(ST_PM["showHS"]=="1");
   WOWTR_CheckButton67:SetValue(ST_PM["sellprice"]=="1");
   WOWTR_CheckButton68:SetValue(ST_PM["constantly"]=="1");
   WOWTR_CheckButton69:SetValue(ST_PM["saveNW"]=="1");
   if (ST_TooltipsID) then
      WOWTR_CheckButton6A:SetValue(ST_PM["transtitle"]=="1");
   end
   
   local fontsize1 = tonumber(BB_PM["fontsize"]);
   WOWTR_Opis1:SetFont(WOWTR_Font2, fontsize1);
 
   local fontsize2 = tonumber(BT_PM["fontsize"]);
   WOWTR_Opis2:SetFont(WOWTR_Font2, fontsize2);
 
   local fontsize4 = tonumber(QTR_PS["fontsize"]);      -- gossip font size
   WOWTR_Opis4:SetFont(WOWTR_Font2, fontsize4);
 
   WOWTR_slider1:SetValue(tonumber(BB_PM["fontsize"]));
   WOWTR_slider2:SetValue(tonumber(BT_PM["fontsize"]));
   WOWTR_slider3:SetValue(tonumber(ST_PM["timer"]));
   WOWTR_slider4:SetValue(tonumber(QTR_PS["fontsize"]));
   WOWTR_slider5:SetValue(tonumber(BB_PM["timeDisplay"]));
   
   if (WOWTR_ConfigFirstTime) then      -- The options window was launched for the first time - show all tabs so that the texts are fully displayed
      WOWTR_ConfigFirstTime = false;
      if (not WOWTR_wait(0.5, WOWTR_ChangePanel1)) then
         -- delay 0.5 sec.
      end
      if (not WOWTR_wait(0.5, WOWTR_ChangePanel2)) then
         -- delay 0.5 sec.
      end
      if (not WOWTR_wait(0.5, WOWTR_ChangePanel3)) then
         -- delay 0.5 sec.
      end
      if (not WOWTR_wait(0.5, WOWTR_ChangePanel4)) then
         -- delay 0.5 sec.
      end
      if (not WOWTR_wait(0.5, WOWTR_ChangePanel5)) then
         -- delay 0.5 sec.
      end
      if (not WOWTR_wait(0.5, WOWTR_ChangePanel6)) then
         -- delay 0.5 sec.
      end
      if (not WOWTR_wait(0.5, WOWTR_ChangePanel1)) then
         -- delay 0.5 sec.
      end
   end
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_SetDungeonFrames(obj, tryb, horiz)
   if (tryb) then       -- show
      obj:SetOwner(UIParent, "ANCHOR_NONE" );
      obj:ClearAllPoints();
      obj:SetPoint("CENTER", horiz, obj.vertical);
      obj:ClearLines();
      obj:AddLine(QTR_ReverseIfAR(WoWTR_Localization.moveFrameUpDown), 1, 1, 1, true);
      if (BB_PM["setsize"]=="1") then              -- jest włączona wielkość czcionki dymku
         _G[obj:GetName().."TextLeft1"]:SetFont(WOWTR_Font2, tonumber(BB_PM["fontsize"]));      -- wielkość czcionki
      else
         _G[obj:GetName().."TextLeft1"]:SetFont(WOWTR_Font2, 13);   -- ustaw turecką czcionkę oraz niezmienioną wielkość (13)
      end
      obj:Show();
      obj:SetMovable(true);
      obj:SetScript("OnMouseDown", function() WOWBB_OnMouseDown(obj); end);
      obj:SetScript("OnMouseUp", function() WOWBB_OnMouseUp(obj); end);
   else                 -- hide
      obj:SetMovable(false);
      obj:SetScript("OnMouseDown", nil);
      obj:SetScript("OnMouseUp", nil);
      obj:Hide();
      BB_PM["dungeonF1"] = WOWBB1.vertical;
      BB_PM["dungeonF2"] = WOWBB2.vertical;
      BB_PM["dungeonF3"] = WOWBB3.vertical;
      BB_PM["dungeonF4"] = WOWBB4.vertical;
      BB_PM["dungeonF5"] = WOWBB5.vertical;
   end
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_HideOptionsFrame()
   WOWTR_SetDungeonFrames(WOWBB1, false);
   WOWTR_SetDungeonFrames(WOWBB2, false);
   WOWTR_SetDungeonFrames(WOWBB3, false);
   WOWTR_SetDungeonFrames(WOWBB4, false);
   WOWTR_SetDungeonFrames(WOWBB5, false);
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_BlizzardOptions()

-- Create main settings frame for information text and options of the addon
local WOWTR_Options = CreateFrame("FRAME", "WOWTR_Options", SettingsPanel);
WOWTR_Options.refresh = function (self) WOWTR_SetCheckButtonState() end;
WOWTR_Options:SetScript("OnHide", WOWTR_HideOptionsFrame);
--WOWTR_Options.name = WoWTR_Localization.optionName;
--InterfaceOptions_AddCategory(WOWTR_Options);
local category = Settings.RegisterCanvasLayoutCategory(WOWTR_Options, WoWTR_Localization.optionName);
Settings.RegisterAddOnCategory(category);

local WOWTR_OptionsHeader = WOWTR_Options:CreateFontString(nil, "ARTWORK");

-- Adjust the size and position of the frame
WOWTR_OptionsHeader:SetFontObject(GameFontNormalLarge);
WOWTR_OptionsHeader:SetJustifyH("LEFT");
WOWTR_OptionsHeader:SetJustifyV("TOP");
WOWTR_OptionsHeader:ClearAllPoints();
WOWTR_OptionsHeader:SetPoint("TOPLEFT", 8, -8);

-- There is an addon icon inside the config frame 
local WOWTR_OptionsHeaderIcon = WOWTR_Options:CreateTexture(nil, "OVERLAY");
WOWTR_OptionsHeaderIcon:SetPoint("TOPLEFT", 0, 0);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderIcon:SetWidth(48);
   WOWTR_OptionsHeaderIcon:SetHeight(48);
else
   WOWTR_OptionsHeaderIcon:SetWidth(32);
   WOWTR_OptionsHeaderIcon:SetHeight(32);
end
WOWTR_OptionsHeaderIcon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon.png");

-- Main text inside the option frame 
local WOWTR_OptionsHeaderText = WOWTR_Options:CreateFontString(nil, "OVERLAY", "GameFontNormal");
WOWTR_OptionsHeaderText:SetFont(WOWTR_Font2, 18);
WOWTR_OptionsHeaderText:SetWidth(600);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderText:SetPoint("LEFT", WOWTR_OptionsHeaderIcon, "RIGHT", 70, 10);
   WOWTR_OptionsHeaderText:SetText(AS_UTF8reverse(WoWTR_Localization.optionTitleAR));
else
   WOWTR_OptionsHeaderText:SetPoint("LEFT", WOWTR_OptionsHeaderIcon, "RIGHT", 0, 0);
   WOWTR_OptionsHeaderText:SetText(" "..WoWTR_Localization.optionTitle.." |cff8080ffv"..WOWTR_version.."|r                          by Platine © 2024");
end

local WOWTR_CheckButton00 = CreateFrame("CheckButton", "WOWTR_CheckButton00", WOWTR_Options, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton00.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["icon"]=="1") then QTR_PS["icon"]="0"; WOWTR.db.profile.minimap.hide=true; LibDBIcon10_WOWTR_LDB:Hide(); else QTR_PS["icon"]="1"; WOWTR.db.profile.minimap.hide=false; LibDBIcon10_WOWTR_LDB:Show(); end; end);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton00.CheckBox:SetPoint("TOPLEFT", WOWTR_OptionsHeaderText, "TOPLEFT", 502, -20);
   WOWTR_CheckButton00:SetPoint("TOPLEFT", WOWTR_OptionsHeaderText, "TOPLEFT", 250, -22);
   WOWTR_CheckButton00.Text:SetText("|cffffffff"..AS_UTF8reverse(WoWTR_Config_Interface.showMinimapIcon).."|r");   -- Show then addon setting icon next to the minimap
   WOWTR_CheckButton00:SetWidth(260);
else
   WOWTR_CheckButton00.CheckBox:SetPoint("TOPLEFT", WOWTR_OptionsHeaderText, "TOPLEFT", 20, -20);
   WOWTR_CheckButton00:SetPoint("TOPLEFT", WOWTR_OptionsHeaderText, "TOPLEFT", 250, -22);
   WOWTR_CheckButton00.Text:SetText("|cffffffff"..WoWTR_Config_Interface.showMinimapIcon.."|r");   -- Show then addon setting icon next to the minimap
   WOWTR_CheckButton00:SetWidth(340);
end
WOWTR_CheckButton00.Text:SetFont(WOWTR_Font2, 13);
WOWTR_CheckButton00:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT");
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.showMinimapIcon).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.showMinimapIconDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton00:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);


local WOWTR_Tab1TitleA = CreateFrame("BUTTON", "WOWTR_Tab1TitleA", WOWTR_Options, "GameMenuButtonTemplate");
WOWTR_Tab1TitleA:SetWidth(100);
WOWTR_Tab1TitleA:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab1TitleA:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab1));
   WOWTR_Tab1TitleA:SetFontString(fo);
end
WOWTR_Tab1TitleA:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab1));
WOWTR_Tab1TitleA:ClearAllPoints();
WOWTR_Tab1TitleA:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -10, -60);
WOWTR_Tab1TitleA:Show();

local WOWTR_Tab1TitleB = CreateFrame("BUTTON", "WOWTR_Tab1TitleB", WOWTR_Options, "UIPanelButtonGrayTemplate");
WOWTR_Tab1TitleB:SetWidth(100);
WOWTR_Tab1TitleB:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab1TitleB:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab1));
   WOWTR_Tab1TitleB:SetFontString(fo);
end
WOWTR_Tab1TitleB:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab1));
WOWTR_Tab1TitleB:ClearAllPoints();
WOWTR_Tab1TitleB:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -10, -60);
WOWTR_Tab1TitleB:Hide();
WOWTR_Tab1TitleB:SetScript("OnClick", WOWTR_ChangePanel1);

local WOWTR_Tab2TitleA = CreateFrame("BUTTON", "WOWTR_Tab2TitleA", WOWTR_Options, "GameMenuButtonTemplate");
WOWTR_Tab2TitleA:SetWidth(100);
WOWTR_Tab2TitleA:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab2TitleA:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab2));
   WOWTR_Tab2TitleA:SetFontString(fo);
end
WOWTR_Tab2TitleA:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab2));
WOWTR_Tab2TitleA:ClearAllPoints();
WOWTR_Tab2TitleA:SetPoint("TOPLEFT", WOWTR_Tab1TitleA, "TOPRIGHT", -4, 0);
WOWTR_Tab2TitleA:Hide();

local WOWTR_Tab2TitleB = CreateFrame("BUTTON", "WOWTR_Tab2TitleB", WOWTR_Options, "UIPanelButtonGrayTemplate");
WOWTR_Tab2TitleB:SetWidth(100);
WOWTR_Tab2TitleB:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab2TitleB:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab2));
   WOWTR_Tab2TitleB:SetFontString(fo);
end
WOWTR_Tab2TitleB:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab2));
WOWTR_Tab2TitleB:ClearAllPoints();
WOWTR_Tab2TitleB:SetPoint("TOPLEFT", WOWTR_Tab1TitleB, "TOPRIGHT", -4, 0);
WOWTR_Tab2TitleB:Show();
WOWTR_Tab2TitleB:SetScript("OnClick", WOWTR_ChangePanel2);

local WOWTR_Tab3TitleA = CreateFrame("BUTTON", "WOWTR_Tab3TitleA", WOWTR_Options, "GameMenuButtonTemplate");
WOWTR_Tab3TitleA:SetWidth(100);
WOWTR_Tab3TitleA:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab3TitleA:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab3));
   WOWTR_Tab3TitleA:SetFontString(fo);
end
WOWTR_Tab3TitleA:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab3));
WOWTR_Tab3TitleA:ClearAllPoints();
WOWTR_Tab3TitleA:SetPoint("TOPLEFT", WOWTR_Tab2TitleA, "TOPRIGHT", -4, 0);
WOWTR_Tab3TitleA:Hide();

local WOWTR_Tab3TitleB = CreateFrame("BUTTON", "WOWTR_Tab3TitleB", WOWTR_Options, "UIPanelButtonGrayTemplate");
WOWTR_Tab3TitleB:SetWidth(100);
WOWTR_Tab3TitleB:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab3TitleB:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab3));
   WOWTR_Tab3TitleB:SetFontString(fo);
end
WOWTR_Tab3TitleB:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab3));
WOWTR_Tab3TitleB:ClearAllPoints();
WOWTR_Tab3TitleB:SetPoint("TOPLEFT", WOWTR_Tab2TitleB, "TOPRIGHT", -4, 0);
WOWTR_Tab3TitleB:Show();
WOWTR_Tab3TitleB:SetScript("OnClick", WOWTR_ChangePanel3);

local WOWTR_Tab4TitleA = CreateFrame("BUTTON", "WOWTR_Tab4TitleA", WOWTR_Options, "GameMenuButtonTemplate");
WOWTR_Tab4TitleA:SetWidth(100);
WOWTR_Tab4TitleA:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab4TitleA:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab4));
   WOWTR_Tab4TitleA:SetFontString(fo);
end
WOWTR_Tab4TitleA:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab4));
WOWTR_Tab4TitleA:ClearAllPoints();
WOWTR_Tab4TitleA:SetPoint("TOPLEFT", WOWTR_Tab3TitleA, "TOPRIGHT", -4, 0);
WOWTR_Tab4TitleA:Hide();

local WOWTR_Tab4TitleB = CreateFrame("BUTTON", "WOWTR_Tab4TitleB", WOWTR_Options, "UIPanelButtonGrayTemplate");
WOWTR_Tab4TitleB:SetWidth(100);
WOWTR_Tab4TitleB:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab4TitleB:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab4));
   WOWTR_Tab4TitleB:SetFontString(fo);
end
WOWTR_Tab4TitleB:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab4));
WOWTR_Tab4TitleB:ClearAllPoints();
WOWTR_Tab4TitleB:SetPoint("TOPLEFT", WOWTR_Tab3TitleB, "TOPRIGHT", -4, 0);
WOWTR_Tab4TitleB:Show();
WOWTR_Tab4TitleB:SetScript("OnClick", WOWTR_ChangePanel4);

local WOWTR_Tab5TitleA = CreateFrame("BUTTON", "WOWTR_Tab5TitleA", WOWTR_Options, "GameMenuButtonTemplate");
WOWTR_Tab5TitleA:SetWidth(100);
WOWTR_Tab5TitleA:SetHeight(20);
if ((WoWTR_Localization.lang == 'AR') or (WoWTR_Localization.lang == 'PL')) then
   local fo = WOWTR_Tab5TitleA:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab5));
   WOWTR_Tab5TitleA:SetFontString(fo);
end
WOWTR_Tab5TitleA:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab5));
WOWTR_Tab5TitleA:ClearAllPoints();
WOWTR_Tab5TitleA:SetPoint("TOPLEFT", WOWTR_Tab4TitleA, "TOPRIGHT", -4, 0);
WOWTR_Tab5TitleA:Hide();

local WOWTR_Tab5TitleB = CreateFrame("BUTTON", "WOWTR_Tab5TitleB", WOWTR_Options, "UIPanelButtonGrayTemplate");
WOWTR_Tab5TitleB:SetWidth(100);
WOWTR_Tab5TitleB:SetHeight(20);
if ((WoWTR_Localization.lang == 'AR') or (WoWTR_Localization.lang == 'PL')) then
   local fo = WOWTR_Tab5TitleB:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab5));
   WOWTR_Tab5TitleB:SetFontString(fo);
end
WOWTR_Tab5TitleB:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab5));
WOWTR_Tab5TitleB:ClearAllPoints();
WOWTR_Tab5TitleB:SetPoint("TOPLEFT", WOWTR_Tab4TitleB, "TOPRIGHT", -4, 0);
WOWTR_Tab5TitleB:Show();
WOWTR_Tab5TitleB:SetScript("OnClick", WOWTR_ChangePanel5);

local WOWTR_Tab6TitleA = CreateFrame("BUTTON", "WOWTR_Tab6TitleA", WOWTR_Options, "GameMenuButtonTemplate");
WOWTR_Tab6TitleA:SetWidth(100);
WOWTR_Tab6TitleA:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab6TitleA:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab6));
   WOWTR_Tab6TitleA:SetFontString(fo);
end
WOWTR_Tab6TitleA:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab6));
WOWTR_Tab6TitleA:ClearAllPoints();
WOWTR_Tab6TitleA:SetPoint("TOPLEFT", WOWTR_Tab5TitleA, "TOPRIGHT", -4, 0);
WOWTR_Tab6TitleA:Hide();

local WOWTR_Tab6TitleB = CreateFrame("BUTTON", "WOWTR_Tab6TitleB", WOWTR_Options, "UIPanelButtonGrayTemplate");
WOWTR_Tab6TitleB:SetWidth(100);
WOWTR_Tab6TitleB:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab6TitleB:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab6));
   WOWTR_Tab6TitleB:SetFontString(fo);
end
WOWTR_Tab6TitleB:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab6));
WOWTR_Tab6TitleB:ClearAllPoints();
WOWTR_Tab6TitleB:SetPoint("TOPLEFT", WOWTR_Tab5TitleB, "TOPRIGHT", -4, 0);
WOWTR_Tab6TitleB:Show();
WOWTR_Tab6TitleB:SetScript("OnClick", WOWTR_ChangePanel6);

local WOWTR_Tab9TitleA = CreateFrame("BUTTON", "WOWTR_Tab9TitleA", WOWTR_Options, "GameMenuButtonTemplate");
WOWTR_Tab9TitleA:SetWidth(100);
WOWTR_Tab9TitleA:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab9TitleA:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab9));
   WOWTR_Tab9TitleA:SetFontString(fo);
end
WOWTR_Tab9TitleA:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab9));
WOWTR_Tab9TitleA:ClearAllPoints();
WOWTR_Tab9TitleA:SetPoint("TOPLEFT", WOWTR_Tab6TitleA, "TOPRIGHT", -4, 0);
WOWTR_Tab9TitleA:Hide();

local WOWTR_Tab9TitleB = CreateFrame("BUTTON", "WOWTR_Tab9TitleB", WOWTR_Options, "UIPanelButtonGrayTemplate");
WOWTR_Tab9TitleB:SetWidth(100);
WOWTR_Tab9TitleB:SetHeight(20);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_Tab9TitleB:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab9));
   WOWTR_Tab9TitleB:SetFontString(fo);
end
WOWTR_Tab9TitleB:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.titleTab9));
WOWTR_Tab9TitleB:ClearAllPoints();
WOWTR_Tab9TitleB:SetPoint("TOPLEFT", WOWTR_Tab6TitleB, "TOPRIGHT", -4, 0);
WOWTR_Tab9TitleB:Show();
WOWTR_Tab9TitleB:SetScript("OnClick", WOWTR_ChangePanel9);

----- PANELS

local WOWTR_OptionPanel1 = CreateFrame("FRAME", "WOWTR_OptionPanel1", WOWTR_Options, "BackdropTemplate");
WOWTR_OptionPanel1:SetMovable(false);
WOWTR_OptionPanel1:SetWidth(682);
WOWTR_OptionPanel1:SetHeight(530);
WOWTR_OptionPanel1:ClearAllPoints();
WOWTR_OptionPanel1:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -15, -73);
WOWTR_OptionPanel1:Hide();
 
local WOWTR_OptionPanel2 = CreateFrame("FRAME", "WOWTR_OptionPanel2", WOWTR_Options, "BackdropTemplate");
WOWTR_OptionPanel2:SetMovable(false);
WOWTR_OptionPanel2:SetWidth(682);
WOWTR_OptionPanel2:SetHeight(530);
WOWTR_OptionPanel2:ClearAllPoints();
WOWTR_OptionPanel2:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -15, -73);
WOWTR_OptionPanel2:Hide();
 
local WOWTR_OptionPanel3 = CreateFrame("FRAME", "WOWTR_OptionPanel3", WOWTR_Options, "BackdropTemplate");
WOWTR_OptionPanel3:SetMovable(false);
WOWTR_OptionPanel3:SetWidth(682);
WOWTR_OptionPanel3:SetHeight(530);
WOWTR_OptionPanel3:ClearAllPoints();
WOWTR_OptionPanel3:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -15, -73);
WOWTR_OptionPanel3:Hide();
 
local WOWTR_OptionPanel4 = CreateFrame("FRAME", "WOWTR_OptionPanel4", WOWTR_Options, "BackdropTemplate");
WOWTR_OptionPanel4:SetMovable(false);
WOWTR_OptionPanel4:SetWidth(682);
WOWTR_OptionPanel4:SetHeight(530);
WOWTR_OptionPanel4:ClearAllPoints();
WOWTR_OptionPanel4:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -15, -73);
WOWTR_OptionPanel4:Hide();
 
local WOWTR_OptionPanel5 = CreateFrame("FRAME", "WOWTR_OptionPanel5", WOWTR_Options, "BackdropTemplate");
WOWTR_OptionPanel5:SetMovable(false);
WOWTR_OptionPanel5:SetWidth(682);
WOWTR_OptionPanel5:SetHeight(530);
WOWTR_OptionPanel5:ClearAllPoints();
WOWTR_OptionPanel5:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -15, -73);
WOWTR_OptionPanel5:Hide();
 
local WOWTR_OptionPanel6 = CreateFrame("FRAME", "WOWTR_OptionPanel6", WOWTR_Options, "BackdropTemplate");
WOWTR_OptionPanel6:SetMovable(false);
WOWTR_OptionPanel6:SetWidth(682);
WOWTR_OptionPanel6:SetHeight(530);
WOWTR_OptionPanel6:ClearAllPoints();
WOWTR_OptionPanel6:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -15, -73);
WOWTR_OptionPanel6:Hide();
 
local WOWTR_OptionPanel9 = CreateFrame("FRAME", "WOWTR_OptionPanel9", WOWTR_Options, "BackdropTemplate");
WOWTR_OptionPanel9:SetMovable(false);
WOWTR_OptionPanel9:SetWidth(682);
WOWTR_OptionPanel9:SetHeight(530);
WOWTR_OptionPanel9:ClearAllPoints();
WOWTR_OptionPanel9:SetPoint("TOPLEFT", WOWTR_Options, "TOPLEFT", -15, -73);
WOWTR_OptionPanel9:Show();

----- TAB 1

local WOWTR_OptionsHeaderIcon1 = WOWTR_OptionPanel1:CreateTexture(nil, "OVERLAY");
WOWTR_OptionsHeaderIcon1:SetWidth(200);
WOWTR_OptionsHeaderIcon1:SetHeight(200);
WOWTR_OptionsHeaderIcon1:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\quests_mini.jpg");   -- WOWTR_OptionPanel1 thumbnail
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderIcon1:SetPoint("CENTER", -230, 150);
else
   WOWTR_OptionsHeaderIcon1:SetPoint("CENTER", 230, 150);
end

local WOWTR_Panel1Header1 = WOWTR_OptionPanel1:CreateFontString(nil, "ARTWORK");
WOWTR_Panel1Header1:SetFontObject(GameFontNormal);
WOWTR_Panel1Header1:SetJustifyH("LEFT"); 
WOWTR_Panel1Header1:SetJustifyV("TOP");
WOWTR_Panel1Header1:ClearAllPoints();
WOWTR_Panel1Header1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.generalMainHeaderQS));   -- Quest translations
WOWTR_Panel1Header1:SetFont(WOWTR_Font2, 15);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel1Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel1, "TOPLEFT", 525, -25);
else
   WOWTR_Panel1Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel1, "TOPLEFT", 20, -25);
end

local WOWTR_CheckButton11 = CreateFrame("CheckButton", "WOWTR_CheckButton11", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton11.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["active"]=="1") then QTR_PS["active"]="0" else QTR_PS["active"]="1" end; end);
WOWTR_CheckButton11:SetWidth(210);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton11.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel1Header1, "TOPLEFT", 110, -20);
   WOWTR_CheckButton11:SetPoint("TOPLEFT", WOWTR_Panel1Header1, "TOPLEFT", -15, -22);
   WOWTR_CheckButton11:SetWidth(130);
else
   WOWTR_CheckButton11.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel1Header1, "TOPLEFT", 10, -20);
   WOWTR_CheckButton11:SetPoint("TOPLEFT", WOWTR_Panel1Header1, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton11.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.activateQuestsTranslations).."|r");   -- Activate quest translations
WOWTR_CheckButton11.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton11:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT");
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.activateQuestsTranslations).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.activateQuestsTranslationsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton11:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton12 = CreateFrame("CheckButton", "WOWTR_CheckButton12", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton12.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["transtitle"]=="1") then QTR_PS["transtitle"]="0" else QTR_PS["transtitle"]="1" end; end);
WOWTR_CheckButton12.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton11.CheckBox, "BOTTOMLEFT", 0, -20);
WOWTR_CheckButton12:SetWidth(240);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton12:SetPoint("TOPLEFT", WOWTR_CheckButton11.CheckBox, "BOTTOMLEFT", -160, -22);
   WOWTR_CheckButton12:SetWidth(165);
else
   WOWTR_CheckButton12:SetPoint("TOPLEFT", WOWTR_CheckButton11.CheckBox, "BOTTOMLEFT", 40, -22);
end
WOWTR_CheckButton12.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateQuestTitles).."|r");   -- Display translation of quest TITLES
WOWTR_CheckButton12.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton12:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateQuestTitles).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateQuestTitlesDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton12:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton13 = CreateFrame("CheckButton", "WOWTR_CheckButton13", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton13.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["gossip"]=="1") then QTR_PS["gossip"]="0" else QTR_PS["gossip"]="1" end; end);
WOWTR_CheckButton13.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton12.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton13:SetWidth(252);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton13:SetPoint("TOPLEFT", WOWTR_CheckButton12.CheckBox, "BOTTOMLEFT", -215, -2);
   WOWTR_CheckButton13:SetWidth(220);
else
   WOWTR_CheckButton13:SetPoint("TOPLEFT", WOWTR_CheckButton12.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton13.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateGossipTexts).."|r");   -- Display translation of GOSSIP texts
WOWTR_CheckButton13.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton13:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateGossipTexts).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateGossipTextsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton13:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton1a = CreateFrame("CheckButton", "WOWTR_CheckButton1a", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton1a.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["ownnames"]=="1") then QTR_PS["ownnames"]="0" else QTR_PS["ownnames"]="1" end; end);
WOWTR_CheckButton1a.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton13.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton1a:SetWidth(252);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton1a:SetPoint("TOPLEFT", WOWTR_CheckButton13.CheckBox, "BOTTOMLEFT", -260, -2);
   WOWTR_CheckButton1a:SetWidth(260);
else
   WOWTR_CheckButton1a:SetPoint("TOPLEFT", WOWTR_CheckButton13.CheckBox, "BOTTOMLEFT", 40, -2);
end
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton1a.Text:SetText(QTR_ReverseIfAR(WOW_ZmienKody(WoWTR_Config_Interface.translateOwnNames)..""));   -- Display translation of GOSSIP texts
else
   WOWTR_CheckButton1a.Text:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.translateOwnNames));   -- Display translation of GOSSIP texts
end
WOWTR_CheckButton1a.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton1a:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   if (WoWTR_Localization.lang == 'AR') then
      GameTooltip:AddLine(QTR_ReverseIfAR(WOW_ZmienKody(WoWTR_Config_Interface.translateOwnNames)).." ", false);                -- red color, no wrap
   else
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateOwnNames).." ", false);                                -- red color, no wrap
   end
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateOwnNamesDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton1a:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton14 = CreateFrame("CheckButton", "WOWTR_CheckButton14", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton14.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["tracker"]=="1") then QTR_PS["tracker"]="0" else QTR_PS["tracker"]="1" end; end);
WOWTR_CheckButton14.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton1a.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton14:SetWidth(260);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton14:SetPoint("TOPLEFT", WOWTR_CheckButton1a.CheckBox, "BOTTOMLEFT", -217, -2);
   WOWTR_CheckButton14:SetWidth(220);
else
   WOWTR_CheckButton14:SetPoint("TOPLEFT", WOWTR_CheckButton1a.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton14.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateTrackObjectives).."|r");   -- Display translation of GOSSIP texts
WOWTR_CheckButton14.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton14:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateTrackObjectives).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateTrackObjectivesDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);    -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton14:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
--if (WoWTR_Localization.lang == 'AR') then
--   WOWTR_CheckButton14:Hide();               -- opcja Quest Tracker jest wyłączona w wersji AR
--end
 
local WOWTR_slider4 = CreateFrame("Slider", "WOWTR_slider4", WOWTR_OptionPanel1, "OptionsSliderTemplate");
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_slider4:SetPoint("TOPLEFT", WOWTR_CheckButton14, "BOTTOMLEFT", 70, -30);
else
   WOWTR_slider4:SetPoint("TOPLEFT", WOWTR_CheckButton14, "BOTTOMLEFT", -30, -30);
end
WOWTR_slider4:SetMinMaxValues(11, 14);
WOWTR_slider4.minValue, WOWTR_slider4.maxValue = WOWTR_slider4:GetMinMaxValues();
WOWTR_slider4.Low:SetText(WOWTR_slider4.minValue);
WOWTR_slider4.High:SetText(WOWTR_slider4.maxValue);
getglobal(WOWTR_slider4:GetName() .. 'Text'):SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.fontsizeBubbles));
getglobal(WOWTR_slider4:GetName() .. 'Text'):SetFont(WOWTR_Font2, 11);
WOWTR_slider4:SetValue(tonumber(QTR_PS["fontsize"]));
WOWTR_slider4:SetValueStep(1);
WOWTR_slider4:SetScript("OnValueChanged", function(self,event,arg1) 
                                      QTR_PS["fontsize"]=string.format("%d",event); 
                                      WOWTR_sliderVal4:SetText(QTR_PS["fontsize"]);
                                      WOWTR_Opis4:SetFont(WOWTR_Font2, event);
                                      end);
WOWTR_sliderVal4 = WOWTR_OptionPanel1:CreateFontString(nil, "ARTWORK");
WOWTR_sliderVal4:SetFontObject(GameFontNormal);
WOWTR_sliderVal4:SetJustifyH("CENTER");
WOWTR_sliderVal4:SetJustifyV("TOP");
WOWTR_sliderVal4:ClearAllPoints();
WOWTR_sliderVal4:SetPoint("CENTER", WOWTR_slider4, "CENTER", 0, -12);
WOWTR_sliderVal4:SetText(QTR_PS["fontsize"]);   
WOWTR_sliderVal4:SetFont(WOWTR_Font2, 13);

WOWTR_Opis4 = WOWTR_OptionPanel1:CreateFontString(nil, "ARTWORK");
WOWTR_Opis4:SetFontObject(GameFontNormalLarge);
WOWTR_Opis4:SetJustifyH("LEFT");
WOWTR_Opis4:SetJustifyV("TOP");
WOWTR_Opis4:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Opis4:SetPoint("TOPLEFT", WOWTR_slider4, "BOTTOMLEFT", -230, 16);
else
   WOWTR_Opis4:SetPoint("TOPLEFT", WOWTR_slider4, "BOTTOMLEFT", 160, 16);
end
local fontsize = tonumber(QTR_PS["fontsize"]);
WOWTR_Opis4:SetFont(WOWTR_Font2, fontsize);
WOWTR_Opis4:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.sampleGossipText));

local WOWTR_Panel1Header2 = WOWTR_OptionPanel1:CreateFontString(nil, "ARTWORK");
WOWTR_Panel1Header2:SetFontObject(GameFontNormal);
WOWTR_Panel1Header2:SetJustifyH("LEFT"); 
WOWTR_Panel1Header2:SetJustifyV("TOP");
WOWTR_Panel1Header2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel1Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel1, "TOPLEFT", 580, -290);
else
   WOWTR_Panel1Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel1, "TOPLEFT", 20, -290);
end
WOWTR_Panel1Header2:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.savingUntranslatedQuests));   -- Saving untranslated quests and gossip texts
WOWTR_Panel1Header2:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton15 = CreateFrame("CheckButton", "WOWTR_CheckButton15", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton15.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["saveQS"]=="1") then QTR_PS["saveQS"]="0" else QTR_PS["saveQS"]="1" end; end);
WOWTR_CheckButton15:SetWidth(254);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton15.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel1Header2, "TOPLEFT", 55, -20);
   WOWTR_CheckButton15:SetPoint("TOPLEFT", WOWTR_Panel1Header2, "TOPLEFT", -95, -22);
   WOWTR_CheckButton15:SetWidth(165);
else
   WOWTR_CheckButton15.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel1Header2, "TOPLEFT", 10, -20);
   WOWTR_CheckButton15:SetPoint("TOPLEFT", WOWTR_Panel1Header2, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton15.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedQuests).."|r");   -- Save untranslated quests
WOWTR_CheckButton15.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton15:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedQuests).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.saveUntranslatedQuestsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton15:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton16 = CreateFrame("CheckButton", "WOWTR_CheckButton16", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton16.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["saveGS"]=="1") then QTR_PS["saveGS"]="0" else QTR_PS["saveGS"]="1" end; end);
WOWTR_CheckButton16.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton15.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton16:SetWidth(322);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton16:SetPoint("TOPLEFT", WOWTR_CheckButton15.CheckBox, "BOTTOMLEFT", -193, -2);
   WOWTR_CheckButton16:SetWidth(200);
else
   WOWTR_CheckButton16:SetPoint("TOPLEFT", WOWTR_CheckButton15.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton16.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedGossip).."|r");   -- Save untranslated gossip texts
WOWTR_CheckButton16.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton16:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedGossip).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.saveUntranslatedGossipDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton16:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_Panel1Header3 = WOWTR_OptionPanel1:CreateFontString(nil, "ARTWORK");
WOWTR_Panel1Header3:SetFontObject(GameFontNormal);
WOWTR_Panel1Header3:SetJustifyH("LEFT"); 
WOWTR_Panel1Header3:SetJustifyV("TOP");
WOWTR_Panel1Header3:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel1Header3:SetPoint("TOPLEFT", WOWTR_OptionPanel1, "TOPLEFT", 620, -400);
else
   WOWTR_Panel1Header3:SetPoint("TOPLEFT", WOWTR_OptionPanel1, "TOPLEFT", 20, -400);
end
WOWTR_Panel1Header3:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.integrationWithOtherAddons));   -- Integration with other addons
WOWTR_Panel1Header3:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton17 = CreateFrame("CheckButton", "WOWTR_CheckButton17", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton17.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["immersion"]=="1") then QTR_PS["immersion"]="0" else QTR_PS["immersion"]="1" end; end);
WOWTR_CheckButton17:SetWidth(303);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton17.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel1Header3, "TOPLEFT", 15, -20);
   WOWTR_CheckButton17:SetPoint("TOPLEFT", WOWTR_Panel1Header3, "TOPLEFT", -210, -22);
   WOWTR_CheckButton17:SetWidth(240);
else
   WOWTR_CheckButton17.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel1Header3, "TOPLEFT", 10, -20);
   WOWTR_CheckButton17:SetPoint("TOPLEFT", WOWTR_Panel1Header3, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton17.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateImmersion).."|r");   -- Display translation in Immersion addon
WOWTR_CheckButton17.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton17:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateImmersion).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateImmersionDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton17:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton18 = CreateFrame("CheckButton", "WOWTR_CheckButton18", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton18.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["storyline"]=="1") then QTR_PS["storyline"]="0" else QTR_PS["storyline"]="1" end; end);
WOWTR_CheckButton18.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton17.CheckBox, "BOTTOMLEFT", 0, 5);
WOWTR_CheckButton18:SetWidth(295);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton18:SetPoint("TOPLEFT", WOWTR_CheckButton17.CheckBox, "BOTTOMLEFT", -215, 3);
   WOWTR_CheckButton18:SetWidth(220);
else
   WOWTR_CheckButton18:SetPoint("TOPLEFT", WOWTR_CheckButton17.CheckBox, "BOTTOMLEFT", 40, 3);
end
WOWTR_CheckButton18.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateStoryLine).."|r");   -- Display translation in StoryLine addon
WOWTR_CheckButton18.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton18:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateStoryLine).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateStoryLineDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton18:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton19 = CreateFrame("CheckButton", "WOWTR_CheckButton19", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton19.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["questlog"]=="1") then QTR_PS["questlog"]="0" else QTR_PS["questlog"]="1" end; end);
WOWTR_CheckButton19.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton18.CheckBox, "BOTTOMLEFT", 0, 5);
WOWTR_CheckButton19:SetWidth(355);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton19:SetPoint("TOPLEFT", WOWTR_CheckButton18.CheckBox, "BOTTOMLEFT", -270, 3);
   WOWTR_CheckButton19:SetWidth(275);
else
   WOWTR_CheckButton19:SetPoint("TOPLEFT", WOWTR_CheckButton18.CheckBox, "BOTTOMLEFT", 40, 3);
end
WOWTR_CheckButton19.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateQuestLog).."|r");   -- Display translation in StoryLine addon
WOWTR_CheckButton19.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton19:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateQuestLog).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateQuestLogDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton19:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton1b = CreateFrame("CheckButton", "WOWTR_CheckButton1b", WOWTR_OptionPanel1, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton1b.CheckBox:SetScript("OnClick", function(self) if (QTR_PS["dialogueui"]=="1") then QTR_PS["dialogueui"]="0" else QTR_PS["dialogueui"]="1" end; end);
WOWTR_CheckButton1b.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton19.CheckBox, "BOTTOMLEFT", 0, 5);
WOWTR_CheckButton1b:SetWidth(355);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton1b:SetPoint("TOPLEFT", WOWTR_CheckButton19.CheckBox, "BOTTOMLEFT", -230, 3);
   WOWTR_CheckButton1b:SetWidth(275);
else
   WOWTR_CheckButton1b:SetPoint("TOPLEFT", WOWTR_CheckButton19.CheckBox, "BOTTOMLEFT", 40, 3);
end
WOWTR_CheckButton1b.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateDialogueUI).."|r");   -- Display translation in StoryLine addon
WOWTR_CheckButton1b.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton1b:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateDialogueUI).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateDialogueUIDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton1b:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

----- TAB 2

local WOWTR_OptionsHeaderIcon2 = WOWTR_OptionPanel2:CreateTexture(nil, "OVERLAY");
WOWTR_OptionsHeaderIcon2:SetWidth(200);
WOWTR_OptionsHeaderIcon2:SetHeight(200);
WOWTR_OptionsHeaderIcon2:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\bubbles_mini.jpg");   -- WOWTR_OptionPanel2 thumbnail
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderIcon2:SetPoint("CENTER", -230, 150);
else
   WOWTR_OptionsHeaderIcon2:SetPoint("CENTER", 230, 150);
end

local WOWTR_Panel2Header1 = WOWTR_OptionPanel2:CreateFontString(nil, "ARTWORK");
WOWTR_Panel2Header1:SetFontObject(GameFontNormal);
WOWTR_Panel2Header1:SetJustifyH("LEFT"); 
WOWTR_Panel2Header1:SetJustifyV("TOP");
WOWTR_Panel2Header1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel2Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel2, "TOPLEFT", 500, -25);
else
   WOWTR_Panel2Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel2, "TOPLEFT", 20, -25);
end
WOWTR_Panel2Header1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.generalMainHeaderBB));   -- Bubbles translations
WOWTR_Panel2Header1:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton21 = CreateFrame("CheckButton", "WOWTR_CheckButton21", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton21.CheckBox:SetScript("OnClick", function(self) if (BB_PM["active"]=="1") then BB_PM["active"]="0" else BB_PM["active"]="1" end; end);
WOWTR_CheckButton21:SetWidth(263);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton21.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel2Header1, "TOPLEFT", 135, -20);
   WOWTR_CheckButton21:SetPoint("TOPLEFT", WOWTR_Panel2Header1, "TOPLEFT", -10, -22);
   WOWTR_CheckButton21:SetWidth(150);
else
   WOWTR_CheckButton21.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel2Header1, "TOPLEFT", 10, -20);
   WOWTR_CheckButton21:SetPoint("TOPLEFT", WOWTR_Panel2Header1, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton21.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.activateBubblesTranslations).."|r");   -- Activate bubble translations
WOWTR_CheckButton21.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton21:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.activateBubblesTranslations).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.activateBubblesTranslationsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton21:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton22 = CreateFrame("CheckButton", "WOWTR_CheckButton22", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton22.CheckBox:SetScript("OnClick", function(self) if (BB_PM["chat-en"]=="1") then BB_PM["chat-en"]="0" else BB_PM["chat-en"]="1";BB_PM["chat-tr"]="0";WOWTR_CheckButton23:SetValue(false); end; end);
WOWTR_CheckButton22.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton21.CheckBox, "BOTTOMLEFT", 0, -20);
WOWTR_CheckButton22:SetWidth(315);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton22:SetPoint("TOPLEFT", WOWTR_CheckButton21.CheckBox, "BOTTOMLEFT", -215, -22);
   WOWTR_CheckButton22:SetWidth(220);
else
   WOWTR_CheckButton22:SetPoint("TOPLEFT", WOWTR_CheckButton21.CheckBox, "BOTTOMLEFT", 40, -22);
end
WOWTR_CheckButton22.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayOriginalTexts).."|r");   -- Display original text in chat frame
WOWTR_CheckButton22.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton22:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayOriginalTexts).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayOriginalTextsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton22:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton23 = CreateFrame("CheckButton", "WOWTR_CheckButton23", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton23.CheckBox:SetScript("OnClick", function(self) if (BB_PM["chat-tr"]=="1") then BB_PM["chat-tr"]="0" else BB_PM["chat-tr"]="1";BB_PM["chat-en"]="0";WOWTR_CheckButton22:SetValue(false); end; end);
WOWTR_CheckButton23.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton22.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton23:SetWidth(340);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton23:SetPoint("TOPLEFT", WOWTR_CheckButton22.CheckBox, "BOTTOMLEFT", -232, -2);
   WOWTR_CheckButton23:SetWidth(238);
else
   WOWTR_CheckButton23:SetPoint("TOPLEFT", WOWTR_CheckButton22.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton23.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslatedTexts).."|r");   -- Display translated text in chat frame
WOWTR_CheckButton23.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton23:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslatedTexts).." ", false);                -- red color, no wrap
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslatedTextsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton23:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton24 = CreateFrame("CheckButton", "WOWTR_CheckButton24", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton24.CheckBox:SetScript("OnClick", function(self) if (BB_PM["sex"]=="2") then BB_PM["sex"]="4";WOWTR_CheckButton26:SetValue(true); else BB_PM["sex"]="2";WOWTR_CheckButton25:SetValue(false);WOWTR_CheckButton26:SetValue(false); end; end);
WOWTR_CheckButton24.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton23.CheckBox, "BOTTOMLEFT", 0, -20);
WOWTR_CheckButton24:SetWidth(287);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton24:SetPoint("TOPLEFT", WOWTR_CheckButton23.CheckBox, "BOTTOMLEFT", -245, -22);
   WOWTR_CheckButton24:SetWidth(250);
else
   WOWTR_CheckButton24:SetPoint("TOPLEFT", WOWTR_CheckButton23.CheckBox, "BOTTOMLEFT", 40, -22);
end
WOWTR_CheckButton24.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.choiceGender1OfPlayer).."|r");   -- Choice of male expression
WOWTR_CheckButton24.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton24:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.choiceGender1OfPlayer).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.choiceGender1OfPlayerDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton24:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton25 = CreateFrame("CheckButton", "WOWTR_CheckButton25", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton25.CheckBox:SetScript("OnClick", function(self) if (BB_PM["sex"]=="3") then BB_PM["sex"]="4";WOWTR_CheckButton26:SetValue(true); else BB_PM["sex"]="3";WOWTR_CheckButton24:SetValue(false);WOWTR_CheckButton26:SetValue(false); end; end);
WOWTR_CheckButton25.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton24.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton25:SetWidth(285);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton25:SetPoint("TOPLEFT", WOWTR_CheckButton24.CheckBox, "BOTTOMLEFT", -243, -2);
   WOWTR_CheckButton25:SetWidth(247);
else
   WOWTR_CheckButton25:SetPoint("TOPLEFT", WOWTR_CheckButton24.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton25.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.choiceGender2OfPlayer).."|r");   -- Choice of female expression
WOWTR_CheckButton25.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton25:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.choiceGender2OfPlayer).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.choiceGender2OfPlayerDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton25:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton26 = CreateFrame("CheckButton", "WOWTR_CheckButton26", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton26.CheckBox:SetScript("OnClick", function(self) if (BB_PM["sex"]=="4") then BB_PM["sex"]="2";WOWTR_CheckButton24:SetValue(true); else BB_PM["sex"]="4";WOWTR_CheckButton24:SetValue(false);WOWTR_CheckButton25:SetValue(false); end; end);
WOWTR_CheckButton26.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton25.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton26:SetWidth(387);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton26:SetPoint("TOPLEFT", WOWTR_CheckButton25.CheckBox, "BOTTOMLEFT", -248, -2);
   WOWTR_CheckButton26:SetWidth(252);
else
   WOWTR_CheckButton26:SetPoint("TOPLEFT", WOWTR_CheckButton25.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton26.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.choiceGender3OfPlayer).."|r");   -- Choice of expression for the player depending
WOWTR_CheckButton26.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton26:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.choiceGender3OfPlayer).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.choiceGender3OfPlayerDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton26:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton2d1 = CreateFrame("CheckButton", "WOWTR_CheckButton2d1", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton2d1.CheckBox:SetScript("OnClick", function(self) if (BB_PM["dungeon"]=="1") then BB_PM["dungeon"]="0" else BB_PM["dungeon"]="1"; end; end);
WOWTR_CheckButton2d1:SetWidth(200);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton2d1.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton26.CheckBox, "BOTTOMLEFT", -300, 0);
   WOWTR_CheckButton2d1:SetPoint("TOPLEFT", WOWTR_CheckButton26.CheckBox, "BOTTOMLEFT", -530, -2);
   WOWTR_CheckButton2d1:SetWidth(235);
elseif ((WoWTR_Localization.lang == 'TR') or (WoWTR_Localization.lang == 'UA')) then
   WOWTR_CheckButton2d1.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton26.CheckBox, "BOTTOMLEFT", 310, 0);
   WOWTR_CheckButton2d1:SetPoint("TOPLEFT", WOWTR_CheckButton26.CheckBox, "BOTTOMLEFT", 350, -2);
else
   WOWTR_CheckButton2d1.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton26.CheckBox, "BOTTOMLEFT", 400, 0);
   WOWTR_CheckButton2d1:SetPoint("TOPLEFT", WOWTR_CheckButton26.CheckBox, "BOTTOMLEFT", 440, -2);
end
WOWTR_CheckButton2d1.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.showBubblesInDungeon).."|r");   -- show bubbles in dungeon
WOWTR_CheckButton2d1.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton2d1:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.showBubblesInDungeon).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.showBubblesInDungeonDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton2d1:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton2d2 = CreateFrame("CheckButton", "WOWTR_CheckButton2d2", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton2d2.CheckBox:SetScript("OnClick", function(self) if (BB_PM["dungeonF"]=="1") then BB_PM["dungeonF"]="0";
                                                                                                   WOWTR_SetDungeonFrames(WOWBB1, false);
                                                                                                   WOWTR_SetDungeonFrames(WOWBB2, false);
                                                                                                   WOWTR_SetDungeonFrames(WOWBB3, false);
                                                                                                   WOWTR_SetDungeonFrames(WOWBB4, false);
                                                                                                   WOWTR_SetDungeonFrames(WOWBB5, false);
                                                                                              else BB_PM["dungeonF"]="1"; 
                                                                                                   WOWTR_SetDungeonFrames(WOWBB1, true, 0);
                                                                                                   WOWTR_SetDungeonFrames(WOWBB2, true, 250);
                                                                                                   WOWTR_SetDungeonFrames(WOWBB3, true, -250);
                                                                                                   WOWTR_SetDungeonFrames(WOWBB4, true, 500);
                                                                                                   WOWTR_SetDungeonFrames(WOWBB5, true, -500);
                                                                                              end; end);
WOWTR_CheckButton2d2.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton2d1.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton2d2:SetWidth(200);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton2d2:SetPoint("TOPLEFT", WOWTR_CheckButton2d1.CheckBox, "BOTTOMLEFT", -195, -2);
   WOWTR_CheckButton2d2:SetWidth(200);
else
   WOWTR_CheckButton2d2:SetPoint("TOPLEFT", WOWTR_CheckButton2d1.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton2d2.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.setDungeonFrames).."|r");   -- show bubbles in dungeon
WOWTR_CheckButton2d2.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton2d2:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.setDungeonFrames).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.setDungeonFramesDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton2d2:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_slider5 = CreateFrame("Slider", "WOWTR_slider5", WOWTR_OptionPanel2, "OptionsSliderTemplate");
WOWTR_slider5:SetPoint("TOPLEFT", WOWTR_CheckButton2d2, "BOTTOMLEFT", 20, -30);
WOWTR_slider5:SetMinMaxValues(3, 10);
WOWTR_slider5.minValue, WOWTR_slider5.maxValue = WOWTR_slider5:GetMinMaxValues();
WOWTR_slider5.Low:SetText(WOWTR_slider5.minValue);
WOWTR_slider5.High:SetText(WOWTR_slider5.maxValue);
getglobal(WOWTR_slider5:GetName() .. 'Text'):SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.timerDisplay));
getglobal(WOWTR_slider5:GetName() .. 'Text'):SetFont(WOWTR_Font2, 11);
WOWTR_slider5:SetValue(tonumber(BB_PM["timeDisplay"]));
WOWTR_slider5:SetValueStep(1);
WOWTR_slider5:SetScript("OnValueChanged", function(self,event,arg1) 
                                      BB_PM["timeDisplay"]=string.format("%d",event); 
                                      WOWTR_sliderVal5:SetText(BB_PM["timeDisplay"]);
                                      end);
WOWTR_sliderVal5 = WOWTR_OptionPanel2:CreateFontString(nil, "ARTWORK");
WOWTR_sliderVal5:SetFontObject(GameFontNormal);
WOWTR_sliderVal5:SetJustifyH("CENTER");
WOWTR_sliderVal5:SetJustifyV("TOP");
WOWTR_sliderVal5:ClearAllPoints();
WOWTR_sliderVal5:SetPoint("CENTER", WOWTR_slider5, "CENTER", 0, -12);
WOWTR_sliderVal5:SetText(BB_PM["timeDisplay"]);   
WOWTR_sliderVal5:SetFont(WOWTR_Font2, 13);
 
local WOWTR_Panel2Header2 = WOWTR_OptionPanel2:CreateFontString(nil, "ARTWORK");
WOWTR_Panel2Header2:SetFontObject(GameFontNormal);
WOWTR_Panel2Header2:SetJustifyH("LEFT"); 
WOWTR_Panel2Header2:SetJustifyV("TOP");
WOWTR_Panel2Header2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel2Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel2, "TOPLEFT", 579, -290);
else
   WOWTR_Panel2Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel2, "TOPLEFT", 20, -290);
end
WOWTR_Panel2Header2:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.savingUntranslatedBubbles));   -- Saving untranslated bubble texts
WOWTR_Panel2Header2:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton27 = CreateFrame("CheckButton", "WOWTR_CheckButton27", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton27.CheckBox:SetScript("OnClick", function(self) if (BB_PM["saveBN"]=="1") then BB_PM["saveBM"]="0" else BB_PM["saveBM"]="1" end; end);
WOWTR_CheckButton27:SetWidth(350);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton27.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel2Header2, "TOPLEFT", 55, -20);
   WOWTR_CheckButton27:SetPoint("TOPLEFT", WOWTR_Panel2Header2, "TOPLEFT", -116, -22);
   WOWTR_CheckButton27:SetWidth(175);
else
   WOWTR_CheckButton27.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel2Header2, "TOPLEFT", 10, -20);
   WOWTR_CheckButton27:SetPoint("TOPLEFT", WOWTR_Panel2Header2, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton27.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedBubbles).."|r");   -- Save untranslated bubbles
WOWTR_CheckButton27.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton27:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedBubbles).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.saveUntranslatedBubblesDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton27:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_Panel2Header3 = WOWTR_OptionPanel2:CreateFontString(nil, "ARTWORK");
WOWTR_Panel2Header3:SetFontObject(GameFontNormal);
WOWTR_Panel2Header3:SetJustifyH("LEFT"); 
WOWTR_Panel2Header3:SetJustifyV("TOP");
WOWTR_Panel2Header3:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel2Header3:SetPoint("TOPLEFT", WOWTR_OptionPanel2, "TOPLEFT", 600, -370);
else
   WOWTR_Panel2Header3:SetPoint("TOPLEFT", WOWTR_OptionPanel2, "TOPLEFT", 20, -370);
end
WOWTR_Panel2Header3:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.fontSizeHeader));    -- Font size of bubbles
WOWTR_Panel2Header3:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton28 = CreateFrame("CheckButton", "WOWTR_CheckButton28", WOWTR_OptionPanel2, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton28.CheckBox:SetScript("OnClick", function(self) if (BB_PM["setsize"]=="1") then BB_PM["setsize"]="0" else BB_PM["setsize"]="1" end; end);
WOWTR_CheckButton28:SetWidth(235);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton28.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel2Header3, "TOPLEFT", 35, -20);
   WOWTR_CheckButton28:SetPoint("TOPLEFT", WOWTR_Panel2Header3, "TOPLEFT", -111, -22);
   WOWTR_CheckButton28:SetWidth(150);
else
   WOWTR_CheckButton28.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel2Header3, "TOPLEFT", 10, -20);
   WOWTR_CheckButton28:SetPoint("TOPLEFT", WOWTR_Panel2Header3, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton28.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.setFontActivate).."|r");   -- Activate font size changes
WOWTR_CheckButton28.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton28:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.setFontActivate).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.setFontActivateDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton28:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_slider1 = CreateFrame("Slider", "WOWTR_slider1", WOWTR_OptionPanel2, "OptionsSliderTemplate");
WOWTR_slider1:SetPoint("TOPLEFT", WOWTR_CheckButton28, "BOTTOMLEFT", 20, -30);
WOWTR_slider1:SetMinMaxValues(10, 20);
WOWTR_slider1.minValue, WOWTR_slider1.maxValue = WOWTR_slider1:GetMinMaxValues();
WOWTR_slider1.Low:SetText(WOWTR_slider1.minValue);
WOWTR_slider1.High:SetText(WOWTR_slider1.maxValue);
getglobal(WOWTR_slider1:GetName() .. 'Text'):SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.fontsizeBubbles));
getglobal(WOWTR_slider1:GetName() .. 'Text'):SetFont(WOWTR_Font2, 11);
WOWTR_slider1:SetValue(tonumber(BB_PM["fontsize"]));
WOWTR_slider1:SetValueStep(1);
WOWTR_slider1:SetScript("OnValueChanged", function(self,event,arg1) 
                                      BB_PM["fontsize"]=string.format("%d",event); 
                                      WOWTR_sliderVal1:SetText(BB_PM["fontsize"]);
                                      WOWTR_Opis1:SetFont(WOWTR_Font2, event);
                                      end);
WOWTR_sliderVal1 = WOWTR_OptionPanel2:CreateFontString(nil, "ARTWORK");
WOWTR_sliderVal1:SetFontObject(GameFontNormal);
WOWTR_sliderVal1:SetJustifyH("CENTER");
WOWTR_sliderVal1:SetJustifyV("TOP");
WOWTR_sliderVal1:ClearAllPoints();
WOWTR_sliderVal1:SetPoint("CENTER", WOWTR_slider1, "CENTER", 0, -12);
WOWTR_sliderVal1:SetText(BB_PM["fontsize"]);   
WOWTR_sliderVal1:SetFont(WOWTR_Font2, 13);

WOWTR_Opis1 = WOWTR_OptionPanel2:CreateFontString(nil, "ARTWORK");
WOWTR_Opis1:SetFontObject(GameFontNormalLarge);
WOWTR_Opis1:SetJustifyH("LEFT");
WOWTR_Opis1:SetJustifyV("TOP");
WOWTR_Opis1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Opis1:SetPoint("TOPLEFT", WOWTR_slider1, "BOTTOMLEFT", -200, 30);
else
   WOWTR_Opis1:SetPoint("TOPLEFT", WOWTR_slider1, "BOTTOMLEFT", 200, 30);
end
local fontsize = tonumber(BB_PM["fontsize"]);
if (BB_PM["setsize"]=="1") then
   WOWTR_Opis1:SetFont(WOWTR_Font2, fontsize);
else
   WOWTR_Opis1:SetFont(WOWTR_Font2, 13);
end
WOWTR_Opis1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.sampleText));

----- TAB 3

local WOWTR_OptionsHeaderIcon3 = WOWTR_OptionPanel3:CreateTexture(nil, "OVERLAY");
WOWTR_OptionsHeaderIcon3:SetWidth(200);
WOWTR_OptionsHeaderIcon3:SetHeight(200);
WOWTR_OptionsHeaderIcon3:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\movies_mini.jpg");   -- WOWTR_OptionPanel3 thumbnail
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderIcon3:SetPoint("CENTER", -230, 150);
else
   WOWTR_OptionsHeaderIcon3:SetPoint("CENTER", 230, 150);
end

local WOWTR_Panel3Header1 = WOWTR_OptionPanel3:CreateFontString(nil, "ARTWORK");
WOWTR_Panel3Header1:SetFontObject(GameFontNormal);
WOWTR_Panel3Header1:SetJustifyH("LEFT"); 
WOWTR_Panel3Header1:SetJustifyV("TOP");
WOWTR_Panel3Header1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel3Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel3, "TOPLEFT", 397, -25);
else
   WOWTR_Panel3Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel3, "TOPLEFT", 20, -25);
end
WOWTR_Panel3Header1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.generalMainHeaderMF));    -- Subtitle translations
WOWTR_Panel3Header1:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton31 = CreateFrame("CheckButton", "WOWTR_CheckButton31", WOWTR_OptionPanel3, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton31.CheckBox:SetScript("OnClick", function(self) if (MF_PM["active"]=="1") then MF_PM["active"]="0" else MF_PM["active"]="1" end; end);
WOWTR_CheckButton31:SetWidth(218);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton31.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel3Header1, "TOPLEFT", 240, -20);
   WOWTR_CheckButton31:SetPoint("TOPLEFT", WOWTR_Panel3Header1, "TOPLEFT", -10, -22);
   WOWTR_CheckButton31:SetWidth(250);
else
   WOWTR_CheckButton31.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel3Header1, "TOPLEFT", 10, -20);
   WOWTR_CheckButton31:SetPoint("TOPLEFT", WOWTR_Panel3Header1, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton31.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.activateSubtitleTranslations).."|r");   -- Activate subtitle translations
WOWTR_CheckButton31.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton31:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.activateSubtitleTranslations).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.activateSubtitleTranslationsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton31:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton32 = CreateFrame("CheckButton", "WOWTR_CheckButton32", WOWTR_OptionPanel3, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton32.CheckBox:SetScript("OnClick", function(self) if (MF_PM["intro"]=="1") then MF_PM["intro"]="0" else MF_PM["intro"]="1" end; end);
WOWTR_CheckButton32.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton31.CheckBox, "BOTTOMLEFT", 0, -20);
WOWTR_CheckButton32:SetWidth(318);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton32:SetPoint("TOPLEFT", WOWTR_CheckButton31.CheckBox, "BOTTOMLEFT", -196, -22);
   WOWTR_CheckButton32:SetWidth(197);
else
   WOWTR_CheckButton32:SetPoint("TOPLEFT", WOWTR_CheckButton31.CheckBox, "BOTTOMLEFT", 40, -22);
end
WOWTR_CheckButton32.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.subtitleIntro).."|r");   -- Display translated subtitles of Intro
WOWTR_CheckButton32.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton32:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.subtitleIntro).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.subtitleIntroDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton32:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton33 = CreateFrame("CheckButton", "WOWTR_CheckButton33", WOWTR_OptionPanel3, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton33.CheckBox:SetScript("OnClick", function(self) if (MF_PM["movie"]=="1") then MF_PM["movie"]="0" else MF_PM["movie"]="1" end; end);
WOWTR_CheckButton33.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton32.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton33:SetWidth(315);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton33:SetPoint("TOPLEFT", WOWTR_CheckButton32.CheckBox, "BOTTOMLEFT", -200, -2);
   WOWTR_CheckButton33:SetWidth(200);
else
   WOWTR_CheckButton33:SetPoint("TOPLEFT", WOWTR_CheckButton32.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton33.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.subtitleMovies).."|r");   -- Display translated subtitle of Movies
WOWTR_CheckButton33.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton33:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.subtitleMovies).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.subtitleMoviesDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton33:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton34 = CreateFrame("CheckButton", "WOWTR_CheckButton34", WOWTR_OptionPanel3, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton34.CheckBox:SetScript("OnClick", function(self) if (MF_PM["cinematic"]=="1") then MF_PM["cinematic"]="0" else MF_PM["cinematic"]="1" end; end);
WOWTR_CheckButton34.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton33.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton34:SetWidth(347);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton34:SetPoint("TOPLEFT", WOWTR_CheckButton33.CheckBox, "BOTTOMLEFT", -200, -2);
   WOWTR_CheckButton34:SetWidth(200);
else
   WOWTR_CheckButton34:SetPoint("TOPLEFT", WOWTR_CheckButton33.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton34.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.subtitleCinematics).."|r");   -- Display translated sybtitles of Cinematics
WOWTR_CheckButton34.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton34:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.subtitleCinematics).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.subtitleCinematicsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton34:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_Panel3Header2 = WOWTR_OptionPanel3:CreateFontString(nil, "ARTWORK");
WOWTR_Panel3Header2:SetFontObject(GameFontNormal);
WOWTR_Panel3Header2:SetJustifyH("LEFT"); 
WOWTR_Panel3Header2:SetJustifyV("TOP");
WOWTR_Panel3Header2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel3Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel3, "TOPLEFT", 582, -210);
else
   WOWTR_Panel3Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel3, "TOPLEFT", 20, -210);
end
WOWTR_Panel3Header2:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.savingUntranslatedSubtitles));   -- Saving untranslated subtitles
WOWTR_Panel3Header2:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton35 = CreateFrame("CheckButton", "WOWTR_CheckButton35", WOWTR_OptionPanel3, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton35.CheckBox:SetScript("OnClick", function(self) if (MF_PM["save"]=="1") then MF_PM["save"]="0" else MF_PM["save"]="1" end; end);
WOWTR_CheckButton35:SetWidth(260);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton35.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel3Header2, "TOPLEFT", 55, -20);
   WOWTR_CheckButton35:SetPoint("TOPLEFT", WOWTR_Panel3Header2, "TOPLEFT", -123, -22);
   WOWTR_CheckButton35:SetWidth(180);
else
   WOWTR_CheckButton35.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel3Header2, "TOPLEFT", 10, -20);
   WOWTR_CheckButton35:SetPoint("TOPLEFT", WOWTR_Panel3Header2, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton35.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedSubtitles).."|r");   -- Save untranslated subtitles
WOWTR_CheckButton35.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton35:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedSubtitles).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.saveUntranslatedSubtitlesDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton35:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

if (WoWTR_Localization.lang == 'AR') then          -- part: Chat
   local WOWTR_Panel3Separator = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
   WOWTR_Panel3Separator:SetFontObject(GameFontWhite);
   WOWTR_Panel3Separator:SetJustifyH("LEFT"); 
   WOWTR_Panel3Separator:SetJustifyV("TOP");
   WOWTR_Panel3Separator:ClearAllPoints();
   WOWTR_Panel3Separator:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 20, -300);
   local frame3 = WOWTR_OptionPanel3:CreateTexture(nil, "BACKGROUND")
   frame3:SetSize(684, 1)
   frame3:SetPoint("TOPLEFT", 0, -300)
   frame3:SetColorTexture(0.2, 0.2, 0.2, 1)

   local WOWTR_OptionsHeaderIcon8 = WOWTR_OptionPanel3:CreateTexture(nil, "OVERLAY");
   WOWTR_OptionsHeaderIcon8:SetWidth(200);
   WOWTR_OptionsHeaderIcon8:SetHeight(200);
   WOWTR_OptionsHeaderIcon8:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\archat.jpg");
   WOWTR_OptionsHeaderIcon8:SetPoint("CENTER", -230, -150);

   local WOWTR_Panel3Header3 = WOWTR_OptionPanel3:CreateFontString(nil, "ARTWORK");
   WOWTR_Panel3Header3:SetFontObject(GameFontNormal);
   WOWTR_Panel3Header3:SetJustifyH("LEFT"); 
   WOWTR_Panel3Header3:SetJustifyV("TOP");
   WOWTR_Panel3Header3:ClearAllPoints();
   WOWTR_Panel3Header3:SetPoint("TOPLEFT", WOWTR_Panel3Separator, "TOPLEFT", 400, -20);
   WOWTR_Panel3Header3:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.chatService));
   WOWTR_Panel3Header3:SetFont(WOWTR_Font2, 15);

   local WOWTR_CheckButton36 = CreateFrame("CheckButton", "WOWTR_CheckButton36", WOWTR_OptionPanel3, "SettingsCheckBoxControlTemplate");
   WOWTR_CheckButton36.CheckBox:SetScript("OnClick", function(self) if (CH_PM["active"]=="1") then CH_PM["active"]="0";CH_ToggleButton:SetText("EN");CH_ToggleButton:Hide() else CH_PM["active"]="1";CH_ToggleButton:Show() end; end);
   WOWTR_CheckButton36:SetWidth(218);
   WOWTR_CheckButton36.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel3Header3, "TOPLEFT", 215, -20);
   WOWTR_CheckButton36:SetPoint("TOPLEFT", WOWTR_Panel3Header3, "TOPLEFT", 20, -22);
   WOWTR_CheckButton36:SetWidth(250);
   WOWTR_CheckButton36.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.activateChatService).."|r");   -- Activate service of arabic chat
   WOWTR_CheckButton36.Text:SetFont(WOWTR_Font2, 15);
   WOWTR_CheckButton36:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.activateChatService).." ", false);                -- red color, no wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.activateChatServiceDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show()   -- Show the tooltip
      end);
   WOWTR_CheckButton36:SetScript("OnLeave", function(self)
      GameTooltip:Hide()   -- Hide the tooltip
      end);

   local WOWTR_CheckButton37 = CreateFrame("CheckButton", "WOWTR_CheckButton37", WOWTR_OptionPanel3, "SettingsCheckBoxControlTemplate");
   WOWTR_CheckButton37.CheckBox:SetScript("OnClick", function(self) if (CH_PM["setsize"]=="1") then CH_PM["setsize"]="0" else CH_PM["setsize"]="1" end; end);
   WOWTR_CheckButton37:SetWidth(235);
   WOWTR_CheckButton37.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton36.CheckBox, "BOTTOMLEFT", 0, 0);
   WOWTR_CheckButton37:SetPoint("TOPLEFT", WOWTR_CheckButton36.CheckBox, "BOTTOMLEFT", -140, -2);
   WOWTR_CheckButton37:SetWidth(150);
   WOWTR_CheckButton37.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.chatFontActivate).."|r");   -- Activate font size changes
   WOWTR_CheckButton37.Text:SetFont(WOWTR_Font2, 15);
   WOWTR_CheckButton37:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.chatFontActivate).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.chatFontActivateDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
   WOWTR_CheckButton37:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

   local WOWTR_slider6 = CreateFrame("Slider", "WOWTR_slider6", WOWTR_OptionPanel3, "OptionsSliderTemplate");
   WOWTR_slider6:SetPoint("TOPLEFT", WOWTR_CheckButton37, "BOTTOMLEFT", 20, -30);
   WOWTR_slider6:SetMinMaxValues(10, 20);
   WOWTR_slider6.minValue, WOWTR_slider6.maxValue = WOWTR_slider6:GetMinMaxValues();
   WOWTR_slider6.Low:SetText(WOWTR_slider6.minValue);
   WOWTR_slider6.High:SetText(WOWTR_slider6.maxValue);
   getglobal(WOWTR_slider6:GetName() .. 'Text'):SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.fontsizeBubbles));
   getglobal(WOWTR_slider6:GetName() .. 'Text'):SetFont(WOWTR_Font2, 11);
   WOWTR_slider6:SetValue(tonumber(CH_PM["fontsize"]));
   WOWTR_slider6:SetValueStep(1);
   WOWTR_slider6:SetScript("OnValueChanged", function(self,event,arg1) 
                                      BB_PM["fontsize"]=string.format("%d",event); 
                                      WOWTR_sliderVal6:SetText(BB_PM["fontsize"]);
                                      end);
   WOWTR_sliderVal6 = WOWTR_OptionPanel3:CreateFontString(nil, "ARTWORK");
   WOWTR_sliderVal6:SetFontObject(GameFontNormal);
   WOWTR_sliderVal6:SetJustifyH("CENTER");
   WOWTR_sliderVal6:SetJustifyV("TOP");
   WOWTR_sliderVal6:ClearAllPoints();
   WOWTR_sliderVal6:SetPoint("CENTER", WOWTR_slider6, "CENTER", 0, -12);
   WOWTR_sliderVal6:SetText(BB_PM["fontsize"]);   
   WOWTR_sliderVal6:SetFont(WOWTR_Font2, 13);
   
   if (CH_PM["active"]=="1") then
      CH_ToggleButton:Show();
   else
      CH_ToggleButton:Hide();
   end
end

----- TAB 4

local WOWTR_OptionsHeaderIcon4 = WOWTR_OptionPanel4:CreateTexture(nil, "OVERLAY");
WOWTR_OptionsHeaderIcon4:SetWidth(200);
WOWTR_OptionsHeaderIcon4:SetHeight(200);
WOWTR_OptionsHeaderIcon4:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\tutorials_mini.jpg");   -- WOWTR_OptionPanel4 thumbnail
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderIcon4:SetPoint("CENTER", -230, 150);
else
   WOWTR_OptionsHeaderIcon4:SetPoint("CENTER", 230, 150);
end

local WOWTR_Panel4Header1 = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
WOWTR_Panel4Header1:SetFontObject(GameFontNormal);
WOWTR_Panel4Header1:SetJustifyH("LEFT"); 
WOWTR_Panel4Header1:SetJustifyV("TOP");
WOWTR_Panel4Header1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel4Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 445, -25);
else
   WOWTR_Panel4Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 20, -25);
end
WOWTR_Panel4Header1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.generalMainHeaderTT));     -- Tutorial translations
WOWTR_Panel4Header1:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton41 = CreateFrame("CheckButton", "WOWTR_CheckButton41", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton41.CheckBox:SetScript("OnClick", function(self) if (TT_PS["active"]=="1") then TT_PS["active"]="0" else TT_PS["active"]="1" end; end);
WOWTR_CheckButton41:SetWidth(215);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton41.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header1, "TOPLEFT", 190, -20);
   WOWTR_CheckButton41:SetPoint("TOPLEFT", WOWTR_Panel4Header1, "TOPLEFT", 0, -22);
   WOWTR_CheckButton41:SetWidth(190);
else
   WOWTR_CheckButton41.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header1, "TOPLEFT", 10, -20);
   WOWTR_CheckButton41:SetPoint("TOPLEFT", WOWTR_Panel4Header1, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton41.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.activateTutorialTranslations).."|r");   -- Activate subtitle translations
WOWTR_CheckButton41.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton41:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.activateTutorialTranslations), false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.activateTutorialTranslationsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton41:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_Panel4Header2 = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
WOWTR_Panel4Header2:SetFontObject(GameFontNormal);
WOWTR_Panel4Header2:SetJustifyH("LEFT"); 
WOWTR_Panel4Header2:SetJustifyV("TOP");
WOWTR_Panel4Header2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel4Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 580, -100);
else
   WOWTR_Panel4Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 20, -100);
end
WOWTR_Panel4Header2:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.savingUntranslatedTutorials));   -- Saving untranslated tutorials
WOWTR_Panel4Header2:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton42 = CreateFrame("CheckButton", "WOWTR_CheckButton42", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton42.CheckBox:SetScript("OnClick", function(self) if (TT_PS["save"]=="1") then TT_PS["save"]="0" else TT_PS["save"]="1" end; end);
WOWTR_CheckButton42:SetWidth(300);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton42.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header2, "TOPLEFT", 55, -20);
   WOWTR_CheckButton42:SetPoint("TOPLEFT", WOWTR_Panel4Header2, "TOPLEFT", -160, -22);
   WOWTR_CheckButton42:SetWidth(215);
else
   WOWTR_CheckButton42.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header2, "TOPLEFT", 10, -20);
   WOWTR_CheckButton42:SetPoint("TOPLEFT", WOWTR_Panel4Header2, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton42.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedTutorials).."|r");   -- Save untranslated tutorials
WOWTR_CheckButton42.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton42:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedTutorials).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.saveUntranslatedTutorialsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton42:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

if (#WOWTR_Fonts > 1) then
   local WOWTR_Panel4Header2f = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
   WOWTR_Panel4Header2f:SetFontObject(GameFontNormal);
   WOWTR_Panel4Header2f:SetJustifyH("LEFT"); 
   WOWTR_Panel4Header2f:SetJustifyV("TOP");
   WOWTR_Panel4Header2f:ClearAllPoints();
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_Panel4Header2f:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 545, -170);
   else
      WOWTR_Panel4Header2f:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 20, -170);
   end
   WOWTR_Panel4Header2f:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.fontSelectingFontHeader));   -- Select a font header
   WOWTR_Panel4Header2f:SetFont(WOWTR_Font2, 15);

   local WOWTR_Panel4Header2g = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
   WOWTR_Panel4Header2g:SetFontObject(GameFontNormal);
   WOWTR_Panel4Header2g:SetJustifyH("LEFT"); 
   WOWTR_Panel4Header2g:SetJustifyV("TOP");
   WOWTR_Panel4Header2g:ClearAllPoints();
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_Panel4Header2g:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 300, -170);
   else
      WOWTR_Panel4Header2g:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 290, -170);
   end
   WOWTR_Panel4Header2g:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.fontCurrentFont));   -- Current font:
   WOWTR_Panel4Header2g:SetFont(WOWTR_Font2, 15);

   local WOWTR_Panel4Header2h = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
   WOWTR_Panel4Header2h:SetFontObject(GameFontWhite);
   WOWTR_Panel4Header2h:SetJustifyH("LEFT"); 
   WOWTR_Panel4Header2h:SetJustifyV("TOP");
   WOWTR_Panel4Header2h:ClearAllPoints();
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_Panel4Header2h:SetPoint("TOPLEFT", WOWTR_Panel4Header2g, "TOPLEFT", 0, -30);
   else
      WOWTR_Panel4Header2h:SetPoint("TOPLEFT", WOWTR_Panel4Header2g, "TOPLEFT", 0, -30);
   end
   WOWTR_Panel4Header2h:SetText(QTR_PS["FontFile"]);   -- current font file
   WOWTR_Panel4Header2h:SetFont(WOWTR_Font2, 13);

   local WOWTR_Panel4SelectF = CreateFrame("Frame", "WOWTR_Panel4SelectF", WOWTR_OptionPanel4, "UIDropDownMenuTemplate");
   WOWTR_Panel4SelectF:ClearAllPoints();
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_Panel4SelectF:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 460, -195);
   else
      WOWTR_Panel4SelectF:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 0, -195);
   end
   UIDropDownMenu_SetWidth(WOWTR_Panel4SelectF, 170);
   UIDropDownMenu_SetText(WOWTR_Panel4SelectF, WoWTR_Config_Interface.fontSelectFontFile);        -- Select a font file
   UIDropDownMenu_Initialize(WOWTR_Panel4SelectF, function(self, level, _)
      for i, font in ipairs(WOWTR_Fonts) do
         local info = UIDropDownMenu_CreateInfo();
         info.text = font;
--      info.text:SetFont(WOWTR_Font2, 13);
         info.value = font;
         info.func = function(self, arg1, arg2, checked)    -- function is called when option is clicked
            QTR_PS["FontFile"] = self.value;
            WOWTR_Panel4Header2h:SetText(self.value);       -- Selected font
            WOWTR_Font2 = WoWTR_Localization.mainFolder.."\\Fonts\\"..self.value;
            WOWTR_Panel4Header2h:SetFont(WOWTR_Font2, 13);
            WOWTR_ReloadButtonUI:Show();
            end;
         UIDropDownMenu_AddButton(info);
      end
   end);
end   -- if
   
local WOWTR_Panel4Separator = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
WOWTR_Panel4Separator:SetFontObject(GameFontWhite);
WOWTR_Panel4Separator:SetJustifyH("LEFT"); 
WOWTR_Panel4Separator:SetJustifyV("TOP");
WOWTR_Panel4Separator:ClearAllPoints();
WOWTR_Panel4Separator:SetPoint("TOPLEFT", WOWTR_OptionPanel4, "TOPLEFT", 20, -250);
local frame = WOWTR_OptionPanel4:CreateTexture(nil, "BACKGROUND")
frame:SetSize(684, 1)
frame:SetPoint("TOPLEFT", 0, -240)
frame:SetColorTexture(0.2, 0.2, 0.2, 1)

local WOWTR_OptionsHeaderIcon5 = WOWTR_OptionPanel4:CreateTexture(nil, "OVERLAY");
WOWTR_OptionsHeaderIcon5:SetWidth(200);
WOWTR_OptionsHeaderIcon5:SetHeight(200);
WOWTR_OptionsHeaderIcon5:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\ui_mini.jpg");   -- WOWTR_OptionPanel4 thumbnail
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderIcon5:SetPoint("CENTER", -230, -100);
else
   WOWTR_OptionsHeaderIcon5:SetPoint("CENTER", 230, -100);
end

local WOWTR_Panel4Header3 = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
WOWTR_Panel4Header3:SetFontObject(GameFontNormal);
WOWTR_Panel4Header3:SetJustifyH("LEFT"); 
WOWTR_Panel4Header3:SetJustifyV("TOP");
WOWTR_Panel4Header3:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel4Header3:SetPoint("TOPLEFT", WOWTR_Panel4Separator, "TOPLEFT", 480, -10);
else
   WOWTR_Panel4Header3:SetPoint("TOPLEFT", WOWTR_Panel4Separator, "TOPLEFT", 0, -10);
end
WOWTR_Panel4Header3:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.translationUI));   -- Translation of user interface
WOWTR_Panel4Header3:SetFont(WOWTR_Font2, 15);

local WOWTR_Panel4Text1 = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
WOWTR_Panel4Text1:SetFontObject(GameFontWhite);
WOWTR_Panel4Text1:SetJustifyH("LEFT"); 
WOWTR_Panel4Text1:SetJustifyV("TOP");
WOWTR_Panel4Text1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel4Text1:SetPoint("TOPLEFT", WOWTR_Panel4Separator, "TOPLEFT", 485, -30);
else
   WOWTR_Panel4Text1:SetPoint("TOPLEFT", WOWTR_Panel4Separator, "TOPLEFT", 0, -30);
end
WOWTR_Panel4Text1:SetWidth(640);
WOWTR_Panel4Text1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationtxt));
WOWTR_Panel4Text1:SetFont(WOWTR_Font2, 12);

local WOWTR_CheckButton43 = CreateFrame("CheckButton", "WOWTR_CheckButton43", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton43.CheckBox:SetScript("OnClick", function(self) if (TT_PS["ui1"]=="1") then TT_PS["ui1"]="0" else TT_PS["ui1"]="1" end; end);
WOWTR_CheckButton43:SetWidth(150);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton43.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header3, "TOPLEFT", 135, -45);
   WOWTR_CheckButton43:SetPoint("TOPLEFT", WOWTR_Panel4Header3, "TOPLEFT", 60, -47);
   WOWTR_CheckButton43:SetWidth(77);
else
   WOWTR_CheckButton43.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header3, "TOPLEFT", 10, -45);
   WOWTR_CheckButton43:SetPoint("TOPLEFT", WOWTR_Panel4Header3, "TOPLEFT", 50, -47);
end
WOWTR_CheckButton43.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI1).."|r");
WOWTR_CheckButton43.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton43:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI1).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft1"):SetWidth(150);
   if (WoWTR_Localization.lang == 'AR') then
      getglobal("GameTooltipTextLeft1"):SetJustifyH("RIGHT");
   end
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationUI1DESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton43:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
   
local WOWTR_CheckButton45 = CreateFrame("CheckButton", "WOWTR_CheckButton45", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton45.CheckBox:SetScript("OnClick", function(self) if (TT_PS["ui2"]=="1") then TT_PS["ui2"]="0" else TT_PS["ui2"]="1" end; end);
WOWTR_CheckButton45.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton43.CheckBox, "TOPLEFT", 0, -28);
WOWTR_CheckButton45:SetWidth(150);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton45:SetPoint("TOPLEFT", WOWTR_CheckButton43.CheckBox, "TOPLEFT", -118, -30);
   WOWTR_CheckButton45:SetWidth(120);
else
   WOWTR_CheckButton45:SetPoint("TOPLEFT", WOWTR_CheckButton43.CheckBox, "TOPLEFT", 40, -30);
end
WOWTR_CheckButton45.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI2).."|r");   -- Display translation of user interface (Character Info)
WOWTR_CheckButton45.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton45:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI2).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft1"):SetWidth(150);
   if (WoWTR_Localization.lang == 'AR') then
      getglobal("GameTooltipTextLeft1"):SetJustifyH("RIGHT");
   end
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationUI2DESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton45:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton46 = CreateFrame("CheckButton", "WOWTR_CheckButton46", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton46.CheckBox:SetScript("OnClick", function(self) if (TT_PS["ui3"]=="1") then TT_PS["ui3"]="0" else TT_PS["ui3"]="1" end; end);
WOWTR_CheckButton46.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton45.CheckBox, "TOPLEFT", 0, -28);
WOWTR_CheckButton46:SetWidth(151);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton46:SetPoint("TOPLEFT", WOWTR_CheckButton45.CheckBox, "TOPLEFT", -122, -30);
   WOWTR_CheckButton46:SetWidth(124);
else
   WOWTR_CheckButton46:SetPoint("TOPLEFT", WOWTR_CheckButton45.CheckBox, "TOPLEFT", 40, -30);
end
WOWTR_CheckButton46.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI3).."|r");   -- Display translation of user interface (Group Finder)
WOWTR_CheckButton46.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton46:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI3).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft1"):SetWidth(150);
   if (WoWTR_Localization.lang == 'AR') then
      getglobal("GameTooltipTextLeft1"):SetJustifyH("RIGHT");
   end
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationUI3DESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton46:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton50 = CreateFrame("CheckButton", "WOWTR_CheckButton50", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton50.CheckBox:SetScript("OnClick", function(self) if (TT_PS["ui7"]=="1") then TT_PS["ui7"]="0" else TT_PS["ui7"]="1" end; end);
WOWTR_CheckButton50.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton46.CheckBox, "TOPLEFT", 0, -28);
WOWTR_CheckButton50:SetWidth(150);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton50:SetPoint("TOPLEFT", WOWTR_CheckButton46.CheckBox, "TOPLEFT", -78, -30);
   WOWTR_CheckButton50:SetWidth(80);
else
   WOWTR_CheckButton50:SetPoint("TOPLEFT", WOWTR_CheckButton46.CheckBox, "TOPLEFT", 40, -30);
end
WOWTR_CheckButton50.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI7).."|r");   -- Display translation of user interface (Group Finder)
WOWTR_CheckButton50.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton50:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI7).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft1"):SetWidth(150);
   if (WoWTR_Localization.lang == 'AR') then
      getglobal("GameTooltipTextLeft1"):SetJustifyH("RIGHT");
   end
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationUI7DESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton50:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
   
local WOWTR_CheckButton47 = CreateFrame("CheckButton", "WOWTR_CheckButton47", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton47.CheckBox:SetScript("OnClick", function(self) if (TT_PS["ui4"]=="1") then TT_PS["ui4"]="0" else TT_PS["ui4"]="1" end; end);
WOWTR_CheckButton47:SetWidth(100);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton47.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header3, "TOPLEFT", -100, -45);
   WOWTR_CheckButton47:SetPoint("TOPLEFT", WOWTR_Panel4Header3, "TOPLEFT", -175, -47);
   WOWTR_CheckButton47:SetWidth(77);
else
   WOWTR_CheckButton47.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header3, "TOPLEFT", 230, -45);
   WOWTR_CheckButton47:SetPoint("TOPLEFT", WOWTR_Panel4Header3, "TOPLEFT", 270, -47);
end
WOWTR_CheckButton47.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI4).."|r");   -- Display translation of user interface (Collections Frame)
WOWTR_CheckButton47.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton47:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI4).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft1"):SetWidth(150);
   if (WoWTR_Localization.lang == 'AR') then
      getglobal("GameTooltipTextLeft1"):SetJustifyH("RIGHT");
   end
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationUI4DESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton47:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton48 = CreateFrame("CheckButton", "WOWTR_CheckButton48", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton48.CheckBox:SetScript("OnClick", function(self) if (TT_PS["ui5"]=="1") then TT_PS["ui5"]="0" else TT_PS["ui5"]="1" end; end);
WOWTR_CheckButton48.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton47.CheckBox, "TOPLEFT", 0, -28);
WOWTR_CheckButton48:SetWidth(150);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton48:SetPoint("TOPLEFT", WOWTR_CheckButton47.CheckBox, "TOPLEFT", -95, -30);
   WOWTR_CheckButton48:SetWidth(97);
else
   WOWTR_CheckButton48:SetPoint("TOPLEFT", WOWTR_CheckButton47.CheckBox, "TOPLEFT", 40, -30);
end
WOWTR_CheckButton48.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI5).."|r");   -- Display translation of user interface (Advanture Guide)
WOWTR_CheckButton48.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton48:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI5).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft1"):SetWidth(150);
   if (WoWTR_Localization.lang == 'AR') then
      getglobal("GameTooltipTextLeft1"):SetJustifyH("RIGHT");
   end
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationUI5DESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton48:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton49 = CreateFrame("CheckButton", "WOWTR_CheckButton49", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton49.CheckBox:SetScript("OnClick", function(self) if (TT_PS["ui6"]=="1") then TT_PS["ui6"]="0" else TT_PS["ui6"]="1" end; end);
WOWTR_CheckButton49.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton48.CheckBox, "TOPLEFT", 0, -28);
WOWTR_CheckButton49:SetWidth(150);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton49:SetPoint("TOPLEFT", WOWTR_CheckButton48.CheckBox, "TOPLEFT", -92, -30);
   WOWTR_CheckButton49:SetWidth(94);
else
   WOWTR_CheckButton49:SetPoint("TOPLEFT", WOWTR_CheckButton48.CheckBox, "TOPLEFT", 40, -30);
end
WOWTR_CheckButton49.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI6).."|r");   -- Display translation of user interface (Friend List)
WOWTR_CheckButton49.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton49:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI6).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft1"):SetWidth(150);
   if (WoWTR_Localization.lang == 'AR') then
      getglobal("GameTooltipTextLeft1"):SetJustifyH("RIGHT");
   end
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationUI6DESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton49:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
   
local WOWTR_CheckButton40 = CreateFrame("CheckButton", "WOWTR_CheckButton40", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton40.CheckBox:SetScript("OnClick", function(self) if (TT_PS["ui8"]=="1") then TT_PS["ui8"]="0" else TT_PS["ui8"]="1" end; end);
WOWTR_CheckButton40.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton49.CheckBox, "TOPLEFT", 0, -28);
WOWTR_CheckButton40:SetWidth(150);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton40:SetPoint("TOPLEFT", WOWTR_CheckButton49.CheckBox, "TOPLEFT", -143, -30);
   WOWTR_CheckButton40:SetWidth(144);
else
   WOWTR_CheckButton40:SetPoint("TOPLEFT", WOWTR_CheckButton49.CheckBox, "TOPLEFT", 40, -30);
end
WOWTR_CheckButton40.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI8).."|r");   -- Display translation of user interface (Friend List)
WOWTR_CheckButton40.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton40:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationUI8).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft1"):SetWidth(150);
   if (WoWTR_Localization.lang == 'AR') then
      getglobal("GameTooltipTextLeft1"):SetJustifyH("RIGHT");
   end
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationUI8DESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton40:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

WOWTR_ReloadButtonUI = CreateFrame("BUTTON", nil, WOWTR_OptionPanel4, "UIPanelButtonTemplate");
WOWTR_ReloadButtonUI:SetWidth(350);
WOWTR_ReloadButtonUI:SetHeight(32);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_ReloadButtonUI:CreateFontString();
   fo:SetFont(WOWTR_Font2, 13);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.ReloadButtonUI));
   WOWTR_ReloadButtonUI:SetFontString(fo);
end
WOWTR_ReloadButtonUI:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.ReloadButtonUI));     -- Przywróć ustawienia domyślne dodatku
WOWTR_ReloadButtonUI:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_ReloadButtonUI:SetPoint("TOPLEFT", WOWTR_CheckButton46.CheckBox, "TOPLEFT", -320, -60);
else
   WOWTR_ReloadButtonUI:SetPoint("TOPLEFT", WOWTR_CheckButton46.CheckBox, "TOPLEFT", 0, -60);
end
WOWTR_ReloadButtonUI:Hide();
WOWTR_ReloadButtonUI:SetScript("OnClick", function() ReloadUI() end);
WOWTR_CheckButton40.CheckBox:HookScript("OnClick", function() WOWTR_ReloadButtonUI:Show(); end);
WOWTR_CheckButton43.CheckBox:HookScript("OnClick", function() WOWTR_ReloadButtonUI:Show(); end);
WOWTR_CheckButton45.CheckBox:HookScript("OnClick", function() WOWTR_ReloadButtonUI:Show(); end);
WOWTR_CheckButton46.CheckBox:HookScript("OnClick", function() WOWTR_ReloadButtonUI:Show(); end);
WOWTR_CheckButton47.CheckBox:HookScript("OnClick", function() WOWTR_ReloadButtonUI:Show(); end);
WOWTR_CheckButton48.CheckBox:HookScript("OnClick", function() WOWTR_ReloadButtonUI:Show(); end);
WOWTR_CheckButton49.CheckBox:HookScript("OnClick", function() WOWTR_ReloadButtonUI:Show(); end);
WOWTR_CheckButton50.CheckBox:HookScript("OnClick", function() WOWTR_ReloadButtonUI:Show(); end);
  
local WOWTR_Panel4Header4 = WOWTR_OptionPanel4:CreateFontString(nil, "ARTWORK");
WOWTR_Panel4Header4:SetFontObject(GameFontNormal);
WOWTR_Panel4Header4:SetJustifyH("LEFT"); 
WOWTR_Panel4Header4:SetJustifyV("TOP");
WOWTR_Panel4Header4:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel4Header4:SetPoint("TOPLEFT", WOWTR_Panel4Separator, "TOPLEFT", 470, -220);
else
   WOWTR_Panel4Header4:SetPoint("TOPLEFT", WOWTR_Panel4Separator, "TOPLEFT", 0, -220);
end
WOWTR_Panel4Header4:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.savingTranslationUI));   -- Saving untranslated user interface
WOWTR_Panel4Header4:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton44 = CreateFrame("CheckButton", "WOWTR_CheckButton44", WOWTR_OptionPanel4, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton44.CheckBox:SetScript("OnClick", function(self) if (TT_PS["saveui"]=="1") then TT_PS["saveui"]="0" else TT_PS["saveui"]="1" end; end);
WOWTR_CheckButton44:SetWidth(350);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton44.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header4, "TOPLEFT", 145, -20);
   WOWTR_CheckButton44:SetPoint("TOPLEFT", WOWTR_Panel4Header4, "TOPLEFT", -112, -22);
   WOWTR_CheckButton44:SetWidth(260);
else
   WOWTR_CheckButton44.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel4Header4, "TOPLEFT", 10, -20);
   WOWTR_CheckButton44:SetPoint("TOPLEFT", WOWTR_Panel4Header4, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton44.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.saveTranslationUI).."|r");   -- Save untranslated user interface
WOWTR_CheckButton44.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton44:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.saveTranslationUI).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.saveTranslationUIDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton44:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

WOWTR_ResetButton2 = CreateFrame("BUTTON", nil, WOWTR_OptionPanel4, "UIPanelButtonTemplate");
WOWTR_ResetButton2:SetWidth(204);
WOWTR_ResetButton2:SetHeight(40);
if (WoWTR_Localization.lang == 'AR') then
   local fo = WOWTR_ResetButton2:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(WoWTR_Localization.resetButton2);
   WOWTR_ResetButton2:SetFontString(fo);
end
WOWTR_ResetButton2:SetText(QTR_ReverseIfAR(WoWTR_Localization.resetButton2));     -- Przywróć ustawienia domyślne dodatku
WOWTR_ResetButton2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_ResetButton2:SetPoint("TOPLEFT", WOWTR_Panel4Header1, "TOPLEFT", -435, -450);
else
   WOWTR_ResetButton2:SetPoint("TOPLEFT", WOWTR_Panel4Header1, "TOPLEFT", 449, -450);
end
WOWTR_ResetButton2:Show();
WOWTR_ResetButton2:SetScript("OnClick", function() WOWTR_Confirmation1:Hide(); WOWTR_Confirmation2:Show(); end);
WOWTR_ResetButton2:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Localization.resetButton2Opis).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Localization.resetButton2OpisDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   --Show the tooltip
   end);
WOWTR_ResetButton2:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   --Hide the tooltip
   end);

----- TAB 5

local WOWTR_OptionsHeaderIcon6 = WOWTR_OptionPanel5:CreateTexture(nil, "OVERLAY");
WOWTR_OptionsHeaderIcon6:SetWidth(200);
WOWTR_OptionsHeaderIcon6:SetHeight(200);
WOWTR_OptionsHeaderIcon6:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\books_mini.jpg");   -- WOWTR_OptionPanel5 thumbnail
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderIcon6:SetPoint("CENTER", -230, 150);
else
   WOWTR_OptionsHeaderIcon6:SetPoint("CENTER", 230, 150);
end

local WOWTR_Panel5Header1 = WOWTR_OptionPanel5:CreateFontString(nil, "ARTWORK");
WOWTR_Panel5Header1:SetFontObject(GameFontNormal);
WOWTR_Panel5Header1:SetJustifyH("LEFT"); 
WOWTR_Panel5Header1:SetJustifyV("TOP");
WOWTR_Panel5Header1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel5Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel5, "TOPLEFT", 525, -25);
else
   WOWTR_Panel5Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel5, "TOPLEFT", 20, -25);
end
WOWTR_Panel5Header1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.generalMainHeaderBT));     -- Books translations
WOWTR_Panel5Header1:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton51 = CreateFrame("CheckButton", "WOWTR_CheckButton51", WOWTR_OptionPanel5, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton51.CheckBox:SetScript("OnClick", function(self) if (BT_PM["active"]=="1") then BT_PM["active"]="0" else BT_PM["active"]="1" end; end);
WOWTR_CheckButton51:SetWidth(207);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton51.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel5Header1, "TOPLEFT", 110, -20);
   WOWTR_CheckButton51:SetPoint("TOPLEFT", WOWTR_Panel5Header1, "TOPLEFT", -20, -22);
   WOWTR_CheckButton51:SetWidth(132);
else
   WOWTR_CheckButton51.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel5Header1, "TOPLEFT", 10, -20);
   WOWTR_CheckButton51:SetPoint("TOPLEFT", WOWTR_Panel5Header1, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton51.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.activateBooksTranslations).."|r");   -- Activate subtitle translations
WOWTR_CheckButton51.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton51:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.activateBooksTranslations).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.activateBooksTranslationsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton51:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
   
local WOWTR_CheckButton52 = CreateFrame("CheckButton", "WOWTR_CheckButton52", WOWTR_OptionPanel5, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton52.CheckBox:SetScript("OnClick", function(self) if (BT_PM["title"]=="1") then BT_PM["title"]="0" else BT_PM["title"]="1";BB_PM["chat-tr"]="0";WOWTR_CheckButton23:SetValue(false); end; end);
WOWTR_CheckButton52.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton51.CheckBox, "BOTTOMLEFT", 0, -20);
WOWTR_CheckButton52:SetWidth(250);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton52:SetPoint("TOPLEFT", WOWTR_CheckButton51.CheckBox, "BOTTOMLEFT", -170, -22);
   WOWTR_CheckButton52:SetWidth(172);
else
   WOWTR_CheckButton52:SetPoint("TOPLEFT", WOWTR_CheckButton51.CheckBox, "BOTTOMLEFT", 40, -22);
end
WOWTR_CheckButton52.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateBookTitles).."|r");   -- translate book tltles
WOWTR_CheckButton52.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton52:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateBookTitles).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateBookTitlesDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton52:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton53 = CreateFrame("CheckButton", "WOWTR_CheckButton53", WOWTR_OptionPanel5, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton53.CheckBox:SetScript("OnClick", function(self) if (BT_PM["showID"]=="1") then BT_PM["showID"]="0" else BT_PM["showID"]="1";BB_PM["chat-en"]="0";WOWTR_CheckButton22:SetValue(false); end; end);
WOWTR_CheckButton53.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton52.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton53:SetWidth(180);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton53:SetPoint("TOPLEFT", WOWTR_CheckButton52.CheckBox, "BOTTOMLEFT", -123, -2);
   WOWTR_CheckButton53:SetWidth(125);
else
   WOWTR_CheckButton53:SetPoint("TOPLEFT", WOWTR_CheckButton52.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton53.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.showBookID).."|r");   -- Show ID of book
WOWTR_CheckButton53.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton53:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.showBookID).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.showBookIDDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton53:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_Panel5Header2 = WOWTR_OptionPanel5:CreateFontString(nil, "ARTWORK");
WOWTR_Panel5Header2:SetFontObject(GameFontNormal);
WOWTR_Panel5Header2:SetJustifyH("LEFT"); 
WOWTR_Panel5Header2:SetJustifyV("TOP");
WOWTR_Panel5Header2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel5Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel5, "TOPLEFT", 587, -190);
else
   WOWTR_Panel5Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel5, "TOPLEFT", 20, -190);
end
WOWTR_Panel5Header2:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.savingUntranslatedBooks));    -- Saving untranslated books
WOWTR_Panel5Header2:SetFont(WOWTR_Font2, 14);

local WOWTR_CheckButton55 = CreateFrame("CheckButton", "WOWTR_CheckButton55", WOWTR_OptionPanel5, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton55.CheckBox:SetScript("OnClick", function(self) if (BT_PM["saveNW"]=="1") then BT_PM["saveNW"]="0" else BT_PM["saveNW"]="1" end; end);
WOWTR_CheckButton55:SetWidth(220);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton55.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel5Header2, "TOPLEFT", 47, -20);
   WOWTR_CheckButton55:SetPoint("TOPLEFT", WOWTR_Panel5Header2, "TOPLEFT", -110, -22);
   WOWTR_CheckButton55:SetWidth(160);
else
   WOWTR_CheckButton55.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel5Header2, "TOPLEFT", 10, -20);
   WOWTR_CheckButton55:SetPoint("TOPLEFT", WOWTR_Panel5Header2, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton55.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedBooks).."|r");   -- Save untranslated books
WOWTR_CheckButton55.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton55:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedBooks).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.saveUntranslatedBooksDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton55:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_Panel5Header3 = WOWTR_OptionPanel5:CreateFontString(nil, "ARTWORK");
WOWTR_Panel5Header3:SetFontObject(GameFontNormal);
WOWTR_Panel5Header3:SetJustifyH("LEFT"); 
WOWTR_Panel5Header3:SetJustifyV("TOP");
WOWTR_Panel5Header3:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel5Header3:SetPoint("TOPLEFT", WOWTR_OptionPanel5, "TOPLEFT", 605, -270);
else
   WOWTR_Panel5Header3:SetPoint("TOPLEFT", WOWTR_OptionPanel5, "TOPLEFT", 20, -270);
end
WOWTR_Panel5Header3:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.fontSizeHeader));                  -- Font size of books
WOWTR_Panel5Header3:SetFont(WOWTR_Font2, 14);

local WOWTR_CheckButton58 = CreateFrame("CheckButton", "WOWTR_CheckButton58", WOWTR_OptionPanel5, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton58.CheckBox:SetScript("OnClick", function(self) if (BT_PM["setsize"]=="1") then BT_PM["setsize"]="0" else BT_PM["setsize"]="1" end; end);
WOWTR_CheckButton58:SetWidth(235);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton58.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel5Header3, "TOPLEFT", 30, -20);
   WOWTR_CheckButton58:SetPoint("TOPLEFT", WOWTR_Panel5Header3, "TOPLEFT", -115, -22);
   WOWTR_CheckButton58:SetWidth(147);
else
   WOWTR_CheckButton58.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel5Header3, "TOPLEFT", 10, -20);
   WOWTR_CheckButton58:SetPoint("TOPLEFT", WOWTR_Panel5Header3, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton58.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.setFontActivate).."|r");   -- Activate font size changes
WOWTR_CheckButton58.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton58:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.setFontActivate).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.setFontActivateDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton58:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_slider2 = CreateFrame("Slider", "WOWTR_slider2", WOWTR_OptionPanel5, "OptionsSliderTemplate");
WOWTR_slider2:SetPoint("TOPLEFT", WOWTR_CheckButton58, "BOTTOMLEFT", 20, -30);
WOWTR_slider2:SetMinMaxValues(10, 20);
WOWTR_slider2.minValue, WOWTR_slider2.maxValue = WOWTR_slider2:GetMinMaxValues();
WOWTR_slider2.Low:SetText(WOWTR_slider2.minValue);
WOWTR_slider2.High:SetText(WOWTR_slider2.maxValue);
getglobal(WOWTR_slider2:GetName() .. 'Text'):SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.fontsizeBubbles));
getglobal(WOWTR_slider2:GetName() .. 'Text'):SetFont(WOWTR_Font2, 11);
WOWTR_slider2:SetValue(tonumber(BT_PM["fontsize"]));
WOWTR_slider2:SetValueStep(1);
WOWTR_slider2:SetScript("OnValueChanged", function(self,event,arg1) 
                                      BT_PM["fontsize"]=string.format("%d",event); 
                                      WOWTR_sliderVal2:SetText(BT_PM["fontsize"]);
                                      WOWTR_Opis2:SetFont(WOWTR_Font2, event);
                                      end);
WOWTR_sliderVal2 = WOWTR_OptionPanel5:CreateFontString(nil, "ARTWORK");
WOWTR_sliderVal2:SetFontObject(GameFontNormal);
WOWTR_sliderVal2:SetJustifyH("CENTER");
WOWTR_sliderVal2:SetJustifyV("TOP");
WOWTR_sliderVal2:ClearAllPoints();
WOWTR_sliderVal2:SetPoint("CENTER", WOWTR_slider2, "CENTER", 0, -12);
WOWTR_sliderVal2:SetText(BT_PM["fontsize"]);   
WOWTR_sliderVal2:SetFont(WOWTR_Font2, 13);

WOWTR_Opis2 = WOWTR_OptionPanel5:CreateFontString(nil, "ARTWORK");
WOWTR_Opis2:SetFontObject(GameFontNormalLarge);
WOWTR_Opis2:SetJustifyH("LEFT");
WOWTR_Opis2:SetJustifyV("TOP");
WOWTR_Opis2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Opis2:SetPoint("TOPLEFT", WOWTR_slider2, "BOTTOMLEFT", -230, 30);
else
   WOWTR_Opis2:SetPoint("TOPLEFT", WOWTR_slider2, "BOTTOMLEFT", 200, 30);
end
local fontsize = tonumber(BT_PM["fontsize"]);
if (BT_PM["setsize"]=="1") then
   WOWTR_Opis2:SetFont(WOWTR_Font2, fontsize);
else
   WOWTR_Opis2:SetFont(WOWTR_Font2, 13);
end
WOWTR_Opis2:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.sampleText));

----- TAB 6

local WOWTR_OptionsHeaderIcon7 = WOWTR_OptionPanel6:CreateTexture(nil, "OVERLAY");
WOWTR_OptionsHeaderIcon7:SetWidth(200);
WOWTR_OptionsHeaderIcon7:SetHeight(200);
WOWTR_OptionsHeaderIcon7:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\tooltips_mini.jpg");   -- WOWTR_OptionPanel6 thumbnail
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_OptionsHeaderIcon7:SetPoint("CENTER", -230, 150);
else
   WOWTR_OptionsHeaderIcon7:SetPoint("CENTER", 230, 150);
end

local WOWTR_Panel6Header1 = WOWTR_OptionPanel6:CreateFontString(nil, "ARTWORK");
WOWTR_Panel6Header1:SetFontObject(GameFontNormal);
WOWTR_Panel6Header1:SetJustifyH("LEFT"); 
WOWTR_Panel6Header1:SetJustifyV("TOP");
WOWTR_Panel6Header1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel6Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel6, "TOPLEFT", 492, -25);
else
   WOWTR_Panel6Header1:SetPoint("TOPLEFT", WOWTR_OptionPanel6, "TOPLEFT", 20, -25);
end
WOWTR_Panel6Header1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.generalMainHeaderST));     -- Tooltips translations
WOWTR_Panel6Header1:SetFont(WOWTR_Font2, 15);

local WOWTR_CheckButton61 = CreateFrame("CheckButton", "WOWTR_CheckButton61", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton61.CheckBox:SetScript("OnClick", function(self) if (ST_PM["active"]=="1") then ST_PM["active"]="0" else ST_PM["active"]="1" end; end);
WOWTR_CheckButton61:SetWidth(244);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton61.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel6Header1, "TOPLEFT", 143, -20);
   WOWTR_CheckButton61:SetPoint("TOPLEFT", WOWTR_Panel6Header1, "TOPLEFT", -10, -22);
   WOWTR_CheckButton61:SetWidth(153);
else
   WOWTR_CheckButton61.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel6Header1, "TOPLEFT", 10, -20);
   WOWTR_CheckButton61:SetPoint("TOPLEFT", WOWTR_Panel6Header1, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton61.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.activateTooltipTranslations).."|r");   -- Activate tooltip translations
WOWTR_CheckButton61.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton61:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.activateTooltipTranslations).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.activateTooltipTranslationsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton61:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);

local WOWTR_CheckButton62 = CreateFrame("CheckButton", "WOWTR_CheckButton62", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton62.CheckBox:SetScript("OnClick", function(self) if (ST_PM["item"]=="1") then ST_PM["item"]="0" else ST_PM["item"]="1" end; end);
WOWTR_CheckButton62.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton61.CheckBox, "BOTTOMLEFT", 0, -20);
WOWTR_CheckButton62:SetWidth(318);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton62:SetPoint("TOPLEFT", WOWTR_CheckButton61.CheckBox, "BOTTOMLEFT", -210, -22);
   WOWTR_CheckButton62:SetWidth(210);
else
   WOWTR_CheckButton62:SetPoint("TOPLEFT", WOWTR_CheckButton61.CheckBox, "BOTTOMLEFT", 40, -22);
end
WOWTR_CheckButton62.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateItems).."|r");   -- Display translated tooltips for items
WOWTR_CheckButton62.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton62:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateItems).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateItemsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton62:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton63 = CreateFrame("CheckButton", "WOWTR_CheckButton63", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton63.CheckBox:SetScript("OnClick", function(self) if (ST_PM["spell"]=="1") then ST_PM["spell"]="0" else ST_PM["spell"]="1" end; end);
WOWTR_CheckButton63.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton62.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton63:SetWidth(320);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton63:SetPoint("TOPLEFT", WOWTR_CheckButton62.CheckBox, "BOTTOMLEFT", -205, -2);
   WOWTR_CheckButton63:SetWidth(205);
else
   WOWTR_CheckButton63:SetPoint("TOPLEFT", WOWTR_CheckButton62.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton63.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateSpells).."|r");   -- Display translated tooltips for spells
WOWTR_CheckButton63.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton63:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateSpells).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateSpellsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton63:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton64 = CreateFrame("CheckButton", "WOWTR_CheckButton64", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton64.CheckBox:SetScript("OnClick", function(self) if (ST_PM["talent"]=="1") then ST_PM["talent"]="0" else ST_PM["talent"]="1" end; end);
WOWTR_CheckButton64.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton63.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton64:SetWidth(347);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton64:SetPoint("TOPLEFT", WOWTR_CheckButton63.CheckBox, "BOTTOMLEFT", -210, -2);
   WOWTR_CheckButton64:SetWidth(210);
else
   WOWTR_CheckButton64:SetPoint("TOPLEFT", WOWTR_CheckButton63.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton64.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateTalents).."|r");   -- Display translated tooltips for talents
WOWTR_CheckButton64.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton64:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateTalents).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateTalentsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton64:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
if (ST_TooltipsID) then
   local WOWTR_CheckButton6A = CreateFrame("CheckButton", "WOWTR_CheckButton6A", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
   WOWTR_CheckButton6A.CheckBox:SetScript("OnClick", function(self) if (ST_PM["transtitle"]=="1") then ST_PM["transtitle"]="0" else ST_PM["transtitle"]="1" end; end);
   WOWTR_CheckButton6A.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton64.CheckBox, "BOTTOMLEFT", 0, 0);
   WOWTR_CheckButton6A:SetWidth(400);
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_CheckButton6A:SetPoint("TOPLEFT", WOWTR_CheckButton64.CheckBox, "BOTTOMLEFT", -297, -2);
      WOWTR_CheckButton6A:SetWidth(300);
   else
      WOWTR_CheckButton6A:SetPoint("TOPLEFT", WOWTR_CheckButton64.CheckBox, "BOTTOMLEFT", 40, -2);
   end
   WOWTR_CheckButton6A.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.translateTooltipTitle).."|r");   -- Display translated title of tooltips
   WOWTR_CheckButton6A.Text:SetFont(WOWTR_Font2, 15);
   WOWTR_CheckButton6A:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.translateTooltipTitle).." ", false);               -- red color, no wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.translateTooltipTitleDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show()   -- Show the tooltip
      end);
   WOWTR_CheckButton6A:SetScript("OnLeave", function(self)
      GameTooltip:Hide()   -- Hide the tooltip
      end);
end
 
local WOWTR_CheckButton65 = CreateFrame("CheckButton", "WOWTR_CheckButton65", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton65.CheckBox:SetScript("OnClick", function(self) if (ST_PM["showID"]=="1") then ST_PM["showID"]="0" else ST_PM["showID"]="1" end; end);
WOWTR_CheckButton65.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton64.CheckBox, "BOTTOMLEFT", 0, -28);
WOWTR_CheckButton65:SetWidth(220);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton65:SetPoint("TOPLEFT", WOWTR_CheckButton64.CheckBox, "BOTTOMLEFT", -125, -30);
   WOWTR_CheckButton65:SetWidth(127);
else
   WOWTR_CheckButton65:SetPoint("TOPLEFT", WOWTR_CheckButton64.CheckBox, "BOTTOMLEFT", 40, -30);
end
WOWTR_CheckButton65.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.showTooltipID).."|r");   -- Display tooltips ID
WOWTR_CheckButton65.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton65:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.showTooltipID).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.showTooltipIDDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   -- Show the tooltip
   end);
WOWTR_CheckButton65:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   -- Hide the tooltip
   end);
 
local WOWTR_CheckButton66 = CreateFrame("CheckButton", "WOWTR_CheckButton66", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton66.CheckBox:SetScript("OnClick", function(self) if (ST_PM["showHS"]=="1") then ST_PM["showHS"]="0" else ST_PM["showHS"]="1" end; end);
WOWTR_CheckButton66.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton65.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton66:SetWidth(205);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton66:SetPoint("TOPLEFT", WOWTR_CheckButton65.CheckBox, "BOTTOMLEFT", -115, -2);
   WOWTR_CheckButton66:SetWidth(118);
else
   WOWTR_CheckButton66:SetPoint("TOPLEFT", WOWTR_CheckButton65.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton66.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.showTooltipHash).."|r");   -- Display tooltips Hash
WOWTR_CheckButton66.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton66:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.showTooltipHash).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.showTooltipHashDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   --Show the tooltip
   end);
WOWTR_CheckButton66:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   --Hide the tooltip
   end);
 
local WOWTR_CheckButton67 = CreateFrame("CheckButton", "WOWTR_CheckButton67", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton67.CheckBox:SetScript("OnClick", function(self) if (ST_PM["sellprice"]=="1") then ST_PM["sellprice"]="0" else ST_PM["sellprice"]="1" end; end);
WOWTR_CheckButton67.CheckBox:SetPoint("TOPLEFT", WOWTR_CheckButton66.CheckBox, "BOTTOMLEFT", 0, 0);
WOWTR_CheckButton67:SetWidth(220);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton67:SetPoint("TOPLEFT", WOWTR_CheckButton66.CheckBox, "BOTTOMLEFT", -155, -2);
   WOWTR_CheckButton67:SetWidth(157);
else
   WOWTR_CheckButton67:SetPoint("TOPLEFT", WOWTR_CheckButton66.CheckBox, "BOTTOMLEFT", 40, -2);
end
WOWTR_CheckButton67.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.hideSellPrice).."|r");   -- Hide sell price
WOWTR_CheckButton67.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton67:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.hideSellPrice).." ", false);                -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.hideSellPriceDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   --Show the tooltip
   end);
WOWTR_CheckButton67:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   --Hide the tooltip
   end);
 
local WOWTR_Panel6Header2 = WOWTR_OptionPanel6:CreateFontString(nil, "ARTWORK");
WOWTR_Panel6Header2:SetFontObject(GameFontNormal);
WOWTR_Panel6Header2:SetJustifyH("LEFT"); 
WOWTR_Panel6Header2:SetJustifyV("TOP");
WOWTR_Panel6Header2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel6Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel6, "TOPLEFT", 560, -330);
else
   WOWTR_Panel6Header2:SetPoint("TOPLEFT", WOWTR_OptionPanel6, "TOPLEFT", 20, -330);
end
WOWTR_Panel6Header2:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.timerHoldTranslation));   -- Select a translation hold time
WOWTR_Panel6Header2:SetFont(WOWTR_Font2, 14);

local WOWTR_CheckButton68 = CreateFrame("CheckButton", "WOWTR_CheckButton68", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton68.CheckBox:SetScript("OnClick", function(self) if (ST_PM["constantly"]=="1") then ST_PM["constantly"]="0" else ST_PM["constantly"]="1" end; end);
WOWTR_CheckButton68:SetWidth(220);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton68.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel6Header2, "TOPLEFT", 75, -20);
   WOWTR_CheckButton68:SetPoint("TOPLEFT", WOWTR_Panel6Header2, "TOPLEFT", -93, -22);
   WOWTR_CheckButton68:SetWidth(168);
else
   WOWTR_CheckButton68.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel6Header2, "TOPLEFT", 10, -20);
   WOWTR_CheckButton68:SetPoint("TOPLEFT", WOWTR_Panel6Header2, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton68.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationConstantly).."|r");   -- Display translation constantly
WOWTR_CheckButton68.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton68:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.displayTranslationConstantly).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.displayTranslationConstantlyDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   --Show the tooltip
   end);
WOWTR_CheckButton68:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   --Hide the tooltip
   end);
 
local WOWTR_slider3 = CreateFrame("Slider", "WOWTR_slider3", WOWTR_OptionPanel6, "OptionsSliderTemplate");
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_slider3:SetPoint("TOPLEFT", WOWTR_CheckButton68, "BOTTOMLEFT", 50, -30);
else
   WOWTR_slider3:SetPoint("TOPLEFT", WOWTR_CheckButton68, "BOTTOMLEFT", 5, -30);
end
WOWTR_slider3:SetMinMaxValues(5, 30);
WOWTR_slider3.minValue, WOWTR_slider3.maxValue = WOWTR_slider3:GetMinMaxValues();
WOWTR_slider3.Low:SetText(WOWTR_slider3.minValue);
WOWTR_slider3.High:SetText(WOWTR_slider3.maxValue);
getglobal(WOWTR_slider3:GetName() .. 'Text'):SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.timerLimitSeconds));
getglobal(WOWTR_slider3:GetName() .. 'Text'):SetFont(WOWTR_Font2, 11);
WOWTR_slider3:SetValue(tonumber(ST_PM["timer"]));
WOWTR_slider3:SetValueStep(1);
WOWTR_slider3:SetScript("OnValueChanged", function(self,event,arg1) 
                                      ST_PM["timer"]=string.format("%d",event); 
                                      WOWTR_sliderVal3:SetText(ST_PM["timer"]);
                                      end);
WOWTR_sliderVal3 = WOWTR_OptionPanel6:CreateFontString(nil, "ARTWORK");
WOWTR_sliderVal3:SetFontObject(GameFontNormal);
WOWTR_sliderVal3:SetJustifyH("CENTER");
WOWTR_sliderVal3:SetJustifyV("TOP");
WOWTR_sliderVal3:ClearAllPoints();
WOWTR_sliderVal3:SetPoint("CENTER", WOWTR_slider3, "CENTER", 0, -12);
WOWTR_sliderVal3:SetText(ST_PM["timer"]);   
WOWTR_sliderVal3:SetFont(WOWTR_Font2, 13);

local WOWTR_Panel6Header3 = WOWTR_OptionPanel6:CreateFontString(nil, "ARTWORK");
WOWTR_Panel6Header3:SetFontObject(GameFontNormal);
WOWTR_Panel6Header3:SetJustifyH("LEFT"); 
WOWTR_Panel6Header3:SetJustifyV("TOP");
WOWTR_Panel6Header3:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel6Header3:SetPoint("TOPLEFT", WOWTR_OptionPanel6, "TOPLEFT", 587, -460);
else
   WOWTR_Panel6Header3:SetPoint("TOPLEFT", WOWTR_OptionPanel6, "TOPLEFT", 20, -460);
end
WOWTR_Panel6Header3:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.savingUntranslatedTooltips));   -- Saving untranslated tooltips
WOWTR_Panel6Header3:SetFont(WOWTR_Font2, 14);

local WOWTR_CheckButton69 = CreateFrame("CheckButton", "WOWTR_CheckButton69", WOWTR_OptionPanel6, "SettingsCheckBoxControlTemplate");
WOWTR_CheckButton69.CheckBox:SetScript("OnClick", function(self) if (ST_PM["saveNW"]=="1") then ST_PM["saveNW"]="0" else ST_PM["saveNW"]="1" end; end);
WOWTR_CheckButton69:SetWidth(230);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_CheckButton69.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel6Header3, "TOPLEFT", 45, -20);
   WOWTR_CheckButton69:SetPoint("TOPLEFT", WOWTR_Panel6Header3, "TOPLEFT", -135, -22);
   WOWTR_CheckButton69:SetWidth(180);
else
   WOWTR_CheckButton69.CheckBox:SetPoint("TOPLEFT", WOWTR_Panel6Header3, "TOPLEFT", 10, -20);
   WOWTR_CheckButton69:SetPoint("TOPLEFT", WOWTR_Panel6Header3, "TOPLEFT", 50, -22);
end
WOWTR_CheckButton69.Text:SetText("|cffffffff"..QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedTooltips).."|r");   -- Save untranslated tooltips
WOWTR_CheckButton69.Text:SetFont(WOWTR_Font2, 15);
WOWTR_CheckButton69:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.saveUntranslatedTooltips).." ", false);                -- red color, no wrap
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Config_Interface.saveUntranslatedTooltipsDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   --Show the tooltip
   end);
WOWTR_CheckButton69:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   --Hide the tooltip
   end);

----- TAB 9

local WOWTR_Panel9Text = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Text:SetFontObject(GameFontWhite);
WOWTR_Panel9Text:SetJustifyH("LEFT"); 
WOWTR_Panel9Text:SetJustifyV("TOP");
WOWTR_Panel9Text:ClearAllPoints();
WOWTR_Panel9Text:SetPoint("TOPLEFT", WOWTR_OptionPanel9, "TOPLEFT", 25, -10);
WOWTR_Panel9Text:SetWidth(640);
WOWTR_Panel9Text:SetFont(WOWTR_Font2, 14);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Text:SetText(QTR_ExpandUnitInfo(WoWTR_Config_Interface.generalText,false,WOWTR_Panel9Text,WOWTR_Font2,-50));        -- generalText
else
   WOWTR_Panel9Text:SetText(QTR_ExpandUnitInfo(WoWTR_Config_Interface.generalText,false,WOWTR_Panel9Text,WOWTR_Font2,-50));        -- generalText
end

local WOWTR_Panel9Header1 = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Header1:SetFontObject(GameFontNormal);
WOWTR_Panel9Header1:SetJustifyH("LEFT"); 
WOWTR_Panel9Header1:SetJustifyV("TOP");
WOWTR_Panel9Header1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Header1:SetPoint("TOPLEFT", WOWTR_Panel9Text, "BOTTOMLEFT", 540, -70);
else
   WOWTR_Panel9Header1:SetPoint("TOPLEFT", WOWTR_Panel9Text, "BOTTOMLEFT", -10, -25);
end
WOWTR_Panel9Header1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.authorHeader));     -- Author info
WOWTR_Panel9Header1:SetFont(WOWTR_Font2, 15);

local WOWTR_Panel9Author1 = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Author1:SetFontObject(GameFontWhite);
WOWTR_Panel9Author1:SetJustifyH("LEFT"); 
WOWTR_Panel9Author1:SetJustifyV("TOP");
WOWTR_Panel9Author1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Author1:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 55, -15);
else
   WOWTR_Panel9Author1:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 20, -15);
end
WOWTR_Panel9Author1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.author));           -- Author:
WOWTR_Panel9Author1:SetFont(WOWTR_Font2, 13);

local WOWTR_Panel9Author2 = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Author2:SetFontObject(GameFontWhite);
WOWTR_Panel9Author2:SetJustifyV("TOP");
WOWTR_Panel9Author2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Author2:SetJustifyH("RIGHT"); 
   WOWTR_Panel9Author2:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", -51, -15);
else
   WOWTR_Panel9Author2:SetJustifyH("LEFT"); 
   WOWTR_Panel9Author2:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 120, -15);
end
WOWTR_Panel9Author2:SetText("Platine");                               -- Platine
WOWTR_Panel9Author2:SetFont(WOWTR_Font2, 13);

local WOWTR_Panel9Email1 = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Email1:SetFontObject(GameFontWhite);
WOWTR_Panel9Email1:SetJustifyH("LEFT"); 
WOWTR_Panel9Email1:SetJustifyV("TOP");
WOWTR_Panel9Email1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Email1:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 12, -35);
else
   WOWTR_Panel9Email1:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 20, -35);
end
WOWTR_Panel9Email1:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.email));             -- E-mail:
WOWTR_Panel9Email1:SetFont(WOWTR_Font2, 13);

local WOWTR_Panel9Email2 = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Email2:SetFontObject(GameFontWhite);
WOWTR_Panel9Email2:SetJustifyH("LEFT"); 
WOWTR_Panel9Email2:SetJustifyV("TOP");
WOWTR_Panel9Email2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Email2:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", -150, -35);
else
   WOWTR_Panel9Email2:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 120, -35);
end
WOWTR_Panel9Email2:SetText("platine.wow@gmail.com");                  -- platine.wow@gmail.com
WOWTR_Panel9Email2:SetFont(WOWTR_Font2, 13);

WOWTR_ResetButton1 = CreateFrame("BUTTON", nil, WOWTR_OptionPanel9, "UIPanelButtonTemplate");
WOWTR_ResetButton1:SetWidth(300);
WOWTR_ResetButton1:SetHeight(32);
if ((WoWTR_Localization.lang == 'AR') or (WoWTR_Localization.lang == 'PL')) then
   local fo = WOWTR_ResetButton1:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Localization.resetButton1));
   WOWTR_ResetButton1:SetFontString(fo);
end
WOWTR_ResetButton1:SetText(QTR_ReverseIfAR(WoWTR_Localization.resetButton1));      -- Wyczyść zapisane nieprzetłumaczone teksty
WOWTR_ResetButton1:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_ResetButton1:SetPoint("BOTTOMRIGHT", WOWTR_Panel9Header1, "TOPRIGHT", 5, 15);
else
   WOWTR_ResetButton1:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "TOPLEFT", 360, 5);
end
WOWTR_ResetButton1:Show();
WOWTR_ResetButton1:SetScript("OnClick", function() WOWTR_Confirmation2:Hide(); WOWTR_Confirmation1:Show(); end);
WOWTR_ResetButton1:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
   GameTooltip:ClearLines();
   GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Localization.resetButton1Opis).." ", false);               -- red color, no wrap
   getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
   GameTooltip:AddLine(QTR_ExpandUnitInfo(WoWTR_Localization.resetButton1OpisDESC,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2).." ", 1, 1, 1, true);   -- white color, wrap
   getglobal("GameTooltipTextLeft2"):SetFont(WOWTR_Font2, 13);
   GameTooltip:Show()   --Show the tooltip
   end);
WOWTR_ResetButton1:SetScript("OnLeave", function(self)
   GameTooltip:Hide()   --Hide the tooltip
   end);

local WOWTR_Panel9Header2 = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Header2:SetFontObject(GameFontNormal);
WOWTR_Panel9Header2:SetJustifyH("LEFT"); 
WOWTR_Panel9Header2:SetJustifyV("TOP");
WOWTR_Panel9Header2:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Header2:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", -28, -75);
else
   WOWTR_Panel9Header2:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 0, -75);
end
WOWTR_Panel9Header2:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.teamHeader));       -- WoWTR project team
WOWTR_Panel9Header2:SetFont(WOWTR_Font2, 15);

local WOWTR_Panel9TextContact = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9TextContact:SetFontObject(GameFontWhite);
WOWTR_Panel9TextContact:SetJustifyH("LEFT"); 
WOWTR_Panel9TextContact:SetJustifyV("TOP");
WOWTR_Panel9TextContact:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9TextContact:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "TOPLEFT", -515, -20);
else
   WOWTR_Panel9TextContact:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "TOPLEFT", 20, -20);
end
WOWTR_Panel9TextContact:SetWidth(640);
WOWTR_Panel9TextContact:SetFont(WOWTR_Font2, 14);
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9TextContact:SetText(QTR_ExpandUnitInfo(WoWTR_Config_Interface.textContact,false,WOWTR_Panel9TextContact,WOWTR_Font2,-40));        -- TextContact
else 
   WOWTR_Panel9TextContact:SetText(QTR_ExpandUnitInfo(WoWTR_Config_Interface.textContact,false,WOWTR_Panel9TextContact,WOWTR_Font2));        -- TextContact
end

WOWTR_LinkFrame = CreateFrame("Frame", nil, WOWTR_OptionPanel9, "UIPanelDialogTemplate");
WOWTR_LinkFrame:SetWidth(305);
WOWTR_LinkFrame:SetHeight(120);
WOWTR_LinkFrame:ClearAllPoints();
WOWTR_LinkFrame:SetPoint("CENTER", 0, 108);
WOWTR_LinkFrame:SetFrameStrata("TOOLTIP");
WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkWWWTitle));       -- Header of the link frame
WOWTR_LinkFrame.Title:SetFont(WOWTR_Font2, 13);
WOWTR_LinkFrame.Input = CreateFrame("EditBox", nil, WOWTR_LinkFrame, "InputBoxTemplate");
WOWTR_LinkFrame.Input:ClearAllPoints();
WOWTR_LinkFrame.Input:SetPoint("TOPLEFT", WOWTR_LinkFrame, "TOPLEFT", 20, -30);
WOWTR_LinkFrame.Input:SetHeight(20);
WOWTR_LinkFrame.Input:SetWidth(275);
WOWTR_LinkFrame.Input:SetAutoFocus(true);
WOWTR_LinkFrame.Input:SetFontObject(GameFontWhite);
WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressWWW);
--WOWTR_LinkFrame.Input:SetCursorPosition(0);
WOWTR_LinkFrame.Text = WOWTR_LinkFrame:CreateFontString(nil, "ARTWORK");
WOWTR_LinkFrame.Text:SetFontObject(GameFontNormal);
WOWTR_LinkFrame.Text:SetJustifyH("CENTER"); 
WOWTR_LinkFrame.Text:SetJustifyV("TOP");
WOWTR_LinkFrame.Text:ClearAllPoints();
WOWTR_LinkFrame.Text:SetPoint("TOPLEFT", WOWTR_LinkFrame, "TOPLEFT", 15, -55);
WOWTR_LinkFrame.Text:SetWidth(280);
WOWTR_LinkFrame.Text:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkCopy));   -- Wciśnij CTRL+C aby skopiować link do schowka Windowsa
WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
WOWTR_LinkFrame.ButtonOK = CreateFrame("Button",nil, WOWTR_LinkFrame, "UIPanelButtonTemplate");
WOWTR_LinkFrame.ButtonOK:SetWidth(150);
WOWTR_LinkFrame.ButtonOK:SetHeight(20);
local fo = WOWTR_LinkFrame.ButtonOK:CreateFontString();
fo:SetFont(WOWTR_Font2, 13);
fo:SetText(QTR_ReverseIfAR(QTR_ReverseIfAR(WoWTR_Config_Interface.linkCloseFrame)));
WOWTR_LinkFrame.ButtonOK:SetFontString(fo);
WOWTR_LinkFrame.ButtonOK:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkCloseFrame));
WOWTR_LinkFrame.ButtonOK:ClearAllPoints();
WOWTR_LinkFrame.ButtonOK:SetPoint("CENTER", 0, -38);
WOWTR_LinkFrame.ButtonOK:Show();
WOWTR_LinkFrame.ButtonOK:SetScript("OnClick", function() WOWTR_LinkFrame:Hide(); end);
WOWTR_LinkFrame:Hide();

local WOW_interSpace = 70;
local WOW_interPlace = 20;
if (string.len(WoWTR_Localization.addressWWW) > 1) then
   local WOWTR_linkButtonWWW = CreateFrame("Button", nil, WOWTR_OptionPanel9)
   WOWTR_linkButtonWWW:SetSize(32, 32);
   if (WoWTR_Localization.lang == 'AR') then
      WOW_interPlace = 0;
      WOWTR_linkButtonWWW:SetPoint("TOPRIGHT", WOWTR_Panel9Header2, "BOTTOMRIGHT", WOW_interPlace, -35);
   else
      WOWTR_linkButtonWWW:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "BOTTOMLEFT", WOW_interPlace, -35);
   end
   WOWTR_linkButtonWWW.icon = WOWTR_linkButtonWWW:CreateTexture()
   WOWTR_linkButtonWWW.icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon_www.png")
   WOWTR_linkButtonWWW.icon:SetSize(32, 32);
   WOWTR_linkButtonWWW.icon:SetPoint("LEFT", 0, 0);

   WOWTR_linkButtonWWW:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.linkWWWShow), 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show() -- Show the tooltip
      getglobal("GameTooltipTextLeft1"):SetText(QTR_ExpandUnitInfo(WoWTR_Config_Interface.linkWWWShow,false,getglobal("GameTooltipTextLeft1"),WOWTR_Font2));   -- white color, wrap
      end);
   WOWTR_linkButtonWWW:SetScript("OnLeave", function(self)
      GameTooltip:Hide() -- Hide the tooltip
      end);
   WOWTR_linkButtonWWW:SetScript("OnClick", function(self)
      WOWTR_LinkFrame:Hide();
      WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkWWWTitle));
      WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressWWW);
      WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
      WOWTR_LinkFrame:Show();
      end);
end

if (string.len(WoWTR_Localization.addressDiscord) > 1) then
   local WOWTR_linkButtonDISC = CreateFrame("Button", nil, WOWTR_OptionPanel9)
   WOWTR_linkButtonDISC:SetSize(64, 32);
   WOW_interPlace = WOW_interPlace + WOW_interSpace;
   if (WoWTR_Localization.lang == 'AR') then
      WOW_interPlace = WOW_interPlace - 40;
      WOWTR_linkButtonDISC:SetPoint("TOPRIGHT", WOWTR_Panel9Header2, "BOTTOMRIGHT", -WOW_interPlace, -35);
      WOW_interPlace = WOW_interPlace + 10;
   else
      WOWTR_linkButtonDISC:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "BOTTOMLEFT", WOW_interPlace, -35);
   end
   WOW_interPlace = WOW_interPlace + 10;
   WOWTR_linkButtonDISC.icon = WOWTR_linkButtonDISC:CreateTexture()
   WOWTR_linkButtonDISC.icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon_discord.png")
   WOWTR_linkButtonDISC.icon:SetSize(64, 32);
   WOWTR_linkButtonDISC.icon:SetPoint("LEFT", 0, 0);

   WOWTR_linkButtonDISC:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.linkDISCShow), 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show() -- Show the tooltip
      end);
   WOWTR_linkButtonDISC:SetScript("OnLeave", function(self)
      GameTooltip:Hide() -- Hide the tooltip
      end);
   WOWTR_linkButtonDISC:SetScript("OnClick", function(self)
      WOWTR_LinkFrame:Hide();
      WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkDISCTitle));
      WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressDiscord);
      WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
      WOWTR_LinkFrame:Show();
      end);
end

if (string.len(WoWTR_Localization.addressTwitch) > 1) then
   local WOWTR_linkButtonTWITCH = CreateFrame("Button", nil, WOWTR_OptionPanel9)
   WOWTR_linkButtonTWITCH:SetSize(32, 32);
   WOW_interPlace = WOW_interPlace + WOW_interSpace;
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_linkButtonTWITCH:SetPoint("TOPRIGHT", WOWTR_Panel9Header2, "BOTTOMRIGHT", -WOW_interPlace, -35);
   else
      WOWTR_linkButtonTWITCH:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "BOTTOMLEFT", WOW_interPlace, -35);
   end
   WOWTR_linkButtonTWITCH.icon = WOWTR_linkButtonTWITCH:CreateTexture()
   WOWTR_linkButtonTWITCH.icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon_twitch.png")
   WOWTR_linkButtonTWITCH.icon:SetSize(32, 32);
   WOWTR_linkButtonTWITCH.icon:SetPoint("LEFT", 0, 0);

   WOWTR_linkButtonTWITCH:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.linkTWITCHShow), 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show() -- Show the tooltip
      end);
   WOWTR_linkButtonTWITCH:SetScript("OnLeave", function(self)
      GameTooltip:Hide() -- Hide the tooltip
      end);
   WOWTR_linkButtonTWITCH:SetScript("OnClick", function(self)
      WOWTR_LinkFrame:Hide();
      WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkTWITCHTitle));
      WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressTwitch);
      WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
      WOWTR_LinkFrame:Show();
      end);
end

if (string.len(WoWTR_Localization.addressFanPage) > 1) then
   local WOWTR_linkButtonFB = CreateFrame("Button", nil, WOWTR_OptionPanel9)
   WOWTR_linkButtonFB:SetSize(32, 32);
   WOW_interPlace = WOW_interPlace + WOW_interSpace;
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_linkButtonFB:SetPoint("TOPRIGHT", WOWTR_Panel9Header2, "BOTTOMRIGHT", -WOW_interPlace, -35);
   else
      WOWTR_linkButtonFB:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "BOTTOMLEFT", WOW_interPlace, -35);
   end
   WOWTR_linkButtonFB.icon = WOWTR_linkButtonFB:CreateTexture()
   WOWTR_linkButtonFB.icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon_fb.png")
   WOWTR_linkButtonFB.icon:SetSize(32, 32);
   WOWTR_linkButtonFB.icon:SetPoint("LEFT", 0, 0);

   WOWTR_linkButtonFB:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.linkFBShow), 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show() -- Show the tooltip
      end);
   WOWTR_linkButtonFB:SetScript("OnLeave", function(self)
      GameTooltip:Hide() -- Hide the tooltip
      end);
   WOWTR_linkButtonFB:SetScript("OnClick", function(self)
      WOWTR_LinkFrame:Hide();
      WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkFBTitle));
      WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressFanPage);
      WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
      WOWTR_LinkFrame:Show();
      end);
end

if (string.len(WoWTR_Localization.addressEmail) > 1) then
   local WOWTR_linkButtonEMAIL = CreateFrame("Button", nil, WOWTR_OptionPanel9)
   WOWTR_linkButtonEMAIL:SetSize(32, 32);
   WOW_interPlace = WOW_interPlace + WOW_interSpace;
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_linkButtonEMAIL:SetPoint("TOPRIGHT", WOWTR_Panel9Header2, "BOTTOMRIGHT", -WOW_interPlace, -35);
   else
      WOWTR_linkButtonEMAIL:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "BOTTOMLEFT", WOW_interPlace, -35);
   end
   WOWTR_linkButtonEMAIL.icon = WOWTR_linkButtonEMAIL:CreateTexture()
   WOWTR_linkButtonEMAIL.icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon_email.png")
   WOWTR_linkButtonEMAIL.icon:SetSize(32, 32);
   WOWTR_linkButtonEMAIL.icon:SetPoint("LEFT", 0, 0);

   WOWTR_linkButtonEMAIL:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.linkEMAILShow), 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show() -- Show the tooltip
      end);
   WOWTR_linkButtonEMAIL:SetScript("OnLeave", function(self)
      GameTooltip:Hide() -- Hide the tooltip
      end);
   WOWTR_linkButtonEMAIL:SetScript("OnClick", function(self)
      WOWTR_LinkFrame:Hide();
      WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkEMAILTitle));
      WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressEmail);
      WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
      WOWTR_LinkFrame:Show();
      end);
end

if (string.len(WoWTR_Localization.addressCurse) > 1) then
   local WOWTR_linkButtonCURSE = CreateFrame("Button", nil, WOWTR_OptionPanel9)
   WOWTR_linkButtonCURSE:SetSize(64, 32);
   WOW_interPlace = WOW_interPlace + WOW_interSpace;
   if (WoWTR_Localization.lang == 'AR') then
      WOW_interPlace = WOW_interPlace - 30;
      WOWTR_linkButtonCURSE:SetPoint("TOPRIGHT", WOWTR_Panel9Header2, "BOTTOMRIGHT", -WOW_interPlace, -35);
      WOW_interPlace = WOW_interPlace + 10;
   else
      WOWTR_linkButtonCURSE:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "BOTTOMLEFT", WOW_interPlace, -35);
   end
   WOW_interPlace = WOW_interPlace + 10;
   WOWTR_linkButtonCURSE.icon = WOWTR_linkButtonCURSE:CreateTexture()
   WOWTR_linkButtonCURSE.icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon_curseforge.png")
   WOWTR_linkButtonCURSE.icon:SetSize(64, 32);
   WOWTR_linkButtonCURSE.icon:SetPoint("LEFT", 0, 0);

   WOWTR_linkButtonCURSE:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.linkCURSEShow), 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show() -- Show the tooltip
      end);
   WOWTR_linkButtonCURSE:SetScript("OnLeave", function(self)
      GameTooltip:Hide() -- Hide the tooltip
      end);
   WOWTR_linkButtonCURSE:SetScript("OnClick", function(self)
      WOWTR_LinkFrame:Hide();
      WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkCURSETitle));
      WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressCurse);
      WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
      WOWTR_LinkFrame:Show();
      end);
end

if (string.len(WoWTR_Localization.addressPayPal) > 1) then
   local WOWTR_linkButtonPP = CreateFrame("Button", nil, WOWTR_OptionPanel9)
   WOWTR_linkButtonPP:SetSize(32, 32);
   WOW_interPlace = WOW_interPlace + WOW_interSpace;
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_linkButtonPP:SetPoint("TOPRIGHT", WOWTR_Panel9Header2, "BOTTOMRIGHT", -WOW_interPlace, -35);
   else
      WOWTR_linkButtonPP:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "BOTTOMLEFT", WOW_interPlace, -35);
   end
   WOWTR_linkButtonPP.icon = WOWTR_linkButtonPP:CreateTexture()
   WOWTR_linkButtonPP.icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon_paypal.png")
   WOWTR_linkButtonPP.icon:SetSize(32, 32);
   WOWTR_linkButtonPP.icon:SetPoint("LEFT", 0, 0);

   WOWTR_linkButtonPP:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.linkPPShow), 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show() -- Show the tooltip
      end);
   WOWTR_linkButtonPP:SetScript("OnLeave", function(self)
      GameTooltip:Hide() -- Hide the tooltip
      end);
   WOWTR_linkButtonPP:SetScript("OnClick", function(self)
      WOWTR_LinkFrame:Hide();
      WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkPPTitle));
      WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressPayPal);
      WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
      WOWTR_LinkFrame:Show();
      end);
end

if (string.len(WoWTR_Localization.addressBlik) > 1) then
   local WOWTR_linkButtonBLIK = CreateFrame("Button", nil, WOWTR_OptionPanel9)
   if (WoWTR_Localization.lang == 'TR') then
      WOWTR_linkButtonBLIK:SetSize(32, 32);
   else
      WOWTR_linkButtonBLIK:SetSize(64, 32);
   end
   WOW_interPlace = WOW_interPlace + WOW_interSpace - 10;
   if (WoWTR_Localization.lang == 'AR') then
      WOWTR_linkButtonBLIK:SetPoint("TOPRIGHT", WOWTR_Panel9Header2, "BOTTOMRIGHT", -WOW_interPlace, -35);
   else
      WOWTR_linkButtonBLIK:SetPoint("TOPLEFT", WOWTR_Panel9Header2, "BOTTOMLEFT", WOW_interPlace, -35);
   end
   WOWTR_linkButtonBLIK.icon = WOWTR_linkButtonBLIK:CreateTexture()
   WOWTR_linkButtonBLIK.icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon_blik.png")
   if (WoWTR_Localization.lang == 'TR') then
      WOWTR_linkButtonBLIK.icon:SetSize(32, 32);
   else
      WOWTR_linkButtonBLIK.icon:SetSize(64, 32);
   end
   WOWTR_linkButtonBLIK.icon:SetPoint("LEFT", 0, 0);

   WOWTR_linkButtonBLIK:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:ClearLines();
      GameTooltip:AddLine(QTR_ReverseIfAR(WoWTR_Config_Interface.linkBLIKShow), 1, 1, 1, true);   -- white color, wrap
      getglobal("GameTooltipTextLeft1"):SetFont(WOWTR_Font2, 13);
      GameTooltip:Show() -- Show the tooltip
      end);
   WOWTR_linkButtonBLIK:SetScript("OnLeave", function(self)
      GameTooltip:Hide() -- Hide the tooltip
      end);
   WOWTR_linkButtonBLIK:SetScript("OnClick", function(self)
      WOWTR_LinkFrame:Hide();
      WOWTR_LinkFrame.Title:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.linkBLIKTitle));
      WOWTR_LinkFrame.Input:SetText(WoWTR_Localization.addressBlik);
      WOWTR_LinkFrame.Text:SetFont(WOWTR_Font2, 12);
      WOWTR_LinkFrame:Show();
      end);
end

local WOWTR_Panel9Header3 = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Header3:SetFontObject(GameFontNormal);
WOWTR_Panel9Header3:SetJustifyH("LEFT"); 
WOWTR_Panel9Header3:SetJustifyV("TOP");
WOWTR_Panel9Header3:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Header3:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 50, -185);
else
   WOWTR_Panel9Header3:SetPoint("TOPLEFT", WOWTR_Panel9Header1, "BOTTOMLEFT", 0, -185);
end
WOWTR_Panel9Header3:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.betaTestersHeader));       -- Beta Testers:
WOWTR_Panel9Header3:SetFont(WOWTR_Font2, 15);

local WOWTR_Panel9Testers = WOWTR_OptionPanel9:CreateFontString(nil, "ARTWORK");
WOWTR_Panel9Testers:SetFontObject(GameFontWhite);
WOWTR_Panel9Testers:SetJustifyH("LEFT"); 
WOWTR_Panel9Testers:SetJustifyV("TOP");
WOWTR_Panel9Testers:ClearAllPoints();
if (WoWTR_Localization.lang == 'AR') then
   WOWTR_Panel9Testers:SetPoint("TOPLEFT", WOWTR_Panel9Header3, "BOTTOMLEFT", 0, -10);
else
   WOWTR_Panel9Testers:SetPoint("TOPLEFT", WOWTR_Panel9Header3, "BOTTOMLEFT", 20, -10);
end
WOWTR_Panel9Testers:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.betaTestersHeaderDESC));
WOWTR_Panel9Testers:SetFont(WOWTR_Font2, 13);

if (string.len(WoWTR_Config_Interface.welcomeText) > 1) then
   local WOWTR_ShowWelcomePanel = CreateFrame("BUTTON", nil, WOWTR_OptionPanel9, "UIPanelButtonTemplate");
   WOWTR_ShowWelcomePanel:SetWidth(200);
   WOWTR_ShowWelcomePanel:SetHeight(20);
   local fo = WOWTR_ShowWelcomePanel:CreateFontString();
   fo:SetFont(WOWTR_Font2, 12);
   fo:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.showWelcome));
   WOWTR_ShowWelcomePanel:SetFontString(fo);
   WOWTR_ShowWelcomePanel:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.showWelcome));
   WOWTR_ShowWelcomePanel:ClearAllPoints();
   WOWTR_ShowWelcomePanel:SetPoint("BOTTOMLEFT", WOWTR_OptionPanel9, "BOTTOMLEFT", 20, 20);
   WOWTR_ShowWelcomePanel:Show();
   WOWTR_ShowWelcomePanel:SetScript("OnClick", function() WOWTR_WelcomePanel(); end);
end

WOWTR_Confirmation1 = CreateFrame("Frame", nil, WOWTR_OptionPanel9, "UIPanelDialogTemplate");
WOWTR_Confirmation1:SetWidth(305);
WOWTR_Confirmation1:SetHeight(120);
WOWTR_Confirmation1:ClearAllPoints();
WOWTR_Confirmation1:SetPoint("BOTTOMLEFT", WOWTR_ResetButton1, "TOPLEFT", -5, 5);
WOWTR_Confirmation1:SetFrameStrata("TOOLTIP");
WOWTR_Confirmation1.Title:SetText(WoWTR_Localization.confirmationHeader);       -- Confirmation Header
WOWTR_Confirmation1.Title:SetFont(WOWTR_Font2, 13);
WOWTR_Confirmation1.Text = WOWTR_Confirmation1:CreateFontString(nil, "ARTWORK");
WOWTR_Confirmation1.Text:SetFontObject(GameFontWhite);
WOWTR_Confirmation1.Text:SetJustifyH("CENTER"); 
WOWTR_Confirmation1.Text:SetJustifyV("TOP");
WOWTR_Confirmation1.Text:ClearAllPoints();
WOWTR_Confirmation1.Text:SetPoint("TOPLEFT", WOWTR_Confirmation1, "TOPLEFT", 20, -40);
WOWTR_Confirmation1.Text:SetWidth(280);
WOWTR_Confirmation1.Text:SetText(QTR_ReverseIfAR(WoWTR_Localization.confirmationText1));   -- Czy chcesz wyczyścić wszystkie zapisane, nieprzetłumaczone teksty?
WOWTR_Confirmation1.Text:SetFont(WOWTR_Font2, 14);
WOWTR_Confirmation1.ButtonYES = CreateFrame("Button",nil, WOWTR_Confirmation1, "UIPanelButtonTemplate");
WOWTR_Confirmation1.ButtonYES:SetWidth(75);
WOWTR_Confirmation1.ButtonYES:SetHeight(20);
local fo = WOWTR_Confirmation1.ButtonYES:CreateFontString();
fo:SetFont(WOWTR_Font2, 13);
fo:SetText(QTR_ReverseIfAR(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieYes)));
WOWTR_Confirmation1.ButtonYES:SetFontString(fo);
WOWTR_Confirmation1.ButtonYES:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieYes));    -- Yes
WOWTR_Confirmation1.ButtonYES:ClearAllPoints();
WOWTR_Confirmation1.ButtonYES:SetPoint("BOTTOMLEFT", WOWTR_Confirmation1, "BOTTOMLEFT", 20, 15);
WOWTR_Confirmation1.ButtonYES:Show();
WOWTR_Confirmation1.ButtonYES:SetScript("OnClick", function() WOWTR_ResetVariables(1); end);
WOWTR_Confirmation1.ButtonNO = CreateFrame("Button",nil, WOWTR_Confirmation1, "UIPanelButtonTemplate");
WOWTR_Confirmation1.ButtonNO:SetWidth(75);
WOWTR_Confirmation1.ButtonNO:SetHeight(20);
local fo = WOWTR_Confirmation1.ButtonNO:CreateFontString();
fo:SetFont(WOWTR_Font2, 13);
fo:SetText(QTR_ReverseIfAR(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieNo)));
WOWTR_Confirmation1.ButtonNO:SetFontString(fo);
WOWTR_Confirmation1.ButtonNO:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieNo));      -- No
WOWTR_Confirmation1.ButtonNO:ClearAllPoints();
WOWTR_Confirmation1.ButtonNO:SetPoint("BOTTOMRIGHT", WOWTR_Confirmation1, "BOTTOMRIGHT", -15, 15);
WOWTR_Confirmation1.ButtonNO:Show();
WOWTR_Confirmation1.ButtonNO:SetScript("OnClick", function() WOWTR_Confirmation1:Hide(); end);
WOWTR_Confirmation1:Hide();

WOWTR_Confirmation2 = CreateFrame("Frame", nil, WOWTR_OptionPanel4, "UIPanelDialogTemplate");
WOWTR_Confirmation2:SetWidth(305);
WOWTR_Confirmation2:SetHeight(120);
WOWTR_Confirmation2:ClearAllPoints();
WOWTR_Confirmation2:SetPoint("BOTTOMLEFT", WOWTR_ResetButton2, "TOPLEFT", -30, 5);
WOWTR_Confirmation2:SetFrameStrata("TOOLTIP");
WOWTR_Confirmation2.Title:SetText(QTR_ReverseIfAR(WoWTR_Localization.confirmationHeader));       -- Confirmation Header
WOWTR_Confirmation2.Text = WOWTR_Confirmation2:CreateFontString(nil, "ARTWORK");
WOWTR_Confirmation2.Title:SetFont(WOWTR_Font2, 13);
WOWTR_Confirmation2.Text:SetFontObject(GameFontWhite);
WOWTR_Confirmation2.Text:SetJustifyH("CENTER"); 
WOWTR_Confirmation2.Text:SetJustifyV("TOP");
WOWTR_Confirmation2.Text:ClearAllPoints();
WOWTR_Confirmation2.Text:SetPoint("TOPLEFT", WOWTR_Confirmation2, "TOPLEFT", 20, -40);
WOWTR_Confirmation2.Text:SetWidth(280);
WOWTR_Confirmation2.Text:SetText(QTR_ReverseIfAR(WoWTR_Localization.confirmationText2));   -- Czy chcesz przywrócić ustawienia domyślne dodatku?
WOWTR_Confirmation2.Text:SetFont(WOWTR_Font2, 14);
WOWTR_Confirmation2.ButtonYES = CreateFrame("Button",nil, WOWTR_Confirmation2, "UIPanelButtonTemplate");
WOWTR_Confirmation2.ButtonYES:SetWidth(75);
WOWTR_Confirmation2.ButtonYES:SetHeight(20);
local fo = WOWTR_Confirmation2.ButtonYES:CreateFontString();
fo:SetFont(WOWTR_Font2, 13);
fo:SetText(QTR_ReverseIfAR(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieYes)));
WOWTR_Confirmation2.ButtonYES:SetFontString(fo);
WOWTR_Confirmation2.ButtonYES:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieYes));    -- Yes
WOWTR_Confirmation2.ButtonYES:ClearAllPoints();
WOWTR_Confirmation2.ButtonYES:SetPoint("BOTTOMLEFT", WOWTR_Confirmation2, "BOTTOMLEFT", 20, 15);
WOWTR_Confirmation2.ButtonYES:Show();
WOWTR_Confirmation2.ButtonYES:SetScript("OnClick", function() 
    WOWTR_ResetVariables(2); 
    WOWTR_ReloadUI()
end);
WOWTR_Confirmation2.ButtonNO = CreateFrame("Button",nil, WOWTR_Confirmation2, "UIPanelButtonTemplate");
WOWTR_Confirmation2.ButtonNO:SetWidth(75);
WOWTR_Confirmation2.ButtonNO:SetHeight(20);
local fo = WOWTR_Confirmation2.ButtonNO:CreateFontString();
fo:SetFont(WOWTR_Font2, 13);
fo:SetText(QTR_ReverseIfAR(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieNo)));
WOWTR_Confirmation2.ButtonNO:SetFontString(fo);
WOWTR_Confirmation2.ButtonNO:SetText(QTR_ReverseIfAR(WoWTR_Localization.stopTheMovieNo));      -- No
WOWTR_Confirmation2.ButtonNO:ClearAllPoints();
WOWTR_Confirmation2.ButtonNO:SetPoint("BOTTOMRIGHT", WOWTR_Confirmation2, "BOTTOMRIGHT", -15, 15);
WOWTR_Confirmation2.ButtonNO:Show();
WOWTR_Confirmation2.ButtonNO:SetScript("OnClick", function() WOWTR_Confirmation2:Hide(); end);
WOWTR_Confirmation2:Hide();

end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ResetVariables(nr)
   if (nr == 1) then    -- wyczyść zapisane dane
      QTR_SAVED = nil;
      QTR_MISSING = nil;
      QTR_GOSSIP = nil;
      BB_PS = nil;
      BB_TR = nil;
      MF_PS = nil;
      TT_TUTORIALS = nil;
      BT_SAVED = nil;
      ST_PS = nil;
      ST_PH = nil;
      if (WOWTR_ResetButton1) then
         WOWTR_ResetButton1:SetText(WoWTR_Localization.resultButton1);   -- Wyczyszczono zapisane teksty
         WOWTR_Confirmation1:Hide();
      end
   else
      QTR_PS = nil;
      BB_PM = nil;
      MF_PM = nil;
      TT_PS = nil;
      BT_PM = nil;
      ST_PM = nil;
      WOWTR_Confirmation2:Hide();
   end
   WOWTR_CheckVars();
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ReloadUI()
    ReloadUI()
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ChangePanel1()
   WOWTR_Tab1TitleB:Hide();
   WOWTR_Tab2TitleA:Hide();
   WOWTR_Tab3TitleA:Hide();
   WOWTR_Tab4TitleA:Hide();
   WOWTR_Tab5TitleA:Hide();
   WOWTR_Tab6TitleA:Hide();
   WOWTR_Tab9TitleA:Hide();
   WOWTR_Tab1TitleA:Show();
   WOWTR_Tab2TitleB:Show();
   WOWTR_Tab3TitleB:Show();
   WOWTR_Tab4TitleB:Show();
   WOWTR_Tab5TitleB:Show();
   WOWTR_Tab6TitleB:Show();
   WOWTR_Tab9TitleB:Show();
   WOWTR_OptionPanel1:Show();
   WOWTR_OptionPanel2:Hide();
   WOWTR_OptionPanel3:Hide();
   WOWTR_OptionPanel4:Hide();
   WOWTR_OptionPanel5:Hide();
   WOWTR_OptionPanel6:Hide();
   WOWTR_OptionPanel9:Hide();
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ChangePanel2()
   WOWTR_Tab1TitleA:Hide();
   WOWTR_Tab2TitleB:Hide();
   WOWTR_Tab3TitleA:Hide();
   WOWTR_Tab4TitleA:Hide();
   WOWTR_Tab5TitleA:Hide();
   WOWTR_Tab6TitleA:Hide();
   WOWTR_Tab9TitleA:Hide();
   WOWTR_Tab1TitleB:Show();
   WOWTR_Tab2TitleA:Show();
   WOWTR_Tab3TitleB:Show();
   WOWTR_Tab4TitleB:Show();
   WOWTR_Tab5TitleB:Show();
   WOWTR_Tab6TitleB:Show();
   WOWTR_Tab9TitleB:Show();
   WOWTR_OptionPanel1:Hide();
   WOWTR_OptionPanel2:Show();
   WOWTR_OptionPanel3:Hide();
   WOWTR_OptionPanel4:Hide();
   WOWTR_OptionPanel5:Hide();
   WOWTR_OptionPanel6:Hide();
   WOWTR_OptionPanel9:Hide();
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ChangePanel3()
   WOWTR_Tab1TitleA:Hide();
   WOWTR_Tab2TitleA:Hide();
   WOWTR_Tab3TitleB:Hide();
   WOWTR_Tab4TitleA:Hide();
   WOWTR_Tab5TitleA:Hide();
   WOWTR_Tab6TitleA:Hide();
   WOWTR_Tab9TitleA:Hide();
   WOWTR_Tab1TitleB:Show();
   WOWTR_Tab2TitleB:Show();
   WOWTR_Tab3TitleA:Show();
   WOWTR_Tab4TitleB:Show();
   WOWTR_Tab5TitleB:Show();
   WOWTR_Tab6TitleB:Show();
   WOWTR_Tab9TitleB:Show();
   WOWTR_OptionPanel1:Hide();
   WOWTR_OptionPanel2:Hide();
   WOWTR_OptionPanel3:Show();
   WOWTR_OptionPanel4:Hide();
   WOWTR_OptionPanel5:Hide();
   WOWTR_OptionPanel6:Hide();
   WOWTR_OptionPanel9:Hide();
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ChangePanel4()
   WOWTR_Tab1TitleA:Hide();
   WOWTR_Tab2TitleA:Hide();
   WOWTR_Tab3TitleA:Hide();
   WOWTR_Tab4TitleB:Hide();
   WOWTR_Tab5TitleA:Hide();
   WOWTR_Tab6TitleA:Hide();
   WOWTR_Tab9TitleA:Hide();
   WOWTR_Tab1TitleB:Show();
   WOWTR_Tab2TitleB:Show();
   WOWTR_Tab3TitleB:Show();
   WOWTR_Tab4TitleA:Show();
   WOWTR_Tab5TitleB:Show();
   WOWTR_Tab6TitleB:Show();
   WOWTR_Tab9TitleB:Show();
   WOWTR_OptionPanel1:Hide();
   WOWTR_OptionPanel2:Hide();
   WOWTR_OptionPanel3:Hide();
   WOWTR_OptionPanel4:Show();
   WOWTR_OptionPanel5:Hide();
   WOWTR_OptionPanel6:Hide();
   WOWTR_OptionPanel9:Hide();
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ChangePanel5()
   WOWTR_Tab1TitleA:Hide();
   WOWTR_Tab2TitleA:Hide();
   WOWTR_Tab3TitleA:Hide();
   WOWTR_Tab4TitleA:Hide();
   WOWTR_Tab5TitleB:Hide();
   WOWTR_Tab6TitleA:Hide();
   WOWTR_Tab9TitleA:Hide();
   WOWTR_Tab1TitleB:Show();
   WOWTR_Tab2TitleB:Show();
   WOWTR_Tab3TitleB:Show();
   WOWTR_Tab4TitleB:Show();
   WOWTR_Tab5TitleA:Show();
   WOWTR_Tab6TitleB:Show();
   WOWTR_Tab9TitleB:Show();
   WOWTR_OptionPanel1:Hide();
   WOWTR_OptionPanel2:Hide();
   WOWTR_OptionPanel3:Hide();
   WOWTR_OptionPanel4:Hide();
   WOWTR_OptionPanel5:Show();
   WOWTR_OptionPanel6:Hide();
   WOWTR_OptionPanel9:Hide();
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ChangePanel6()
   WOWTR_Tab1TitleA:Hide();
   WOWTR_Tab2TitleA:Hide();
   WOWTR_Tab3TitleA:Hide();
   WOWTR_Tab4TitleA:Hide();
   WOWTR_Tab5TitleA:Hide();
   WOWTR_Tab6TitleB:Hide();
   WOWTR_Tab9TitleA:Hide();
   WOWTR_Tab1TitleB:Show();
   WOWTR_Tab2TitleB:Show();
   WOWTR_Tab3TitleB:Show();
   WOWTR_Tab4TitleB:Show();
   WOWTR_Tab5TitleB:Show();
   WOWTR_Tab6TitleA:Show();
   WOWTR_Tab9TitleB:Show();
   WOWTR_OptionPanel1:Hide();
   WOWTR_OptionPanel2:Hide();
   WOWTR_OptionPanel3:Hide();
   WOWTR_OptionPanel4:Hide();
   WOWTR_OptionPanel5:Hide();
   WOWTR_OptionPanel6:Show();
   WOWTR_OptionPanel9:Hide();
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_ChangePanel9()
   WOWTR_Tab1TitleA:Hide();
   WOWTR_Tab2TitleA:Hide();
   WOWTR_Tab3TitleA:Hide();
   WOWTR_Tab4TitleA:Hide();
   WOWTR_Tab5TitleA:Hide();
   WOWTR_Tab6TitleA:Hide();
   WOWTR_Tab9TitleB:Hide();
   WOWTR_Tab1TitleB:Show();
   WOWTR_Tab2TitleB:Show();
   WOWTR_Tab3TitleB:Show();
   WOWTR_Tab4TitleB:Show();
   WOWTR_Tab5TitleB:Show();
   WOWTR_Tab6TitleB:Show();
   WOWTR_Tab9TitleA:Show();
   WOWTR_OptionPanel1:Hide();
   WOWTR_OptionPanel2:Hide();
   WOWTR_OptionPanel3:Hide();
   WOWTR_OptionPanel4:Hide();
   WOWTR_OptionPanel5:Hide();
   WOWTR_OptionPanel6:Hide();
   WOWTR_OptionPanel9:Show();
end

-----------------------------------------------------------------------------------------------------------------

function Config_OnEnable()
   -- Create main frame for setting options
   WOWTR_BlizzardOptions();
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_SlashCommand(msg)
   if not msg or msg:trim() == "" then
      InterfaceOptionsFrame_OpenToCategory(WOWTR_Options);          -- open Settings of the addon
   end
end

-----------------------------------------------------------------------------------------------------------------

function WOWTR_WelcomePanel()
   if (not WOWTR.WelcomePanel) then
      QTR_PS["welcome"] = "1";
      WOWTR.WelcomePanel = CreateFrame("Frame", nil, UIParent, "UIPanelDialogTemplate");
      WOWTR.WelcomePanel:SetWidth(800);
      WOWTR.WelcomePanel:SetHeight(400);
      WOWTR.WelcomePanel:ClearAllPoints();
      WOWTR.WelcomePanel:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
      WOWTR.WelcomePanel:SetFrameStrata("TOOLTIP");
      WOWTR.WelcomePanel.Title:SetText(QTR_ReverseIfAR(WoWTR_Localization.optionTitle));
      WOWTR.WelcomePanel.Title:SetFont(WOWTR_Font2, 15);
      if (WoWTR_Localization.welcomeIconPos > 0) then
         WOWTR.Icon = WOWTR.WelcomePanel:CreateTexture(nil, "OVERLAY");
         WOWTR.Icon:ClearAllPoints();
         WOWTR.Icon:SetPoint("TOPRIGHT", WOWTR.WelcomePanel, "TOPRIGHT", -20, -WoWTR_Localization.welcomeIconPos);
         WOWTR.Icon:SetWidth(32);
         WOWTR.Icon:SetHeight(32);
         WOWTR.Icon:SetTexture(WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon.png");
      end
      WOWTR.WelcomePanel.Text = WOWTR.WelcomePanel:CreateFontString(nil, "ARTWORK");
      WOWTR.WelcomePanel.Text:SetFontObject(GameFontWhite);
      WOWTR.WelcomePanel.Text:SetJustifyH("LEFT"); 
      WOWTR.WelcomePanel.Text:SetJustifyV("TOP");
      WOWTR.WelcomePanel.Text:ClearAllPoints();
      WOWTR.WelcomePanel.Text:SetPoint("TOPLEFT", WOWTR.WelcomePanel, "TOPLEFT", 20, -40);
      WOWTR.WelcomePanel.Text:SetWidth(770);
      WOWTR.WelcomePanel.Text:SetText(QTR_ExpandUnitInfo(WoWTR_Config_Interface.welcomeText,false,WOWTR.WelcomePanel.Text,WOWTR_Font2));        -- welcome text when the addon is launched for the first time
      WOWTR.WelcomePanel.Text:SetFont(WOWTR_Font2, 14);
      WOWTR.WelcomePanel.Button = CreateFrame("Button",nil, WOWTR.WelcomePanel, "UIPanelButtonTemplate");
      WOWTR.WelcomePanel.Button:SetWidth(160);
      WOWTR.WelcomePanel.Button:SetHeight(20);
      local fo = WOWTR.WelcomePanel.Button:CreateFontString();
      fo:SetFont(WOWTR_Font2, 13);
      fo:SetText(QTR_ReverseIfAR(QTR_ReverseIfAR(WoWTR_Config_Interface.welcomeButton)));
      WOWTR.WelcomePanel.Button:SetFontString(fo);
      WOWTR.WelcomePanel.Button:SetText(QTR_ReverseIfAR(WoWTR_Config_Interface.welcomeButton));
      WOWTR.WelcomePanel.Button:ClearAllPoints();
      WOWTR.WelcomePanel.Button:SetPoint("BOTTOMLEFT", WOWTR.WelcomePanel, "BOTTOMLEFT", WOWTR.WelcomePanel:GetWidth()/2-WOWTR.WelcomePanel.Button:GetWidth()/2, 10);
      WOWTR.WelcomePanel.Button:Show();
      WOWTR.WelcomePanel.Button:SetScript("OnClick", function() WOWTR.WelcomePanel:Hide(); end);
   end
   WOWTR.WelcomePanel:Show();
end

-----------------------------------------------------------------------------------------------------------------

if ((GetLocale()=="enUS") or (GetLocale()=="enGB")) then

-- Create minimap button with Ace-3.0 library
-- Required Libraries: LibStub, AceAddon-3.0, AceConsole-3.0, AceDB-3.0, CallbackHandler-1.0, LibDataBroker-1.1, LibDBIcon-1.0

-- We report to Ace the name of our addon
local addon = LibStub("AceAddon-3.0"):NewAddon(WoWTR_Localization.addonName, "AceConsole-3.0")
-- Let's fetch the icon reference
   WOWTR_icon = LibStub("LibDBIcon-1.0");
-- We create an LDB object
   WOWTR_minimapButton = LibStub("LibDataBroker-1.1"):NewDataObject("WOWTR_LDB", {
   type = "data source",
   text = "WOWTR_LDB",
   icon = WoWTR_Localization.mainFolder.."\\Fonts\\images\\icon.png",    -- icon file
   
-- We open the addon settings window by clicking on the icon
   OnClick = function()
      InterfaceOptionsFrame_OpenToCategory(WOWTR_Options);          -- open Settings of the addon
   end,
   
-- Here we add a description of the addon to the tooltip object
   OnTooltipShow = function(tooltip)
      if (WoWTR_Localization.lang=='AR') then
         tooltip:SetText("|cff8080ff"..WOWTR_version.."|r "..QTR_ReverseIfAR(WoWTR_Localization.optionTitle));
      else
         tooltip:SetText(QTR_ReverseIfAR(WoWTR_Localization.optionTitle).." |cff8080ff"..WOWTR_version.."|r");
      end
      tooltip:AddLine("|cffffffff"..QTR_ReverseIfAR(WoWTR_Localization.addonIconDesc).."|r");
      _G[tooltip:GetName().."TextLeft1"]:SetFont(WOWTR_Font2, 15);
      _G[tooltip:GetName().."TextLeft2"]:SetFont(WOWTR_Font2, 13);
      tooltip:Show();
   end,
   });


-- Let's save the icon when our addon is loaded for the first time
   function addon:OnInitialize()
-- Don't forget to add the SavedVariables line to your TOC file! (WoWTR_minimapDB)
   WOWTR.db = LibStub("AceDB-3.0"):New("WoWTR_minimapDB", {
      profile = {
         minimap = {
            hide = false,
         },
      },
   });
   WOWTR_icon:Register("WOWTR_LDB", WOWTR_minimapButton, WOWTR.db.profile.minimap);
   end

end