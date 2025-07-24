local M = {}

--- @alias Direction 'left' | 'down' | 'up'| 'right'
--- @alias DirectionKey 'h' | 'j' | 'k' | 'l'

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

--- @return integer, integer
local function get_current_win_buf()
  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  return cur_win, cur_buf
end

--- @param direction Direction
--- @return integer, integer
local function get_target_win_buf(direction)
  local direction_key = get_direction_key(direction)
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. direction_key)
  local target_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(cur_win)
  return target_win, vim.api.nvim_win_get_buf(target_win)
end

---@param bufnr integer
---@return boolean
local function is_special_buf(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  for _, pattern in ipairs(config.excluded_patterns) do
    if name:match(pattern) then
      return true
    end
  end
  return false
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

---@param direction Direction
---@return Direction
local function get_opposite_direction(direction)
  if direction == 'left' then
    return 'right'
  elseif direction == 'right' then
    return 'left'
  elseif direction == 'up' then
    return 'down'
  elseif direction == 'down' then
    return 'up'
  end
  error('Bad direction: ' .. direction)
end

---@param direction Direction
local function move_window(direction)
  local direction_key = get_direction_key(direction)
  local curent_win, curent_buf = get_current_win_buf()
  local target_win, target_buf = get_target_win_buf(direction)
  local new_win

  if is_special_buf(curent_buf) then
    vim.notify('Moving or swapping excluded buffers is not allowed.', vim.log.levels.WARN)
    return
  end

  if is_special_buf(target_buf) then
    local opposite_direction = get_opposite_direction(direction)
    new_win = create_new_win(target_win, opposite_direction)
  else
    if direction == 'left' or direction == 'right' then
      new_win = create_new_win(target_win, 'up')
    else
      new_win = create_new_win(target_win, 'left')
    end
  end

  vim.api.nvim_win_set_buf(new_win, curent_buf)
  vim.api.nvim_win_close(curent_win, true)

  if curent_buf == target_buf then
    vim.cmd('wincmd ' .. string.upper(direction_key))
  end
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
