-- Arabic locale pack changelog entries
-- Unshaped copy for localization reshaper workflows.
-- Source: common/Locale/changelog.lua

WOWTR = WOWTR or {}
WOWTR.Changelog = WOWTR.Changelog or {}

-- Newest first
WOWTR.Changelog.entries = {
  {
    version = tostring(WOWTR_version or "12.00"),
    -- NOTE: Hardcode release dates; do NOT use date() which evaluates at addon load.
    date = "13 Feb 2026",
    color = "legendary",
    type = "Fix",
    author = "WoWLang",
    title = "ﺗﺤﺴﻴﻨﺎت ﺷﺎﺷﺔ اﻟﺘﺮﺣﻴﺐ اﻟﻌﺮﺑﻴﺔ",
    description =
      "ﺗﻢ ﺗﺤﺴﻴﻦ ﻋﺮض ﻧﺺ اﻟﺘﺮﺣﻴﺐ اﻟﻌﺮﺑﻲ داﺧﻞ اﻟﻨﺎﻓﺬة ﻟﻀﻤﺎن اﻟﺘﻔﺎف أدق ﻟﻠﺠﻤﻞ اﻟﻄﻮﻳﻠﺔ.\n\n"
      .. "- ﺗﺤﺴﻴﻦ ﻛﺴﺮ اﻷﺳﻄﺮ ﻓﻲ اﻟﻔﻘﺮات اﻟﻄﻮﻳﻠﺔ داﺧﻞ ﺷﺎﺷﺔ اﻟﺘﺮﺣﻴﺐ\n"
      .. "- ﺗﺤﺴﻴﻦ ﺗﺮﺗﻴﺐ اﻟﻜﻠﻤﺎت ﻋﻨﺪ ﻧﻬﺎﻳﺔ اﻟﺴﻄﺮ ﻟﻴﻈﻬﺮ اﻟﻨﺺ ﺑﺸﻜﻞ ﻃﺒﻴﻌﻲ\n"
      .. "- ﺗﺤﺴﻴﻦ ﺛﺒﺎت ﻋﺮض اﻟﻨﺺ ﻋﻨﺪ ﻓﺘﺢ اﻟﻨﺎﻓﺬة ﻷول ﻣﺮة\n"
      .. "- ﻣﻌﺎﻟﺠﺔ ﺳﻄﺮ ﻣﺜﻞ: ﻓﻲ ﺗﺤﺴﻴﻦ وﺗﻮﺳﻴﻊ ﻟﻴﻈﻬﺮ ﺑﺸﻜﻞ أوﺿﺢ"
  },
  {
    version = "11.20",
    date = "05 Sep 2025",
    color = "purple",
    type = "Feature",
    author = "WoWLang",
    title = "ﺗﺤﺪﻳﺜﺎت ﻣﺬﻛﺮات اﻹﺻﺪار",
    description =
      "ﺗﻤﺖ إﺿﺎﻓﺔ ﻗﺴﻢ )ﻣﺎ اﻟﺠﺪﻳﺪ؟( داﺧﻞ ﻟﻮﺣﺔ اﻹﻋﺪادات ﻟﻌﺮض اﻟﺘﻐﻴﻴﺮات ﺑﺸﻜﻞ أوﺿﺢ.\n\n"
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
      "ﺗﻢ ﺗﺤﺴﻴﻦ ﻋﺮض اﻟﻨﺺ اﻟﻌﺮﺑﻲ واﺗﺠﺎﻫﻪ ﻓﻲ ﻋﺪة واﺟﻬﺎت داﺧﻞ اﻟﻠﻌﺒﺔ.\n\n"
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
      "ﺗﻤﺖ ﻣﻌﺎﻟﺠﺔ ﻣﺸﺎﻛﻞ ﻛﺎﻧﺖ ﺗﺴﺒﺐ رﺟﻮع ﺑﻌﺾ اﻟﻨﺼﻮص إﻟﻰ اﻟﻠﻐﺔ اﻷﺻﻠﻴﺔ أﺛﻨﺎء اﻟﻠﻌﺐ.\n\n"
      .. "- ﺗﺤﺴﻴﻦ ﺛﺒﺎت ﺗﻄﺒﻴﻖ اﻟﺘﺮﺟﻤﺔ ﻋﻨﺪ ﻓﺘﺢ اﻟﻮاﺟﻬﺎت\n"
      .. "- ﺗﺤﺴﻴﻦ اﻟﺘﺒﺪﻳﻞ ﺑﻴﻦ اﻟﻌﺮﺑﻴﺔ واﻹﻧﺠﻠﻴﺰﻳﺔ ﺑﺪون ﺗﻌﺎرض\n"
      .. "- ﺗﻘﻠﻴﻞ ﺣﺎﻻت اﺧﺘﻔﺎء اﻟﺘﺮﺟﻤﺔ ﺑﺸﻜﻞ ﻣﻔﺎﺟﺊ"
  },
}
