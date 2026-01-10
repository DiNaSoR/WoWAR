-- General options group
-------------------------------------------------------------------------------------------------------

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.Groups = WOWTR.Config.Groups or {}

local LSM = LibStub("LibSharedMedia-3.0", true)

function WOWTR.Config.Groups.General()
  local fontValues
  if LSM then
    fontValues = {}
    local reg = LSM:HashTable("font")
    for name, _ in pairs(reg) do fontValues[name] = name end
  end

  return {
    type = "group", order = 1,
    name = function() return WOWTR.Config.Label("titleTab1", "General") end,
    get = function(info) return WOWTR.db.profile.quests[info[#info]] end,
    set = function(info, val)
      local key = info[#info]
      WOWTR.db.profile.quests[key] = val
      WOWTR.Config.SyncGlobalsFromDB()
      WOWTR.Config.NotifyChange()
      
      -- If "active" changed, refresh visible quest frames immediately
      if key == "active" then
        -- Disable/enable buttons based on new active state
        if QTR_ToggleButton0 then
          if val then QTR_ToggleButton0:Enable() else QTR_ToggleButton0:Disable() end
        end
        if QTR_ToggleButton1 then
          if val then QTR_ToggleButton1:Enable() else QTR_ToggleButton1:Disable() end
        end
        if QTR_ToggleButton2 then
          if val then QTR_ToggleButton2:Enable() else QTR_ToggleButton2:Disable() end
        end
        
        -- If turning off, disable translation immediately
        if not val and QTR_Translate_Off then
          QTR_Translate_Off(1)
        end
        
        -- Refresh visible quest frames
        if QuestFrame and QuestFrame:IsVisible() and QTR_QuestPrepare then
          QTR_QuestPrepare("__force__")
        elseif QuestLogPopupDetailFrame and QuestLogPopupDetailFrame:IsVisible() and QTR_QuestPrepare then
          QTR_QuestPrepare("QUEST_DETAIL")
        elseif QuestMapFrame and QuestMapFrame:IsVisible() then
          local questID =
            (QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.DetailsFrame and QuestMapFrame.QuestsFrame.DetailsFrame.questID)
            or (QuestMapFrame.DetailsFrame and QuestMapFrame.DetailsFrame.questID)
          if questID and QuestMapFrame_ShowQuestDetails then
            QuestMapFrame_ShowQuestDetails(questID)
          elseif QTR_PrepareReload then
            QTR_PrepareReload()
          end
        end
        
        -- Refresh visible gossip frame if active is turned off
        if not val and GossipFrame and GossipFrame:IsVisible() then
          -- Revert gossip to original text, fonts, alignment, etc.
          local gl_QTR_curr_goss = rawget(_G, "QTR_curr_goss")
          if gl_QTR_curr_goss == "1" then
            local gl_GS_ON_OFF = rawget(_G, "GS_ON_OFF")
            if gl_GS_ON_OFF then
              gl_GS_ON_OFF() -- Toggle off - this will restore everything (fonts, alignment, text)
            end
          end
          -- Also disable the gossip toggle button
          local gl_S = rawget(_G, "WOWTR") and rawget(_G, "WOWTR").Config and rawget(_G, "WOWTR").Config.Groups
          if gl_S and gl_S.General then
            -- Button is managed by the gossip module, but we can ensure it's disabled
            local gl_QTR_ToggleButtonGS1 = rawget(_G, "QTR_ToggleButtonGS1")
            if gl_QTR_ToggleButtonGS1 then gl_QTR_ToggleButtonGS1:Disable() end
          end
        end
      end
    end,
    args = {
      core = {
        type = "group", inline = true, order = 1,
        name = WOWTR.Config.Label("generalMainHeaderQS", "Core"),
        args = {
          active = { type = "toggle", name = WOWTR.Config.Label("activateQuestsTranslations", "Enable translations"), desc = WOWTR.Config.Label("activateQuestsTranslationsDESC", "Enable/disable quest translations."), order = 2, width = "full" },
          transtitle = { type = "toggle", name = WOWTR.Config.Label("translateQuestTitles", "Translate quest titles"), desc = WOWTR.Config.Label("translateQuestTitlesDESC", "Translate quest titles."), order = 3, width = "full" },
          gossip = { type = "toggle", name = WOWTR.Config.Label("translateGossipTexts", "Translate gossip"), desc = WOWTR.Config.Label("translateGossipTextsDESC", "Translate NPC gossip/dialogue."), order = 4, width = "full" },
          tracker = { type = "toggle", name = WOWTR.Config.Label("translateTrackObjectives", "Translate tracker"), desc = WOWTR.Config.Label("translateTrackObjectivesDESC", "Translate objective tracker text."), order = 5, width = "full" },
          ownnames = { type = "toggle", name = WOWTR.Config.Label("translateOwnNames", "Translate own names"), desc = WOWTR.Config.Label("translateOwnNamesDESC", "Translate some proper nouns (places)."), order = 6, width = "full" },
          en_first = { type = "toggle", name = WOWTR.Config.Label("displayENfirst", "Show English first"), desc = WOWTR.Config.Label("displayENfirstDESC", "Show original English text first."), order = 7, width = "full" },
        }
      },
      saving = {
        type = "group", inline = true, order = 5,
        name = WOWTR.Config.Label("savingUntranslatedQuests", "Saving"),
        args = {
          saveQS = { type = "toggle", name = WOWTR.Config.Label("saveUntranslatedQuests", "Save untranslated quests"), desc = WOWTR.Config.Label("saveUntranslatedQuestsDESC", "Save untranslated quest lines."), order = 8, width = "full" },
          saveGS = { type = "toggle", name = WOWTR.Config.Label("saveUntranslatedGossip", "Save untranslated gossip"), desc = WOWTR.Config.Label("saveUntranslatedGossipDESC", "Save untranslated gossip lines."), order = 9, width = "full" },
        }
      },
      plugins = {
        type = "group", inline = true, order = 10,
        name = WOWTR.Config.Label("integrationWithOtherAddons", "Plugins"),
        args = {
          immersion = { type = "toggle", name = WOWTR.Config.Label("translateImmersion", "Immersion"), desc = WOWTR.Config.Label("translateImmersionDESC", "Enable Immersion integration."), order = 11, width = "full" },
          storyline = { type = "toggle", name = WOWTR.Config.Label("translateStoryLine", "Storyline"), desc = WOWTR.Config.Label("translateStoryLineDESC", "Enable Storyline integration."), order = 12, width = "full" },
          questlog = { type = "toggle", name = WOWTR.Config.Label("translateQuestLog", "ClassicQuestLog"), desc = WOWTR.Config.Label("translateQuestLogDESC", "Enable ClassicQuestLog integration."), order = 13, width = "full" },
          dialogueui = { type = "toggle", name = WOWTR.Config.Label("translateDialogueUI", "DialogueUI"), desc = WOWTR.Config.Label("translateDialogueUIDESC", "Enable DialogueUI integration."), order = 14, width = "full" },
        }
      },
      fonts = {
        type = "group", inline = true, order = 16,
        name = WOWTR.Config.Label("fontSelectingFontHeader", "Font"),
        args = {
          FontLSM = fontValues and { type = "select", name = WOWTR.Config.Label("fontSelectingFontHeader", "Font"), desc = WOWTR.Config.Label("fontSelectingFontHeaderDESC", "Choose a font for WoWLang."), values = fontValues, order = 16, width = "full" } or nil,
          fontsize = { type = "range", name = WOWTR.Config.Label("fontsize", "Font size"), desc = WOWTR.Config.Label("fontsizeDESC", "Adjust font size."), min = 10, max = 24, step = 1, order = 17, width = "full" },
        }
      },
      minimapGroup = {
        type = "group", inline = true, order = 18,
        name = WOWTR.Config.Label("minimap", "Minimap"),
        args = {
          minimap = {
            type = "toggle", order = 19,
            name = WOWTR.Config.Label("showMinimapIcon", "Show minimap icon"), desc = WOWTR.Config.Label("showMinimapIconDESC", "Show/hide the minimap icon."), width = "full",
            get = function() return not WOWTR.db.profile.minimap.hide end,
            set = function(_, val)
              WOWTR.db.profile.minimap.hide = not val
              WOWTR.Config.SyncGlobalsFromDB()
              local LDBIcon = LibStub("LibDBIcon-1.0", true)
              if LDBIcon then
                if WOWTR.db.profile.minimap.hide then LDBIcon:Hide("WOWTR_LDB") else LDBIcon:Show("WOWTR_LDB") end
              end
              WOWTR.Config.NotifyChange()
            end,
          },
        }
      },
    },
  }
end


