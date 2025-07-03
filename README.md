<h1 align="center">
window-shuffler.nvim
</h1>

<p align="center">Easily move buffers between windows in Neovim, skipping excluded buffer types!</p>

## Features

- Move current buffer to the next window in any direction.
- If no window exists in the chosen direction, creates a split and moves the buffer there.
- Skip (do not swap/move) special buffers like `neo-tree` or terminals (customizable).
- Easy configuration and custom keymaps.

## Installation

Using [packer](https://github.com/wbthomason/packer.nvim) in lua

```lua
use {"SpaceShaman/window-shuffler.nvim", tag = '*', config = function()
  require("window-shuffler").setup()
end}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim) in lua

```lua
{
  -- amongst your other plugins
  {'SpaceShaman/window-shuffler.nvim', version = "*", config = true}
  -- or
  {'SpaceShaman/window-shuffler.nvim', version = "*", opts = {--[[ things you want to change go here]]}}
}
```

Using [vim-plug](https://github.com/junegunn/vim-plug) in vimscript

```vim
Plug 'SpaceShaman/window-shuffler.nvim', {'tag' : '*'}

lua require("window-shuffler").setup()
```

You can/should specify a tag for the current major version of the plugin, to avoid breaking changes as this plugin evolves.

## Configuration

You can configure the plugin by passing a table to the `setup` function.

```lua
require("window-shuffler").setup({
  excluded_patterns = { "neo%-tree", "^term://" },
  keymaps = {
    left = "<C-w>H",
    down = "<C-w>J",
    up = "<C-w>K",
    right = "<C-w>L",
  },
})
```

Or by setting the `opts` field in the plugin's configuration.

```lua
{
    "SpaceShaman/window-shuffler.nvim",
    opts = {
      excluded_patterns = { "neo%-tree", "^term://" },
      keymaps = {
        left = "<C-w>H",
        down = "<C-w>J",
        up = "<C-w>K",
        right = "<C-w>L",
      },
    },
}
```

### `excluded_patterns`

A list of Lua patterns that match buffer names to be excluded from the window movement. By default, the plugin will skip buffers with names that start with "neo-tree" or "term://".

### `keymaps`

A table of keymaps to be used for window movement. The default keymaps are:

- `<C-w>H`: Move the current buffer to the left window.
- `<C-w>J`: Move the current buffer to the down window.
- `<C-w>K`: Move the current buffer to the up window.
- `<C-w>L`: Move the current buffer to the right window.

