-- Debug UI
-- Smart Debugging Interface for WoWTR

WOWTR = WOWTR or {}
WOWTR.DebugUI = WOWTR.DebugUI or {}
local Debug = WOWTR.Debug
local DebugUI = WOWTR.DebugUI

-- Constants
local WIDTH = 700
local HEIGHT = 500
local MAX_LINES = 2000 -- Max lines in the scrolling message frame

-- State
DebugUI.isOpen = false
DebugUI.autoScroll = true
DebugUI.viewFilters = {
    search = "",
    categories = {}, -- true = visible (default), false = hidden
}

-- Initialize category view filters
for _, cat in pairs(Debug.Categories) do
    DebugUI.viewFilters.categories[cat] = true
end

-- Create the main frame
function DebugUI.CreateFrame()
    if DebugUI.frame then return DebugUI.frame end

    local f = CreateFrame("Frame", "WOWTR_DebugFrame", UIParent, "BackdropTemplate")
    f:SetSize(WIDTH, HEIGHT)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    f:SetResizable(true)
    f:SetMinResize(500, 300)

    -- Resize handle
    local rb = CreateFrame("Button", nil, f)
    rb:SetPoint("BOTTOMRIGHT", -6, 6)
    rb:SetSize(16, 16)
    rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    rb:SetScript("OnMouseDown", function() f:StartSizing("BOTTOMRIGHT") end)
    rb:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)

    -- Background
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })

    -- Title
    local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
    title:SetPoint("TOP", f, "TOP", 0, -16)
    title:SetText("WoWTR Smart Debug")

    -- Close Button
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -8)
    close:SetScript("OnClick", function() DebugUI.Toggle() end)

    -- Top Toolbar
    local toolbar = CreateFrame("Frame", nil, f)
    toolbar:SetPoint("TOPLEFT", 16, -40)
    toolbar:SetPoint("TOPRIGHT", -16, -40)
    toolbar:SetHeight(30)
    f.toolbar = toolbar

    -- Clear Button
    local clearBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
    clearBtn:SetSize(60, 22)
    clearBtn:SetPoint("LEFT", 0, 0)
    clearBtn:SetText("Clear")
    clearBtn:SetScript("OnClick", function()
        Debug.ClearLogBuffer()
        DebugUI.Refresh()
    end)

    -- Copy Button
    local copyBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
    copyBtn:SetSize(60, 22)
    copyBtn:SetPoint("LEFT", clearBtn, "RIGHT", 5, 0)
    copyBtn:SetText("Copy")
    copyBtn:SetScript("OnClick", function()
        DebugUI.ShowCopyWindow()
    end)

    -- Auto Scroll Toggle
    local autoScroll = CreateFrame("CheckButton", nil, toolbar, "UICheckButtonTemplate")
    autoScroll:SetSize(24, 24)
    autoScroll:SetPoint("LEFT", copyBtn, "RIGHT", 10, 0)
    autoScroll:SetChecked(DebugUI.autoScroll)
    autoScroll:SetScript("OnClick", function(self)
        DebugUI.autoScroll = self:GetChecked()
        if DebugUI.autoScroll then
            f.msgFrame:ScrollToBottom()
        end
    end)
    local asLabel = toolbar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    asLabel:SetPoint("LEFT", autoScroll, "RIGHT", 2, 0)
    asLabel:SetText("Auto Scroll")

    -- Search Box
    local searchBox = CreateFrame("EditBox", "WOWTR_DebugSearch", toolbar, "InputBoxTemplate")
    searchBox:SetSize(150, 20)
    searchBox:SetPoint("RIGHT", -5, 0)
    searchBox:SetAutoFocus(false)
    searchBox:SetFontObject("ChatFontNormal")
    searchBox:SetScript("OnTextChanged", function(self)
        DebugUI.viewFilters.search = self:GetText()
        DebugUI.Refresh()
    end)
    searchBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    local searchLabel = toolbar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    searchLabel:SetPoint("RIGHT", searchBox, "LEFT", -5, 0)
    searchLabel:SetText("Search:")

    -- Settings Button (Toggle Categories)
    local settingsBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
    settingsBtn:SetSize(80, 22)
    settingsBtn:SetPoint("RIGHT", searchLabel, "LEFT", -10, 0)
    settingsBtn:SetText("Options")
    settingsBtn:SetScript("OnClick", function()
        if DebugUI.optionsFrame and DebugUI.optionsFrame:IsShown() then
            DebugUI.optionsFrame:Hide()
        else
            DebugUI.ShowOptions()
        end
    end)

    -- Log Display (ScrollingMessageFrame)
    local msgFrame = CreateFrame("ScrollingMessageFrame", nil, f)
    msgFrame:SetPoint("TOPLEFT", 16, -75)
    msgFrame:SetPoint("BOTTOMRIGHT", -16, 16)
    msgFrame:SetFontObject("ChatFontNormal")
    msgFrame:SetJustifyH("LEFT")
    msgFrame:SetFading(false)
    msgFrame:SetMaxLines(MAX_LINES)
    msgFrame:SetHyperlinksEnabled(true)
    msgFrame:SetScript("OnHyperlinkClick", function(self, link, text, button)
        SetItemRef(link, text, button)
    end)
    
    -- Scroll behavior
    msgFrame:EnableMouseWheel(true)
    msgFrame:SetScript("OnMouseWheel", function(self, delta)
        if delta > 0 then
            self:ScrollUp()
        else
            self:ScrollDown()
        end
        -- If user scrolls up, disable auto-scroll
        if self:GetScrollOffset() > 0 then
            autoScroll:SetChecked(false)
            DebugUI.autoScroll = false
        end
    end)

    f.msgFrame = msgFrame

    DebugUI.frame = f
    return f
end

-- Refresh the log display based on current buffer and filters
function DebugUI.Refresh()
    if not DebugUI.frame then return end
    local f = DebugUI.frame
    f.msgFrame:Clear()

    local buffer = Debug.GetLogBuffer()
    for _, entry in ipairs(buffer) do
        DebugUI.AddEntryToDisplay(entry)
    end

    if DebugUI.autoScroll then
        f.msgFrame:ScrollToBottom()
    end
end

-- Add a single entry to display if it matches filters
function DebugUI.AddEntryToDisplay(entry)
    if not DebugUI.frame then return end

    -- Category View Filter
    if not DebugUI.viewFilters.categories[entry.category] then
        return
    end

    -- Search Filter
    if DebugUI.viewFilters.search ~= "" then
        if not string.find(string.lower(entry.rawMessage), string.lower(DebugUI.viewFilters.search), 1, true) then
            return
        end
    end

    -- Append context info if Verbose
    local displayMsg = entry.message
    if entry.context then
        displayMsg = displayMsg .. " |cFF888888(" .. entry.context .. ")|r"
    end

    -- Timestamp
    displayMsg = "|cFF888888[" .. entry.date .. "]|r " .. displayMsg

    DebugUI.frame.msgFrame:AddMessage(displayMsg)
end

-- Callback from Debug.lua
function DebugUI.OnLogAdded(entry)
    if DebugUI.isOpen and DebugUI.frame then
        DebugUI.AddEntryToDisplay(entry)
        if DebugUI.autoScroll then
            DebugUI.frame.msgFrame:ScrollToBottom()
        end
    end
end

-- Register callback
Debug.OnLogAdded = DebugUI.OnLogAdded
Debug.OnClearLogs = function()
    if DebugUI.frame then
        DebugUI.frame.msgFrame:Clear()
    end
end

-- Show Options Dropdown/Panel
function DebugUI.ShowOptions()
    if DebugUI.optionsFrame then
        DebugUI.optionsFrame:Show()
        return
    end

    local f = CreateFrame("Frame", "WOWTR_DebugOptions", DebugUI.frame, "BackdropTemplate")
    f:SetSize(250, 400)
    f:SetPoint("TOPRIGHT", DebugUI.frame, "TOPLEFT", -5, 0)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    
    local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Options & Categories")

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -5, -5)
    close:SetScript("OnClick", function() f:Hide() end)

    -- Print to Chat Toggle
    local chatToggle = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
    chatToggle:SetPoint("TOPLEFT", 20, -40)
    chatToggle:SetChecked(Debug.Settings.PrintToChat)
    chatToggle:SetScript("OnClick", function(self)
        Debug.Settings.PrintToChat = self:GetChecked()
        -- Also save to DB for persistence if possible
        if WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core then
             WOWTR.db.profile.core.printToChat = self:GetChecked()
        end
    end)
    local chatLabel = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    chatLabel:SetPoint("LEFT", chatToggle, "RIGHT", 5, 0)
    chatLabel:SetText("Print to Chat Frame")

    -- Global Debug Toggle
    local globalToggle = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
    globalToggle:SetPoint("TOPLEFT", chatToggle, "BOTTOMLEFT", 0, -5)
    globalToggle:SetChecked(Debug.IsEnabled())
    globalToggle:SetScript("OnClick", function(self)
        if WOWTR.db and WOWTR.db.profile and WOWTR.db.profile.core then
             WOWTR.db.profile.core.debug = self:GetChecked()
        end
    end)
    local globalLabel = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    globalLabel:SetPoint("LEFT", globalToggle, "RIGHT", 5, 0)
    globalLabel:SetText("Enable Debug System")

    -- Separator
    local line = f:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    line:SetPoint("TOPLEFT", 10, -100)
    line:SetPoint("TOPRIGHT", -10, -100)

    -- Categories Label
    local catTitle = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    catTitle:SetPoint("TOPLEFT", 15, -110)
    catTitle:SetText("Visible Categories:")

    -- Category Checkboxes
    local y = -130
    local keys = {}
    for k in pairs(Debug.Categories) do table.insert(keys, k) end
    table.sort(keys)

    for _, k in ipairs(keys) do
        local cat = Debug.Categories[k]
        local cb = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, y)
        cb:SetSize(20, 20)
        cb:SetChecked(DebugUI.viewFilters.categories[cat])
        cb:SetScript("OnClick", function(self)
            DebugUI.viewFilters.categories[cat] = self:GetChecked()
            DebugUI.Refresh()
        end)

        local lbl = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        lbl:SetPoint("LEFT", cb, "RIGHT", 5, 0)
        lbl:SetText(k)

        y = y - 22
    end

    DebugUI.optionsFrame = f
end

-- Helper to update copy window content
function DebugUI.UpdateCopyWindowText()
    if not DebugUI.copyFrame then return end
    local editBox = DebugUI.copyFrame.editBox
    if not editBox then return end

    -- Populate text
    local buffer = Debug.GetLogBuffer()
    local text = ""
    for _, entry in ipairs(buffer) do
        -- Use raw message for copy
        local line = "[" .. entry.date .. "] [" .. string.upper(entry.category) .. "] " .. entry.rawMessage
        if entry.context then
             line = line .. " (" .. entry.context .. ")"
        end
        text = text .. line .. "\n"
    end
    editBox:SetText(text)
    editBox:HighlightText()
    editBox:SetFocus()
end

-- Show Copy Window
function DebugUI.ShowCopyWindow()
    if DebugUI.copyFrame then
        DebugUI.copyFrame:Show()
        DebugUI.UpdateCopyWindowText()
        return
    end

    local f = CreateFrame("Frame", "WOWTR_DebugCopy", UIParent, "BackdropTemplate")
    f:SetSize(600, 400)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetFrameLevel(100) -- Above main frame
    f:EnableMouse(true)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })

    local title = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Copy Logs (Ctrl+C)")

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -5, -5)
    close:SetScript("OnClick", function() f:Hide() end)

    local scrollArea = CreateFrame("ScrollFrame", "WOWTR_DebugCopyScroll", f, "UIPanelScrollFrameTemplate")
    scrollArea:SetPoint("TOPLEFT", 20, -40)
    scrollArea:SetPoint("BOTTOMRIGHT", -40, 20)

    local editBox = CreateFrame("EditBox", nil, scrollArea)
    editBox:SetMultiLine(true)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(540)
    editBox:SetScript("OnEscapePressed", function() f:Hide() end)
    scrollArea:SetScrollChild(editBox)

    f.editBox = editBox
    DebugUI.copyFrame = f

    DebugUI.UpdateCopyWindowText()

    f:Show()
end

-- Main Toggle
function DebugUI.Toggle()
    if not DebugUI.frame then
        DebugUI.CreateFrame()
    end

    if DebugUI.isOpen then
        DebugUI.frame:Hide()
        DebugUI.isOpen = false
    else
        DebugUI.frame:Show()
        DebugUI.isOpen = true
        DebugUI.Refresh()
    end
end

-- Initialize (lazy load on first toggle)
-- DebugUI.CreateFrame()

return DebugUI
