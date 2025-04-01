local parser = require("scripts.parser")
local config = require("scripts.config")

---Finds the scripts filepath
---@return string | nil
local function find_filepath()
	local scripts_dir = vim.fs.find(config.options.scripts_dir, { upward = true, type = "directory" })[1]

	if not scripts_dir then
		return nil
	end

	local scripts_file = config.options.scripts_file

	return vim.fs.joinpath(scripts_dir, scripts_file)
end

---@return ScriptFile | nil
function FindScripts()
	local filepath = find_filepath()
	if not filepath then
		return nil
	end

	return parser.parse(filepath)
end

return FindScripts
