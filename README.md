
## Installation

### Lazy

```lua

{
    "epoll31/scripts.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
	    local scripts = require("scripts")
	    scripts.setup()

        vim.keymap.set("n", "<leader>f<Enter>", require("scripts.api").picker, {
            desc = "[F]ind Script",
        })
    end,
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


