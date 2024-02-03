-- Addon: WoWAR (version: 10.L10) 2024.01.30
-- Description: Texts in the selected localization language
-- Autor: Platine
-- E-mail: platine.wow@gmail.com

---------------------------------------------------------------------------------------------------------

WoWTR_Localization = {
   lang = "AR",
   started = "started",                                              -- addon was started
   mainFolder = "Interface\\AddOns\\WoWAR",                          -- main folder for addon files
   addonName = "WoWAR",                                              -- short name of the addon
   addonIconDesc = "انقر , لفتح قائمة الإعدادات.",                    -- Click to open the settings menu
   optionName = "WoWAR - Options",                                   -- WoWAR - options
   optionTitle = "إضافة واو بالعربي",                                -- WoWAR Patch
   optionTitleAR = "ملحق WOW باللغة العربية، baranogarD & enitalP، (C) 4202-3202",  -- Main title of addon in Arabic
   addressWWW = "https://www.WoWinArabic.com",                       -- address of project page
   addressDiscord = "https://discord.gg/uW5NJ6y",                    -- address of discord page
   addressTwitch = "",                                               -- address of Twitch page 
   addressFanPage = "",                                              -- address of FanPage 
   addressEmail = "dragonarab@gmail.com",                            -- address of project e-mail
   addressCurse = "https://www.curseforge.com/wow/addons/wowinarabic-quests",         -- address of CurseForge page
   addressPayPal = "https://www.paypal.com/donate/?hosted_button_id=FC2NVQ5DN7GVA",   -- address of PayPal page
   addressBlik = "",                                                 -- telephon number for BLIK payment
   gossipText = "نص الشائعات",                                       -- gossip text
   quests = "المهام",                                                -- Quests
   campaignquests = "الحملات",
   scenariodung = "الدهليز",
   objectives = "أهداف",                                             -- Objectives
   rewards = "مكافئات",                                              -- Rewards
   storyLineProgress = "مراحل تقدم القصة",                           -- StoryLine Progress
   storyLineChapters = "فصول القصة",                                 -- StoryLine Chapters
   choiceQuestFirst = "أختر المهمة أولا",                             -- choose a quest first
   readyForTurnIn = "جاهزة للتسليم",                                 -- Ready for turn-in
   clickToComplete = "انقر للإكمال",                                  -- click to complete
   failed = "فشل",                                                   -- Failed
   optional = "اختياري",                                             -- Optional
   emptyProgress = "أنت تقوم بعمل جيد, YOUR_NAME",                   -- You are doing well, $N
   bookID = "رقم الكتاب:",                                           -- Book ID:
   stopTheMovie = "تريد إيقاف الفيديو ؟",                            -- Do you want to stop the video?
   stopTheMovieYes = "نعم",                                          -- Yes
   stopTheMovieNo = "لا",                                             -- No
   reopenBoard = "إعادة فتح لوحة الإعلانات",                           -- Reopen the Bulletin Board
   sellPrice = ":سعر البيع",                                         -- Sell price:
   currentlyEquipped = "مرتدي حاليا",                                -- Currently Equipped
   additionalEquipped = "مرتدي معدات إضافية",                        -- Equipped with additional Equipment
   WoWTR_Talent_arDESC = "المهارات: بالعربي",                        -- Talents: Arabic
   WoWTR_Talent_enDESC = "Talents: English",                         -- Talents: English
   WoWTR_Spellbook_arDESC = "القدرات: بالعربي",                      -- Spell Book: Arabic
   WoWTR_Spellbook_enDESC = "Spell Book: English",                   -- Spell Book: English
   your_home = "منزلك",                                              -- 'your home' (if the Hearthstone location fails to be read)
   welcomeIconPos = 255,                                             -- position of welcome icon on the welcom panel; 0 = disabled to display
   resetButton1 = "مسح السجلات المخزنة في ملف aul.RAWoW",             -- مسح النصوص غير المترجمة المحفوظة (بدون خط عربي)
   resetButton2 = "إعادة ضبط إعدادات الإضافة",                        -- إعادة الإضافة إلى إعداداتها الافتراضية (بدون خط عربي)
   resetButton1Opis = "مسح النصوص غير المترجمة المحفوظة",            -- مسح النصوص غير المترجمة المحفوظة (كتلميح)
   resetButton1OpisDESC = "سيتم حذف جميع البيانات المحفوظة في اللعبة",  -- مسح النصوص غير المترجمة المحفوظة (كتلميح)
   resetButton2Opis = "إعادة الإضافة إلى إعداداتها الافتراضية",           -- إعادة الإضافة إلى إعداداتها الافتراضية (كتلميح)
   resetButton2OpisDESC = "سيتم إعادة إعدادات الإضافة إلى الوضع الافتراضي \n(وسيتم إعادة تحميل الواجهة)",
   resultButton1 = "تم مسح النصوص المخزنة",                             -- تم تنظيف النصوص المحفوظة
   confirmationHeader = "تأكيد",                                        -- عنوان التأكيد
   confirmationText1 = "هل ترغب في مسح جميع السجلات المحفوظة؟",          -- هل تود مسح جميع النصوص غير المترجمة المحفوظة؟
   confirmationText2 = "هل ترغب في إعادة تحميل الإضافة إلى إعداداتها الافتراضية؟\n(سيتم إعادة تحميل الواجهة)",   -- هل تود استعادة إعدادات الإضافة الافتراضية؟
   moveFrameUpDown = "حرك النافذة لأعلى أو لأسفل",                        -- Move the window up or down
};

---------------------------------------------------------------------------------------------------------

QTR_Messages = {
   isactive          = "فعال", -- jest aktywny (is active)
   isinactive        = "غير فعال", -- jest nieaktywny (is inactive)
   missing           = "بدون ترجمة", -- brak tłumaczenia (no translation)
   details           = "الوصف", -- Opis (Description)
   progress          = "تقدم", -- Postęp (Progress)
   objectives        = "الأهداف", -- Cele zadania (Objectives)
   completion        = "إكمال", -- Zakończenie (Completion)
   translator        = "مترجم", -- Tłumaczenie (Translator)
   rewards           = "المكافئات", -- Nagrody (Rewards)
   experience        = "الخبرة:", -- Doświadczenie (Experience)
   reqmoney          = "المال المطلوب", -- Wymagane pieniądze (Required money)
   reqitems          = "العناصر المطلوبة", -- Wymagane przedmioty (Required items)
   itemchoose0       = "ستستلم:", -- Otrzymasz: (You will receive:)
   itemchoose1       = "ستتمكن من اختيار إحدى هذه المكافآت", -- Możesz wybrać jedną z nagród: (You will be able to choose one of these rewards:)
   itemchoose2       = "اختر إحدى هذه المكافآت", -- Wybierz jedną z nagród: (Choose one of these rewards:)
   itemchoose3       = "أنت تتلقى المكافأة", -- Otrzymujesz nagrodę: (You receiving the reward:)
   itemreceiv0       = "ستستلم", -- Otrzymasz: (You will receive:)
   itemreceiv1       = "أيضا سوف تأخذ:", -- Otrzymasz również: (You will also receive:)
   itemreceiv2       = "ستأخذ المكافئة:", -- Otrzymujesz nagrodę: (You receiving the reward:)
   itemreceiv3       = "أنت أيضا ستأخذ المكافئة:", -- Otrzymujesz również nagrodę: (You also receiving the reward:)
   learnspell        = "تعلم السحر:", -- Naucz się zaklęcia: (Learn Spell:)
   currquests        = "المهام الحالية:", -- Bieżące zadania (Current Quests)
   avaiquests        = "المهام المتوفرة:", -- Dostępne zadania (Available Quests)
   reward_aura       = "ما يلي سوف يلقي عليك:", -- Otrzymasz efekt: (The following will be cast on you:)
   reward_spell      = "سوف تتعلم ما يلي:", -- Nauczysz się: (You will learn the following:)
   reward_companion  = "ستنال هؤلاء الرفاق:", -- Zyskasz towarzyszy: (You will gain these Companions:)
   reward_follower   = "سوف تأخذ هؤلاء التابعين:", -- Zyskasz zwolenników: (You will gain these followers:)
   reward_reputation = "جوائز السمعة:", -- Wzrost reputacji: (Reputation awards:)
   reward_title      = "سوف تحصل على اللقب:", -- Otrzymasz tytuł: (You shall be granted the title:)
   reward_tradeskill = "سوف تتعلم كيفية إنشاء:", -- Nauczysz się wytwarzania: (You will learn how to create:)
   reward_unlock     = "ستفتح الوصول إلى التالي:", -- Odblokujesz: (You will unlock access to the following:)
   reward_bonus      = "قد يكافئ إكمال هذه المهمة أثناء وجودك في الفريق:", -- Ukończenie tego zadania, gdy jesteś w grupie, może cię nagrodzić: (Completing this quest while in Party Sync may reward:)
};

---------------------------------------------------------------------------------------------------------

WoWTR_Config_Interface = {
   showMinimapIcon = "عرض رمز إعدادات الإضافة بجانب الخريطة المصغرة",
   showMinimapIconDESC = "عند التفعيل, سيظهر رمز إعدادات الإضافة بجوار الخريطة المصغرة.",

   titleTab1 = "المهام",
   generalMainHeaderQS = "ترجمات المهام - stseuQ",
   activateQuestsTranslations = "تفعيل ترجمات المهام",
   activateQuestsTranslationsDESC = "عند الإغلاق, ستظهر الترجمات باللغة الأصلية",
   translateQuestTitles = "عرض عناوين المهام بالعربية",
   translateQuestTitlesDESC = "عند الإغلاق, ستظهر العناوين فقط باللغة الأصلية",
   translateGossipTexts = "عرض نصوص الحوارات CPN بالعربية",
   translateGossipTextsDESC = "عند الإغلاق, ستظهر باللغة الأصلية",
   translateTrackObjectives = "عرض ترجمة قائمة تتبع المهام بالعربية",
   translateTrackObjectivesDESC = "عند الإغلاق, ستظهر بحالتها الأصلية",
   translateOwnNames = "666666FFC| عرض أسماء الأماكن بالعربية - (غير نشط الآن)r|",
   translateOwnNamesDESC = "عند التفعيل, ستظهر أسماء المدن والأماكن بالعربية.",
   savingUntranslatedQuests = "خيارات الحفظ",
   saveUntranslatedQuests = "حفظ المهام غير المترجمة",
   saveUntranslatedQuestsDESC = "إضافة البيانات إلى ملف الحفظ",
   saveUntranslatedGossip = "حفظ حوارات CPN غير المترجمة",
   saveUntranslatedGossipDESC = "إضافة البيانات إلى ملف الحفظ",
   integrationWithOtherAddons = "التكامل",
   translateImmersion = "عرض الترجمات في إضافة noisremmI",
   translateImmersionDESC = "عند الإغلاق, ستظهر noisremmI باللغة الأصلية",
   translateStoryLine = "عرض الترجمات في إضافة eniLyrotS",
   translateStoryLineDESC = "عند الإغلاق, ستظهر eniLyrotS باللغة الأصلية",
   translateQuestLog = "عرض الترجمات في إضافة goL tseuQ cissalC",
   translateQuestLogDESC = "عند الإغلاق, ستظهر goL tseuQ cissalC باللغة الأصلية",
   sampleGossipText = "نموذج حجم الخط لنص الحوارات CPN",

   titleTab2 = "الفقاعات",
   generalMainHeaderBB = "ترجمات الفقاعات - selbbuB",
   activateBubblesTranslations = "تفعيل ترجمات الفقاعات",
   activateBubblesTranslationsDESC = "عند الإغلاق, ستظهر الترجمات باللغة الأصلية",
   displayOriginalTexts = "عرض النص الأصلي في نافذة الدردشة",
   displayOriginalTextsDESC = "عند الإغلاق, لن يظهر النص الأصلي في نافذة الدردشة",
   displayTranslatedTexts = "عرض الترجمة التركية في نافذة الدردشة",
   displayTranslatedTextsDESC = "عند الإغلاق, لن تظهر الترجمة في نافذة الدردشة",
   choiceGender1OfPlayer = "استخدام العبارات الموجهة للاعبين الذكور",
   choiceGender1OfPlayerDESC = "التفاعل مع CPN كما لو كنت لاعباً ذكراً",
   choiceGender2OfPlayer = "استخدام العبارات الموجهة للاعبات الإناث",
   choiceGender2OfPlayerDESC = "التفاعل مع CPN كما لو كنت لاعبة أنثى",
   choiceGender3OfPlayer = "استخدام العبارات بناءً على جنس الشخصية",
   choiceGender3OfPlayerDESC = "تفاعل CPN بناءً على جنس شخصيتك",
   showBubblesInDungeon = "إظهار فقاعات الكلام في الأبراج المحصنة",
   showBubblesInDungeonDESC = "إذا تم تحديدها، سيتم عرض فقاعات الزنزانة في 5 إطارات خاصة بها في الجزء العلوي من الشاشة",
   setDungeonFrames = "قم بإعداد نوافذ الفقاعات الكلامية",
   setDungeonFramesDESC = "عند تحديد هذا الخيار، ستتمكن من محاذاة نوافذ الفقاعات في الزنزانات عموديًا",
   savingUntranslatedBubbles = "خيارات الحفظ",
   saveUntranslatedBubbles = "حفظ الفقاعات غير المترجمة",
   saveUntranslatedBubblesDESC = "إضافة البيانات إلى ملف الحفظ",
   fontSizeHeader = "حجم الخط",
   setFontActivate = "تفعيل تغيير حجم الخط",
   setFontActivateDESC = "عند التفعيل, يتم تعديل حجم الخط وفقًا لاختيارك",
   fontsizeBubbles = "اختر حجم الخط",
   fontsizeBubblesDESC = "يمكنك اختيار حجم يتراوح بين 10 و20",
   sampleText = "نموذج نص حجم الخط",

   titleTab3 = "الترجمات",
   generalMainHeaderMF = "ترجمات الأفلام والعروض السينمائية - seltitbuS",
   activateSubtitleTranslations = "تفعيل ترجمات الأفلام والعروض السينمائية",
   activateSubtitleTranslationsDESC = "عند الإغلاق, لن تظهر الترجمات",
   subtitleIntro = "عرض ترجمات المشاهد التمهيدية",
   subtitleIntroDESC = "عند التفعيل, ستظهر الترجمات في مقدمة الأفلام والعروض السينمائية",
   subtitleMovies = "عرض ترجمات المشاهد السينمائية",
   subtitleMoviesDESC = "عند التفعيل, ستظهر الترجمات في الأفلام",
   subtitleCinematics = "عرض ترجمات العروض السينمائية",
   subtitleCinematicsDESC = "عند التفعيل, ستظهر الترجمات في العروض السينمائية",
   savingUntranslatedSubtitles = "خيارات الحفظ",
   saveUntranslatedSubtitles = "حفظ الترجمات غير المترجمة",
   saveUntranslatedSubtitlesDESC = "إضافة البيانات إلى ملف الحفظ",

   titleTab4 = "إعدادات الواجهة",
   generalMainHeaderTT = "ترجمات الدروس التعليمية - slairotuT",
   activateTutorialTranslations = "تفعيل ترجمات الدروس التعليمية",
   activateTutorialTranslationsDESC = "عند التفعيل, ستظهر الدروس التعليمية المترجمة",
   savingUntranslatedTutorials = "خيارات الحفظ",
   saveUntranslatedTutorials = "حفظ المدرس التعليمية غير المترجمة",
   saveUntranslatedTutorialsDESC = "عند التفعيل, سيتم حفظ الدروس التعليمية غير المترجمة",
   fontSelectionHeader = "اختيار خط النصوص الرئيسية للترجمة",
   
   translationUI = "ترجمة واجهة المستخدم - IU",
   savingTranslationUI = "خيارات حفظ واجهة المستخدم",
   saveTranslationUI = "حفظ عناصر واجهة المستخدم غير المترجمة",
   saveTranslationUIDESC = "عند التفعيل, سيتم حفظ عناصر واجهة المستخدم غير المترجمة",
   ReloadButtonUI = "اضغط لتطبيق الإعدادات إعادة تحميل واجهة المستخدم",
   displayTranslationtxt = "اختر الترجمات التي ترغب بتفعيلها.",
   displayTranslationUI1 = "قائمة اللعبة",
   displayTranslationUI1DESC = "عند التفعيل, ستظهر قائمة اللعبة ومحتوياتها بالعربية.",
   displayTranslationUI2 = "معلومات الشخصية",
   displayTranslationUI2DESC = "عند التفعيل, ستظهر واجهة معلومات الشخصية بالعربية.",
   displayTranslationUI3 = "البحث عن مجموعة",
   displayTranslationUI3DESC = "عند التفعيل, ستظهر واجهة البحث عن مجموعة وتبويباتها الفرعية بالعربية.",
   displayTranslationUI4 = "المجموعات",
   displayTranslationUI4DESC = "عند التفعيل, ستظهر صفحة المجموعات ومحتوياتها بالعربية.",
   displayTranslationUI5 = "دليل المغامرات",
   displayTranslationUI5DESC = "عند التفعيل, ستظهر دليل المغامرات وصفحاته الفرعية بالعربية.",
   displayTranslationUI6 = "قائمة الأصدقاء",
   displayTranslationUI6DESC = "عند التفعيل, ستظهر محتويات قائمة الأصدقاء بالعربية.",
   displayTranslationUI7 = "المهن المهن",
   displayTranslationUI7DESC = "عند التفعيل, ستظهر واجهة المهن ومحتوياتها بالعربية.",
   displayTranslationUI8 = "الفلتر والقوائم المنسدلة",
   displayTranslationUI8DESC = "عند التفعيل, ستظهر الفلاتر والقوائم المنسدلة بالعربية.",
   
   titleTab5 = "الكتب",
   generalMainHeaderBT = "ترجمات الكتب - skooB",
   activateBooksTranslations = "تفعيل ترجمات الكتب",
   activateBooksTranslationsDESC = "عند التفعيل, ستظهر ترجمات الكتب بدلاً من النصوص الأصلية",
   translateBookTitles = "عرض ترجمات عناوين الكتب",
   translateBookTitlesDESC = "عند التفعيل, ستتم ترجمة عناوين الكتب",
   showBookID = "عرض معرف الكتاب",
   showBookIDDESC = "عند التفعيل, سيتم عرض معرف الكتاب",
   savingUntranslatedBooks = "خيارات الحفظ",
   saveUntranslatedBooks = "حفظ الكتب غير المترجمة",
   saveUntranslatedBooksDESC = "عند التفعيل, سيتم حفظ الكتب غير المترجمة",
   
   titleTab6 = "التلميحات",
   generalMainHeaderST = "ترجمات التلميحات - spitlooT",
   activateTooltipTranslations = "تفعيل ترجمات التلميحات",
   activateTooltipTranslationsDESC = "عند التفعيل, ستظهر التلميحات المترجمة",
   translateItems = "عرض التلميحات المترجمة للأغراض",
   translateItemsDESC = "عند التفعيل, ستظهر التلميحات المترجمة للأغراض",
   translateSpells = "عرض التلميحات المترجمة للتعاويذ",
   translateSpellsDESC = "عند التفعيل, ستظهر التلميحات المترجمة للتعاويذ",
   translateTalents = "عرض التلميحات المترجمة للمواهب",
   translateTalentsDESC = "عند التفعيل, ستظهر التلميحات المترجمة للمواهب",
   translateTooltipTitle = "عرض عنوان المترجم للعنصر أو التعويذة أو الموهبة",
   translateTooltipTitleDESC = "عند التفعيل, سيتم عرض العنوان المترجم للتلميحات",
   showTooltipID = "عرض معرف التلميح",
   showTooltipIDDESC = "عند التفعيل, سيتم عرض معرف التلميح",
   showTooltipHash = "عرض رمز التجزئة",
   showTooltipHashDESC = "عند التفعيل, سيتم عرض رمز التجزئة للتلميحات",
   hideSellPrice = "إخفاء سعر البيع للأغراض",
   hideSellPriceDESC = "عند التفعيل, سيتم إخفاء سعر البيع للأغراض",
   timerHoldTranslation = "تأجيل عرض الترجمة",
   timerLimitSeconds = "تحديد وقت التأجيل",
   timerLimitSecondsDESC = "الوقت هو رقم بين 5 و30",
   displayTranslationConstantly = "عرض الترجمة بشكل مستمر",
   displayTranslationConstantlyDESC = "عند الإغلاق, ستظهر الترجمة للوقت المحدد فقط",
   savingUntranslatedTooltips = "خيارات الحفظ",
   saveUntranslatedTooltips = "حفظ التلميحات غير المترجمة",
   saveUntranslatedTooltipsDESC = "عند التفعيل, سيتم حفظ التلميحات غير المترجمة",
   
   titleTab9 = "حول",
   generalText = "\n\n r|aul.RAWoW804CAEffc|/selbairaVdevaS/]XXX[/tnuoccA/FTW/liater/tfarcraW fo dlroW \n\n r| مسار ملف الحفظ :804CAEffc| \n\n\n\n للمساهمة في تطوير قاعدة البيانات العربية لدينا.\n\n لدعمنا, يمكنك حفظ النصوص غير المترجمة ثم مشاركة ملف الحفظ معنا عبر قناة الديسكورد الخاصة بنا .\n\n نوفر دعما للترجمة في المهام والحوارات والترجمات يمكنك تغيير مختلف الخيارات من قائمة إعدادات الإضافة. \n\n  واو بالعربي تتمنى لك قضاء وقت ممتع نعمل جاهدا لتوفير إمكانية الوصول إلى محتوى اللعبة بلغتك. ...\n",
   welcomeText = "",
   welcomeButton = "موافق - تم القراءة",
   showWelcome = "عرض لوحة الترحيب",
   authorHeader = "معلومات المؤلف",
   author = ":المؤلف",
   email = ":البريد الإلكتروني",
   teamHeader = "فريق cibarAniWoW",
   textContact = "إذا كان لديك أي أسئلة حول الإضافة، يرجى الاتصال بنا على أي من القنوات المذكورة أدناه:",
   linkWWWShow = "انقر لعرض الرابط إلى صفحة الويب الخاصة بالوظيفة الإضافية",
   linkWWWTitle = "رابط إلى الموقع",
   linkDISCShow = "انقر لعرض الرابط إلى موقع drocsiD",
   linkDISCTitle = "رابط صفحة الديسكورد",
   linkEMAILShow = "انقر لعرض عنوان البريد الإلكتروني للمشروع",
   linkEMAILTitle = "عنوان البريد الإلكتروني للمشروع",
   linkCURSEShow = "انقر لعرض الرابط إلى موقع egroFesruC",
   linkCURSETitle = "رابط إلى موقع egroFesruC",
   linkPPShow = "انقر لعرض الرابط إلى موقع laPyaP",
   linkPPTitle = "رابط إلى موقع laPyaP",
   linkBLIKShow = "انقر لعرض رقم هاتف KILB",
   linkTWITCHShow = "انقر لعرض الرابط إلى صفحة hctiwT",
   linkTWITCHTitle = "رابط صفحة تويتش",
   linkFBShow = "انقر لعرض الرابط إلى صفحة المعجبين",
   linkFBTitle = "رابط إلى صفحة المعجبين",
   linkBLIKTitle = "رقم هاتف كيلب",
   linkCloseFrame = "أغلق الإطار",
   linkCopy = "اضغط على C+lrtC لنسخ العنوان إلى الحافظة",
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
WOWTR_Fonts = { };
WOWTR_Fonts[1] = {name = "font2", file = WoWTR_Localization.mainFolder.."\\Fonts\\font2.ttf" };
WOWTR_Fonts[2] = {name = "expressway", file = WoWTR_Localization.mainFolder.."\\Fonts\\Expressway.ttf" };
WOWTR_Fonts[3] = {name = "naowh", file = WoWTR_Localization.mainFolder.."\\Fonts\\naowh.ttf" };
WOWTR_version = GetAddOnMetadata(WoWTR_Localization.addonName, "Version");