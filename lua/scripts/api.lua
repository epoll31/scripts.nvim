local utils = require("scripts.utils")
local config = require("scripts.config")

local M = {}

---Open a Telescope script picker.
function M.picker()
	local scripts = utils.find_scripts(config.options.scripts_dir, config.options.scripts_file)

	if not scripts then
		utils.info("No scripts available.")
		return
	end

	if false then
		utils.info(vim.inspect(scripts))
		return
	end

	utils.picker(scripts)
end

-- function M.run_default_in_window()
-- 	local scripts = utils.find_scripts(config.options.scripts_dir, config.options.scripts_file)
--
-- 	if not scripts then
-- 		utils.info("No scripts available.")
-- 		return
-- 	end
--
-- 	local default = utils.get_default_script(scripts)
-- 	if not default then
-- 		utils.info("No default script specified.")
-- 		return
-- 	end
--
-- 	utils.run_in_window(default)
-- end

-- function M.run_default_in_cmdline()
-- 	local scripts = utils.find_scripts(config.options.scripts_dir, config.options.scripts_file)
--
-- 	if not scripts then
-- 		utils.info("No scripts available.")
-- 		return
-- 	end
--
-- 	local default = utils.get_default_script(scripts)
-- 	if not default then
-- 		utils.info("No default script specified.")
-- 		return
-- 	end
--
-- 	utils.run_in_cmdline(scripts.default)
-- end

return M
