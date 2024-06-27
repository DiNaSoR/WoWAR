-- Addon: WoWAR (version: 10.L12) 2024.04.16
-- Description: Texts in the selected localization language
-- Autor: Platine
-- E-mail: platine.wow@gmail.com

---------------------------------------------------------------------------------------------------------

WoWTR_Localization = {
   lang = "AR",
   started = "started",                                              -- addon was started
   mainFolder = "Interface\\AddOns\\WoWAR",                          -- main folder for addon files
   addonName = "WoWAR",                                              -- short name of the addon                                       -- version of the addon
   addonIconDesc = "ﺍﻧﻘﺮ , ﻟﻔﺘﺢ ﻗﺎﺋﻤﺔ ﺍﻹﻋﺪﺍﺩﺍﺕ.",                    -- Click to open the settings menu
   optionName = "WoWAR - Options",                                   -- WoWAR - options
   optionTitle = "ﺇﺿﺎﻓﺔ ﻭﺍﻭ ﺑﺎﻟﻌﺮﺑﻲ",                                -- WoWAR Patch
   optionTitleAR = "ﻣﻠﺤﻖ RAWoW ﺑﺎﻟﻠﻐﺔ ﺍﻟﻌﺮﺑﻴﺔ، baranogarD & enitalP، )C( 4202-3202",  -- Main title of addon in Arabic
   addressWWW = "https://www.WoWinArabic.com",                       -- address of project page
   addressDiscord = "https://discord.gg/uW5NJ6y",                    -- address of discord page
   addressTwitch = "",                                               -- address of Twitch page 
   addressFanPage = "",                                              -- address of FanPage 
   addressEmail = "dragonarab@gmail.com",                            -- address of project e-mail
   addressCurse = "https://www.curseforge.com/wow/addons/wowinarabic-quests",         -- address of CurseForge page
   addressPayPal = "https://www.paypal.com/donate/?hosted_button_id=FC2NVQ5DN7GVA",   -- address of PayPal page
   addressBlik = "",                                                 -- telephon number for BLIK payment
   gossipText = "ﻧﺺ ﺍﻟﺸﺎﺋﻌﺎﺕ",                                       -- gossip text
   quests = "ﺍﻟﻤﻬﺎﻡ",                                                -- Quests
   campaignquests = "ﺍﻟﺤﻤﻼﺕ",                                       -- Campaign Quests
   scenariodung = "ﺍﻟﺪﻫﻠﻴﺰ",                                         -- Scenario/Dungeon
   objectives = "اﻷﻫﺪاف",                                             -- Objectives
   rewards = "اﻟﻤﻜﺎﻓﺌﺔ",                                              -- Rewards
   storyLineProgress = "ﻣﺮﺍﺣﻞ ﺗﻘﺪﻡ ﺍﻟﻘﺼﺔ",                           -- StoryLine Progress
   storyLineChapters = "ﻓﺼﻮﻝ ﺍﻟﻘﺼﺔ",                                 -- StoryLine Chapters
   choiceQuestFirst = "ﺃﺧﺘﺮ ﺍﻟﻤﻬﻤﺔ ﺃﻭﻻ",                             -- choose a quest first
   readyForTurnIn = "ﺟﺎﻫﺰﺓ ﻟﻠﺘﺴﻠﻴﻢ",                                 -- Ready for turn-in
   clickToComplete = "ﺍﻧﻘﺮ ﻟﻺﻛﻤﺎﻝ",                                  -- click to complete
   failed = "ﻓﺸﻞ",                                                   -- Failed
   optional = "ﺍﺧﺘﻴﺎﺭﻱ",                                             -- Optional
   emptyProgress = "ﺃﻧﺖ ﺗﻘﻮﻡ ﺑﻌﻤﻞ ﺟﻴﺪ, YOUR_NAME",                   -- You are doing well, $N
   bookID = "ﺭﻗﻢ ﺍﻟﻜﺘﺎﺏ:",                                           -- Book ID:
   stopTheMovie = "ﺗﺮﻳﺪ ﺇﻳﻘﺎﻑ ﺍﻟﻔﻴﺪﻳﻮ ؟",                            -- Do you want to stop the video?
   stopTheMovieYes = "ﻧﻌﻢ",                                          -- Yes
   stopTheMovieNo = "ﻻ",                                             -- No
   reopenBoard = "ﺇﻋﺎﺩﺓ ﻓﺘﺢ ﻟﻮﺣﺔ ﺍﻹﻋﻼﻧﺎﺕ",                           -- Reopen the Bulletin Board
   sellPrice = "اﻟﺴﻌﺮ:",                                         -- Sell price:
   currentlyEquipped = "ﻣﺮﺗﺪﻱ ﺣﺎﻟﻴﺎ",                                -- Currently Equipped
   additionalEquipped = "ﻣﺮﺗﺪﻱ ﻣﻌﺪﺍﺕ ﺇﺿﺎﻓﻴﺔ",                        -- Equipped with additional Equipment
   WoWTR_Talent_trDESC = "ﺍﻟﻤﻬﺎﺭﺍﺕ: ﺑﺎﻟﻌﺮﺑﻲ",                        -- Talents: Arabic
   WoWTR_Talent_enDESC = "Talents: English",                         -- Talents: English
   WoWTR_Spellbook_trDESC = "ﺍﻟﻘﺪﺭﺍﺕ: ﺑﺎﻟﻌﺮﺑﻲ",                      -- Spell Book: Arabic
   WoWTR_Spellbook_enDESC = "Spell Book: English",                   -- Spell Book: English
   your_home = "ﻣﻨﺰﻟﻚ",                                              -- 'your home' (if the Hearthstone location fails to be read)
   welcomeIconPos = 255,                                             -- position of welcome icon on the welcom panel; 0 = disabled to display
   resetButton1 = "ﻣﺴﺢ ﺍﻟﺴﺠﻼﺕ ﺍﻟﻤﺨﺰﻧﺔ ﻓﻲ ﻣﻠﻒ aul.RAWoW",             -- Clear saved untranslated texts (no Arabic font)
   resetButton2 = "ﺇﻋﺎﺩﺓ ﺿﺒﻂ ﺇﻋﺪﺍﺩﺍﺕ ﺍﻹﺿﺎﻓﺔ",                        -- Restore the extension to its default settings (no Arabic font)
   resetButton1Opis = "ﻣﺴﺢ ﺍﻟﻨﺼﻮﺹ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ ﺍﻟﻤﺤﻔﻮﻇﺔ",            -- Clear saved untranslated text (as a hint)
   resetButton1OpisDESC = "ﺳﻴﺘﻢ ﺣﺬﻑ ﺟﻤﻴﻊ ﺍﻟﺒﻴﺎﻧﺎﺕ ﺍﻟﻤﺤﻔﻮﻇﺔ ﻓﻲ ﺍﻟﻠﻌﺒﺔ",  -- Clear saved untranslated texts (as a hint)
   resetButton2Opis = "ﺇﻋﺎﺩﺓ ﺍﻹﺿﺎﻓﺔ ﺇﻟﻰ ﺇﻋﺪﺍﺩﺍﺗﻬﺎ ﺍﻻﻓﺘﺮﺍﺿﻴﺔ",           -- Restore the extension to its default settings (as a tip)
   resetButton2OpisDESC = "ﺳﻴﺘﻢ ﺇﻋﺎﺩﺓ ﺇﻋﺪﺍﺩﺍﺕ ﺍﻹﺿﺎﻓﺔ ﺇﻟﻰ ﺍﻟﻮﺿﻊ ﺍﻻﻓﺘﺮﺍﺿﻲ \n)ﻭﺳﻴﺘﻢ ﺇﻋﺎﺩﺓ ﺗﺤﻤﻴﻞ ﺍﻟﻮﺍﺟﻬﺔ(",
   resultButton1 = "ﺗﻢ ﻣﺴﺢ ﺍﻟﻨﺼﻮﺹ ﺍﻟﻤﺨﺰﻧﺔ",                             -- Saved texts have been erased
   confirmationHeader = "ﺗﺄﻛﻴﺪ",                                        -- Confirmation
   confirmationText1 = "ﻫﻞ ﺗﺮﻏﺐ ﻓﻲ ﻣﺴﺢ ﺟﻤﻴﻊ ﺍﻟﺴﺠﻼﺕ ﺍﻟﻤﺤﻔﻮﻇﺔ؟",          -- Do you want to clear all saved untranslated texts?
   confirmationText2 = "ﻫﻞ ﺗﺮﻏﺐ ﻓﻲ ﺇﻋﺎﺩﺓ ﺗﺤﻤﻴﻞ ﺍﻹﺿﺎﻓﺔ ﺇﻟﻰ ﺇﻋﺪﺍﺩﺍﺗﻬﺎ ﺍﻻﻓﺘﺮﺍﺿﻴﺔ؟\n(ﺳﻴﺘﻢ ﺇﻋﺎﺩﺓ ﺗﺤﻤﻴﻞ ﺍﻟﻮﺍﺟﻬﺔ)",   -- Do you want to restore the addon's default settings?
   moveFrameUpDown = "ﺣﺮﻙ ﺍﻟﻨﺎﻓﺬﺓ ﻷﻋﻠﻰ ﺃﻭ ﻷﺳﻔﻞ",                        -- Move the window up or down
};

---------------------------------------------------------------------------------------------------------

QTR_Messages = {
   isactive          = "ﻓﻌﺎﻝ", -- jest aktywny (is active)
   isinactive        = "ﻏﻴﺮ ﻓﻌﺎﻝ", -- jest nieaktywny (is inactive)
   missing           = "ﺑﺪﻭﻥ ﺗﺮﺟﻤﺔ", -- brak tłumaczenia (no translation)
   details           = "اﻟﻮﺻﻒ", -- Opis (Description)
   progress          = "ﺗﻘﺪﻡ", -- Postęp (Progress)
   objectives        = "اﻷﻫﺪاف", -- Cele zadania (Objectives)
   completion        = "ﺇﻛﻤﺎﻝ", -- Zakończenie (Completion)
   translator        = "ﻣﺘﺮﺟﻢ", -- Tłumaczenie (Translator)
   rewards           = "اﻟﻤﻜﺎﻓﺌﺎت", -- Nagrody (Rewards)
   experience        = "ﺍﻟﺨﺒﺮﺓ:", -- Doświadczenie (Experience)
   reqmoney          = "ﺍﻟﻤﺎﻝ ﺍﻟﻤﻄﻠﻮﺏ", -- Wymagane pieniądze (Required money)
   reqitems          = "اﻟﻌﻨﺎﺻﺮ اﻟﻤﻄﻠﻮﺑﺔ", -- Wymagane przedmioty (Required items)
   itemchoose0       = "ﺳﺘﺴﺘﻠﻢ:", -- Otrzymasz: (You will receive:)
   itemchoose1       = "اﺧﺘﺮ اﻟﻤﻜﺎﻓﺄة:", -- Możesz wybrać jedną z nagród: (You will be able to choose one of these rewards:)
   itemchoose2       = "اﺧﺘﺮ اﻟﻤﻜﺎﻓﺄة:", -- Wybierz jedną z nagród: (Choose one of these rewards:)
   itemchoose3       = "ﺳﺘﺄﺧﺬ اﻟﻤﻜﺎﻓﺄة:", -- Otrzymujesz nagrodę: (You receiving the reward:)
   itemreceiv0       = "ﺳﺘﺴﺘﻠﻢ", -- Otrzymasz: (You will receive:)
   itemreceiv1       = "ﺃﻳﻀﺎ ﺳﻮﻑ ﺗﺄﺧﺬ:", -- Otrzymasz również: (You will also receive:)
   itemreceiv2       = "اﻟﻤﻜﺎﻓﺄة:", -- Otrzymujesz nagrodę: (You receiving the reward:)
   itemreceiv3       = "اﻟﻤﻜﺎﻓﺄة:", -- Otrzymujesz również nagrodę: (You also receiving the reward:)
   learnspell        = "ﺗﻌﻠﻢ ﺍﻟﺴﺤﺮ:", -- Naucz się zaklęcia: (Learn Spell:)
   currquests        = "اﻟﻤﻬﺎم اﻟﺤﺎﻟﻴﺔ:", -- Bieżące zadania (Current Quests)
   avaiquests        = "اﻟﻤﻬﺎم اﻟﻤﺘﻮﻓﺮة:", -- Dostępne zadania (Available Quests)
   reward_aura       = "ﻣﺎ ﻳﻠﻲ ﺳﻮﻑ ﻳﻠﻘﻲ ﻋﻠﻴﻚ:", -- Otrzymasz efekt: (The following will be cast on you:)
   reward_spell      = "ﺳﻮﻑ ﺗﺘﻌﻠﻢ ﻣﺎ ﻳﻠﻲ:", -- Nauczysz się: (You will learn the following:)
   reward_companion  = "ﺳﺘﻨﺎﻝ ﻫﺆﻻﺀ ﺍﻟﺮﻓﺎﻕ:", -- Zyskasz towarzyszy: (You will gain these Companions:)
   reward_follower   = "ﺳﻮﻑ ﺗﺄﺧﺬ ﻫﺆﻻﺀ ﺍﻟﺘﺎﺑﻌﻴﻦ:", -- Zyskasz zwolenników: (You will gain these followers:)
   reward_reputation = "ﺟﻮﺍﺋﺰ ﺍﻟﺴﻤﻌﺔ:", -- Wzrost reputacji: (Reputation awards:)
   reward_title      = "ﺳﻮﻑ ﺗﺤﺼﻞ ﻋﻠﻰ ﺍﻟﻠﻘﺐ:", -- Otrzymasz tytuł: (You shall be granted the title:)
   reward_tradeskill = "ﺳﻮﻑ ﺗﺘﻌﻠﻢ ﻛﻴﻔﻴﺔ ﺇﻧﺸﺎﺀ:", -- Nauczysz się wytwarzania: (You will learn how to create:)
   reward_unlock     = "ﺳﺘﻔﺘﺢ ﺍﻟﻮﺻﻮﻝ ﺇﻟﻰ ﺍﻟﺘﺎﻟﻲ:", -- Odblokujesz: (You will unlock access to the following:)
   reward_bonus      = "ﻗﺪ ﻳﻜﺎﻓﺊ ﺇﻛﻤﺎﻝ ﻫﺬﻩ ﺍﻟﻤﻬﻤﺔ ﺃﺛﻨﺎﺀ ﻭﺟﻮﺩﻙ ﻓﻲ ﺍﻟﻔﺮﻳﻖ:", -- Ukończenie tego zadania, gdy jesteś w grupie, może cię nagrodzić: (Completing this quest while in Party Sync may reward:)
};

---------------------------------------------------------------------------------------------------------

WoWTR_Config_Interface = {
   showMinimapIcon = "ﻋﺮﺽ ﺭﻣﺰ ﺇﻋﺪﺍﺩﺍﺕ ﺍﻹﺿﺎﻓﺔ ﺑﺠﺎﻧﺐ ﺍﻟﺨﺮﻳﻄﺔ ﺍﻟﻤﺼﻐﺮﺓ",
   showMinimapIconDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﻈﻬﺮ ﺭﻣﺰ ﺇﻋﺪﺍﺩﺍﺕ ﺍﻹﺿﺎﻓﺔ ﺑﺠﻮﺍﺭ ﺍﻟﺨﺮﻳﻄﺔ ﺍﻟﻤﺼﻐﺮﺓ.",
   
   titleTab1 = "ﺍﻟﻤﻬﺎﻡ",
   generalMainHeaderQS = "ﺗﺮﺟﻤﺎﺕ ﺍﻟﻤﻬﺎﻡ - stseuQ",
   activateQuestsTranslations = "ﺗﻔﻌﻴﻞ ﺗﺮﺟﻤﺎﺕ ﺍﻟﻤﻬﺎﻡ",
   activateQuestsTranslationsDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺎﺕ ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   translateQuestTitles = "ﻋﺮﺽ ﻋﻨﺎﻭﻳﻦ ﺍﻟﻤﻬﺎﻡ ﺑﺎﻟﻌﺮﺑﻴﺔ",
   translateQuestTitlesDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ ﺍﻟﻌﻨﺎﻭﻳﻦ ﻓﻘﻂ ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   translateGossipTexts = "ﻋﺮﺽ ﻧﺼﻮﺹ ﺍﻟﺤﻮﺍﺭﺍﺕ CPN ﺑﺎﻟﻌﺮﺑﻴﺔ",
   translateGossipTextsDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   translateTrackObjectives = "ﻋﺮﺽ ﺗﺮﺟﻤﺔ ﻗﺎﺋﻤﺔ ﺗﺘﺒﻊ ﺍﻟﻤﻬﺎﻡ ﺑﺎﻟﻌﺮﺑﻴﺔ",
   translateTrackObjectivesDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ ﺑﺤﺎﻟﺘﻬﺎ ﺍﻷﺻﻠﻴﺔ",
   translateOwnNames = "ﻋﺮﺽ ﺃﺳﻤﺎﺀ ﺍﻷﻣﺎﻛﻦ ﺑﺎﻟﻌﺮﺑﻴﺔ - 002DFFFFc|)ﻏﻴﺮ ﻧﺸﻂ ﺍﻵﻥ(r|",
   translateOwnNamesDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺃﺳﻤﺎﺀ ﺍﻟﻤﺪﻥ ﻭﺍﻷﻣﺎﻛﻦ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   savingUntranslatedQuests = "ﺧﻴﺎﺭﺍﺕ ﺍﻟﺤﻔﻆ",
   saveUntranslatedQuests = "ﺣﻔﻆ ﺍﻟﻤﻬﺎﻡ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   saveUntranslatedQuestsDESC = "ﺇﺿﺎﻓﺔ ﺍﻟﺒﻴﺎﻧﺎﺕ ﺇﻟﻰ ﻣﻠﻒ ﺍﻟﺤﻔﻆ",
   saveUntranslatedGossip = "ﺣﻔﻆ ﺣﻮﺍﺭﺍﺕ CPN ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   saveUntranslatedGossipDESC = "ﺇﺿﺎﻓﺔ ﺍﻟﺒﻴﺎﻧﺎﺕ ﺇﻟﻰ ﻣﻠﻒ ﺍﻟﺤﻔﻆ",
   integrationWithOtherAddons = "ﺍﻟﺘﻜﺎﻣﻞ",
   translateImmersion = "ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺎﺕ ﻓﻲ ﺇﺿﺎﻓﺔ noisremmI",
   translateImmersionDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ noisremmI ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   translateStoryLine = "ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺎﺕ ﻓﻲ ﺇﺿﺎﻓﺔ eniLyrotS",
   translateStoryLineDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ eniLyrotS ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   translateQuestLog = "ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺎﺕ ﻓﻲ ﺇﺿﺎﻓﺔ goL tseuQ cissalC",
   translateQuestLogDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ goL tseuQ cissalC ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   translateDialogueUI = "ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺎﺕ ﻓﻲ ﺇﺿﺎﻓﺔ IUeuqolaiD",
   translateDialogueUIDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ IUeuqolaiD ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   sampleGossipText = "ﻧﻤﻮﺫﺝ ﺣﺠﻢ ﺍﻟﺨﻂ ﻟﻨﺺ ﺍﻟﺤﻮﺍﺭﺍﺕ CPN",
   
   titleTab2 = "ﺍﻟﻔﻘﺎﻋﺎﺕ",
   generalMainHeaderBB = "ﺗﺮﺟﻤﺎﺕ ﺍﻟﻔﻘﺎﻋﺎﺕ - selbbuB",
   activateBubblesTranslations = "ﺗﻔﻌﻴﻞ ﺗﺮﺟﻤﺎﺕ ﺍﻟﻔﻘﺎﻋﺎﺕ",
   activateBubblesTranslationsDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺎﺕ ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   displayOriginalTexts = "ﻋﺮﺽ ﺍﻟﻨﺺ ﺍﻷﺻﻠﻲ ﻓﻲ ﻧﺎﻓﺬﺓ ﺍﻟﺪﺭﺩﺷﺔ",
   displayOriginalTextsDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﻟﻦ ﻳﻈﻬﺮ ﺍﻟﻨﺺ ﺍﻷﺻﻠﻲ ﻓﻲ ﻧﺎﻓﺬﺓ ﺍﻟﺪﺭﺩﺷﺔ",
   displayTranslatedTexts = "ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺔ اﻟﻌﺮﺑﻴﺔ ﻓﻲ ﻧﺎﻓﺬﺓ ﺍﻟﺪﺭﺩﺷﺔ",
   displayTranslatedTextsDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﻟﻦ ﺗﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺔ ﻓﻲ ﻧﺎﻓﺬﺓ ﺍﻟﺪﺭﺩﺷﺔ",
   choiceGender1OfPlayer = "ﺍﺳﺘﺨﺪﺍﻡ ﺍﻟﻌﺒﺎﺭﺍﺕ ﺍﻟﻤﻮﺟﻬﺔ ﻟﻼﻋﺒﻴﻦ ﺍﻟﺬﻛﻮﺭ",
   choiceGender1OfPlayerDESC = "ﺍﻟﺘﻔﺎﻋﻞ ﻣﻊ CPN ﻛﻤﺎ ﻟﻮ ﻛﻨﺖ ﻻﻋﺒﺎ ﺫﻛﺮﺍ",
   choiceGender2OfPlayer = "ﺍﺳﺘﺨﺪﺍﻡ ﺍﻟﻌﺒﺎﺭﺍﺕ ﺍﻟﻤﻮﺟﻬﺔ ﻟﻼﻋﺒﺎﺕ ﺍﻹﻧﺎﺙ",
   choiceGender2OfPlayerDESC = "ﺍﻟﺘﻔﺎﻋﻞ ﻣﻊ CPN ﻛﻤﺎ ﻟﻮ ﻛﻨﺖ ﻻﻋﺒﺔ ﺃﻧﺜﻰ",
   choiceGender3OfPlayer = "ﺍﺳﺘﺨﺪﺍﻡ ﺍﻟﻌﺒﺎﺭﺍﺕ ﺑﻨﺎﺀ ﻋﻠﻰ ﺟﻨﺲ ﺍﻟﺸﺨﺼﻴﺔ",
   choiceGender3OfPlayerDESC = "ﺗﻔﺎﻋﻞ CPN ﺑﻨﺎﺀ ﻋﻠﻰ ﺟﻨﺲ ﺷﺨﺼﻴﺘﻚ",
   showBubblesInDungeon = "ﺇﻇﻬﺎﺭ ﻓﻘﺎﻋﺎﺕ ﺍﻟﻜﻼﻡ ﻓﻲ ﺍﻷﺑﺮﺍﺝ ﺍﻟﻤﺤﺼﻨﺔ",
   showBubblesInDungeonDESC = "ﺇﺫﺍ ﺗﻢ ﺗﺤﺪﻳﺪﻫﺎ، ﺳﻴﺘﻢ ﻋﺮﺽ ﻓﻘﺎﻋﺎﺕ ﺍﻟﺰﻧﺰﺍﻧﺔ ﻓﻲ 5 ﺇﻃﺎﺭﺍﺕ ﺧﺎﺻﺔ ﺑﻬﺎ ﻓﻲ ﺍﻟﺠﺰﺀ ﺍﻟﻌﻠﻮﻱ ﻣﻦ ﺍﻟﺸﺎﺷﺔ",
   setDungeonFrames = "ﻗﻢ ﺑﺈﻋﺪﺍﺩ ﻧﻮﺍﻓﺬ ﺍﻟﻔﻘﺎﻋﺎﺕ ﺍﻟﻜﻼﻣﻴﺔ",
   setDungeonFramesDESC = "ﻋﻨﺪ ﺗﺤﺪﻳﺪ ﻫﺬﺍ ﺍﻟﺨﻴﺎﺭ، ﺳﺘﺘﻤﻜﻦ ﻣﻦ ﻣﺤﺎﺫﺍﺓ ﻧﻮﺍﻓﺬ ﺍﻟﻔﻘﺎﻋﺎﺕ ﻓﻲ ﺍﻟﺰﻧﺰﺍﻧﺎﺕ ﻋﻤﻮﺩﻳﺎ",
   savingUntranslatedBubbles = "ﺧﻴﺎﺭﺍﺕ ﺍﻟﺤﻔﻆ",
   saveUntranslatedBubbles = "ﺣﻔﻆ ﺍﻟﻔﻘﺎﻋﺎﺕ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   saveUntranslatedBubblesDESC = "ﺇﺿﺎﻓﺔ ﺍﻟﺒﻴﺎﻧﺎﺕ ﺇﻟﻰ ﻣﻠﻒ ﺍﻟﺤﻔﻆ",
   fontSizeHeader = "ﺣﺠﻢ ﺍﻟﺨﻂ",
   setFontActivate = "ﺗﻔﻌﻴﻞ ﺗﻐﻴﻴﺮ ﺣﺠﻢ ﺍﻟﺨﻂ",
   setFontActivateDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﻳﺘﻢ ﺗﻌﺪﻳﻞ ﺣﺠﻢ ﺍﻟﺨﻂ ﻭﻓﻘﺎ ﻻﺧﺘﻴﺎﺭﻙ",
   fontsizeBubbles = "ﺍﺧﺘﺮ ﺣﺠﻢ ﺍﻟﺨﻂ",
   fontsizeBubblesDESC = "ﻳﻤﻜﻨﻚ ﺍﺧﺘﻴﺎﺭ ﺣﺠﻢ ﻳﺘﺮﺍﻭﺡ ﺑﻴﻦ 10 ﻭ20",
   sampleText = "ﻧﻤﻮﺫﺝ ﻧﺺ ﺣﺠﻢ ﺍﻟﺨﻂ",
   timerDisplay = "ﻭﻗﺖ ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺔ",
   
   titleTab3 = "ﺍﻟﺘﺮﺟﻤﺎﺕ",
   generalMainHeaderMF = "ﺗﺮﺟﻤﺎﺕ ﺍﻷﻓﻼﻡ ﻭﺍﻟﻌﺮﻭﺽ ﺍﻟﺴﻴﻨﻤﺎﺋﻴﺔ - seltitbuS",
   activateSubtitleTranslations = "ﺗﻔﻌﻴﻞ ﺗﺮﺟﻤﺎﺕ ﺍﻷﻓﻼﻡ ﻭﺍﻟﻌﺮﻭﺽ ﺍﻟﺴﻴﻨﻤﺎﺋﻴﺔ",
   activateSubtitleTranslationsDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﻟﻦ ﺗﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺎﺕ",
   subtitleIntro = "ﻋﺮﺽ ﺗﺮﺟﻤﺎﺕ ﺍﻟﻤﺸﺎﻫﺪ ﺍﻟﺘﻤﻬﻴﺪﻳﺔ",
   subtitleIntroDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺎﺕ ﻓﻲ ﻣﻘﺪﻣﺔ ﺍﻷﻓﻼﻡ ﻭﺍﻟﻌﺮﻭﺽ ﺍﻟﺴﻴﻨﻤﺎﺋﻴﺔ",
   subtitleMovies = "ﻋﺮﺽ ﺗﺮﺟﻤﺎﺕ ﺍﻟﻤﺸﺎﻫﺪ ﺍﻟﺴﻴﻨﻤﺎﺋﻴﺔ",
   subtitleMoviesDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺎﺕ ﻓﻲ ﺍﻷﻓﻼﻡ",
   subtitleCinematics = "ﻋﺮﺽ ﺗﺮﺟﻤﺎﺕ ﺍﻟﻌﺮﻭﺽ ﺍﻟﺴﻴﻨﻤﺎﺋﻴﺔ",
   subtitleCinematicsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺎﺕ ﻓﻲ ﺍﻟﻌﺮﻭﺽ ﺍﻟﺴﻴﻨﻤﺎﺋﻴﺔ",
   savingUntranslatedSubtitles = "ﺧﻴﺎﺭﺍﺕ ﺍﻟﺤﻔﻆ",
   saveUntranslatedSubtitles = "ﺣﻔﻆ ﺍﻟﺘﺮﺟﻤﺎﺕ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   saveUntranslatedSubtitlesDESC = "ﺇﺿﺎﻓﺔ ﺍﻟﺒﻴﺎﻧﺎﺕ ﺇﻟﻰ ﻣﻠﻒ ﺍﻟﺤﻔﻆ",
   chatService = "اﻟﻜﺘﺎﺑﺔ ﺑﺎﻟﻠﻐﺔ اﻟﻌﺮﺑﻴﺔ ﻓﻲ اﻟﺸﺎت - tahC",
   activateChatService = "ﺗﻔﻌﻴﻞ ﺧﺎﺻﻴﺔ اﻟﻜﺘﺎﺑﺔ ﺑﺎﻟﻠﻐﺔ اﻟﻌﺮﺑﻴﺔ",
   activateChatServiceDESC = "ﻋﻨﺪ اﻟﺘﻔﻌﻴﻞ ﻳﻤﻜﻨﻚ اﻟﻜﺘﺎﺑﺔ ﺑﺎﻟﻌﺮﺑﻲ",
   chatFontActivate = "ﺗﻔﻌﻴﻞ ﺗﻐﻴﻴﺮ ﺣﺠﻢ ﺍﻟﺨﻂ",
   chatFontActivateDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﻳﺘﻢ ﺗﻌﺪﻳﻞ ﺣﺠﻢ ﺍﻟﺨﻂ ﻭﻓﻘﺎ ﻻﺧﺘﻴﺎﺭﻙ",
   fontsizeChat = "ﺍﺧﺘﺮ ﺣﺠﻢ ﺍﻟﺨﻂ",
   fontsizeChatDESC = "ﻳﻤﻜﻨﻚ ﺍﺧﺘﻴﺎﺭ ﺣﺠﻢ ﻳﺘﺮﺍﻭﺡ ﺑﻴﻦ 10 ﻭ20",
   
   titleTab4 = "ﺇﻋﺪﺍﺩﺍﺕ ﺍﻟﻮﺍﺟﻬﺔ",
   generalMainHeaderTT = "ﺗﺮﺟﻤﺎﺕ ﺍﻟﺪﺭﻭﺱ ﺍﻟﺘﻌﻠﻴﻤﻴﺔ - slairotuT",
   activateTutorialTranslations = "ﺗﻔﻌﻴﻞ ﺗﺮﺟﻤﺎﺕ ﺍﻟﺪﺭﻭﺱ ﺍﻟﺘﻌﻠﻴﻤﻴﺔ",
   activateTutorialTranslationsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﺪﺭﻭﺱ ﺍﻟﺘﻌﻠﻴﻤﻴﺔ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   savingUntranslatedTutorials = "ﺧﻴﺎﺭﺍﺕ ﺍﻟﺤﻔﻆ",
   saveUntranslatedTutorials = "ﺣﻔﻆ ﺍﻟﻤﺪﺭﺱ ﺍﻟﺘﻌﻠﻴﻤﻴﺔ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   saveUntranslatedTutorialsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﺣﻔﻆ ﺍﻟﺪﺭﻭﺱ ﺍﻟﺘﻌﻠﻴﻤﻴﺔ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   fontSelectingFontHeader = "ﺗﺤﺪﻳﺪ ﺍﻟﺨﻂ ﺍﻹﺿﺎﻓﻲ",                                      -- Selecting the add-on font
   fontSelectFontFile = "Select a font file",                                          -- Select a font file
   fontCurrentFont = "ﺍﻟﺨﻂ ﺍﻟﺤﺎﻟﻲ:",                                                   -- Current font:
   
   translationUI = "ﺗﺮﺟﻤﺔ ﻭﺍﺟﻬﺔ ﺍﻟﻤﺴﺘﺨﺪﻡ - IU",
   savingTranslationUI = "ﺧﻴﺎﺭﺍﺕ ﺣﻔﻆ ﻭﺍﺟﻬﺔ ﺍﻟﻤﺴﺘﺨﺪﻡ",
   saveTranslationUI = "ﺣﻔﻆ ﻋﻨﺎﺻﺮ ﻭﺍﺟﻬﺔ ﺍﻟﻤﺴﺘﺨﺪﻡ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   saveTranslationUIDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﺣﻔﻆ ﻋﻨﺎﺻﺮ ﻭﺍﺟﻬﺔ ﺍﻟﻤﺴﺘﺨﺪﻡ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   ReloadButtonUI = "ﺍﺿﻐﻂ ﻟﺘﻄﺒﻴﻖ ﺍﻹﻋﺪﺍﺩﺍﺕ ﺇﻋﺎﺩﺓ ﺗﺤﻤﻴﻞ ﻭﺍﺟﻬﺔ ﺍﻟﻤﺴﺘﺨﺪﻡ",
   displayTranslationtxt = "ﺍﺧﺘﺮ ﺍﻟﺘﺮﺟﻤﺎﺕ ﺍﻟﺘﻲ ﺗﺮﻏﺐ ﺑﺘﻔﻌﻴﻠﻬﺎ.",
   displayTranslationUI1 = "ﻗﺎﺋﻤﺔ ﺍﻟﻠﻌﺒﺔ",
   displayTranslationUI1DESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﻗﺎﺋﻤﺔ ﺍﻟﻠﻌﺒﺔ ﻭﻣﺤﺘﻮﻳﺎﺗﻬﺎ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   displayTranslationUI2 = "ﻣﻌﻠﻮﻣﺎﺕ ﺍﻟﺸﺨﺼﻴﺔ",
   displayTranslationUI2DESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﻭﺍﺟﻬﺔ ﻣﻌﻠﻮﻣﺎﺕ ﺍﻟﺸﺨﺼﻴﺔ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   displayTranslationUI3 = "ﺍﻟﺒﺤﺚ ﻋﻦ ﻣﺠﻤﻮﻋﺔ",
   displayTranslationUI3DESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﻭﺍﺟﻬﺔ ﺍﻟﺒﺤﺚ ﻋﻦ ﻣﺠﻤﻮﻋﺔ ﻭﺗﺒﻮﻳﺒﺎﺗﻬﺎ ﺍﻟﻔﺮﻋﻴﺔ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   displayTranslationUI4 = "ﺍﻟﻤﺠﻤﻮﻋﺎﺕ",
   displayTranslationUI4DESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺻﻔﺤﺔ ﺍﻟﻤﺠﻤﻮﻋﺎﺕ ﻭﻣﺤﺘﻮﻳﺎﺗﻬﺎ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   displayTranslationUI5 = "ﺩﻟﻴﻞ ﺍﻟﻤﻐﺎﻣﺮﺍﺕ",
   displayTranslationUI5DESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺩﻟﻴﻞ ﺍﻟﻤﻐﺎﻣﺮﺍﺕ ﻭﺻﻔﺤﺎﺗﻪ ﺍﻟﻔﺮﻋﻴﺔ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   displayTranslationUI6 = "ﻗﺎﺋﻤﺔ ﺍﻷﺻﺪﻗﺎﺀ",
   displayTranslationUI6DESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﻣﺤﺘﻮﻳﺎﺕ ﻗﺎﺋﻤﺔ ﺍﻷﺻﺪﻗﺎﺀ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   displayTranslationUI7 = "ﺍﻟﻤﻬﻦ ﺍﻟﻤﻬﻦ",
   displayTranslationUI7DESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﻭﺍﺟﻬﺔ ﺍﻟﻤﻬﻦ ﻭﻣﺤﺘﻮﻳﺎﺗﻬﺎ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   displayTranslationUI8 = "ﺍﻟﻔﻠﺘﺮ ﻭﺍﻟﻘﻮﺍﺋﻢ ﺍﻟﻤﻨﺴﺪﻟﺔ",
   displayTranslationUI8DESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﻔﻼﺗﺮ ﻭﺍﻟﻘﻮﺍﺋﻢ ﺍﻟﻤﻨﺴﺪﻟﺔ ﺑﺎﻟﻌﺮﺑﻴﺔ.",
   
   titleTab5 = "ﺍﻟﻜﺘﺐ",
   generalMainHeaderBT = "ﺗﺮﺟﻤﺎﺕ ﺍﻟﻜﺘﺐ - skooB",
   activateBooksTranslations = "ﺗﻔﻌﻴﻞ ﺗﺮﺟﻤﺎﺕ ﺍﻟﻜﺘﺐ",
   activateBooksTranslationsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺗﺮﺟﻤﺎﺕ ﺍﻟﻜﺘﺐ ﺑﺪﻻ ﻣﻦ ﺍﻟﻨﺼﻮﺹ ﺍﻷﺻﻠﻴﺔ",
   translateBookTitles = "ﻋﺮﺽ ﺗﺮﺟﻤﺎﺕ ﻋﻨﺎﻭﻳﻦ ﺍﻟﻜﺘﺐ",
   translateBookTitlesDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﺘﻢ ﺗﺮﺟﻤﺔ ﻋﻨﺎﻭﻳﻦ ﺍﻟﻜﺘﺐ",
   showBookID = "ﻋﺮﺽ ﻣﻌﺮﻑ ﺍﻟﻜﺘﺎﺏ",
   showBookIDDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﻋﺮﺽ ﻣﻌﺮﻑ ﺍﻟﻜﺘﺎﺏ",
   savingUntranslatedBooks = "ﺧﻴﺎﺭﺍﺕ ﺍﻟﺤﻔﻆ",
   saveUntranslatedBooks = "ﺣﻔﻆ ﺍﻟﻜﺘﺐ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   saveUntranslatedBooksDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﺣﻔﻆ ﺍﻟﻜﺘﺐ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   
   titleTab6 = "ﺍﻟﺘﻠﻤﻴﺤﺎﺕ",
   generalMainHeaderST = "ﺗﺮﺟﻤﺎﺕ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ - spitlooT",
   activateTooltipTranslations = "ﺗﻔﻌﻴﻞ ﺗﺮﺟﻤﺎﺕ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ",
   activateTooltipTranslationsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   translateItems = "ﻋﺮﺽ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﺍﻟﻤﺘﺮﺟﻤﺔ ﻟﻸﻏﺮﺍﺽ",
   translateItemsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﺍﻟﻤﺘﺮﺟﻤﺔ ﻟﻸﻏﺮﺍﺽ",
   translateSpells = "ﻋﺮﺽ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﺍﻟﻤﺘﺮﺟﻤﺔ ﻟﻠﺘﻌﺎﻭﻳﺬ",
   translateSpellsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﺍﻟﻤﺘﺮﺟﻤﺔ ﻟﻠﺘﻌﺎﻭﻳﺬ",
   translateTalents = "ﻋﺮﺽ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﺍﻟﻤﺘﺮﺟﻤﺔ ﻟﻠﻤﻮﺍﻫﺐ",
   translateTalentsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﺍﻟﻤﺘﺮﺟﻤﺔ ﻟﻠﻤﻮﺍﻫﺐ",
   translateTooltipTitle = "ﻋﺮﺽ ﻋﻨﻮﺍﻥ ﺍﻟﻤﺘﺮﺟﻢ ﻟﻠﻌﻨﺼﺮ ﺃﻭ ﺍﻟﺘﻌﻮﻳﺬﺓ ﺃﻭ ﺍﻟﻤﻮﻫﺒﺔ",
   translateTooltipTitleDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﻋﺮﺽ ﺍﻟﻌﻨﻮﺍﻥ ﺍﻟﻤﺘﺮﺟﻢ ﻟﻠﺘﻠﻤﻴﺤﺎﺕ",
   showTooltipID = "ﻋﺮﺽ ﻣﻌﺮﻑ ﺍﻟﺘﻠﻤﻴﺢ",
   showTooltipIDDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﻋﺮﺽ ﻣﻌﺮﻑ ﺍﻟﺘﻠﻤﻴﺢ",
   showTooltipHash = "ﻋﺮﺽ ﺭﻣﺰ ﺍﻟﺘﺠﺰﺋﺔ",
   showTooltipHashDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﻋﺮﺽ ﺭﻣﺰ ﺍﻟﺘﺠﺰﺋﺔ ﻟﻠﺘﻠﻤﻴﺤﺎﺕ",
   hideSellPrice = "ﺇﺧﻔﺎﺀ ﺳﻌﺮ ﺍﻟﺒﻴﻊ ﻟﻸﻏﺮﺍﺽ",
   hideSellPriceDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﺇﺧﻔﺎﺀ ﺳﻌﺮ ﺍﻟﺒﻴﻊ ﻟﻸﻏﺮﺍﺽ",
   timerHoldTranslation = "ﺗﺄﺟﻴﻞ ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺔ",
   timerLimitSeconds = "ﺗﺤﺪﻳﺪ ﻭﻗﺖ ﺍﻟﺘﺄﺟﻴﻞ",
   timerLimitSecondsDESC = "ﺍﻟﻮﻗﺖ ﻫﻮ ﺭﻗﻢ ﺑﻴﻦ 5 ﻭ30",
   displayTranslationConstantly = "ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺔ ﺑﺸﻜﻞ ﻣﺴﺘﻤﺮ",
   displayTranslationConstantlyDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺔ ﻟﻠﻮﻗﺖ ﺍﻟﻤﺤﺪﺩ ﻓﻘﻂ",
   savingUntranslatedTooltips = "ﺧﻴﺎﺭﺍﺕ ﺍﻟﺤﻔﻆ",
   saveUntranslatedTooltips = "ﺣﻔﻆ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   saveUntranslatedTooltipsDESC = "ﻋﻨﺪ ﺍﻟﺘﻔﻌﻴﻞ, ﺳﻴﺘﻢ ﺣﻔﻆ ﺍﻟﺘﻠﻤﻴﺤﺎﺕ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ",
   
   titleTab9 = "ﺣﻮﻝ",
   generalText = "\n\nﻭﺍﻭ ﺑﺎﻟﻌﺮﺑﻲ ﺗﺘﻤﻨﻰ ﻟﻚ ﻗﻀﺎﺀ ﻭﻗﺖ ﻣﻤﺘﻊ ﻧﻌﻤﻞ ﺟﺎﻫﺪﺍ ﻟﺘﻮﻓﻴﺮ ﺇﻣﻜﺎﻧﻴﺔ ﺍﻟﻮﺻﻮﻝ ﺇﻟﻰ ﻣﺤﺘﻮﻯ ﺍﻟﻠﻌﺒﺔ ﺑﻠﻐﺘﻚ. ...\n\nﻧﻮﻓﺮ ﺩﻋﻤﺎ ﻟﻠﺘﺮﺟﻤﺔ ﻓﻲ ﺍﻟﻤﻬﺎﻡ ﻭﺍﻟﺤﻮﺍﺭﺍﺕ ﻭﺍﻟﺘﺮﺟﻤﺎﺕ ﻳﻤﻜﻨﻚ ﺗﻐﻴﻴﺮ ﻣﺨﺘﻠﻒ ﺍﻟﺨﻴﺎﺭﺍﺕ ﻣﻦ ﻗﺎﺋﻤﺔ ﺇﻋﺪﺍﺩﺍﺕ ﺍﻹﺿﺎﻓﺔ. \n\n  ﻟﺪﻋﻤﻨﺎ, ﻳﻤﻜﻨﻚ ﺣﻔﻆ ﺍﻟﻨﺼﻮﺹ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ ﺛﻢ ﻣﺸﺎﺭﻛﺔ ﻣﻠﻒ ﺍﻟﺤﻔﻆ ﻣﻌﻨﺎ ﻋﺒﺮ ﻗﻨﺎﺓ ﺍﻟﺪﻳﺴﻜﻮﺭﺩ ﺍﻟﺨﺎﺻﺔ ﺑﻨﺎ .\n\n ﻟﻠﻤﺴﺎﻫﻤﺔ ﻓﻲ ﺗﻄﻮﻳﺮ ﻗﺎﻋﺪﺓ ﺍﻟﺒﻴﺎﻧﺎﺕ ﺍﻟﻌﺮﺑﻴﺔ ﻟﺪﻳﻨﺎ.\n\n\n\n r| ﻣﺴﺎﺭ ﻣﻠﻒ ﺍﻟﺤﻔﻆ :804CAEffc| \n\n r|aul.RAWoW804CAEffc|/selbairaVdevaS/]XXX[/tnuoccA/FTW/liater/tfarcraW fo dlroW",
   welcomeText = "",
   welcomeButton = "ﻣﻮﺍﻓﻖ - ﺗﻢ ﺍﻟﻘﺮﺍﺀﺓ",
   showWelcome = "ﻋﺮﺽ ﻟﻮﺣﺔ ﺍﻟﺘﺮﺣﻴﺐ",
   authorHeader = "ﻣﻌﻠﻮﻣﺎﺕ ﺍﻟﻤﺆﻟﻒ",
   author = "ﺍﻟﻤﺆﻟﻒ:",
   email = "ﺍﻟﺒﺮﻳﺪ ﺍﻹﻟﻜﺘﺮﻭﻧﻲ:",
   teamHeader = "ﻓﺮﻳﻖ ARWoW",
   textContact = "ﺇﺫﺍ ﻛﺎﻥ ﻟﺪﻳﻚ ﺃﻱ ﺃﺳﺌﻠﺔ ﺣﻮﻝ ﺍﻹﺿﺎﻓﺔ، ﻳﺮﺟﻰ ﺍﻻﺗﺼﺎﻝ ﺑﻨﺎ ﻋﻠﻰ ﺃﻱ ﻣﻦ ﺍﻟﻘﻨﻮﺍﺕ ﺍﻟﻤﺬﻛﻮﺭﺓ ﺃﺩﻧﺎﻩ:",
   linkWWWShow = "ﺍﻧﻘﺮ ﻟﻌﺮﺽ ﺍﻟﺮﺍﺑﻂ ﺇﻟﻰ ﺻﻔﺤﺔ ﺍﻟﻮﻳﺐ ﺍﻟﺨﺎﺻﺔ ﺑﺎﻟﻮﻇﻴﻔﺔ ﺍﻹﺿﺎﻓﻴﺔ",
   linkWWWTitle = "ﺭﺍﺑﻂ ﺇﻟﻰ ﺍﻟﻤﻮﻗﻊ",
   linkDISCShow = "ﺍﻧﻘﺮ ﻟﻌﺮﺽ ﺍﻟﺮﺍﺑﻂ ﺇﻟﻰ ﻣﻮﻗﻊ drocsiD",
   linkDISCTitle = "ﺭﺍﺑﻂ ﺻﻔﺤﺔ ﺍﻟﺪﻳﺴﻜﻮﺭﺩ",
   linkEMAILShow = "ﺍﻧﻘﺮ ﻟﻌﺮﺽ ﻋﻨﻮﺍﻥ ﺍﻟﺒﺮﻳﺪ ﺍﻹﻟﻜﺘﺮﻭﻧﻲ ﻟﻠﻤﺸﺮﻭﻉ",
   linkEMAILTitle = "ﻋﻨﻮﺍﻥ ﺍﻟﺒﺮﻳﺪ ﺍﻹﻟﻜﺘﺮﻭﻧﻲ ﻟﻠﻤﺸﺮﻭﻉ",
   linkCURSEShow = "ﺍﻧﻘﺮ ﻟﻌﺮﺽ ﺍﻟﺮﺍﺑﻂ ﺇﻟﻰ ﻣﻮﻗﻊ egroFesruC",
   linkCURSETitle = "ﺭﺍﺑﻂ ﺇﻟﻰ ﻣﻮﻗﻊ egroFesruC",
   linkPPShow = "ﺍﻧﻘﺮ ﻟﻌﺮﺽ ﺍﻟﺮﺍﺑﻂ ﺇﻟﻰ ﻣﻮﻗﻊ laPyaP",
   linkPPTitle = "ﺭﺍﺑﻂ ﺇﻟﻰ ﻣﻮﻗﻊ laPyaP",
   linkBLIKShow = "ﺍﻧﻘﺮ ﻟﻌﺮﺽ ﺭﻗﻢ ﻫﺎﺗﻒ KILB",
   linkTWITCHShow = "ﺍﻧﻘﺮ ﻟﻌﺮﺽ ﺍﻟﺮﺍﺑﻂ ﺇﻟﻰ ﺻﻔﺤﺔ hctiwT",
   linkTWITCHTitle = "ﺭﺍﺑﻂ ﺻﻔﺤﺔ ﺗﻮﻳﺘﺶ",
   linkFBShow = "ﺍﻧﻘﺮ ﻟﻌﺮﺽ ﺍﻟﺮﺍﺑﻂ ﺇﻟﻰ ﺻﻔﺤﺔ ﺍﻟﻤﻌﺠﺒﻴﻦ",
   linkFBTitle = "ﺭﺍﺑﻂ ﺇﻟﻰ ﺻﻔﺤﺔ ﺍﻟﻤﻌﺠﺒﻴﻦ",
   linkBLIKTitle = "ﺭﻗﻢ ﻫﺎﺗﻒ ﻛﻴﻠﺐ",
   linkCloseFrame = "ﺃﻏﻠﻖ ﺍﻹﻃﺎﺭ",
   linkCopy = "ﺍﺿﻐﻂ ﻋﻠﻰ C+lrtC ﻟﻨﺴﺦ ﺍﻟﻌﻨﻮﺍﻥ ﺇﻟﻰ ﺍﻟﺤﺎﻓﻈﺔ",
   betaTestersHeader = "",
   betaTestersHeaderDESC = "",
};
   
---------------------------------------------------------------------------------------------------------
--translated names of the player's races and classes in arabic; only male (M) and female (F)

---------------------------------------------------------------------------------------------------------
local p_race = {
   ["Blood Elf"] = { M="ﺑﻠﻮد اﻟﻒ", F="ﺑﻠﻮد اﻟﻔﺔ" },
   ["Dark Iron Dwarf"] = { M="دارك اﻳﺮون دوارف", F="دارك اﻳﺮون دوارﻓﺔ" },
   ["Dracthyr"] = { M="دراﻛﺜﻴﺮ", F="دراﻛﺜﻴﺮة" },
   ["Draenei"] = { M="دراﻳﻨﻲ", F="دراﻳﻨﻴﺔ" },
   ["Dwarf"] = { M="دوارف", F="دوارﻓﺔ" },
   ["Gnome"] = { M="ﺟﻨﻮم", F="ﺟﻨﻮﻣﺔ" },
   ["Goblin"] = { M="ﺟﻮﺑﻠﻦ", F="ﺟﻮﺑﻠﻨﺔ" },
   ["Highmountain Tauren"] = { M="ﻫﺎي ﻣﺎوﻧﺘﻦ ﺗﻮرﻳﻦ", F="ﻫﺎي ﻣﺎوﻧﺘﻦ ﺗﻮرﻳﻨﺔ" },
   ["Human"] = { M="ﻫﻴﻮﻣﻦ", F="ﻫﻴﻮﻣﻨﺔ" },
   ["Kul Tiran"] = { M="ﻛﻮل ﺗﻴﺮان", F="ﻛﻮل ﺗﻴﺮاﻧﺔ" },
   ["Lightforged Draenei"] = { M="ﻻﻳﺖ ﻓﻮرﺟﺪ دراﻳﻨﻲ", F="ﻻﻳﺖ ﻓﻮرﺟﺪ دراﻳﻨﻴﺔ" },
   ["Mag'har Orc"] = { M="ﻣﺎج ﻫﺎر اورك", F="ﻣﺎج ﻫﺎر اورﻛﺔ" },
   ["Mechagnome"] = { M="ﻣﻴﻜﺎﺟﻨﻮم", F="ﻣﻴﻜﺎﺟﻨﻮﻣﺔ" },
   ["Nightborne"] = { M="ﻧﺎﻳﺖ ﺑﻮرن", F="ﻧﺎﻳﺖ ﺑﻮرﻧﺔ" },
   ["Night Elf"] = { M="ﻧﺎﻳﺖ اﻟﻒ", F="ﻧﺎﻳﺖ اﻟﻔﺔ" },
   ["Orc"] = { M="اورك", F="اورﻛﺔ" },
   ["Pandaren"] = { M="ﺑﺎﻧﺪاران", F="ﺑﺎﻧﺪاراﻧﺔ" },
   ["Tauren"] = { M="ﺗﻮرﻳﻦ", F="ﺗﻮرﻳﻨﺔ" },
   ["Troll"] = { M="ﺗﺮول", F="ﺗﺮوﻟﺔ" },
   ["Undead"] = { M="اﻧﺪد", F="اﻧﺪﻳﺔ" },
   ["Void Elf"] = { M="ﻓﻮﻳﺪ اﻟﻒ", F="ﻓﻮﻳﺪ اﻟﻔﺔ" },
   ["Vulpera"] = { M="ﻓﻮﻟﺒﻴﺮا", F="ﻓﻮﻟﺒﻴﺮا" },
   ["Worgen"] = { M="وارﺟﻴﻦ", F="وارﺟﻴﻨﺔ" },
   ["Zandalari Troll"] = { M="زاﻧﺪاﻻري ﺗﺮول", F="زاﻧﺪاﻻري ﺗﺮوﻟﺔ" },
};

local p_class = {
   ["Death Knight"] = { M="دﻳﺚ ﻧﺎﻳﺖ", F="دﻳﺚ ﻧﺎﻳﺘﺔ" },
   ["Demon Hunter"] = { M="دﻳﻤﻮن ﻫﺎﻧﺘﺮ", F="دﻳﻤﻮن ﻫﺎﻧﺘﺮة" },
   ["Druid"] = { M="دروﻳﺪ", F="دروﻳﺪة" },
   ["Evoker"] = { M="اﻳﻔﻮﻛﺮ", F="اﻳﻔﻮﻛﺮة" },
   ["Hunter"] = { M="ﻫﺎﻧﺘﺮ", F="ﻫﺎﻧﺘﺮة" },
   ["Mage"] = { M="ﻣﻴﺞ", F="ﻣﻴﺠﺔ" },
   ["Monk"] = { M="ﻣﻮﻧﻚ", F="ﻣﻮﻧﻜﺔ" },
   ["Paladin"] = { M="ﺑﺎﻻدﻳﻦ", F="ﺑﺎﻻدﻳﻨﺔ" },
   ["Priest"] = { M="ﺑﺮﻳﺴﺖ", F="ﺑﺮﻳﺴﺘﺔ" },
   ["Rogue"] = { M="روق", F="روﻗﺔ" },
   ["Shaman"] = { M="ﺷﺎﻣﺎن", F="ﺷﺎﻣﺎﻧﺔ" },
   ["Warlock"] = { M="وارﻟﻮك", F="وارﻟﻮﻛﺔ" },
   ["Warrior"] = { M="وارﻳﻮر", F="وارﻳﻮرة" },
};

local QTR_race = UnitRace("player");
local QTR_class = UnitClass("player");

if (p_race[QTR_race]) then
   player_race_table = { M=AS_UTF8reverse(p_race[QTR_race].M), F=AS_UTF8reverse(p_race[QTR_race].F) };
else   
   player_race_table = { M=QTR_race, F=QTR_race };
end

if (p_class[QTR_class]) then
   player_class_table = { M=p_class[QTR_class].M, F=p_class[QTR_class].F };
else
   player_class_table = { M=QTR_class, F=QTR_class };
end

---------------------------------------------------------------------------------------------------------
--Fonts
---------------------------------------------------------------------------------------------------------
WOWTR_Font1 = WoWTR_Localization.mainFolder.."\\Fonts\\font1.ttf";
WOWTR_Font2 = WoWTR_Localization.mainFolder.."\\Fonts\\font2.ttf";
WOWTR_Fonts = {"font2.ttf"};
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata;
WOWTR_version = GetAddOnMetadata(WoWTR_Localization.addonName, "Version");