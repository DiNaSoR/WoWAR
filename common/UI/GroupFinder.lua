local addonName, ns = ...

ns = ns or {}
ns.UI = ns.UI or {}
ns.UI.GroupFinder = ns.UI.GroupFinder or {}
local M = ns.UI.GroupFinder

-- Group Finder module (migrated from WoW_Tooltips.lua)

function M.GroupFinder()
  local T = (ns.UI and ns.UI.Translate) or nil
  if not (T and T.Enabled("ui3")) then return end

  T.ApplyUI({
    function() return _G.PVEFrameTitleText end,
    function() return _G.PVEFrameTab1 and _G.PVEFrameTab1.Text end,
    function() return _G.PVEFrameTab2 and _G.PVEFrameTab2.Text end,
    function() return _G.PVEFrameTab3 and _G.PVEFrameTab3.Text end,
    function() return _G.GroupFinderFrameGroupButton2Name end,
    function() return _G.LFDQueueFrameTypeDropDownName end,
    { obj = function() return _G.LFDQueueFrameRandomScrollFrameChildFrameTitle end, font = _G.WOWTR_Font1 },
    { obj = function() return _G.LFDQueueFrameRandomScrollFrameChildFrameRewardsLabel end, font = _G.WOWTR_Font1 },
    function() return _G.LFDQueueFrameFindGroupButton and _G.LFDQueueFrameFindGroupButton.Text end,
    function() return _G.RaidFinderQueueFrameScrollFrameChildFrameDescription end,
    { obj = function() return _G.RaidFinderQueueFrameScrollFrameChildFrameRewardsLabel end, font = _G.WOWTR_Font1 },
    function() return _G.RaidFinderQueueFrameScrollFrameChildFrameRewardsDescription end,
    function() return _G.RaidFinderFrameFindRaidButton and _G.RaidFinderFrameFindRaidButton.Text end,
    function()
      local cs = _G.LFGListFrame and _G.LFGListFrame.CategorySelection
      return cs and cs.StartGroupButton and cs.StartGroupButton.Text
    end,
    function()
      local cs = _G.LFGListFrame and _G.LFGListFrame.CategorySelection
      return cs and cs.FindGroupButton and cs.FindGroupButton.Text
    end,
    { obj = function() return _G.LFGListFrame and _G.LFGListFrame.CategorySelection and _G.LFGListFrame.CategorySelection.Label end, font = _G.WOWTR_Font1 },
    function() return _G.LFGListApplicationDialog and _G.LFGListApplicationDialog.Label end,
    function() return _G.LFGListApplicationDialog and _G.LFGListApplicationDialog.SignUpButton and _G.LFGListApplicationDialog.SignUpButton.Text end,
    function() return _G.LFGListApplicationDialog and _G.LFGListApplicationDialog.CancelButton and _G.LFGListApplicationDialog.CancelButton.Text end,
    function() return _G.LFGListFrame and _G.LFGListFrame.SearchPanel and _G.LFGListFrame.SearchPanel.SignUpButton and _G.LFGListFrame.SearchPanel.SignUpButton.Text end,
    function() return _G.LFGListFrame and _G.LFGListFrame.SearchPanel and _G.LFGListFrame.SearchPanel.BackButton and _G.LFGListFrame.SearchPanel.BackButton.Text end,
    function() return _G.LFGListFrame and _G.LFGListFrame.SearchPanel and _G.LFGListFrame.SearchPanel.CategoryName end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.NameLabel end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.DescriptionLabel end,
    { obj = function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.Label end, font = _G.WOWTR_Font1 },
    function() return _G.LFGListInviteDialog and _G.LFGListInviteDialog.Label end,
    function() return _G.LFGListInviteDialog and _G.LFGListInviteDialog.RoleDescription end,
    function() return _G.LFGListInviteDialog and _G.LFGListInviteDialog.AcceptButton and _G.LFGListInviteDialog.AcceptButton.Text end,
    function() return _G.LFGListInviteDialog and _G.LFGListInviteDialog.DeclineButton and _G.LFGListInviteDialog.DeclineButton.Text end,
    function() return _G.LFGListInviteDialog and _G.LFGListInviteDialog.AcknowledgeButton and _G.LFGListInviteDialog.AcknowledgeButton.Text end,
    { obj = function() return _G.LFDQueueFrameFollowerTitle end, font = _G.WOWTR_Font1 },
    function() return _G.LFDQueueFrameFollowerDescription end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.ListGroupButton and _G.LFGListFrame.EntryCreation.ListGroupButton.Text end,
    function()
      local sp = _G.LFGListFrame and _G.LFGListFrame.SearchPanel
      local sb = sp and sp.ScrollBox
      return sb and sb.StartGroupButton and sb.StartGroupButton.Text
    end,
    function() return _G.LFGListFrame and _G.LFGListFrame.SearchPanel and _G.LFGListFrame.SearchPanel.SearchBox and _G.LFGListFrame.SearchPanel.SearchBox.Instructions end,
    function()
      local sp = _G.LFGListFrame and _G.LFGListFrame.SearchPanel
      local sb = sp and sp.ScrollBox
      return sb and sb.NoResultsFound
    end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.PlayStyleLabel end,
    function() return _G.LFGListCreationDescription and _G.LFGListCreationDescription.EditBox and _G.LFGListCreationDescription.EditBox.Instructions end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.MythicPlusRating and _G.LFGListFrame.EntryCreation.MythicPlusRating.Label end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.ItemLevel and _G.LFGListFrame.EntryCreation.ItemLevel.Label end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.VoiceChat and _G.LFGListFrame.EntryCreation.VoiceChat.Label end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.PrivateGroup and _G.LFGListFrame.EntryCreation.PrivateGroup.Label end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.CrossFactionGroup and _G.LFGListFrame.EntryCreation.CrossFactionGroup.Label end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.Name and _G.LFGListFrame.EntryCreation.Name.Instructions end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.ItemLevel and _G.LFGListFrame.EntryCreation.ItemLevel.EditBox and _G.LFGListFrame.EntryCreation.ItemLevel.EditBox.Instructions end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.VoiceChat and _G.LFGListFrame.EntryCreation.VoiceChat.EditBox and _G.LFGListFrame.EntryCreation.VoiceChat.EditBox.Instructions end,
    function() return _G.LFGListFrame and _G.LFGListFrame.EntryCreation and _G.LFGListFrame.EntryCreation.CancelButton and _G.LFGListFrame.EntryCreation.CancelButton.Text end,
    function() return _G.LFGListApplicationDialogDescription and _G.LFGListApplicationDialogDescription.EditBox and _G.LFGListApplicationDialogDescription.EditBox.Instructions end,
    function() return _G.LFGListFrame and _G.LFGListFrame.ApplicationViewer and _G.LFGListFrame.ApplicationViewer.ScrollBox and _G.LFGListFrame.ApplicationViewer.ScrollBox.NoApplicants end,
    function() return _G.LFGListFrame and _G.LFGListFrame.ApplicationViewer and _G.LFGListFrame.ApplicationViewer.BrowseGroupsButton and _G.LFGListFrame.ApplicationViewer.BrowseGroupsButton.Text end,
    function() return _G.LFGListFrame and _G.LFGListFrame.ApplicationViewer and _G.LFGListFrame.ApplicationViewer.RemoveEntryButton and _G.LFGListFrame.ApplicationViewer.RemoveEntryButton.Text end,
    function() return _G.LFGListFrame and _G.LFGListFrame.ApplicationViewer and _G.LFGListFrame.ApplicationViewer.EditButton and _G.LFGListFrame.ApplicationViewer.EditButton.Text end,
    function() return _G.LFGListFrame and _G.LFGListFrame.SearchPanel and _G.LFGListFrame.SearchPanel.BackToGroupButton and _G.LFGListFrame.SearchPanel.BackToGroupButton.Text end,
    function() return _G.LFGListFrame and _G.LFGListFrame.ApplicationViewer and _G.LFGListFrame.ApplicationViewer.NameColumnHeader and _G.LFGListFrame.ApplicationViewer.NameColumnHeader.Label end,
    function() return _G.LFGListFrame and _G.LFGListFrame.ApplicationViewer and _G.LFGListFrame.ApplicationViewer.RoleColumnHeader and _G.LFGListFrame.ApplicationViewer.RoleColumnHeader.Label end,
  }, { sav = true, prefix = "ui" })

  T.ApplyText({
    { obj = function() return _G.GroupFinderFrameGroupButton1Name end, onlyReverse = true },
    { obj = function() return _G.GroupFinderFrameGroupButton3Name end, onlyReverse = true },
    function() return _G.LFDQueueFrameRandomScrollFrameChildFrameDescription end,
    { obj = function() return _G.LFDQueueFrameRandomScrollFrameChildFrameRewardsDescription end, corr = -10 },
  }, { sav = true, prefix = "ui" })

  -- Category buttons: translation-only (no save), with RTL-aware font selection.
  local categoryList = {}
  for i = 1, 6 do
    categoryList[#categoryList + 1] = {
      obj = function()
        local cs = _G.LFGListFrame and _G.LFGListFrame.CategorySelection
        local btn = cs and cs.CategoryButtons and cs.CategoryButtons[i]
        if btn then return btn.Label or btn end
        return nil
      end,
      font = T.Font,
    }
  end
  T.ApplyUI(categoryList, { sav = false, prefix = "ui" })
end

function M.GroupPVPFinder()
  local T = (ns.UI and ns.UI.Translate) or nil
  if not (T and T.Enabled("ui3")) then return end

  T.ApplyUI({
    function() return _G.PVPQueueFrameCategoryButton1 and _G.PVPQueueFrameCategoryButton1.Name end,
    function() return _G.PVPQueueFrameCategoryButton2 and _G.PVPQueueFrameCategoryButton2.Name end,
    function() return _G.PVPQueueFrameCategoryButton3 and _G.PVPQueueFrameCategoryButton3.Name end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.NewSeasonPopup and _G.PVPQueueFrame.NewSeasonPopup.NewSeason end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.NewSeasonPopup and _G.PVPQueueFrame.NewSeasonPopup.SeasonDescriptionHeader end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.NewSeasonPopup and _G.PVPQueueFrame.NewSeasonPopup.SeasonDescription end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.NewSeasonPopup and _G.PVPQueueFrame.NewSeasonPopup.SeasonRewardText end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.NewSeasonPopup and _G.PVPQueueFrame.NewSeasonPopup.Leave and _G.PVPQueueFrame.NewSeasonPopup.Leave.Text end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.HonorInset and _G.PVPQueueFrame.HonorInset.CasualPanel and _G.PVPQueueFrame.HonorInset.CasualPanel.HKLabel end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.HonorInset and _G.PVPQueueFrame.HonorInset.CasualPanel and _G.PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay and _G.PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay.LevelLabel end,
    function() return _G.HonorFrameQueueButton and _G.HonorFrameQueueButton.Text end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.HonorInset and _G.PVPQueueFrame.HonorInset.RatedPanel and _G.PVPQueueFrame.HonorInset.RatedPanel.Label end,
    function() return _G.PVPQueueFrame and _G.PVPQueueFrame.HonorInset and _G.PVPQueueFrame.HonorInset.RatedPanel and _G.PVPQueueFrame.HonorInset.RatedPanel.Tier and _G.PVPQueueFrame.HonorInset.RatedPanel.Tier.Title end,
    function() return _G.ConquestJoinButtonText end,
    function() return _G.LFGListFrame and _G.LFGListFrame.CategorySelection and _G.LFGListFrame.CategorySelection.Label end,
  }, { sav = true, prefix = "ui" })
end

function M.GroupMplusFinder()
  local T = (ns.UI and ns.UI.Translate) or nil
  if not (T and T.Enabled("ui3")) then return end

  local list = {
    function() return _G.ChallengesFrame and _G.ChallengesFrame.SeasonChangeNoticeFrame and _G.ChallengesFrame.SeasonChangeNoticeFrame.NewSeason end,
    function() return _G.ChallengesFrame and _G.ChallengesFrame.SeasonChangeNoticeFrame and _G.ChallengesFrame.SeasonChangeNoticeFrame.SeasonDescription end,
    function() return _G.ChallengesFrame and _G.ChallengesFrame.SeasonChangeNoticeFrame and _G.ChallengesFrame.SeasonChangeNoticeFrame.SeasonDescription2 end,
    function() return _G.ChallengesFrame and _G.ChallengesFrame.WeeklyInfo and _G.ChallengesFrame.WeeklyInfo.Child and _G.ChallengesFrame.WeeklyInfo.Child.Description end,
    function() return _G.ChallengesFrame and _G.ChallengesFrame.WeeklyInfo and _G.ChallengesFrame.WeeklyInfo.Child and _G.ChallengesFrame.WeeklyInfo.Child.SeasonBest end,
    function() return _G.ChallengesFrame and _G.ChallengesFrame.WeeklyInfo and _G.ChallengesFrame.WeeklyInfo.Child and _G.ChallengesFrame.WeeklyInfo.Child.ThisWeekLabel end,
    function() return _G.ChallengesFrame and _G.ChallengesFrame.WeeklyInfo and _G.ChallengesFrame.WeeklyInfo.Child and _G.ChallengesFrame.WeeklyInfo.Child.WeeklyChest and _G.ChallengesFrame.WeeklyInfo.Child.WeeklyChest.RunStatus end,
    function() return _G.ChallengesFrame and _G.ChallengesFrame.WeeklyInfo and _G.ChallengesFrame.WeeklyInfo.Child and _G.ChallengesFrame.WeeklyInfo.Child.DungeonScoreInfo and _G.ChallengesFrame.WeeklyInfo.Child.DungeonScoreInfo.Title end,
  }

  if ns.RTL and ns.RTL.IsRTL and ns.RTL.IsRTL() then
    T.ApplyText(list, { sav = true, prefix = "ui", corr = -10 })
  else
    T.ApplyUI(list, { sav = true, prefix = "ui" })
  end
end

return M