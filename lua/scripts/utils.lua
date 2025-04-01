local parser = require("scripts.parser")
local config = require("scripts.config")

local M = {
	run = {},
}

---@param msg string
function M.info(msg)
	vim.notify(msg, vim.log.levels.INFO)
end

---@param msg string
function M.error(msg)
	vim.notify(msg, vim.log.levels.ERROR)
end

---@param scripts_dir string
---@return string
function M.find_scripts_dir(scripts_dir)
	return vim.fs.find(scripts_dir, { upward = true, type = "directory" })[1]
end

---@param scripts_dir string
---@param scripts_file string
---@return string | nil
function M.find_scripts_file(scripts_dir, scripts_file)
	if not scripts_dir then
		return nil
	end

	return vim.fs.joinpath(scripts_dir, scripts_file)
end

---@param file_path string
---@return table | nil
function M.parse_json_file(file_path)
	local file = io.open(file_path, "r") -- Open the file in read mode
	if not file then
		M.errro("Error: Could not open file " .. file_path)
		return nil
	end

	local content = file:read("*a") -- Read the entire file
	file:close() -- Close the file

	-- Decode JSON content
	local ok, json = pcall(vim.json.decode, content)
	if not ok then
		M.error("error: could not decode json" .. content)
		return nil
	end

	return json
end

---@param scripts_folder string
---@param scripts_file string
---@return ScriptFile | nil
function M.find_scripts(scripts_folder, scripts_file)
	local scripts_dir = M.find_scripts_dir(scripts_folder)
	local filepath = M.find_scripts_file(scripts_dir, scripts_file)

	if not filepath then
		return nil
	end

	return parser.parse(filepath)
end

---@param script string
function M.run_in_window(script)
	if not script then
		return
	end

	vim.cmd.new()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, config.options.term_output.height)
	vim.api.nvim_get_current_buf()

	vim.fn.chansend(vim.bo.channel, { script .. "\r\n" })
end

---@param script string
function M.run_in_cmdline(script)
	vim.fn.system(script)
end

---Runs a script
---@param script Script
function M.run_script(script)
	print(vim.inspect(script))
	local show_output = script.show_output
	if show_output == nil then
		show_output = config.options.default_behaviour.show_output
	end
	print(show_output and "true" or "false")

	if show_output then
		M.run_in_window(script.cmd)
	else
		M.run_in_cmdline(script.cmd)
	end
end

---Opens a Telescope picker to allow the user to select a script to run.
---@param scripts ScriptFile
function M.picker(scripts)
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local entry_display = require("telescope.pickers.entry_display")
	local conf = require("telescope.config").values

	local opts = {}
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 20 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		return displayer({
			entry.name,
			entry.script.cmd,
		})
	end

	local script_pairs = parser.get_pairs(scripts)

	pickers
		.new(opts, {
			prompt_title = "Run Script",
			finder = finders.new_table({
				results = script_pairs,
				---@param pair ScriptPair
				---@return table
				entry_maker = function(pair)
					return {
						value = pair,
						display = make_display,
						ordinal = pair.name,
						name = pair.name,
						script = pair.script,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selected_entry = action_state.get_selected_entry()
					-- print(vim.inspect(selected_entry))
					M.run_script(selected_entry.script)
				end)
				return true
			end,
		})
		:find()
end

return M
