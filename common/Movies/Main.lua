local addonName, ns = ...

ns.Movies = ns.Movies or {}
local Movies = ns.Movies
local S = Movies.State
local U = Movies.Utils

local function MoviesActive()
  return MF_PM and MF_PM["active"] == "1"
end

local function SaveMissingEnabled()
  return MoviesActive() and MF_PM["save"] == "1"
end

local function IntroFallbackEnabled()
  return MoviesActive() and MF_PM["intro"] == "1"
end

local function CinematicLiveHandlingEnabled()
  return MoviesActive() and ((MF_PM["cinematic"] == "1") or (MF_PM["intro"] == "1") or (MF_PM["save"] == "1"))
end

local function TranslateLiveCinematicSubtitles()
  return MoviesActive() and ((MF_PM["cinematic"] == "1") or (S.introDataAvailable and MF_PM["intro"] == "1"))
end

local function SubtitleFont()
  return WOWTR_Font1 or WOWTR_Font2
end

local function EnsureIntroSubtitleFS()
  if not CinematicFrame then return nil end
  if not S.introSubtitleFS then
    S.introSubtitleFS = CinematicFrame:CreateFontString(nil, "ARTWORK")
    S.introSubtitleFS:SetFontObject(GameFontWhite)
    S.introSubtitleFS:SetJustifyH("CENTER")
    S.introSubtitleFS:SetJustifyV("MIDDLE")
    S.introSubtitleFS:ClearAllPoints()
    S.introSubtitleFS:SetPoint("CENTER", CinematicFrame, "BOTTOM", 0, 100)
    S.introSubtitleFS:SetHeight(50)
  end
  S.introSubtitleFS:SetText("")
  S.introSubtitleFS:SetFont(SubtitleFont(), 22)
  return S.introSubtitleFS
end

local function ResetIntroFallback()
  S.introFallbackArmed = false
  S.introFallbackActive = false
  S.isShowing = false
  S.currentStartTime = 0
  S.currentStopTime = 0
  S.currentText = ""
  if S.introSubtitleFS then
    S.introSubtitleFS:SetText("")
    S.introSubtitleFS:Hide()
  end
end

local function PrimeIntroFallback()
  local gl_MF_Data = _G["MF_Data"]
  local firstKey = S.playerRace .. ":01"
  local firstEntry = gl_MF_Data and gl_MF_Data[firstKey]
  S.introDataAvailable = firstEntry and true or false
  if not (firstEntry and IntroFallbackEnabled()) then
    return
  end

  EnsureIntroSubtitleFS()
  S.lineIndex = 1
  S.currentStartTime = firstEntry["START"]
  S.currentStopTime = firstEntry["STOP"]
  S.currentText = firstEntry["NAPIS"]
  S.introFallbackArmed = true
end

local function StartIntroFallbackIfNeeded()
  if not S.introFallbackArmed then return end
  if S.liveSubtitleSeen then
    S.introFallbackArmed = false
    return
  end
  if (GetTime() - (S.cinematicStartedAt or 0)) < (S.currentStartTime or 0) then return end

  local fs = EnsureIntroSubtitleFS()
  if not fs then return end
  fs:Show()
  S.introFallbackArmed = false
  S.introFallbackActive = true
  S.isShowing = false
end

-- Show movie subtitles (called via SubtitlesFrame OnEvent in movie playback)
function Movies.ShowMovieSubtitles()
  local fs = SubtitlesFrame and SubtitlesFrame.Subtitle1
  if not fs then return end
  local readText = fs:GetText()
  if (readText and (readText ~= S.lastSubtitle) and (string.find(readText, NONBREAKINGSPACE) == nil)) then
    readText = WOWTR_DetectAndReplacePlayerName(readText)
    local cleaned = WOWTR_NormalizeForHash(readText)
    S.lineIndex = S.lineIndex + 1
    local lineIndexStr = U.leftPad2(S.lineIndex)
    S.lastSubtitle = readText
    local hash2 = StringHash(cleaned)
    local gl_MF_Hash = _G["MF_Hash"]
    local gl_BB_Bubbles = _G["BB_Bubbles"]
    if (gl_MF_Hash and gl_MF_Hash[hash2]) or (gl_BB_Bubbles and gl_BB_Bubbles[hash2]) then
      local translated = (gl_MF_Hash and gl_MF_Hash[hash2]) or (gl_BB_Bubbles and gl_BB_Bubbles[hash2])
      fs:SetText(QTR_ReverseIfAR(translated) .. NONBREAKINGSPACE)
      local _, size = fs:GetFont()
      fs:SetFont(SubtitleFont(), size)
    else
      if (MF_PM and MF_PM["save"] == "1") then
        MF_PS[S.movieId .. ":" .. lineIndexStr .. ":" .. tostring(hash2)] = readText
      end
    end
  end
end

-- Show cinematic subtitles during in-game cinematics
function Movies.ShowCinematicSubtitles()
  if not S.cinematicWatching then return end
  if (GetTime() < (S.liveCaptureThrottleUntil or 0)) then return end
  local fs = SubtitlesFrame and SubtitlesFrame.Subtitle1
  if not (fs and fs.IsVisible and fs:IsVisible()) then return end

  local text = fs:GetText()
  if (text and (#text > 0) and (string.find(text, NONBREAKINGSPACE) == nil) and (text ~= S.lastSubtitle)) then
    S.liveCaptureThrottleUntil = GetTime() + 1
    S.lastSubtitle = text
    S.liveSubtitleSeen = true
    S.introFallbackArmed = false
    if S.introFallbackActive then ResetIntroFallback() end

    local shouldTranslate = TranslateLiveCinematicSubtitles()
    local shouldSaveEN = true
    local replaced = WOWTR_DetectAndReplacePlayerName(text)
    local cleaned = WOWTR_NormalizeForHash(replaced)
    local hash = StringHash(cleaned)
    local p1 = select(1, string.find(replaced, ":"))

    if (p1 and p1 > 0 and p1 < 30) then
      local msg = WOWTR_DetectAndReplacePlayerName(string.sub(replaced, p1 + 2))
      local msgClean = WOWTR_NormalizeForHash(msg)
      local hash2 = StringHash(msgClean)
      local gl_MF_Hash = _G["MF_Hash"]
      local gl_BB_Bubbles = _G["BB_Bubbles"]
      if (gl_BB_Bubbles and gl_BB_Bubbles[hash2]) or (gl_MF_Hash and gl_MF_Hash[hash2]) then
        shouldSaveEN = false
        if shouldTranslate and (WOWTR_Localization and WOWTR_Localization.lang == 'AR') then
          local output = "r|" .. WOWTR_AnsiReverse(string.sub(replaced, 1, p1 - 1)) .. " :0099FFFFc| " .. WOW_ZmienKody((gl_BB_Bubbles and gl_BB_Bubbles[hash2]) or (gl_MF_Hash and gl_MF_Hash[hash2]))
          fs:SetText(QTR_ExpandUnitInfo(output, false, fs, WOWTR_Font1) .. NONBREAKINGSPACE)
        elseif shouldTranslate then
          local output = "|cFFFF9900" .. string.sub(replaced, 1, p1 - 1) .. " :|r " .. WOW_ZmienKody((gl_BB_Bubbles and gl_BB_Bubbles[hash2]) or (gl_MF_Hash and gl_MF_Hash[hash2]))
          fs:SetText(output .. NONBREAKINGSPACE)
        end
      else
        if (shouldSaveEN and SaveMissingEnabled()) then
          MF_PS[tostring(hash2)] = msg .. "@" .. (WOWTR_player_name or "") .. ":" .. (WOWTR_player_race or "") .. ":" .. (WOWTR_player_class or "")
        end
      end
    else
      local gl_MF_Hash = _G["MF_Hash"]
      local gl_BB_Bubbles = _G["BB_Bubbles"]
      if (gl_BB_Bubbles and gl_BB_Bubbles[hash]) or (gl_MF_Hash and gl_MF_Hash[hash]) then
        shouldSaveEN = false
        if shouldTranslate then
          local translated = WOW_ZmienKody((gl_BB_Bubbles and gl_BB_Bubbles[hash]) or (gl_MF_Hash and gl_MF_Hash[hash]))
          local nr_poz = U.findPercentS(translated)
          if (strsub(translated, 1, 2) == "%o") then
            translated = strsub(translated, 3):gsub("^%s*", "")
          elseif (nr_poz > 0) then
            local npcName = _G["name_NPC"] or ""
            if (nr_poz == 1) then
              translated = npcName .. strsub(translated, 3)
            else
              translated = strsub(translated, 1, nr_poz - 1) .. npcName .. strsub(translated, nr_poz + 2)
            end
          end
          local output = translated .. ""
          fs:SetText(QTR_ReverseIfAR(output) .. NONBREAKINGSPACE)
        end
      else
        if (shouldSaveEN and SaveMissingEnabled()) then
          MF_PS[tostring(hash)] = replaced .. "@" .. (WOWTR_player_name or "") .. ":" .. (WOWTR_player_race or "") .. ":" .. (WOWTR_player_class or "")
        end
      end
    end
  end
end

-- Intro subtitles controlled by timeline (fallback only when no live subtitle feed appears)
function Movies.ShowCinematicIntro()
  if not S.introFallbackActive then return end

  local elapsed = GetTime() - (S.cinematicStartedAt or 0)
  if ((S.isShowing == false) and (elapsed > (S.currentStartTime or 0))) then
    if S.introSubtitleFS then S.introSubtitleFS:SetText(QTR_ReverseIfAR(S.currentText)) end
    S.isShowing = true
  end
  if ((S.isShowing == true) and (elapsed > (S.currentStopTime or 0))) then
    if S.introSubtitleFS then S.introSubtitleFS:SetText("") end
    S.isShowing = false
    S.lineIndex = S.lineIndex + 1
    local key = S.playerRace .. ":" .. U.leftPad2(S.lineIndex)
    local gl_MF_Data = _G["MF_Data"]
    if (gl_MF_Data and gl_MF_Data[key]) then
      S.currentStartTime = gl_MF_Data[key]["START"]
      S.currentStopTime  = gl_MF_Data[key]["STOP"]
      S.currentText      = WOW_ZmienKody(gl_MF_Data[key]["NAPIS"])
    else
      ResetIntroFallback()
    end
  end
end

function Movies.OnCinematicUpdate()
  if not S.cinematicWatching then return end

  Movies.ShowCinematicSubtitles()
  StartIntroFallbackIfNeeded()
  Movies.ShowCinematicIntro()
end

-- Movie start event
function Movies.PlayMovie(movieID)
  S.movieId = tostring(movieID)
  if (not S.confirmQuestionMovie) then
    S.confirmQuestionMovie = MovieFrame.CloseDialog:CreateFontString(nil, "ARTWORK")
    S.confirmQuestionMovie:SetFontObject(GameFontNormal)
    S.confirmQuestionMovie:ClearAllPoints()
    S.confirmQuestionMovie:SetPoint("CENTER", MovieFrame.CloseDialog, "CENTER", 0, 6)
    S.confirmQuestionMovie:SetFont(WOWTR_Font2, 13)
    S.confirmQuestionMovie:SetText(QTR_ReverseIfAR(WOWTR_Localization.stopTheMovie))
  end
  MovieFrame.CloseDialog.ConfirmButton:SetText(QTR_ReverseIfAR(WOWTR_Localization.stopTheMovieYes))
  MovieFrame.CloseDialog.ResumeButton:SetText(QTR_ReverseIfAR(WOWTR_Localization.stopTheMovieNo))
  U.applyFontToButtonFontStrings(MovieFrame.CloseDialog.ConfirmButton, WOWTR_Font2, 15)
  U.applyFontToButtonFontStrings(MovieFrame.CloseDialog.ResumeButton, WOWTR_Font2, 15)

  MovieFrame:EnableSubtitles(true)
  S.lastSubtitle = ""
  S.lineIndex = 0

  while (#S.movieId < 3) do S.movieId = "0" .. S.movieId end
  local _, size = SubtitlesFrame.Subtitle1:GetFont()
  SubtitlesFrame.Subtitle1:SetFont(SubtitleFont(), size)
  SubtitlesFrame:HookScript("OnEvent", Movies.ShowMovieSubtitles)
end

-- Cinematic start event
function Movies.CinematicStart()
  if (not S.confirmQuestionCinematic) then
    S.confirmQuestionCinematic = CinematicFrameCloseDialog:CreateFontString(nil, "ARTWORK")
    S.confirmQuestionCinematic:SetFontObject(GameFontNormal)
    S.confirmQuestionCinematic:ClearAllPoints()
    S.confirmQuestionCinematic:SetPoint("CENTER", CinematicFrameCloseDialog, "CENTER", 0, 6)
    S.confirmQuestionCinematic:SetFont(WOWTR_Font2, 13)
    S.confirmQuestionCinematic:SetText(QTR_ReverseIfAR(WOWTR_Localization.stopTheMovie))
  end
  CinematicFrameCloseDialogConfirmButton:SetText(QTR_ReverseIfAR(WOWTR_Localization.stopTheMovieYes))
  CinematicFrameCloseDialogResumeButton:SetText(QTR_ReverseIfAR(WOWTR_Localization.stopTheMovieNo))
  U.applyFontToButtonFontStrings(CinematicFrameCloseDialogConfirmButton, WOWTR_Font2, 15)
  U.applyFontToButtonFontStrings(CinematicFrameCloseDialogResumeButton, WOWTR_Font2, 15)

  MovieFrame:EnableSubtitles(false)
  local _, size = SubtitlesFrame.Subtitle1:GetFont()
  size = math.floor(size + .5)
  SubtitlesFrame.Subtitle1:SetFont(SubtitleFont(), size)

  S.lastSubtitle = ""
  S.liveCaptureThrottleUntil = 0
  S.liveSubtitleSeen = false
  S.cinematicStartedAt = GetTime()
  S.introDataAvailable = false
  ResetIntroFallback()
  PrimeIntroFallback()

  S.cinematicWatching = CinematicLiveHandlingEnabled()
  if (S.cinematicWatching and SubtitlesFrame and not S.cinematicOnUpdateHooked) then
    SubtitlesFrame:HookScript("OnUpdate", Movies.OnCinematicUpdate)
    S.cinematicOnUpdateHooked = true
  end
end

function Movies.CinematicStop()
  S.cinematicWatching = false
  S.lastSubtitle = ""
  S.liveCaptureThrottleUntil = 0
  S.liveSubtitleSeen = false
  S.cinematicStartedAt = 0
  S.introDataAvailable = false
  ResetIntroFallback()
end

-- Back-compat global wrappers
function MF_ShowMovieSubtitles() return Movies.ShowMovieSubtitles() end
function MF_ShowCinematicSubtitles() return Movies.ShowCinematicSubtitles() end
function MF_ShowCinematicIntro() return Movies.ShowCinematicIntro() end
function MF_PlayMovie(movieID) return Movies.PlayMovie(movieID) end
function MF_CinematicStart() return Movies.CinematicStart() end
function MF_CinematicStop() return Movies.CinematicStop() end
