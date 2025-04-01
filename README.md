
## Installation

### Lazy

```lua

{
    "epoll31/scripts.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
	    local scripts = require("scripts")
	    scripts.setup()

        vim.keymap.set("n", "<leader>fss", function()
            require("scripts.api").picker("all")
        end, {
            desc = "[F]ind [S]cript",
        })
        vim.keymap.set("n", "<leader>fsh", function()
            require("scripts.api").picker("history")
        end, {
            desc = "[F]ind [S]cript from [H]istory",
        })
        vim.keymap.set("n", "<C-Enter>", function()
            require("scripts.api").run_recent()
        end, {
            desc = "Run Previous Script",
        })
    end,
}
```

#### Default Configuration

Here are the default options.

```lua
{
	scripts_dir = ".nvim",
	scripts_file = "scripts.json",
	storage_dir = vim.fn.stdpath("state") .. "/scripts_storage/", -- directory where history files are saved
	default_behaviour = {
		show_output = true,
	},
	term_output = {
		height = 15,
	},
}

```


## Scripts File

This plugin will search your cwd and upwards for a folder named `.nvim` that contains a file named `scripts.json`.

You can override the search folder name (`scripts_dir`) and file name (`scripts_file`) in the setup opts.

### Example File

``` json
{
  "$schema": "https://raw.githubusercontent.com/epoll31/scripts.nvim/refs/heads/main/schemas/scripts.schema.json",
  "scripts": {
    "test": {
      "cmd": "echo test",
    },
    "test2": {
      "cmd": "echo test2"
      "show_output": true
    },
    "test3": {
      "cmd": "echo test3",
      "show_output": false
    }
  }
}
```

## Commands

### Script Picker

To open the scripts picker, run `:ScriptsPicker`.
To run the previously ran script, run `:ScriptsRunPrevious`.


