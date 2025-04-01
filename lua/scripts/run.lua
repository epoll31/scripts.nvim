local config = require("scripts.config")

local M = {}

---@param cmd string
function M.run_in_window(cmd)
	if not cmd then
		return
	end

	vim.cmd.new()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, config.options.term_output.height)
	vim.api.nvim_get_current_buf()

	vim.fn.chansend(vim.bo.channel, { cmd .. "\r\n" })
end

---@param cmd string
function M.run_in_cmdline(cmd)
	-- vim.fn.system(cmd)
	vim.cmd.new()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, config.options.term_output.height)
	vim.api.nvim_get_current_buf()

	vim.fn.chansend(vim.bo.channel, { cmd .. "\r\n" })
	vim.cmd.wincmd("q")
end

---Runs a script
---@param script Script
function M.run_script(script)
	-- print(vim.inspect(script))
	local show_output = script.show_output
	if show_output == nil then
		show_output = config.options.default_behaviour.show_output
	end

	if show_output then
		M.run_in_window(script.cmd)
	else
		M.run_in_cmdline(script.cmd)
	end
end

return M
