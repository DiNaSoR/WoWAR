-------------------------------------------------------------------------------------------------------
-- Professions Module for WoWTranslation Addon
-- Handles translation and UI modifications for Blizzard's Profession Frames.
-- Depends on global functions/variables:
--   ST_CheckAndReplaceTranslationTextUI, ST_CheckAndReplaceTranslationText, ST_RenkKoduSil,
--   ST_OriginalTextCache, ST_OriginalFontCache, ST_OriginalJustifyCache, StartTicker,
--   WoWTR_Localization, QTR_ReverseIfAR, NONBREAKINGSPACE, TT_PS
-------------------------------------------------------------------------------------------------------

local addonName, ns = ...
ns = ns or {}
local UI = ns.UI and ns.UI.Translate
local RTL = ns.RTL

local function isRTL()
    return (RTL and RTL.IsRTL and RTL.IsRTL()) or false
end

-------------------------------------------------------------------------------------------------------
-- ProfessionsFrame Logic (Main Profession Window)
-------------------------------------------------------------------------------------------------------

-- Reverts text elements within ProfessionsFrame to their original state
function ST_revertProfessionDescription()
    local elementsToRevert = {
        ProfessionsFrame.CraftingPage.SchematicForm.Description,
        ProfessionsFrame.SpecPage.TreeView.TreeDescription,
        ProfessionsFrame.SpecPage.TreePreview.Description,
        ProfessionsFrame.SpecPage.TreePreview.Highlight1.Description,
        ProfessionsFrame.SpecPage.TreePreview.Highlight2.Description,
        ProfessionsFrame.SpecPage.TreePreview.Highlight3.Description,
        ProfessionsFrame.SpecPage.TreePreview.Highlight4.Description,
        ProfessionsFrame.CraftingPage.SchematicForm.Details.Label,
        ProfessionsFrame.SpecPage.TreePreview.HighlightsHeader,
        ProfessionsFrame.SpecPage.ViewPreviewButton.Text,
        ProfessionsFrame.SpecPage.BackToFullTreeButton.Text,
        ProfessionsFrame.SpecPage.DetailedView.SpendPointsButton.Text,
        ProfessionsFrame.SpecPage.DetailedView.UnlockPathButton.Text,
        ProfessionsFrame.SpecPage.ApplyButton.Text,
        ProfessionsFrame.SpecPage.ViewTreeButton.Text,
        ProfessionsFrame.CraftingPage.SchematicForm.Details.CraftingChoicesContainer.FinishingReagentSlotContainer.Label,
        ProfessionsFrame.CraftingPage.SchematicForm.FirstCraftBonus.Text,
        ProfessionsFrame.CraftingPage.SchematicForm.RecipeSourceButton.Text,
        ProfessionsFrame.CraftingPage.SchematicForm.Reagents.Label,
        ProfessionsFrame.CraftingPage.SchematicForm.OptionalReagents.Label,
        ProfessionsFrame.CraftingPage.SchematicForm.RecraftingDescription,
        ProfessionsFrame.SpecPage.UnlockTabButton.Text,
        ProfessionsFrame.CraftingPage.RecipeList.FilterDropdown.Text
        -- Add other elements handled by ST_showProfessionDescription if missed
    }

    for _, element in ipairs(elementsToRevert) do
        if element and element.GetText and element.SetText then
            local currentText = element:GetText()
            if currentText and (string.find(currentText, NONBREAKINGSPACE) or ST_OriginalTextCache[element]) then
                local originalText = ST_OriginalTextCache[element]
                local originalFontInfo = ST_OriginalFontCache[element]
                local originalJustifyH = ST_OriginalJustifyCache[element]

                if originalText then
                    element:SetText(originalText)
                    if element.SetFont and originalFontInfo then
                       pcall(element.SetFont, element, unpack(originalFontInfo))
                    end
                    if element.SetJustifyH and originalJustifyH then
                        pcall(element.SetJustifyH, element, originalJustifyH)
                    end
                end
            end
        end
    end
end

-- Translates text elements within ProfessionsFrame based on the toggle state
function ST_showProfessionDescription()
    -- Ensure TT_PS exists (should be global or initialized elsewhere)
    TT_PS = TT_PS or {}
    TT_PS.ui7 = TT_PS.ui7 or "1" -- Default to translated if setting doesn't exist

    if (TT_PS["ui7"] == "1") then
        -- Translate various elements using ST_CheckAndReplaceTranslationTextUI or ST_CheckAndReplaceTranslationText
        -- (Keeping the detailed list collapsed for brevity, the logic remains the same as before)
        local prof_title = ProfessionsFrame.CraftingPage.SchematicForm.OutputText:GetText() or "?";
        local prof_name = ProfessionsFrameTitleText:GetText() or "?";
        local prof_prefix = "Profession:"..ST_RenkKoduSil(prof_name)..":"
        local rtl = isRTL()
        local rtlFont = rtl and WOWTR_Font2 or nil
        local rtlCorr = rtl and -5 or nil
        local rtlJustify = rtl and "RIGHT" or nil

        ST_CheckAndReplaceTranslationText(ProfessionsFrame.CraftingPage.SchematicForm.Description, true, prof_prefix..ST_RenkKoduSil(prof_title));
        ST_CheckAndReplaceTranslationText(ProfessionsFrame.SpecPage.TreeView.TreeDescription, false, "", rtlFont, false, rtlCorr, rtlJustify);
        ST_CheckAndReplaceTranslationText(ProfessionsFrame.SpecPage.TreePreview.Description, false, "", rtlFont, false, rtlCorr, rtlJustify);
        ST_CheckAndReplaceTranslationText(ProfessionsFrame.SpecPage.TreePreview.Highlight1.Description, true, prof_prefix.."Other", rtlFont, false, rtlCorr, rtlJustify);
        ST_CheckAndReplaceTranslationText(ProfessionsFrame.SpecPage.TreePreview.Highlight2.Description, true, prof_prefix.."Other", rtlFont, false, rtlCorr, rtlJustify);
        ST_CheckAndReplaceTranslationText(ProfessionsFrame.SpecPage.TreePreview.Highlight3.Description, true, prof_prefix.."Other", rtlFont, false, rtlCorr, rtlJustify);
        ST_CheckAndReplaceTranslationText(ProfessionsFrame.SpecPage.TreePreview.Highlight4.Description, true, prof_prefix.."Other", rtlFont, false, rtlCorr, rtlJustify);

        if UI and UI.ApplyUI then
            UI.ApplyUI({
                ProfessionsFrame.CraftingPage.SchematicForm.Details.Label,
                ProfessionsFrame.SpecPage.TreePreview.HighlightsHeader,
                ProfessionsFrame.SpecPage.ViewPreviewButton.Text,
                ProfessionsFrame.SpecPage.BackToFullTreeButton.Text,
                ProfessionsFrame.SpecPage.DetailedView.SpendPointsButton.Text,
                ProfessionsFrame.SpecPage.DetailedView.UnlockPathButton.Text,
                ProfessionsFrame.SpecPage.ApplyButton.Text,
                ProfessionsFrame.SpecPage.ViewTreeButton.Text,
                ProfessionsFrame.CraftingPage.SchematicForm.Details.CraftingChoicesContainer.FinishingReagentSlotContainer.Label,
                ProfessionsFrame.CraftingPage.SchematicForm.FirstCraftBonus.Text,
                ProfessionsFrame.CraftingPage.SchematicForm.RecipeSourceButton.Text,
                ProfessionsFrame.CraftingPage.SchematicForm.Reagents.Label,
                ProfessionsFrame.CraftingPage.SchematicForm.OptionalReagents.Label,
                ProfessionsFrame.CraftingPage.SchematicForm.RecraftingDescription,
                ProfessionsFrame.SpecPage.UnlockTabButton.Text,
            }, { sav = true, prefix = "Profession:Other" })

            UI.ApplyUI({
                ProfessionsFrame.CraftingPage.RecipeList.FilterDropdown.Text,
            }, { sav = true, prefix = "ui" })
        else
            -- Fallback to legacy direct calls
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.CraftingPage.SchematicForm.Details.Label, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.SpecPage.TreePreview.HighlightsHeader, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.SpecPage.ViewPreviewButton.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.SpecPage.BackToFullTreeButton.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.SpecPage.DetailedView.SpendPointsButton.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.SpecPage.DetailedView.UnlockPathButton.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.SpecPage.ApplyButton.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.SpecPage.ViewTreeButton.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.CraftingPage.SchematicForm.Details.CraftingChoicesContainer.FinishingReagentSlotContainer.Label, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.CraftingPage.SchematicForm.FirstCraftBonus.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.CraftingPage.SchematicForm.RecipeSourceButton.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.CraftingPage.SchematicForm.Reagents.Label, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.CraftingPage.SchematicForm.OptionalReagents.Label, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.CraftingPage.SchematicForm.RecraftingDescription, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.SpecPage.UnlockTabButton.Text, true, "Profession:Other");
            ST_CheckAndReplaceTranslationTextUI(ProfessionsFrame.CraftingPage.RecipeList.FilterDropdown.Text, true, "ui");
        end
    else
        -- Revert translations if toggle is off
        ST_revertProfessionDescription()
    end
end

-- State variables for the toggle button
local isProfButtonCreated = false
local ProfupdateVisibility -- Holds the function returned by CreateToggleButton

-- Creates/Updates the toggle button on the ProfessionsFrame
function ST_ProfDescbutton()
    if not isProfButtonCreated then
        TT_PS = TT_PS or { ui7 = "1" } -- Initialize settings if they don't exist

        ProfupdateVisibility = CreateToggleButton(
           ProfessionsFrame,
           TT_PS,
           "ui7",
           WoWTR_Localization.WoWTR_enDESC,
           WoWTR_Localization.WoWTR_trDESC,
           {"TOPLEFT", ProfessionsFrame, "TOPRIGHT", -170, 0},
           function() -- OnClick handler
                 if ST_showProfessionDescription then
                     ST_showProfessionDescription() -- Translate or revert based on new state
                 end
                 -- Optional: Force refresh complex parts
                 if ProfessionsFrame.CraftingPage and ProfessionsFrame.CraftingPage.SchematicForm and ProfessionsFrame.CraftingPage.SchematicForm:IsVisible() then
                    C_Timer.After(0.01, function()
                        ProfessionsFrame.CraftingPage.SchematicForm:Hide()
                        ProfessionsFrame.CraftingPage.SchematicForm:Show()
                    end)
                 end
                 if ProfessionsFrame.SpecPage and ProfessionsFrame.SpecPage.TreeView and ProfessionsFrame.SpecPage.TreeView:IsVisible() then
                    C_Timer.After(0.01, function()
                        ProfessionsFrame.SpecPage.TreeView:Hide()
                        ProfessionsFrame.SpecPage.TreeView:Show()
                    end)
                 end
           end
        )
        isProfButtonCreated = true
    end

    -- Update button visibility based on current state
    if ProfupdateVisibility then
        ProfupdateVisibility()
    end
end

-------------------------------------------------------------------------------------------------------
-- ProfessionsBookFrame Logic (Smaller profession list in Spellbook)
-------------------------------------------------------------------------------------------------------

-- Translates the "missing profession" text in the ProfessionsBookFrame
function ST_ProfessionEmptyText()
    -- Ensure TT_PS exists (should be global or initialized elsewhere)
    TT_PS = TT_PS or {}
    TT_PS.ui1 = TT_PS.ui1 or "1" -- Assuming ui1 controls general UI translation

    if (TT_PS["ui1"] == "1") then
       -- Global frame names (often used for templates/placeholders)
       ST_CheckAndReplaceTranslationTextUI(PrimaryProfession1Missing, true, "Profession:Other");
       ST_CheckAndReplaceTranslationTextUI(PrimaryProfession2Missing, true, "Profession:Other");

       -- Specific frame.property access for the actual displayed text
       local function safeTranslateMissingText(frame, frameName)
           if frame and frame.missingText then
               local element = frame.missingText
               ST_CheckAndReplaceTranslationText(element, true, "Profession:Other", false, false, -15);
               if isRTL() then
                   pcall(function() element:SetFont(WOWTR_Font2, (frameName:find("Secondary") and 10 or 11)) end)
                   pcall(function() element:SetJustifyH("RIGHT") end)
               end
           -- else -- Debug
              -- print("DEBUG: " .. frameName .. ".missingText not found or nil")
           end
       end

       safeTranslateMissingText(PrimaryProfession1, "PrimaryProfession1")
       safeTranslateMissingText(PrimaryProfession2, "PrimaryProfession2")
       safeTranslateMissingText(SecondaryProfession1, "SecondaryProfession1")
       safeTranslateMissingText(SecondaryProfession2, "SecondaryProfession2")
       safeTranslateMissingText(SecondaryProfession3, "SecondaryProfession3")
    end
 end

-------------------------------------------------------------------------------------------------------
-- Initialization & Hooking Logic
-------------------------------------------------------------------------------------------------------

local professionFrameCheckTimer
local professionsHooked = false -- Track if ProfessionsFrame hooks are set
local professionsBookHooked = false -- Track if ProfessionsBookFrame hooks are set

-- Hooks the main ProfessionsFrame (Blizzard_Professions)
local function CheckAndHookProfessionsFrame()
    if ProfessionsFrame and not ProfessionsFrame.hooked then
        if _G.ST_showProfessionDescription or ST_showProfessionDescription then
            ProfessionsFrame:HookScript("OnShow", function()
                if _G.StartTicker then
                    _G.StartTicker(ProfessionsFrame, (_G.ST_showProfessionDescription or ST_showProfessionDescription), 0)
                end
            end)
        end
        if _G.ST_ProfDescbutton or ST_ProfDescbutton then
            ProfessionsFrame:HookScript("OnShow", (_G.ST_ProfDescbutton or ST_ProfDescbutton))
        end

        ProfessionsFrame.hooked = true
        professionsHooked = true
        return true
    end
    return false
end

-- Starts a timer to wait for ProfessionsFrame if not immediately available
local function StartProfessionsFrameCheck()
    if not professionsHooked and not professionFrameCheckTimer then
        professionFrameCheckTimer = C_Timer.NewTicker(1, function()
            if CheckAndHookProfessionsFrame() then
                if professionFrameCheckTimer then
                    professionFrameCheckTimer:Cancel()
                    professionFrameCheckTimer = nil
                end
            end
        end)
    end
end

-- Hooks the ProfessionsBookFrame (Blizzard_ProfessionsBook)
local function HookProfessionsBookFrame()
    if ProfessionsBookFrame and not professionsBookHooked then
        if _G.ST_ProfessionEmptyText or ST_ProfessionEmptyText then
            ProfessionsBookFrame:HookScript("OnShow", function()
                if _G.StartTicker then
                    _G.StartTicker(ProfessionsBookFrame, (_G.ST_ProfessionEmptyText or ST_ProfessionEmptyText), 0.02)
                end
            end)
            professionsBookHooked = true
        end
    end
end

-- Frame to handle ADDON_LOADED events for this module
local ProfessionsLoaderFrame = CreateFrame("Frame")
ProfessionsLoaderFrame:RegisterEvent("ADDON_LOADED")
ProfessionsLoaderFrame:SetScript("OnEvent", function(self, event, addonName)
    local bothHooked = false -- Flag to check if we can unregister

    if addonName == "Blizzard_Professions" then
        if not CheckAndHookProfessionsFrame() then
            StartProfessionsFrameCheck()
        end
    elseif addonName == "Blizzard_ProfessionsBook" then
        HookProfessionsBookFrame()
    else
        return -- Ignore other addons
    end

    -- Check if both are now hooked after processing the current event
    if professionsHooked and professionsBookHooked then
        --print("Professions.lua: Both frames hooked, unregistering ADDON_LOADED.") -- Debug
        self:UnregisterEvent("ADDON_LOADED")
        -- Also cancel the timer if it's still running (e.g., Book loaded before Frame was ready)
        if professionFrameCheckTimer then
             --print("Professions.lua: Cancelling check timer as both frames are hooked.") -- Debug
             professionFrameCheckTimer:Cancel()
             professionFrameCheckTimer = nil
        end
    end
end)