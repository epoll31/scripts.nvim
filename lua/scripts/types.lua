---@class Script
---@field cmd string
---@field show_output boolean | nil

---@class ScriptPair
---@field name string
---@field script Script

---@alias ScriptMap table<string, Script>
---@alias ScriptPairs table<ScriptPair>

---@class ScriptFile
---@field scripts ScriptMap

return {}
