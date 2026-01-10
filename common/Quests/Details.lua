-- Quests/Details.lua
-- Facade for quest detail handling and translate on/off

local addonName, ns = ...
ns = ns or {}
ns.Quests = ns.Quests or {}
local Quests = ns.Quests

Quests.Details = Quests.Details or {}
-- Debounce state for rapid QuestPrepare calls from QuestMapFrame_ShowQuestDetails
local _lastPrepareQuestID = 0
local _lastPrepareAt = 0
local _postLayoutTicker

-- Detect Arabic script in a UTF-8 string (base Arabic + Presentation Forms).
-- Kept local to this file because `common/Text.lua` is loaded later in the TOC.
local function ContainsArabic(txt)
  if not txt or txt == "" then return false end

  -- Arabic Presentation Forms-A/B live in UTF-8 sequences starting with 0xEF 0xAD..0xBB
  if (string.find(txt, "\239\173") ~= nil)
      or (string.find(txt, "\239\174") ~= nil)
      or (string.find(txt, "\239\175") ~= nil)
      or (string.find(txt, "\239\185") ~= nil)
      or (string.find(txt, "\239\186") ~= nil)
      or (string.find(txt, "\239\187") ~= nil) then
    return true
  end

  -- Most Arabic base letters live in 2-byte UTF-8 sequences starting with 0xD8..0xDB.
  if string.find(txt, "[\216\217\218\219]") ~= nil then
    return true
  end

  -- Fallback: use reshaper helper if available.
  if type(_G.AS_ContainsArabic) == "function" then
    return _G.AS_ContainsArabic(txt) == true
  end

  return false
end

local function CancelPostLayoutTicker()
  if _postLayoutTicker then
    _postLayoutTicker:Cancel()
    _postLayoutTicker = nil
  end
end

function Quests.Details.SchedulePostLayoutRefresh()
  CancelPostLayoutTicker()
  if not (QuestMapFrame and QuestMapFrame:IsVisible()) then return end
  -- Intentionally always schedule while QuestMapFrame is visible.
  -- Blizzard can overwrite quest strings after our initial translation pass; this ticker
  -- re-applies the chosen view (translated) a few times right after layout changes.
  local runs = 0
  _postLayoutTicker = C_Timer.NewTicker(0.08, function()
    runs = runs + 1
    if QTR_curr_trans == "1" then
      -- Pass "__post__" event to prevent duplicate processing
      QTR_Translate_On(1, "__post__")
    end
    local shouldStop = (runs >= 4) or not (QuestMapFrame and QuestMapFrame:IsVisible()) or (QTR_curr_trans ~= "1")
    if shouldStop then
      CancelPostLayoutTicker()
    end
  end)
end

function Quests.Details.CancelPostLayoutRefresh()
  CancelPostLayoutTicker()
end

-- Display translation
function Quests.Details.TranslateOn(typ,event)
   -- NOTE: "__post__" is intentionally allowed to run even right after QuestPrepare.
   -- Blizzard frequently re-applies quest UI strings after QuestMapFrame_ShowQuestDetails,
   -- which can overwrite our translated Arabic text. The post-layout ticker exists to
   -- re-apply the translation after those late UI updates.
   
   if WOWTR and WOWTR.Debug then
     WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn called with typ:", typ, "event:", event or "nil")
     WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QTR_quest_ID:", QTR_quest_ID)
   end

   -- Always keep the user's preference as "translated ON" when this is called.
   QTR_curr_trans = "1"

   -- Guard: do NOT apply Arabic headers/RTL unless the current quest actually has real Arabic QuestData.
   -- Otherwise we end up with mixed UI (Arabic headers like "الوصف" on an English quest body).
   if typ == 1 then
      local numer_ID = QTR_quest_ID or 0
      local str_ID = tostring(numer_ID)
      local qd = (QTR_QuestData and QTR_QuestData[str_ID]) or nil
      local hasRealTrans = false
      if qd then
         local fields = { "Title", "Description", "Objectives", "Progress", "Completion" }
         for i = 1, #fields do
            local v = qd[fields[i]]
            if type(v) == "string" and v ~= "" and ContainsArabic(v) then
               hasRealTrans = true
               break
            end
         end
      end
      if not hasRealTrans then
         -- Keep preference ON, but ensure the UI stays in the original (LTR/English) layout.
         if Quests and Quests.Details and Quests.Details.TranslateOff then
            Quests.Details.TranslateOff(typ, "__keep_state__")
         end
         return
      end
   end

   QTR_display_constants(1)
   if (QuestNPCModelText:IsVisible() and (QTR_ModelTextHash>0)) then
      QuestNPCModelText:SetFont(WOWTR_Font2, 13)
      QuestNPCModelText:SetText(QTR_ExpandUnitInfo(QTR_ModelText_PL..NONBREAKINGSPACE,false,QuestNPCModelText,WOWTR_Font2,-15))
      if QuestNPCModelText.SetJustifyH then
        if ns and ns.RTL and ns.RTL.JustifyFontString then
          ns.RTL.JustifyFontString(QuestNPCModelText, "LEFT")
        else
          QuestNPCModelText:SetJustifyH("RIGHT")
        end
      end
   end

   if (typ==1) then
      local numer_ID = QTR_quest_ID
      str_ID = tostring(numer_ID)
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Checking quest data for ID:", str_ID)
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QTR_QuestData[str_ID] exists:", QTR_QuestData and QTR_QuestData[str_ID] ~= nil)
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QTR_quest_EN[numer_ID] exists:", QTR_quest_EN and QTR_quest_EN[numer_ID] ~= nil)
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QTR_quest_LG[numer_ID] exists:", QTR_quest_LG and QTR_quest_LG[numer_ID] ~= nil)
      end
      
      if (numer_ID>0 and QTR_QuestData[str_ID]) then
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Quest data found, setting button text...")
        end
         QTR_ToggleButton0:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")")
         QTR_ToggleButton1:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")")
         QTR_ToggleButton2:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")")
         if (isClassicQuestLog()) then
            QTR_ToggleButton3:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")")
         end
         if (isImmersion()) then
            QTR_ToggleButton4:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")")
            if (not WOWTR_wait(0.2,QTR_Immersion)) then end
         end
         local storylineFrame = GetStorylineFrame()
         if (isStoryline() and storylineFrame and storylineFrame:IsVisible()) then
            QTR_ToggleButton5:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")")
            QTR_Storyline(1)
         end
         if (IsDUIQuestFrame()) then
            QTR_ToggleButton7:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")")
            QTR_ToggleButton7:Enable()
         end

         local WOW_width = 280
         local rtl = (Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL()) or false
         if rtl then WOW_width = 320 end
         if (QuestInfoRewardsFrame:IsVisible() and not rtl) then WOW_width = 280 end
         -- Unified text column width (make Title/Desc/Obj/Prog/Comp match).
         -- In RTL we previously used a wider title with a -50 correction; now we keep widths equal and place the icon outside.
         local textW = rtl and (WOW_width - 50) or (WOW_width - 1)
         -- Some Blizzard FontStrings are anchored LEFT+RIGHT, so `SetWidth()` alone doesn't change the actual width.
         -- For "perfect same width", we also tighten the RIGHT anchor by the measured delta.
         Quests.Details._OrigPoints = Quests.Details._OrigPoints or {}
         Quests.Details._AppliedDelta = Quests.Details._AppliedDelta or {}
         local function savePoints(fs)
            if not (fs and fs.GetNumPoints and fs.GetPoint) then return end
            if Quests.Details._OrigPoints[fs] then return end
            local pts = {}
            local n = fs:GetNumPoints() or 0
            for i = 1, n do
               pts[i] = { fs:GetPoint(i) }
            end
            Quests.Details._OrigPoints[fs] = pts
         end

         local function enforceWidth(fs, desiredW)
            if not (fs and desiredW and fs.GetWidth) then return end
            if fs.SetWidth then fs:SetWidth(desiredW) end
            local w0 = fs:GetWidth() or 0
            local delta = w0 - desiredW
            if delta > 0.5 and fs.GetNumPoints and fs:GetNumPoints() >= 2 and fs.GetPoint and fs.ClearAllPoints and fs.SetPoint then
               savePoints(fs)
               local pts = {}
               local n = fs:GetNumPoints() or 0
               for i = 1, n do
                  pts[i] = { fs:GetPoint(i) }
               end

               -- Find which point is the RIGHT anchor, then shift it left by delta.
               local rightIndex = nil
               for i = 1, n do
                  local p, relTo, relP = pts[i][1], pts[i][2], pts[i][3]
                  if type(p) == "string" and p:find("RIGHT") then
                     rightIndex = i
                     break
                  end
                  if type(relP) == "string" and relP:find("RIGHT") then
                     rightIndex = i
                     break
                  end
               end
               if not rightIndex then rightIndex = n end
               pts[rightIndex][4] = (pts[rightIndex][4] or 0) - delta

               fs:ClearAllPoints()
               for i = 1, n do
                  fs:SetPoint(unpack(pts[i]))
               end

               -- Remember the margin we created so we can place the title icon consistently across post-layout refresh passes.
               Quests.Details._AppliedDelta[fs] = delta
            end
         end

         if (QTR_PS["transtitle"] == "1") then
            local currentHeaderTitle = (QuestInfoTitleHeader and QuestInfoTitleHeader.GetText and QuestInfoTitleHeader:GetText()) or ""
            QuestInfoTitleHeader:SetWidth(textW)
            QuestProgressTitleText:SetWidth(textW)
            enforceWidth(QuestInfoTitleHeader, textW)
            enforceWidth(QuestProgressTitleText, textW)
            -- Cache the ORIGINAL quest title font so we can render any "icon glyph" that doesn't exist in Arabic fonts.
            -- (Some decorations use private glyphs that only render correctly with the original FontString font.)
            Quests.Details._TitleIconFontCache = Quests.Details._TitleIconFontCache or {}
            do
               local f, s, flags
               if QuestInfoTitleHeader and QuestInfoTitleHeader.GetFont then
                  f, s, flags = QuestInfoTitleHeader:GetFont()
               end
               if f and f ~= "" then
                  Quests.Details._TitleIconFontCache[QTR_quest_ID] = { font = f, size = s, flags = flags }
               end
            end

            QuestInfoTitleHeader:SetFont(WOWTR_Font1, C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtitle.size or 18)
            QuestProgressTitleText:SetFont(WOWTR_Font1, C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtitle.size or 18)

            -- Preserve quest title "decorations" that Blizzard sometimes injects:
            -- - Inline textures / atlases (`|T...|t`, `|A...|a`)
            -- - A leading "icon glyph" (non-ASCII, or "!" / "?") that is NOT represented as a `|T` tag.
            --   These glyphs are often missing from Arabic fonts, so we render them in a separate FontString
            --   using the original quest title font.
            local function utf8first(s)
               if type(s) ~= "string" or s == "" then return nil end
               return s:match("^[%z\1-\127\194-\244][\128-\191]*")
            end

            local function extractLeadingTitleDecorations(txt)
               if type(txt) ~= "string" or txt == "" then return "", "" end
               local rest = txt:gsub("^%s+", "")
               local out = {}
               local safety = 0

               -- Leading hyperlink tags (e.g. `|HRepeatable...|h<icon>|h`).
               -- These are not `|T`/`|A`, but they still act like "decorations" and must be preserved in RTL.
               local linkGlyph = ""
               while safety < 10 do
                  safety = safety + 1
                  local link = rest:match("^(|H.-|h.-|h)")
                  if not link then break end
                  if linkGlyph == "" then
                     local display = link:match("^|H.-|h(.-)|h") or ""
                     display = tostring(display)
                     -- Strip leading color/name codes to get at the actual glyph.
                     -- e.g. `|cFFFFD200!|r` or `|cnXYZ:!|r`
                     for _ = 1, 5 do
                        local before = display
                        display = display:gsub("^|c%x%x%x%x%x%x%x%x", "")
                        display = display:gsub("^|cn[%w_]+:", "")
                        display = display:gsub("^|r", "")
                        display = display:gsub("^%s+", "")
                        if display == before then break end
                     end
                     -- The repeatable/title decoration often uses an inline atlas/texture inside the link display.
                     -- Capture the first inline tag so we can render it in our overlay.
                     local inlineTag = display:match("^(|A.-|a)") or display:match("^(|T.-|t)")
                     if inlineTag and inlineTag ~= "" then
                        linkGlyph = inlineTag
                     end
                     local ch = utf8first(display)
                     if ch and ch ~= "" then
                        local isNonASCII = (#ch > 1)
                        local isBang = (ch == "!" or ch == "?")
                        if isNonASCII or isBang then
                           linkGlyph = ch
                        end
                     end
                  end
                  rest = rest:sub(#link + 1)
                  rest = rest:gsub("^%s+", "")
               end

               -- Leading inline texture/atlas tags.
               -- (Reset safety counter so we don't prematurely stop if there was a hyperlink tag first.)
               safety = 0
               while safety < 10 do
                  safety = safety + 1
                  local tag = rest:match("^(|T.-|t)")
                  if not tag then tag = rest:match("^(|A.-|a)") end
                  if not tag then break end
                  out[#out + 1] = tag
                  rest = rest:sub(#tag + 1)
                  rest = rest:gsub("^%s+", "")
               end

               local glyph = ""
               do
                  local ch = utf8first(rest)
                  if ch and ch ~= "" then
                     local isNonASCII = (#ch > 1)
                     local isBang = (ch == "!" or ch == "?")
                     if isNonASCII or isBang then
                        glyph = ch
                     end
                  end
               end

               if glyph == "" and linkGlyph ~= "" then glyph = linkGlyph end
               return table.concat(out, ""), glyph
            end

            local titleLG = QTR_quest_LG[QTR_quest_ID] and QTR_quest_LG[QTR_quest_ID].title or ""
            local titleEN = QTR_quest_EN[QTR_quest_ID] and QTR_quest_EN[QTR_quest_ID].title or ""
            -- Prefer the live header title (still English at this moment) to capture late-applied Blizzard decorations.
            local titleENDecorated = titleEN
            if currentHeaderTitle ~= "" and (not ContainsArabic(currentHeaderTitle)) then
               titleENDecorated = currentHeaderTitle
            end
            local leadingTags, leadingGlyph = extractLeadingTitleDecorations(titleENDecorated)
            -- Capture the leading hyperlink decoration (if present) so our overlay icon can reproduce its tooltip behavior.
            local leadingLinkRef = titleENDecorated:match("^|H([^|]+)|h")
            local leadingLinkText = titleENDecorated:match("^|H.-|h(.-)|h")
            Quests.Details._TitleDecorLinks = Quests.Details._TitleDecorLinks or {}
            if leadingLinkRef and leadingLinkRef ~= "" then
               Quests.Details._TitleDecorLinks[QTR_quest_ID] = { ref = leadingLinkRef, text = leadingLinkText }
            else
               Quests.Details._TitleDecorLinks[QTR_quest_ID] = nil
            end

            -- Inline tags are safe to keep inside the Arabic title (they render regardless of font).
            if leadingTags ~= "" and type(titleLG) == "string" and titleLG ~= "" and (not titleLG:find("|T", 1, true)) and (not titleLG:find("|A", 1, true)) then
               if rtl then
                  -- Append before reversal so the icon ends up on the LEFT visually after RTL shaping.
                  titleLG = titleLG .. " " .. leadingTags
               else
                  titleLG = leadingTags .. " " .. titleLG
               end
            end

            -- Leading icon glyph: render in a separate FontString using the ORIGINAL quest font (Arabic fonts may not contain it).
            do
               local titleParent = (QuestInfoTitleHeader and QuestInfoTitleHeader.GetParent and QuestInfoTitleHeader:GetParent()) or nil
               local progParent = (QuestProgressTitleText and QuestProgressTitleText.GetParent and QuestProgressTitleText:GetParent()) or nil
               if not Quests.Details._TitleIconFS and titleParent then
                  Quests.Details._TitleIconFS = titleParent:CreateFontString(nil, "OVERLAY")
               elseif Quests.Details._TitleIconFS and titleParent then
                  -- Re-parent to current titleParent (may differ between QuestMapFrame and QuestFrame)
                  Quests.Details._TitleIconFS:SetParent(titleParent)
               end
               if not Quests.Details._ProgressTitleIconFS and progParent then
                  Quests.Details._ProgressTitleIconFS = progParent:CreateFontString(nil, "OVERLAY")
               elseif Quests.Details._ProgressTitleIconFS and progParent then
                  -- Re-parent to current progParent
                  Quests.Details._ProgressTitleIconFS:SetParent(progParent)
               end

               -- Mouse hit boxes so the overlay icon has the same tooltip hover behavior as the original title hyperlink.
               if not Quests.Details._TitleIconHit and titleParent then
                  local hit = CreateFrame("Frame", nil, titleParent)
                  hit:EnableMouse(true)
                  hit:SetFrameStrata("TOOLTIP")
                  Quests.Details._TitleIconHit = hit
               elseif Quests.Details._TitleIconHit and titleParent then
                  -- Re-parent to current titleParent
                  Quests.Details._TitleIconHit:SetParent(titleParent)
               end
               if not Quests.Details._ProgressTitleIconHit and progParent then
                  local hit2 = CreateFrame("Frame", nil, progParent)
                  hit2:EnableMouse(true)
                  hit2:SetFrameStrata("TOOLTIP")
                  Quests.Details._ProgressTitleIconHit = hit2
               elseif Quests.Details._ProgressTitleIconHit and progParent then
                  -- Re-parent to current progParent
                  Quests.Details._ProgressTitleIconHit:SetParent(progParent)
               end

               local iconFS = Quests.Details._TitleIconFS
               local iconFS2 = Quests.Details._ProgressTitleIconFS

               local inQuestMap = (QuestMapFrame and QuestMapFrame.IsVisible and QuestMapFrame:IsVisible()) or false
               -- To avoid a visible "snap" (Blizzard/ElvUI can adjust anchors/fonts after our first pass),
               -- defer showing the overlay icon until the post-layout reapply pass in QuestMapFrame.
               local allowIconShow = not (rtl and inQuestMap and event ~= "__post__")

               Quests.Details._IconPosLock = Quests.Details._IconPosLock or {}
               local lockIdTitle = tostring(QTR_quest_ID or 0) .. ":title:" .. (inQuestMap and "map" or "other")
               local lockIdProg = tostring(QTR_quest_ID or 0) .. ":prog:" .. (inQuestMap and "map" or "other")

               if leadingGlyph ~= "" and Original_Font1 then
                  local titleSize = C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtitle.size or 18
                  local cache = Quests.Details._TitleIconFontCache and Quests.Details._TitleIconFontCache[QTR_quest_ID]
                  local iconFont = (cache and cache.font) or Original_Font1
                  local iconSize = (cache and cache.size) or titleSize
                  local iconFlags = (cache and cache.flags) or ""
                  local function showHyperlinkTooltip(ownerFrame, linkRef, linkText)
                     -- Try to reuse Blizzard's handler on the owning frame (if present), else fall back to GameTooltip.
                     if ownerFrame and ownerFrame.GetScript then
                        local hEnter = ownerFrame:GetScript("OnHyperlinkEnter")
                        if type(hEnter) == "function" then
                           pcall(hEnter, ownerFrame, linkRef, linkText)
                           return
                        end
                     end
                     if GameTooltip then
                        GameTooltip:SetOwner(ownerFrame or UIParent, "ANCHOR_RIGHT")
                        local full = "|H" .. tostring(linkRef) .. "|h" .. tostring(linkText or "") .. "|h"
                        local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, full)
                        if not ok then
                           GameTooltip:SetText(tostring(linkRef))
                        end
                        GameTooltip:Show()
                     end
                  end

                  local function hideHyperlinkTooltip(ownerFrame, linkRef, linkText)
                     if ownerFrame and ownerFrame.GetScript then
                        local hLeave = ownerFrame:GetScript("OnHyperlinkLeave")
                        if type(hLeave) == "function" then
                           pcall(hLeave, ownerFrame, linkRef, linkText)
                        end
                     end
                     if GameTooltip then GameTooltip:Hide() end
                  end

                  if iconFS then
                     iconFS:SetFont(iconFont, iconSize or titleSize, iconFlags)
                     iconFS:SetText(leadingGlyph)
                     if allowIconShow then
                        if not (rtl and inQuestMap and Quests.Details._IconPosLock[lockIdTitle]) then
                           iconFS:ClearAllPoints()
                           if rtl then
                              -- Place the icon inside the right margin created by enforceWidth() (see lessons L-013).
                              -- Use the measured icon width (fallback for |A/|T) so we don't push it outside the frame
                              -- when the reserved margin (dx) is smaller than our previous fixed-width guess.
                              local dx = (Quests.Details._AppliedDelta and Quests.Details._AppliedDelta[QuestInfoTitleHeader]) or 0
                              if dx < 0 then dx = 0 end
                              local gap, pad, extra = 2, 0, 15
                              local w = 0
                              if type(leadingGlyph) == "string" and (leadingGlyph:find("^|A") or leadingGlyph:find("^|T")) then
                                 w = 22
                              elseif iconFS.GetStringWidth then
                                 w = iconFS:GetStringWidth() or 0
                              end
                              if w < 8 then w = 8 end
                              local desired = dx - pad
                              local minOffset = w + gap
                              local maxOffset = dx + extra
                              local xOffset = desired
                              if xOffset < minOffset then xOffset = minOffset end
                              if xOffset > maxOffset then xOffset = maxOffset end
                              iconFS:SetWidth(0) -- let it size naturally; we only control positioning.
                              iconFS:SetJustifyH("RIGHT")
                              iconFS:SetPoint("RIGHT", QuestInfoTitleHeader, "RIGHT", xOffset, 0)
                           else
                              iconFS:SetWidth(0)
                              iconFS:SetPoint("LEFT", QuestInfoTitleHeader, "LEFT", 0, 0)
                           end
                           if rtl and inQuestMap and event == "__post__" then
                              Quests.Details._IconPosLock[lockIdTitle] = true
                           end
                        end
                        iconFS:Show()
                     else
                        iconFS:Hide()
                     end
                  end
                  if iconFS2 then
                     iconFS2:SetFont(iconFont, iconSize or titleSize, iconFlags)
                     iconFS2:SetText(leadingGlyph)
                     if allowIconShow then
                        if not (rtl and inQuestMap and Quests.Details._IconPosLock[lockIdProg]) then
                           iconFS2:ClearAllPoints()
                           if rtl then
                              local dx2 = (Quests.Details._AppliedDelta and Quests.Details._AppliedDelta[QuestProgressTitleText]) or 0
                              if dx2 < 0 then dx2 = 0 end
                              local gap2, pad2, extra2 = 2, 0, 15
                              local w2 = 0
                              if type(leadingGlyph) == "string" and (leadingGlyph:find("^|A") or leadingGlyph:find("^|T")) then
                                 w2 = 22
                              elseif iconFS2.GetStringWidth then
                                 w2 = iconFS2:GetStringWidth() or 0
                              end
                              if w2 < 8 then w2 = 8 end
                              local desired2 = dx2 - pad2
                              local minOffset2 = w2 + gap2
                              local maxOffset2 = dx2 + extra2
                              local xOffset2 = desired2
                              if xOffset2 < minOffset2 then xOffset2 = minOffset2 end
                              if xOffset2 > maxOffset2 then xOffset2 = maxOffset2 end
                              iconFS2:SetWidth(0)
                              iconFS2:SetJustifyH("RIGHT")
                              iconFS2:SetPoint("RIGHT", QuestProgressTitleText, "RIGHT", xOffset2, 0)
                           else
                              iconFS2:SetWidth(0)
                              iconFS2:SetPoint("LEFT", QuestProgressTitleText, "LEFT", 0, 0)
                           end
                           if rtl and inQuestMap and event == "__post__" then
                              Quests.Details._IconPosLock[lockIdProg] = true
                           end
                        end
                        iconFS2:Show()
                     else
                        iconFS2:Hide()
                     end
                  end

                  -- Position and wire hover tooltips for the icon hit boxes.
                  local linkInfo = Quests.Details._TitleDecorLinks and Quests.Details._TitleDecorLinks[QTR_quest_ID]
                  local linkRef = linkInfo and linkInfo.ref or nil
                  local linkText = linkInfo and linkInfo.text or nil
                  if Quests.Details._TitleIconHit and iconFS and iconFS.IsShown and iconFS:IsShown() and linkRef and allowIconShow then
                     local hit = Quests.Details._TitleIconHit
                     hit:ClearAllPoints()
                     hit:SetPoint("CENTER", iconFS, "CENTER", 0, 0)
                     hit:SetSize(22, 22)
                     hit:Show()
                     hit:SetScript("OnEnter", function(self)
                        showHyperlinkTooltip(titleParent or self, linkRef, linkText)
                     end)
                     hit:SetScript("OnLeave", function(self)
                        hideHyperlinkTooltip(titleParent or self, linkRef, linkText)
                     end)
                  elseif Quests.Details._TitleIconHit then
                     Quests.Details._TitleIconHit:Hide()
                  end

                  if Quests.Details._ProgressTitleIconHit and iconFS2 and iconFS2.IsShown and iconFS2:IsShown() and linkRef and allowIconShow then
                     local hit2 = Quests.Details._ProgressTitleIconHit
                     hit2:ClearAllPoints()
                     hit2:SetPoint("CENTER", iconFS2, "CENTER", 0, 0)
                     hit2:SetSize(22, 22)
                     hit2:Show()
                     hit2:SetScript("OnEnter", function(self)
                        showHyperlinkTooltip(progParent or self, linkRef, linkText)
                     end)
                     hit2:SetScript("OnLeave", function(self)
                        hideHyperlinkTooltip(progParent or self, linkRef, linkText)
                     end)
                  elseif Quests.Details._ProgressTitleIconHit then
                     Quests.Details._ProgressTitleIconHit:Hide()
                  end
               else
                  if iconFS then iconFS:Hide() end
                  if iconFS2 then iconFS2:Hide() end
                  if Quests.Details._TitleIconHit then Quests.Details._TitleIconHit:Hide() end
                  if Quests.Details._ProgressTitleIconHit then Quests.Details._ProgressTitleIconHit:Hide() end
               end
            end

            if (WorldMapFrame:IsVisible()) then
               if rtl then
                  QuestInfoTitleHeader:SetText(QTR_ExpandUnitInfo(titleLG, false, QuestInfoTitleHeader, WOWTR_Font1, -5, "RIGHT"))
               else
                  QuestInfoTitleHeader:SetText(QTR_ExpandUnitInfo(titleLG, false, QuestInfoTitleHeader, WOWTR_Font1, -5))
               end
            else
               if rtl then
                  QuestInfoTitleHeader:SetText(QTR_ExpandUnitInfo(titleLG, false, QuestInfoTitleHeader, WOWTR_Font1, -5, "RIGHT"))
               else
                  QuestInfoTitleHeader:SetText(QTR_ExpandUnitInfo(titleLG, false, QuestInfoTitleHeader, WOWTR_Font1, -5))
               end
            end
            if rtl then
               QuestProgressTitleText:SetText(QTR_ExpandUnitInfo(titleLG, false, QuestProgressTitleText, WOWTR_Font1, -5, "RIGHT"))
            else
               QuestProgressTitleText:SetText(QTR_ExpandUnitInfo(titleLG, false, QuestProgressTitleText, WOWTR_Font1, -5))
            end
         end

         if rtl then
            QuestInfoDescriptionText:SetWidth(textW)
            QuestInfoObjectivesText:SetWidth(textW)
            QuestProgressText:SetWidth(textW)
            QuestInfoRewardText:SetWidth(textW)
            -- Also unify section header widths (e.g. "الوصف") to match the same text column width.
            enforceWidth(QuestInfoDescriptionHeader, textW)
            enforceWidth(QuestInfoObjectivesHeader, textW)
            if QuestInfoRewardsFrame and QuestInfoRewardsFrame.Header then
               enforceWidth(QuestInfoRewardsFrame.Header, textW)
            end
         else
            QuestInfoDescriptionText:SetWidth(WOW_width - 1)
            QuestInfoObjectivesText:SetWidth(WOW_width - 1)
            QuestProgressText:SetWidth(WOW_width - 1)
            QuestInfoRewardText:SetWidth(WOW_width)
         end

         local sz = C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtext.size or tonumber(QTR_PS["fontsize"])
         QuestInfoDescriptionText:SetFont(WOWTR_Font2, sz)
         QuestInfoObjectivesText:SetFont(WOWTR_Font2, sz)
         QuestProgressText:SetFont(WOWTR_Font2, sz)
         QuestInfoRewardText:SetFont(WOWTR_Font2, sz)
         
         if WOWTR and WOWTR.Debug then
           WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: About to set quest text...")
           WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QTR_quest_LG[numer_ID].details:", QTR_quest_LG[numer_ID] and QTR_quest_LG[numer_ID].details and string.len(QTR_quest_LG[numer_ID].details) or "nil", "chars")
           WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QTR_quest_LG[numer_ID].objectives:", QTR_quest_LG[numer_ID] and QTR_quest_LG[numer_ID].objectives and string.len(QTR_quest_LG[numer_ID].objectives) or "nil", "chars")
           WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoDescriptionText exists:", QuestInfoDescriptionText ~= nil)
           WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoObjectivesText exists:", QuestInfoObjectivesText ~= nil)
         end
         
         -- Check which panels are visible
         if QuestFrame then
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestFrame visible:", QuestFrame:IsVisible())
              if QuestFrame.DetailPanel then
                WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestFrame.DetailPanel visible:", QuestFrame.DetailPanel:IsVisible())
              end
              if QuestFrame.ProgressPanel then
                WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestFrame.ProgressPanel visible:", QuestFrame.ProgressPanel:IsVisible())
              end
              if QuestFrame.RewardPanel then
                WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestFrame.RewardPanel visible:", QuestFrame.RewardPanel:IsVisible())
              end
            else
              WOWTR.DebugPrint("TranslateOn: QuestFrame visible:", QuestFrame:IsVisible())
              if QuestFrame.DetailPanel then
                WOWTR.DebugPrint("TranslateOn: QuestFrame.DetailPanel visible:", QuestFrame.DetailPanel:IsVisible())
              end
              if QuestFrame.ProgressPanel then
                WOWTR.DebugPrint("TranslateOn: QuestFrame.ProgressPanel visible:", QuestFrame.ProgressPanel:IsVisible())
              end
              if QuestFrame.RewardPanel then
                WOWTR.DebugPrint("TranslateOn: QuestFrame.RewardPanel visible:", QuestFrame.RewardPanel:IsVisible())
              end
            end
         end
         
         -- Check if text fields are visible and show them if needed
         if QuestInfoDescriptionText then
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoDescriptionText visible:", QuestInfoDescriptionText:IsVisible())
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoDescriptionText parent visible:", QuestInfoDescriptionText:GetParent() and QuestInfoDescriptionText:GetParent():IsVisible())
            else
              WOWTR.DebugPrint("TranslateOn: QuestInfoDescriptionText visible:", QuestInfoDescriptionText:IsVisible())
              WOWTR.DebugPrint("TranslateOn: QuestInfoDescriptionText parent visible:", QuestInfoDescriptionText:GetParent() and QuestInfoDescriptionText:GetParent():IsVisible())
            end
            local currentText = QuestInfoDescriptionText:GetText()
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoDescriptionText current text length:", currentText and string.len(currentText) or 0)
            else
              WOWTR.DebugPrint("TranslateOn: QuestInfoDescriptionText current text length:", currentText and string.len(currentText) or 0)
            end
            
            -- If text field is hidden, try to show it and its parent
            if not QuestInfoDescriptionText:IsVisible() then
               if WOWTR and WOWTR.Debug then
                 WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoDescriptionText is hidden, attempting to show...")
               else
                 WOWTR.DebugPrint("TranslateOn: QuestInfoDescriptionText is hidden, attempting to show...")
               end
               if QuestInfoDescriptionText.Show then QuestInfoDescriptionText:Show() end
               local parent = QuestInfoDescriptionText:GetParent()
               if parent and parent.Show and not parent:IsVisible() then
                  parent:Show()
                  if WOWTR and WOWTR.Debug then
                    WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Showed parent of QuestInfoDescriptionText")
                  else
                    WOWTR.DebugPrint("TranslateOn: Showed parent of QuestInfoDescriptionText")
                  end
               end
               -- Try showing DetailPanel if it exists
               if QuestFrame and QuestFrame.DetailPanel and QuestFrame.DetailPanel.Show then
                  QuestFrame.DetailPanel:Show()
                  if WOWTR and WOWTR.Debug then
                    WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Showed QuestFrame.DetailPanel")
                  else
                    WOWTR.DebugPrint("TranslateOn: Showed QuestFrame.DetailPanel")
                  end
               end
            end
         end
         if QuestInfoObjectivesText then
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoObjectivesText visible:", QuestInfoObjectivesText:IsVisible())
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoObjectivesText parent visible:", QuestInfoObjectivesText:GetParent() and QuestInfoObjectivesText:GetParent():IsVisible())
            else
              WOWTR.DebugPrint("TranslateOn: QuestInfoObjectivesText visible:", QuestInfoObjectivesText:IsVisible())
              WOWTR.DebugPrint("TranslateOn: QuestInfoObjectivesText parent visible:", QuestInfoObjectivesText:GetParent() and QuestInfoObjectivesText:GetParent():IsVisible())
            end
            local currentText = QuestInfoObjectivesText:GetText()
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoObjectivesText current text length:", currentText and string.len(currentText) or 0)
            else
              WOWTR.DebugPrint("TranslateOn: QuestInfoObjectivesText current text length:", currentText and string.len(currentText) or 0)
            end
            
            -- If text field is hidden, try to show it
            if not QuestInfoObjectivesText:IsVisible() then
               if WOWTR and WOWTR.Debug then
                 WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoObjectivesText is hidden, attempting to show...")
               else
                 WOWTR.DebugPrint("TranslateOn: QuestInfoObjectivesText is hidden, attempting to show...")
               end
               if QuestInfoObjectivesText.Show then QuestInfoObjectivesText:Show() end
               local parent = QuestInfoObjectivesText:GetParent()
               if parent and parent.Show and not parent:IsVisible() then
                  parent:Show()
                  if WOWTR and WOWTR.Debug then
                    WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Showed parent of QuestInfoObjectivesText")
                  else
                    WOWTR.DebugPrint("TranslateOn: Showed parent of QuestInfoObjectivesText")
                  end
               end
            end
         end
         
         -- Set the text immediately (Blizzard should have finished by now)
         -- Ensure text fields are visible before setting text
         if QuestInfoDescriptionText and not QuestInfoDescriptionText:IsVisible() then
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoDescriptionText is hidden, showing it...")
            else
              WOWTR.DebugPrint("TranslateOn: QuestInfoDescriptionText is hidden, showing it...")
            end
            if QuestInfoDescriptionText.Show then QuestInfoDescriptionText:Show() end
            local parent = QuestInfoDescriptionText:GetParent()
            if parent and parent.Show then parent:Show() end
            -- Try showing DetailPanel if it exists
            if QuestFrame and QuestFrame.DetailPanel and QuestFrame.DetailPanel.Show then
               QuestFrame.DetailPanel:Show()
            end
         end
         if QuestInfoObjectivesText and not QuestInfoObjectivesText:IsVisible() then
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: QuestInfoObjectivesText is hidden, showing it...")
            else
              WOWTR.DebugPrint("TranslateOn: QuestInfoObjectivesText is hidden, showing it...")
            end
            if QuestInfoObjectivesText.Show then QuestInfoObjectivesText:Show() end
            local parent = QuestInfoObjectivesText:GetParent()
            if parent and parent.Show then parent:Show() end
         end
         
         if QuestInfoDescriptionText and QTR_quest_LG[QTR_quest_ID] and QTR_quest_LG[QTR_quest_ID].details then
            QuestInfoDescriptionText:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].details, false, QuestInfoDescriptionText, WOWTR_Font2, -5))
            if rtl then QuestInfoDescriptionText:SetJustifyH("RIGHT") else QuestInfoDescriptionText:SetJustifyH("LEFT") end
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Description text set")
            else
              WOWTR.DebugPrint("TranslateOn: Description text set")
            end
         end
         if QuestInfoObjectivesText and QTR_quest_LG[QTR_quest_ID] and QTR_quest_LG[QTR_quest_ID].objectives then
            QuestInfoObjectivesText:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].objectives,true,QuestInfoObjectivesText,WOWTR_Font2,-5))
            if rtl then QuestInfoObjectivesText:SetJustifyH("RIGHT") else QuestInfoObjectivesText:SetJustifyH("LEFT") end
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Objectives text set")
            else
              WOWTR.DebugPrint("TranslateOn: Objectives text set")
            end
         end
         if QuestProgressText and QTR_quest_LG[QTR_quest_ID] and QTR_quest_LG[QTR_quest_ID].progress then
            QuestProgressText:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].progress,false,QuestProgressText,WOWTR_Font2,-5))
            if rtl then QuestProgressText:SetJustifyH("RIGHT") else QuestProgressText:SetJustifyH("LEFT") end
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Progress text set")
            else
              WOWTR.DebugPrint("TranslateOn: Progress text set")
            end
         end
         if QuestInfoRewardText and QTR_quest_LG[QTR_quest_ID] and QTR_quest_LG[QTR_quest_ID].completion then
            if rtl then
               QuestInfoRewardText:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].completion,false,QuestInfoRewardText,WOWTR_Font2,-5,"RIGHT"))
            else
               QuestInfoRewardText:SetText(QTR_ExpandUnitInfo(QTR_quest_LG[QTR_quest_ID].completion,false,QuestInfoRewardText,WOWTR_Font2,-5))
            end
            if WOWTR and WOWTR.Debug then
              WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: Reward text set")
            else
              WOWTR.DebugPrint("TranslateOn: Reward text set")
            end
         end
         if WOWTR and WOWTR.Debug then
           WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "TranslateOn: All quest text set successfully")
         else
           WOWTR.DebugPrint("TranslateOn: All quest text set successfully")
         end
         
         -- Set fonts immediately (these shouldn't conflict)
         QuestInfoDescriptionText:SetFont(WOWTR_Font2, sz)
         QuestInfoObjectivesText:SetFont(WOWTR_Font2, sz)
         QuestProgressText:SetFont(WOWTR_Font2, sz)
         QuestInfoRewardText:SetFont(WOWTR_Font2, sz)
      end
      if (IsDUIQuestFrame()) then
         QTR_DUIQuestFrame(event)
         if ( QTR_PS["en_first"]=="1" ) then DUI_ON_OFF() end
      end
   else
      if (QTR_curr_trans == "1") then
         local immersionFrame = GetImmersionFrame()
         if (immersionFrame and immersionFrame.TalkBox and immersionFrame.TalkBox:IsVisible()) then
            if (not WOWTR_wait(0.2,QTR_Immersion_Static)) then end
         end
      end
   end
   if event ~= "__post__" then
      Quests.Details.SchedulePostLayoutRefresh()
   end
end

-- Display original English text
function Quests.Details.TranslateOff(typ,event)
   Quests.Details.CancelPostLayoutRefresh()
   QTR_display_constants(0)
   -- When used as a "fallback to English" (no translation available / feature disabled),
   -- we don't want to flip the user's global preference toggle.
   local keepState = (event == "__keep_state__")
   if not keepState then
     QTR_curr_trans = "0"
   end

   -- Always hide Arabic-only overlay labels created for RTL reward layout.
   if QTR_QuestDetail_ItemReceiveText then QTR_QuestDetail_ItemReceiveText:Hide() end
   if QTR_QuestReward_ItemReceiveText then QTR_QuestReward_ItemReceiveText:Hide() end
   if QTR_QuestDetail_InfoXP then QTR_QuestDetail_InfoXP:Hide() end
   if QTR_QuestReward_InfoXP then QTR_QuestReward_InfoXP:Hide() end

   -- Restore QuestMapFrame rewards labels to original English/LTR.
   -- QuestMapFrame uses pooled MapQuestInfoRewardsFrame instances which keep our previous Arabic text unless we revert it.
   local function norm(s)
     if not s then return "" end
     s = tostring(s)
     s = s:gsub("\194\160", " ") -- NBSP -> space
     s = s:gsub("%s+", " ")
     s = s:gsub("^%s+", ""):gsub("%s+$", "")
     return s
   end

   local function setEN(fs, msg, size)
     if not (fs and fs.SetText and fs.SetFont) then return end
     fs:SetText(msg)
     local _, curSize, flags = fs:GetFont()
     fs:SetFont(Original_Font2, size or curSize or 13, flags)
     if fs.SetJustifyH then fs:SetJustifyH("LEFT") end
   end

   local function restoreMapRewards()
     if not (QuestMapFrame and QuestMapFrame.IsVisible and QuestMapFrame:IsVisible()) then return end
     local df = (QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.DetailsFrame) or QuestMapFrame.DetailsFrame
     local mapRewards = (df and df.RewardsFrameContainer and df.RewardsFrameContainer.RewardsFrame) or _G.MapQuestInfoRewardsFrame
     if not mapRewards then return end

     local inv = {}
     local function addPair(en, ar)
       if not (en and ar) then return end
       inv[norm(AS_UTF8reverse(ar))] = en
     end

     -- Core reward labels
     addPair(QTR_MessOrig.itemchoose0, QTR_Messages.itemchoose0)
     addPair(QTR_MessOrig.itemchoose1, QTR_Messages.itemchoose1)
     addPair(QTR_MessOrig.itemchoose2, QTR_Messages.itemchoose2)
     addPair(QTR_MessOrig.itemchoose3, QTR_Messages.itemchoose3)
     addPair(QTR_MessOrig.itemreceiv0, QTR_Messages.itemreceiv0)
     addPair(QTR_MessOrig.itemreceiv1, QTR_Messages.itemreceiv1)
     addPair(QTR_MessOrig.itemreceiv2, QTR_Messages.itemreceiv2)
     addPair(QTR_MessOrig.itemreceiv3, QTR_Messages.itemreceiv3)
     addPair(QTR_MessOrig.experience, QTR_Messages.experience)
     -- Rewards header (prevents Arabic text being left behind with English font -> square glyphs)
     if QUEST_REWARDS and QTR_Messages and QTR_Messages.rewards then
       addPair(QUEST_REWARDS, QTR_Messages.rewards)
     end

     -- Reward subheaders
     addPair(QTR_MessOrig.reward_aura, QTR_Messages.reward_aura)
     addPair(QTR_MessOrig.reward_spell, QTR_Messages.reward_spell)
     addPair(QTR_MessOrig.reward_companion, QTR_Messages.reward_companion)
     addPair(QTR_MessOrig.reward_follower, QTR_Messages.reward_follower)
     addPair(QTR_MessOrig.reward_reputation, QTR_Messages.reward_reputation)
     addPair(QTR_MessOrig.reward_title, QTR_Messages.reward_title)
     addPair(QTR_MessOrig.reward_tradeskill, QTR_Messages.reward_tradeskill)
     addPair(QTR_MessOrig.reward_unlock, QTR_Messages.reward_unlock)
     addPair(QTR_MessOrig.reward_bonus, QTR_Messages.reward_bonus)

     -- Questline reward headers (localized strings live in WoW_Localization_*.lua via QTR_Messages.*)
     do
       local unlockAR = QTR_Messages and QTR_Messages.questline_unlocking or nil
       local endAR = QTR_Messages and QTR_Messages.questline_rewards_end or nil
       if unlockAR then
         if type(AS_UTF8reverseRS) == "function" then
           inv[norm(AS_UTF8reverseRS(unlockAR, true))] = "This quest line is part of unlocking:"
         else
           inv[norm(AS_UTF8reverse(unlockAR))] = "This quest line is part of unlocking:"
         end
       end
       if endAR then
         if type(AS_UTF8reverseRS) == "function" then
           inv[norm(AS_UTF8reverseRS(endAR, true))] = "The end of this quest line rewards:"
         else
           inv[norm(AS_UTF8reverse(endAR))] = "The end of this quest line rewards:"
         end
       end
     end

     local function walk(node)
       if not node then return end
       local ot = node.GetObjectType and node:GetObjectType() or nil
       if ot == "FontString" and node.GetText and node.SetFont then
         local t = node:GetText()
         if t and t ~= "" then
           local nt = norm(t)
           local en = inv[nt]
           if en then
             setEN(node, en)
           elseif ContainsArabic(t) then
             -- Best effort: if we couldn't map the Arabic string back to EN, do NOT force the Latin font
             -- (that produces square glyphs). Keep an Arabic-capable font instead.
             local _, curSize, flags = node:GetFont()
             node:SetFont(WOWTR_Font2 or Original_Font2, curSize or 13, flags)
             if node.SetJustifyH then node:SetJustifyH("LEFT") end
           end
         end
       end
       if node.GetRegions then
         local regions = { node:GetRegions() }
         for i = 1, #regions do walk(regions[i]) end
       end
       if node.GetChildren then
         local children = { node:GetChildren() }
         for i = 1, #children do walk(children[i]) end
       end
     end

     walk(mapRewards)

     -- Restore the main Rewards header if it was translated.
     if mapRewards.Header and mapRewards.Header.GetText then
       local ht = mapRewards.Header:GetText()
       if ht and ContainsArabic(ht) and QUEST_REWARDS then
         setEN(mapRewards.Header, QUEST_REWARDS, 18)
       end
     end
   end

   restoreMapRewards()

   if (QuestNPCModelText:IsVisible() and (QTR_ModelTextHash>0)) then
      QuestNPCModelText:SetText(QTR_ModelText_EN)
      QuestNPCModelText:SetFont(Original_Font2, 13)
      if QuestNPCModelText.SetJustifyH then QuestNPCModelText:SetJustifyH("LEFT") end
   end

   -- Hide any Arabic-only quest title icon overlay we add in TranslateOn().
   if Quests and Quests.Details then
     if Quests.Details._TitleIconFS then Quests.Details._TitleIconFS:Hide() end
     if Quests.Details._ProgressTitleIconFS then Quests.Details._ProgressTitleIconFS:Hide() end
     if Quests.Details._TitleIconHit then Quests.Details._TitleIconHit:Hide() end
     if Quests.Details._ProgressTitleIconHit then Quests.Details._ProgressTitleIconHit:Hide() end
   end

   -- Restore original anchor points for any FontStrings we tightened for RTL "perfect width".
   do
     local orig = Quests and Quests.Details and Quests.Details._OrigPoints
     if orig then
       local function restore(fs)
         local pts = fs and orig[fs]
         if pts and fs and fs.ClearAllPoints and fs.SetPoint then
           fs:ClearAllPoints()
           for i = 1, #pts do
             fs:SetPoint(unpack(pts[i]))
           end
         end
       end
       restore(QuestInfoTitleHeader)
       restore(QuestProgressTitleText)
       restore(QuestInfoDescriptionHeader)
       restore(QuestInfoObjectivesHeader)
       if QuestInfoRewardsFrame and QuestInfoRewardsFrame.Header then
         restore(QuestInfoRewardsFrame.Header)
       end
     end
   end
   if (typ==1) then
      local numer_ID = QTR_quest_ID
      str_ID = tostring(numer_ID)

      -- Always restore LTR layout + original header labels, even if the quest has no translation data.
      -- This prevents mixed UI states like Arabic "الوصف" and RTL alignment on English-only quests.
      do
         local WOW_width = 280
         if QuestInfoRewardsFrame and QuestInfoRewardsFrame.IsVisible and QuestInfoRewardsFrame:IsVisible() then
            WOW_width = 280
         end
         local titleSize = C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtitle.size or 18
         local bodySize = C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtext.size or tonumber(QTR_PS["fontsize"])

         if QuestInfoDescriptionHeader then
           QuestInfoDescriptionHeader:SetWidth(WOW_width + 40)
           QuestInfoDescriptionHeader:SetFont(Original_Font1, titleSize)
           QuestInfoDescriptionHeader:SetText(QTR_MessOrig.details)
           QuestInfoDescriptionHeader:SetJustifyH("LEFT")
         end
         if QuestInfoObjectivesHeader then
           QuestInfoObjectivesHeader:SetWidth(WOW_width + 10)
           QuestInfoObjectivesHeader:SetFont(Original_Font1, titleSize)
           QuestInfoObjectivesHeader:SetText(QTR_MessOrig.objectives)
           QuestInfoObjectivesHeader:SetJustifyH("LEFT")
         end
         if QuestInfoRewardsFrame and QuestInfoRewardsFrame.Header then
           QuestInfoRewardsFrame.Header:SetWidth(WOW_width + 10)
           QuestInfoRewardsFrame.Header:SetFont(Original_Font1, titleSize)
           QuestInfoRewardsFrame.Header:SetText(QTR_MessOrig.rewards)
           QuestInfoRewardsFrame.Header:SetJustifyH("LEFT")
         end

         if QuestInfoDescriptionText then
           QuestInfoDescriptionText:SetJustifyH("LEFT")
           if QuestInfoDescriptionText.SetFont then QuestInfoDescriptionText:SetFont(Original_Font2, bodySize) end
         end
         if QuestInfoObjectivesText then
           QuestInfoObjectivesText:SetJustifyH("LEFT")
           if QuestInfoObjectivesText.SetFont then QuestInfoObjectivesText:SetFont(Original_Font2, bodySize) end
         end
         if QuestProgressText then
           QuestProgressText:SetJustifyH("LEFT")
           if QuestProgressText.SetFont then QuestProgressText:SetFont(Original_Font2, bodySize) end
         end
         if QuestInfoRewardText then
           QuestInfoRewardText:SetJustifyH("LEFT")
           if QuestInfoRewardText.SetFont then QuestInfoRewardText:SetFont(Original_Font2, bodySize) end
         end
         if QuestInfoTitleHeader then QuestInfoTitleHeader:SetJustifyH("LEFT") end
         if QuestProgressTitleText then QuestProgressTitleText:SetJustifyH("LEFT") end
      end

      if (numer_ID>0 and QTR_QuestData[str_ID]) then
         QTR_ToggleButton0:SetText("QID="..QTR_quest_ID.." (EN)")
         QTR_ToggleButton1:SetText("QID="..QTR_quest_ID.." (EN)")
         QTR_ToggleButton2:SetText("QID="..QTR_quest_ID.." (EN)")
         if (isClassicQuestLog()) then QTR_ToggleButton3:SetText("QID="..QTR_quest_ID.." (EN)") end
         if (isImmersion()) then
            QTR_ToggleButton4:SetText("QID="..QTR_quest_ID.." (EN)")
            QTR_Immersion_OFF()
            local immersionFrame = GetImmersionFrame()
            if immersionFrame and immersionFrame.TalkBox and immersionFrame.TalkBox.TextFrame and immersionFrame.TalkBox.TextFrame.Text and immersionFrame.TalkBox.TextFrame.Text.RepeatTexts then
              immersionFrame.TalkBox.TextFrame.Text:RepeatTexts()
            end
         end
         local storylineFrame = GetStorylineFrame()
         if (isStoryline() and storylineFrame and storylineFrame:IsVisible()) then
            QTR_ToggleButton5:SetText("QID="..QTR_quest_ID.." (EN)")
            QTR_Storyline_OFF(1)
         end
         local WOW_width = 280
         if (QuestInfoRewardsFrame:IsVisible()) then WOW_width = 280 end
         if QuestInfoDescriptionHeader then
           QuestInfoDescriptionHeader:SetWidth(WOW_width + 40)
           QuestInfoDescriptionHeader:SetFont(Original_Font1, 18)
           QuestInfoDescriptionHeader:SetText(QTR_MessOrig.details)
           QuestInfoDescriptionHeader:SetJustifyH("LEFT")
         end
         if QuestInfoObjectivesHeader then
           QuestInfoObjectivesHeader:SetWidth(WOW_width + 10)
           QuestInfoObjectivesHeader:SetFont(Original_Font1, 18)
           QuestInfoObjectivesHeader:SetText(QTR_MessOrig.objectives)
           QuestInfoObjectivesHeader:SetJustifyH("LEFT")
         end
         if QuestInfoRewardsFrame and QuestInfoRewardsFrame.Header then
           QuestInfoRewardsFrame.Header:SetWidth(WOW_width + 10)
           QuestInfoRewardsFrame.Header:SetFont(Original_Font1, 18)
           QuestInfoRewardsFrame.Header:SetText(QTR_MessOrig.rewards)
           QuestInfoRewardsFrame.Header:SetJustifyH("LEFT")
         end
         QuestInfoTitleHeader:SetFont(Original_Font1, C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtitle.size or 18)
         QuestProgressTitleText:SetFont(Original_Font1, C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtitle.size or 18)
         QuestInfoTitleHeader:SetText(QTR_quest_EN[QTR_quest_ID].title)
         QuestProgressTitleText:SetText(QTR_quest_EN[QTR_quest_ID].title)
         QuestInfoDescriptionText:SetWidth(WOW_width - 1)
         QuestInfoObjectivesText:SetWidth(WOW_width - 1)
         QuestProgressText:SetWidth(WOW_width - 1)
         QuestInfoRewardText:SetWidth(WOW_width)
         local sz = C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtext.size or tonumber(QTR_PS["fontsize"])
         QuestInfoDescriptionText:SetFont(Original_Font2, sz)
         QuestInfoObjectivesText:SetFont(Original_Font2, sz)
         QuestProgressText:SetFont(Original_Font2, sz)
         QuestInfoRewardText:SetFont(Original_Font2, sz)
         QuestInfoDescriptionText:SetText(QTR_quest_EN[QTR_quest_ID].details)
         QuestInfoObjectivesText:SetText(QTR_quest_EN[QTR_quest_ID].objectives)
         QuestProgressText:SetText(QTR_quest_EN[QTR_quest_ID].progress)
         QuestInfoRewardText:SetText(QTR_quest_EN[QTR_quest_ID].completion)
         QuestInfoDescriptionText:SetJustifyH("LEFT")
         QuestInfoObjectivesText:SetJustifyH("LEFT")
         QuestProgressText:SetJustifyH("LEFT")
         QuestInfoRewardText:SetJustifyH("LEFT")
         QuestInfoTitleHeader:SetJustifyH("LEFT")
         QuestProgressTitleText:SetJustifyH("LEFT")
         QuestInfoXPFrame.ReceiveText:SetText(EXPERIENCE_COLON)
         QuestInfoXPFrame.ReceiveText:SetFont(Original_Font2, 13)
         QuestInfoXPFrame.ReceiveText:SetJustifyH("LEFT")
         QuestInfoRewardsFrame.ItemChooseText:SetText(QTR_quest_EN[QTR_quest_ID].itemchoose)
         QuestInfoRewardsFrame.ItemReceiveText:SetText(QTR_quest_EN[QTR_quest_ID].itemreceive)
         QuestInfoRewardsFrame.ItemChooseText:SetFont(Original_Font2, 13)
         QuestInfoRewardsFrame.ItemReceiveText:SetFont(Original_Font2, 13)
         QuestInfoRewardsFrame.ItemChooseText:SetJustifyH("LEFT")
         QuestInfoRewardsFrame.ItemReceiveText:SetJustifyH("LEFT")
         if QTR_QuestDetail_ItemReceiveText then QTR_QuestDetail_ItemReceiveText:Hide() end
         if QTR_QuestReward_ItemReceiveText then QTR_QuestReward_ItemReceiveText:Hide() end
         if QTR_QuestDetail_InfoXP then QTR_QuestDetail_InfoXP:Hide() end
         if QTR_QuestReward_InfoXP then QTR_QuestReward_InfoXP:Hide() end

         local rewardHeaders = {
            REWARD_CHOICES = "ItemChooseText",
            REWARD_ITEMS = "ItemReceiveText",
            REWARD_AURA = "rewardAura",
            REWARD_SPELL = "rewardSpell",
            REWARD_COMPANION = "rewardCompanion",
            REWARD_FOLLOWER = "rewardFollower",
            REWARD_REPUTATION = "rewardReputation",
            REWARD_TITLE = "rewardTitle",
            REWARD_TRADESKILL = "rewardTradeskill",
            REWARD_UNLOCK = "rewardUnlock",
            REWARD_BONUS = "rewardBonus"
         }
         for constant, property in pairs(rewardHeaders) do
            if QuestInfoRewardsFrame[property] then
               QuestInfoRewardsFrame[property]:SetText(_G[constant])
               QuestInfoRewardsFrame[property]:SetFont(Original_Font2, 13)
               QuestInfoRewardsFrame[property]:SetJustifyH("LEFT")
            end
         end
         for fontString in QuestInfoRewardsFrame.spellHeaderPool:EnumerateActive() do
            for constant, _ in pairs(rewardHeaders) do
               if fontString:GetText() == QTR_Messages[string.lower(constant)] then
                  fontString:SetText(_G[constant])
                  fontString:SetFont(Original_Font2, 13)
                  fontString:SetJustifyH("LEFT")
               end
            end
         end
      end
   else
      if (QTR_curr_trans == "0") then
         if ((ImmersionFrame ~= nil ) and (ImmersionFrame.TalkBox:IsVisible() )) then
            if (not WOWTR_wait(0.2,QTR_Immersion_OFF_Static)) then end
         end
      end
   end
end

-- Back-compat global wrappers to ensure monolith calls delegate to module
function QTR_Translate_On(typ, event) return Quests.Details.TranslateOn(typ, event) end
function QTR_Translate_Off(typ, event) return Quests.Details.TranslateOff(typ, event) end
function QTR_display_constants(lg) return Quests.Details.DisplayConstants(lg) end
function QTR_QuestPrepare(event) return Quests.Details.QuestPrepare(event) end
function QTR_PrepareReload() return Quests.Details.QuestPrepare() end

-- Prepare quest data and switch translated view on
function Quests.Details.QuestPrepare(event)
  local startTime = GetTime()
  if WOWTR and WOWTR.Debug then
    WOWTR.Debug.Enter("QuestPrepare", WOWTR.Debug.Categories.QUESTS, "Event:", event or "nil", "| Time:", startTime)
  end
  QTR_PrepareTime = time()
  if QTR_IconAI then QTR_IconAI:Hide() end
  if GoQ_IconAI then GoQ_IconAI:Hide() end

  local q_ID = Quests.GetQuestID and Quests.GetQuestID() or 0
  if WOWTR and WOWTR.Debug then
    WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Quest ID:", q_ID, "| Active frames:", 
      (QuestFrame and QuestFrame:IsVisible() and "QuestFrame") or 
      (QuestLogPopupDetailFrame and QuestLogPopupDetailFrame:IsVisible() and "QuestLogPopup") or
      (QuestMapFrame and QuestMapFrame:IsVisible() and "QuestMapFrame") or "None")
  end
  
  -- Check if we just processed this quest (avoid double processing)
  -- But allow reprocessing if the text isn't actually translated (Blizzard might have overwritten it)
  if q_ID > 0 then
    local now = GetTime()
    if _lastProcessedQuestID == q_ID and (now - _lastProcessedQuestTime) < 0.5 then
      -- Check if text is actually translated - if not, allow reprocessing
      -- But only allow ONE reprocessing attempt to avoid infinite loops
      local isActuallyTranslated = false
      local shouldReprocess = false
      
      if QuestInfoDescriptionText and QuestInfoDescriptionText:IsVisible() then
        local currentText = QuestInfoDescriptionText:GetText() or ""
        local expectedText = QTR_quest_LG[q_ID] and QTR_quest_LG[q_ID].details or ""
        -- If we have translation data and the current text doesn't match the English text, assume it's translated
        if expectedText ~= "" and QTR_quest_EN[q_ID] and QTR_quest_EN[q_ID].details then
          local englishText = QTR_quest_EN[q_ID].details or ""
          local currentLen = string.len(currentText)
          local englishLen = string.len(englishText)
          local translatedLen = string.len(expectedText)
          
          -- If current text is different from English and similar length to translated, assume translated
          if currentText ~= englishText and math.abs(currentLen - translatedLen) < 100 then
            isActuallyTranslated = true
          -- If current text matches English length but we have translation, check if we've already tried reprocessing
          elseif currentLen == englishLen and currentText == englishText then
            -- Check if we've already attempted reprocessing for this quest
            local reprocessKey = "_reprocess_" .. q_ID
            if not _G[reprocessKey] then
              -- First time seeing English text after processing - allow one reprocessing attempt
              _G[reprocessKey] = true
              shouldReprocess = true
            else
              -- Already tried reprocessing, don't allow again (to prevent infinite loop)
              isActuallyTranslated = false -- Treat as translated to stop reprocessing
            end
          end
        end
      end
      
      if isActuallyTranslated then
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "SKIP | Quest", q_ID, "already processed | Text is translated | Time since last:", string.format("%.2f", now - _lastProcessedQuestTime), "s")
        end
        return
      elseif shouldReprocess then
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "REPROCESS | Quest", q_ID, "was processed but text appears untranslated | Allowing ONE reprocessing attempt")
        end
        -- Reset the timestamp so we can process it again, but mark that we've tried reprocessing
        _lastProcessedQuestTime = 0
      else
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "SKIP | Quest", q_ID, "already processed recently | Time since last:", string.format("%.2f", now - _lastProcessedQuestTime), "s")
        end
        return
      end
    end
    -- Mark that we're processing this quest now
    _lastProcessedQuestID = q_ID
    _lastProcessedQuestTime = now
    -- Clear reprocess flag when starting fresh processing
    local reprocessKey = "_reprocess_" .. q_ID
    _G[reprocessKey] = nil
  end
  
  if (q_ID == 0) then 
    if WOWTR and WOWTR.Debug then
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Quest ID is 0 (invalid) | Resetting quest UI to original layout")
    end
    -- Avoid leaving Arabic headers/RTL from the previous quest when the current details view has no questID (e.g. recap panels).
    local prevID = QTR_quest_ID
    QTR_quest_ID = 0
    if Quests and Quests.Details and Quests.Details.TranslateOff then
      Quests.Details.TranslateOff(1, "__keep_state__")
    end
    QTR_quest_ID = prevID
    return 
  end
  
  if isClassicQuestLog and isClassicQuestLog() then
    if (QTR_PS["questlog"] == "0") then
      if QTR_ToggleButton3 then QTR_ToggleButton3:Hide() end
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "SKIP | Classic quest log disabled")
      end
      return
    else
      if QTR_ToggleButton3 then QTR_ToggleButton3:Show() end
      local classicQuestLogFrame = GetClassicQuestLogFrame()
      if (classicQuestLogFrame and classicQuestLogFrame:IsVisible() and (QTR_curr_trans == "0")) then
        QTR_Translate_Off(1)
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "SKIP | Classic quest log | Translate off | QTR_curr_trans:", QTR_curr_trans)
        end
        return
      end
    end
  end
  if isImmersion and isImmersion() then
    local immersionContentFrame = GetImmersionContentFrame()
    if (immersionContentFrame and immersionContentFrame:IsVisible() and (QTR_curr_trans == "0")) then
      QTR_Translate_Off(1)
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "SKIP | Immersion frame | Translate off | QTR_curr_trans:", QTR_curr_trans)
      end
      return
    end
  end
  
  do
    local now = GetTime()
    local isForced = (event == "__force__")
    if (not isForced) and (_lastPrepareQuestID == q_ID and (now - (_lastPrepareAt or 0)) < 0.05) then
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "SKIP | Throttled duplicate call | Quest:", q_ID, "| Time since last:", string.format("%.3f", now - (_lastPrepareAt or 0)), "s")
      end
      return
    end
    _lastPrepareQuestID = q_ID
    _lastPrepareAt = now
  end
  QTR_quest_ID = q_ID
  local str_ID = tostring(q_ID)

  QTR_quest_EN[QTR_quest_ID] = QTR_quest_EN[QTR_quest_ID] or {}
  QTR_quest_LG[QTR_quest_ID] = QTR_quest_LG[QTR_quest_ID] or {}

  if QTR_ToggleButton0 then QTR_ToggleButton0:SetWidth(150); QTR_ToggleButton0:SetScript("OnClick", QTR_ON_OFF) end

  if WOWTR and WOWTR.Debug then
    WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Config | QTR_PS active:", QTR_PS and QTR_PS["active"], "| QTR_curr_trans:", QTR_curr_trans)
  end
  if (QTR_PS["active"] == "1") then
    if WOWTR and WOWTR.Debug then
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Processing translation for quest", q_ID, "| Event:", event or "nil")
    end
    -- Don't enable buttons yet - wait to see if translation data exists
    -- Buttons will be enabled only if translation data is found

    -- Model text capture for translation (stored to GS tables for later use)
    if (QuestNPCModelText and QuestNPCModelText:IsVisible()) then
      local text = QuestNPCModelText:GetText()
      if (text and not string.find(text, NONBREAKINGSPACE)) then
        QTR_ModelTextHash = StringHash(text)
        if GS_Gossip and GS_Gossip[QTR_ModelTextHash] then
          QTR_ModelText_EN = text
          QTR_ModelText_PL = GS_Gossip[QTR_ModelTextHash]
        else
          local map = C_Map.GetBestMapForUnit and (C_Map.GetBestMapForUnit("player") or 0) or 0
          local npcName = (QuestNPCModelNameText and QuestNPCModelNameText:GetText()) or "Unknown Monster"
          QTR_GOSSIP[npcName.."@"..tostring(QTR_ModelTextHash).."@"..tostring(map)] = text.."@"..WOWTR_player_name..":"..WOWTR_player_race..":"..WOWTR_player_class
          QTR_ModelTextHash = 0
        end
      end
    end

    QTR_curr_trans = QTR_curr_trans or "1"
    QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_MessOrig.itemchoose0
    QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv0

    if WOWTR and WOWTR.Debug then
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Translation data check | QTR_QuestData:", QTR_QuestData ~= nil, "| Quest ID:", str_ID, "| Has data:", QTR_QuestData and QTR_QuestData[str_ID] ~= nil)
    end
    
    if (QTR_QuestData and QTR_QuestData[str_ID]) then
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "[OK] Translation data FOUND for quest", str_ID, "| Loading translation...")
      end
      -- Determine whether the quest has REAL localized (Arabic) strings.
      -- Some quest IDs exist in the DB but are empty/English-only; those should be treated as "no translation"
      -- to avoid mixing Arabic headers (e.g. "الوصف") with an English quest body.
      local hasRealTrans = false
      do
        local qd = QTR_QuestData[str_ID]
        if qd then
          local fields = { "Title", "Description", "Objectives", "Progress", "Completion" }
          for i = 1, #fields do
            local v = qd[fields[i]]
            if type(v) == "string" and v ~= "" and ContainsArabic(v) then
              hasRealTrans = true
              break
            end
          end
        end
      end

      do
        -- Always set LG title from DB (used for display).
        if (not QTR_quest_LG[QTR_quest_ID].title) then
          QTR_quest_LG[QTR_quest_ID].title = QTR_QuestData[str_ID]["Title"]
        end

        -- Prefer the visible header text when it contains Blizzard "decorations" (repeatable icon links, textures, etc.).
        -- `GetTitleText()` often returns the plain title without those prefixes.
        local apiTitle = (GetTitleText and GetTitleText()) or ""
        local headerTitle = (QuestInfoTitleHeader and QuestInfoTitleHeader.GetText and QuestInfoTitleHeader:GetText()) or ""
        local chosen = apiTitle
        if headerTitle ~= "" and (not ContainsArabic(headerTitle)) then
          if headerTitle ~= apiTitle then
            chosen = headerTitle
          end
        end
        if chosen == "" then chosen = headerTitle end

        local cur = QTR_quest_EN[QTR_quest_ID].title
        if not cur or cur == "" then
          QTR_quest_EN[QTR_quest_ID].title = chosen
        else
          -- Upgrade existing cached title to the decorated version if we previously captured the plain title.
          local curHasDeco = (type(cur) == "string") and (cur:find("|H", 1, true) or cur:find("|T", 1, true) or cur:find("|A", 1, true))
          local newHasDeco = (type(chosen) == "string") and (chosen:find("|H", 1, true) or chosen:find("|T", 1, true) or chosen:find("|A", 1, true))
          if (not curHasDeco) and newHasDeco then
            QTR_quest_EN[QTR_quest_ID].title = chosen
          end
        end
      end
      if (not QTR_quest_LG[QTR_quest_ID].details) then
        QTR_quest_LG[QTR_quest_ID].details = QTR_QuestData[str_ID]["Description"]
        QTR_quest_LG[QTR_quest_ID].objectives = QTR_QuestData[str_ID]["Objectives"]
      end

      if (event == "QUEST_DETAIL") then
        if (not QTR_quest_EN[QTR_quest_ID].details) then
          QTR_quest_EN[QTR_quest_ID].details = GetQuestText()
          QTR_quest_EN[QTR_quest_ID].objectives = GetObjectiveText()
        end
        quest_numReward[str_ID] = GetNumQuestChoices()
        if (quest_numReward[str_ID] and quest_numReward[str_ID] > 1) then
          QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_MessOrig.itemchoose1
          QTR_quest_LG[QTR_quest_ID].itemchoose = QTR_Messages.itemchoose1
        else
          QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_MessOrig.itemchoose0
          QTR_quest_LG[QTR_quest_ID].itemchoose = QTR_Messages.itemchoose0
        end
        if (quest_numReward[str_ID] and quest_numReward[str_ID] > 0) then
          QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv1
          QTR_quest_LG[QTR_quest_ID].itemreceive = QTR_Messages.itemreceiv1
        else
          QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv0
          QTR_quest_LG[QTR_quest_ID].itemreceive = QTR_Messages.itemreceiv0
        end
        if (QTR_quest_EN[QTR_quest_ID].details and QTR_quest_LG[QTR_quest_ID].details == "") then
          if (QTR_PS and QTR_PS["saveQS"] == "1") then
            QTR_MISSING[QTR_quest_ID.." DESCRIPTION"] = WOWTR_DetectAndReplacePlayerName(QTR_quest_EN[QTR_quest_ID].details)
          end
        end
        if (QTR_quest_LG[QTR_quest_ID].details == "") then
          QTR_quest_LG[QTR_quest_ID].details = QTR_quest_EN[QTR_quest_ID].details
        end
        if (QTR_quest_EN[QTR_quest_ID].objectives and QTR_quest_LG[QTR_quest_ID].objectives == "") then
          if (QTR_PS and QTR_PS["saveQS"] == "1") then
            QTR_MISSING[QTR_quest_ID.." OBJECTIVE"] = WOWTR_DetectAndReplacePlayerName(QTR_quest_EN[QTR_quest_ID].objectives)
          end
        end
        if (QTR_quest_LG[QTR_quest_ID].objectives == "") then
          QTR_quest_LG[QTR_quest_ID].objectives = QTR_quest_EN[QTR_quest_ID].objectives
        end
      else
        -- Map quest panel path: when event is nil, read visible EN texts if frames are ready
        if (not QTR_quest_EN[QTR_quest_ID].details and QuestInfoDescriptionText and QuestInfoDescriptionText.GetText) then
          QTR_quest_EN[QTR_quest_ID].details = QuestInfoDescriptionText:GetText()
        end
        if (not QTR_quest_EN[QTR_quest_ID].objectives and QuestInfoObjectivesText and QuestInfoObjectivesText.GetText) then
          QTR_quest_EN[QTR_quest_ID].objectives = QuestInfoObjectivesText:GetText()
        end
        if (not quest_numReward[str_ID]) then
          QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_MessOrig.itemchoose0
          QTR_quest_LG[QTR_quest_ID].itemchoose = QTR_Messages.itemchoose0
          if (MapQuestInfoRewardsFrame and MapQuestInfoRewardsFrame.ItemChooseText and MapQuestInfoRewardsFrame.ItemChooseText:IsVisible()) then
            QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv1
            QTR_quest_LG[QTR_quest_ID].itemreceive = QTR_Messages.itemreceiv1
          else
            QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv0
            QTR_quest_LG[QTR_quest_ID].itemreceive = QTR_Messages.itemreceiv0
          end
        else
          if (quest_numReward[str_ID] > 1) then
            QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_MessOrig.itemchoose1
            QTR_quest_LG[QTR_quest_ID].itemchoose = QTR_Messages.itemchoose1
          else
            QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_MessOrig.itemchoose0
            QTR_quest_LG[QTR_quest_ID].itemchoose = QTR_Messages.itemchoose0
          end
          if (quest_numReward[str_ID] > 0) then
            QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv1
            QTR_quest_LG[QTR_quest_ID].itemreceive = QTR_Messages.itemreceiv1
          else
            QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv0
            QTR_quest_LG[QTR_quest_ID].itemreceive = QTR_Messages.itemreceiv0
          end
        end
      end

      if (event == "QUEST_PROGRESS") then
        if (not QTR_quest_EN[QTR_quest_ID].progress) then
          QTR_quest_EN[QTR_quest_ID].progress = GetProgressText()
          QTR_quest_LG[QTR_quest_ID].progress = QTR_QuestData[str_ID]["Progress"]
        end
        if (QTR_quest_EN[QTR_quest_ID].progress and QTR_quest_LG[QTR_quest_ID].progress == "") then
          if (QTR_PS and QTR_PS["saveQS"] == "1") then
            QTR_MISSING[QTR_quest_ID.." PROGRESS"] = WOWTR_DetectAndReplacePlayerName(QTR_quest_EN[QTR_quest_ID].progress)
          end
        end
        if (QTR_quest_LG[QTR_quest_ID].progress == "") then
          QTR_quest_LG[QTR_quest_ID].progress = QTR_quest_EN[QTR_quest_ID].progress
        end
      end
      if (event == "QUEST_COMPLETE") then
        if (not QTR_quest_EN[QTR_quest_ID].completion) then
          QTR_quest_EN[QTR_quest_ID].completion = GetRewardText()
          QTR_quest_LG[QTR_quest_ID].completion = QTR_QuestData[str_ID]["Completion"]
        end
        if (not quest_numReward[str_ID]) then quest_numReward[str_ID] = GetNumQuestChoices() end
        if (quest_numReward[str_ID] > 1) then
          QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_MessOrig.itemchoose2
          QTR_quest_LG[QTR_quest_ID].itemchoose = QTR_Messages.itemchoose2
        else
          QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_MessOrig.itemchoose3
          QTR_quest_LG[QTR_quest_ID].itemchoose = QTR_Messages.itemchoose3
        end
        if (quest_numReward[str_ID] > 0) then
          QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv3
          QTR_quest_LG[QTR_quest_ID].itemreceive = QTR_Messages.itemreceiv3
        else
          QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_MessOrig.itemreceiv2
          QTR_quest_LG[QTR_quest_ID].itemreceive = QTR_Messages.itemreceiv2
        end
        if (QTR_quest_EN[QTR_quest_ID].completion and QTR_quest_LG[QTR_quest_ID].completion == "") then
          if (QTR_PS and QTR_PS["saveQS"] == "1") then
            QTR_MISSING[QTR_quest_ID.." COMPLETE"] = WOWTR_DetectAndReplacePlayerName(QTR_quest_EN[QTR_quest_ID].completion)
          end
        end
        if (QTR_quest_LG[QTR_quest_ID].completion == "") then
          QTR_quest_LG[QTR_quest_ID].completion = QTR_quest_EN[QTR_quest_ID].completion
        end
      end

      if QTR_ToggleButton0 then QTR_ToggleButton0:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")") end
      if QTR_ToggleButton1 then QTR_ToggleButton1:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")") end
      if QTR_ToggleButton2 then QTR_ToggleButton2:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")") end
      if (isImmersion and isImmersion() and QTR_ToggleButton4) then QTR_ToggleButton4:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")") end
      do
        local storylineFrame = GetStorylineFrame()
        if (isStoryline and isStoryline() and storylineFrame and storylineFrame:IsVisible() and QTR_ToggleButton5) then QTR_ToggleButton5:SetText("QID="..QTR_quest_ID.." ("..QTR_lang..")") end
      end

      -- Determine if we actually have localized (Arabic) quest text; if not, keep EN view.
      local hasTrans = hasRealTrans
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Translation check | hasTrans:", hasTrans, "| QTR_curr_trans:", QTR_curr_trans,
          "| HasArabic:", hasRealTrans and "YES" or "NO",
          "| Details:", (QTR_quest_LG[q_ID] and QTR_quest_LG[q_ID].details and string.len(QTR_quest_LG[q_ID].details) or 0) .. " chars",
          "| Objectives:", (QTR_quest_LG[q_ID] and QTR_quest_LG[q_ID].objectives and string.len(QTR_quest_LG[q_ID].objectives) or 0) .. " chars")
      end
      
      -- Enable toggle buttons only if we have translation data
      if hasTrans then
        if QTR_ToggleButton0 then QTR_ToggleButton0:Enable() end
        if QTR_ToggleButton1 then QTR_ToggleButton1:Enable() end
        if QTR_ToggleButton2 then QTR_ToggleButton2:Enable() end
        if isImmersion and isImmersion() and QTR_ToggleButton4 then QTR_ToggleButton4:Enable() end
        if isStoryline and isStoryline() and QTR_ToggleButton5 then QTR_ToggleButton5:Enable() end
        if IsDUIQuestFrame and IsDUIQuestFrame() and QTR_ToggleButton7 then QTR_ToggleButton7:Enable() end
      else
        -- No translation available, disable buttons
        if QTR_ToggleButton0 then QTR_ToggleButton0:Disable() end
        if QTR_ToggleButton1 then QTR_ToggleButton1:Disable() end
        if QTR_ToggleButton2 then QTR_ToggleButton2:Disable() end
        if isImmersion and isImmersion() and QTR_ToggleButton4 then QTR_ToggleButton4:Disable() end
        if isStoryline and isStoryline() and QTR_ToggleButton5 then QTR_ToggleButton5:Disable() end
        if IsDUIQuestFrame and IsDUIQuestFrame() and QTR_ToggleButton7 then QTR_ToggleButton7:Disable() end
      end
      
      if not hasTrans then
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "|cFFFF0000[X] No localized text available|r | Falling back to English | Quest:", q_ID)
        end
        if Quests and Quests.Utils and Quests.Utils.DebugPrint then
          Quests.Utils.DebugPrint("QuestPrepare: no LG text, fallback to EN", "qid=", tostring(QTR_quest_ID))
        end
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Calling QTR_Translate_Off (no translation)...")
        end
        QTR_Translate_Off(1, "__keep_state__")
        if WOWTR and WOWTR.Debug then
          WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "[OK] QTR_Translate_Off completed")
        end
      else
        -- Respect the user's current toggle state.
        -- Default is translated ("1") via `common/Quests/State.lua`, so quests will show translated
        -- immediately when translation data exists.
        if QTR_curr_trans == "1" then
          if WOWTR and WOWTR.Debug then
            WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "[OK] Has translation | Showing translated view (TranslateOn)")
          end
          QTR_Translate_On(1, event)
        else
          if WOWTR and WOWTR.Debug then
            WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "[OK] Has translation | Showing English view (TranslateOff)")
          end
          QTR_Translate_Off(1, event)
        end
      end
    else
      -- No translation data available; leave view as EN but disable toggles
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "|cFFFF0000[X] No translation data found|r | Quest:", str_ID, "| Displaying English | Saving quest data...")
      end
      -- Disable all toggle buttons since there's no translation available
      if QTR_ToggleButton0 then QTR_ToggleButton0:Disable() end
      if QTR_ToggleButton1 then QTR_ToggleButton1:Disable() end
      if QTR_ToggleButton2 then QTR_ToggleButton2:Disable() end
      if isImmersion and isImmersion() and QTR_ToggleButton4 then QTR_ToggleButton4:Disable() end
      if isStoryline and isStoryline() and QTR_ToggleButton5 then QTR_ToggleButton5:Disable() end
      if IsDUIQuestFrame and IsDUIQuestFrame() and QTR_ToggleButton7 then QTR_ToggleButton7:Disable() end
      
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "QuestPrepare: Calling QTR_Translate_Off (no data)...")
      end
      QTR_Translate_Off(1, "__keep_state__")
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "QuestPrepare: Saving quest data...")
      end
      QTR_SaveQuest(event)
      if WOWTR and WOWTR.Debug then
        WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "QuestPrepare: QTR_SaveQuest completed")
      end
    end

    if (IsDUIQuestFrame and IsDUIQuestFrame()) then
      QTR_DUIQuestFrame(event)
      if (QTR_PS["en_first"] == "1") then DUI_ON_OFF() end
    end
  else
    -- Active is OFF - still need to save quest data and display in English
    if WOWTR and WOWTR.Debug then
      WOWTR.Debug.Verbose(WOWTR.Debug.Categories.QUESTS, "Active is OFF | Processing English display | Quest:", q_ID)
    end
    -- Disable all toggle buttons
    if QTR_ToggleButton0 then QTR_ToggleButton0:Disable() end
    if QTR_ToggleButton1 then QTR_ToggleButton1:Disable() end
    if QTR_ToggleButton2 then QTR_ToggleButton2:Disable() end
    if isImmersion and isImmersion() and QTR_ToggleButton4 then QTR_ToggleButton4:Disable() end
    if isStoryline and isStoryline() and QTR_ToggleButton5 then QTR_ToggleButton5:Disable() end
    if IsDUIQuestFrame and IsDUIQuestFrame() and QTR_ToggleButton7 then QTR_ToggleButton7:Disable() end
    
    -- Capture quest text data even when active is off (needed for display)
    WOWTR.DebugPrint("QuestPrepare: Capturing quest text...")
    if (not QTR_quest_EN[QTR_quest_ID].title) then
      local apiTitle = (GetTitleText and GetTitleText()) or ""
      local headerTitle = (QuestInfoTitleHeader and QuestInfoTitleHeader.GetText and QuestInfoTitleHeader:GetText()) or ""
      local chosen = apiTitle
      if headerTitle ~= "" and (not ContainsArabic(headerTitle)) then
        if headerTitle ~= apiTitle then
          chosen = headerTitle
        end
      end
      if chosen == "" then chosen = headerTitle end
      QTR_quest_EN[QTR_quest_ID].title = chosen
      WOWTR.DebugPrint("QuestPrepare: Captured title:", QTR_quest_EN[QTR_quest_ID].title and string.len(QTR_quest_EN[QTR_quest_ID].title) or 0, "chars")
    end
    
    if (event == "QUEST_DETAIL") then
      if (not QTR_quest_EN[QTR_quest_ID].details) then
        QTR_quest_EN[QTR_quest_ID].details = GetQuestText() or ""
        QTR_quest_EN[QTR_quest_ID].objectives = GetObjectiveText() or ""
        WOWTR.DebugPrint("QuestPrepare: Captured details:", QTR_quest_EN[QTR_quest_ID].details and string.len(QTR_quest_EN[QTR_quest_ID].details) or 0, "chars")
        WOWTR.DebugPrint("QuestPrepare: Captured objectives:", QTR_quest_EN[QTR_quest_ID].objectives and string.len(QTR_quest_EN[QTR_quest_ID].objectives) or 0, "chars")
      end
    elseif QuestInfoDescriptionText and QuestInfoDescriptionText.GetText then
      -- For map quest panel or other events, read from visible frames
      if (not QTR_quest_EN[QTR_quest_ID].details) then
        QTR_quest_EN[QTR_quest_ID].details = QuestInfoDescriptionText:GetText() or ""
        WOWTR.DebugPrint("QuestPrepare: Captured details from frame:", QTR_quest_EN[QTR_quest_ID].details and string.len(QTR_quest_EN[QTR_quest_ID].details) or 0, "chars")
      end
      if (not QTR_quest_EN[QTR_quest_ID].objectives and QuestInfoObjectivesText and QuestInfoObjectivesText.GetText) then
        QTR_quest_EN[QTR_quest_ID].objectives = QuestInfoObjectivesText:GetText() or ""
        WOWTR.DebugPrint("QuestPrepare: Captured objectives from frame:", QTR_quest_EN[QTR_quest_ID].objectives and string.len(QTR_quest_EN[QTR_quest_ID].objectives) or 0, "chars")
      end
    end
    
    -- Set default item text
    QTR_quest_EN[QTR_quest_ID].itemchoose = QTR_quest_EN[QTR_quest_ID].itemchoose or QTR_MessOrig.itemchoose0
    QTR_quest_EN[QTR_quest_ID].itemreceive = QTR_quest_EN[QTR_quest_ID].itemreceive or QTR_MessOrig.itemreceiv0
    
    -- Save quest data even when active is off (so we have it if user re-enables)
    WOWTR.DebugPrint("QuestPrepare: Saving quest data...")
    QTR_SaveQuest(event)
    
    -- Ensure quest is displayed in English (not translated)
    WOWTR.DebugPrint("QuestPrepare: Calling QTR_Translate_Off...")
    if QTR_Translate_Off then
      QTR_Translate_Off(1, "__keep_state__")
      WOWTR.DebugPrint("QuestPrepare: QTR_Translate_Off completed")
    else
      WOWTR.DebugPrint("QuestPrepare: ERROR - QTR_Translate_Off is nil!")
    end
    
    -- Handle Immersion frame if visible
    if (QTR_curr_trans == "1") then
      local immersionFrame = GetImmersionFrame()
      if (immersionFrame and immersionFrame.TalkBox and immersionFrame.TalkBox:IsVisible()) then
        if (not WOWTR_wait(0.2, QTR_Immersion_Static)) then end
      end
    end
  end
  if WOWTR and WOWTR.Debug then
    WOWTR.Debug.Exit("QuestPrepare", WOWTR.Debug.Categories.QUESTS, "Quest:", q_ID, "| Event:", event or "nil", "| Duration:", string.format("%.3f", GetTime() - startTime), "s")
  end
end

-- (removed duplicate DisplayConstants; keep the full implementation below)

-- Popup quest details show handler
function QTR_QuestLogPopupShow()
  if (QuestLogPopupDetailFrame and QuestLogPopupDetailFrame:IsVisible()) then
    return Quests.Details.QuestPrepare("QUEST_DETAIL")
  end
end

-- Remove delegator stubs that would override real implementations

function Quests.Details.DisplayConstants(lg)
   local str_ID = QTR_quest_ID and tostring(QTR_quest_ID) or nil
   local questDataExists = str_ID and QTR_QuestData and QTR_QuestData[str_ID]
   local questLGData = questDataExists and QTR_quest_LG and QTR_quest_LG[QTR_quest_ID]

   -- If the current quest has NO real Arabic translation, do NOT apply Arabic headers/RTL layout.
   -- This prevents mixed UI like Arabic "الوصف" with an English quest body.
   if lg == 1 then
      local hasRealTrans = false
      do
         local qd = questDataExists and QTR_QuestData[str_ID] or nil
         if qd then
            local fields = { "Title", "Description", "Objectives", "Progress", "Completion" }
            for i = 1, #fields do
               local v = qd[fields[i]]
               if type(v) == "string" and v ~= "" and ContainsArabic(v) then
                  hasRealTrans = true
                  break
               end
            end
         end
      end
      if not hasRealTrans then
         lg = 0
      end
   end

  -- Reposition the destination map button for RTL when translation is ON
  do
    local df = QuestMapFrame and QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.DetailsFrame
    local btn = df and df.DestinationMapButton
    if btn and btn.ClearAllPoints and btn.SetPoint then
      local rtl = (lg == 1) and (Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL()) or false
      btn:ClearAllPoints()
      if rtl then
        btn:SetPoint("TOPLEFT", df, "TOPLEFT", 10, -50)
      else
        btn:SetPoint("TOPRIGHT", df, "TOPRIGHT", -10, -50)
      end
    end
  end

   if lg == 1 then
        local isArabic = (Quests.Utils and Quests.Utils.IsRTL and Quests.Utils.IsRTL()) or false
        local WOW_width = 265
        if (WorldMapFrame:IsVisible()) then WOW_width = 245 end

        local elvuiFontSize = C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI[1].db.general.fonts.questtext.enable and ElvUI[1].db.general.fonts.questtitle.size or 18

        QuestInfoObjectivesHeader:SetWidth(WOW_width+10)
        QuestInfoObjectivesHeader:SetFont(WOWTR_Font1, elvuiFontSize)
        QuestInfoObjectivesHeader:SetText(QTR_ExpandUnitInfo(QTR_Messages.objectives,false,QuestInfoObjectivesHeader,WOWTR_Font1,-10))
        if isArabic then QuestInfoObjectivesHeader:SetJustifyH("RIGHT") else QuestInfoObjectivesHeader:SetJustifyH("LEFT") end

        QuestInfoDescriptionHeader:SetWidth(WOW_width+40)
        QuestInfoDescriptionHeader:SetFont(WOWTR_Font1, elvuiFontSize)
        QuestInfoDescriptionHeader:SetText(QTR_ExpandUnitInfo(QTR_Messages.details,false,QuestInfoDescriptionHeader,WOWTR_Font1,-10))
        if isArabic then QuestInfoDescriptionHeader:SetJustifyH("RIGHT") else QuestInfoDescriptionHeader:SetJustifyH("LEFT") end

        QuestInfoRewardsFrame.Header:SetWidth(WOW_width+10)
        QuestInfoRewardsFrame.Header:SetFont(WOWTR_Font1, elvuiFontSize)
        QuestInfoRewardsFrame.Header:SetText(QTR_ExpandUnitInfo(QTR_Messages.rewards,false,QuestInfoRewardsFrame.Header,WOWTR_Font1,-12))
        if isArabic then QuestInfoRewardsFrame.Header:SetJustifyH("RIGHT") else QuestInfoRewardsFrame.Header:SetJustifyH("LEFT") end

        QuestProgressRequiredItemsText:SetWidth(WOW_width+7)
        QuestProgressRequiredItemsText:SetFont(WOWTR_Font1, elvuiFontSize)
        QuestProgressRequiredItemsText:SetText(QTR_ExpandUnitInfo(QTR_Messages.reqitems,false,QuestProgressRequiredItemsText,WOWTR_Font1,-10))
        if isArabic then QuestProgressRequiredItemsText:SetJustifyH("RIGHT") else QuestProgressRequiredItemsText:SetJustifyH("LEFT") end

        CurrentQuestsText:SetFont(WOWTR_Font1, elvuiFontSize)
        CurrentQuestsText:SetWidth(WOW_width)
        CurrentQuestsText:SetText(QTR_ExpandUnitInfo(QTR_Messages.currquests,false,CurrentQuestsText,WOWTR_Font1,-30))
        if isArabic then CurrentQuestsText:SetJustifyH("RIGHT") else CurrentQuestsText:SetJustifyH("LEFT") end

        AvailableQuestsText:SetFont(WOWTR_Font1, elvuiFontSize)
        AvailableQuestsText:SetText(QTR_ReverseIfAR(QTR_Messages.avaiquests))
        AvailableQuestsText:SetWidth(WOW_width)
        if isArabic then AvailableQuestsText:SetJustifyH("RIGHT") else AvailableQuestsText:SetJustifyH("LEFT") end

        -- Translate QuestMapFrame action buttons (Abandon / Share / Track/Untrack)
        -- These are UI strings (not quest content) and should be localized even when a quest has no translation data.
        do
          local df = (QuestMapFrame and QuestMapFrame.DetailsFrame)
            or (QuestMapFrame and QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.DetailsFrame)
          if df and isArabic and _G.ST_CheckAndReplaceTranslationTextUI then
            local btns = {
              df.AbandonButton,
              df.ShareButton,
              df.TrackButton,
              df.TrackQuestButton,
            }
            for i = 1, #btns do
              local b = btns[i]
              local fs = b and (b.Text or (b.GetFontString and b:GetFontString()))
              if fs then
                ST_CheckAndReplaceTranslationTextUI(fs, false, "QuestMapFrame")
              end
            end
          end
        end

        local rewardsFrame = QuestMapFrame.DetailsFrame.RewardsFrameContainer and QuestMapFrame.DetailsFrame.RewardsFrameContainer.RewardsFrame
        if rewardsFrame then
            local regions = { rewardsFrame:GetRegions() }
            for index = 1, #regions do
               local region = regions[index]
               if ((region:GetObjectType() == "FontString") and (region:GetText() == QUEST_REWARDS)) then
                  region:SetText(QTR_ReverseIfAR(QTR_Messages.rewards))
                  region:SetFont(WOWTR_Font1, 18)
                  if isArabic then region:SetJustifyH("RIGHT") else region:SetJustifyH("LEFT") end
               end
            end
        end

        do
            -- Always translate reward labels when Arabic is active, even if the quest itself has no translation data.
            -- This fixes missing "You will receive:" / XP labels in QuestMapFrame.
            local lgData = questLGData or (QTR_quest_LG and QTR_quest_LG[QTR_quest_ID]) or nil
            local itemChooseText = (lgData and lgData.itemchoose) or QTR_Messages.itemchoose0
            local itemReceiveText = (lgData and lgData.itemreceive) or QTR_Messages.itemreceiv0

            if isArabic then
               QuestInfoRewardsFrame.ItemChooseText:SetFont(WOWTR_Font2, 14)
               QuestInfoRewardsFrame.ItemChooseText:SetWidth(260)
               QuestInfoRewardsFrame.ItemChooseText:SetJustifyH("RIGHT")
               QuestInfoRewardsFrame.ItemChooseText:SetText(AS_UTF8reverse(itemChooseText))

               QuestInfoRewardsFrame.ItemReceiveText:SetText(" ")
               QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(" ")
               QuestInfoXPFrame.ReceiveText:SetText(" ")

               if (not QTR_QuestDetail_ItemReceiveText) then
                  QTR_QuestDetail_ItemReceiveText = QuestDetailScrollChildFrame:CreateFontString(nil, "ARTWORK")
                  QTR_QuestDetail_ItemReceiveText:SetFontObject(GameFontBlack)
                  QTR_QuestDetail_ItemReceiveText:SetJustifyH("RIGHT")
                  QTR_QuestDetail_ItemReceiveText:SetJustifyV("TOP")
                  QTR_QuestDetail_ItemReceiveText:ClearAllPoints()
                  QTR_QuestDetail_ItemReceiveText:SetPoint("TOPRIGHT", QuestInfoRewardsFrame.ItemReceiveText, "TOPLEFT", 260, 2)
                  QTR_QuestDetail_ItemReceiveText:SetFont(WOWTR_Font2, 13)
               end
               QTR_QuestDetail_ItemReceiveText:SetText(AS_UTF8reverse(itemReceiveText))
               QTR_QuestDetail_ItemReceiveText:Show()

               if (not QTR_QuestReward_ItemReceiveText) then 
                  QTR_QuestReward_ItemReceiveText = QuestRewardScrollChildFrame:CreateFontString(nil, "ARTWORK")
                  QTR_QuestReward_ItemReceiveText:SetFontObject(GameFontBlack)
                  QTR_QuestReward_ItemReceiveText:SetJustifyH("RIGHT")
                  QTR_QuestReward_ItemReceiveText:SetJustifyV("TOP")
                  QTR_QuestReward_ItemReceiveText:ClearAllPoints()
                  QTR_QuestReward_ItemReceiveText:SetPoint("TOPRIGHT", QuestInfoRewardsFrame.ItemReceiveText, "TOPLEFT", 260, 2)
                  QTR_QuestReward_ItemReceiveText:SetFont(WOWTR_Font2, 14)
               end
               QTR_QuestReward_ItemReceiveText:SetText(AS_UTF8reverse(itemReceiveText))
               QTR_QuestReward_ItemReceiveText:Show()

               if (not QTR_QuestDetail_InfoXP) then 
                  QTR_QuestDetail_InfoXP = QuestDetailScrollChildFrame:CreateFontString(nil, "ARTWORK")
                  QTR_QuestDetail_InfoXP:SetFontObject(GameFontBlack)
                  QTR_QuestDetail_InfoXP:SetJustifyH("RIGHT")
                  QTR_QuestDetail_InfoXP:SetJustifyV("TOP")
                  QTR_QuestDetail_InfoXP:ClearAllPoints()
                  QTR_QuestDetail_InfoXP:SetPoint("TOPRIGHT", QuestInfoRewardsFrame.XPFrame.ReceiveText, "TOPLEFT", 260, 2)
                  QTR_QuestDetail_InfoXP:SetFont(WOWTR_Font2, 14)
               end
               QTR_QuestDetail_InfoXP:SetText(AS_UTF8reverse(QTR_Messages.experience))
               QTR_QuestDetail_InfoXP:Show()

               if (not QTR_QuestReward_InfoXP) then 
                  QTR_QuestReward_InfoXP = QuestRewardScrollChildFrame:CreateFontString(nil, "ARTWORK")
                  QTR_QuestReward_InfoXP:SetFontObject(GameFontBlack)
                  QTR_QuestReward_InfoXP:SetJustifyH("RIGHT")
                  QTR_QuestReward_InfoXP:SetJustifyV("TOP")
                  QTR_QuestReward_InfoXP:ClearAllPoints()
                  QTR_QuestReward_InfoXP:SetPoint("TOPRIGHT", QuestInfoRewardsFrame.XPFrame.ReceiveText, "TOPLEFT", 260, 2)
                  QTR_QuestReward_InfoXP:SetFont(WOWTR_Font2, 14)
               end
               QTR_QuestReward_InfoXP:SetText(AS_UTF8reverse(QTR_Messages.experience))
               QTR_QuestReward_InfoXP:Show()

               if (QuestInfoMoneyFrame:IsVisible()) then
                  QuestInfoXPFrame.ValueText:ClearAllPoints()
                  QuestInfoXPFrame.ValueText:SetPoint("TOPRIGHT", QuestInfoMoneyFrame, "BOTTOMRIGHT", -10, 0)
               end

               local max_len = AS_UTF8len(QTR_QuestDetail_ItemReceiveText:GetText())
               local money_len = QuestInfoMoneyFrame:GetWidth()
               local spaces05 = "     "
               local spaces10 = "          "
               local spaces15 = "               "
               local spaces20 = "                    "
               if (max_len < 10) then
                  if (money_len < 70) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces20)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces20)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces20)
                  elseif (money_len < 90) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces15)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces15)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces15)
                  elseif (money_len < 110) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces10)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces10)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces10)
                  elseif (money_len < 130) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces05)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces05)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces05)
                  end
               elseif (max_len < 20) then
                  if (money_len < 70) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces15)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces15)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces15)
                  elseif (money_len < 90) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces10)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces10)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces10)
                  elseif (money_len < 110) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces05)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces05)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces05)
                  end
               elseif (max_len < 30) then
                  if (money_len < 70) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces10)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces10)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces10)
                  elseif (money_len < 90) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces05)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces05)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces05)
                  end
               elseif (max_len < 40) then
                  if (money_len < 70) then
                     QuestInfoRewardsFrame.ItemReceiveText:SetText(spaces05)
                     QuestInfoRewardsFrame.XPFrame.ReceiveText:SetText(spaces05)
                     QuestInfoXPFrame.ReceiveText:SetText(spaces05)
                  end
               end
            else
               QuestInfoRewardsFrame.ItemChooseText:SetText(itemChooseText)
               QuestInfoRewardsFrame.ItemChooseText:SetFont(WOWTR_Font2, 13)
               QuestInfoRewardsFrame.ItemChooseText:SetJustifyH("LEFT")

               QuestInfoRewardsFrame.ItemReceiveText:SetText(itemReceiveText)
               QuestInfoRewardsFrame.ItemReceiveText:SetFont(WOWTR_Font2, 13)
               QuestInfoRewardsFrame.ItemReceiveText:SetJustifyH("LEFT")

               QuestInfoXPFrame.ReceiveText:SetText(QTR_Messages.experience)
               QuestInfoXPFrame.ReceiveText:SetFont(WOWTR_Font2, 13)
               QuestInfoXPFrame.ReceiveText:SetJustifyH("LEFT")

               if QTR_QuestDetail_ItemReceiveText then QTR_QuestDetail_ItemReceiveText:Hide() end
               if QTR_QuestReward_ItemReceiveText then QTR_QuestReward_ItemReceiveText:Hide() end
               if QTR_QuestDetail_InfoXP then QTR_QuestDetail_InfoXP:Hide() end
               if QTR_QuestReward_InfoXP then QTR_QuestReward_InfoXP:Hide() end
            end

            -- QuestMapFrame uses MapQuestInfoRewardsFrame (different widget set than QuestInfoRewardsFrame).
            -- Apply the same label translations there so "You will receive" / "You will also receive" localize.
            do
              -- Prefer the active QuestMapFrame rewards frame instance (modern UI), fall back to the global if present.
              local df = (QuestMapFrame and QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.DetailsFrame)
                or (QuestMapFrame and QuestMapFrame.DetailsFrame)
              local mapRewards =
                (df and df.RewardsFrameContainer and df.RewardsFrameContainer.RewardsFrame)
                or _G.MapQuestInfoRewardsFrame
              if mapRewards and mapRewards.GetRegions then
                local function norm(s)
                  if not s then return "" end
                  -- Normalize whitespace and NBSP for robust matching.
                  s = tostring(s)
                  s = s:gsub("\194\160", " ")
                  s = s:gsub("%s+", " ")
                  s = s:gsub("^%s+", ""):gsub("%s+$", "")
                  return s
                end

                local function setLabel(fs, msg, size)
                  if not (fs and fs.SetText and fs.SetFont) then return end
                  fs:SetText(AS_UTF8reverse(msg))
                  local _, curSize, flags = fs:GetFont()
                  fs:SetFont(WOWTR_Font2, size or curSize or 13, flags)
                  if fs.SetJustifyH then fs:SetJustifyH("RIGHT") end
                  -- Ensure the FontString has enough width so RIGHT-justify is visually effective in AR.
                  if fs.SetWidth and mapRewards and mapRewards.GetWidth then
                    local w = tonumber(mapRewards:GetWidth()) or 0
                    if w > 0 then
                      -- Add safe right padding so the first Arabic glyph doesn't clip outside the rewards pane.
                      local leftPad = 0
                      if fs.GetLeft and mapRewards.GetLeft then
                        local fl = fs:GetLeft()
                        local cl = mapRewards:GetLeft()
                        if fl and cl then leftPad = math.max(0, fl - cl) end
                      end
                      local rightPad = 24
                      local target = math.floor(w - leftPad - rightPad)
                      if target > 0 then fs:SetWidth(target) end
                    else
                      fs:SetWidth(math.max(tonumber(fs:GetWidth()) or 0, 240))
                    end
                  end
                end

                local function setLabelRS(fs, msg, size)
                  -- Use RS reshaper for phrases that are not in pre-shaped (presentation-form) tables.
                  if not (fs and fs.SetText and fs.SetFont) then return end
                  if type(AS_UTF8reverseRS) == "function" then
                    fs:SetText(AS_UTF8reverseRS(msg, true))
                  else
                    fs:SetText(AS_UTF8reverse(msg))
                  end
                  local _, curSize, flags = fs:GetFont()
                  fs:SetFont(WOWTR_Font2, size or curSize or 13, flags)
                  if fs.SetJustifyH then fs:SetJustifyH("RIGHT") end
                  -- Ensure the FontString has enough width so RIGHT-justify is visually effective in AR.
                  if fs.SetWidth and mapRewards and mapRewards.GetWidth then
                    local w = tonumber(mapRewards:GetWidth()) or 0
                    if w > 0 then
                      -- Add safe right padding so the first Arabic glyph doesn't clip outside the rewards pane.
                      local leftPad = 0
                      if fs.GetLeft and mapRewards.GetLeft then
                        local fl = fs:GetLeft()
                        local cl = mapRewards:GetLeft()
                        if fl and cl then leftPad = math.max(0, fl - cl) end
                      end
                      local rightPad = 24
                      local target = math.floor(w - leftPad - rightPad)
                      if target > 0 then fs:SetWidth(target) end
                    else
                      fs:SetWidth(math.max(tonumber(fs:GetWidth()) or 0, 240))
                    end
                  end
                end

                if isArabic then
                  -- Prefer computed per-quest variants (itemchoose/itemreceive) when available
                  setLabel(mapRewards.ItemChooseText, itemChooseText, 14)
                  setLabel(mapRewards.ItemReceiveText, itemReceiveText, 13)
                  if mapRewards.XPFrame and mapRewards.XPFrame.ReceiveText then
                    setLabel(mapRewards.XPFrame.ReceiveText, QTR_Messages.experience, 13)
                  end
                end

                -- Walk the full rewards frame tree to:
                -- - Translate any remaining labels that use the English constants
                -- - Force WOWTR_Font2 + RTL on any Arabic strings (fixes "square glyphs")
                local function walk(node)
                  if not node then return end
                  local ot = node.GetObjectType and node:GetObjectType() or nil
                  if ot == "FontString" and node.GetText and node.SetFont then
                    local t = node:GetText()
                    if t and t ~= "" then
                      local nt = norm(t)
                      if nt == norm(QTR_MessOrig.itemchoose0) then setLabel(node, QTR_Messages.itemchoose0, 13)
                      elseif nt == norm(QTR_MessOrig.itemchoose1) then setLabel(node, QTR_Messages.itemchoose1, 13)
                      elseif nt == norm(QTR_MessOrig.itemchoose2) then setLabel(node, QTR_Messages.itemchoose2, 13)
                      elseif nt == norm(QTR_MessOrig.itemchoose3) then setLabel(node, QTR_Messages.itemchoose3, 13)
                      elseif nt == norm(QTR_MessOrig.itemreceiv0) then setLabel(node, QTR_Messages.itemreceiv0, 13)
                      elseif nt == norm(QTR_MessOrig.itemreceiv1) then setLabel(node, QTR_Messages.itemreceiv1, 13)
                      elseif nt == norm(QTR_MessOrig.itemreceiv2) then setLabel(node, QTR_Messages.itemreceiv2, 13)
                      elseif nt == norm(QTR_MessOrig.itemreceiv3) then setLabel(node, QTR_Messages.itemreceiv3, 13)
                      elseif nt == norm(QTR_MessOrig.experience) then setLabel(node, QTR_Messages.experience, 13)
                      elseif nt == norm(QTR_MessOrig.reward_aura) then setLabel(node, QTR_Messages.reward_aura, 13)
                      elseif nt == norm(QTR_MessOrig.reward_spell) then setLabel(node, QTR_Messages.reward_spell, 13)
                      elseif nt == norm(QTR_MessOrig.reward_companion) then setLabel(node, QTR_Messages.reward_companion, 13)
                      elseif nt == norm(QTR_MessOrig.reward_follower) then setLabel(node, QTR_Messages.reward_follower, 13)
                      elseif nt == norm(QTR_MessOrig.reward_reputation) then setLabel(node, QTR_Messages.reward_reputation, 13)
                      elseif nt == norm(QTR_MessOrig.reward_title) then setLabel(node, QTR_Messages.reward_title, 13)
                      elseif nt == norm(QTR_MessOrig.reward_tradeskill) then setLabel(node, QTR_Messages.reward_tradeskill, 13)
                      elseif nt == norm(QTR_MessOrig.reward_unlock) then setLabel(node, QTR_Messages.reward_unlock, 13)
                      elseif nt == norm(QTR_MessOrig.reward_bonus) then setLabel(node, QTR_Messages.reward_bonus, 13)
                      elseif nt == norm("This quest line is part of unlocking:") then
                        local ar = QTR_Messages and QTR_Messages.questline_unlocking or nil
                        if ar then setLabelRS(node, ar, 13) end
                      elseif nt == norm("The end of this quest line rewards:") then
                        local ar = QTR_Messages and QTR_Messages.questline_rewards_end or nil
                        if ar then setLabelRS(node, ar, 13) end
                      elseif QUEST_REWARDS and nt == norm(QUEST_REWARDS) then
                        -- Rewards header in QuestMapFrame
                        if node == mapRewards.Header then
                          setLabel(node, QTR_Messages.rewards, 18)
                          if node.SetJustifyH then node:SetJustifyH("CENTER") end
                        else
                          setLabel(node, QTR_Messages.rewards, 18)
                        end
                      elseif ContainsArabic(t) then
                        local _, curSize, flags = node:GetFont()
                        node:SetFont(WOWTR_Font2, curSize or 13, flags)
                        if node.SetJustifyH then node:SetJustifyH("RIGHT") end
                      elseif _G.ST_CheckAndReplaceTranslationTextUI then
                        -- Best-effort translation for other UI strings (e.g., questline reward label)
                        ST_CheckAndReplaceTranslationTextUI(node, false, "QuestMapRewards")
                      end
                    end
                  end
                  if node.GetRegions then
                    local regions = { node:GetRegions() }
                    for i = 1, #regions do walk(regions[i]) end
                  end
                  if node.GetChildren then
                    local children = { node:GetChildren() }
                    for i = 1, #children do walk(children[i]) end
                  end
                end
                if isArabic then
                  walk(mapRewards)
                end

                -- Ensure Arabic font is applied to ALL reward frame strings (fixes "square glyphs")
                -- and ensure RTL justification is consistent.
                if isArabic and WOWTR and WOWTR.Fonts and WOWTR.Fonts.Apply then
                  WOWTR.Fonts.Apply(mapRewards)
                end
              end
            end
        end

        for fontString in QuestInfoRewardsFrame.spellHeaderPool:EnumerateActive() do
           local txt = fontString:GetText()
           if (txt) then
              txt = string.gsub(txt, QTR_MessOrig.reward_aura, QTR_Messages.reward_aura)
              txt = string.gsub(txt, QTR_MessOrig.reward_spell, QTR_Messages.reward_spell)
              txt = string.gsub(txt, QTR_MessOrig.reward_companion, QTR_Messages.reward_companion)
              txt = string.gsub(txt, QTR_MessOrig.reward_follower, QTR_Messages.reward_follower)
              txt = string.gsub(txt, QTR_MessOrig.reward_reputation, QTR_Messages.reward_reputation)
              txt = string.gsub(txt, QTR_MessOrig.reward_title, QTR_Messages.reward_title)
              txt = string.gsub(txt, QTR_MessOrig.reward_tradeskill, QTR_Messages.reward_tradeskill)
              txt = string.gsub(txt, QTR_MessOrig.reward_unlock, QTR_Messages.reward_unlock)
              txt = string.gsub(txt, QTR_MessOrig.reward_bonus, QTR_Messages.reward_bonus)
              fontString:SetText(txt)
              fontString:SetFont(WOWTR_Font2, 13)
              if isArabic then fontString:SetJustifyH("RIGHT") else fontString:SetJustifyH("LEFT") end
           end
        end
   end
end

