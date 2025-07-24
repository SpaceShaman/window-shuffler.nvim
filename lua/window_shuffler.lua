local M = {}

--- @alias Direction 'left' | 'down' | 'up'| 'right'
--- @alias DirectionKey 'h' | 'j' | 'k' | 'l'

-- Default config
local config = {
  keymaps = {
    left = '<C-w>H',
    down = '<C-w>J',
    up = '<C-w>K',
    right = '<C-w>L',
  },
}

--- @param direction Direction
--- @return DirectionKey
local function get_direction_key(direction)
  if direction == 'left' then
    return 'h'
  elseif direction == 'down' then
    return 'j'
  elseif direction == 'up' then
    return 'k'
  elseif direction == 'right' then
    return 'l'
  end
  error('Bad direction: ' .. direction)
end

--- @param direction Direction
--- @return integer | nil
local function get_win(direction)
  local direction_key = get_direction_key(direction)
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. direction_key)
  local target_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(cur_win)
  if cur_win == target_win then
    return nil
  end
  return target_win
end

---@param window integer
---@param direction Direction
---@return integer
local function create_new_win(window, direction)
  vim.api.nvim_set_current_win(window)
  if direction == 'left' then
    vim.cmd 'leftabove vnew'
  elseif direction == 'right' then
    vim.cmd 'vnew'
  elseif direction == 'up' then
    vim.cmd 'leftabove new'
  elseif direction == 'down' then
    vim.cmd 'new'
  end
  return vim.api.nvim_get_current_win()
end

local function windows_have_same_height(win1, win2)
  local win1_height = vim.api.nvim_win_get_height(win1)
  local win2_height = vim.api.nvim_win_get_height(win2)
  return win1_height == win2_height
end

local function windows_have_same_width(win1, win2)
  local win1_width = vim.api.nvim_win_get_width(win1)
  local win2_width = vim.api.nvim_win_get_width(win2)
  return win1_width == win2_width
end

---@param direction Direction
local function move_window(direction)
  local curent_win = vim.api.nvim_get_current_win()
  local curent_buf = vim.api.nvim_win_get_buf(curent_win)

  local target_win = get_win(direction)
  local left_win = get_win 'left'
  local right_win = get_win 'right'
  local up_win = get_win 'up'
  local down_win = get_win 'down'
  local new_win

  if direction == 'right' then
    if right_win and windows_have_same_height(curent_win, right_win) then
      new_win = create_new_win(right_win, 'up')
    elseif down_win and windows_have_same_width(curent_win, down_win) then
      new_win = create_new_win(down_win, 'right')
    elseif target_win then
      new_win = create_new_win(target_win, 'left')
    else
      vim.cmd 'wincmd L'
    end
  elseif direction == 'left' then
    if left_win and windows_have_same_height(curent_win, left_win) then
      new_win = create_new_win(left_win, 'up')
    elseif down_win and windows_have_same_width(curent_win, down_win) then
      new_win = create_new_win(down_win, 'left')
    elseif target_win then
      new_win = create_new_win(target_win, 'right')
    else
      vim.cmd 'wincmd H'
    end
  elseif direction == 'up' then
    if up_win and windows_have_same_width(curent_win, up_win) then
      new_win = create_new_win(up_win, 'left')
    elseif right_win and windows_have_same_height(curent_win, right_win) then
      new_win = create_new_win(right_win, 'up')
    elseif target_win then
      new_win = create_new_win(target_win, 'left')
    else
      vim.cmd 'wincmd K'
    end
  elseif direction == 'down' then
    if down_win and windows_have_same_width(curent_win, down_win) then
      new_win = create_new_win(down_win, 'left')
    elseif right_win and windows_have_same_height(curent_win, right_win) then
      new_win = create_new_win(right_win, 'down')
    elseif target_win then
      new_win = create_new_win(target_win, 'left')
    else
      vim.cmd 'wincmd J'
    end
  end

  if new_win then
    vim.api.nvim_win_set_buf(new_win, curent_buf)
    vim.api.nvim_win_close(curent_win, true)
  end
end

function M.setup(user_config)
  if user_config then
    if user_config.keymaps then
      config.keymaps = vim.tbl_extend('force', config.keymaps, user_config.keymaps)
    end
  end

  -- Setup keymaps
  vim.keymap.set('n', config.keymaps.left, function()
    move_window 'left'
  end, { desc = 'Move buffer left', noremap = true })
  vim.keymap.set('n', config.keymaps.down, function()
    move_window 'down'
  end, { desc = 'Move buffer down', noremap = true })
  vim.keymap.set('n', config.keymaps.up, function()
    move_window 'up'
  end, { desc = 'Move buffer up', noremap = true })
  vim.keymap.set('n', config.keymaps.right, function()
    move_window 'right'
  end, { desc = 'Move buffer right', noremap = true })
end

return M
