local M = {}

-- Default config
local config = {
  excluded_patterns = { 'neo%-tree', '^term://' },
  keymaps = {
    left = '<C-w>H',
    down = '<C-w>J',
    up = '<C-w>K',
    right = '<C-w>L',
  },
}

local function is_special_buf(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  for _, pattern in ipairs(config.excluded_patterns) do
    if name:match(pattern) then
      return true
    end
  end
  return false
end

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
end

local function get_target_win_buf(direction_key)
  vim.cmd('wincmd ' .. direction_key)
  local target_win = vim.api.nvim_get_current_win()
  return target_win, vim.api.nvim_win_get_buf(target_win)
end

local function move_window(direction)
  local direction_key = get_direction_key(direction)
  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_win_get_buf(cur_win)

  if is_special_buf(cur_buf) then
    vim.notify('Moving or swapping excluded buffers is not allowed.', vim.log.levels.WARN)
    return
  end

  local target_win, target_buf = get_target_win_buf(direction_key)

  if is_special_buf(target_buf) then
    vim.api.nvim_win_close(target_win, true)
    vim.cmd('wincmd ' .. direction_key)
    target_win = vim.api.nvim_get_current_win()
    target_buf = vim.api.nvim_win_get_buf(target_win)
  end

  if cur_win == target_win then
    vim.cmd('wincmd ' .. string.upper(direction_key))
    return
  end

  if direction == 'left' or direction == 'right' then
    vim.cmd 'new'
  elseif direction == 'down' or direction == 'up' then
    vim.cmd 'vnew'
  end
  local new_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(target_win, cur_buf)
  vim.api.nvim_win_set_buf(new_win, target_buf)
  vim.api.nvim_win_close(cur_win, true)
  vim.api.nvim_set_current_win(target_win)
end

function M.setup(user_config)
  if user_config then
    if user_config.excluded_patterns then
      config.excluded_patterns = user_config.excluded_patterns
    end
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
