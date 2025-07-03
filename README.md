# buffer-mover.nvim

**Easily move buffers between windows in Neovim, skipping excluded buffer types!**

## Features

- Move current buffer to the next window in any direction.
- If no window exists in the chosen direction, creates a split and moves the buffer there.
- Skip (do not swap/move) special buffers like `neo-tree` or terminals (customizable).
- Easy configuration and custom keymaps.

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'SpaceShaman/window-shuffler.nvim',
  config = function()
    require('buffer_mover').setup()
  end,
}
