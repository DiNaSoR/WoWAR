-- Books/Main.lua
-- Modularized Books (letters, notes) translation logic

local addonName, ns = ...
ns = ns or {}
ns.Books = ns.Books or {}
local Books = ns.Books

-- Internal state
local act_tr = "0"         -- current translation toggle state for the open book ("1" = translated)
local bookID = "0"
local title_en, title_tr, text_en, text_tr = "", "", "", ""
local page_str = "1"

local function SetBookJustify(isArabic)
  local just = isArabic and "RIGHT" or "LEFT"
  if ItemTextPageText and ItemTextPageText.SetJustifyH then
    ItemTextPageText:SetJustifyH("P", just)
    ItemTextPageText:SetJustifyH("H1", just)
    ItemTextPageText:SetJustifyH("H2", just)
    ItemTextPageText:SetJustifyH("H3", just)
  end
end

local function IsArabic()
  return (WoWTR_Localization and WoWTR_Localization.lang == 'AR') or false
end

-- Remember original fonts/sizes so we can restore them on toggle OFF
Books.origFonts = Books.origFonts or {}
local function CaptureOriginalFonts()
  if ItemTextPageText and ItemTextPageText.GetFont then
    if not Books.origFonts.P then
      local f,s,fl = ItemTextPageText:GetFont("P"); Books.origFonts.P = { f, s or 13, fl or "" }
    end
    if not Books.origFonts.H1 then
      local f,s,fl = ItemTextPageText:GetFont("H1"); Books.origFonts.H1 = { f or Books.origFonts.P[1], s or Books.origFonts.P[2], fl or Books.origFonts.P[3] }
    end
    if not Books.origFonts.H2 then
      local f,s,fl = ItemTextPageText:GetFont("H2"); Books.origFonts.H2 = { f or Books.origFonts.P[1], s or Books.origFonts.P[2], fl or Books.origFonts.P[3] }
    end
    if not Books.origFonts.H3 then
      local f,s,fl = ItemTextPageText:GetFont("H3"); Books.origFonts.H3 = { f or Books.origFonts.P[1], s or Books.origFonts.P[2], fl or Books.origFonts.P[3] }
    end
  end
  if ItemTextFrameTitleText and ItemTextFrameTitleText.GetFont and not Books.origFonts.title then
    local f,s,fl = ItemTextFrameTitleText:GetFont(); Books.origFonts.title = { f, s or 13, fl or "" }
  end
end

local function ApplyOriginalBodyFont()
  if not ItemTextPageText or not ItemTextPageText.SetFont then return end
  local f = Books.origFonts
  if f and f.P then ItemTextPageText:SetFont("P", f.P[1], f.P[2], f.P[3]) end
  if f and f.H1 then ItemTextPageText:SetFont("H1", f.H1[1], f.H1[2], f.H1[3]) end
  if f and f.H2 then ItemTextPageText:SetFont("H2", f.H2[1], f.H2[2], f.H2[3]) end
  if f and f.H3 then ItemTextPageText:SetFont("H3", f.H3[1], f.H3[2], f.H3[3]) end
end

local function SetBookJustifyAsync(isArabic)
  local token = Books.justifyToken or 0
  SetBookJustify(isArabic)
  local function try()
    if (Books.justifyToken or 0) ~= token then return end
    SetBookJustify(isArabic)
  end
  if StartDelayedFunction then
    StartDelayedFunction(try, 0.02)
    StartDelayedFunction(try, 0.10)
    StartDelayedFunction(try, 0.20)
  elseif C_Timer and C_Timer.After then
    C_Timer.After(0.02, try)
    C_Timer.After(0.10, try)
    C_Timer.After(0.20, try)
  end
end

local function ApplyBodyFont()
  if not ItemTextPageText or not ItemTextPageText.SetFont then return end
  local _, size, flags = ItemTextPageText:GetFont("P")
  local fsize = (BT_PM and BT_PM["setsize"] == "1") and (tonumber(BT_PM["fontsize"]) or size) or size
  if WOWTR_Font2 then
    ItemTextPageText:SetFont("P", WOWTR_Font2, fsize, flags)
    ItemTextPageText:SetFont("H1", WOWTR_Font2, fsize, flags)
    ItemTextPageText:SetFont("H2", WOWTR_Font2, fsize, flags)
    ItemTextPageText:SetFont("H3", WOWTR_Font2, fsize, flags)
  end
end

local function BumpJustifyToken()
  Books.justifyToken = (Books.justifyToken or 0) + 1
end

local booksEventFrame
local function RegisterOneShotPageEvents()
  booksEventFrame = booksEventFrame or CreateFrame("Frame")
  local token = Books.justifyToken or 0
  local handled = false
  booksEventFrame:SetScript("OnEvent", function(self, event)
    if (Books.justifyToken or 0) ~= token then return end
    ApplyBodyFont()
    SetBookJustify(IsArabic() and act_tr == "1")
    if not handled then
      handled = true
      self:UnregisterAllEvents(); self:SetScript("OnEvent", nil)
    end
  end)
  booksEventFrame:RegisterEvent("ITEM_TEXT_READY")
end

local function save_original()
  if (BT_PM and BT_PM["saveNW"] == "1") then
    if (not page_str or page_str == "0") then return end
    if (strlen(page_str) == 1) then page_str = "0" .. page_str end
    local safe_bookID = bookID or tostring(StringHash(text_en))
    BT_SAVED[safe_bookID .. " STR" .. page_str] = (title_en or "") .. "@" .. (text_en or "")
  end
end

local function UpdateToggleButton(hasTranslation)
  if not BT_ToggleButton0 then return end
  local showID = BT_PM and BT_PM["showID"] == "1"
  local isAR = (WoWTR_Localization and WoWTR_Localization.lang == 'AR')
  -- Ensure toggle button uses our font
  do
    local fs = BT_ToggleButton0:GetFontString()
    if not fs then
      fs = BT_ToggleButton0:CreateFontString(nil, "ARTWORK")
      BT_ToggleButton0:SetFontString(fs)
    end
    if fs and fs.SetFont and WOWTR_Font2 then
      fs:SetFont(WOWTR_Font2, 13)
    end
  end
  if act_tr == "1" then
    if showID and bookID and bookID ~= "" then
      if isAR then
        BT_ToggleButton0:SetText("("..WoWTR_Localization.lang..") "..bookID.." "..QTR_ReverseIfAR(WoWTR_Localization.bookID))
      else
        BT_ToggleButton0:SetText(WoWTR_Localization.bookID.." "..bookID.." ("..WoWTR_Localization.lang..")")
      end
      BT_ToggleButton0:SetWidth(170)
    else
      BT_ToggleButton0:SetText(WoWTR_Localization and WoWTR_Localization.lang or "TR")
      BT_ToggleButton0:SetWidth(40)
    end
  else
    if showID and bookID and bookID ~= "" then
      if isAR then
        BT_ToggleButton0:SetText("(EN) "..bookID.." "..QTR_ReverseIfAR(WoWTR_Localization.bookID))
      else
        BT_ToggleButton0:SetText(WoWTR_Localization.bookID.." "..bookID.." (EN)")
      end
      BT_ToggleButton0:SetWidth(170)
    else
      BT_ToggleButton0:SetText("EN")
      BT_ToggleButton0:SetWidth(40)
    end
  end
  if hasTranslation then BT_ToggleButton0:Enable() else BT_ToggleButton0:Disable() end
end

-- Toggle translated/original view
function Books.Toggle()
  if (act_tr == "0") then
    act_tr = "1"
    if BT_PM then BT_PM["book_tr_on"] = "1" end
    BumpJustifyToken(); RegisterOneShotPageEvents()
    CaptureOriginalFonts()
    if (BT_PM and BT_PM["title"] == "1" and title_tr) then
      ItemTextFrameTitleText:SetText(QTR_ReverseIfAR(title_tr))
      ItemTextFrameTitleText:SetFont(WOWTR_Font2, 11)
    end
    ItemTextPageText:SetText(QTR_ExpandUnitInfo(text_tr, false, ItemTextPageText, WOWTR_Font2, -10))
    SetBookJustifyAsync(IsArabic())
    UpdateToggleButton(true)
  else
    act_tr = "0"
    if BT_PM then BT_PM["book_tr_on"] = "0" end
    BumpJustifyToken(); RegisterOneShotPageEvents()
    CaptureOriginalFonts()
    if (BT_PM and BT_PM["title"] == "1") then
      ItemTextFrameTitleText:SetText(title_en)
      if Books.origFonts and Books.origFonts.title then
        ItemTextFrameTitleText:SetFont(Books.origFonts.title[1], Books.origFonts.title[2], Books.origFonts.title[3])
      end
    end
    ApplyOriginalBodyFont()
    ItemTextPageText:SetText(text_en)
    SetBookJustifyAsync(false)
    UpdateToggleButton(true)
  end
end

-- Show translation for current ItemText page
function Books.ShowTranslation()
  if not BT_PM or BT_PM["active"] ~= "1" then
    if BT_ToggleButton0 then BT_ToggleButton0:Hide() end
    return
  end

  if BT_ToggleButton0 then
    BT_ToggleButton0:Show()
  end
  -- Restore last toggle state if remembered
  if BT_PM and BT_PM["book_tr_on"] then act_tr = BT_PM["book_tr_on"] else act_tr = act_tr or "0" end
  BumpJustifyToken(); RegisterOneShotPageEvents()

  title_en = ItemTextGetItem() or ""
  text_en = WOWTR_DetectAndReplacePlayerName(ItemTextGetText(), nil, "$N") or ""
  page_str = tostring(ItemTextGetPage() or "1")
  if (not page_str or page_str == "nil" or page_str == "") then page_str = '1' end

  local _, link = C_Item.GetItemInfo(ItemTextGetItem())
  local hashID = tostring(StringHash(WOWTR_NormalizeForHash(text_en)))
  bookID = ""
  if link and type(link) == "string" then
    local _, itemID = strsplit(":", link)
    if itemID and tonumber(itemID) then bookID = tostring(itemID) end
  end

  if ((not bookID) or (bookID == "") or (bookID == "|Hitem")) then
    if title_en == "Plain Letter" or title_en == "Order of Night Propaganda" or (_G["BT_Books"] and _G["BT_Books"][tostring(StringHash(WOWTR_NormalizeForHash(text_en)))]) then
      bookID = tostring(StringHash(WOWTR_NormalizeForHash(text_en)))
    else
      local beginTXT = string.gsub(text_en, "\n", "")
      local marker = (title_en or "") .. "#" .. page_str .. "#" .. string.sub(beginTXT, 1, 15)
      local gl_BT_BooksID = _G["BT_BooksID"]
      bookID = (gl_BT_BooksID and gl_BT_BooksID[marker]) or tostring(StringHash(WOWTR_NormalizeForHash(text_en)))
    end
  end
  if (not bookID) or (bookID == "") then
    local beginTXT = string.gsub(text_en, "\n", "")
    local marker = (title_en or "") .. "#" .. page_str .. "#" .. string.sub(beginTXT, 1, 15)
    local gl_BT_BooksID2 = _G["BT_BooksID"]
    bookID = (gl_BT_BooksID2 and gl_BT_BooksID2[marker]) or hashID
  end

  if ((not bookID) or (bookID == "") or (bookID == "|Hitem")) then
    save_original(); return
  end

  local gl_BT_Books = _G["BT_Books"]
  if gl_BT_Books and gl_BT_Books[bookID] then
    local hasPage = gl_BT_Books[bookID][page_str]
    local hasTitle = (BT_PM and BT_PM["title"] == "1" and gl_BT_Books[bookID].Title and gl_BT_Books[bookID].Title ~= '')
    if hasPage or hasTitle then
      if hasTitle then
        title_tr = gl_BT_Books[bookID]["Title"]
        if act_tr == "1" and title_tr and title_tr ~= "" then
          ItemTextFrameTitleText:SetText(QTR_ReverseIfAR(title_tr))
          ItemTextFrameTitleText:SetFont(WOWTR_Font2, 11)
        else
          ItemTextFrameTitleText:SetText(title_en)
        end
      end

      text_tr = gl_BT_Books[bookID][page_str] or ""
      text_tr = string.gsub(text_tr, "$b", "$B")
      text_tr = string.gsub(text_tr, "$B", "\n")
      text_tr = string.gsub(text_tr, "$N", WOWTR_player_name or "")
      text_tr = string.gsub(text_tr, "$o", "$O")

      local pos = string.find(text_tr, "$O")
      while pos and pos > 0 do
        local n1 = pos + 1
        while string.sub(text_tr, n1, n1) ~= "(" do n1 = n1 + 1 end
        local n2 = n1 + 1
        while string.sub(text_tr, n2, n2) ~= ";" do n2 = n2 + 1 end
        local n3 = n2 + 1
        while string.sub(text_tr, n3, n3) ~= ")" do n3 = n3 + 1 end
        local forma
        if QTR_PS and QTR_PS["ownname"] == "1" then
          forma = string.sub(text_tr, n2 + 1, n3 - 1)
        else
          forma = string.sub(text_tr, n1 + 1, n2 - 1)
        end
        text_tr = string.sub(text_tr, 1, pos - 1) .. forma .. string.sub(text_tr, n3 + 1)
        pos = string.find(text_tr, "$O", pos + 1)
      end

      -- Apply according to remembered toggle state
      local font, size, flags = ItemTextPageText:GetFont("P")
      if (BT_PM and BT_PM["setsize"] == "1") then
        ItemTextPageText:SetFont("P", WOWTR_Font2, tonumber(BT_PM["fontsize"]) or size, flags)
      else
        ItemTextPageText:SetFont("P", WOWTR_Font2, size, flags)
      end

      if act_tr == "1" then
        -- Show translated (respect RTL for AR)
        ItemTextPageText:SetText(QTR_ExpandUnitInfo(text_tr, false, ItemTextPageText, WOWTR_Font2, -10))
        SetBookJustifyAsync(ns and ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL())
        UpdateToggleButton(true)
      else
        -- Show original EN (LTR)
        ItemTextPageText:SetText(text_en)
        SetBookJustifyAsync(false)
        UpdateToggleButton(true)
      end
      -- ensure final state
      UpdateToggleButton(true)
    else
      save_original()
      UpdateToggleButton(false)
    end
  else
    save_original()
    UpdateToggleButton(false)
  end
end

-- Global wrappers for back-compat with Core hooks
function BookTranslator_ShowTranslation() return Books.ShowTranslation() end
function BT_ON_OFF() return Books.Toggle() end

