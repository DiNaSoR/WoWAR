-- DebugSchema.lua
-- Canonical debug schema: categories, verbosity, badges, and presets.

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

Core.DebugSchema = Core.DebugSchema or {}
local Schema = Core.DebugSchema

Schema.Categories = Schema.Categories or {
  QUESTS = "quests",
  GOSSIP = "gossip",
  TOOLTIPS = "tooltips",
  BOOKS = "books",
  MOVIES = "movies",
  BUBBLES = "bubbles",
  CHAT = "chat",
  CONFIG = "config",
  GENERAL = "general",
}

Schema.CategoryOrder = Schema.CategoryOrder or {
  "quests",
  "gossip",
  "tooltips",
  "books",
  "movies",
  "bubbles",
  "chat",
  "config",
  "general",
}

Schema.CategoryMeta = Schema.CategoryMeta or {
  quests = { tag = "QST", label = "Quests", color = "|cFF4DB8FF", rgb = { 0.30, 0.72, 1.00 } },
  gossip = { tag = "GSP", label = "Gossip", color = "|cFFFF9EC7", rgb = { 1.00, 0.62, 0.78 } },
  tooltips = { tag = "TIP", label = "Tooltips", color = "|cFFBB80FF", rgb = { 0.73, 0.50, 1.00 } },
  books = { tag = "BKS", label = "Books", color = "|cFFFFB347", rgb = { 1.00, 0.70, 0.28 } },
  movies = { tag = "MOV", label = "Movies", color = "|cFF5AE55A", rgb = { 0.35, 0.90, 0.35 } },
  bubbles = { tag = "BBL", label = "Bubbles", color = "|cFF87CEEB", rgb = { 0.53, 0.81, 0.92 } },
  chat = { tag = "CHT", label = "Chat", color = "|cFFFFD700", rgb = { 1.00, 0.84, 0.00 } },
  config = { tag = "CFG", label = "Config", color = "|cFFDDA0DD", rgb = { 0.87, 0.63, 0.87 } },
  general = { tag = "GEN", label = "General", color = "|cFFFFFFFF", rgb = { 1.00, 1.00, 1.00 } },
}

Schema.Verbosity = Schema.Verbosity or {
  NONE = 0,
  ERRORS = 1,
  MINIMAL = 2,
  NORMAL = 3,
  VERBOSE = 4,
}

Schema.VerbosityMeta = Schema.VerbosityMeta or {
  [0] = { name = "OFF", color = "|cFF666666", rgb = { 0.40, 0.40, 0.40 } },
  [1] = { name = "ERR", color = "|cFFFF4444", rgb = { 1.00, 0.27, 0.27 } },
  [2] = { name = "MIN", color = "|cFFFFAA00", rgb = { 1.00, 0.67, 0.00 } },
  [3] = { name = "INF", color = "|cFF00FF88", rgb = { 0.00, 1.00, 0.53 } },
  [4] = { name = "VRB", color = "|cFF9999FF", rgb = { 0.60, 0.60, 1.00 } },
}

Schema.SeverityBadges = Schema.SeverityBadges or {
  [1] = { icon = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:12:12:0:0|t", label = "ERR", color = "|cFFFF4444" },
  [2] = { icon = "|TInterface\\RaidFrame\\ReadyCheck-Waiting:12:12:0:0|t", label = "MIN", color = "|cFFFFAA00" },
  [3] = { icon = "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12:0:0|t", label = "INF", color = "|cFF00FF88" },
  [4] = { icon = "", label = "VRB", color = "|cFF9999FF" },
}

Schema.PresetOrder = Schema.PresetOrder or {
  "off",
  "minimal",
  "quest-investigation",
  "ui-dump",
  "full-trace",
}

Schema.Presets = Schema.Presets or {
  off = { enabled = false },
  minimal = {
    enabled = true,
    categories = {
      quests = 2, gossip = 2, tooltips = 2, books = 2, movies = 2,
      bubbles = 2, chat = 2, config = 2, general = 2,
    },
  },
  ["quest-investigation"] = {
    enabled = true,
    categories = {
      quests = 4, gossip = 4, tooltips = 2, books = 1, movies = 1,
      bubbles = 1, chat = 2, config = 2, general = 2,
    },
  },
  ["ui-dump"] = {
    enabled = true,
    categories = {
      quests = 2, gossip = 2, tooltips = 4, books = 4, movies = 2,
      bubbles = 4, chat = 2, config = 2, general = 4,
    },
  },
  ["full-trace"] = {
    enabled = true,
    categories = {
      quests = 4, gossip = 4, tooltips = 4, books = 4, movies = 4,
      bubbles = 4, chat = 4, config = 4, general = 4,
    },
  },
}

function Schema.GetPresetNames()
  local out = {}
  for i = 1, #Schema.PresetOrder do
    out[i] = Schema.PresetOrder[i]
  end
  return out
end

return Schema
