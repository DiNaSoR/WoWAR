-- Template for a new Config Tab (copy me)
-------------------------------------------------------------------------------------------------------

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.Groups = WOWTR.Config.Groups or {}

-- Replace MyFeature with your group name
function WOWTR.Config.Groups.MyFeature()
  return {
    type = "group", order = 99,
    name = function() return QTR_ReverseIfAR("My Feature") end,
    get = function(info) return WOWTR.db.profile.myfeature and WOWTR.db.profile.myfeature[info[#info]] end,
    set = function(info, val)
      WOWTR.db.profile.myfeature = WOWTR.db.profile.myfeature or {}
      WOWTR.db.profile.myfeature[info[#info]] = val
      WOWTR.Config.NotifyChange()
      WOWTR.Config.SyncGlobalsFromDB()
    end,
    args = {
      enabled = { type = "toggle", name = QTR_ReverseIfAR("Enable"), order = 1 },
      level   = { type = "range",  name = QTR_ReverseIfAR("Level"), min = 1, max = 10, step = 1, order = 2 },
    },
  }
end

