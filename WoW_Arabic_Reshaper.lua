-------------------------------------------------------------------------------------------------------
-- Arabic Reshaper for WoWinArabic addons (2024.02.04)
-- Author: Platine (email: platine.wow@gmail.com)
-- Contributor: DragonArab - Developed letter reshaping tables and ligatures (http://WoWinArabic.com)
-- Based on: UTF8 library by Kyle Smith
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
-- This variable controls whether or not to show the debug form.
-------------------------------------------------------------------------------------------------------
local debug_show_form = 0;
-------------------------------------------------------------------------------------------------------
-- AS_Reshaping_Rules is a table that contains reshaping rules for Arabic characters.
-- Each key-value pair in the table represents a specific Arabic character and its reshaping rules.
-- The key is the original Arabic character represented as a string of bytes.
-- The value is a table that contains the reshaping rules for the character, including isolated, initial, middle, and final forms.
-- The reshaping rules are represented as strings of bytes.
-- The reshaped forms are used to correctly display Arabic text in different contexts.
-------------------------------------------------------------------------------------------------------
AS_Reshaping_Rules = {
   ["\216\167"] = { isolated = "\216\167", initial = "\216\167", middle = "\239\186\142", final = "\239\186\142" },                 -- ALEF
   ["\216\162"] = { isolated = "\239\186\129", initial = "\239\186\129", middle = "\239\186\142", final = "\239\186\142" },         -- ALEF WITH MADDA ABOVE
   ["\216\163"] = { isolated = "\216\163", initial = "\216\163", middle = "\239\186\132", final = "\239\186\132" },                 -- ALEF WITH HAMZA ABOVE
   ["\216\165"] = { isolated = "\216\165", initial = "\216\165", middle = "\239\186\136", final = "\239\186\136" },                 -- ALEF WITH HAMZA BELOW
   ["\216\168"] = { isolated = "\216\168", initial = "\239\186\145", middle = "\239\186\146", final = "\239\186\144" },             -- BEH
   ["\216\170"] = { isolated = "\216\170", initial = "\239\186\151", middle = "\239\186\152", final = "\239\186\150" },             -- TEH
   ["\216\171"] = { isolated = "\216\171", initial = "\239\186\155", middle = "\239\186\156", final = "\239\186\154" },             -- THA
   ["\216\172"] = { isolated = "\216\172", initial = "\239\186\159", middle = "\239\186\160", final = "\239\186\158" },             -- JIM
   ["\216\173"] = { isolated = "\216\173", initial = "\239\186\163", middle = "\239\186\164", final = "\239\186\162" },             -- HAH
   ["\216\174"] = { isolated = "\216\174", initial = "\239\186\167", middle = "\239\186\168", final = "\239\186\166" },             -- KHAH
   ["\216\175"] = { isolated = "\216\175", initial = "\216\175", middle = "\239\186\170", final = "\239\186\170" },                 -- DAL
   ["\216\176"] = { isolated = "\216\176", initial = "\216\176", middle = "\239\186\172", final = "\239\186\172" },                 -- DHAL
   ["\216\177"] = { isolated = "\216\177", initial = "\216\177", middle = "\239\186\174", final = "\239\186\174" },                 -- RA
   ["\216\178"] = { isolated = "\216\178", initial = "\216\178", middle = "\239\186\176", final = "\239\186\176" },                 -- ZAIN
   ["\216\179"] = { isolated = "\216\179", initial = "\239\186\179", middle = "\239\186\180", final = "\239\186\178" },             -- SIN
   ["\216\180"] = { isolated = "\216\180", initial = "\239\186\183", middle = "\239\186\184", final = "\239\186\182" },             -- SHIN
   ["\216\181"] = { isolated = "\216\181", initial = "\239\186\187", middle = "\239\186\188", final = "\239\186\186" },             -- SAD
   ["\216\182"] = { isolated = "\216\182", initial = "\239\186\191", middle = "\239\187\128", final = "\239\186\190" },             -- DAD
   ["\216\183"] = { isolated = "\216\183", initial = "\239\187\131", middle = "\239\187\132", final = "\239\187\130" },             -- TAH
   ["\216\184"] = { isolated = "\216\184", initial = "\239\187\135", middle = "\239\187\136", final = "\239\187\134" },             -- ZAH
   ["\216\185"] = { isolated = "\216\185", initial = "\239\187\139", middle = "\239\187\140", final = "\239\187\138" },             -- AIN
   ["\216\186"] = { isolated = "\216\186", initial = "\239\187\143", middle = "\239\187\144", final = "\239\187\142" },             -- GHAIN
   ["\217\129"] = { isolated = "\217\129", initial = "\239\187\147", middle = "\239\187\148", final = "\239\187\146" },             -- FEH
   ["\217\130"] = { isolated = "\217\130", initial = "\239\187\151", middle = "\239\187\152", final = "\239\187\150" },             -- QAF
   ["\217\131"] = { isolated = "\217\131", initial = "\239\187\155", middle = "\239\187\156", final = "\239\187\154" },             -- KAF
   ["\217\132"] = { isolated = "\217\132", initial = "\239\187\159", middle = "\239\187\160", final = "\239\187\158" },             -- LAM
   ["\217\133"] = { isolated = "\217\133", initial = "\239\187\163", middle = "\239\187\164", final = "\239\187\162" },             -- MIM
   ["\217\134"] = { isolated = "\217\134", initial = "\239\187\167", middle = "\239\187\168", final = "\239\187\166" },             -- NUN
   ["\217\138"] = { isolated = "\217\138", initial = "\239\187\179", middle = "\239\187\180", final = "\239\187\178" },             -- YA
   ["\216\166"] = { isolated = "\216\166", initial = "\239\186\139", middle = "\239\186\140", final = "\239\186\138" },             -- YEH WITH HAMZA ABOVE
   ["\217\137"] = { isolated = "\217\137", initial = "\217\137", middle = "\217\137", final = "\239\187\176" },                     -- ALEF MAKSURA
   ["\217\136"] = { isolated = "\217\136", initial = "\217\136", middle = "\239\187\174", final = "\239\187\174" },                 -- WAW
   ["\216\164"] = { isolated = "\216\164", initial = "\216\164", middle = "\239\186\134", final = "\239\186\134" },                 -- WAW WITH HAMZA ABOVE
   ["\217\135"] = { isolated = "\239\187\169", initial = "\239\187\171", middle = "\239\187\172", final = "\239\187\170" },         -- HAH
   ["\216\169"] = { isolated = "\216\169", initial = "\216\169", middle = "\216\169", final = "\239\186\148" },                     -- TAH
   ["\239\187\187"] = { isolated = "\239\187\187", initial = "\239\187\187", middle = "\239\187\188", final = "\239\187\188" },     -- LAM WITH ALEF
   ["\239\187\181"] = { isolated = "\239\187\181", initial = "\239\187\181", middle = "\239\187\182", final = "\239\187\182" },     -- LAM WITH ALEF WITH MADDA
   ["\217\132\216\163"] = { isolated = "\239\187\183", initial = "\239\187\183", middle = "\239\187\184", final = "\239\187\184" }, -- LAM WITH ALEF WITH HAMZA ABOVE
   ["\217\132\216\165"] = { isolated = "\239\187\185", initial = "\239\187\185", middle = "\239\187\186", final = "\239\187\186" }, -- LAM WITH ALEF WITH HAMZA BELOW
   ["\216\161"] = { isolated = "\216\161", initial = "\216\161", middle = "\216\161", final = "\216\161" },                         -- HAMZA
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
   ["\217\132" .. "\216\167"] = { isolated = "\239\187\187", initial = "\239\187\187", middle = "\239\187\188", final = "\239\187\188" }, -- Arabic ligature LAM with ALEF
   ["\217\132" .. "\216\163"] = { isolated = "\239\187\183", initial = "\239\187\183", middle = "\239\187\184", final = "\239\187\184" }, -- Arabic ligature LAM with ALEF with HAMZA above
   ["\217\132" .. "\216\165"] = { isolated = "\239\187\185", initial = "\239\187\185", middle = "\239\187\186", final = "\239\187\186" }, -- Arabic ligature LAM with ALEF with HAMZA below
   ["\217\132" .. "\216\162"] = { isolated = "\239\187\181", initial = "\239\187\181", middle = "\239\187\182", final = "\239\187\182" }, -- Arabic ligature LAM with ALEF with MADDA
   ["ي" .. "ء"] = { isolated = "0", initial = "ءي", middle = "ءﻲ", final = "ءﻲ" },
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
         error("UTF-8 string terminated early");
      end

      -- validate byte 2
      if (c2 < 128 or c2 > 191) then
         error("Invalid UTF-8 character");
      end

      return 2;
   elseif (c >= 224 and c <= 239) then
      -- UTF8-3
      local c2 = strbyte(s, i + 1);
      local c3 = strbyte(s, i + 2);

      if (not c2 or not c3) then
         error("UTF-8 string terminated early");
      end

      -- validate byte 2
      if (c == 224 and (c2 < 160 or c2 > 191)) then
         error("Invalid UTF-8 character")
      elseif (c == 237 and (c2 < 128 or c2 > 159)) then
         error("Invalid UTF-8 character");
      elseif (c2 < 128 or c2 > 191) then
         error("Invalid UTF-8 character");
      end

      -- validate byte 3
      if (c3 < 128 or c3 > 191) then
         error("Invalid UTF-8 character");
      end

      return 3;
   elseif (c >= 240 and c <= 244) then
      -- UTF8-4
      local c2 = strbyte(s, i + 1);
      local c3 = strbyte(s, i + 2);
      local c4 = strbyte(s, i + 3);

      if ((not c2) or (not c3) or (not c4)) then
         error("UTF-8 string terminated early");
      end

      -- validate byte 2
      if (c == 240 and (c2 < 144 or c2 > 191)) then
         error("Invalid UTF-8 character");
      elseif (c == 244 and (c2 < 128 or c2 > 143)) then
         error("Invalid UTF-8 character");
      elseif (c2 < 128 or c2 > 191) then
         error("Invalid UTF-8 character");
      end

      -- validate byte 3
      if (c3 < 128 or c3 > 191) then
         error("Invalid UTF-8 character");
      end

      -- validate byte 4
      if (c4 < 128 or c4 > 191) then
         error("Invalid UTF-8 character");
      end

      return 4;
   else
      error("Invalid UTF-8 character: " .. c);
   end
end

-------------------------------------------------------------------------------------------------------
-- Calculates the length of a UTF-8 encoded string.
-- @param s The UTF-8 encoded string.
-- @return The length of the string in characters.
-------------------------------------------------------------------------------------------------------
function AS_UTF8len(s)
   local len = 0;
   if (s) then          -- argument checking
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
   if (s and c) then                                  -- check if arguments are not empty (nil)
      local pos = 1;
      local bytes = strlen(s);                        -- number of length of the string s in bytes
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
   j = j or -1;            -- argument defaults, is not required

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

   local pos   = 1;
   local bytes = strlen(s);
   local len   = 0;

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
   if not s or #s == 0 then return "" end  -- Check if string is empty or nil

   local newstrParts = {};  -- Use table to collect parts of the new string
   local bytes = strlen(s);
   local index = 1;         -- Keep track of insert position in table
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
   
   return table.concat(newstrParts);  -- Join parts into final string
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
   AS_TestLine:Hide();     -- the frame is invisible in the game
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

         if ((char2 .. char1 == "|r") and (pos < bytes)) then     -- start of the link
            link_start_stop = true;
         elseif ((char2 .. char1 == "|c") and (pos < bytes)) then -- end of the link
            link_start_stop = false;
         end

         if ((char1 == '#') or ((char1 == " ") and (link_start_stop == false))) then   -- we have a space, not inside a link
            last_space = 0;
            nextstr = "";
         else
            nextstr = nextstr .. char1; -- characters following the last space
            last_space = last_space + charbytes;
         end
         if (link_start_stop == false) then -- we are not inside a link - can check
            AS_TestLine.text:SetWidth(Awidth);   -- set the frame width to the text
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
-- Reverses the order of UTF-8 letters in lines of 35 or 32 characters (limit)
-- Reverses lines in a string, with optional line length limit.
-- The function takes a string 's' and a limit 'limit' as arguments.
-- It iterates through the string, reversing each line and removing unnecessary characters.
-- The reversed lines are then concatenated and returned as a new string.

-- @param s The input string to be processed.
-- @param limit The maximum length of each line. Lines longer than this limit will be split.
-- @return The reversed string with lines limited to the specified length.
-------------------------------------------------------------------------------------------------------
function QTR_LineReverse(s, limit)
   local retstr = "";
   if (s and limit) then -- check if arguments are not empty (nil)
      local bytes = strlen(s);
      local pos = 1;
      local charbytes;
      local newstr = "";
      local counter = 0;
      local char1;
      while pos <= bytes do
         c = strbyte(s, pos);                  -- read the character (odczytaj znak)
         charbytes = AS_UTF8charbytes(s, pos); -- count of bytes (liczba bajtów znaku)
         char1 = strsub(s, pos, pos + charbytes - 1);
         newstr = newstr .. char1;
         pos = pos + charbytes;

         counter = counter + 1;
         if ((char1 >= "A") and (char1 <= "Z")) then
            counter = counter + 2; -- latin letters are 2x wider, then Arabic
         end
         if ((char1 == "#") or ((char1 == " ") and (counter > limit))) then
            newstr = string.gsub(newstr, "#", "");
            retstr = retstr .. AS_UTF8reverse(newstr) .. "\n";
            newstr = "";
            counter = 0;
         end
      end
      retstr = retstr .. AS_UTF8reverse(newstr);
      retstr = string.gsub(retstr, "#", "");
      retstr = string.gsub(retstr, "\n ", "\n");      -- space after newline code is useless
      retstr = string.gsub(retstr, "\n\n\n", "\n\n"); -- elimination of redundant newline codes
   end
   return retstr;
end
