-- Arabic locale pack changelog entries
-- Loaded before common/UI/Changelog.lua. Populates WOWTR.Changelog.entries

WOWTR = WOWTR or {}
WOWTR.Changelog = WOWTR.Changelog or {}

-- Newest first
WOWTR.Changelog.entries = {
  {
    version = tostring(WOWTR_version or "12.00"),
    -- NOTE: Hardcode release dates; do NOT use date() which evaluates at addon load.
    date = "31 Dec 2025",
    color = "legendary",
    type = "Feature",
    author = "WoWLang",
    title = "ﻟﻮﺣﺔ ﺇﻋﺪﺍﺩﺍﺕ ﺟﺪﻳﺪة",
    description =
      "ﺗﻢﺖ ﺇﺿﺎﻓﺔ ﻟﻮﺣﺔ ﺇﻋﺪﺍﺩﺍﺕ ﺟﺪﻳﺪة ﻣﺴﺘﻮﺣﺎة ﻣﻦ ﻭاﺟﻬﺔ ﺑﻠَﻤﺒَﺮ، ﻣﻊ ﺑﺤﺚ ﻭﺗﺼﻨﻴﻒ ﻭﻣﻌﺎﻳﻨﺔ ﻟﻠﻤﻴﺰات.\n\n"
      .. "- ﺍﺳﺘﺒﺪال ﻭﺍﺟﻬﺔ اﻟﺨﻴﺎرات اﻟﻘﺪﻳﻤﺔ ﺑﻮاﺟﻬﺔ ﺟﺪﻳﺪة ﻛﺎﻣﻠﺔ\n"
      .. "- ﺗﺤﺴﻴﻦ ﻋﺮﺽ اﻟﺨﻂ اﻟﻌﺮﺑﻲ ﻭاﻟﺘﺸﻜﻴﻞ ﻭاﻟﺘﺮﺗﻴﺐ ﻣﻦ اﻟﻴﻤﻴﻦ ﻟﻠﻴﺴﺎر\n"
      .. "- ﺇﺻﻼﺣﺎت ﻓﻲ ﺣﺪﻭد اﻟﻨﺎﻓﺬة ﻭﺗﺒﻮﻳﺒﺎت اﻟﺄﺳﻔﻞ ﻭاﻹﻏﻼﻕ ﺑﺰﺭ اﻟﻬﺮوب"
  },
  {
    version = "11.20",
    date = "05 Sep 2025",
    color = "purple",
    type = "Feature",
    author = "WoWLang",
    title = "ﺛﻢ ﺗﻌﺎل أﻳﻬﺎ اﻟﻨﺎﺳﻚ! - 2",
    description =
      "ﺗﻢﺖ ﺇﺿﺎﻓﺔ ﻗﺴﻢ (ﻣﺎ اﻟﺠﺪﻳﺪ؟) ﻣﻊ ﻋﺮﺽ ﻣﻔﺼﻞ ﻟﻠﺘﻐﻴﻴﺮات.\n\n"
      .. "- ﻋﺮﺽ اﻟﺘﺤﺪﻳﺜﺎت ﺑﺸﻜﻞ ﻣﻨﻈﻢ ﻭﻣﻊ ﺗﻤﺮﻳﺮ\n"
      .. "- ﺗﺤﺴﻴﻦ ﻣﻄﺎﺑﻘﺔ اﻟﻨﺺ اﻟﻌﺮﺑﻲ ﻣﻊ اﻟﺨﻂ\n"
      .. "- ﺗﺤﺴﻴﻦ ﻋﺮﺽ اﻟﻨﺼﻮﺹ اﻟﻄﻮﻳﻠﺔ ﻭاﻟﻤﺴﺎﻓﺎت"
  },
  {
    version = "11.19",
    date = "04 Sep 2025",
    color = "blue",
    type = "Improvement",
    author = "WoWLang",
    title = "ﺗﺤﺴﻴﻨﺎت ﻟﻠﻨﺺ اﻟﻌﺮﺑﻲ",
    description =
      "ﺗﺤﺴﻴﻦ ﺗﺸﻜﻴﻞ اﻟﻨﺺ ﻭاﻟﺘﻌﺎﻣﻞ ﻣﻊ اﺗﺠﺎﻩ اﻟﻨﺺ ﻓﻲ ﻋﺪة ﻭاﺟﻬﺎت.\n\n"
      .. "- ﻣﻨﻊ ﻇﻬﻮﺭ ﻋﻨﺎﻭﻳﻦ ﻋﺮﺑﻴﺔ ﻣﻊ ﻣﺤﺘﻮﻯ ﺇﻧﺠﻠﻴﺰي ﻋﻨﺪ ﻋﺪم ﺗﻮﻓﺮ ﺑﻴﺎﻧﺎت اﻟﺘﺮﺟﻤﺔ\n"
      .. "- ﺗﺤﺴﻴﻦ ﺣﻔﻆ اﻟﺮﻣﻮز ﻭاﻟﺄﻳﻘﻮﻧﺎت ﺩاﺧﻞ اﻟﻨﺺ\n"
      .. "- ﺗﺤﺴﻴﻦ اﻟﺘﻨﺴﻴﻖ ﻭاﻟﺘﻔﺎﺻﻴﻞ ﺑﺎﻟﻤﻬﺎم"
  },
  {
    version = "11.18",
    date = "03 Sep 2025",
    color = "red",
    type = "Fix",
    author = "WoWLang",
    title = "ﺇﺻﻼﺣﺎت اﺳﺘﻘﺮار اﻟﺘﺮﺟﻤﺔ",
    description =
      "ﺗﻤﺖ ﺇﺻﻼﺣﺎت ﻻﺳﺘﻘﺮار ﺗﺮﺟﻤﺔ اﻟﻤﻬﺎم ﻭﻣﻨﻊ اﺭﺗﺪاد اﻟﻮاﺟﻬﺔ ﺇﻟﻰ اﻟﻨﺺ اﻷﺻﻠﻲ.\n\n"
      .. "- ﺗﺤﺴﻴﻦ اﻟﺘﻄﺒﻴﻖ ﺑﻌﺪ اﻟﺘﺨﻄﻴﻂ\n"
      .. "- ﺗﺤﺴﻴﻦ ﺗﻌﺎﻣﻞ اﻟﺘﺒﺪﻳﻞ ﺑﻴﻦ اﻟﻌﺮﺑﻴﺔ/اﻹﻧﺠﻠﻴﺰﻳﺔ ﺩون ﺗﻌﺎرض"
  },
}






