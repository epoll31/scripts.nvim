local Config = require("scripts.config")
local api = require("scripts.api")

-- TODO: run last script: run the previously ran script
-- TODO: add option to run not in window

local M = {}

local function setup_autocmds()
	vim.api.nvim_create_user_command("ScriptsPicker", api.picker, {})
	-- vim.api.nvim_create_user_command("RunDefaultScript", api.run.default_script, {})
	-- vim.api.nvim_create_user_command("RunDefaultScriptQuick", api.run.default_script_in_cmdline, {})
end

---@param opts Scripts.Config | nil
function M.setup(opts)
	Config.setup(opts)
	setup_autocmds()
end

return M
