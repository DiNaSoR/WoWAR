-- Tooltips and UI options group
-------------------------------------------------------------------------------------------------------

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.Groups = WOWTR.Config.Groups or {}

function WOWTR.Config.Groups.Tooltips()
  return WOWTR.Config.MakeTab("tooltips", {
    order = 2,
    name = function() return WOWTR.Config.Label("titleTab6", "Tooltips/UI") end,
    args = {
      basics = {
        type = "group", inline = true, order = 1,
        name = WOWTR.Config.Label("generalMainHeaderST", "Basics"),
        args = {
          active = { type = "toggle", name = WOWTR.Config.Label("activateTooltipTranslations", "Enable"), desc = WOWTR.Config.Label("activateTooltipTranslationsDESC", "Enable/disable tooltip translations."), order = 1, width = "full" },
          constantly = { type = "toggle", name = WOWTR.Config.Label("displayTranslationConstantly", "Always show"), desc = WOWTR.Config.Label("displayTranslationConstantlyDESC", "Always show translation (no timer)."), order = 2, width = "full" },
          timer = { type = "range", name = WOWTR.Config.Label("timerLimitSeconds", "Timer"), desc = WOWTR.Config.Label("timerLimitSecondsDESC", "Delay in seconds."), min = 1, max = 60, step = 1, order = 3, width = "full" },
        }
      },
      uiTargets = {
        type = "group", inline = true, order = 5,
        name = WOWTR.Config.Label("translationUI", "UI Targets"),
        args = {
          saveui = { type = "toggle", name = WOWTR.Config.Label("saveTranslationUI", "Save UI"), desc = WOWTR.Config.Label("saveTranslationUIDESC", "Save missing UI strings."), order = 3, width = "full" },
          ui1 = { type = "toggle", name = WOWTR.Config.Label("displayTranslationUI1", "Game Menu"), desc = WOWTR.Config.Label("displayTranslationUI1DESC", "Translate Game Menu."), order = 10, width = "full" },
          ui2 = { type = "toggle", name = WOWTR.Config.Label("displayTranslationUI2", "Character Info"), desc = WOWTR.Config.Label("displayTranslationUI2DESC", "Translate Character Info."), order = 11, width = "full" },
          ui3 = { type = "toggle", name = WOWTR.Config.Label("displayTranslationUI3", "Group Finder"), desc = WOWTR.Config.Label("displayTranslationUI3DESC", "Translate Group Finder."), order = 12, width = "full" },
          ui4 = { type = "toggle", name = WOWTR.Config.Label("displayTranslationUI4", "Collections"), desc = WOWTR.Config.Label("displayTranslationUI4DESC", "Translate Collections."), order = 13, width = "full" },
          ui5 = { type = "toggle", name = WOWTR.Config.Label("displayTranslationUI5", "Adventure Guide"), desc = WOWTR.Config.Label("displayTranslationUI5DESC", "Translate Adventure Guide."), order = 14, width = "full" },
          ui6 = { type = "toggle", name = WOWTR.Config.Label("displayTranslationUI6", "Friends"), desc = WOWTR.Config.Label("displayTranslationUI6DESC", "Translate Friends."), order = 15, width = "full" },
          ui7 = { type = "toggle", name = WOWTR.Config.Label("displayTranslationUI7", "Professions"), desc = WOWTR.Config.Label("displayTranslationUI7DESC", "Translate Professions."), order = 16, width = "full" },
          ui8 = { type = "toggle", name = WOWTR.Config.Label("displayTranslationUI8", "Misc UI"), desc = WOWTR.Config.Label("displayTranslationUI8DESC", "Translate various UI."), order = 17, width = "full" },
          ui_talents = { type = "toggle", name = WOWTR.Config.Label("ControlCenter_UI_TalentsUI", "Talents UI"), desc = WOWTR.Config.Label("ControlCenter_UI_TalentsUI_DESC", "Translate Talents UI."), order = 18, width = "full" },
        }
      },
      content = {
        type = "group", inline = true, order = 10,
        name = WOWTR.Config.Label("savingUntranslatedTooltips", "Content"),
        args = {
          item = { type = "toggle", name = WOWTR.Config.Label("translateItems", "Items"), desc = WOWTR.Config.Label("translateItemsDESC", "Translate item tooltips."), order = 20, width = "full" },
          spell = { type = "toggle", name = WOWTR.Config.Label("translateSpells", "Spells"), desc = WOWTR.Config.Label("translateSpellsDESC", "Translate spell tooltips."), order = 21, width = "full" },
          talent = { type = "toggle", name = WOWTR.Config.Label("translateTalents", "Talents"), desc = WOWTR.Config.Label("translateTalentsDESC", "Translate talent tooltips."), order = 22, width = "full" },
          transtitle = { type = "toggle", name = WOWTR.Config.Label("translateTooltipTitle", "Translate titles"), desc = WOWTR.Config.Label("translateTooltipTitleDESC", "Show translated names in tooltips."), order = 23, width = "full" },
          -- TT_PS["save"] controls tutorial capture (TT_TUTORIALS) in common/Tutorials/Main.lua
          save = { type = "toggle", name = WOWTR.Config.Label("saveUntranslatedTutorials", "Save untranslated tutorials"), desc = WOWTR.Config.Label("saveUntranslatedTutorialsDESC", "Save missing tutorial strings."), order = 24, width = "full" },
          showID = { type = "toggle", name = WOWTR.Config.Label("showTooltipID", "Show ID"), desc = WOWTR.Config.Label("showTooltipIDDESC", "Show tooltip IDs."), order = 25, width = "full" },
          showHS = { type = "toggle", name = WOWTR.Config.Label("showTooltipHash", "Show Hash"), desc = WOWTR.Config.Label("showTooltipHashDESC", "Show tooltip hash codes."), order = 26, width = "full" },
          sellprice = { type = "toggle", name = WOWTR.Config.Label("hideSellPrice", "Hide sell price"), desc = WOWTR.Config.Label("hideSellPriceDESC", "Hide item sell prices in tooltips."), order = 27, width = "full" },
          saveNW = { type = "toggle", name = WOWTR.Config.Label("saveUntranslatedTooltips", "Save untranslated"), desc = WOWTR.Config.Label("saveUntranslatedTooltipsDESC", "Save missing tooltip strings."), order = 29, width = "full" },
        }
      },
    },
  })
end


