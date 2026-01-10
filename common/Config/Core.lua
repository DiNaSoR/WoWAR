-- Config Core: AceDB init, migration, syncing, and options assembly
-------------------------------------------------------------------------------------------------------

local AceConfig = LibStub("AceConfig-3.0", true)
local AceConfigDialog = LibStub("AceConfigDialog-3.0", true)
local AceDB = LibStub("AceDB-3.0", true)
local AceDBOptions = LibStub("AceDBOptions-3.0", true)
local LSM = LibStub("LibSharedMedia-3.0", true)
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0", true)

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
local C = WOWTR.Config
function C.NotifyChange()
  if AceConfigRegistry then
    AceConfigRegistry:NotifyChange("WOWTR")
  end
end

C.defaults = {
  profile = {
    minimap = { hide = false, minimapPos = 238 },
    core = {
      lastShownChangelogVersion = "",
      debug = false, -- Debug mode toggle
      debugConfig = {
        quests = 3,    -- NORMAL by default
        gossip = 3,
        tooltips = 3,
        books = 3,
        movies = 3,
        bubbles = 3,
        chat = 3,
        config = 3,
        general = 3,
      },
    },
    quests = {
      active = true, transtitle = true, gossip = true, tracker = true,
      saveQS = true, saveGS = true, immersion = true, storyline = true,
      questlog = true, dialogueui = true, ownnames = false, en_first = false,
      FontFile = WOWTR_Fonts and WOWTR_Fonts[1] or nil, FontLSM = nil, fontsize = tonumber(QTR_PS and QTR_PS["fontsize"]) or 13,
    },
    tooltips = {
      active = true, save = true, saveui = true,
      ui1 = true, ui2 = true, ui3 = true, ui4 = true, ui5 = true, ui6 = true, ui7 = true, ui8 = true,
      ui_talents = true,
      item = true, spell = true, talent = true, transtitle = false, showID = false, showHS = false,
      sellprice = false, constantly = true, timer = 10, saveNW = true,
    },
    bubbles = {
      active = true, chat_en = false, chat_tr = true, saveNB = true, setsize = false, fontsize = 13,
      sex = 4, dungeon = false, timeDisplay = 5, dungeonF1 = 270, dungeonF2 = 270, dungeonF3 = 270, dungeonF4 = 270, dungeonF5 = 270,
    },
    movies = { active = true, intro = true, movie = true, cinematic = true, save = true },
    books = { active = true, title = true, showID = true, setsize = false, fontsize = 15, saveNW = true },
    chatAR = { active = true, setsize = false, fontsize = 13 },
  }
}

local function NormalizeBubblesProfile(profile)
  if not profile or type(profile) ~= "table" then return end
  local b = profile.bubbles
  if not b or type(b) ~= "table" then return end

  -- Prevent double chat output (EN + TR) for the same bubble lines.
  -- If both are enabled, prefer translated output (Chat TR) and disable Chat EN.
  if b.chat_en and b.chat_tr then
    b.chat_en = false
  end
end

function C.SyncGlobalsFromDB()
  if not WOWTR.db then return end
  local p = WOWTR.db.profile

  NormalizeBubblesProfile(p)

  if WOWTR and WOWTR.LegacyBridge and WOWTR.LegacyBridge.SyncLegacyFromProfile then
    WOWTR.LegacyBridge.SyncLegacyFromProfile(p)
  end

  if LSM and p.quests.FontLSM then
    local fontPath = LSM:Fetch("font", p.quests.FontLSM)
    if fontPath then
      WOWTR_Font1 = fontPath
      WOWTR_Font2 = fontPath
    end
  elseif p.quests.FontFile and WOWTR_Fonts and #WOWTR_Fonts > 1 then
    WOWTR_Font2 = WOWTR_Localization.mainFolder .. "\\Fonts\\" .. p.quests.FontFile
  end
end

function C.MigrateLegacyToDB()
  if not WOWTR.db then return end
  local p = WOWTR.db.profile
  if WOWTR and WOWTR.LegacyBridge and WOWTR.LegacyBridge.MigrateLegacyToProfile then
    WOWTR.LegacyBridge.MigrateLegacyToProfile(p)
  end

  -- Auto-fix legacy states that had both toggles enabled (prevents duplicate EN+TR chat lines).
  NormalizeBubblesProfile(p)
end

local function RegisterLSMFonts()
  if not LSM then return end
  if not WOWTR_Localization then return end
  if WOWTR_Font1 then LSM:Register("font", "WoWLang Font1", WOWTR_Font1) end
  if WOWTR_Font2 then LSM:Register("font", "WoWLang Font2", WOWTR_Font2) end
  if WOWTR_Fonts and type(WOWTR_Fonts) == "table" then
    for _, filename in ipairs(WOWTR_Fonts) do
      local name = tostring(filename):gsub("%.ttf$", "")
      local path = WOWTR_Localization.mainFolder .. "\\Fonts\\" .. filename
      LSM:Register("font", "WoWLang " .. name, path)
    end
  end
end

-- Apply WOWTR_Font2 to AceConfigDialog UI when Arabic is active
local ChromeHooked = false
local function HookAceConfigDialogChrome()
  if ChromeHooked then return end
  if not AceConfigDialog or not AceConfigDialog.Open then return end
  
  local function FixTitleWidth(frameRef)
    if not frameRef or not frameRef.obj then return end
    local widget = frameRef.obj
    if widget.WOWTR_TitleHooked then return end
    widget.WOWTR_TitleHooked = true
    local origSetTitle = widget.SetTitle
    if type(origSetTitle) ~= "function" then return end
    widget.SetTitle = function(self, title)
      origSetTitle(self, title)
      local bg = self.titlebg
      if not bg or not bg.SetWidth then return end
      local tw = 0
      if self.titletext and self.titletext.GetStringWidth then
        tw = tonumber(self.titletext:GetStringWidth()) or 0
      elseif self.titletext and self.titletext.GetWidth then
        tw = tonumber(self.titletext:GetWidth()) or 0
      elseif bg.GetWidth then
        tw = tonumber(bg:GetWidth()) or 200
      end
      tw = math.max(120, math.floor(tw + 12))
      if not self.WOWTR_TitleFixedWidth or tw > self.WOWTR_TitleFixedWidth then
        self.WOWTR_TitleFixedWidth = tw
      end
      bg:SetWidth(self.WOWTR_TitleFixedWidth)
    end
    -- Apply immediately after fonts are set so first render is stable
    local bg = widget.titlebg
    local current = (bg and bg.GetWidth and tonumber(bg:GetWidth())) or 200
    local tw = 0
    if widget.titletext and widget.titletext.GetStringWidth then
      tw = tonumber(widget.titletext:GetStringWidth()) or 0
    elseif widget.titletext and widget.titletext.GetWidth then
      tw = tonumber(widget.titletext:GetWidth()) or 0
    end
    local target = math.max(120, math.floor(math.max(current, tw + 12)))
    widget.WOWTR_TitleFixedWidth = target
    if bg and bg.SetWidth then bg:SetWidth(target) end
  end
  
  local function NudgeTabGroupDown(frameRef, topPad)
    -- No-op: rely on AceGUI's internal layout; our banner only adjusts content padding
  end
  
  -- (removed) ElevateTopControls: superseded by EnsureTopRightClose/HideFooterControls

  local function HideFooterControls(frameRef)
    if not frameRef then return end
    local function kill(f)
      if not f then return end
      if f.Hide then pcall(f.Hide, f) end
      if f.SetAlpha then pcall(f.SetAlpha, f, 0) end
      if f.EnableMouse then pcall(f.EnableMouse, f, false) end
      if f.SetFrameStrata then pcall(f.SetFrameStrata, f, "BACKGROUND") end
      if f.ClearAllPoints and f.SetPoint then pcall(f.ClearAllPoints, f); pcall(f.SetPoint, f, "BOTTOMLEFT", frameRef, "BOTTOMLEFT", 0, -9999) end
      if f.HookScript then pcall(f.HookScript, f, "OnShow", function(self) self:Hide() end) end
    end
    local closeBtn = (frameRef.obj and frameRef.obj.closebutton) or frameRef.closebutton
    local searchBox = (frameRef.obj and frameRef.obj.searchbox) or frameRef.searchbox
    kill(closeBtn); kill(searchBox)
    if frameRef.GetChildren then
      local kids = { frameRef:GetChildren() }
      for _, k in ipairs(kids) do
        local t = k.GetObjectType and k:GetObjectType() or nil
        if (t == "Button" or t == "EditBox") and (k ~= frameRef.WOWTR_TopRightClose) then
          -- Skip our top-right close and only target footer-like controls
          local name = k.GetName and k:GetName() or ""
          local p1 = k.GetPoint and select(1, k:GetPoint()) or nil
          local anchoredBottom = p1 == "BOTTOM" or p1 == "BOTTOMLEFT" or p1 == "BOTTOMRIGHT"
          local looksLikeFooter = anchoredBottom or (name and (name:find("Search") or name:find("Close")))
          if looksLikeFooter then kill(k) end
        end
      end
    end
  end

  local function EnsureTopRightClose(frameRef, appName)
    if not frameRef then return end
    HideFooterControls(frameRef)
    if not frameRef.WOWTR_TopRightClose then
      local btn = CreateFrame("Button", nil, frameRef, "UIPanelCloseButton")
      frameRef.WOWTR_TopRightClose = btn
      btn:SetPoint("TOPRIGHT", frameRef, "TOPRIGHT", -6, -6)
      if btn.SetFrameStrata then btn:SetFrameStrata("FULLSCREEN_DIALOG") end
      if btn.SetFrameLevel and frameRef.GetFrameLevel then btn:SetFrameLevel((frameRef:GetFrameLevel() or 0) + 250) end
      btn:SetScript("OnClick", function() if AceConfigDialog and AceConfigDialog.Close then AceConfigDialog:Close(appName or "WOWTR") else frameRef:Hide() end end)
    end
    frameRef.WOWTR_TopRightClose:Show()
    -- Keep footer controls removed even if AceGUI rebuilds them
    if not frameRef.WOWTR_KillFooterHooked and frameRef.HookScript then
      frameRef.WOWTR_KillFooterHooked = true
      local acc = 0
      frameRef:HookScript("OnUpdate", function(f, elapsed)
        acc = (acc or 0) + (elapsed or 0)
        if acc >= 0.5 then
          acc = 0
          HideFooterControls(f)
        end
      end)
    end
  end
  local function NeutralizeFrameChrome(frameRef)
    if not frameRef then return end
    if frameRef.titlebg and frameRef.titlebg.Hide then frameRef.titlebg:Hide() end
    if frameRef.statusbg and frameRef.statusbg.Hide then frameRef.statusbg:Hide() end
  end

  local function AttachConfigBanner(container)
    if not container or not container.CreateTexture then return end
    if not container.WOWTR_Banner then
      local tex = container:CreateTexture(nil, "BACKGROUND")
      container.WOWTR_Banner = tex
      tex:SetHorizTile(false); tex:SetVertTile(false)
      tex:SetAlpha(1)
      tex:SetVertexColor(1, 1, 1, 1)
      tex:SetDrawLayer("ARTWORK")
      tex:SetPoint("TOPLEFT", container, "TOPLEFT", 2, 73)
      tex:SetPoint("TOPRIGHT", container, "TOPRIGHT", -2, 73)
      tex:SetHeight(80)
    end
    local path
    if WOWTR_Localization and WOWTR_Localization.mainFolder then
      path = WOWTR_Localization.mainFolder .. "\\Images\\bannar.png"
    end
    if path then container.WOWTR_Banner:SetTexture(path) end
    container.WOWTR_Banner:Show()
    NeutralizeFrameChrome(container)
    local content = container.content
    -- Do not push content down; keep banner as a top overlay above the frame
    if content and content.ClearAllPoints then
      content:ClearAllPoints()
      content:SetPoint("TOPLEFT", container, "TOPLEFT", 12, -12)
      content:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -12, 12)
    end
    -- Do not re-anchor children; let AceGUI position TabGroup within content
    if not container.WOWTR_BannerHooked and container.HookScript then
      container.WOWTR_BannerHooked = true
      container:HookScript("OnShow", function(f)
        local c = f.content
        if c and c.ClearAllPoints then
          c:ClearAllPoints()
          c:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -12)
          c:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 12)
        end
      end)
      container:HookScript("OnSizeChanged", function(f)
        local c = f.content
        if c and c.ClearAllPoints then
          c:ClearAllPoints()
          c:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -12)
          c:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 12)
        end
      end)
    end
  end

  local function AfterOpen(self, appName, container, ...)
    -- Only apply extra chrome changes to our standalone AceConfig frame (OpenFrames).
    if not (self and self.OpenFrames and self.OpenFrames[appName] and self.OpenFrames[appName].frame) then return end
    if appName ~= "WOWTR" then return end

    local openFrame = self.OpenFrames[appName].frame
    AttachConfigBanner(openFrame)
    FixTitleWidth(openFrame)
    -- push content down by banner height so tabs do not overlap the image
    local banner = openFrame and openFrame.WOWTR_Banner
    local content = openFrame and openFrame.content
    local bh = banner and banner.GetHeight and tonumber(banner:GetHeight()) or 96
    local topPad = bh
    if content and content.ClearAllPoints then
      content:ClearAllPoints()
      content:SetPoint("TOPLEFT", openFrame, "TOPLEFT", 12, -topPad)
      content:SetPoint("BOTTOMRIGHT", openFrame, "BOTTOMRIGHT", -12, 12)
    end
    NudgeTabGroupDown(openFrame, topPad)
    EnsureTopRightClose(openFrame, appName)
  end

  if hooksecurefunc then
    hooksecurefunc(AceConfigDialog, "Open", AfterOpen)
  else
    -- Fallback: wrap Open (unlikely in WoW)
    local orig = AceConfigDialog.Open
    AceConfigDialog.Open = function(self, appName, container, ...)
      local ret = orig(self, appName, container, ...)
      pcall(AfterOpen, self, appName, container, ...)
      return ret
    end
  end

  ChromeHooked = true
end

-- Tooltip hooking/font templating is owned by the Tooltips module (see `common/Tooltips/Hooks.lua`).

local function GetOptionTitle()
  return QTR_ReverseIfAR(WOWTR_Localization and WOWTR_Localization.optionTitle or "WoWLang")
end

local function BuildOptions()
  local options = {
    type = "group",
    childGroups = "tab",
    name = GetOptionTitle(),
    args = {}
  }

  local G = C.Groups or {}
  if G.General then options.args.general = G.General() end
  if G.Tooltips then options.args.tooltips = G.Tooltips() end
  if G.Bubbles then options.args.bubbles = G.Bubbles() end
  if G.Movies then options.args.movies = G.Movies() end
  if G.Books then options.args.books = G.Books() end
  if G.ChatAR then options.args.chatAR = G.ChatAR() end
  if G.About then options.args.about = G.About() end

  if AceDBOptions and WOWTR.db then
    options.args.profiles = AceDBOptions:GetOptionsTable(WOWTR.db)
    options.args.profiles.order = 99
  end
  return options
end

function C.Init()
  if AceDB then
    -- IMPORTANT:
    -- Legacy tables (QTR_PS/TT_PS/...) are still used at runtime, but AceDB is our durable config store.
    -- Only migrate legacy -> AceDB when the AceDB SavedVariables table does not yet exist,
    -- otherwise we can accidentally overwrite user-saved AceDB values on every login.
    local hadDB = (type(_G.WOWTR_DB) == "table")

    WOWTR.db = AceDB:New("WOWTR_DB", C.defaults, true)

    if not hadDB then
      C.MigrateLegacyToDB()
    end

    if WOWTR.db and WOWTR.db.global then
      WOWTR.db.global.legacyMigrated = true
    end
    C.SyncGlobalsFromDB()
    if WOWTR.db.RegisterCallback then
      WOWTR.db:RegisterCallback("OnProfileChanged", C.SyncGlobalsFromDB)
      WOWTR.db:RegisterCallback("OnProfileCopied", C.SyncGlobalsFromDB)
      WOWTR.db:RegisterCallback("OnProfileReset", C.SyncGlobalsFromDB)
    end
    -- Initialize debug system after database is ready
    if WOWTR and WOWTR.Debug and WOWTR.Debug.Initialize then
      WOWTR.Debug.Initialize()
    end
  end
  -- WoWLang: options UI is now the Plumber-style ControlCenter panel (no AceConfig UI registration).
  RegisterLSMFonts()
  if WOWTR and WOWTR.Fonts then
    WOWTR.Fonts.HookBlizzardAddOnsList()
    WOWTR.Fonts.HookDropdownLists()
  end
  -- (AceConfigDialog chrome hooks no longer needed)
  -- Tooltips own tooltip hooking/font templating (see common/Tooltips/Hooks.lua)
end

function C.Open()
  local CC = WOWTR and WOWTR.Config and WOWTR.Config.ControlCenter
  if CC and CC.ToggleSettings then
    CC.ToggleSettings()
    return
  end
  if Settings and WOWTR and WOWTR.ControlCenterCategoryID then
    Settings.OpenToCategory(WOWTR.ControlCenterCategoryID)
  end
end

