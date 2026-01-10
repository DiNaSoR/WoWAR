-- common/Config/ControlCenter/Registry.lua
-- WoWLang ControlCenter registry:
-- Maps AceDB profile settings into Plumber-style "modules" + categories for the SettingsPanel UI.

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.ControlCenter = WOWTR.Config.ControlCenter or {}

local ControlCenter = WOWTR.Config.ControlCenter

ControlCenter.modules = ControlCenter.modules or {}
ControlCenter.dbKeyXModule = ControlCenter.dbKeyXModule or {}
ControlCenter.changelogs = ControlCenter.changelogs or {}

ControlCenter.dbKeyToSetting = ControlCenter.dbKeyToSetting or {}

local function L(key, fallback)
  if WOWTR and WOWTR.Config and WOWTR.Config.Label then
    return WOWTR.Config.Label(key, fallback)
  end
  return fallback
end

local function LDesc(key, fallback)
  if WOWTR and WOWTR.Config then
    if WOWTR.Config.LabelRaw then
      return WOWTR.Config.LabelRaw(key, fallback)
    end
    if WOWTR.Config.Label then
      return WOWTR.Config.Label(key, fallback)
    end
  end
  return fallback
end

local function GetProfile()
  return WOWTR and WOWTR.db and WOWTR.db.profile
end

local function SplitPath(path)
  if type(path) ~= "string" then return nil end
  local out = {}
  for part in string.gmatch(path, "([%w_]+)") do
    out[#out + 1] = part
  end
  return out
end

local function GetByPath(path)
  local p = GetProfile()
  if not p then return nil end
  local parts = SplitPath(path)
  if not parts then return nil end
  local t = p
  for i = 1, #parts do
    local k = parts[i]
    t = t and t[k] or nil
  end
  return t
end

local function SetByPath(path, value)
  local p = GetProfile()
  if not p then return false end
  local parts = SplitPath(path)
  if not parts or #parts == 0 then return false end
  local t = p
  for i = 1, (#parts - 1) do
    local k = parts[i]
    if type(t[k]) ~= "table" then
      t[k] = {}
    end
    t = t[k]
  end
  t[parts[#parts]] = value
  return true
end

function ControlCenter:GetDBValue(dbKey)
  local reg = self.dbKeyToSetting[dbKey]
  if not reg then return nil end
  if type(reg.get) == "function" then
    return reg.get()
  end
  if type(reg.path) == "string" then
    return GetByPath(reg.path)
  end
end

function ControlCenter:GetDBBool(dbKey)
  return self:GetDBValue(dbKey) and true or false
end

function ControlCenter:SetDBValue(dbKey, value, noApply)
  local reg = self.dbKeyToSetting[dbKey]
  if not reg then return false end

  if type(reg.set) == "function" then
    reg.set(value)
  elseif type(reg.path) == "string" then
    if not SetByPath(reg.path, value) then
      return false
    end
  else
    return false
  end

  if not noApply then
    if self.Apply and self.Apply.OnSettingChanged then
      self.Apply.OnSettingChanged(dbKey, value)
    else
      -- Safe default: keep globals in sync; deeper runtime refresh is implemented in Apply.lua.
      if WOWTR and WOWTR.Config and WOWTR.Config.SyncGlobalsFromDB then
        WOWTR.Config.SyncGlobalsFromDB()
      end
    end
  end

  self:ClearFilterCache()
  return true
end

function ControlCenter:RegisterSetting(dbKey, opts)
  if not (dbKey and opts) then return end
  self.dbKeyToSetting[dbKey] = opts
end

local function IndexModule(self, moduleData)
  if not moduleData or not moduleData.dbKey then return end

  self.dbKeyXModule[moduleData.dbKey] = moduleData

  if moduleData.setting then
    self:RegisterSetting(moduleData.dbKey, moduleData.setting)
  end

  if moduleData.subOptions then
    for _, sub in ipairs(moduleData.subOptions) do
      IndexModule(self, sub)
    end
  end
end

function ControlCenter:AddModule(moduleData)
  if not moduleData or not moduleData.dbKey then return end
  table.insert(self.modules, moduleData)
  IndexModule(self, moduleData)
end

-- -----------------------------------------------------------------------------
-- Categories + Sorting/Search (ported/adapted from Plumber/Modules/ControlCenter/PreLoad.lua)
-- -----------------------------------------------------------------------------

local SortFunc = {}

function SortFunc.Alphabet(a, b)
  if a.virtual ~= b.virtual then
    return not a.virtual
  end
  return a.name < b.name
end

function SortFunc.Date(a, b)
  if a.virtual ~= b.virtual then
    return not a.virtual
  end
  if a.moduleAddedTime and b.moduleAddedTime then
    return a.moduleAddedTime > b.moduleAddedTime
  end
  if not (a.moduleAddedTime or b.moduleAddedTime) then
    return a.name < b.name
  end
  return a.moduleAddedTime ~= nil
end

local CurrentSortMethod = SortFunc.Alphabet
local FilterSortByMethods = { SortFunc.Alphabet, SortFunc.Date }

ControlCenter.PrimaryCategory = ControlCenter.PrimaryCategory or {
  "General",
  "Tooltips",
  "Bubbles",
  "Movies",
  "Books",
  "Chat",
  "About",
}

function ControlCenter:ClearFilterCache()
  self.sortedModules = nil
end

function ControlCenter:GetValidSortMethodIndex(index)
  if not (index and FilterSortByMethods[index]) then
    index = 1
  end
  return index
end

function ControlCenter:UpdateCurrentSortMethod()
  local p = GetProfile()
  local index = p and p.core and p.core.controlCenterSortIndex or 1
  index = self:GetValidSortMethodIndex(index)
  if CurrentSortMethod ~= FilterSortByMethods[index] then
    CurrentSortMethod = FilterSortByMethods[index]
    self:ClearFilterCache()
  end
  return index
end

function ControlCenter:SetCurrentSortMethod(index)
  index = self:GetValidSortMethodIndex(index)
  if CurrentSortMethod ~= FilterSortByMethods[index] then
    CurrentSortMethod = FilterSortByMethods[index]
    self.sortedModules = nil
  end
  local p = GetProfile()
  if p then
    p.core = p.core or {}
    p.core.controlCenterSortIndex = index
  end
end

function ControlCenter:GetNumFilters()
  return #FilterSortByMethods
end

function ControlCenter:GetPrimaryCategoryName(categoryKey)
  return L("ControlCenter_Category_" .. tostring(categoryKey), tostring(categoryKey))
end

local function BuildSearchTextForModule(self, data)
  local parts = {}
  parts[#parts + 1] = string.lower(data.name or "")
  if data.description then
    parts[#parts + 1] = string.lower(data.description)
  end
  if data.subOptions then
    for _, sub in ipairs(data.subOptions) do
      parts[#parts + 1] = string.lower(sub.name or "")
      if sub.description then
        parts[#parts + 1] = string.lower(sub.description)
      end
    end
  end
  return table.concat(parts, " ")
end

function ControlCenter:GetSortedModules()
  if self.sortedModules then
    return self.sortedModules
  end

  -- Ensure sort mode is current
  self:UpdateCurrentSortMethod()

  local tbl = {}
  local categoryXModule = {}

  for _, data in ipairs(self.modules) do
    if data.isValid then
      local categoryKeys = data.categoryKeys or { "General" }
      for _, cateKey in ipairs(categoryKeys) do
        categoryXModule[cateKey] = categoryXModule[cateKey] or {}
        table.insert(categoryXModule[cateKey], data)
      end
    end
  end

  for _, v in pairs(categoryXModule) do
    table.sort(v, CurrentSortMethod)
  end

  for _, cateKey in ipairs(self.PrimaryCategory) do
    local modules = categoryXModule[cateKey]
    local numModules = modules and #modules or 0
    if numModules > 0 then
      table.insert(tbl, {
        key = cateKey,
        categoryName = self:GetPrimaryCategoryName(cateKey),
        modules = modules,
        anyNewFeature = false,
        numModules = numModules,
      })
    end
  end

  self.sortedModules = tbl
  return tbl
end

function ControlCenter:GetSearchResult(keyword)
  if not keyword or keyword == "" then
    return self:GetSortedModules()
  end

  self:UpdateCurrentSortMethod()

  keyword = string.lower(keyword)

  local categoryXModule = {}

  for _, data in ipairs(self.modules) do
    if data.isValid then
      if not data.combinedSearchText then
        data.combinedSearchText = BuildSearchTextForModule(self, data)
      end

      if data.combinedSearchText and string.find(data.combinedSearchText, keyword, 1, true) then
        local cateKey = (data.categoryKeys and data.categoryKeys[1]) or "General"
        categoryXModule[cateKey] = categoryXModule[cateKey] or {}
        table.insert(categoryXModule[cateKey], data)
      end
    end
  end

  for _, v in pairs(categoryXModule) do
    table.sort(v, CurrentSortMethod)
  end

  local tbl = {}
  for _, cateKey in ipairs(self.PrimaryCategory) do
    local modules = categoryXModule[cateKey]
    local numModules = modules and #modules or 0
    if numModules > 0 then
      table.insert(tbl, {
        key = cateKey,
        categoryName = self:GetPrimaryCategoryName(cateKey),
        modules = modules,
        anyNewFeature = false,
        numModules = numModules,
      })
    end
  end

  return tbl
end

function ControlCenter:FlagCurrentNewFeatureMarkerSeen()
  -- WoWLang: currently unused (we don’t ship new-feature markers yet).
  self:ClearFilterCache()
end

function ControlCenter:AnyNewFeatureMarker()
  return false
end

-- -----------------------------------------------------------------------------
-- Build WoWLang modules (maps to WOWTR.db.profile.*)
-- -----------------------------------------------------------------------------

local function MakeBoolSetting(path)
  return { path = path }
end

local function MakeBoolModule(args)
  -- args: {dbKey, name, description, categoryKey, path OR get/set, parentDBKey?}
  local data = {
    dbKey = args.dbKey,
    name = args.name,
    description = args.description,
    categoryKeys = { args.categoryKey },
    isValid = true,
    moduleAddedTime = args.moduleAddedTime,
    virtual = args.virtual,
    setting = args.setting,
  }

  data.toggleFunc = function(newState)
    -- Setting already written by panel code; just apply side effects.
    if ControlCenter.Apply and ControlCenter.Apply.OnSettingChanged then
      ControlCenter.Apply.OnSettingChanged(args.dbKey, newState)
    else
      if WOWTR and WOWTR.Config and WOWTR.Config.SyncGlobalsFromDB then
        WOWTR.Config.SyncGlobalsFromDB()
      end
    end
  end

  data.optionToggleFunc = args.optionToggleFunc
  data.hasMovableWidget = args.hasMovableWidget

  return data
end

local function RegisterDefaultModules(self)
  wipe(self.modules)
  wipe(self.dbKeyXModule)
  wipe(self.dbKeyToSetting)

  -- GENERAL (Quests + Minimap)
  do
    local quests = MakeBoolModule({
      dbKey = "WOWTR_Quests",
      name = L("activateQuestsTranslations", "Enable translations"),
      description = LDesc("activateQuestsTranslationsDESC", "Translate quests/gossip into your selected language."),
      categoryKey = "General",
      setting = MakeBoolSetting("quests.active"),
    })

    quests.subOptions = {
      MakeBoolModule({
        dbKey = "WOWTR_Quests_Transtitle",
        name = L("translateQuestTitles", "Translate quest titles"),
        description = LDesc("translateQuestTitlesDESC", "Translate quest titles."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.transtitle"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_Gossip",
        name = L("translateGossipTexts", "Translate gossip"),
        description = LDesc("translateGossipTextsDESC", "Translate NPC gossip/dialogue."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.gossip"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_Tracker",
        name = L("translateTrackObjectives", "Translate tracker"),
        description = LDesc("translateTrackObjectivesDESC", "Translate objective tracker text."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.tracker"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_OwnNames",
        name = L("translateOwnNames", "Translate own names"),
        description = LDesc("translateOwnNamesDESC", "Translate some proper nouns (places)."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.ownnames"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_ENFirst",
        name = L("displayENfirst", "Show English first"),
        description = LDesc("displayENfirstDESC", "Show the original English text first."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.en_first"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_SaveQS",
        name = L("saveUntranslatedQuests", "Save untranslated quests"),
        description = LDesc("saveUntranslatedQuestsDESC", "Save missing quest lines for later translation."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.saveQS"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_SaveGS",
        name = L("saveUntranslatedGossip", "Save untranslated gossip"),
        description = LDesc("saveUntranslatedGossipDESC", "Save missing gossip lines for later translation."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.saveGS"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_Immersion",
        name = L("translateImmersion", "Immersion"),
        description = LDesc("translateImmersionDESC", "Enable Immersion addon integration."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.immersion"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_Storyline",
        name = L("translateStoryLine", "Storyline"),
        description = LDesc("translateStoryLineDESC", "Enable Storyline addon integration."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.storyline"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_QuestLog",
        name = L("translateQuestLog", "ClassicQuestLog"),
        description = LDesc("translateQuestLogDESC", "Enable ClassicQuestLog addon integration."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.questlog"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Quests_DialogueUI",
        name = L("translateDialogueUI", "DialogueUI"),
        description = LDesc("translateDialogueUIDESC", "Enable DialogueUI addon integration."),
        categoryKey = "General",
        setting = MakeBoolSetting("quests.dialogueui"),
      }),
    }

    self:AddModule(quests)

    local minimap = MakeBoolModule({
      dbKey = "WOWTR_Minimap_ShowIcon",
      name = L("showMinimapIcon", "Show minimap icon"),
      description = LDesc("showMinimapIconDESC", "Show/hide the minimap icon for opening settings."),
      categoryKey = "General",
      setting = {
        get = function()
          local p = GetProfile()
          -- NOTE: Avoid `a and b or default` here; when `b` is false it will fall through to `default`.
          -- We want: show icon unless the profile explicitly says `minimap.hide = true`.
          return not (p and p.minimap and p.minimap.hide)
        end,
        set = function(val)
          local p = GetProfile()
          if not p then return end
          p.minimap = p.minimap or {}
          p.minimap.hide = not val
        end,
      },
    })

    minimap.toggleFunc = function()
      if WOWTR and WOWTR.Config and WOWTR.Config.SyncGlobalsFromDB then
        WOWTR.Config.SyncGlobalsFromDB()
      end
      local LDBIcon = LibStub("LibDBIcon-1.0", true)
      if LDBIcon and WOWTR and WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.minimap then
        if WOWTR.db.profile.minimap.hide then
          LDBIcon:Hide("WOWTR_LDB")
        else
          LDBIcon:Show("WOWTR_LDB")
        end
      end
    end

    self:AddModule(minimap)
  end

  -- TOOLTIPS / UI
  do
    local tooltips = MakeBoolModule({
      dbKey = "WOWTR_Tooltips",
      name = L("activateTooltipTranslations", "Enable tooltips/UI translations"),
      description = LDesc("activateTooltipTranslationsDESC", "Translate tooltips and selected UI panels."),
      categoryKey = "Tooltips",
      setting = MakeBoolSetting("tooltips.active"),
    })

    tooltips.subOptions = {
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_Always",
        name = L("displayTranslationConstantly", "Always show"),
        description = LDesc("displayTranslationConstantlyDESC", "Always show translated tooltip text."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.constantly"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_SaveUI",
        name = L("saveTranslationUI", "Save UI"),
        description = LDesc("saveTranslationUIDESC", "Save untranslated UI strings for later translation."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.saveui"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UI1",
        name = L("displayTranslationUI1", "Game Menu"),
        description = LDesc("displayTranslationUI1DESC", "Translate Game Menu."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui1"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UI2",
        name = L("displayTranslationUI2", "Character Info"),
        description = LDesc("displayTranslationUI2DESC", "Translate Character Info."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui2"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UI3",
        name = L("displayTranslationUI3", "Group Finder"),
        description = LDesc("displayTranslationUI3DESC", "Translate Group Finder."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui3"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UI4",
        name = L("displayTranslationUI4", "Collections"),
        description = LDesc("displayTranslationUI4DESC", "Translate Collections."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui4"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UI5",
        name = L("displayTranslationUI5", "Adventure Guide"),
        description = LDesc("displayTranslationUI5DESC", "Translate Adventure Guide."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui5"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UI6",
        name = L("displayTranslationUI6", "Friends"),
        description = LDesc("displayTranslationUI6DESC", "Translate Friends."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui6"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UI7",
        name = L("displayTranslationUI7", "Professions"),
        description = LDesc("displayTranslationUI7DESC", "Translate Professions."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui7"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UI8",
        name = L("displayTranslationUI8", "Misc UI"),
        description = LDesc("displayTranslationUI8DESC", "Translate various UI dropdowns/filters."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui8"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_UITalents",
        name = L("ControlCenter_UI_TalentsUI", "Talents UI"),
        description = LDesc("ControlCenter_UI_TalentsUI_DESC", "Translate Talents UI."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.ui_talents"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_Item",
        name = L("translateItems", "Items"),
        description = LDesc("translateItemsDESC", "Translate item tooltips."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.item"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_Spell",
        name = L("translateSpells", "Spells"),
        description = LDesc("translateSpellsDESC", "Translate spell tooltips."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.spell"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_Talent",
        name = L("translateTalents", "Talents"),
        description = LDesc("translateTalentsDESC", "Translate talent tooltips."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.talent"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_Title",
        name = L("translateTooltipTitle", "Translate titles"),
        description = LDesc("translateTooltipTitleDESC", "Show translated names in tooltips."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.transtitle"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_SaveTutorials",
        name = L("saveUntranslatedTutorials", "Save untranslated tutorials"),
        description = LDesc("saveUntranslatedTutorialsDESC", "Save missing tutorial strings for later translation."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.save"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_ShowID",
        name = L("showTooltipID", "Show ID"),
        description = LDesc("showTooltipIDDESC", "Show tooltip IDs."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.showID"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_ShowHash",
        name = L("showTooltipHash", "Show Hash"),
        description = LDesc("showTooltipHashDESC", "Show tooltip hash codes."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.showHS"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_HideSellPrice",
        name = L("hideSellPrice", "Hide sell price"),
        description = LDesc("hideSellPriceDESC", "Hide item sell price lines in tooltips."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.sellprice"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Tooltips_SaveNW",
        name = L("saveUntranslatedTooltips", "Save untranslated"),
        description = LDesc("saveUntranslatedTooltipsDESC", "Save missing tooltip strings."),
        categoryKey = "Tooltips",
        setting = MakeBoolSetting("tooltips.saveNW"),
      }),
    }

    self:AddModule(tooltips)
  end

  -- BUBBLES
  do
    local bubbles = MakeBoolModule({
      dbKey = "WOWTR_Bubbles",
      name = L("activateBubblesTranslations", "Enable bubbles"),
      description = LDesc("activateBubblesTranslationsDESC", "Translate chat bubbles."),
      categoryKey = "Bubbles",
      setting = MakeBoolSetting("bubbles.active"),
    })

    bubbles.subOptions = {
      MakeBoolModule({
        dbKey = "WOWTR_Bubbles_ChatTR",
        name = L("displayTranslatedTexts", "Chat TR"),
        description = LDesc("displayTranslatedTextsDESC", "Show translated bubble lines in chat."),
        categoryKey = "Bubbles",
        setting = MakeBoolSetting("bubbles.chat_tr"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Bubbles_ChatEN",
        name = L("displayOriginalTexts", "Chat EN"),
        description = LDesc("displayOriginalTextsDESC", "Show original (English) bubble lines in chat."),
        categoryKey = "Bubbles",
        setting = MakeBoolSetting("bubbles.chat_en"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Bubbles_SaveNB",
        name = L("saveUntranslatedBubbles", "Save untranslated bubbles"),
        description = LDesc("saveUntranslatedBubblesDESC", "Save missing bubble lines for later translation."),
        categoryKey = "Bubbles",
        setting = MakeBoolSetting("bubbles.saveNB"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Bubbles_SetSize",
        name = L("setFontActivate", "Set font size"),
        description = LDesc("setFontActivateDESC", "Enable custom font size."),
        categoryKey = "Bubbles",
        setting = MakeBoolSetting("bubbles.setsize"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Bubbles_Dungeon",
        name = L("showBubblesInDungeon", "Dungeon frames"),
        description = LDesc("showBubblesInDungeonDESC", "Show translated bubbles as dungeon frames."),
        categoryKey = "Bubbles",
        setting = MakeBoolSetting("bubbles.dungeon"),
      }),
    }

    self:AddModule(bubbles)
  end

  -- MOVIES
  do
    local movies = MakeBoolModule({
      dbKey = "WOWTR_Movies",
      name = L("activateSubtitleTranslations", "Enable subtitles"),
      description = LDesc("activateSubtitleTranslationsDESC", "Show translated subtitles for movies/cinematics."),
      categoryKey = "Movies",
      setting = MakeBoolSetting("movies.active"),
    })

    movies.subOptions = {
      MakeBoolModule({
        dbKey = "WOWTR_Movies_Intro",
        name = L("subtitleIntro", "Intro"),
        description = LDesc("subtitleIntroDESC", "Show translated intro subtitles."),
        categoryKey = "Movies",
        setting = MakeBoolSetting("movies.intro"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Movies_Movie",
        name = L("subtitleMovies", "Movies"),
        description = LDesc("subtitleMoviesDESC", "Show translated movie subtitles."),
        categoryKey = "Movies",
        setting = MakeBoolSetting("movies.movie"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Movies_Cinematic",
        name = L("subtitleCinematics", "Cinematics"),
        description = LDesc("subtitleCinematicsDESC", "Show translated cinematic subtitles."),
        categoryKey = "Movies",
        setting = MakeBoolSetting("movies.cinematic"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Movies_Save",
        name = L("saveUntranslatedSubtitles", "Save untranslated"),
        description = LDesc("saveUntranslatedSubtitlesDESC", "Save missing subtitle lines for later translation."),
        categoryKey = "Movies",
        setting = MakeBoolSetting("movies.save"),
      }),
    }

    self:AddModule(movies)
  end

  -- BOOKS
  do
    local books = MakeBoolModule({
      dbKey = "WOWTR_Books",
      name = L("activateBooksTranslations", "Enable books"),
      description = LDesc("activateBooksTranslationsDESC", "Translate in-game books/letters."),
      categoryKey = "Books",
      setting = MakeBoolSetting("books.active"),
    })

    books.subOptions = {
      MakeBoolModule({
        dbKey = "WOWTR_Books_Title",
        name = L("translateBookTitles", "Translate titles"),
        description = LDesc("translateBookTitlesDESC", "Translate book titles."),
        categoryKey = "Books",
        setting = MakeBoolSetting("books.title"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Books_ShowID",
        name = L("showBookID", "Show ID"),
        description = LDesc("showBookIDDESC", "Show book ID in the title."),
        categoryKey = "Books",
        setting = MakeBoolSetting("books.showID"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Books_SetSize",
        name = L("setFontActivate", "Set font size"),
        description = LDesc("setFontActivateDESC", "Enable custom font size."),
        categoryKey = "Books",
        setting = MakeBoolSetting("books.setsize"),
      }),
      MakeBoolModule({
        dbKey = "WOWTR_Books_SaveNW",
        name = L("saveUntranslatedBooks", "Save untranslated"),
        description = LDesc("saveUntranslatedBooksDESC", "Save missing book lines for later translation."),
        categoryKey = "Books",
        setting = MakeBoolSetting("books.saveNW"),
      }),
    }

    self:AddModule(books)
  end

  -- CHAT (Arabic)
  do
    local chat = MakeBoolModule({
      dbKey = "WOWTR_ChatAR",
      name = L("activateChatService", "Enable Arabic chat"),
      description = LDesc("activateChatServiceDESC", "Enable Arabic chat input helpers."),
      categoryKey = "Chat",
      setting = MakeBoolSetting("chatAR.active"),
    })

    chat.subOptions = {
      MakeBoolModule({
        dbKey = "WOWTR_ChatAR_SetSize",
        name = L("chatFontActivate", "Set font size"),
        description = LDesc("chatFontActivateDESC", "Enable custom font size for Arabic chat."),
        categoryKey = "Chat",
        setting = MakeBoolSetting("chatAR.setsize"),
      }),
    }

    self:AddModule(chat)
  end

  -- ABOUT (placeholder; virtual entry)
  do
    local about = {
      dbKey = "WOWTR_About",
      name = L("ControlCenter_About_Title", "About"),
      description = LDesc("ControlCenter_About_Desc", "WoWLang / WoWAR settings and info."),
      categoryKeys = { "About" },
      isValid = true,
      virtual = true,
    }
    self:AddModule(about)
  end
end

function ControlCenter:InitializeModules()
  if not self.registryBuilt then
    RegisterDefaultModules(self)
    self.registryBuilt = true
  end

  if not self.changelogsBuilt then
    -- Convert WOWTR.Changelog.entries (locale pack) into ControlCenter.changelogs for the Release Notes tab.
    local entries = WOWTR and WOWTR.Changelog and WOWTR.Changelog.entries
    if type(entries) == "table" then
      wipe(self.changelogs)

      local function VersionToID(versionText)
        versionText = tostring(versionText or "")
        local major, minor, patch = versionText:match("^(%d+)%.(%d+)%.*(%d*)$")
        major = tonumber(major)
        minor = tonumber(minor)
        patch = tonumber(patch) or 0
        if not (major and minor) then
          return nil
        end
        return tonumber(string.format("%d%02d%02d", major, minor, patch))
      end

      local function iterLines(text)
        return string.gmatch((text or "") .. "\n", "(.-)\n")
      end

      local MONTH_ABBR_TO_NUM = {
        Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
        Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12,
      }

      -- Parse hardcoded changelog dates like "05 Sep 2025" (preferred) or "2025-09-05".
      local function ParseChangelogDateToTimestamp(dateText)
        dateText = tostring(dateText or "")
        local d, mon, y = dateText:match("^(%d%d?)%s+([%a]+)%s+(%d%d%d%d)$")
        if d and mon and y then
          mon = mon:sub(1, 1):upper() .. mon:sub(2, 3):lower()
          local m = MONTH_ABBR_TO_NUM[mon]
          if m then
            return time({ year = tonumber(y), month = m, day = tonumber(d), hour = 12 })
          end
        end

        local y2, m2, d2 = dateText:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
        if y2 and m2 and d2 then
          return time({ year = tonumber(y2), month = tonumber(m2), day = tonumber(d2), hour = 12 })
        end

        return nil
      end

      for _, e in ipairs(entries) do
        local id = VersionToID(e.version) or tonumber(e.version)
        if id then
          local list = {}

          local dateText = tostring(e.date or "")
          local ts = ParseChangelogDateToTimestamp(dateText) or time()
          list[#list + 1] = {
            type = "date",
            versionText = tostring(e.version or ""),
            timestamp = ts,
            dateText = dateText,
          }

          if e.title and e.title ~= "" then
            list[#list + 1] = { type = "h1", text = tostring(e.title) }
          elseif e.type and e.type ~= "" then
            list[#list + 1] = { type = "h1", text = tostring(e.type) }
          end

          local desc = tostring(e.description or "")
          for line in iterLines(desc) do
            if line == "" then
              list[#list + 1] = { type = "br" }
            else
              local bulletText = line:match("^%s*[-*]%s+(.+)$")
              if bulletText then
                list[#list + 1] = { type = "p", bullet = true, text = bulletText }
              else
                list[#list + 1] = { type = "p", text = line }
              end
            end
          end

          self.changelogs[id] = list
        end
      end
    end

    self.changelogsBuilt = true
  end

  -- In WoWLang, all settings exist in AceDB and are valid on all clients.
  for _, moduleData in ipairs(self.modules) do
    moduleData.isValid = true
  end

  self:ClearFilterCache()
end


