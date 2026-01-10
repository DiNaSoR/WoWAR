local addonName, ns = ...

ns.Core = ns.Core or {}
local Core = ns.Core

-- Debug system: centralized debug printing that can be toggled
-- Usage: Core.DebugPrint("message", arg1, arg2, ...)
-- Or: WOWTR.DebugPrint("message", arg1, arg2, ...)
-- Or better: WOWTR.Debug.Normal(WOWTR.Debug.Categories.QUESTS, "message", ...)
function Core.DebugPrint(...)
  if WOWTR and WOWTR.Debug and WOWTR.Debug.Normal then
    -- Use new debug system if available
    WOWTR.Debug.Normal(WOWTR.Debug.Categories.GENERAL, ...)
  elseif WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core and WOWTR.db.profile.core.debug then
    -- Fallback to simple debug print
    local prefix = "|cFF00FF00WOWTR Debug:|r"
    print(prefix, ...)
  end
end

-- Global wrapper for backward compatibility
WOWTR = WOWTR or {}
WOWTR.DebugPrint = function(...) return Core.DebugPrint(...) end

-- Hash function used across modules
function Core.StringHash(text)
  if (not text or (#text == 0)) then return 0 end
  local counter = 1
  local pomoc = 0
  local dlug = string.len(text)
  for i = 1, dlug, 3 do
    counter = math.fmod(counter * 8161, 4294967279)
    pomoc = (string.byte(text, i) * 16776193)
    counter = counter + pomoc
    pomoc = ((string.byte(text, i + 1) or (dlug - i + 256)) * 8372226)
    counter = counter + pomoc
    pomoc = ((string.byte(text, i + 2) or (dlug - i + 256)) * 3932164)
    counter = counter + pomoc
  end
  return math.fmod(counter, 4294967291)
end

-- Repetitive function and delay utilities
function Core.Wait(delay, func, ...)
  if (type(delay) ~= "number" or type(func) ~= "function") then
    return false
  end
  if (WOWTR_waitFrame == nil) then
    WOWTR_waitFrame = CreateFrame("Frame", "WOWTR_WaitFrame", UIParent)
    WOWTR_waitFrame:SetScript("OnUpdate", function(self, elapse)
      local count = #WOWTR_waitTable
      local i = 1
      while (i <= count) do
        local waitRecord = tremove(WOWTR_waitTable, i)
        local d = tremove(waitRecord, 1)
        local f = tremove(waitRecord, 1)
        local p = tremove(waitRecord, 1)
        if (d > elapse) then
          tinsert(WOWTR_waitTable, i, { d - elapse, f, p })
          i = i + 1
        else
          count = count - 1
          f(unpack(p))
        end
      end
    end)
  end
  tinsert(WOWTR_waitTable, { delay, func, { ... } })
  return true
end

local tickers = {}
function Core.StartTicker(frame, func, interval)
  if not frame or not func or not interval then return end
  -- Clamp invalid/zero intervals. Some call sites pass 0 to mean "as fast as possible",
  -- which can translate into per-frame execution and cause heavy UI stutter.
  if type(interval) ~= "number" or interval <= 0 then
    interval = 0.1
  end
  if not tickers[frame] then
    func()
    tickers[frame] = C_Timer.NewTicker(interval, function()
      if frame:IsVisible() then
        func()
      else
        tickers[frame]:Cancel()
        tickers[frame] = nil
      end
    end)
  end
end

function Core.StartDelayedFunction(func, delay)
  if not func or not delay then return end
  C_Timer.After(delay, func)
end

-- SavedVariables initialization and migration shim (legacy globals preserved)
function Core.CheckVars()
  QTR_PS = QTR_PS or {}
  QTR_SAVED = QTR_SAVED or {}
  QTR_MISSING = QTR_MISSING or {}
  QTR_GOSSIP = QTR_GOSSIP or {}

  BB_PM = BB_PM or {}
  BB_PS = BB_PS or {}
  BB_TR = BB_TR or {}

  MF_PM = MF_PM or {}
  MF_PS = MF_PS or {}

  QTR_GS = {}

  -- Centralized legacy defaults/mapping (single source of truth).
  if WOWTR and WOWTR.LegacyBridge and WOWTR.LegacyBridge.EnsureLegacyDefaults then
    WOWTR.LegacyBridge.EnsureLegacyDefaults()
  end

  -- Font selection for legacy quest/gossip rendering (depends on QTR_PS["FontFile"]).
  if (WOWTR_Fonts and #WOWTR_Fonts > 1) then
    WOWTR_Font2 = WOWTR_Localization.mainFolder .. "\\Fonts\\" .. (QTR_PS["FontFile"] or WOWTR_Fonts[1])
  end

  if (not QTR_PS.firstTimeLoaded) then
    QTR_PS.firstTimeLoaded = true
    if WOWTR_ResetVariables then WOWTR_ResetVariables(1) end
  end

  -- One-time cleanup: strip accidental UE_COLOR: markers from saved gossip texts
  if QTR_GOSSIP then
    for k, v in pairs(QTR_GOSSIP) do
      if type(v) == "string" and string.sub(v, 1, 9) == "UE_COLOR:" then
        if WOWTR_StripUEColorMarker then
          QTR_GOSSIP[k] = WOWTR_StripUEColorMarker(v)
        else
          QTR_GOSSIP[k] = v:gsub("^UE_COLOR:", "")
        end
      end
    end
  end

  if (not BB_PM["TRonline"]) then BB_PM["TRonline"] = "0" end
  BB_PM["dungeonF"] = "0"
  if (WOWBB1) then
    WOWBB1.vertical = BB_PM["dungeonF1"]
    WOWBB2.vertical = BB_PM["dungeonF2"]
    WOWBB3.vertical = BB_PM["dungeonF3"]
    WOWBB4.vertical = BB_PM["dungeonF4"]
    WOWBB5.vertical = BB_PM["dungeonF5"]
  end

  -- TT_PS defaults are handled by LegacyBridge; tutorials table remains legacy-only.
  TT_TUTORIALS = TT_TUTORIALS or {}

  -- BT_PM defaults are handled by LegacyBridge; BT_SAVED remains legacy-only.
  BT_SAVED = BT_SAVED or {}

  -- ST_PM defaults are handled by LegacyBridge; ST_PS/ST_PH remain legacy-only.
  ST_PS = ST_PS or {}
  ST_PH = ST_PH or {}

  WoWTR_minimapDB = WoWTR_minimapDB or {}

  QTR_PS["patch"] = GetBuildInfo()
  QTR_PS["locale"] = GetLocale()
end

-- Version ping helpers
function Core.SendVersion()
  local now = GetTime()
  if (WOWTR_time_ver + 15 * 60 < now) then
    if (IsInGuild()) then C_ChatInfo.SendAddonMessage(WOWTR_ADDON_PREFIX, WOWTR_version, "GUILD") end
    if (IsInRaid()) then C_ChatInfo.SendAddonMessage(WOWTR_ADDON_PREFIX, WOWTR_version, "RAID") end
    WOWTR_time_ver = now
  end
end

function Core.OnChatMsgAddon(who, msg)
  if (tonumber(msg) > tonumber(WOWTR_version)) then
    local currentTime = GetTime()
    if (currentTime - WOWTR_lastNotificationTime) > WOWTR_notificationCooldown then
      print("|cffffff00" .. WOWTR_Localization.addonName .. "|r - " .. WOWTR_Localization.newVersionAvailable .. " |cffffff00" .. msg .. "|r")
      UIErrorsFrame:SetTimeVisible(10)
      if (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
        UIErrorsFrame:AddMessage(QTR_ReverseIfAR(WOWTR_Localization.addonName .. " - " .. WOWTR_Localization.newVersionAvailable .. WOWTR_AnsiReverse(msg)), 1, 0.5, 1)
      else
        UIErrorsFrame:AddMessage(WOWTR_Localization.addonName .. " - " .. WOWTR_Localization.newVersionAvailable .. msg, 1, 0.5, 1)
      end
      WOWTR_lastNotificationTime = currentTime
    end
  end
end

-- Event dispatcher
function Core.OnEvent(self, event, name, ...)
  if (event == "ADDON_LOADED" and WOWTR_Localization and name == WOWTR_Localization.addonFolder) then
    self:UnregisterEvent("ADDON_LOADED")
    self:RegisterEvent("QUEST_ACCEPTED")
    self:RegisterEvent("QUEST_DETAIL")
    self:RegisterEvent("QUEST_PROGRESS")
    self:RegisterEvent("QUEST_COMPLETE")
    self:RegisterEvent("GOSSIP_SHOW")
    self:RegisterEvent("QUEST_GREETING")
    self:RegisterEvent("PLAY_MOVIE")
    self:RegisterEvent("CINEMATIC_START")
    self:RegisterEvent("CINEMATIC_STOP")
    self:RegisterEvent("TUTORIAL_TRIGGER")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("MODIFIER_STATE_CHANGED")

    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", BB_ChatFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_PARTY", BB_ChatFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", BB_ChatFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_WHISPER", BB_ChatFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_EMOTE", BB_ChatFilter)

    SlashCmdList["WOWTR"] = function(msg) WOWTR_SlashCommand(msg) end
    SLASH_WOWTR_BUBBLES1 = "/wowtr"
    SLASH_WOWTR_BUBBLES2 = "/qtr"
    SLASH_WOWTR_BUBBLES3 = "/bbtr"
    SLASH_WOWTR_BUBBLES4 = "/mtr"
    SLASH_WOWTR_BUBBLES5 = "/btr"
    SLASH_WOWTR_BUBBLES6 = "/str"

    -- Register /wdebug command for debug UI
    SlashCmdList["WOWTR_DEBUG"] = function(msg)
      if WOWTR and WOWTR.DebugUI and WOWTR.DebugUI.Toggle then
        WOWTR.DebugUI.Toggle()
      else
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00WOWTR Debug:|r Debug UI not available")
      end
    end
    SLASH_WOWTR_DEBUG1 = "/wdebug"

    -- Register /wtools command for Debug Tools UI (clickable dump/clear buttons)
    SlashCmdList["WOWTR_TOOLS"] = function(msg)
      if WOWTR and WOWTR.DebugToolsUI and WOWTR.DebugToolsUI.Toggle then
        WOWTR.DebugToolsUI.Toggle()
      else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WoWAR]|r Debug Tools UI not available")
      end
    end
    SLASH_WOWTR_TOOLS1 = "/wtools"
    SLASH_WOWTR_TOOLS2 = "/wowtrtools"

    -- Smart UI string dumper (replaces /fstack hunting)
    -- Usage: /wowtrdump <frame or shortcut> [all] [noise] [hidden]
    -- Examples: /wowtrdump prof, /wowtrdump talents, /wowtrdump ProfessionsFrame all
    SlashCmdList["WOWTR_DUMP"] = function(msg)
      if WOWTR and WOWTR.Debug and WOWTR.Debug.HandleDumpCommand then
        WOWTR.Debug.HandleDumpCommand(msg)
      else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WoWAR]|r Dump system not available")
      end
    end
    SLASH_WOWTR_DUMP1 = "/wowtrdump"
    SLASH_WOWTR_DUMP2 = "/wdump"
    SLASH_WOWTR_DUMP3 = "/dumpui"

    -- Clear agent SavedVariables logs (agentDebugNDJSON / agentDumpNDJSON) from in-game.
    -- Usage: /wowtrclearlogs [all|debug|dump|cache]
    SlashCmdList["WOWTR_CLEARLOGS"] = function(msg)
      if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then
        WOWTR.Debug.ClearAgentLogs(msg)
      else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WoWAR]|r ClearLogs not available")
      end
    end
    SLASH_WOWTR_CLEARLOGS1 = "/wowtrclearlogs"
    SLASH_WOWTR_CLEARLOGS2 = "/wclearlogs"
    SLASH_WOWTR_CLEARLOGS3 = "/clearwowtrlogs"

    Core.CheckVars()
    if QTR_START then QTR_START() end
    if Config_OnEnable then Config_OnEnable() end
    if (WOWTR_Localization and WOWTR_Localization.lang == 'AR' and CHAT_START) then CHAT_START() end

    if TutorialFrame and TT_onTutorialShow then TutorialFrame:HookScript("OnShow", TT_onTutorialShow) end
    if (not PlayerChoiceFrame) then PlayerChoice_LoadUI() end
    if PlayerChoiceFrame and TT_onChoiceDelay then PlayerChoiceFrame:HookScript("OnShow", TT_onChoiceDelay) end

    if ItemTextFrame and BookTranslator_ShowTranslation then
      ItemTextFrame:HookScript("OnShow", function() BookTranslator_ShowTranslation() end)
      if ItemTextNextPageButton then ItemTextNextPageButton:HookScript("OnClick", function() BookTranslator_ShowTranslation() end) end
      if ItemTextPrevPageButton then ItemTextPrevPageButton:HookScript("OnClick", function() BookTranslator_ShowTranslation() end) end
      BT_ToggleButton0 = CreateFrame("Button", nil, ItemTextFrame, "UIPanelButtonTemplate")
      BT_ToggleButton0:SetWidth(40)
      BT_ToggleButton0:SetHeight(20)
      BT_ToggleButton0:SetText("EN")
      BT_ToggleButton0:Show()
      BT_ToggleButton0:ClearAllPoints()
      BT_ToggleButton0:SetPoint("BOTTOMRIGHT", ItemTextFrame, "BOTTOMRIGHT", -29, 5)
      BT_ToggleButton0:SetScript("OnClick", BT_ON_OFF)
    end

    if (_G.ElvUI and ST_ElvSpellBookTooltipOnShow) then
      local E = unpack(ElvUI)
      if E and E.SpellBookTooltip then
        E.SpellBookTooltip:HookScript("OnShow", function(self, ...)
          Core.Wait(0.02, ST_ElvSpellBookTooltipOnShow)
        end)
      end
    end

    if StaticPopup1 and ST_StaticPopup1 then StaticPopup1:HookScript("OnShow", ST_StaticPopup1) end
    if StaticPopup2 and ST_StaticPopup1 then StaticPopup2:HookScript("OnShow", ST_StaticPopup1) end
    if GameMenuFrame and ST_GameMenuTranslate then Core.HookOnShowTicker(GameMenuFrame, ST_GameMenuTranslate, 0.05) end
    if MerchantFrame and ST_MerchantFrame then MerchantFrame:HookScript("OnShow", ST_MerchantFrame) end
    if PVEFrame and ST_GroupFinder then Core.HookOnShowTicker(PVEFrame, ST_GroupFinder, 0) end
    if WorldMapFrame and ST_WorldMapFunc then Core.HookOnShowTicker(WorldMapFrame, ST_WorldMapFunc, 0.1) end
    if QuestScrollFrame and QTR_Quest_Next then Core.HookOnShowTicker(QuestScrollFrame, QTR_Quest_Next, 0.02) end
    if CharacterFrame and ST_CharacterFrame then CharacterFrame:HookScript("OnShow", ST_CharacterFrame) end
    if FriendsFrame and ST_FriendsFrame then Core.HookOnShowTicker(FriendsFrame, ST_FriendsFrame, 0.1) end
    if HelpPlateTooltip and ST_HelpPlateTooltip then Core.HookOnShowTicker(HelpPlateTooltip, ST_HelpPlateTooltip, 0.1) end
    if SplashFrame and ST_SplashFrame then Core.HookOnShowTicker(SplashFrame, ST_SplashFrame, 0.1) end
    if PingSystemTutorialTitleText and ST_PingSystemTutorial then Core.HookOnShowTicker(PingSystemTutorialTitleText, ST_PingSystemTutorial, 0.1) end
    if BankFrame and ST_WarbandBankFrm then Core.HookOnShowTicker(BankFrame, ST_WarbandBankFrm, 0.1) end
    if ItemRefTooltip and ST_ItemRefTooltip then Core.HookOnShowTicker(ItemRefTooltip, ST_ItemRefTooltip, 0.02) end
    if EventToastManagerFrame and ST_EventToastManagerFrame then Core.HookOnShowTicker(EventToastManagerFrame, ST_EventToastManagerFrame, 0.1) end
    if RaidBossEmoteFrame and ST_RaidBossEmoteFrame then Core.HookOnShowTicker(RaidBossEmoteFrame, ST_RaidBossEmoteFrame, 0.1) end
    if ReputationFrame and ReputationFrame.ReputationDetailFrame and ST_CharacterFrame then Core.HookOnShowTicker(ReputationFrame.ReputationDetailFrame, ST_CharacterFrame, 0.1) end
    if PlayerChoiceFrame and TT_onChoiceShow then Core.HookOnShowTicker(PlayerChoiceFrame, TT_onChoiceShow, 0.1) end

    if BB_OknoTRonline then BB_OknoTRonline() end

    WOWTR_ADDON_PREFIX = WOWTR_Localization.addonName .. "_ver"
    if WOWTR_EventFrame and WOWTR_EventFrame.RegisterEvent then
      WOWTR_EventFrame:RegisterEvent("CHAT_MSG_ADDON")
    else
      WOWTR_EventFrame = CreateFrame("Frame")
      WOWTR_EventFrame:RegisterEvent("CHAT_MSG_ADDON")
    end
    C_ChatInfo.RegisterAddonMessagePrefix(WOWTR_ADDON_PREFIX)

    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00" .. WOWTR_Localization.addonName .. "  ver. " .. WOWTR_version .. " - " .. WOWTR_Localization.started)
    if ((not QTR_PS["welcome"]) and WOWTR_Config_Interface and (string.len(WOWTR_Config_Interface.welcomeText or "") > 1)) then
      if WOWTR_WelcomePanel then WOWTR_WelcomePanel() end
    end
  elseif (event == "PLAYER_ENTERING_WORLD") then
    if TT_onTutorialShow then TT_onTutorialShow() end
    -- Auto-open changelog once per version if needed
    if WOWTR and WOWTR.Changelog and WOWTR.Changelog.ShouldShow and WOWTR.Changelog.ShouldShow() then
      if WOWTR_ShowChangelog then WOWTR_ShowChangelog() end
      if WOWTR.Changelog.MarkShown then WOWTR.Changelog.MarkShown() end
    end
  elseif (event == "QUEST_DETAIL" or event == "QUEST_PROGRESS" or event == "QUEST_COMPLETE") then
    if WOWTR and WOWTR.Debug then
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Event received:", event)
    end
    
    -- Get current quest ID
    local currentQuestID = QTR_quest_ID or (Quests.GetQuestID and Quests.GetQuestID()) or 0
    local now = GetTime()
    
    -- Skip if we just processed this same quest (avoid double processing)
    if currentQuestID > 0 and _lastProcessedQuestID == currentQuestID and (now - _lastProcessedQuestTime) < 0.5 then
       if WOWTR and WOWTR.Debug then
         WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Event handler: Already processed quest", currentQuestID, "recently, skipping to avoid double processing")
       end
       return
    end
    
    if (event == "QUEST_DETAIL" and QTR_quest_ID and QTR_quest_ID > 0) then
      local QTR_mapID = C_Map.GetBestMapForUnit("player")
      if (QTR_mapID) then
        local QTR_mapINFO = C_Map.GetMapInfo(QTR_mapID)
        if QTR_mapINFO then
          -- Config: allow disabling quest saving completely
          if (QTR_PS and QTR_PS["saveQS"] == "1") then
            QTR_SAVED[QTR_quest_ID .. " MAPID"] = QTR_mapID .. "@" .. QTR_mapINFO.name .. "@" .. QTR_mapINFO.mapType .. "@" .. QTR_mapINFO.parentMapID
          end
        end
      end
    end
    if WOWTR and WOWTR.Debug then
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Checking visible quest frames...")
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "QuestFrame visible:", QuestFrame and QuestFrame:IsVisible())
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "isImmersion:", isImmersion and isImmersion())
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "IsDUIQuestFrame:", IsDUIQuestFrame and IsDUIQuestFrame())
    else
      WOWTR.DebugPrint("Checking visible quest frames...")
      WOWTR.DebugPrint("QuestFrame visible:", QuestFrame and QuestFrame:IsVisible())
      WOWTR.DebugPrint("isImmersion:", isImmersion and isImmersion())
      WOWTR.DebugPrint("IsDUIQuestFrame:", IsDUIQuestFrame and IsDUIQuestFrame())
    end
    if ((QuestFrame and QuestFrame:IsVisible()) or (isImmersion and isImmersion()) or (IsDUIQuestFrame and IsDUIQuestFrame())) then
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Calling QTR_QuestPrepare from event handler...")
      end
      if QTR_QuestPrepare then 
        QTR_QuestPrepare(event)
        -- QuestPrepare marks the quest as processed internally, no need to do it here
      end
    elseif (isStoryline and isStoryline()) then
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Storyline detected, calling QTR_Storyline_Quest...")
        end
      if QTR_Storyline_Quest then Core.Wait(1, QTR_Storyline_Quest) end
    end
    -- (cleanup) removed orphaned QTR_ObjectiveTracker_Check hook
  elseif (event == "GOSSIP_SHOW") then
    if (QTR_PS and QTR_PS["active"] == "1" and QTR_PS["gossip"] == "1") then
      if DUIPlugin and IsDUIQuestFrame and IsDUIQuestFrame() then
        if QTR_DUIGossipFrame then QTR_DUIGossipFrame() end
      else
        if (ElvUI and QTR_Gossip_Show) then
          Core.Wait(0.02, QTR_Gossip_Show)
        elseif QTR_Gossip_Show then
          QTR_Gossip_Show()
        end
      end
    end
  elseif (event == "PLAY_MOVIE") then
    local WOWTR_movieID = name
    if (WOWTR_movieID and MF_PM and (MF_PM["active"] == "1") and (MF_PM["movie"] == "1") and MF_PlayMovie) then
      MF_PlayMovie(WOWTR_movieID)
    end
  elseif (event == "CINEMATIC_START") then
    if MF_CinematicStart then MF_CinematicStart() end
  elseif (event == "CINEMATIC_STOP") then
    if MF_CinematicStop then MF_CinematicStop() end
  elseif (event == "TUTORIAL_TRIGGER") then
    if TT_onTutorialShow then TT_onTutorialShow() end
  elseif (isImmersion and isImmersion() and event == "QUEST_ACCEPTED") then
    if QTR_delayed3 then QTR_delayed3() end
  elseif (event == "CHAT_MSG_ADDON") then
    local msg, method, who = select(1, ...)
    if (name == WOWTR_ADDON_PREFIX) then Core.OnChatMsgAddon(who, msg) end
  elseif (GameTooltip and GameTooltip.IsShown and GameTooltip:IsShown() and event == "MODIFIER_STATE_CHANGED" and (name == "LSHIFT" or name == "RSHIFT") and ST_PM and (ST_PM["active"] == "1")) then
    if (GameTooltip.processingInfo and GameTooltip.processingInfo.tooltipData and GameTooltip.processingInfo.tooltipData.id and (ST_PM["item"] == "1")) then
      if (GameTooltip.processingInfo.tooltipData.type == 0) then -- items
        if (ShoppingTooltip1 and ShoppingTooltip1:IsVisible()) then
          ShoppingTooltip1:Hide()
          if (ShoppingTooltip2 and ShoppingTooltip2:IsVisible()) then
            ShoppingTooltip2:Hide()
          end
        else
          GameTooltip_ShowCompareItem()
        end
      end
    end
  end

  if (TT_onTutorialShow) then TT_onTutorialShow() end
  Core.SendVersion()
end

-- Global wrappers for backward compatibility
function StringHash(text) return Core.StringHash(text) end
function WOWTR_wait(delay, func, ...) return Core.Wait(delay, func, ...) end
function StartTicker(frame, func, interval) return Core.StartTicker(frame, func, interval) end
function StartDelayedFunction(func, delay) return Core.StartDelayedFunction(func, delay) end
function WOWTR_CheckVars() return Core.CheckVars() end
function WOWTR_onEvent(self, event, name, ...) return Core.OnEvent(self, event, name, ...) end
function WOWTR_SendVersion() return Core.SendVersion() end
function WOWTR_onChatMsgAddon(who, msg) return Core.OnChatMsgAddon(who, msg) end

-- Bootstrap the root frame and events similar to legacy behavior
if ((GetLocale() == "enUS") or (GetLocale() == "enGB")) then
  WOWTR_EventFrame = WOWTR_EventFrame or CreateFrame("Frame")
  WOWTR_EventFrame:SetScript("OnEvent", WOWTR_onEvent)
  WOWTR_EventFrame:RegisterEvent("ADDON_LOADED")
else
  DEFAULT_CHAT_FRAME:AddMessage("|cffffff00" .. (WOWTR_Localization and WOWTR_Localization.addonName or addonName) .. "|r  ver. " .. (WOWTR_version or "") .. " - add-on is not active because it was run in Locale |cffffff00" .. GetLocale())
end


