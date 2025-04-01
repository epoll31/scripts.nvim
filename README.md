
## Installation

### Lazy

```lua

{
    "epoll31/scripts.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
	    local sp = require("scripts")
	    sp.setup()

	    vim.keymap.set({ "n", "i" }, "<C-Enter>", require("scripts").run_default_script)
	    vim.keymap.set("n", "<leader>ss", require("scripts").script_picker)
	    vim.keymap.set("n", "<leader>fs", require("scripts").script_picker)
    end,
}
```

## Scripts File

This plugin will search your cwd and upwards for a folder named `.nvim` that contains a file named `scripts.json`.

### Example File

``` json
{
  "default": "echo default",
  "build": "echo build",
  "dev": "echo dev"
}
```

## Commands

### Script Picker

To open a script picker, run `:SearchScripts`.

### Run Default Script

To run the default script, run `:RunDefaultScript`.

The default script is the script named `default`.

