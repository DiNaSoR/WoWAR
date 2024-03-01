-- Addon: WoWAR (version: 10.L11) 2024.02.05
-- Description: Texts in the selected localization language
-- Autor: Platine
-- E-mail: platine.wow@gmail.com

---------------------------------------------------------------------------------------------------------

WoWTR_Localization = {
   lang = "AR",
   started = "started",                                              -- addon was started
   mainFolder = "Interface\\AddOns\\WoWAR",                          -- main folder for addon files
   addonName = "WoWAR",                                              -- short name of the addon
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
   objectives = "ﺃﻫﺪﺍﻑ",                                             -- Objectives
   rewards = "ﻣﻜﺎﻓﺌﺎﺕ",                                              -- Rewards
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
   sellPrice = ":ﺳﻌﺮ ﺍﻟﺒﻴﻊ",                                         -- Sell price:
   currentlyEquipped = "ﻣﺮﺗﺪﻱ ﺣﺎﻟﻴﺎ",                                -- Currently Equipped
   additionalEquipped = "ﻣﺮﺗﺪﻱ ﻣﻌﺪﺍﺕ ﺇﺿﺎﻓﻴﺔ",                        -- Equipped with additional Equipment
   WoWTR_Talent_arDESC = "ﺍﻟﻤﻬﺎﺭﺍﺕ: ﺑﺎﻟﻌﺮﺑﻲ",                        -- Talents: Arabic
   WoWTR_Talent_enDESC = "Talents: English",                         -- Talents: English
   WoWTR_Spellbook_arDESC = "ﺍﻟﻘﺪﺭﺍﺕ: ﺑﺎﻟﻌﺮﺑﻲ",                      -- Spell Book: Arabic
   WoWTR_Spellbook_enDESC = "Spell Book: English",                   -- Spell Book: English
   your_home = "ﻣﻨﺰﻟﻚ",                                              -- 'your home' (if the Hearthstone location fails to be read)
   welcomeIconPos = 255,                                             -- position of welcome icon on the welcom panel; 0 = disabled to display
   resetButton1 = "ﻣﺴﺢ ﺍﻟﺴﺠﻼﺕ ﺍﻟﻤﺨﺰﻧﺔ ﻓﻲ ﻣﻠﻒ aul.RAWoW",             -- مسح النصوص غير المترجمة المحفوظة (بدون خط عربي)
   resetButton2 = "ﺇﻋﺎﺩﺓ ﺿﺒﻂ ﺇﻋﺪﺍﺩﺍﺕ ﺍﻹﺿﺎﻓﺔ",                        -- إعادة الإضافة إلى إعداداتها الافتراضية (بدون خط عربي)
   resetButton1Opis = "ﻣﺴﺢ ﺍﻟﻨﺼﻮﺹ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ ﺍﻟﻤﺤﻔﻮﻇﺔ",            -- ﻣﺴﺢ ﺍﻟﻨﺼﻮﺹ ﻏﻴﺮ ﺍﻟﻤﺘﺮﺟﻤﺔ ﺍﻟﻤﺤﻔﻮﻇﺔ (كتلميح)
   resetButton1OpisDESC = "ﺳﻴﺘﻢ ﺣﺬﻑ ﺟﻤﻴﻊ ﺍﻟﺒﻴﺎﻧﺎﺕ ﺍﻟﻤﺤﻔﻮﻇﺔ ﻓﻲ ﺍﻟﻠﻌﺒﺔ",  -- مسح النصوص غير المترجمة المحفوظة (كتلميح)
   resetButton2Opis = "ﺇﻋﺎﺩﺓ ﺍﻹﺿﺎﻓﺔ ﺇﻟﻰ ﺇﻋﺪﺍﺩﺍﺗﻬﺎ ﺍﻻﻓﺘﺮﺍﺿﻴﺔ",           -- ﺇﻋﺎﺩﺓ ﺍﻹﺿﺎﻓﺔ ﺇﻟﻰ ﺇﻋﺪﺍﺩﺍﺗﻬﺎ ﺍﻻﻓﺘﺮﺍﺿﻴﺔ (كتلميح)
   resetButton2OpisDESC = "ﺳﻴﺘﻢ ﺇﻋﺎﺩﺓ ﺇﻋﺪﺍﺩﺍﺕ ﺍﻹﺿﺎﻓﺔ ﺇﻟﻰ ﺍﻟﻮﺿﻊ ﺍﻻﻓﺘﺮﺍﺿﻲ \n)ﻭﺳﻴﺘﻢ ﺇﻋﺎﺩﺓ ﺗﺤﻤﻴﻞ ﺍﻟﻮﺍﺟﻬﺔ(",
   resultButton1 = "ﺗﻢ ﻣﺴﺢ ﺍﻟﻨﺼﻮﺹ ﺍﻟﻤﺨﺰﻧﺔ",                             -- تم تنظيف النصوص المحفوظة
   confirmationHeader = "ﺗﺄﻛﻴﺪ",                                        -- عنوان الﺗﺄﻛﻴﺪ
   confirmationText1 = "ﻫﻞ ﺗﺮﻏﺐ ﻓﻲ ﻣﺴﺢ ﺟﻤﻴﻊ ﺍﻟﺴﺠﻼﺕ ﺍﻟﻤﺤﻔﻮﻇﺔ؟",          -- هل تود مسح جميع النصوص غير المترجمة المحفوظة؟
   confirmationText2 = "ﻫﻞ ﺗﺮﻏﺐ ﻓﻲ ﺇﻋﺎﺩﺓ ﺗﺤﻤﻴﻞ ﺍﻹﺿﺎﻓﺔ ﺇﻟﻰ ﺇﻋﺪﺍﺩﺍﺗﻬﺎ ﺍﻻﻓﺘﺮﺍﺿﻴﺔ؟\n(ﺳﻴﺘﻢ ﺇﻋﺎﺩﺓ ﺗﺤﻤﻴﻞ ﺍﻟﻮﺍﺟﻬﺔ)",   -- هل تود استعادة إعدادات الإضافة الافتراضية؟
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
   reqitems          = "ﺍﻟﻌﻨﺎﺻﺮ ﺍﻟﻤﻄﻠﻮﺑﺔ", -- Wymagane przedmioty (Required items)
   itemchoose0       = "ﺳﺘﺴﺘﻠﻢ:", -- Otrzymasz: (You will receive:)
   itemchoose1       = "ﺳﺘﺘﻤﻜﻦ ﻣﻦ ﺍﺧﺘﻴﺎﺭ ﺇﺣﺪﻯ ﻫﺬﻩ ﺍﻟﻤﻜﺎﻓﺂﺕ", -- Możesz wybrać jedną z nagród: (You will be able to choose one of these rewards:)
   itemchoose2       = "ﺍﺧﺘﺮ ﺇﺣﺪﻯ ﻫﺬﻩ ﺍﻟﻤﻜﺎﻓﺂﺕ", -- Wybierz jedną z nagród: (Choose one of these rewards:)
   itemchoose3       = "ﺃﻧﺖ ﺗﺘﻠﻘﻰ ﺍﻟﻤﻜﺎﻓﺄﺓ", -- Otrzymujesz nagrodę: (You receiving the reward:)
   itemreceiv0       = "ﺳﺘﺴﺘﻠﻢ", -- Otrzymasz: (You will receive:)
   itemreceiv1       = "ﺃﻳﻀﺎ ﺳﻮﻑ ﺗﺄﺧﺬ:", -- Otrzymasz również: (You will also receive:)
   itemreceiv2       = "ﺳﺘﺄﺧﺬ ﺍﻟﻤﻜﺎﻓﺌﺔ:", -- Otrzymujesz nagrodę: (You receiving the reward:)
   itemreceiv3       = "ﺃﻧﺖ ﺃﻳﻀﺎ ﺳﺘﺄﺧﺬ ﺍﻟﻤﻜﺎﻓﺌﺔ:", -- Otrzymujesz również nagrodę: (You also receiving the reward:)
   learnspell        = "ﺗﻌﻠﻢ ﺍﻟﺴﺤﺮ:", -- Naucz się zaklęcia: (Learn Spell:)
   currquests        = "ﺍﻟﻤﻬﺎﻡ ﺍﻟﺤﺎﻟﻴﺔ:", -- Bieżące zadania (Current Quests)
   avaiquests        = "ﺍﻟﻤﻬﺎﻡ ﺍﻟﻤﺘﻮﻓﺮﺓ:", -- Dostępne zadania (Available Quests)
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
   translateOwnNames = "ﻋﺮﺽ ﺃﺳﻤﺎﺀ ﺍﻷﻣﺎﻛﻦ ﺑﺎﻟﻌﺮﺑﻴﺔ - |ﺑﻠﻮﻥ|)ﻏﻴﺮ ﻧﺸﻂ ﺍﻵﻥ(|ﺭﻣﺎﺩﻱ|",
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
   sampleGossipText = "ﻧﻤﻮﺫﺝ ﺣﺠﻢ ﺍﻟﺨﻂ ﻟﻨﺺ ﺍﻟﺤﻮﺍﺭﺍﺕ CPN",
   
   titleTab2 = "ﺍﻟﻔﻘﺎﻋﺎﺕ",
   generalMainHeaderBB = "ﺗﺮﺟﻤﺎﺕ ﺍﻟﻔﻘﺎﻋﺎﺕ - selbbuB",
   activateBubblesTranslations = "ﺗﻔﻌﻴﻞ ﺗﺮﺟﻤﺎﺕ ﺍﻟﻔﻘﺎﻋﺎﺕ",
   activateBubblesTranslationsDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﺳﺘﻈﻬﺮ ﺍﻟﺘﺮﺟﻤﺎﺕ ﺑﺎﻟﻠﻐﺔ ﺍﻷﺻﻠﻴﺔ",
   displayOriginalTexts = "ﻋﺮﺽ ﺍﻟﻨﺺ ﺍﻷﺻﻠﻲ ﻓﻲ ﻧﺎﻓﺬﺓ ﺍﻟﺪﺭﺩﺷﺔ",
   displayOriginalTextsDESC = "ﻋﻨﺪ ﺍﻹﻏﻼﻕ, ﻟﻦ ﻳﻈﻬﺮ ﺍﻟﻨﺺ ﺍﻷﺻﻠﻲ ﻓﻲ ﻧﺎﻓﺬﺓ ﺍﻟﺪﺭﺩﺷﺔ",
   displayTranslatedTexts = "ﻋﺮﺽ ﺍﻟﺘﺮﺟﻤﺔ ﺍﻟﺘﺮﻛﻴﺔ ﻓﻲ ﻧﺎﻓﺬﺓ ﺍﻟﺪﺭﺩﺷﺔ",
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
--translated names of the player's races and classes in various cases of the noun
--variant (M1,D1,C1,B1,N1,K1,W1;M2,D2,C2,B2,N2,K2,W2) and the player's gender (male:1, female:2)
---------------------------------------------------------------------------------------------------------

local p_race = {
      ["Blood Elf"] = { M1="Blood Elf", D1="Blood Elf", C1="Blood Elf", B1="Blood Elf", N1="Blood Elf", K1="Blood Elf", W1="Blood Elf", M2="Blood Elf", D2="Blood Elf", C2="Blood Elf", B2="Blood Elf", N2="Blood Elf", K2="Blood Elf", W2="Blood Elf" }, 
      ["Dark Iron Dwarf"] = { M1="Dark Iron Dwarf", D1="Dark Iron Dwarf", C1="Dark Iron Dwarf", B1="Dark Iron Dwarf", N1="Dark Iron Dwarf", K1="Dark Iron Dwarf", W1="Dark Iron Dwarf", M2="Dark Iron Dwarf", D2="Dark Iron Dwarf", C2="Dark Iron Dwarf", B2="Dark Iron Dwarf", N2="Dark Iron Dwarf", K2="Dark Iron Dwarf", W2="Dark Iron Dwarf" }, 
      ["Dracthyr"] = { M1="Dracthyr", D1="Dracthyr", C1="Dracthyr", B1="Dracthyr", N1="Dracthyr", K1="Dracthyr", W1="Dracthyr", M2="Dracthyr", D2="Dracthyr", C2="Dracthyr", B2="Dracthyr", N2="Dracthyr", K2="Dracthyr", W2="Dracthyr" }, 
      ["Draenei"] = { M1="Draenei", D1="Draenei", C1="Draenei", B1="Draenei", N1="Draenei", K1="Draenei", W1="Draenei", M2="Draenei", D2="Draenei", C2="Draenei", B2="Draenei", N2="Draenei", K2="Draenei", W2="Draenei" }, 
      ["Dwarf"] = { M1="Dwarf", D1="Dwarf", C1="Dwarf", B1="Dwarf", N1="Dwarf", K1="Dwarf", W1="Dwarf", M2="Dwarf", D2="Dwarf", C2="Dwarf", B2="Dwarf", N2="Dwarf", K2="Dwarf", W2="Dwarf" }, 
      ["Gnome"] = { M1="Gnome", D1="Gnome", C1="Gnome", B1="Gnome", N1="Gnome", K1="Gnome", W1="Gnome", M2="Gnome", D2="Gnome", C2="Gnome", B2="Gnome", N2="Gnome", K2="Gnome", W2="Gnome" }, 
      ["Goblin"] = { M1="Goblin", D1="Goblin", C1="Goblin", B1="Goblin", N1="Goblin", K1="Goblin", W1="Goblin", M2="Goblin", D2="Goblin", C2="Goblin", B2="Goblin", N2="Goblin", K2="Goblin", W2="Goblin" }, 
      ["Highmountain Tauren"] = { M1="Highmountain Tauren", D1="Highmountain Tauren", C1="Highmountain Tauren", B1="Highmountain Tauren", N1="Highmountain Tauren", K1="Highmountain Tauren", W1="Highmountain Tauren", M2="Highmountain Tauren", D2="Highmountain Tauren", C2="Highmountain Tauren", B2="Highmountain Tauren", N2="Highmountain Tauren", K2="Highmountain Tauren", W2="Highmountain Tauren" }, 
      ["Human"] = { M1="Human", D1="Human", C1="Human", B1="Human", N1="Human", K1="Human", W1="Human", M2="Human", D2="Human", C2="Human", B2="Human", N2="Human", K2="Human", W2="Human" }, 
      ["Kul Tiran"] = { M1="Kul Tiran", D1="Kul Tiran", C1="Kul Tiran", B1="Kul Tiran", N1="Kul Tiran", K1="Kul Tiran", W1="Kul Tiran", M2="Kul Tiran", D2="Kul Tiran", C2="Kul Tiran", B2="Kul Tiran", N2="Kul Tiran", K2="Kul Tiran", W2="Kul Tiran" }, 
      ["Lightforged Draenei"] = { M1="Lightforged Draenei", D1="Lightforged Draenei", C1="Lightforged Draenei", B1="Lightforged Draenei", N1="Lightforged Draenei", K1="Lightforged Draenei", W1="Lightforged Draenei", M2="Lightforged Draenei", D2="Lightforged Draenei", C2="Lightforged Draenei", B2="Lightforged Draenei", N2="Lightforged Draenei", K2="Lightforged Draenei", W2="Lightforged Draenei" }, 
      ["Mag'har Orc"] = { M1="Mag'har Orc", D1="Mag'har Orc", C1="Mag'har Orc", B1="Mag'har Orc", N1="Mag'har Orc", K1="Mag'har Orc", W1="Mag'har Orc", M2="Mag'har Orc", D2="Mag'har Orc", C2="Mag'har Orc", B2="Mag'har Orc", N2="Mag'har Orc", K2="Mag'har Orc", W2="Mag'har Orc" }, 
      ["Mechagnome"] = { M1="Mechagnome", D1="Mechagnome", C1="Mechagnome", B1="Mechagnome", N1="Mechagnome", K1="Mechagnome", W1="Mechagnome", M2="Mechagnome", D2="Mechagnome", C2="Mechagnome", B2="Mechagnome", N2="Mechagnome", K2="Mechagnome", W2="Mechagnome" }, 
      ["Nightborne"] = { M1="Nightborne", D1="Nightborne", C1="Nightborne", B1="Nightborne", N1="Nightborne", K1="Nightborne", W1="Nightborne", M2="Nightborne", D2="Nightborne", C2="Nightborne", B2="Nightborne", N2="Nightborne", K2="Nightborne", W2="Nightborne" }, 
      ["Night Elf"] = { M1="Night Elf", D1="Night Elf", C1="Night Elf", B1="Night Elf", N1="Night Elf", K1="Night Elf", W1="Night Elf", M2="Night Elf", D2="Night Elf", C2="Night Elf", B2="Night Elf", N2="Night Elf", K2="Night Elf", W2="Night Elf" }, 
      ["Orc"] = { M1="Orc", D1="Orc", C1="Orc", B1="Orc", N1="Orc", K1="Orc", W1="Orc", M2="Orc", D2="Orc", C2="Orc", B2="Orc", N2="Orc", K2="Orc", W2="Orc" }, 
      ["Pandaren"] = { M1="Pandaren", D1="Pandaren", C1="Pandaren", B1="Pandaren", N1="Pandaren", K1="Pandaren", W1="Pandaren", M2="Pandaren", D2="Pandaren", C2="Pandaren", B2="Pandaren", N2="Pandaren", K2="Pandaren", W2="Pandaren" }, 
      ["Tauren"] = { M1="Tauren", D1="Tauren", C1="Tauren", B1="Tauren", N1="Tauren", K1="Tauren", W1="Tauren", M2="Tauren", D2="Tauren", C2="Tauren", B2="Tauren", N2="Tauren", K2="Tauren", W2="Tauren" }, 
      ["Troll"] = { M1="Troll", D1="Troll", C1="Troll", B1="Troll", N1="Troll", K1="Troll", W1="Troll", M2="Troll", D2="Troll", C2="Troll", B2="Troll", N2="Troll", K2="Troll", W2="Troll" }, 
      ["Undead"] = { M1="Undead", D1="Undead", C1="Undead", B1="Undead", N1="Undead", K1="Undead", W1="Undead", M2="Undead", D2="Undead", C2="Undead", B2="Undead", N2="Undead", K2="Undead", W2="Undead" }, 
      ["Void Elf"] = { M1="Void Elf", D1="Void Elf", C1="Void Elf", B1="Void Elf", N1="Void Elf", K1="Void Elf", W1="Void Elf", M2="Void Elf", D2="Void Elf", C2="Void Elf", B2="Void Elf", N2="Void Elf", K2="Void Elf", W2="Void Elf" }, 
      ["Vulpera"] = { M1="Vulpera", D1="Vulpera", C1="Vulpera", B1="Vulpera", N1="Vulpera", K1="Vulpera", W1="Vulpera", M2="Vulpera", D2="Vulpera", C2="Vulpera", B2="Vulpera", N2="Vulpera", K2="Vulpera", W2="Vulpera" }, 
      ["Worgen"] = { M1="Worgen", D1="Worgen", C1="Worgen", B1="Worgen", N1="Worgen", K1="Worgen", W1="Worgen", M2="Worgen", D2="Worgen", C2="Worgen", B2="Worgen", N2="Worgen", K2="Worgen", W2="Worgen" }, 
      ["Zandalari Troll"] = { M1="Zandalari Troll", D1="Zandalari Troll", C1="Zandalari Troll", B1="Zandalari Troll", N1="Zandalari Troll", K1="Zandalari Troll", W1="Zandalari Troll", M2="Zandalari Troll", D2="Zandalari Troll", C2="Zandalari Troll", B2="Zandalari Troll", N2="Zandalari Troll", K2="Zandalari Troll", W2="Zandalari Troll" }, 
};
local p_class = {
      ["Death Knight"] = { M1="Death Knight", D1="Death Knight", C1="Death Knight", B1="Death Knight", N1="Death Knight", K1="Death Knight", W1="Death Knight", M2="Death Knight", D2="Death Knight", C2="Death Knight", B2="Death Knight", N2="Death Knight", K2="Death Knight", W2="Death Knight" }, 
      ["Demon Hunter"] = { M1="Demon Hunter", D1="Demon Hunter", C1="Demon Hunter", B1="Demon Hunter", N1="Demon Hunter", K1="Demon Hunter", W1="Demon Hunter", M2="Demon Hunter", D2="Demon Hunter", C2="Demon Hunter", B2="Demon Hunter", N2="Demon Hunter", K2="Demon Hunter", W2="Demon Hunter" }, 
      ["Druid"] = { M1="Druid", D1="Druid", C1="Druid", B1="Druid", N1="Druid", K1="Druid", W1="Druid", M2="Druid", D2="Druid", C2="Druid", B2="Druid", N2="Druid", K2="Druid", W2="Druid" }, 
      ["Evoker"] = { M1="Evoker", D1="Evoker", C1="Evoker", B1="Evoker", N1="Evoker", K1="Evoker", W1="Evoker", M2="Evoker", D2="Evoker", C2="Evoker", B2="Evoker", N2="Evoker", K2="Evoker", W2="Evoker" }, 
      ["Hunter"] = { M1="Hunter", D1="Hunter", C1="Hunter", B1="Hunter", N1="Hunter", K1="Hunter", W1="Hunter", M2="Hunter", D2="Hunter", C2="Hunter", B2="Hunter", N2="Hunter", K2="Hunter", W2="Hunter" }, 
      ["Mage"] = { M1="Mage", D1="Mage", C1="Mage", B1="Mage", N1="Mage", K1="Mage", W1="Mage", M2="Mage", D2="Mage", C2="Mage", B2="Mage", N2="Mage", K2="Mage", W2="Mage" }, 
      ["Monk"] = { M1="Monk", D1="Monk", C1="Monk", B1="Monk", N1="Monk", K1="Monk", W1="Monk", M2="Monk", D2="Monk", C2="Monk", B2="Monk", N2="Monk", K2="Monk", W2="Monk" }, 
      ["Paladin"] = { M1="Paladin", D1="Paladin", C1="Paladin", B1="Paladin", N1="Paladin", K1="Paladin", W1="Paladin", M2="Paladin", D2="Paladin", C2="Paladin", B2="Paladin", N2="Paladin", K2="Paladin", W2="Paladin" }, 
      ["Priest"] = { M1="Priest", D1="Priest", C1="Priest", B1="Priest", N1="Priest", K1="Priest", W1="Priest", M2="Priest", D2="Priest", C2="Priest", B2="Priest", N2="Priest", K2="Priest", W2="Priest" }, 
      ["Rogue"] = { M1="Rogue", D1="Rogue", C1="Rogue", B1="Rogue", N1="Rogue", K1="Rogue", W1="Rogue", M2="Rogue", D2="Rogue", C2="Rogue", B2="Rogue", N2="Rogue", K2="Rogue", W2="Rogue" }, 
      ["Shaman"] = { M1="Shaman", D1="Shaman", C1="Shaman", B1="Shaman", N1="Shaman", K1="Shaman", W1="Shaman", M2="Shaman", D2="Shaman", C2="Shaman", B2="Shaman", N2="Shaman", K2="Shaman", W2="Shaman" }, 
      ["Warlock"] = { M1="Warlock", D1="Warlock", C1="Warlock", B1="Warlock", N1="Warlock", K1="Warlock", W1="Warlock", M2="Warlock", D2="Warlock", C2="Warlock", B2="Warlock", N2="Warlock", K2="Warlock", W2="Warlock" }, 
      ["Warrior"] = { M1="Warrior", D1="Warrior", C1="Warrior", B1="Warrior", N1="Warrior", K1="Warrior", W1="Warrior", M2="Warrior", D2="Warrior", C2="Warrior", B2="Warrior", N2="Warrior", K2="Warrior", W2="Warrior" }, 
};

local QTR_race = UnitRace("player");
local QTR_class = UnitClass("player");

if (p_race[QTR_race]) then      
   player_race_table = { M1=p_race[QTR_race].M1, D1=p_race[QTR_race].D1, C1=p_race[QTR_race].C1, B1=p_race[QTR_race].B1, N1=p_race[QTR_race].N1, K1=p_race[QTR_race].K1, W1=p_race[QTR_race].W1, M2=p_race[QTR_race].M2, D2=p_race[QTR_race].D2, C2=p_race[QTR_race].C2, B2=p_race[QTR_race].B2, N2=p_race[QTR_race].N2, K2=p_race[QTR_race].K2, W2=p_race[QTR_race].W2 };
else   
   player_race_table = { M1=QTR_race, D1=QTR_race, C1=QTR_race, B1=QTR_race, N1=QTR_race, K1=QTR_race, W1=QTR_race, M2=QTR_race, D2=QTR_race, C2=QTR_race, B2=QTR_race, N2=QTR_race, K2=QTR_race, W2=QTR_race };
end
if (p_class[QTR_class]) then
   player_class_table = { M1=p_class[QTR_class].M1, D1=p_class[QTR_class].D1, C1=p_class[QTR_class].C1, B1=p_class[QTR_class].B1, N1=p_class[QTR_class].N1, K1=p_class[QTR_class].K1, W1=p_class[QTR_class].W1, M2=p_class[QTR_class].M2, D2=p_class[QTR_class].D2, C2=p_class[QTR_class].C2, B2=p_class[QTR_class].B2, N2=p_class[QTR_class].N2, K2=p_class[QTR_class].K2, W2=p_class[QTR_class].W2 };
else
   player_class_table = { M1=QTR_class, D1=QTR_class, C1=QTR_class, B1=QTR_class, N1=QTR_class, K1=QTR_class, W1=QTR_class, M2=QTR_class, D2=QTR_class, C2=QTR_class, B2=QTR_class, N2=QTR_class, K2=QTR_class, W2=QTR_class };
end

---------------------------------------------------------------------------------------------------------
--Fonts
---------------------------------------------------------------------------------------------------------
WOWTR_Font1 = WoWTR_Localization.mainFolder.."\\Fonts\\font1.ttf";
WOWTR_Font2 = WoWTR_Localization.mainFolder.."\\Fonts\\font2.ttf";
WOWTR_Fonts = {"font2.ttf"};
WOWTR_version = GetAddOnMetadata(WoWTR_Localization.addonName, "Version");