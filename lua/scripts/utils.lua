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
			entry.script.name,
			entry.script.cmd,
		})
	end

	pickers
		.new(opts, {
			prompt_title = "Run Script",
			finder = finders.new_table({
				results = scripts,
				---@param script Script
				---@return table
				entry_maker = function(script)
					return {
						value = script,
						display = make_display,
						ordinal = script.name,

						script = script,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selected_entry = action_state.get_selected_entry()
					-- print(vim.inspect(selected_entry))
					script_picked(selected_entry.script)
				end)
				return true
			end,
		})
		:find()
end

return M
