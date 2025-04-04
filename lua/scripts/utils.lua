local run = require("scripts.run")
local storage = require("scripts.storage")

local M = {}

-- SECTION: vim.notify

---@param msg string
function M.info(msg)
	vim.notify(msg, vim.log.levels.INFO)
end

---@param msg string
function M.error(msg)
	vim.notify(msg, vim.log.levels.ERROR)
end

-- SECTION: script picker

---Function that runs after a script is picked
---@param script Script
local function script_picked(script)
	run.run_script(script)
	storage.store(script)
end

---Opens a Telescope picker to allow the user to select a script to run.
---@param scripts table<Script>
function M.picker(scripts)
	local items = {}
	for _, script in ipairs(scripts) do
		table.insert(items, {
			label = script.name,
			cmd = script.cmd,
			script = script,
		})
	end

	vim.ui.select(items, {
		prompt = "Run Script",
		format_item = function(item)
			return string.format("%s (%s)", item.label, item.cmd)
		end,
	}, function(choice)
		if choice then
			script_picked(choice.script)
		end
	end)
end

return M
