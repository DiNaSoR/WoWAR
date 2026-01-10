-- Movies/Subtitles options group
-------------------------------------------------------------------------------------------------------

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.Groups = WOWTR.Config.Groups or {}

function WOWTR.Config.Groups.Movies()
  return WOWTR.Config.MakeTab("movies", {
    order = 4,
    name = function() return WOWTR.Config.Label("titleTab3", "Subtitles") end,
    args = {
      basics = {
        type = "group", inline = true, order = 1,
        name = WOWTR.Config.Label("generalMainHeaderMF", "Basics"),
        args = {
          active = { type = "toggle", name = WOWTR.Config.Label("activateSubtitleTranslations", "Enable"), desc = WOWTR.Config.Label("activateSubtitleTranslationsDESC", "Enable/disable subtitle translations."), order = 1, width = "full" },
          save = { type = "toggle", name = WOWTR.Config.Label("saveUntranslatedSubtitles", "Save untranslated"), desc = WOWTR.Config.Label("saveUntranslatedSubtitlesDESC", "Save missing subtitle lines."), order = 5, width = "full" },
        }
      },
      types = {
        type = "group", inline = true, order = 5,
        name = WOWTR.Config.Label("subtitleMovies", "Types"),
        args = {
          intro = { type = "toggle", name = WOWTR.Config.Label("subtitleIntro", "Intro"), desc = WOWTR.Config.Label("subtitleIntroDESC", "Show intro subtitles."), order = 2, width = "full" },
          movie = { type = "toggle", name = WOWTR.Config.Label("subtitleMovies", "Movies"), desc = WOWTR.Config.Label("subtitleMoviesDESC", "Show movie subtitles."), order = 3, width = "full" },
          cinematic = { type = "toggle", name = WOWTR.Config.Label("subtitleCinematics", "Cinematics"), desc = WOWTR.Config.Label("subtitleCinematicsDESC", "Show cinematic subtitles."), order = 4, width = "full" },
        }
      },
    },
  })
end

