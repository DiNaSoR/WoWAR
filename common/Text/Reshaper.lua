-- Authors: Platine, Dragonarab[DiNaSoR]
-- Based on: UTF8 library by Kyle Smith
-- Enhanced: Added diacritics, Persian/Urdu support, performance optimizations, and bug fixes
-------------------------------------------------------------------------------------------------------

-- debug_show_form has been replaced by the unified WOWTR.Debug gate (general category, VERBOSE level).
-- Set via /wowardebug preset full-trace  (or  /wowardebug on  +  set general verbosity to 4 in the panel).
local function RS_IsDebugForm()
  return WOWTR and WOWTR.Debug and WOWTR.Debug.ShouldPrint
    and WOWTR.Debug.ShouldPrint("general", 4)
end

-------------------------------------------------------------------------------------------------------
-- Arabic Diacritics (Harakat/Tashkeel) - These are combining marks that don't change shape
-- but need to be preserved and handled correctly during reshaping.
-- Diacritics should stay attached to their base character and not affect position detection.
-------------------------------------------------------------------------------------------------------
-- WoW's FontString renderer does not reliably position Unicode combining marks (tashkeel)
-- using OpenType anchors, so marks like "ً" may appear on the baseline in-game.
-- Workaround: convert common harakat (U+064B..U+0652) into Arabic Presentation Forms
-- (U+FE70..U+FE7E) which are spacing glyphs that fonts often render in the correct vertical position.
-- IMPORTANT: These presentation-form marks are *spacing* glyphs. In many fonts (e.g. Calibri),
-- they have non-zero advance width and will visually separate joined Arabic letters.
-- Therefore the default is OFF (keep proper joining). Enable only if your chosen font renders
-- these marks with zero/near-zero width and correct placement.
AS_USE_PRESENTATION_DIACRITICS = false;

-- Map common combining harakat to their presentation-form equivalents.
-- Also includes identity mappings for the presentation forms so round-trips remain stable.
AS_DiacriticPresentationForms = {
   -- U+064B..U+0652 → U+FE70..U+FE7E
   ["\217\139"] = "\239\185\176", -- ً  FATHATAN → ﹰ  FE70
   ["\217\140"] = "\239\185\178", -- ٌ  DAMMATAN → ﹲ  FE72
   ["\217\141"] = "\239\185\180", -- ٍ  KASRATAN → ﹴ  FE74
   ["\217\142"] = "\239\185\182", -- َ  FATHA    → ﹶ  FE76
   ["\217\143"] = "\239\185\184", -- ُ  DAMMA    → ﹸ  FE78
   ["\217\144"] = "\239\185\186", -- ِ  KASRA    → ﹺ  FE7A
   ["\217\145"] = "\239\185\188", -- ّ  SHADDA   → ﹼ  FE7C
   ["\217\146"] = "\239\185\190", -- ْ  SUKUN    → ﹾ  FE7E
   -- identity for already-converted marks
   ["\239\185\176"] = "\239\185\176", -- ﹰ
   ["\239\185\178"] = "\239\185\178", -- ﹲ
   ["\239\185\180"] = "\239\185\180", -- ﹴ
   ["\239\185\182"] = "\239\185\182", -- ﹶ
   ["\239\185\184"] = "\239\185\184", -- ﹸ
   ["\239\185\186"] = "\239\185\186", -- ﹺ
   ["\239\185\188"] = "\239\185\188", -- ﹼ
   ["\239\185\190"] = "\239\185\190", -- ﹾ
};

AS_Diacritics = {
   ["\217\139"] = true,  -- FATHATAN (ً) U+064B - tanween fath
   ["\217\140"] = true,  -- DAMMATAN (ٌ) U+064C - tanween damm
   ["\217\141"] = true,  -- KASRATAN (ٍ) U+064D - tanween kasr
   ["\217\142"] = true,  -- FATHA (َ) U+064E - short a
   ["\217\143"] = true,  -- DAMMA (ُ) U+064F - short u
   ["\217\144"] = true,  -- KASRA (ِ) U+0650 - short i
   ["\217\145"] = true,  -- SHADDA (ّ) U+0651 - gemination mark
   ["\217\146"] = true,  -- SUKUN (ْ) U+0652 - no vowel
   -- Presentation-form harakat (spacing marks) for WoW rendering compatibility
   ["\239\185\176"] = true, -- ﹰ ARABIC FATHATAN ISOLATED FORM U+FE70
   ["\239\185\178"] = true, -- ﹲ ARABIC DAMMATAN ISOLATED FORM U+FE72
   ["\239\185\180"] = true, -- ﹴ ARABIC KASRATAN ISOLATED FORM U+FE74
   ["\239\185\182"] = true, -- ﹶ ARABIC FATHA ISOLATED FORM U+FE76
   ["\239\185\184"] = true, -- ﹸ ARABIC DAMMA ISOLATED FORM U+FE78
   ["\239\185\186"] = true, -- ﹺ ARABIC KASRA ISOLATED FORM U+FE7A
   ["\239\185\188"] = true, -- ﹼ ARABIC SHADDA ISOLATED FORM U+FE7C
   ["\239\185\190"] = true, -- ﹾ ARABIC SUKUN ISOLATED FORM U+FE7E
   ["\217\147"] = true,  -- MADDAH ABOVE (ٓ) U+0653
   ["\217\148"] = true,  -- HAMZA ABOVE (ٔ) U+0654
   ["\217\149"] = true,  -- HAMZA BELOW (ٕ) U+0655
   ["\217\176"] = true,  -- SUPERSCRIPT ALEF (ٰ) U+0670
};

-------------------------------------------------------------------------------------------------------
-- Helper function to check if a character is a diacritic
-------------------------------------------------------------------------------------------------------
function AS_IsDiacritic(char)
   return AS_Diacritics[char] == true;
end

-------------------------------------------------------------------------------------------------------
-- Tatweel/Kashida - Arabic text elongation character
-- This character connects and can be used between any connecting letters
-------------------------------------------------------------------------------------------------------
AS_TATWEEL = "\217\128";  -- TATWEEL (ـ) U+0640

-------------------------------------------------------------------------------------------------------
-- Arabic-Indic Numerals mapping (Eastern Arabic numerals)
-- These don't need reshaping but should be recognized as non-connecting
-------------------------------------------------------------------------------------------------------
AS_ArabicIndicNumerals = {
   ["\217\160"] = true,  -- ٠ (0) U+0660
   ["\217\161"] = true,  -- ١ (1) U+0661
   ["\217\162"] = true,  -- ٢ (2) U+0662
   ["\217\163"] = true,  -- ٣ (3) U+0663
   ["\217\164"] = true,  -- ٤ (4) U+0664
   ["\217\165"] = true,  -- ٥ (5) U+0665
   ["\217\166"] = true,  -- ٦ (6) U+0666
   ["\217\167"] = true,  -- ٧ (7) U+0667
   ["\217\168"] = true,  -- ٨ (8) U+0668
   ["\217\169"] = true,  -- ٩ (9) U+0669
};

-------------------------------------------------------------------------------------------------------
-- Extended Arabic Punctuation
-------------------------------------------------------------------------------------------------------
AS_ArabicPunctuation = {
   ["\216\159"] = true,  -- ؟ Arabic Question Mark U+061F
   ["\216\155"] = true,  -- ؛ Arabic Semicolon U+061B
   ["\216\140"] = true,  -- ، Arabic Comma U+060C
   ["\217\170"] = true,  -- ٪ Arabic Percent Sign U+066A
   ["\217\171"] = true,  -- ٫ Arabic Decimal Separator U+066B
   ["\217\172"] = true,  -- ٬ Arabic Thousands Separator U+066C
};

-------------------------------------------------------------------------------------------------------
-- AS_Reshaping_Rules is a table that contains reshaping rules for Arabic characters.
-- Each key-value pair in the table represents a specific Arabic character and its reshaping rules.
-- The key is the original Arabic character represented as a string of bytes.
-- The value is a table that contains the reshaping rules for the character, including isolated, initial, middle, and final forms.
-- The reshaping rules are represented as strings of bytes.
-- The reshaped forms are used to correctly display Arabic text in different contexts.
-------------------------------------------------------------------------------------------------------
AS_Reshaping_Rules = {
   -- ===== BASIC ARABIC ALPHABET (28 letters + variants) =====
   ["\216\167"] = { isolated = "\216\167", initial = "\216\167", middle = "\239\186\142", final = "\239\186\142" },                 -- ALEF (ا) U+0627
   ["\216\162"] = { isolated = "\239\186\129", initial = "\239\186\129", middle = "\239\186\142", final = "\239\186\142" },         -- ALEF WITH MADDA ABOVE (آ) U+0622
   ["\216\163"] = { isolated = "\216\163", initial = "\216\163", middle = "\239\186\132", final = "\239\186\132" },                 -- ALEF WITH HAMZA ABOVE (أ) U+0623
   ["\216\165"] = { isolated = "\216\165", initial = "\216\165", middle = "\239\186\136", final = "\239\186\136" },                 -- ALEF WITH HAMZA BELOW (إ) U+0625
   ["\216\168"] = { isolated = "\216\168", initial = "\239\186\145", middle = "\239\186\146", final = "\239\186\144" },             -- BEH (ب) U+0628
   ["\216\170"] = { isolated = "\216\170", initial = "\239\186\151", middle = "\239\186\152", final = "\239\186\150" },             -- TEH (ت) U+062A
   ["\216\171"] = { isolated = "\216\171", initial = "\239\186\155", middle = "\239\186\156", final = "\239\186\154" },             -- THEH (ث) U+062B
   ["\216\172"] = { isolated = "\216\172", initial = "\239\186\159", middle = "\239\186\160", final = "\239\186\158" },             -- JEEM (ج) U+062C
   ["\216\173"] = { isolated = "\216\173", initial = "\239\186\163", middle = "\239\186\164", final = "\239\186\162" },             -- HAH (ح) U+062D
   ["\216\174"] = { isolated = "\216\174", initial = "\239\186\167", middle = "\239\186\168", final = "\239\186\166" },             -- KHAH (خ) U+062E
   ["\216\175"] = { isolated = "\216\175", initial = "\216\175", middle = "\239\186\170", final = "\239\186\170" },                 -- DAL (د) U+062F - non-connecting
   ["\216\176"] = { isolated = "\216\176", initial = "\216\176", middle = "\239\186\172", final = "\239\186\172" },                 -- THAL (ذ) U+0630 - non-connecting
   ["\216\177"] = { isolated = "\216\177", initial = "\216\177", middle = "\239\186\174", final = "\239\186\174" },                 -- REH (ر) U+0631 - non-connecting
   ["\216\178"] = { isolated = "\216\178", initial = "\216\178", middle = "\239\186\176", final = "\239\186\176" },                 -- ZAIN (ز) U+0632 - non-connecting
   ["\216\179"] = { isolated = "\216\179", initial = "\239\186\179", middle = "\239\186\180", final = "\239\186\178" },             -- SEEN (س) U+0633
   ["\216\180"] = { isolated = "\216\180", initial = "\239\186\183", middle = "\239\186\184", final = "\239\186\182" },             -- SHEEN (ش) U+0634
   ["\216\181"] = { isolated = "\216\181", initial = "\239\186\187", middle = "\239\186\188", final = "\239\186\186" },             -- SAD (ص) U+0635
   ["\216\182"] = { isolated = "\216\182", initial = "\239\186\191", middle = "\239\187\128", final = "\239\186\190" },             -- DAD (ض) U+0636
   ["\216\183"] = { isolated = "\216\183", initial = "\239\187\131", middle = "\239\187\132", final = "\239\187\130" },             -- TAH (ط) U+0637
   ["\216\184"] = { isolated = "\216\184", initial = "\239\187\135", middle = "\239\187\136", final = "\239\187\134" },             -- ZAH (ظ) U+0638
   ["\216\185"] = { isolated = "\216\185", initial = "\239\187\139", middle = "\239\187\140", final = "\239\187\138" },             -- AIN (ع) U+0639
   ["\216\186"] = { isolated = "\216\186", initial = "\239\187\143", middle = "\239\187\144", final = "\239\187\142" },             -- GHAIN (غ) U+063A
   ["\217\129"] = { isolated = "\217\129", initial = "\239\187\147", middle = "\239\187\148", final = "\239\187\146" },             -- FEH (ف) U+0641
   ["\217\130"] = { isolated = "\217\130", initial = "\239\187\151", middle = "\239\187\152", final = "\239\187\150" },             -- QAF (ق) U+0642
   ["\217\131"] = { isolated = "\217\131", initial = "\239\187\155", middle = "\239\187\156", final = "\239\187\154" },             -- KAF (ك) U+0643
   ["\217\132"] = { isolated = "\217\132", initial = "\239\187\159", middle = "\239\187\160", final = "\239\187\158" },             -- LAM (ل) U+0644
   ["\217\133"] = { isolated = "\217\133", initial = "\239\187\163", middle = "\239\187\164", final = "\239\187\162" },             -- MEEM (م) U+0645
   ["\217\134"] = { isolated = "\217\134", initial = "\239\187\167", middle = "\239\187\168", final = "\239\187\166" },             -- NOON (ن) U+0646
   ["\217\138"] = { isolated = "\217\138", initial = "\239\187\179", middle = "\239\187\180", final = "\239\187\178" },             -- YEH (ي) U+064A
   ["\216\166"] = { isolated = "\216\166", initial = "\239\186\139", middle = "\239\186\140", final = "\239\186\138" },             -- YEH WITH HAMZA ABOVE (ئ) U+0626
   ["\217\137"] = { isolated = "\217\137", initial = "\217\137", middle = "\217\137", final = "\239\187\176" },                     -- ALEF MAKSURA (ى) U+0649 - non-connecting
   ["\217\136"] = { isolated = "\217\136", initial = "\217\136", middle = "\239\187\174", final = "\239\187\174" },                 -- WAW (و) U+0648 - non-connecting
   ["\216\164"] = { isolated = "\216\164", initial = "\216\164", middle = "\239\186\134", final = "\239\186\134" },                 -- WAW WITH HAMZA ABOVE (ؤ) U+0624 - non-connecting
   ["\217\135"] = { isolated = "\239\187\169", initial = "\239\187\171", middle = "\239\187\172", final = "\239\187\170" },         -- HEH (ه) U+0647 (FIXED: was incorrectly labeled HAH)
   ["\216\169"] = { isolated = "\216\169", initial = "\216\169", middle = "\216\169", final = "\239\186\148" },                     -- TEH MARBUTA (ة) U+0629 (FIXED: was incorrectly labeled TAH)
   ["\239\187\187"] = { isolated = "\239\187\187", initial = "\239\187\187", middle = "\239\187\188", final = "\239\187\188" },     -- LAM WITH ALEF ligature
   ["\239\187\181"] = { isolated = "\239\187\181", initial = "\239\187\181", middle = "\239\187\182", final = "\239\187\182" },     -- LAM WITH ALEF WITH MADDA ligature
   ["\217\132\216\163"] = { isolated = "\239\187\183", initial = "\239\187\183", middle = "\239\187\184", final = "\239\187\184" }, -- LAM WITH ALEF WITH HAMZA ABOVE
   ["\217\132\216\165"] = { isolated = "\239\187\185", initial = "\239\187\185", middle = "\239\187\186", final = "\239\187\186" }, -- LAM WITH ALEF WITH HAMZA BELOW
   ["\216\161"] = { isolated = "\216\161", initial = "\216\161", middle = "\216\161", final = "\216\161" },                         -- HAMZA (ء) U+0621 - non-connecting

   -- ===== TATWEEL (Kashida) - Arabic text elongation =====
   ["\217\128"] = { isolated = "\217\128", initial = "\217\128", middle = "\217\128", final = "\217\128" },                         -- TATWEEL (ـ) U+0640 - connects both sides

   -- ===== PERSIAN/URDU EXTENSIONS =====
   -- These letters have their correct presentation forms in Arabic Presentation Forms-A (FB50–FDFF),
   -- not in Forms-B (FE70–FEFF). Using the wrong code points renders *different* Arabic letters.
   ["\217\190"] = { isolated = "\217\190", initial = "\239\173\152", middle = "\239\173\153", final = "\239\173\151" },             -- PEH (پ) U+067E → FB58/FB59/FB57
   ["\218\134"] = { isolated = "\218\134", initial = "\239\173\188", middle = "\239\173\189", final = "\239\173\187" },             -- TCHEH (چ) U+0686 → FB7C/FB7D/FB7B
   ["\218\152"] = { isolated = "\218\152", initial = "\218\152", middle = "\239\174\139", final = "\239\174\139" },                 -- JEH (ژ) U+0698 (non-connecting) → FB8B (final)
   ["\218\175"] = { isolated = "\218\175", initial = "\239\174\148", middle = "\239\174\149", final = "\239\174\147" },             -- GAF (گ) U+06AF → FB94/FB95/FB93
   ["\218\169"] = { isolated = "\218\169", initial = "\239\174\144", middle = "\239\174\145", final = "\239\174\143" },             -- KEHEH (ک) U+06A9 → FB90/FB91/FB8F
   ["\218\140"] = { isolated = "\218\140", initial = "\218\140", middle = "\239\174\133", final = "\239\174\133" },                 -- DAHAL (ڌ) U+068C (non-connecting) → FB85 (final)
   ["\219\140"] = { isolated = "\219\140", initial = "\239\175\190", middle = "\239\175\191", final = "\239\175\189" },             -- FARSI YEH (ی) U+06CC → FBFE/FBFF/FBFD

   -- ===== ADDITIONAL ARABIC LETTERS =====
   -- Note: HAMZA (ء) U+0621 is already defined above at line 123
   ["\218\129"] = { isolated = "\218\129", initial = "\218\129", middle = "\218\129", final = "\218\129" },                         -- HAMZA ON HIGH (ځ) U+0681
};

-------------------------------------------------------------------------------------------------------
-- Arabic ligature
-- AS_Reshaping_Rules2 is a table that contains reshaping rules for Arabic ligatures.
-- Each key-value pair represents a ligature and its corresponding reshaping rules.
-- The ligature is represented by a concatenation of two characters.
-- The reshaping rules include isolated, initial, middle, and final forms of the ligature.
-- The isolated form is used when the ligature appears alone.
-- The initial form is used when the ligature appears at the beginning of a word.
-- The middle form is used when the ligature appears in the middle of a word.
-- The final form is used when the ligature appears at the end of a word.
-- The reshaping rules are represented by Unicode characters.
-------------------------------------------------------------------------------------------------------

AS_Reshaping_Rules2 = {
   -- ===== LAM-ALEF LIGATURES (mandatory in Arabic typography) =====
   ["\217\132" .. "\216\167"] = { isolated = "\239\187\187", initial = "\239\187\187", middle = "\239\187\188", final = "\239\187\188" }, -- LAM + ALEF (لا) → ﻻ/ﻼ
   ["\217\132" .. "\216\163"] = { isolated = "\239\187\183", initial = "\239\187\183", middle = "\239\187\184", final = "\239\187\184" }, -- LAM + ALEF HAMZA ABOVE (لأ) → ﻷ/ﻸ
   ["\217\132" .. "\216\165"] = { isolated = "\239\187\185", initial = "\239\187\185", middle = "\239\187\186", final = "\239\187\186" }, -- LAM + ALEF HAMZA BELOW (لإ) → ﻹ/ﻺ
   ["\217\132" .. "\216\162"] = { isolated = "\239\187\181", initial = "\239\187\181", middle = "\239\187\182", final = "\239\187\182" }, -- LAM + ALEF MADDA (لآ) → ﻵ/ﻶ
};

-------------------------------------------------------------------------------------------------------
-- AS_Reshaping_Rules3 is a table that contains reshaping rules for Arabic characters.
-- Each key-value pair represents a reshaping rule for a specific character or character range.
-- The keys are character ranges, and the values are tables with properties for different forms of the character.
-------------------------------------------------------------------------------------------------------
AS_Reshaping_Rules3 = {
   --["ا".."ل".."آ"] = {isolated = "ﻵا",  initial="ﻵا", middle="ﻵا", final="ﻶا"},        -- Arabic ligature ALEF+LAM+(ALEF with MADA)
};

-------------------------------------------------------------------------------------------------------
-- VERSION AND CAPABILITY INFO
-------------------------------------------------------------------------------------------------------
AS_RESHAPER_VERSION = "2.0.0";
AS_RESHAPER_CAPABILITIES = {
   diacritics = true,           -- Supports Arabic diacritics (harakat/tashkeel)
   persian = true,              -- Supports Persian/Urdu extensions (پ چ ژ گ)
   tatweel = true,              -- Supports Tatweel/Kashida (ـ)
   arabic_indic_numerals = true, -- Recognizes Arabic-Indic numerals (٠-٩)
   extended_punctuation = true,  -- Supports Arabic punctuation (؟ ؛ ،)
};

-------------------------------------------------------------------------------------------------------
-- Utility function: Strip diacritics from Arabic text
-- Removes all harakat/tashkeel marks, leaving only base letters
-- Useful for search/comparison operations
-------------------------------------------------------------------------------------------------------
function AS_StripDiacritics(s)
   if not s or #s == 0 then return "" end
   
   local resultParts = {};
   local bytes = strlen(s);
   local pos = 1;
   
   while pos <= bytes do
      local charbytes = AS_UTF8charbytes(s, pos);
      local char = strsub(s, pos, pos + charbytes - 1);
      
      if not AS_IsDiacritic(char) then
         resultParts[#resultParts + 1] = char;
      end
      
      pos = pos + charbytes;
   end
   
   return table.concat(resultParts);
end

-------------------------------------------------------------------------------------------------------
-- Utility function: Check if a string contains Arabic characters
-- Returns true if the string contains at least one Arabic letter
-------------------------------------------------------------------------------------------------------
function AS_ContainsArabic(s)
   if not s or #s == 0 then return false end
   
   local bytes = strlen(s);
   local pos = 1;
   
   while pos <= bytes do
      local charbytes = AS_UTF8charbytes(s, pos);
      local char = strsub(s, pos, pos + charbytes - 1);
      
      -- Check if character is in our reshaping rules (i.e., is an Arabic letter)
      if AS_Reshaping_Rules[char] then
         return true;
      end
      
      pos = pos + charbytes;
   end
   
   return false;
end

-------------------------------------------------------------------------------------------------------
-- Utility function: Check if a character is an Arabic letter (base letter, not diacritic)
-------------------------------------------------------------------------------------------------------
function AS_IsArabicLetter(char)
   return AS_Reshaping_Rules[char] ~= nil;
end

-------------------------------------------------------------------------------------------------------
-- Utility function: Check if a character is Arabic-Indic numeral
-------------------------------------------------------------------------------------------------------
function AS_IsArabicIndicNumeral(char)
   return AS_ArabicIndicNumerals[char] == true;
end

-------------------------------------------------------------------------------------------------------
-- Utility function: Check if a character is Arabic punctuation
-------------------------------------------------------------------------------------------------------
function AS_IsArabicPunctuation(char)
   return AS_ArabicPunctuation[char] == true;
end

-------------------------------------------------------------------------------------------------------
-- Utility function: Get the reshaper version
-------------------------------------------------------------------------------------------------------
function AS_GetReshaperVersion()
   return AS_RESHAPER_VERSION;
end

-------------------------------------------------------------------------------------------------------
-- Reshape Arabic text while KEEPING string order unchanged
-- Intended for WoW editboxes that build strings already reversed for RTL display.
-- NOTE: We temporarily disable LAM-ALEF ligatures to preserve 1:1 character count
-- (important for cursor position stability in EditBox).
-------------------------------------------------------------------------------------------------------
function AS_ReshapeOnly(s)
   if not s or #s == 0 then return "" end

   local savedRules2 = AS_Reshaping_Rules2;
   AS_Reshaping_Rules2 = {}; -- disable ligatures during reshape-only

   local ok, out = pcall(function()
      -- Double-reverse trick: reverse input, then use reverse+reshape.
      -- Net effect: order stays the same, Arabic gets contextual forms.
      -- IMPORTANT: do NOT apply digit-run fix here (it would flip digits in LTR strings).
      return AS_UTF8reverseRS(AS_UTF8reverse(s), false);
   end);

   AS_Reshaping_Rules2 = savedRules2;

   if ok and out then
      return out;
   end
   return s;
end

-------------------------------------------------------------------------------------------------------
-- returns the number of bytes used by the UTF-8 character at byte
-- Function: AS_UTF8charbytes
-- Description: Determines the number of bytes needed to represent a UTF-8 character at a given index in a string.
-- Parameters:
--    - s (string): The input string. (s=arabic UTF8 text)
--    - i (number) [optional]: The index of the character in the string. Defaults to 1. (i=index of the character to get the byte value of)
-- Returns:
--    - number: The number of bytes needed to represent the UTF-8 character.
-- Throws:
--    - error: If the input string is not a string or the index is not a number.
--    - error: If the UTF-8 string is terminated early.
--    - error: If the UTF-8 character is invalid.
-- Example:
--    local bytes = AS_UTF8charbytes("Hello, 世界!", 8) -- returns 3
-------------------------------------------------------------------------------------------------------
function AS_UTF8charbytes(s, i)
   -- argument defaults
   i = i or 1;

   -- argument checking
   if (type(s) ~= "string") then
      error("bad argument #1 to 'AS_UTF8charbytes' (string expected, got " .. type(s) .. ")");
   end
   if (type(i) ~= "number") then
      error("bad argument #2 to 'QTR_UFT8charbytes' (number expected, got " .. type(i) .. ")");
   end

   local c = strbyte(s, i);

   -- determine bytes needed for character, based on RFC 3629
   -- validate byte 1

   if (c > 0 and c <= 127) then
      -- UTF8-1
      return 1;
   elseif (c >= 194 and c <= 223) then
      -- UTF8-2
      local c2 = strbyte(s, i + 1);

      if (not c2) then
         --print("UTF-8 string terminated early (" .. tostring(i) .. ",2,0): " .. s);
         return 1;
      end

      -- validate byte 2
      if (c2 < 128 or c2 > 191) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",2,1): " .. s);
         return 1;
      end

      return 2;
   elseif (c >= 224 and c <= 239) then
      -- UTF8-3
      local c2 = strbyte(s, i + 1);
      local c3 = strbyte(s, i + 2);

      if (not c2 or not c3) then
         --print("UTF-8 string terminated early (" .. tostring(i) .. ",3,0): " .. s);
         if (not c2) then
            return 1;
         else
            return 2;
         end
      end

      -- validate byte 2
      if (c == 224 and (c2 < 160 or c2 > 191)) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",3,1): " .. s)
         return 1;
      elseif (c == 237 and (c2 < 128 or c2 > 159)) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",3,2): " .. s);
         return 1;
      elseif (c2 < 128 or c2 > 191) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",3,3): " .. s);
         return 1;
      end

      -- validate byte 3
      if (c3 < 128 or c3 > 191) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",3,4): " .. s);
         return 2;
      end

      return 3;
   elseif (c >= 240 and c <= 244) then
      -- UTF8-4
      local c2 = strbyte(s, i + 1);
      local c3 = strbyte(s, i + 2);
      local c4 = strbyte(s, i + 3);

      if ((not c2) or (not c3) or (not c4)) then
         --print("UTF-8 string terminated early (" .. tostring(i) .. ",4,0): " .. s);
         if (not c2) then
            return 1;
         elseif (not c3) then
            return 2;
         else
            return 3;
         end
      end

      -- validate byte 2
      if (c == 240 and (c2 < 144 or c2 > 191)) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",4,1): " .. s);
         return 1;
      elseif (c == 244 and (c2 < 128 or c2 > 143)) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",4,2): " .. s);
         return 1;
      elseif (c2 < 128 or c2 > 191) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",4,3): " .. s);
         return 1;
      end

      -- validate byte 3
      if (c3 < 128 or c3 > 191) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",4,4): " .. s);
         return 2;
      end

      -- validate byte 4
      if (c4 < 128 or c4 > 191) then
         --print("Invalid UTF-8 character (" .. tostring(i) .. ",4,5): " .. s);
         return 3;
      end

      return 4;
   elseif (c >= 128 and c <= 193) or c >= 245 then
      --print("Handling invalid UTF-8 byte: " .. c);
      return 1; -- Treat as a single-byte character
   else
      --print("Invalid UTF-8 character: " .. c);
      -- `strbyte` can return 0 for NUL bytes; treat it (and any other unexpected value)
      -- as a single-byte character to avoid returning nil and crashing callers.
      return 1;
   end
end

-------------------------------------------------------------------------------------------------------
-- Calculates the length of a UTF-8 encoded string.
-- @param s The UTF-8 encoded string.
-- @return The length of the string in characters.
-------------------------------------------------------------------------------------------------------
function AS_UTF8len(s)
   local len = 0;
   if (s) then -- argument checking
      local pos = 1;
      local bytes = strlen(s);
      while (pos <= bytes) do
         len = len + 1;
         pos = pos + AS_UTF8charbytes(s, pos);
      end
   end
   return len;
end

-------------------------------------------------------------------------------------------------------
-- function finding character c in the string s and return true or false
-- Function: AS_UTF8find
-- Description: Searches for a specific character in a UTF-8 encoded string.
-- Parameters:
--   - s: The UTF-8 encoded string to search in.
--   - c: The character to search for.
-- Returns:
--   - odp: A boolean value indicating whether the character was found in the string.
-- Returns the number of characters in a UTF-8 string; Parameters: s=arabic UTF8 text
-------------------------------------------------------------------------------------------------------
function AS_UTF8find(s, c)
   local odp = false;
   if (s and c) then           -- check if arguments are not empty (nil)
      local pos = 1;
      local bytes = strlen(s); -- number of length of the string s in bytes
      local charbytes;
      local char1;

      while (pos <= bytes) do
         charbytes = AS_UTF8charbytes(s, pos);        -- count of bytes of the character
         char1 = strsub(s, pos, pos + charbytes - 1); -- current character from the string s
         if (char1 == c) then
            odp = true;
         end
         pos = pos + AS_UTF8charbytes(s, pos);
      end
   end
   return odp;
end

-------------------------------------------------------------------------------------------------------
-- functions identically to string.sub except that i and j are UTF-8 characters
-- instead of bytes
-- Function: AS_UTF8sub
-- Description: Returns a substring of a UTF-8 encoded string.
-- Parameters:
--    - s (string): The UTF-8 encoded string.
--    - i (number): The starting index of the substring. If negative, it is counted from the end of the string.
--    - j (number, optional): The ending index of the substring. If negative, it is counted from the end of the string. If not provided, the substring extends to the end of the string.
-- Returns:
--    - (string): The substring of the UTF-8 encoded string.
-- Throws:
--    - If the first argument is not a string.
--    - If the second argument is not a number.
--    - If the third argument is not a number.
-- Functions identically to string.sub except that i and j are UTF-8 characters
-- instead of bytes; Parameters: s=arabic UTF8 text, i=starting position, j=ending position (not given=end the text); first element is 1, not 0
-------------------------------------------------------------------------------------------------------
function AS_UTF8sub(s, i, j)
   j = j or -1; -- argument defaults, is not required

   -- argument checking
   if (type(s) ~= "string") then
      error("bad argument #1 to 'AS_UTF8sub' (string expected, got " .. type(s) .. ")");
   end
   if (type(i) ~= "number") then
      error("bad argument #2 to 'AS_UTF8sub' (number expected, got " .. type(i) .. ")");
   end
   if (type(j) ~= "number") then
      error("bad argument #3 to 'AS_UTF8sub' (number expected, got " .. type(j) .. ")");
   end

   local pos       = 1;
   local bytes     = strlen(s);
   local len       = 0;

   -- only set l if i or j is negative
   local l         = (i >= 0 and j >= 0) or AS_UTF8len(s);
   local startChar = (i >= 0) and i or l + i + 1;
   local endChar   = (j >= 0) and j or l + j + 1;

   -- can't have start before end!
   if (startChar > endChar) then
      return "";
   end

   -- byte offsets to pass to string.sub
   local startByte, endByte = 1, bytes;

   while (pos <= bytes) do
      len = len + 1;

      if (len == startChar) then
         startByte = pos;
      end

      pos = pos + AS_UTF8charbytes(s, pos);

      if (len == endChar) then
         endByte = pos - 1;
         break;
      end
   end

   return strsub(s, startByte, endByte);
end

-------------------------------------------------------------------------------------------------------
-- Reverses the order of UTF-8 letters with ReShaping
-- Function: AS_UTF8reverse
-- Description: Reverses the order of characters in a UTF-8 encoded string, while applying Arabic reshaping rules.
-- Parameters:
--   - s: The UTF-8 encoded string to be reversed.
-- Returns:
--   - newstr: The reversed string with applied Arabic reshaping rules.
-- Notes:
--   - This function assumes that the input string follows UTF-8 encoding and contains Arabic characters.
--   - It applies reshaping rules to each character based on its position in the string (isolated, initial, middle, final).
--   - It also handles special cases for specific characters like Hamza and numeric sequences.
--   - The resulting string may not be valid UTF-8 if the input string contains invalid UTF-8 sequences.
-- Reverses the order of UTF-8 letters with ReShaping; Parameters: s=arabic UTF8 text
-------------------------------------------------------------------------------------------------------
function AS_UTF8reverse(s)
   if not s or #s == 0 then return "" end -- Check if string is empty or nil

   local newstrParts = {};                -- Use table to collect parts of the new string
   local bytes = strlen(s);
   local index = 1;                       -- Keep track of insert position in table
   local pos = 1;
   while pos <= bytes do
      local charbytes = AS_UTF8charbytes(s, pos)
      local char1 = strsub(s, pos, pos + charbytes - 1)
      newstrParts[index] = char1;
      index = index + 1;
      pos = pos + charbytes;
   end
   -- Reverse the collected parts and join them into a single string
   for i = 1, math.floor(#newstrParts / 2) do
      newstrParts[i], newstrParts[#newstrParts - i + 1] = newstrParts[#newstrParts - i + 1], newstrParts[i];
   end

   return table.concat(newstrParts); -- Join parts into final string
end

-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
-- Helper function to check if a character is a non-connecting letter
-- Non-connecting letters don't connect to the NEXT letter (but CAN receive connection from previous)
-------------------------------------------------------------------------------------------------------
local AS_NonConnecting = {
   -- Standard Arabic non-connecting letters (these don't connect to the RIGHT)
   ["\216\167"] = true,  -- ALEF (ا)
   ["\216\162"] = true,  -- ALEF WITH MADDA ABOVE (آ)
   ["\216\163"] = true,  -- ALEF WITH HAMZA ABOVE (أ)
   ["\216\165"] = true,  -- ALEF WITH HAMZA BELOW (إ)
   ["\216\175"] = true,  -- DAL (د)
   ["\216\176"] = true,  -- THAL (ذ)
   ["\216\177"] = true,  -- REH (ر)
   ["\216\178"] = true,  -- ZAIN (ز)
   ["\217\136"] = true,  -- WAW (و)
   ["\216\164"] = true,  -- WAW WITH HAMZA ABOVE (ؤ)
   ["\217\137"] = true,  -- ALEF MAKSURA (ى)
   ["\216\169"] = true,  -- TEH MARBUTA (ة)
   ["\216\161"] = true,  -- HAMZA (ء)
   -- Persian/Urdu non-connecting
   ["\218\152"] = true,  -- JEH (ژ)
};

local function AS_IsNonConnecting(char)
   return AS_NonConnecting[char] == true;
end

-------------------------------------------------------------------------------------------------------
-- Helper function to check if a character is a word separator (space, punctuation, etc.)
-------------------------------------------------------------------------------------------------------
local function AS_IsWordSeparator(char)
   if not char or char == '' or char == 'X' then return true end
   local spaces = '( )?؟!,.;:،؛٪\n\r\t';
   if AS_UTF8find(spaces, char) then return true end
   -- HAMZA (ء) is a non-joining letter (doesn't connect from previous or to next).
   -- Treat it as a join-breaker so words like "شيء" shape correctly (ي should be FINAL, not MIDDLE).
   if char == "\216\161" then return true end
   -- ASCII digits should break Arabic joining and be treated as separators
   if (#char == 1) and (char >= "0") and (char <= "9") then return true end
   if AS_ArabicPunctuation[char] then return true end
   if AS_ArabicIndicNumerals[char] then return true end
   return false;
end

-------------------------------------------------------------------------------------------------------
-- Helpers: Digits and numeric separators (for mixed Arabic + numbers)
-- We reverse whole strings for RTL display; digit runs must stay LTR.
-------------------------------------------------------------------------------------------------------
local function AS_IsAsciiDigit(char)
   return char and (#char == 1) and (char >= "0") and (char <= "9");
end

local function AS_IsAnyDigit(char)
   return AS_IsAsciiDigit(char) or (AS_ArabicIndicNumerals[char] == true);
end

local AS_NumberSeparators = {
   ["."] = true,
   [","] = true,
   ["\217\171"] = true, -- ٫ Arabic Decimal Separator U+066B
   ["\217\172"] = true, -- ٬ Arabic Thousands Separator U+066C
};

local function AS_IsNumberSeparator(char)
   return AS_NumberSeparators[char] == true;
end

-- After full RTL reversal, digit sequences become reversed (e.g. 1000 -> 0001).
-- This function flips digit runs back while preserving WoW escape sequences (|c... and hyperlinks).
local function AS_FixDigitRunsForRTL(s)
   if not s or #s == 0 then return "" end

   local out = {};
   local bytes = strlen(s);
   local pos = 1;

   while pos <= bytes do
      -- Protect WoW escape sequences (color codes, hyperlinks, textures) from digit-run reversal
      if strsub(s, pos, pos) == "|" then
         local nextChar = (pos + 1 <= bytes) and strsub(s, pos + 1, pos + 1) or "";

         -- Color code: |cAARRGGBB (10 bytes total)
         if (nextChar == "c") and (pos + 9 <= bytes) then
            out[#out + 1] = strsub(s, pos, pos + 9);
            pos = pos + 10;
         -- Color reset: |r
         elseif (nextChar == "r") then
            out[#out + 1] = "|r";
            pos = pos + 2;
         -- Hyperlink: |H...|h[Text]|h
         elseif (nextChar == "H") then
            local firstH = string.find(s, "|h", pos, true);
            if not firstH then
               out[#out + 1] = strsub(s, pos);
               break;
            end
            local secondH = string.find(s, "|h", firstH + 2, true);
            if not secondH then
               out[#out + 1] = strsub(s, pos);
               break;
            end
            out[#out + 1] = strsub(s, pos, secondH + 1);
            pos = secondH + 2;
         -- Texture tag: |T...|t
         elseif (nextChar == "T") then
            local endT = string.find(s, "|t", pos, true);
            if not endT then
               out[#out + 1] = strsub(s, pos);
               break;
            end
            out[#out + 1] = strsub(s, pos, endT + 1);
            pos = endT + 2;
         else
            out[#out + 1] = "|";
            pos = pos + 1;
         end
      else
         local charbytes = AS_UTF8charbytes(s, pos);
         local ch = strsub(s, pos, pos + charbytes - 1);

         if AS_IsAnyDigit(ch) then
            local run = { ch };
            pos = pos + charbytes;

            while pos <= bytes do
               -- Stop runs at WoW escape sequences
               if strsub(s, pos, pos) == "|" then break end

               local cb2 = AS_UTF8charbytes(s, pos);
               local ch2 = strsub(s, pos, pos + cb2 - 1);

               if AS_IsAnyDigit(ch2) then
                  run[#run + 1] = ch2;
                  pos = pos + cb2;
               elseif AS_IsNumberSeparator(ch2) then
                  -- Include separator only if followed by a digit
                  local lookPos = pos + cb2;
                  if (lookPos <= bytes) and (strsub(s, lookPos, lookPos) ~= "|") then
                     local cb3 = AS_UTF8charbytes(s, lookPos);
                     local ch3 = strsub(s, lookPos, lookPos + cb3 - 1);
                     if AS_IsAnyDigit(ch3) then
                        run[#run + 1] = ch2;
                        pos = pos + cb2;
                     else
                        break;
                     end
                  else
                     break;
                  end
               else
                  break;
               end
            end

            -- Reverse the run back to LTR
            for i = #run, 1, -1 do
               out[#out + 1] = run[i];
            end
         else
            out[#out + 1] = ch;
            pos = pos + charbytes;
         end
      end
   end

   return table.concat(out);
end

-------------------------------------------------------------------------------------------------------
-- Reverses the order of UTF-8 letters with ReShaping - using for chat
-- REWRITTEN: Uses a cleaner two-concept approach:
--   1. connectedFromLeft: Is this letter connected FROM the previous letter?
--   2. connectsToRight: Does this letter connect TO the next letter?
-- Form determination:
--   - isolated: not connected from left, doesn't connect to right
--   - initial: not connected from left, connects to right
--   - middle: connected from left, connects to right
--   - final: connected from left, doesn't connect to right
-------------------------------------------------------------------------------------------------------
function AS_UTF8reverseRS(s, fixNumbers)
   if not s or #s == 0 then return "" end
   if fixNumbers == nil then fixNumbers = true end
   
   local resultParts = {};
   local resultIndex = 1;
   local bytes = strlen(s);
   local pos = 1;
   
   -- Track previous character info for connection logic
   local prevChar = nil;           -- Previous BASE character (nil = start of string or after separator)
   local prevConnectsRight = false; -- Did the previous character connect to the right?

   while (pos <= bytes) do
      -- Get current character
      local charbytes1 = AS_UTF8charbytes(s, pos);
      local char1 = strsub(s, pos, pos + charbytes1 - 1);
      
      -- Collect any diacritics attached to this character
      local attachedDiacritics = {};
      local nextPos = pos + charbytes1;
      
      while nextPos <= bytes do
         local diacBytes = AS_UTF8charbytes(s, nextPos);
         local diacChar = strsub(s, nextPos, nextPos + diacBytes - 1);
         if AS_IsDiacritic(diacChar) then
            attachedDiacritics[#attachedDiacritics + 1] = diacChar;
            nextPos = nextPos + diacBytes;
         else
            break;
         end
      end
      
      pos = nextPos;

      -- Handle diacritics - they don't affect reshaping logic
      if AS_IsDiacritic(char1) then
         local diacOut = char1;
         if AS_USE_PRESENTATION_DIACRITICS and AS_DiacriticPresentationForms and AS_DiacriticPresentationForms[char1] then
            diacOut = AS_DiacriticPresentationForms[char1];
         end
         resultParts[resultIndex] = diacOut;
         resultIndex = resultIndex + 1;
         -- Don't update prevChar or prevConnectsRight for diacritics
      else
         -- Find next base character (skipping diacritics)
         local char2 = nil;
         local charbytes2 = 0;
         local lookPos = pos;
         
         while lookPos <= bytes do
            local tempBytes = AS_UTF8charbytes(s, lookPos);
            local tempChar = strsub(s, lookPos, lookPos + tempBytes - 1);
            if AS_IsDiacritic(tempChar) then
               lookPos = lookPos + tempBytes;
            else
               char2 = tempChar;
               charbytes2 = tempBytes;
               break;
            end
         end
         
         -- Check for ligatures FIRST (they affect char1 and may skip char2)
         local ligatureApplied = false;
         local ligatureForm = nil;
         
         if char2 and AS_Reshaping_Rules2[char1 .. char2] then
            ligatureForm = AS_Reshaping_Rules2[char1 .. char2];
            ligatureApplied = true;
            -- Skip char2 (and its diacritics)
            pos = lookPos + charbytes2;
            while pos <= bytes do
               local skipBytes = AS_UTF8charbytes(s, pos);
               local skipChar = strsub(s, pos, pos + skipBytes - 1);
               if AS_IsDiacritic(skipChar) then
                  pos = pos + skipBytes;
               else
                  break;
               end
            end
            -- Update char2 to what comes AFTER the ligature
            lookPos = pos;
            char2 = nil;
            while lookPos <= bytes do
               local tempBytes = AS_UTF8charbytes(s, lookPos);
               local tempChar = strsub(s, lookPos, lookPos + tempBytes - 1);
               if AS_IsDiacritic(tempChar) then
                  lookPos = lookPos + tempBytes;
               else
                  char2 = tempChar;
                  break;
               end
            end
         end
         
         -- Determine if this character/ligature is a word separator
         local isCurrentSeparator = AS_IsWordSeparator(char1);
         local isNextSeparator = AS_IsWordSeparator(char2);

         -- IMPORTANT: Any non-Arabic character must break Arabic joining.
         -- Previously, Latin letters (doom) were treated like "letters" and could incorrectly
         -- connect to the next Arabic letter, producing wrong forms (e.g., ح becomes medial).
         local isCurrentArabic = ligatureApplied or (AS_Reshaping_Rules[char1] ~= nil);
         if (not isCurrentSeparator) and (not isCurrentArabic) then
            isCurrentSeparator = true;
         end
         
         if isCurrentSeparator then
            -- Word separators pass through unchanged
            local outputChar = char1;
            -- Handle bracket reversal for separators
            if (char1 == "<") then outputChar = ">";
            elseif (char1 == ">") then outputChar = "<";
            elseif (char1 == "(") then outputChar = ")";
            elseif (char1 == ")") then outputChar = "(";
            elseif (char1 == "[") then outputChar = "]";
            elseif (char1 == "]") then outputChar = "[";
            elseif (char1 == "{") then outputChar = "}";
            elseif (char1 == "}") then outputChar = "{";
            end
            
            resultParts[resultIndex] = outputChar;
            resultIndex = resultIndex + 1;
            
            -- Reset connection state
            prevChar = nil;
            prevConnectsRight = false;
         else
            -- This is an Arabic letter - determine its form
            
            -- Step 1: Is this letter connected FROM the left?
            -- It's connected from left if previous letter exists AND previous letter connects right
            local connectedFromLeft = (prevChar ~= nil) and prevConnectsRight;
            
            -- Step 2: Does this letter connect TO the right?
            -- It connects right if: (a) it's not a non-connecting letter, AND (b) next char is an Arabic letter
            local currentConnectsRight = false;
            if ligatureApplied then
               -- Lam-Alef ligatures are non-connecting (don't connect to next letter)
               currentConnectsRight = false;
            elseif AS_IsNonConnecting(char1) then
               -- Non-connecting letters don't connect to the right
               currentConnectsRight = false;
            elseif not isNextSeparator and char2 and AS_Reshaping_Rules[char2] then
               -- Next character is an Arabic letter, so we connect to it
               currentConnectsRight = true;
            else
               -- No next letter or next is separator
               currentConnectsRight = false;
            end
            
            -- Step 3: Determine form based on connection state
            local position;
            if connectedFromLeft and currentConnectsRight then
               position = 2;  -- middle
            elseif connectedFromLeft and not currentConnectsRight then
               position = 3;  -- final
            elseif not connectedFromLeft and currentConnectsRight then
               position = 1;  -- initial
            else
               position = 0;  -- isolated
            end
            
            -- Step 4: Apply reshaping
            local outputChar;
            
            if ligatureApplied and ligatureForm then
               -- Use ligature form
               if position == 0 then
                  outputChar = ligatureForm.isolated;
               elseif position == 1 then
                  outputChar = ligatureForm.initial;
               elseif position == 2 then
                  outputChar = ligatureForm.middle;
               else
                  outputChar = ligatureForm.final;
               end
            else
               -- Use regular reshaping rules
               local rules = AS_Reshaping_Rules[char1];
               if rules then
                  if position == 0 then
                     outputChar = rules.isolated;
                  elseif position == 1 then
                     outputChar = rules.initial;
                  elseif position == 2 then
                     outputChar = rules.middle;
                  else
                     outputChar = rules.final;
                  end
               else
                  outputChar = char1;
               end
            end
            
            -- Add position prefix when reshaper debug is enabled (general VERBOSE)
            if RS_IsDebugForm() then
               outputChar = tostring(position) .. outputChar;
            end
            
            -- Add attached diacritics
            for _, diac in ipairs(attachedDiacritics) do
               if AS_USE_PRESENTATION_DIACRITICS and AS_DiacriticPresentationForms and AS_DiacriticPresentationForms[diac] then
                  outputChar = outputChar .. AS_DiacriticPresentationForms[diac];
               else
                  outputChar = outputChar .. diac;
               end
            end
            
            resultParts[resultIndex] = outputChar;
            resultIndex = resultIndex + 1;
            
            -- Update state for next iteration
            prevChar = char1;
            prevConnectsRight = currentConnectsRight;
         end
      end
   end
   
   -- Reverse the parts and concatenate
   local reversed = {};
   for i = resultIndex - 1, 1, -1 do
      reversed[#reversed + 1] = resultParts[i];
   end
   
   local out = table.concat(reversed);
   if fixNumbers then
      out = AS_FixDigitRunsForRTL(out);
   end
   return out;
end

-------------------------------------------------------------------------------------------------------
-- the function create testing frame to determine the length of text in a frame
-- Creates a test frame for measuring the width of text.
-------------------------------------------------------------------------------------------------------
function AS_CreateTestLine()
   AS_TestLine = CreateFrame("Frame", "AS_TestLine", UIParent, "BasicFrameTemplateWithInset");
   AS_TestLine:SetHeight(150);
   AS_TestLine:SetWidth(300);
   AS_TestLine:ClearAllPoints();
   AS_TestLine:SetPoint("TOPLEFT", 20, -300); -- 20,-300
   AS_TestLine.title = AS_TestLine:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
   AS_TestLine.title:SetPoint("CENTER", AS_TestLine.TitleBg);
   AS_TestLine.title:SetText("Frame for testing width of text");
   AS_TestLine.ScrollFrame = CreateFrame("ScrollFrame", nil, AS_TestLine, "UIPanelScrollFrameTemplate");
   AS_TestLine.ScrollFrame:SetPoint("TOPLEFT", AS_TestLine.InsetBg, "TOPLEFT", 10, -40);
   AS_TestLine.ScrollFrame:SetPoint("BOTTOMRIGHT", AS_TestLine.InsetBg, "BOTTOMRIGHT", -5, 10);

   AS_TestLine.ScrollFrame.ScrollBar:ClearAllPoints();
   AS_TestLine.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", AS_TestLine.ScrollFrame, "TOPRIGHT", -12, -18);
   AS_TestLine.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", AS_TestLine.ScrollFrame, "BOTTOMRIGHT", -7, 15);
   CHchild = CreateFrame("Frame", nil, AS_TestLine.ScrollFrame);
   CHchild:SetSize(552, 100);
   CHchild.bg = CHchild:CreateTexture(nil, "BACKGROUND");
   CHchild.bg:SetAllPoints(true);
   CHchild.bg:SetColorTexture(0, 0.05, 0.1, 0.8);
   AS_TestLine.ScrollFrame:SetScrollChild(CHchild);
   AS_TestLine.text = CHchild:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
   AS_TestLine.text:SetPoint("TOPLEFT", CHchild, "TOPLEFT", 2, 0);
   AS_TestLine.text:SetText("");
   AS_TestLine.text:SetSize(DEFAULT_CHAT_FRAME:GetWidth(), 0);
   AS_TestLine.text:SetJustifyH("LEFT");
   AS_TestLine.CloseButton:SetPoint("TOPRIGHT", AS_TestLine, "TOPRIGHT", 0, 0);
   AS_TestLine:Hide(); -- the frame is invisible in the game
end

-------------------------------------------------------------------------------------------------------
-- This function prepares Arabic text to be displayed in a specific window width;
-- Parameters: Atext=arabic UTF8 text, Awidth=frame width to the text, AfontSize=size of current font
-- Function: AS_ReverseAndPrepareLineText
-- Description: Reverses and prepares a line of text for display.
-- Parameters:
--    - Atext (string): The input text to be processed.
--    - Awidth (number): The width of the frame for displaying the text.
--    - AfontSize (number): The font size of the text.
-- Returns:
--    - retstr (string): The processed text ready for display.
-------------------------------------------------------------------------------------------------------
function AS_ReverseAndPrepareLineText(Atext, Awidth, Afont, AfontSize)
   local retstr = "";
   if (Atext and Awidth and AfontSize) then
      if (AS_TestLine == nil) then
         AS_CreateTestLine();
      end
      Atext = string.gsub(Atext, " #", "#");
      Atext = string.gsub(Atext, "# ", "#");

      local bytes = strlen(Atext);
      local pos = 1;
      local counter = 0;
      local link_start_stop = false;
      local newstr = "";
      local nextstr = "";
      local charbytes;
      --local newstrR; -- Removed as unused
      local char1 = "";
      local char2 = "";
      local last_space = 0;

      while (pos <= bytes) do
         charbytes = AS_UTF8charbytes(Atext, pos);
         char1 = strsub(Atext, pos, pos + charbytes - 1);
         newstr = newstr .. char1;

         local pair = char2 .. char1;
         if (((pair == "|r") or (pair == "r|")) and (pos < bytes)) then
            link_start_stop = true;
         elseif (((pair == "|c") or (pair == "c|")) and (pos < bytes)) then
            link_start_stop = false;
         end

         if ((char1 == '#') or ((char1 == " ") and (link_start_stop == false))) then
            last_space = 0;
            nextstr = "";
         else
            nextstr = nextstr .. char1;
            last_space = last_space + charbytes;
         end

         if (link_start_stop == false) then
            AS_TestLine.text:SetWidth(Awidth);
            AS_TestLine.text:SetFont(Afont, AfontSize);
            AS_TestLine.text:SetText(AS_UTF8reverse(newstr));
            if ((char1 == '#') or (AS_TestLine.text:GetHeight() > AfontSize * 1.5)) then
               newstr = string.sub(newstr, 1, strlen(newstr) - last_space);
               newstr = string.gsub(newstr, "#", "");
               -- *** MODIFICATION: Remove call to AS_AddSpaces ***
               retstr = retstr .. AS_UTF8reverse(newstr) .. "\n";
               newstr = nextstr;
               nextstr = "";
               --counter = 0; -- Removed counter reset
            end
         end
         char2 = char1;
         pos = pos + charbytes;
      end

      -- *** MODIFICATION: Remove call to AS_AddSpaces for the last line ***
      retstr = retstr .. AS_UTF8reverse(newstr);
      retstr = string.gsub(retstr, "#", "");
      retstr = string.gsub(retstr, " \n", "\n");
      retstr = string.gsub(retstr, "\n ", "\n");
   end

   return retstr;
end

--------------------------------------------------------------------------------------------------------
--[[
comment...

]]
--------------------------------------------------------------------------------------------------------

function AS_ReverseAndPrepareLineText_RIGHT(Atext, Awidth, Afont, AfontSize)
   local retstr = "";
   if (Atext and Awidth and AfontSize) then
      if (AS_TestLine == nil) then -- a separate frame for displaying the translation of texts and determining the length
         AS_CreateTestLine();
      end
      Atext = string.gsub(Atext, " #", "#");
      Atext = string.gsub(Atext, "# ", "#");
      local bytes = strlen(Atext);
      local pos = 1;
      local counter = 0;
      local link_start_stop = false;
      local newstr = "";
      local nextstr = "";
      local charbytes;
      local newstrR;
      local char1 = "";
      local char2 = "";
      local last_space = 0;
      while (pos <= bytes) do                                     -- CAUTION: Arabic text is provided directly, individual characters are from the left
         charbytes = AS_UTF8charbytes(Atext, pos);                -- count of bytes per character
         char1 = strsub(Atext, pos, pos + charbytes - 1);         -- retrieved letter character
         newstr = newstr .. char1;                                -- add the next retrieved character

         local pair = char2 .. char1;
         if (((pair == "|r") or (pair == "r|")) and (pos < bytes)) then     -- start of the link
            link_start_stop = true;
         elseif (((pair == "|c") or (pair == "c|")) and (pos < bytes)) then -- end of the link
            link_start_stop = false;
         end

         if ((char1 == '#') or ((char1 == " ") and (link_start_stop == false))) then -- we have a space, not inside a link
            last_space = 0;
            nextstr = "";
         else
            nextstr = nextstr .. char1; -- characters following the last space
            last_space = last_space + charbytes;
         end
         if (link_start_stop == false) then    -- we are not inside a link - can check
            AS_TestLine.text:SetWidth(Awidth); -- set the frame width to the text
            AS_TestLine.text:SetFont(Afont, AfontSize);
            AS_TestLine.text:SetText(AS_UTF8reverse(newstr));
            if ((char1 == '#') or (AS_TestLine.text:GetHeight() > AfontSize * 1.5)) then -- text no longer fits in one line
               newstr = string.sub(newstr, 1, strlen(newstr) - last_space);              -- text up to the last space
               newstr = string.gsub(newstr, "#", "");
               retstr = retstr .. AS_AddSpaces(AS_UTF8reverse(newstr), Awidth, Afont, AfontSize) .. "\n";
               newstr = nextstr;
               nextstr = "";
               counter = 0;
            end
         end
         char2 = char1; -- remember the character, needed in the next loop
         pos = pos + charbytes;
      end
      retstr = retstr .. AS_AddSpaces(AS_UTF8reverse(newstr), Awidth, Afont, AfontSize);
      retstr = string.gsub(retstr, "#", "");
      retstr = string.gsub(retstr, " \n", "\n"); -- space before newline code is useless
      retstr = string.gsub(retstr, "\n ", "\n"); -- space after newline code is useless
   end

   return retstr;
end

-------------------------------------------------------------------------------------------------------
-- the function appends spaces to the left of the given text so that the text is aligned to the right

-- Function: AS_AddSpaces
-- Description: Adds leading spaces to a given text to fit within a specified width and font size.
-- Parameters:
--   - txt (string): The text to add spaces to.
--   - width (number): The maximum width in pixels that the text should fit within.
--   - fontsize (number): The font size in points.
-- Returns:
--   - txt (string): The modified text with leading spaces added.
-------------------------------------------------------------------------------------------------------
function AS_AddSpaces(txt, width, fontfile, fontsize)
   local chars_limitC = 300;    -- so much max. characters can fit on one line

   if (AS_TestLine == nil) then -- a own frame for displaying the translation of texts and determining the length
      AS_CreateTestLine();
   end
   local count = 0;
   local text = txt;
   AS_TestLine.text:SetWidth(width);
   AS_TestLine.text:SetFont(fontfile, fontsize);
   AS_TestLine.text:SetText(text);
   while ((AS_TestLine.text:GetHeight() < fontsize * 1.5) and (count < chars_limitC)) do
      count = count + 1;
      text = " " .. text;
      AS_TestLine.text:SetText(text);
   end
   if (count < chars_limitC) then -- failed to properly add leading spaces
      for i = 2, count, 1 do      -- spaces are added to the left of the text
         txt = " " .. txt;
      end
   end
   return (txt);
end

-------------------------------------------------------------------------------------------------------
function BB_LineChat(txt, font_size, more_chars)
   local retstr = "";
   if (txt and font_size) then
      local more_chars = more_chars or 0;
      local chat_width = DEFAULT_CHAT_FRAME:GetWidth();           -- width of 1 chat line
      local chars_limit = chat_width / (0.35 * font_size + 0.8) * 1.1; -- so much max. characters can fit on one line
      local bytes = strlen(txt);
      local pos = 1;
      local counter = 0;
      local second = 0;
      local newstr = "";
      local charbytes;
      local newstrR;
      local char1;
      while (pos <= bytes) do
         local c = strbyte(txt, pos);            -- read the character (odczytaj znak)
         charbytes = AS_UTF8charbytes(txt, pos); -- count of bytes (liczba bajtów znaku)
         char1 = strsub(txt, pos, pos + charbytes - 1);
         newstr = newstr .. char1;
         pos = pos + charbytes;

         counter = counter + 1;
         if ((char1 >= "A") and (char1 <= "z")) then
            counter = counter + 1;                                        -- latin letters are 2x wider, then Arabic
         end
         if ((char1 == " ") and (counter - more_chars >= chars_limit - 3)) then -- break line here
            newstrR = BB_AddSpaces(AS_UTF8reverse(newstr), second);
            retstr = retstr .. newstrR .. "\n";
            newstr = "";
            counter = 0;
            more_chars = 0;
            second = 2;
         end
      end
      newstrR = BB_AddSpaces(AS_UTF8reverse(newstr), second);
      retstr = retstr .. newstrR;
      retstr = string.gsub(retstr, "\n ", "\n"); -- space after newline code is useless
   end
   return retstr;
end

--------------------------------------------------------------------------------------------------------
function BB_AddSpaces(txt, snd)                             -- snd = second or next line (interspace 2 on right)
   local _fontC, _sizeC, _C = DEFAULT_CHAT_FRAME:GetFont(); -- read current font, size and flag of the chat object
   local chat_widthC = DEFAULT_CHAT_FRAME:GetWidth();       -- width of 1 chat line
   local chars_limitC = chat_widthC / (0.35 * _sizeC + 0.8); -- so much max. characters can fit on one line

   if (BB_TestLine == nil) then                             -- a own frame for displaying the translation of texts and determining the length
      BB_CreateTestLine();
   end
   BB_TestLine:SetWidth(DEFAULT_CHAT_FRAME:GetWidth() + 50);
   BB_TestLine:Hide(); -- the frame is invisible in the game
   BB_TestLine.text:SetFont(_fontC, _sizeC, _C);
   local count = 0;
   local text = txt;
   BB_TestLine.text:SetText(text);
   while ((BB_TestLine.text:GetHeight() < _sizeC * 1.5) and (count < chars_limitC)) do
      count = count + 1;
      text = " " .. text;
      BB_TestLine.text:SetText(text);
   end

   if (count < chars_limitC) then -- failed to properly add leading spaces
      for i = 4, count - snd, 1 do -- spaces are added to the left of the text
         txt = " " .. txt;
      end
   end
   BB_TestLine.text:SetText(txt);

   return (txt);
end

--------------------------------------------------------------------------------------------------------
function BB_CreateTestLine()
   BB_TestLine = CreateFrame("Frame", "BB_TestLine", UIParent, "BasicFrameTemplateWithInset");
   BB_TestLine:SetHeight(150);
   BB_TestLine:SetWidth(DEFAULT_CHAT_FRAME:GetWidth() + 50);
   BB_TestLine:ClearAllPoints();
   BB_TestLine:SetPoint("TOPLEFT", 20, -300);
   BB_TestLine.title = BB_TestLine:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
   BB_TestLine.title:SetPoint("CENTER", BB_TestLine.TitleBg);
   BB_TestLine.title:SetText("Frame for testing width of text");
   BB_TestLine.ScrollFrame = CreateFrame("ScrollFrame", nil, BB_TestLine, "UIPanelScrollFrameTemplate");
   BB_TestLine.ScrollFrame:SetPoint("TOPLEFT", BB_TestLine.InsetBg, "TOPLEFT", 10, -40);
   BB_TestLine.ScrollFrame:SetPoint("BOTTOMRIGHT", BB_TestLine.InsetBg, "BOTTOMRIGHT", -5, 10);

   BB_TestLine.ScrollFrame.ScrollBar:ClearAllPoints();
   BB_TestLine.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", BB_TestLine.ScrollFrame, "TOPRIGHT", -12, -18);
   BB_TestLine.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", BB_TestLine.ScrollFrame, "BOTTOMRIGHT", -7, 15);
   BBchild = CreateFrame("Frame", nil, BB_TestLine.ScrollFrame);
   BBchild:SetSize(552, 100);
   BBchild.bg = BBchild:CreateTexture(nil, "BACKGROUND");
   BBchild.bg:SetAllPoints(true);
   BBchild.bg:SetColorTexture(0, 0.05, 0.1, 0.8);
   BB_TestLine.ScrollFrame:SetScrollChild(BBchild);
   BB_TestLine.text = BBchild:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
   BB_TestLine.text:SetPoint("TOPLEFT", BBchild, "TOPLEFT", 2, 0);
   BB_TestLine.text:SetText("");
   BB_TestLine.text:SetSize(DEFAULT_CHAT_FRAME:GetWidth(), 0);
   BB_TestLine.text:SetJustifyH("LEFT");
   BB_TestLine.CloseButton:SetPoint("TOPRIGHT", BB_TestLine, "TOPRIGHT", 0, 0);
   BB_TestLine:Hide(); -- the frame is invisible in the game
end

