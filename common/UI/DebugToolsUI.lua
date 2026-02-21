-- Debug Tools UI (floating helper panel with tabs)
-- Open with /wowardebug (no args)  or  /wowardebug toggle
-- Tab 1: Debug Settings  —  master toggle, per-category verbosity (< N >), presets
-- Tab 2: Dump Tools      —  UI dump, log-clear, /reload

WOWTR = WOWTR or {}
WOWTR.DebugToolsUI = WOWTR.DebugToolsUI or {}
local UI = WOWTR.DebugToolsUI

local RESET   = "|r"
local C_GREEN = "|cFF00FF88"
local C_RED   = "|cFFFF4444"
local C_GOLD  = "|cFFFFD700"
local C_GREY  = "|cFF666666"
local C_BLUE  = "|cFF00BFFF"

local function _debug()
  return WOWTR and WOWTR.Debug or nil
end

local function _schema()
  local d = _debug()
  return d and d.Schema or nil
end

local PRESET_LABELS = {
  ["off"]                  = "Off",
  ["minimal"]              = "Min",
  ["quest-investigation"]  = "Quest",
  ["ui-dump"]              = "UI Dump",
  ["full-trace"]           = "Full",
}

local function _buildVerbMeta()
  local s = _schema()
  local out = {}
  if s and s.VerbosityMeta then
    for level = 0, 4 do
      local m = s.VerbosityMeta[level]
      out[level + 1] = {
        level = level,
        name = (m and m.name) or tostring(level),
        color = (m and m.rgb) or { 1, 1, 1 },
      }
    end
    return out
  end
  return {
    { level = 0, name = "OFF", color = { 0.40, 0.40, 0.40 } },
    { level = 1, name = "ERR", color = { 1.00, 0.27, 0.27 } },
    { level = 2, name = "MIN", color = { 1.00, 0.67, 0.00 } },
    { level = 3, name = "INF", color = { 0.00, 1.00, 0.53 } },
    { level = 4, name = "VRB", color = { 0.60, 0.60, 1.00 } },
  }
end

local function _buildCategories()
  local s = _schema()
  local out = {}
  if s and s.CategoryOrder and s.CategoryMeta then
    for i = 1, #s.CategoryOrder do
      local key = s.CategoryOrder[i]
      local m = s.CategoryMeta[key] or {}
      local rgb = m.rgb or { 1, 1, 1 }
      out[#out + 1] = {
        key = key,
        tag = m.tag or string.upper(key),
        label = m.label or key,
        r = rgb[1], g = rgb[2], b = rgb[3],
      }
    end
    return out
  end
  return {
    { key = "quests",   tag = "QST", label = "Quests",   r = 0.30, g = 0.72, b = 1.00 },
    { key = "gossip",   tag = "GSP", label = "Gossip",   r = 1.00, g = 0.62, b = 0.78 },
    { key = "tooltips", tag = "TIP", label = "Tooltips", r = 0.73, g = 0.50, b = 1.00 },
    { key = "books",    tag = "BKS", label = "Books",    r = 1.00, g = 0.70, b = 0.28 },
    { key = "movies",   tag = "MOV", label = "Movies",   r = 0.35, g = 0.90, b = 0.35 },
    { key = "bubbles",  tag = "BBL", label = "Bubbles",  r = 0.53, g = 0.81, b = 0.92 },
    { key = "chat",     tag = "CHT", label = "Chat",     r = 1.00, g = 0.84, b = 0.00 },
    { key = "config",   tag = "CFG", label = "Config",   r = 0.87, g = 0.63, b = 0.87 },
    { key = "general",  tag = "GEN", label = "General",  r = 1.00, g = 1.00, b = 1.00 },
  }
end

local function _buildPresets()
  local d = _debug()
  local names = (d and d.GetPresetNames and d.GetPresetNames()) or { "off", "minimal", "quest-investigation", "ui-dump", "full-trace" }
  local out = {}
  for i = 1, #names do
    out[#out + 1] = { key = names[i], label = PRESET_LABELS[names[i]] or names[i] }
  end
  return out
end

local VerbMeta = _buildVerbMeta()
local Categories = _buildCategories()
local Presets = _buildPresets()

-- -------------------------------------------------------
-- Apply WOWTR_Font2 to a FontString so Unicode block glyphs
-- (█ ░) and Arabic-capable characters render correctly.
-- WOWTR_Font2 is set by AR.lua before UI.CreateFrame() is ever called.
local function _setF2(fs, size, flags)
  local path = rawget(_G, "WOWTR_Font2")
  if path and fs and fs.SetFont then
    fs:SetFont(path, size or 12, flags or "")
  end
end

-- -------------------------------------------------------
local function _msg(text)
  if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
end

local function _getCategoryLevel(key)
  local d = _debug()
  if d and d.GetCategoryLevel then
    return d.GetCategoryLevel(key)
  end
  return 3
end

local function _setCategoryLevel(key, val)
  local d = _debug()
  if d and d.SetCategoryLevel then
    d.SetCategoryLevel(key, val, true)
  end
end

-- -------------------------------------------------------
-- Frame construction
-- -------------------------------------------------------
function UI.CreateFrame()
  if UI.frame then return UI.frame end

  local f = CreateFrame("Frame", "WOWTR_DebugToolsUIFrame", UIParent, "BackdropTemplate")
  f:SetSize(440, 504)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  f:Hide()
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop",  function(self) self:StopMovingOrSizing() end)

  -- Background + border
  f:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left=11, right=12, top=12, bottom=11 },
  })
  local bg = f:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  bg:SetColorTexture(0.08, 0.08, 0.13, 0.97)

  -- Title
  local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
  title:SetPoint("TOP", f, "TOP", 0, -16)
  title:SetText(C_GOLD .. "WoWAR" .. RESET .. " Debug Tools")
  _setF2(title, 16)

  -- Close button
  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
  close:SetScript("OnClick", function() f:Hide() end)

  -- ── Status banner (below title) ──────────────────────────
  local statusBanner = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  statusBanner:SetPoint("TOP", title, "BOTTOM", 0, -6)
  statusBanner:SetWidth(400)
  statusBanner:SetJustifyH("CENTER")
  _setF2(statusBanner, 12)
  f.statusBanner = statusBanner

  -- ── Tab bar ──────────────────────────────────────────────
  -- Positioned at -82 (not -56) to clear the 2-line status banner when debug is ON.
  -- Layout: title ~-16, title height ~16px → title bottom ~-32; banner start ~-38;
  -- banner 2 lines at 12px font ≈ 28px → banner bottom ~-66; tab bar at -82 = 16px gap.
  local tabBar = CreateFrame("Frame", nil, f)
  tabBar:SetPoint("TOPLEFT",  f, "TOPLEFT",  14, -82)
  tabBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, -82)
  tabBar:SetHeight(28)

  -- Content panels
  local settingsPanel = CreateFrame("Frame", nil, f)
  settingsPanel:SetPoint("TOPLEFT",     tabBar, "BOTTOMLEFT",   0, -4)
  settingsPanel:SetPoint("BOTTOMRIGHT", f,      "BOTTOMRIGHT", -14, 14)
  f.settingsPanel = settingsPanel

  local toolsPanel = CreateFrame("Frame", nil, f)
  toolsPanel:SetPoint("TOPLEFT",     tabBar, "BOTTOMLEFT",   0, -4)
  toolsPanel:SetPoint("BOTTOMRIGHT", f,      "BOTTOMRIGHT", -14, 14)
  toolsPanel:Hide()
  f.toolsPanel = toolsPanel

  -- Tab helper
  local function MakeTab(parent, idx, text, onSelect)
    local tab = CreateFrame("Button", nil, parent)
    tab:SetSize(100, 28)
    tab:SetNormalFontObject("GameFontNormalSmall")
    tab:SetHighlightFontObject("GameFontHighlightSmall")
    tab:SetText(text)
    _setF2(tab:GetFontString(), 11)
    local bg2 = tab:CreateTexture(nil, "BACKGROUND")
    bg2:SetAllPoints()
    bg2:SetColorTexture(0.15, 0.15, 0.25, 0.9)
    tab._bg = bg2
    local hl = tab:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(0.30, 0.30, 0.50, 0.5)
    local sel = tab:CreateTexture(nil, "OVERLAY")
    sel:SetPoint("BOTTOM", tab, "BOTTOM", 0, 0)
    sel:SetSize(100, 3)
    sel:SetColorTexture(0.30, 0.85, 0.30, 1)
    sel:Hide()
    tab._sel = sel
    tab:SetScript("OnClick", function() onSelect(idx) end)
    return tab
  end

  f.tabs = {}
  local function SelectTab(idx)
    f._currentTab = idx
    for i, tab in ipairs(f.tabs) do
      if i == idx then
        tab._sel:Show()
        tab._bg:SetColorTexture(0.25, 0.25, 0.40, 1)
      else
        tab._sel:Hide()
        tab._bg:SetColorTexture(0.15, 0.15, 0.25, 0.9)
      end
    end
    settingsPanel:SetShown(idx == 1)
    toolsPanel:SetShown(idx == 2)
  end
  f._selectTab = SelectTab

  local t1 = MakeTab(tabBar, 1, "Debug Settings", SelectTab)
  t1:SetPoint("LEFT", tabBar, "LEFT", 0, 0)
  f.tabs[1] = t1

  local t2 = MakeTab(tabBar, 2, "Dump Tools", SelectTab)
  t2:SetPoint("LEFT", t1, "RIGHT", 4, 0)
  f.tabs[2] = t2

  -- ============================================================
  -- TAB 1: Debug Settings
  -- ============================================================
  local sp = settingsPanel

  -- ── Master toggle row ──────────────────────────────────
  local masterLabel = sp:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  masterLabel:SetPoint("TOPLEFT", sp, "TOPLEFT", 10, -10)
  masterLabel:SetText("Debug Mode:")
  _setF2(masterLabel, 13)

  local masterToggle = CreateFrame("CheckButton", nil, sp, "UICheckButtonTemplate")
  masterToggle:SetPoint("LEFT", masterLabel, "RIGHT", 8, 0)
  masterToggle:SetScript("OnClick", function(self)
    local checked = self:GetChecked()
    if WOWTR and WOWTR.Debug then
      WOWTR.Debug.SetEnabled(checked)
    end
    _msg(checked and (C_GREEN .. "[WoWAR]" .. RESET .. " Debug: enabled")
                  or (C_GREY  .. "[WoWAR]" .. RESET .. " Debug: disabled"))
    UI.UpdateSettings()
  end)
  f.masterToggle = masterToggle

  -- ── Preset buttons row ─────────────────────────────────
  local presetLabel = sp:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  presetLabel:SetPoint("TOPLEFT", masterLabel, "BOTTOMLEFT", 0, -16)
  presetLabel:SetText(C_GOLD .. "Preset:" .. RESET)
  _setF2(presetLabel, 12)

  local lastPresetBtn = presetLabel
  f.presetBtns = {}
  for i, p in ipairs(Presets) do
    local btn = CreateFrame("Button", nil, sp, "UIPanelButtonTemplate")
    btn:SetSize(68, 20)
    if i == 1 then
      btn:SetPoint("LEFT", presetLabel, "RIGHT", 8, 0)
    else
      btn:SetPoint("LEFT", f.presetBtns[i-1], "RIGHT", 3, 0)
    end
    btn:SetText(p.label)
    _setF2(btn:GetFontString(), 12)
    local pk = p.key
    btn:SetScript("OnClick", function()
      if WOWTR and WOWTR.Debug and WOWTR.Debug.SetPreset then
        WOWTR.Debug.SetPreset(pk)
        UI.UpdateSettings()
      end
    end)
    f.presetBtns[i] = btn
  end

  -- ── Category section header ────────────────────────────
  local catHeader = sp:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  catHeader:SetPoint("TOPLEFT", presetLabel, "BOTTOMLEFT", 0, -14)
  catHeader:SetText("Category verbosity:   " .. C_GREY .. "0=OFF  1=ERR  2=MIN  3=INF  4=VRB" .. RESET)
  _setF2(catHeader, 11)

  -- Column headers
  local colTag  = sp:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  colTag:SetPoint("TOPLEFT", catHeader, "BOTTOMLEFT", 2, -6)
  colTag:SetText("|cFFBBBBBBCategory|r")
  colTag:SetWidth(96)
  _setF2(colTag, 11)

  local colLvl  = sp:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  colLvl:SetPoint("LEFT", colTag, "RIGHT", 4, 0)
  colLvl:SetText("|cFFBBBBBBLevel|r")
  colLvl:SetWidth(100)
  _setF2(colLvl, 11)

  local colBar  = sp:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  colBar:SetPoint("LEFT", colLvl, "RIGHT", 4, 0)
  colBar:SetText("|cFFBBBBBBBar|r")
  _setF2(colBar, 11)

  -- ── Per-category rows inside a scroll frame ─────────────
  local scrollFrame = CreateFrame("ScrollFrame", nil, sp, "UIPanelScrollFrameTemplate")
  scrollFrame:SetPoint("TOPLEFT",  colTag, "BOTTOMLEFT", -2, -6)
  scrollFrame:SetPoint("BOTTOMRIGHT", sp, "BOTTOMRIGHT", -22, 5)

  local scrollBar = scrollFrame.ScrollBar
  if scrollBar then
    scrollBar:ClearAllPoints()
    scrollBar:SetPoint("TOPLEFT",    scrollFrame, "TOPRIGHT",    2, -16)
    scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 2,  16)
  end

  local scrollContent = CreateFrame("Frame", nil, scrollFrame)
  scrollContent:SetWidth(scrollFrame:GetWidth() - 28)
  scrollContent:SetHeight(1)
  scrollFrame:SetScrollChild(scrollContent)
  f.scrollContent = scrollContent

  f.catRows = {}
  local rowH = 28
  for i, cat in ipairs(Categories) do
    local row = CreateFrame("Frame", nil, scrollContent)
    row:SetPoint("TOPLEFT",  scrollContent, "TOPLEFT", 0, -(i-1)*rowH)
    row:SetHeight(rowH)
    row:SetPoint("RIGHT", scrollContent, "RIGHT", 0, 0)

    -- Zebra-stripe background
    local stripe = row:CreateTexture(nil, "BACKGROUND")
    stripe:SetAllPoints()
    if i % 2 == 0 then
      stripe:SetColorTexture(0.12, 0.12, 0.20, 0.5)
    else
      stripe:SetColorTexture(0.08, 0.08, 0.15, 0.5)
    end

    -- [TAG] label
    local tagLabel = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    tagLabel:SetPoint("LEFT", row, "LEFT", 4, 0)
    tagLabel:SetWidth(90)
    tagLabel:SetText(string.format(
      "|cFF%02X%02X%02X[%s]|r %s", cat.r*255, cat.g*255, cat.b*255, cat.tag, cat.label))
    _setF2(tagLabel, 12)
    row.tagLabel = tagLabel

    -- < button
    local btnDec = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    btnDec:SetSize(22, 20)
    btnDec:SetPoint("LEFT", tagLabel, "RIGHT", 6, 0)
    btnDec:SetText("<")
    local catKey = cat.key
    btnDec:SetScript("OnClick", function()
      local cur = _getCategoryLevel(catKey)
      if cur > 0 then
        _setCategoryLevel(catKey, cur - 1)
        UI.UpdateSettings()
      end
    end)
    row.btnDec = btnDec

    -- Level display
    local lvlLabel = row:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    lvlLabel:SetPoint("LEFT", btnDec, "RIGHT", 4, 0)
    lvlLabel:SetWidth(36)
    lvlLabel:SetJustifyH("CENTER")
    _setF2(lvlLabel, 16)
    row.lvlLabel = lvlLabel

    -- > button
    local btnInc = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    btnInc:SetSize(22, 20)
    btnInc:SetPoint("LEFT", lvlLabel, "RIGHT", 4, 0)
    btnInc:SetText(">")
    btnInc:SetScript("OnClick", function()
      local cur = _getCategoryLevel(catKey)
      if cur < 4 then
        _setCategoryLevel(catKey, cur + 1)
        UI.UpdateSettings()
      end
    end)
    row.btnInc = btnInc

    -- Bar + name display (uses █ ░ block chars that need WOWTR_Font2)
    local barLabel = row:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    barLabel:SetPoint("LEFT", btnInc, "RIGHT", 8, 0)
    barLabel:SetWidth(130)
    _setF2(barLabel, 13)
    row.barLabel = barLabel

    f.catRows[cat.key] = row
  end
  scrollContent:SetHeight(#Categories * rowH + 4)

  -- ============================================================
  -- TAB 2: Dump Tools
  -- ============================================================
  local tp = toolsPanel

  local hint = tp:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  hint:SetPoint("TOPLEFT", tp, "TOPLEFT", 10, -10)
  hint:SetWidth(390)
  hint:SetJustifyH("LEFT")
  hint:SetText("Dump visible UI strings/art.\nExport with Tools/ExportAgentDebugLog.ps1 after /reload.")
  _setF2(hint, 11)

  local opts = { includeAll=false, includeNoise=false, includeHidden=false, includeArt=false }
  f.opts = opts

  local function mkCheck(text, x, y, field)
    local cb = CreateFrame("CheckButton", nil, tp, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", tp, "TOPLEFT", x, y)
    cb.text:SetText(text)
    _setF2(cb.text, 11)
    cb:SetChecked(false)
    cb:SetScript("OnClick", function(self) opts[field] = self:GetChecked() and true or false end)
    return cb
  end
  -- Shifted down 20px from the original positions to accommodate the 2-line hint above.
  f.cbAll    = mkCheck("Include translated (all)",    10,  -55, "includeAll")
  f.cbNoise  = mkCheck("Include noise (numbers)",     10,  -80, "includeNoise")
  f.cbHidden = mkCheck("Include hidden",              10, -105, "includeHidden")
  f.cbArt    = mkCheck("Include art (textures)",      10, -130, "includeArt")

  local function mkBtn(label, x, y, w, onClick)
    local b = CreateFrame("Button", nil, tp, "UIPanelButtonTemplate")
    b:SetSize(w or 120, 22)
    b:SetPoint("TOPLEFT", tp, "TOPLEFT", x, y)
    b:SetText(label)
    _setF2(b:GetFontString(), 12)
    b:SetScript("OnClick", onClick)
    return b
  end

  mkBtn("Dump Visible UI", 210, -70, 145, function()
    if not (WOWTR and WOWTR.Debug and WOWTR.Debug.DumpVisibleUI) then
      _msg("|cFFFF0000[WoWAR]|r DumpVisibleUI not available"); return
    end
    WOWTR.Debug.DumpVisibleUI({
      includeAll=f.opts.includeAll, skipNoise=not f.opts.includeNoise,
      includeHidden=f.opts.includeHidden, includeArt=f.opts.includeArt,
      dedupe=true, maxRoots=30, maxNodes=2000, maxDepth=12, maxArtEntries=6000,
    })
  end)

  mkBtn("Reset dedupe", 210, -100, 145, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ResetDumpCache then
      WOWTR.Debug.ResetDumpCache()
      _msg("|cFF00FF88[WoWAR]|r Dump dedupe cache reset.")
    end
  end)

  -- Clear logs section
  local clearLabel = tp:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  clearLabel:SetPoint("TOPLEFT", tp, "TOPLEFT", 10, -165)
  clearLabel:SetText(C_GOLD .. "Clear agent logs:" .. RESET)
  _setF2(clearLabel, 13)

  mkBtn("Clear ALL",   10, -188, 100, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then WOWTR.Debug.ClearAgentLogs("all") end
  end)
  mkBtn("Clear dump",  118, -188, 100, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then WOWTR.Debug.ClearAgentLogs("dump") end
  end)
  mkBtn("Clear debug", 226, -188, 100, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then WOWTR.Debug.ClearAgentLogs("debug") end
  end)
  mkBtn("Clear cache",  10, -216, 100, function()
    if WOWTR and WOWTR.Debug and WOWTR.Debug.ClearAgentLogs then WOWTR.Debug.ClearAgentLogs("cache") end
  end)
  mkBtn("/reload", 118, -216, 100, function() if ReloadUI then ReloadUI() end end)

  -- Help text at bottom of dump tools.
  -- NOTE: avoid |t and |h (lowercase) directly after pipe — WoW treats |t as
  -- end-texture-tag and |h as end-hyperlink, swallowing those characters.
  -- Using " | " (pipe with spaces on both sides) prevents that.
  local helpLabel = tp:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
  helpLabel:SetPoint("TOPLEFT", tp, "TOPLEFT", 10, -250)
  helpLabel:SetWidth(390)
  helpLabel:SetJustifyH("LEFT")
  helpLabel:SetText("|cFF888888/wowardebug on | off | toggle | status | preset <name> | help|r")
  _setF2(helpLabel, 11)

  -- Activate first tab
  SelectTab(1)

  UI.frame = f
  return f
end

-- -------------------------------------------------------
-- Update all controls to reflect current saved-variables state
-- -------------------------------------------------------
function UI.UpdateSettings()
  if not UI.frame then return end
  local f = UI.frame

  local d = _debug()
  local debugOn = d and d.IsEnabled and d.IsEnabled() or false

  -- Status banner
  local bannerText
  if WOWTR and WOWTR.Debug and WOWTR.Debug.GetStatusLine then
    bannerText = WOWTR.Debug.GetStatusLine()
  else
    bannerText = debugOn and (C_GREEN .. "Debug: ON" .. RESET) or (C_GREY .. "Debug: OFF" .. RESET)
  end
  if f.statusBanner then
    f.statusBanner:SetText(bannerText)
    _setF2(f.statusBanner, 12)
  end

  -- Master toggle
  if f.masterToggle then f.masterToggle:SetChecked(debugOn) end

  -- Per-category rows
  if f.catRows then
    for _, cat in ipairs(Categories) do
      local row = f.catRows[cat.key]
      if row then
        local lvl = _getCategoryLevel(cat.key)
        local vm  = VerbMeta[lvl + 1] or VerbMeta[1]

        -- Level label: coloured number
        local hex = string.format("%02X%02X%02X", vm.color[1]*255, vm.color[2]*255, vm.color[3]*255)
        row.lvlLabel:SetText(string.format("|cFF%s%d|r", hex, lvl))
        _setF2(row.lvlLabel, 16)

        -- Bar: 4 filled/empty blocks + verbosity name (requires WOWTR_Font2 for █ ░)
        local bar = ""
        for i = 1, 4 do
          if i <= lvl then
            bar = bar .. string.format("|cFF%s█|r", hex)
          else
            bar = bar .. "|cFF333333░|r"
          end
        end
        row.barLabel:SetText(bar .. "  " .. string.format("|cFF%s%s|r", hex, vm.name))
        _setF2(row.barLabel, 13)

        -- Disable < > when master is off
        if debugOn then
          row.btnDec:Enable()
          row.btnInc:Enable()
          row.tagLabel:SetAlpha(1.0)
        else
          row.btnDec:Disable()
          row.btnInc:Disable()
          row.tagLabel:SetAlpha(0.4)
        end
      end
    end
  end
end

-- -------------------------------------------------------
-- Public API
-- -------------------------------------------------------
function UI.Show()
  local f = UI.CreateFrame()
  UI.UpdateSettings()
  f:Show()
end

function UI.Hide()
  if UI.frame then UI.frame:Hide() end
end

function UI.Toggle()
  if UI.frame and UI.frame:IsVisible() then
    UI.Hide()
  else
    UI.Show()
  end
end
