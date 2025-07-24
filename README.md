<h1 align="center">window-shuffler.nvim</h1>

<p align="center">Smartly shuffle Neovim windows around – layout-aware and intuitive.</p>

## Features

* Move the current **window** in any direction: left, right, up, or down.
* Automatically finds the best possible placement based on existing layout.
* Respects window dimensions to keep your layout clean and consistent.
* Simple setup with fully customizable keymaps.

## Installation

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use { "SpaceShaman/window-shuffler.nvim", tag = "*", config = function()
  require("window-shuffler").setup()
end }
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "SpaceShaman/window-shuffler.nvim",
  version = "*",
  opts = {
    -- Optional custom keymaps
  },
}
```

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'SpaceShaman/window-shuffler.nvim', {'tag': '*'}

lua require("window-shuffler").setup()
```

You can (and should) pin the plugin to a tag to avoid breaking changes as development continues.

## Configuration

You can configure the plugin by passing a table to the `setup()` function:

```lua
require("window-shuffler").setup({
  keymaps = {
    left = "<C-w>H",
    down = "<C-w>J",
    up = "<C-w>K",
    right = "<C-w>L",
  },
})
```

Or by using the `opts` field in your lazy.nvim config:

```lua
{
  "SpaceShaman/window-shuffler.nvim",
  opts = {
    keymaps = {
      left = "<C-w>H",
      down = "<C-w>J",
      up = "<C-w>K",
      right = "<C-w>L",
    },
  },
}
```

### `keymaps`

A table of keybindings for directional movement. Default values are:

* `<C-w>H`: Move current window to the left.
* `<C-w>J`: Move current window downward.
* `<C-w>K`: Move current window upward.
* `<C-w>L`: Move current window to the right.

## How it works

When you trigger a directional move, the plugin searches for the most logical location in that direction – for example, it may go around obstacles to maintain the layout's flow. It ensures the moved window integrates cleanly with the rest of your layout.

