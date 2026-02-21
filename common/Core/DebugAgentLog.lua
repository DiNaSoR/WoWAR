-- DebugAgentLog.lua
-- NDJSON debug/dump storage in SavedVariables.

local addonName, ns = ...
ns = ns or {}
ns.Core = ns.Core or {}
local Core = ns.Core

Core.DebugAgentLog = Core.DebugAgentLog or {}
local Agent = Core.DebugAgentLog

local function _agentJsonEscape(v)
  local s = tostring(v)
  s = s:gsub("\\", "\\\\")
       :gsub("\"", "\\\"")
       :gsub("\n", "\\n")
       :gsub("\r", "\\r")
       :gsub("\t", "\\t")
  return s
end

local function _agentJsonValue(v)
  local t = type(v)
  if v == nil then return "null" end
  if t == "number" then return tostring(v) end
  if t == "boolean" then return v and "true" or "false" end
  if t == "string" then return "\"" .. _agentJsonEscape(v) .. "\"" end
  return "\"" .. _agentJsonEscape(tostring(v)) .. "\""
end

local function _agentJsonObject(obj)
  if type(obj) ~= "table" then return "{}" end
  local parts = {}
  for k, v in pairs(obj) do
    if type(k) == "string" then
      parts[#parts + 1] = "\"" .. _agentJsonEscape(k) .. "\":" .. _agentJsonValue(v)
    end
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function _agentGetRunId()
  local db = rawget(_G, "WOWTR_DB")
  local rid = db and db.global and db.global.agentDebugRunId
  if type(rid) == "string" and rid ~= "" then return rid end
  return "run1"
end

local function _agentEnsureStore()
  _G.WOWTR_DB = _G.WOWTR_DB or {}
  _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
  _G.WOWTR_DB.global.agentDebugNDJSON = _G.WOWTR_DB.global.agentDebugNDJSON or {}
  _G.WOWTR_DB.global.agentDebugNDJSONMax = _G.WOWTR_DB.global.agentDebugNDJSONMax or 250
  return _G.WOWTR_DB.global.agentDebugNDJSON, _G.WOWTR_DB.global.agentDebugNDJSONMax
end

local function _agentEnsureDumpStore()
  _G.WOWTR_DB = _G.WOWTR_DB or {}
  _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
  _G.WOWTR_DB.global.agentDumpNDJSON = _G.WOWTR_DB.global.agentDumpNDJSON or {}
  _G.WOWTR_DB.global.agentDumpNDJSONMax = _G.WOWTR_DB.global.agentDumpNDJSONMax or 10000
  return _G.WOWTR_DB.global.agentDumpNDJSON, _G.WOWTR_DB.global.agentDumpNDJSONMax
end

function Agent.AgentLog(hypothesisId, location, message, data)
  local store, maxN = _agentEnsureStore()
  if type(store) ~= "table" then return end

  local ts = time and (time() * 1000) or 0
  local payload = {
    sessionId = "debug-session",
    runId = _agentGetRunId(),
    hypothesisId = hypothesisId or "UNKNOWN",
    location = location or "unknown",
    message = message or "",
    timestamp = ts,
  }

  local json =
    "{" ..
    "\"sessionId\":" .. _agentJsonValue(payload.sessionId) .. "," ..
    "\"runId\":" .. _agentJsonValue(payload.runId) .. "," ..
    "\"hypothesisId\":" .. _agentJsonValue(payload.hypothesisId) .. "," ..
    "\"location\":" .. _agentJsonValue(payload.location) .. "," ..
    "\"message\":" .. _agentJsonValue(payload.message) .. "," ..
    "\"data\":" .. _agentJsonObject(data) .. "," ..
    "\"timestamp\":" .. _agentJsonValue(payload.timestamp) ..
    "}"

  store[#store + 1] = json
  if #store > maxN then
    table.remove(store, 1)
  end
end

function Agent.AgentDumpLog(hypothesisId, location, message, data)
  local store, maxN = _agentEnsureDumpStore()
  if type(store) ~= "table" then return end

  local ts = time and (time() * 1000) or 0
  local payload = {
    sessionId = "debug-session",
    runId = _agentGetRunId(),
    hypothesisId = hypothesisId or "DUMP",
    location = location or "unknown",
    message = message or "",
    timestamp = ts,
  }

  local json =
    "{" ..
    "\"sessionId\":" .. _agentJsonValue(payload.sessionId) .. "," ..
    "\"runId\":" .. _agentJsonValue(payload.runId) .. "," ..
    "\"hypothesisId\":" .. _agentJsonValue(payload.hypothesisId) .. "," ..
    "\"location\":" .. _agentJsonValue(payload.location) .. "," ..
    "\"message\":" .. _agentJsonValue(payload.message) .. "," ..
    "\"data\":" .. _agentJsonObject(data) .. "," ..
    "\"timestamp\":" .. _agentJsonValue(payload.timestamp) ..
    "}"

  store[#store + 1] = json
  if #store > maxN then
    table.remove(store, 1)
  end
end

-- Clear SavedVariables stores (agentDebugNDJSON / agentDumpNDJSON) to avoid buildup.
-- We intentionally write a post-clear marker log so exports can prove the clear happened.
function Agent.ClearAgentLogs(msg)
  msg = (msg or ""):lower()
  local mode = msg:match("^%s*(%S+)")
  if mode == nil or mode == "" then mode = "all" end

  local function wipeTable(t)
    if type(t) ~= "table" then return 0 end
    local n = 0
    for k in pairs(t) do
      t[k] = nil
      n = n + 1
    end
    return n
  end

  local db = rawget(_G, "WOWTR_DB")
  local g = db and db.global
  local debugT = g and g.agentDebugNDJSON
  local dumpT = g and g.agentDumpNDJSON
  local beforeDebug = (type(debugT) == "table" and #debugT) or 0
  local beforeDump = (type(dumpT) == "table" and #dumpT) or 0

  Agent.AgentLog("H7", "common/Core/DebugAgentLog.lua:ClearAgentLogs", "before_clear", {
    mode = mode,
    debugN = beforeDebug,
    dumpN = beforeDump,
  })

  local clearedDebug, clearedDump, clearedCache = false, false, false

  if mode == "all" or mode == "debug" then
    _G.WOWTR_DB = _G.WOWTR_DB or {}
    _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
    if type(_G.WOWTR_DB.global.agentDebugNDJSON) ~= "table" then
      _G.WOWTR_DB.global.agentDebugNDJSON = {}
    else
      wipeTable(_G.WOWTR_DB.global.agentDebugNDJSON)
    end
    clearedDebug = true
  end

  if mode == "all" or mode == "dump" then
    _G.WOWTR_DB = _G.WOWTR_DB or {}
    _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
    if type(_G.WOWTR_DB.global.agentDumpNDJSON) ~= "table" then
      _G.WOWTR_DB.global.agentDumpNDJSON = {}
    else
      wipeTable(_G.WOWTR_DB.global.agentDumpNDJSON)
    end
    clearedDump = true
  end

  if mode == "all" or mode == "cache" or mode == "dedupe" then
    if Core.DebugDump and Core.DebugDump.ClearSeenCache then
      Core.DebugDump.ClearSeenCache()
      clearedCache = true
    end
  end

  local afterDebug = (_G.WOWTR_DB and _G.WOWTR_DB.global and type(_G.WOWTR_DB.global.agentDebugNDJSON) == "table" and #_G.WOWTR_DB.global.agentDebugNDJSON) or 0
  local afterDump = (_G.WOWTR_DB and _G.WOWTR_DB.global and type(_G.WOWTR_DB.global.agentDumpNDJSON) == "table" and #_G.WOWTR_DB.global.agentDumpNDJSON) or 0

  Agent.AgentLog("H7", "common/Core/DebugAgentLog.lua:ClearAgentLogs", "after_clear", {
    mode = mode,
    clearedDebug = clearedDebug,
    clearedDump = clearedDump,
    clearedCache = clearedCache,
    debugN_before = beforeDebug,
    dumpN_before = beforeDump,
    debugN_after = afterDebug,
    dumpN_after = afterDump,
  })

  local parts = {}
  if clearedDebug then parts[#parts + 1] = "debug" end
  if clearedDump then parts[#parts + 1] = "dump" end
  if clearedCache then parts[#parts + 1] = "dedupeCache" end

  if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Logs]|r Cleared: " .. table.concat(parts, ", ") .. " (note: 1 post-clear marker log is written).")
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[WoWAR Logs]|r Run |cFFFFD700/reload|r to flush SavedVariables, then export via |cFFFFD700Tools/ExportAgentDebugLog.ps1|r.")
  end
end

-- Clear prior agent logs at addon load; they are already flushed to disk on /reload before this runs.
do
  pcall(function()
    _G.WOWTR_DB = _G.WOWTR_DB or {}
    _G.WOWTR_DB.global = _G.WOWTR_DB.global or {}
    _G.WOWTR_DB.global.agentDebugNDJSON = {}
    _G.WOWTR_DB.global.agentDumpNDJSON = {}
    _G.WOWTR_DB.global.agentDebugRunId = "t" .. tostring(time and time() or 0)
  end)
end

return Agent
