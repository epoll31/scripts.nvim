local M = {}

--- Parses a JSON file into a ScriptFile table.
---@param filepath string
---@return ScriptFile|nil, string|nil
function M.parse(filepath)
	local full_path = vim.fn.expand(filepath)
	if vim.fn.filereadable(full_path) == 0 then
		return nil, "File does not exist: " .. full_path
	end

	local lines = vim.fn.readfile(full_path)
	if not lines or vim.tbl_isempty(lines) then
		return nil, "File is empty"
	end

	local content = table.concat(lines, "\n")
	local ok, decoded = pcall(vim.fn.json_decode, content)
	if not ok then
		return nil, "Failed to decode JSON"
	end

	if type(decoded) ~= "table" or type(decoded.scripts) ~= "table" then
		return nil, "Invalid structure: missing top-level 'scripts' table"
	end

	-- Validate each script
	for name, script in pairs(decoded.scripts) do
		if type(script) ~= "table" or type(script.cmd) ~= "string" then
			return nil, ("Invalid script entry for '%s'"):format(name)
		end
		script.name = name
	end

	---@type ScriptFile
	local result = {
		scripts = decoded.scripts,
	}

	return result, nil
end

return M
