-------------------------------------------------------------------------------------------------------
-- Talents Module for WoWTranslation Addon
-- Handles translation and UI modifications for Blizzard's Talents Frames.
-- Depends on global functions/variables:
--   ST_CheckAndReplaceTranslationTextUI, ST_CheckAndReplaceTranslationText, ST_RenkKoduSil,
--   ST_OriginalTextCache, ST_OriginalFontCache, ST_OriginalJustifyCache, StartTicker,
--   WoWTR_Localization, QTR_ReverseIfAR, NONBREAKINGSPACE, TT_PS, ST_UsunZbedneZnaki, StringHash,
--   ST_TooltipsHS, WOWTR_Font2, QTR_ExpandUnitInfo, ST_TranslatePrepare, ST_SetText, ST_PM, ST_PH,
--   WOWTR_player_class, ST_PrzedZapisem
-------------------------------------------------------------------------------------------------------

-- ADDED: Check if the dependency function exists early on
if not _G.CreateToggleButton then
    -- print("WoWTR Talents: CRITICAL ERROR - CreateToggleButton function not found in global scope!")
end

local addonName, ns = ...
ns = ns or {}
local UI = ns.UI and ns.UI.Translate
local RTL = ns.RTL

local function isRTL()
    return (RTL and RTL.IsRTL and RTL.IsRTL()) or (type(WoWTR_Localization) == "table" and WoWTR_Localization.lang == "AR") or false
end

local function uiFont()
    if UI and UI.Font then
        return UI.Font()
    end
    return isRTL() and WOWTR_Font1 or WOWTR_Font2
end

-- Ensure global cache tables exist
ST_OriginalTextCache = ST_OriginalTextCache or {}
ST_OriginalFontCache = ST_OriginalFontCache or {}
ST_OriginalJustifyCache = ST_OriginalJustifyCache or {}

-- ========================================== --
--          Helper Functions                  --
-- ========================================== --

-- Helper function to cache original font
local function CacheOriginalFont(element)
    if element and element.GetFont and not ST_OriginalFontCache[element] then
        local success, font, size, flags = pcall(element.GetFont, element)
        if success and font then
            ST_OriginalFontCache[element] = { font, size, flags }
        end
    end
end

-- Helper function to cache original text
local function CacheOriginalText(element)
    if element and element.GetText and not ST_OriginalTextCache[element] then
        local success, text = pcall(element.GetText, element)
        -- Only cache if it doesn't look already translated/cached
        if success and text and string.find(text, NONBREAKINGSPACE) == nil then
            ST_OriginalTextCache[element] = text
        end
    end
end

-- Helper function to cache original justification
local function CacheOriginalJustify(element)
    if element and element.GetJustifyH and not ST_OriginalJustifyCache[element] then
        local success, justifyH = pcall(element.GetJustifyH, element)
        if success and justifyH then
            ST_OriginalJustifyCache[element] = justifyH
        end
    end
end

-- NEW: Combined caching function
local function CacheElementState(element)
    if not element then return end
    -- Use pcall for safety as element methods might not exist
    pcall(CacheOriginalText, element)
    pcall(CacheOriginalFont, element)
    pcall(CacheOriginalJustify, element)
end


-- Helper function to revert element state
local function RevertElementState(element)
    if not element then return end
    local elementName = element:GetName() or "Unknown Element" -- Get name for logging (optional)

    -- Revert Text
    if element.SetText then
        local originalText = ST_OriginalTextCache[element]
        if originalText then
            pcall(element.SetText, element, originalText)
            ST_OriginalTextCache[element] = nil -- Clear cache after reverting
        end
    end

    -- Revert Font
    if element.SetFont then
        local originalFontInfo = ST_OriginalFontCache[element]
        if originalFontInfo then
            local success, err = pcall(element.SetFont, element, unpack(originalFontInfo))
            --[[if not success then
                print("WoWTR Revert: Error reverting font for " .. elementName .. " - " .. tostring(err))
            end]]
            ST_OriginalFontCache[element] = nil -- Clear cache after reverting
        end
    end

    -- Revert Justification
    if element.SetJustifyH then
        local originalJustifyH = ST_OriginalJustifyCache[element]
        if originalJustifyH then
            local success, err = pcall(element.SetJustifyH, element, originalJustifyH)
            --[[if not success then
                print("WoWTR Revert: Error reverting justifyH for " .. elementName .. " - " .. tostring(err))
            end]]
            ST_OriginalJustifyCache[element] = nil -- Clear cache after reverting
        end
    end
end

-- NEW: Applies translation if hash found, assumes element is valid and was cached
local function ApplyTranslationIfFound(element, isDescription)
    local originalText
    local successGetText, result = pcall(element.GetText, element)
    if not successGetText or not result then return false end -- Cannot get text
    originalText = result

    -- Only process if not already translated/marked and has text
    if originalText and #originalText > 0 and not string.find(originalText, NONBREAKINGSPACE) then
        local textForHash = ST_UsunZbedneZnaki(originalText)
        local ST_hash = StringHash(textForHash)

        if ST_TooltipsHS[ST_hash] then
            local originalSize = 11 -- Default size
            local successGetFont, font, size, flags = pcall(element.GetFont, element)
            if successGetFont and size then originalSize = size end
            originalSize = originalSize or (isDescription and 12 or 11) -- Fallback

            local translatedText
            if isDescription then
                -- Special handling for descriptions (expand unit info, etc.)
                translatedText = QTR_ExpandUnitInfo(
                    ST_TranslatePrepare(originalText, ST_TooltipsHS[ST_hash]), false, element, WOWTR_Font2
                ) .. NONBREAKINGSPACE
            else
                -- Use ST_SetText which handles the hash lookup internally for standard text
                translatedText = QTR_ReverseIfAR(ST_SetText(originalText)) .. NONBREAKINGSPACE
            end

            -- Safely set font and text
            pcall(function() if element.SetFont then element:SetFont(WOWTR_Font2, originalSize) end end)
            pcall(function() if element.SetText then element:SetText(translatedText) end end)
            -- Add justification update if needed
            -- pcall(function() if element.SetJustifyH then element:SetJustifyH("LEFT") end end)
            return true -- Translation applied
        end
        -- SaveNW logic is handled specifically in ST_updateHeroTalentHook, not here.
    end
    return false -- No translation found or applied
end

-- NEW: Main handler for most elements - checks toggle, caches, applies translation or reverts
local function HandleElementUpdate(element, isDescription)
    if not element then return end

    if TT_PS["ui_talents"] == "1" then
        -- Try to apply translation
        local canCache = pcall(CacheElementState, element) -- Cache first
        if canCache then
            pcall(ApplyTranslationIfFound, element, isDescription)
            -- If ApplyTranslationIfFound returns false, the element remains unchanged (with original text/font).
        end
    else
        -- Revert if toggle is off
        pcall(RevertElementState, element)
    end
end

-- ========================================== --
--          UI Update Functions               --
-- ========================================== --

-- REFACTORED: Handles Frame Title and Tab Buttons (Special Cases using Globals)
function ST_UpdateFrameTitle(parentFrame)
    if not parentFrame then return end

    local titleTextElement = parentFrame.TitleContainer and parentFrame.TitleContainer.TitleText
    local talentsTabButton = parentFrame.GetTalentsTabButton and parentFrame:GetTalentsTabButton()
    local specTabButton = parentFrame.GetTabButton and parentFrame.specTabID and
        parentFrame:GetTabButton(parentFrame.specTabID)
    local spellbookTabButton = parentFrame.GetTabButton and parentFrame.spellBookTabID and
        parentFrame:GetTabButton(parentFrame.spellBookTabID)

    -- Handle Title Text (Uses Globals: SPECIALIZATION, TALENTS, SPELLBOOK)
    if titleTextElement then
        local titleTextKey = nil
        local canGetTab, currentTab = pcall(parentFrame.GetTab, parentFrame)

        if canGetTab and parentFrame.specTabID then
            if currentTab == parentFrame.specTabID then
                titleTextKey = "SPECIALIZATION"
            elseif parentFrame.talentTabID and currentTab == parentFrame.talentTabID then
                titleTextKey = "TALENTS"
            elseif parentFrame.spellBookTabID and currentTab == parentFrame.spellBookTabID then
                titleTextKey = "SPELLBOOK"
            end
        end

        if TT_PS["ui_talents"] == "1" and titleTextKey then
            -- Apply translation using the global key
            local canCache = pcall(CacheElementState, titleTextElement)
            if canCache then
                local originalSize = 12
                local successGetFont, font, size, flags = pcall(titleTextElement.GetFont, titleTextElement)
                if successGetFont and size then originalSize = size end

                local translatedTitle = QTR_ReverseIfAR(ST_SetText(_G[titleTextKey])) ..
                    NONBREAKINGSPACE -- ST_SetText handles lookup

                pcall(function()
                    if titleTextElement.SetFont then
                        titleTextElement:SetFont(uiFont(), originalSize)
                    end
                end)
                pcall(function() if titleTextElement.SetText then titleTextElement:SetText(translatedTitle) end end)
            end
        else
            -- Revert title if toggle is off OR it's not a spec/talent tab title
            pcall(RevertElementState, titleTextElement)
        end
    end

    -- Handle Talent Tab Button (Uses Global: TALENT_FRAME_TAB_LABEL_TALENTS)
    if talentsTabButton and talentsTabButton.Text then
        if TT_PS["ui_talents"] == "1" then
            local canCache = pcall(CacheElementState, talentsTabButton.Text)
            if canCache then
                local originalSize = 11
                local successGetFont, font, size, flags = pcall(talentsTabButton.Text.GetFont, talentsTabButton.Text)
                if successGetFont and size then originalSize = size end

                local translatedTabText = QTR_ReverseIfAR(ST_SetText(_G["TALENT_FRAME_TAB_LABEL_TALENTS"])) ..
                    NONBREAKINGSPACE

                pcall(function()
                    if talentsTabButton.Text.SetFont then
                        talentsTabButton.Text:SetFont(uiFont(), originalSize)
                    end
                end)
                -- Note: SetText is called on the button itself, not its .Text child typically
                pcall(function() if talentsTabButton.SetText then talentsTabButton:SetText(translatedTabText) end end)
            end
        else
            pcall(RevertElementState, talentsTabButton.Text)
        end
    end

    -- Handle Spec Tab Button (Uses Global: TALENT_FRAME_TAB_LABEL_SPEC)
    if specTabButton and specTabButton.Text then
        if TT_PS["ui_talents"] == "1" then
            local canCache = pcall(CacheElementState, specTabButton.Text)
            if canCache then
                local originalSize = 11
                local successGetFont, font, size, flags = pcall(specTabButton.Text.GetFont, specTabButton.Text)
                if successGetFont and size then originalSize = size end

                local translatedTabText = QTR_ReverseIfAR(ST_SetText(_G["TALENT_FRAME_TAB_LABEL_SPEC"])) ..
                    NONBREAKINGSPACE
                pcall(function()
                    if specTabButton.Text.SetFont then
                        specTabButton.Text:SetFont(uiFont(), originalSize)
                    end
                end)
                -- Note: SetText is called on the button itself, not its .Text child typically
                pcall(function() if specTabButton.SetText then specTabButton:SetText(translatedTabText) end end)
            end
        else
            pcall(RevertElementState, specTabButton.Text)
        end
    end

    -- Handle Spellbook Tab Button (Uses Global: SPELLBOOK)
    if spellbookTabButton and spellbookTabButton.Text then
        if TT_PS["ui_talents"] == "1" then
            local canCache = pcall(CacheElementState, spellbookTabButton.Text)
            if canCache then
                local originalSize = 11
                local successGetFont, font, size, flags = pcall(spellbookTabButton.Text.GetFont, spellbookTabButton.Text)
                if successGetFont and size then originalSize = size end

                local translatedTabText = QTR_ReverseIfAR(ST_SetText(_G["SPELLBOOK"])) ..NONBREAKINGSPACE
                if isRTL() then
                    print("AR")
                else
                    print("EN")
                end
                pcall(function()
                    if spellbookTabButton.Text.SetFont then
                        spellbookTabButton.Text:SetFont(uiFont(), originalSize)
                    end
                end)
                -- Note: SetText is called on the button itself, not its .Text child typically
                pcall(function() if spellbookTabButton.SetText then spellbookTabButton:SetText(translatedTabText) end end)
            end
        else
            pcall(RevertElementState, spellbookTabButton.Text)
        end
    end
end

-- REFACTORED: Uses HandleElementUpdate helper
function ST_TalentsTab_OnShow(talentsTab)
    if not talentsTab then return end

    HandleElementUpdate(talentsTab.ClassCurrencyDisplay and talentsTab.ClassCurrencyDisplay.CurrencyLabel, false)
    HandleElementUpdate(talentsTab.SpecCurrencyDisplay and talentsTab.SpecCurrencyDisplay.CurrencyLabel, false)
    HandleElementUpdate(talentsTab.ApplyButton and talentsTab.ApplyButton.Text, false)
end

-- REFACTORED: Uses HandleElementUpdate helper
function ST_TalentsTranslate()
    local talentsFrame = PlayerSpellsFrame and PlayerSpellsFrame.TalentsFrame
    if not talentsFrame then return end

    HandleElementUpdate(talentsFrame.HeroTalentsContainer and talentsFrame.HeroTalentsContainer.LockedLabel1, false)
    HandleElementUpdate(talentsFrame.HeroTalentsContainer and talentsFrame.HeroTalentsContainer.LockedLabel2, false)
end

-- REFACTORED: Uses HandleElementUpdate helper
function ST_updateSpecContentsHook()
    if not PlayerSpellsFrame or not PlayerSpellsFrame.SpecFrame or not PlayerSpellsFrame.SpecFrame.SpecContentFramePool then
        return
    end

    for specContentFrame in PlayerSpellsFrame.SpecFrame.SpecContentFramePool:EnumerateActive() do
        -- Update standard text elements
        HandleElementUpdate(specContentFrame.RoleName, false)
        HandleElementUpdate(specContentFrame.SampleAbilityText, false)
        HandleElementUpdate(specContentFrame.ActivatedText, false)
        HandleElementUpdate(specContentFrame.ActivateButton and specContentFrame.ActivateButton.Text, false)

        -- Update description (handled as 'description' type by the helper)
        HandleElementUpdate(specContentFrame.Description, true)

        -- <<< ADDED: Specific SaveNW Logic for Spec Description (if toggle ON and translation failed) >>>
        if TT_PS["ui_talents"] == "1" and ST_PM and ST_PM["saveNW"] == "1" then
            local descriptionElement = specContentFrame.Description
            if descriptionElement then
                local successGetText, originalText = pcall(descriptionElement.GetText, descriptionElement)
                -- Check if text exists and wasn't translated (no NBSP added by HandleElementUpdate/ApplyTranslationIfFound)
                if successGetText and originalText and #originalText > 0 and not string.find(originalText, NONBREAKINGSPACE) then
                    local textForHash = ST_UsunZbedneZnaki(originalText)
                    local ST_hash = StringHash(textForHash)
                    -- Double-check if it's really not in the table (HandleElementUpdate->ApplyTranslationIfFound already checked)
                    if not ST_TooltipsHS[ST_hash] then
                        -- Get spec name safely (Prioritize SpecName for actual specialization)
                        local specName = "UnknownSpec"
                        if specContentFrame.SpecName then -- <<<< PRIORITIZE THIS
                             local successGetName, nameResult = pcall(specContentFrame.SpecName.GetText, specContentFrame.SpecName)
                             if successGetName and nameResult then specName = nameResult end
                        -- Fallback: Try RoleName if SpecName failed or wasn't present
                        elseif specContentFrame.RoleName then -- <<<< FALLBACK
                            local successGetName, nameResult = pcall(specContentFrame.RoleName.GetText, specContentFrame.RoleName)
                            if successGetName and nameResult then specName = nameResult end
                        end
                        -- Construct placeholder string
                        local placeholder = "SpecTab:" ..
                            (WOWTR_player_class or "UnknownClass") .. ":" .. specName ..
                            "@" ..
                            ST_PrzedZapisem(originalText:gsub("(%%d),(%%d)", "%%1%%2"):gsub("\r", "")) -- Escaped % for gsub
                        ST_PH = ST_PH or {} -- Ensure placeholder table exists
                        ST_PH[ST_hash] = placeholder
                    end
                end
            end
        end
        -- <<< END ADDED >>>
    end
end

-- REFACTORED: Uses HandleElementUpdate helper + retains specific SaveNW logic
function ST_updateHeroTalentHook()
    if not HeroTalentsSelectionDialog or not HeroTalentsSelectionDialog.SpecContentFramePool then
        return
    end

    local activeFrameFunction = HeroTalentsSelectionDialog.SpecContentFramePool:EnumerateActive()
    if activeFrameFunction then
        for frame in activeFrameFunction do
            -- Update elements using the helper
            HandleElementUpdate(frame.CurrencyFrame and frame.CurrencyFrame.LabelText, false)
            HandleElementUpdate(frame.ActivatedText, false)
            HandleElementUpdate(frame.ActivateButton and frame.ActivateButton.Text, false)
            HandleElementUpdate(frame.Description, true) -- Handles translation/revert

            -- <<< Specific SaveNW Logic for Description (if toggle ON and translation failed) >>>
            if TT_PS["ui_talents"] == "1" and ST_PM and ST_PM["saveNW"] == "1" then
                local descriptionElement = frame.Description
                if descriptionElement then
                    local successGetText, originalText = pcall(descriptionElement.GetText, descriptionElement)
                    -- Check if text exists and wasn't translated (no NBSP added by HandleElementUpdate/ApplyTranslationIfFound)
                    if successGetText and originalText and #originalText > 0 and not string.find(originalText, NONBREAKINGSPACE) then
                        local textForHash = ST_UsunZbedneZnaki(originalText)
                        local ST_hash = StringHash(textForHash)
                        -- Double-check if it's really not in the table (HandleElementUpdate already checked via ApplyTranslationIfFound)
                        if not ST_TooltipsHS[ST_hash] then
                            -- Get spec name safely
                            local specName = "UnknownSpec"
                            if frame.SpecName then -- Use SpecName here as it's likely correct for Hero Talents dialog
                                local successGetName, nameResult = pcall(frame.SpecName.GetText, frame.SpecName)
                                if successGetName and nameResult then specName = nameResult end
                            end
                            -- Construct placeholder string
                            local placeholder = "SpecTab:" ..
                                (WOWTR_player_class or "UnknownClass") .. ":" .. specName ..
                                "@" ..
                                ST_PrzedZapisem(originalText:gsub("(%%d),(%%d)", "%%1%%2"):gsub("\r", "")) -- Escaped % for gsub
                            ST_PH = ST_PH or
                                {}                                                                         -- Ensure placeholder table exists
                            ST_PH[ST_hash] = placeholder
                        end
                    end
                end
            end
        end
    end
end

-- ========================================== --
--          Tooltip Check Function            --
-- ========================================== --

-- Keep: ST_IsTalentTooltip (Seems independent of the refactoring)
function ST_IsTalentTooltip(tooltipData)
    if not tooltipData or not tooltipData.type then
        return false
    end

    -- Talent tooltip type seems to be 1 (spell/talent) check location relative to ClassTalentFrame
    if tooltipData.type == 1 then
        local frame = ClassTalentFrame -- Check specifically ClassTalentFrame
        -- Ensure the frame exists, is visible, and the 'Talents' tab (index 2 usually) is selected
        if frame and frame:IsVisible() and frame.GetTab and (frame:GetTab() == 2) then
            local frameLeft, frameBottom, frameWidth, frameHeight = frame:GetRect()
            if frameLeft then -- Check if GetRect returned valid values
                local frameRight = frameLeft + frameWidth
                local frameTop = frameBottom + frameHeight
                local x, y = GetCursorPosition()
                local scale = frame:GetEffectiveScale()
                x = x / scale
                y = y / scale
                -- Check if cursor is within the bounds of the ClassTalentFrame
                if x > frameLeft and x < frameRight and y > frameBottom and y < frameTop then
                    return true
                end
            end
        end
    end
    -- Could add checks for SpecTalentFrame if needed

    return false
end

-- ========================================== --
--          Button Management Logic           --
-- ========================================== --

local isTalentButtonCreated = false
local TalentUpdateVisibility -- Function to update button visibility

function UpdateTalentToggleButtonState(parentFrame)
    if not parentFrame then return end
    if not _G.CreateToggleButton then
        -- print("WoWTR Talents: ERROR - CreateToggleButton function is nil!")
        return
    end

    if not isTalentButtonCreated then
        TT_PS = TT_PS or { ui_talents = "1" } -- Ensure settings table exists
        local success, result = pcall(CreateToggleButton,
            parentFrame,
            TT_PS,
            "ui_talents",
            WoWTR_Localization.WoWTR_enDESC,
            WoWTR_Localization.WoWTR_trDESC,
            { "TOPRIGHT", parentFrame, "TOPRIGHT", -65, 0 }, -- Position args
            function()                                       -- OnClick handler
                -- When toggled, update all relevant parts of the UI based on current state
                if parentFrame and parentFrame:IsVisible() then
                    ST_UpdateFrameTitle(parentFrame) -- Applies or reverts title/tabs

                    -- Update Spec Frame contents if the SpecFrame itself is visible
                    if parentFrame.SpecFrame and parentFrame.SpecFrame:IsVisible() then
                        ST_updateSpecContentsHook()
                    end

                    -- Update Talents Frame contents if the TalentsFrame itself is visible
                    local talentsFrame = parentFrame.TalentsFrame
                    if talentsFrame and talentsFrame:IsVisible() then
                        ST_TalentsTranslate() -- Locked labels etc.
                        -- Update Talent Tab specific elements if that tab is visible
                        if talentsFrame.TalentsTab and talentsFrame.TalentsTab:IsVisible() then
                            ST_TalentsTab_OnShow(talentsFrame.TalentsTab) -- Currency/apply button
                        end
                    end
                    -- Could potentially add ST_updateHeroTalentHook() call here if Hero Talents dialog can be open simultaneously
                end
            end
        )
        if success and result then
            TalentUpdateVisibility = result -- Store the visibility update function returned by CreateToggleButton
            isTalentButtonCreated = true
        else
            -- print("WoWTR Talents: CreateToggleButton failed:", success and "nil returned" or tostring(result))
            return -- Don't proceed if button creation failed
        end
    end

    -- Update button visibility if the function exists
    if TalentUpdateVisibility then
        local visSuccess, visError = pcall(TalentUpdateVisibility)
        -- if not visSuccess then print("WoWTR Talents: Error calling TalentUpdateVisibility:", tostring(visError)) end
    end

    -- Hook TalentsTab OnShow if needed (only needs to happen once per session)
    -- This ensures currency/apply button update correctly even if toggled while tab is hidden
    local talentsFrame = parentFrame.TalentsFrame
    if talentsFrame and talentsFrame.TalentsTab and not talentsFrame.TalentsTab.WoWTRHooked_OnShow_Delayed then
        talentsFrame.TalentsTab:HookScript("OnShow", ST_TalentsTab_OnShow) -- Directly use the refactored function
        talentsFrame.TalentsTab.WoWTRHooked_OnShow_Delayed = true
    end
end

-- ========================================== --
--          Initialization Logic              --
-- ========================================== --

local playerSpellsFrameCheckTimer = nil
local playerSpellsFrameHooked = false

-- Hooks the main PlayerSpellsFrame to manage the toggle button and initial UI state
local function HookPlayerSpellsFrameForButton()
    if PlayerSpellsFrame and not PlayerSpellsFrame.WoWTRSpellsHooked then
        -- Hook OnShow to add button and perform initial update
        PlayerSpellsFrame:HookScript("OnShow", function(self)
            if not self then return end
            UpdateTalentToggleButtonState(self) -- Create/update button state/visibility
            ST_UpdateFrameTitle(self)           -- Initial update for title/tabs on show

            -- Initial update for spec contents if spec frame is visible on initial show
            if self.SpecFrame and self.SpecFrame:IsVisible() then
                ST_updateSpecContentsHook()
            end
            -- Initial update for talent tab contents if talent frame/tab is visible on initial show
            local talentsFrame = self.TalentsFrame
            if talentsFrame and talentsFrame:IsVisible() then
                ST_TalentsTranslate()
                if talentsFrame.TalentsTab and talentsFrame.TalentsTab:IsVisible() then
                    ST_TalentsTab_OnShow(talentsFrame.TalentsTab)
                end
            end
            -- Could potentially add ST_updateHeroTalentHook() call here if needed on initial show
        end)

        -- Hook OnHide (optional, but good practice) to potentially clear caches or stop timers if needed
        -- PlayerSpellsFrame:HookScript("OnHide", function(self)
        -- Clean up if necessary
        -- end)

        PlayerSpellsFrame.WoWTRSpellsHooked = true
        playerSpellsFrameHooked = true
        -- print("WoWTR Talents: PlayerSpellsFrame hooked successfully.")

        -- Stop the timer check once hooked
        if playerSpellsFrameCheckTimer then
            playerSpellsFrameCheckTimer:Cancel()
            playerSpellsFrameCheckTimer = nil
        end
        return true -- Hooked successfully
    end

    -- Already hooked scenario
    if PlayerSpellsFrame and PlayerSpellsFrame.WoWTRSpellsHooked then
        playerSpellsFrameHooked = true
        if playerSpellsFrameCheckTimer then
            playerSpellsFrameCheckTimer:Cancel()
            playerSpellsFrameCheckTimer = nil
        end
        return true
    end

    return false -- Not found or not hooked yet
end

-- Starts a timer to periodically check for PlayerSpellsFrame if it wasn't available immediately
function StartPlayerSpellsFrameCheck()
    -- Only proceed if not already hooked
    if not playerSpellsFrameHooked then
        -- Try hooking immediately first
        if HookPlayerSpellsFrameForButton() then
            return -- Succeeded immediately
        end

        -- If immediate hook failed and timer doesn't exist, start the timer
        if not playerSpellsFrameCheckTimer then
            -- Check every 1 second for the frame
            playerSpellsFrameCheckTimer = C_Timer.NewTicker(1, function()
                -- Inside the timer, attempt to hook again
                if HookPlayerSpellsFrameForButton() then
                    -- Timer's job is done once hooked (Hook function cancels timer)
                    -- print("WoWTR Talents: Timer found and hooked PlayerSpellsFrame.")
                end
            end)
        end
    end
end

-- ========================================== --
--              Event Registration            --
-- ========================================== --

-- Use a simple frame to register for ADDON_LOADED to ensure initialization runs
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, addonName)
    -- Check if this addon is loaded or potentially trigger on a core Blizzard addon load
    if addonName == "WoWTR" or addonName == "Blizzard_PlayerSpells" then -- Check against your addon name
        StartPlayerSpellsFrameCheck()

        -- Hook the SpecFrame content update (adjust hook point if needed)
        -- Need to find the right place where Spec content is populated/updated
        -- hooksecurefunc("PlayerSpellsSpecFrame_Update", ST_updateSpecContentsHook) -- Example hook point, might need adjustment
        -- It seems ST_updateSpecContentsHook is called from OnShow/OnClick, which might be sufficient if SpecFrame updates then.

        -- Hook the Hero Talent content update
        -- Need to find the right place for this too. Might be triggered by events or function calls.
        -- hooksecurefunc("HeroTalentsSelectionDialog_UpdateSpecContent", ST_updateHeroTalentHook) -- Example

        -- Unregister after first run if only needed once
        -- self:UnregisterEvent("ADDON_LOADED")
    end
end)

-- Example of hooking a Blizzard function if needed (adjust function name as necessary)
-- Replace "SomeBlizzardFunctionThatUpdatesSpecContent" with the actual function name if known
-- hooksecurefunc("SomeBlizzardFunctionThatUpdatesSpecContent", ST_updateSpecContentsHook)
-- hooksecurefunc("SomeBlizzardFunctionThatUpdatesHeroTalentContent", ST_updateHeroTalentHook)

-- Make sure the Start function is called when the addon loads
-- The ADDON_LOADED event handler above should cover this.
