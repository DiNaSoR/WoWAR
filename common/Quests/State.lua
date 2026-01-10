-- Quests/State.lua
-- Centralized state tables and constants used by quest modules and plugins

local addonName, ns = ...
ns = ns or {}
ns.Quests = ns.Quests or {}
ns.Quests.State = ns.Quests.State or {}
local S = ns.Quests.State

-- English (original) labels for fallback/reset
QTR_MessOrig = {
  details    = "Description",
  objectives = "Quest Objectives",
  rewards    = "Rewards",
  itemchoose0= "You will receive:",
  itemchoose1= "You will be able to choose one of these rewards:",
  itemchoose2= "Choose one of these rewards:",
  itemchoose3= "You receiving the reward:",
  itemreceiv0= "You will receive:",
  itemreceiv1= "You will also receive:",
  itemreceiv2= "You receiving the reward:",
  itemreceiv3= "You also receiving the reward:",
  learnspell = "Learn Spell:",
  reqmoney   = "Required Money:",
  reqitems   = "Required items:",
  experience = "Experience:",
  currquests = "Current Quests",
  avaiquests = "Available Quests",
  reward_aura       = "The following will be cast on you:",
  reward_spell      = "You will learn the following:",
  reward_companion  = "You will gain these Companions:",
  reward_follower   = "You will gain these followers:",
  reward_reputation = "Reputation awards:",
  reward_title      = "You shall be granted the title:",
  reward_tradeskill = "You will learn how to create::",
  reward_unlock     = "You will unlock access to the following:",
  reward_bonus      = "Completing this quest while in Party Sync may reward:",
}

-- Runtime state
QTR_quest_ID = QTR_quest_ID or 0
QTR_quest_EN = QTR_quest_EN or {}
QTR_quest_LG = QTR_quest_LG or {}
QTR_quest_EN[0] = QTR_quest_EN[0] or {}
QTR_quest_LG[0] = QTR_quest_LG[0] or {}

QTR_goss_optionsEN = QTR_goss_optionsEN or {}
QTR_goss_optionsTR = QTR_goss_optionsTR or {}

GossipDUI_LN = GossipDUI_LN or {}
GossipDUI_EN = GossipDUI_EN or {}
Gossip2DUI_LN = Gossip2DUI_LN or {}
Gossip2DUI_EN = Gossip2DUI_EN or {}

QTR_curr_trans = QTR_curr_trans or "1"
QTR_curr_goss = QTR_curr_goss or "X"
QTR_curr_hash = QTR_curr_hash or 0
QTR_first_show = QTR_first_show or 0
QTR_first_show2 = QTR_first_show2 or 0
QTR_PrepareTime = QTR_PrepareTime or 0
QTR_ModelTextHash = QTR_ModelTextHash or 0
QTR_ModelText_EN = QTR_ModelText_EN or ""
QTR_ModelText_PL = QTR_ModelText_PL or ""
quest_numReward = quest_numReward or {}
QTR_curr_dialog = QTR_curr_dialog or "1"

-- Original Blizzard font fallbacks
Original_Font1 = Original_Font1 or "Fonts\\MORPHEUS.ttf"
Original_Font2 = Original_Font2 or "Fonts\\FRIZQT__.ttf"

-- UI handles registry (preferred over globals for intra-module access)
S.ui = S.ui or {}
S.ui.gossip = S.ui.gossip or {}
S.ui.quest = S.ui.quest or {}

