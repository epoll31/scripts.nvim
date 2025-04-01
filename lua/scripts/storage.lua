local config = require("scripts.config")
local find_scripts = require("scripts.find_scripts")

local M = {}

---Get full storage filepath
---@return string
function M.get_filepath()
	local name = vim.fn.getcwd():gsub("[\\/:]+", "%%") .. ".txt"
	local fullname = config.options.storage_dir .. name
	return vim.fs.normalize(fullname)
end

---Get history based on `cwd`
---@return table<Script>
function M.get_history()
	local scripts = find_scripts().scripts
	local filepath = M.get_filepath()
	local lines = {}
	---@type table<Script>
	local history = {}

	if vim.fn.filereadable(filepath) == 1 then
		lines = vim.fn.readfile(filepath)
	end

	local seen = {}
	for _, line in ipairs(lines) do
		-- print(line, not seen[line], not scripts[line])
		if not seen[line] and scripts and scripts[line] then
			table.insert(history, scripts[line])
			seen[line] = true
		end
	end

	return history
end

---Store a specified `script` in the `storage_dir`
--- - Store the `script.name`
---@param script Script The script to store in history
function M.store(script)
	local filepath = M.get_filepath()
	local lines = {}

	if vim.fn.filereadable(filepath) == 1 then
		lines = vim.fn.readfile(filepath)
	end

	-- Remove duplicates
	local new_lines = { script.name }
	for _, line in ipairs(lines) do
		if line ~= script.name then
			table.insert(new_lines, line)
		end
	end

	-- Write updated list back to the file
	vim.fn.writefile(new_lines, filepath)
end
-- M.store({
-- 	cmd = "echo hello",
-- 	name = "test",
-- })

return M
