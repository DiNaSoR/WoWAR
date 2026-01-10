-- Books options group
-------------------------------------------------------------------------------------------------------

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.Groups = WOWTR.Config.Groups or {}

function WOWTR.Config.Groups.Books()
  return WOWTR.Config.MakeTab("books", {
    order = 5,
    name = function() return WOWTR.Config.Label("titleTab5", "Books") end,
    afterSet = function(key, val)
      -- If "active" or "title" changed, refresh visible book frame immediately
      if (key == "active" or key == "title") and ItemTextFrame and ItemTextFrame:IsVisible() then
        if key == "active" and not val then
          -- If turning off, hide button and revert to original text
          if BT_ToggleButton0 then BT_ToggleButton0:Hide() end
          -- Check if currently translated and toggle off
          local gl_act_tr = rawget(_G, "act_tr")
          if gl_act_tr == "1" and BT_ON_OFF then
            BT_ON_OFF() -- Toggle off if currently translated
          end
        end
        -- Refresh book display
        if BookTranslator_ShowTranslation then
          BookTranslator_ShowTranslation()
        end
      end
    end,
    args = {
      basics = {
        type = "group", inline = true, order = 1,
        name = WOWTR.Config.Label("generalMainHeaderBT", "Basics"),
        args = {
          active = { type = "toggle", name = WOWTR.Config.Label("activateBooksTranslations", "Enable"), desc = WOWTR.Config.Label("activateBooksTranslationsDESC", "Enable/disable book translations."), order = 1, width = "full" },
          title = { type = "toggle", name = WOWTR.Config.Label("translateBookTitles", "Translate title"), desc = WOWTR.Config.Label("translateBookTitlesDESC", "Translate book titles."), order = 2, width = "full" },
          showID = { type = "toggle", name = WOWTR.Config.Label("showBookID", "Show ID"), desc = WOWTR.Config.Label("showBookIDDESC", "Show the book ID."), order = 3, width = "full" },
        }
      },
      appearance = {
        type = "group", inline = true, order = 5,
        name = WOWTR.Config.Label("fontSelectingFontHeader", "Appearance"),
        args = {
          setsize = { type = "toggle", name = WOWTR.Config.Label("setFontActivate", "Custom size"), desc = WOWTR.Config.Label("setFontActivateDESC", "Enable custom font size."), order = 4, width = "full" },
          fontsize = { type = "range", name = WOWTR.Config.Label("fontsize", "Font size"), desc = WOWTR.Config.Label("fontsizeDESC", "Adjust font size."), min = 10, max = 24, step = 1, order = 5, width = "full" },
        }
      },
      saving = {
        type = "group", inline = true, order = 10,
        name = WOWTR.Config.Label("savingUntranslatedBooks", "Saving"),
        args = {
          saveNW = { type = "toggle", name = WOWTR.Config.Label("saveUntranslatedBooks", "Save untranslated"), desc = WOWTR.Config.Label("saveUntranslatedBooksDESC", "Save missing book lines."), order = 6, width = "full" },
        }
      },
    },
  })
end


