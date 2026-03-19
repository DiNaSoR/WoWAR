-- Arabic locale pack changelog entries
-- Unshaped copy for localization reshaper workflows.
-- Source: common/Locale/changelog.lua

WOWTR = WOWTR or {}
WOWTR.Changelog = WOWTR.Changelog or {}

-- Newest first
WOWTR.Changelog.entries = {
  {
    version = tostring(WOWTR_version or "12.03"),
    -- NOTE: Hardcode release dates; do NOT use date() which evaluates at addon load.
    date = "19 Mar 2026",
    color = "blue",
    type = "Improvement",
    author = "WoWLang",
    title = "تحسينات الترجمة داخل الواجهات",
    description =
      "يجلب هذا التحديث تحسينات أوسع لعرض النصوص العربية داخل عدة واجهات في اللعبة.\n"
      .. "- تحسين عرض نصوص المهام والمكافآت داخل خريطة العالم بشكل أوضح\n"
      .. "- تحسين ترجمة دليل المغامرات والدروس مع محاذاة عربية أفضل\n"
      .. "- تحديث المزيد من الشروحات والنصوص العربية داخل الواجهات"
  },
  {
    version = "11.20",
    date = "05 Sep 2025",
    color = "purple",
    type = "Feature",
    author = "WoWLang",
    title = "ﺗﺤﺪﻳﺜﺎت ﻣﺬﻛﺮات اﻹﺻﺪار",
    description =
      "ﺗﻤﺖ إﺿﺎﻓﺔ ﻗﺴﻢ )ﻣﺎ اﻟﺠﺪﻳﺪ؟( داﺧﻞ ﻟﻮﺣﺔ اﻹﻋﺪادات ﻟﻌﺮض اﻟﺘﻐﻴﻴﺮات ﺑﺸﻜﻞ أوﺿﺢ.\n"
      .. "- ﻋﺮض اﻟﺘﺤﺪﻳﺜﺎت ﺑﻄﺮﻳﻘﺔ ﻣﻨﻈﻤﺔ وﺳﻬﻠﺔ اﻟﺘﺼﻔﺢ\n"
      .. "- ﺗﺤﺴﻴﻦ ﻣﻈﻬﺮ اﻟﻨﺺ اﻟﻌﺮﺑﻲ داﺧﻞ ﺻﻔﺤﺔ اﻟﻤﻼﺣﻈﺎت\n"
      .. "- ﺗﺤﺴﻴﻦ ﻗﺮاءة اﻷﺳﻄﺮ اﻟﻄﻮﻳﻠﺔ وﺗﻘﻠﻴﻞ اﻟﺘﻜﺪس"
  },
  {
    version = "11.19",
    date = "04 Sep 2025",
    color = "blue",
    type = "Improvement",
    author = "WoWLang",
    title = "ﺗﺤﺴﻴﻨﺎت ﻟﻠﻨﺺ اﻟﻌﺮﺑﻲ",
    description =
      "ﺗﻢ ﺗﺤﺴﻴﻦ ﻋﺮض اﻟﻨﺺ اﻟﻌﺮﺑﻲ واﺗﺠﺎﻫﻪ ﻓﻲ ﻋﺪة واﺟﻬﺎت داﺧﻞ اﻟﻠﻌﺒﺔ.\n"
      .. "- ﻣﻨﻊ ﻇﻬﻮر ﻋﻨﺎوﻳﻦ ﻋﺮﺑﻴﺔ ﻣﻊ ﻧﺺ إﻧﺠﻠﻴﺰي ﻏﻴﺮ ﻣﺘﺮﺟﻢ\n"
      .. "- ﺗﺤﺴﻴﻦ ﺛﺒﺎت اﻟﺮﻣﻮز واﻷﻳﻘﻮﻧﺎت داﺧﻞ اﻟﻨﺼﻮص\n"
      .. "- ﺗﺤﺴﻴﻦ ﺗﻨﺴﻴﻖ ﻧﺼﻮص اﻟﻤﻬﺎم ﻟﺘﻜﻮن أوﺿﺢ أﺛﻨﺎء اﻟﻘﺮاءة"
  },
  {
    version = "11.18",
    date = "03 Sep 2025",
    color = "red",
    type = "Fix",
    author = "WoWLang",
    title = "إﺻﻼﺣﺎت اﺳﺘﻘﺮار اﻟﺘﺮﺟﻤﺔ",
    description =
      "ﺗﻤﺖ ﻣﻌﺎﻟﺠﺔ ﻣﺸﺎﻛﻞ ﻛﺎﻧﺖ ﺗﺴﺒﺐ رﺟﻮع ﺑﻌﺾ اﻟﻨﺼﻮص إﻟﻰ اﻟﻠﻐﺔ اﻷﺻﻠﻴﺔ أﺛﻨﺎء اﻟﻠﻌﺐ.\n"
      .. "- ﺗﺤﺴﻴﻦ ﺛﺒﺎت ﺗﻄﺒﻴﻖ اﻟﺘﺮﺟﻤﺔ ﻋﻨﺪ ﻓﺘﺢ اﻟﻮاﺟﻬﺎت\n"
      .. "- ﺗﺤﺴﻴﻦ اﻟﺘﺒﺪﻳﻞ ﺑﻴﻦ اﻟﻌﺮﺑﻴﺔ واﻹﻧﺠﻠﻴﺰﻳﺔ ﺑﺪون ﺗﻌﺎرض\n"
      .. "- ﺗﻘﻠﻴﻞ ﺣﺎﻻت اﺧﺘﻔﺎء اﻟﺘﺮﺟﻤﺔ ﺑﺸﻜﻞ ﻣﻔﺎﺟﺊ"
  },
}
