local storage = require("scripts.storage")
local utils = require("scripts.utils")
local run = require("scripts.run")
local find_scripts = require("scripts.find_scripts")

local M = {}

---Open a Telescope script picker.
---@param source nil | 'all' | 'history'
function M.picker(source)
	local script_map = find_scripts().scripts
	---@type table<Script>
	local scripts = {}

	for _, script in pairs(script_map) do
		table.insert(scripts, script)
	end

	if source == "history" then
		scripts = storage.get_history()
	end

	if not scripts then
		utils.info("No scripts available.")
		return
	end

	if false then
		utils.info(vim.inspect(scripts))
		return
	end

	utils.picker(scripts)
end

---@class Scripts.RunRecent.Opts
local run_recent_default_opts = {
	open_picker_on_miss = true,
}

---Run the most recently ran script.
---@param opts Scripts.RunRecent.Opts | nil
function M.run_recent(opts)
	opts = vim.tbl_deep_extend("force", {}, run_recent_default_opts, opts or {})

	local prev = storage.get_history()[1]
	if not prev then
		if opts.open_picker_on_miss then
			M.picker("all")
		end
		return
	end

	run.run_script(prev)
end
return M
