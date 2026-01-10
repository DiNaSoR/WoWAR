local addonName, ns = ...

ns.Movies = ns.Movies or {}
local Movies = ns.Movies
Movies.State = Movies.State or {}
local S = Movies.State

-- Runtime state for Movies/Cinematics/Intro subtitles
S.movieId = nil
S.subtitleFontSize = 16
S.lastSubtitle = ""
S.lineIndex = 0
S.timerStart = 0
S.isPlaying = false
S.isShowing = false
S.currentStartTime = 0
S.currentStopTime = 0
S.currentText = ""
S.playerRace = UnitRace("player")
S.playerClass = UnitClass("player")

-- Death Knight cinematic intro rules use class as race key
if (S.playerClass == "Death Knight") then
  S.playerRace = S.playerClass
end

-- UI elements created lazily
S.confirmQuestionMovie = nil
S.confirmQuestionCinematic = nil
S.introSubtitleFS = nil
