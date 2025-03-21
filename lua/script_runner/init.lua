local M = {}

-- TODO: define opts (dir_name, file_name)
-- TODO: run last script: run the previously ran script

local function find_scripts_folder()
	local scripts_folder = vim.fs.find(".nvim", { upward = true, type = "directory" })[1]

	return scripts_folder
end

local function find_scripts_file(scripts_folder)
	if not scripts_folder then
		return nil
	end

	local scripts_file = vim.fs.joinpath(scripts_folder, "scripts.json")
	return scripts_file
end

local function parse_json_file(filepath)
	local file = io.open(filepath, "r") -- Open the file in read mode
	if not file then
		vim.notify("error: could not open file " .. filepath, vim.log.levels.ERROR)
		return nil
	end

	local content = file:read("*a") -- Read the entire file
	file:close() -- Close the file

	-- Decode JSON content
	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		vim.notify("error: could not decode json" .. content, vim.log.levels.ERROR)
		return nil
	end

	return data
end

local function json_to_scripts_list(json)
	local scripts = {}

	-- vim.notify("json_to_scripts" .. vim.inspect(json), vim.log.levels.INFO)

	for name, script in pairs(json) do
		table.insert(scripts, { name, script })
	end

	return scripts
end

local function find_scripts()
	local scripts_folder = find_scripts_folder()
	local scripts_file = find_scripts_file(scripts_folder)

	local json = parse_json_file(scripts_file)

	return json
end

local function run_script(script)
	if not script then
		return
	end

	vim.cmd.new()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)

	vim.fn.chansend(vim.bo.channel, { script .. "\r\n" })
end
-- local function get_selected_entry(prompt_bufnr)
-- 	local actions = require("telescope.actions")
-- 	local action_state = require("telescope.actions.state")
-- 	local entry = action_state.get_selected_entry()
-- 	if entry then
-- 		-- print(vim.inspect(entry)) -- Print entry for debugging
-- 		-- vim.notify("Selected: " .. entry.value, vim.log.levels.INFO)
-- 	else
-- 		vim.notify("No entry selected", vim.log.levels.WARN)
-- 	end
-- 	actions.close(prompt_bufnr)
-- end

local function show_script_picker(scripts)
	local scripts = json_to_scripts_list(scripts)

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
			entry.script,
		})
	end

	pickers
		.new(opts, {
			prompt_title = "Scripts",
			finder = finders.new_table({
				results = scripts,
				entry_maker = function(entry)
					return {
						value = "split | term " .. entry[2],
						display = make_display,
						ordinal = entry[1] .. entry[2],
						name = entry[1],
						script = entry[2],
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					print(vim.inspect(selection))

					run_script(selection.script)
					-- vim.api.nvim_put({ selection[1] }, "", false, true)
				end)

				-- map({ "i", "n" }, "<CR>", function(entry)
				-- 	vim.cmd(":q!")
				-- 	print(entry)
				-- 	-- vim.notify(vim.inspect({ "dne" }), vim.log.levels.INFO)
				-- 	-- run_script(entry.script)
				-- end)
				return true
			end,
		})
		:find()
end

M.script_picker = function()
	local scripts = find_scripts()

	-- vim.notify("scripts: \n" .. vim.inspect(scripts), vim.log.levels.INFO)
	show_script_picker(scripts)
end

M.run_default_script = function()
	local scripts = find_scripts()
	-- local default = find_default_script(scripts)

	-- vim.notify(vim.inspect(scripts), vim.log.levels.INFO)
	-- vim.notify(default or "dne", vim.log.levels.INFO)

	if scripts and scripts.default then
		run_script(scripts.default)
	end
end

M.setup = function(opts)
	opts = opts or {}

	opts.folder_name = opts.folder_name or ".nvim"
	opts.file_name = opts.file_name or "scripts.json"

	vim.api.nvim_create_user_command("SearchScripts", M.script_picker, {})
	vim.api.nvim_create_user_command("RunDefaultScript", M.run_default_script, {})
end

return M
