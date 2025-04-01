local config = require("scripts.config")
local api = require("scripts.api")

local M = {}

local function setup_autocmds()
	vim.api.nvim_create_user_command("ScriptsPicker", function(opts)
		api.picker(opts.fargs[1])
	end, {
		nargs = "*",
		desc = "Open a Telescope picker to select which script to run.",
	})
	vim.api.nvim_create_user_command("ScriptsRunPrevious", api.run_recent, {
		desc = "Rerun the previously ran script.",
	})
end

---@param opts Scripts.Config | nil
function M.setup(opts)
	config.setup(opts)
	setup_autocmds()
end

return M
