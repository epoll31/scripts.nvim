local M = {}

---@class Scripts.Config
local defaults = {
	scripts_dir = ".nvim",
	scripts_file = "scripts.json",
	storage_dir = vim.fn.stdpath("state") .. "/scripts_storage/", -- directory where session files are saved
	default_behaviour = {
		show_output = true,
	},
	term_output = {
		height = 15,
	},
}

---@type Scripts.Config
---@diagnostic disable-next-line: missing-fields
M.options = {}

---@param opts Scripts.Config | nil
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
	vim.notify(M.options.storage_dir, vim.log.levels.DEBUG)
	vim.fn.mkdir(M.options.storage_dir, "p")
end

return M
