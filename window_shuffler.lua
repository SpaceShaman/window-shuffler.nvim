local M = {}

-- Default config
local config = {
	excluded_patterns = { "neo%-tree", "^term://" },
	keymaps = {
		left = "<leader>j",
		down = "<leader>k",
		up = "<leader>l",
		right = "<leader>;",
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

function M.move_window(direction)
	local cur_win = vim.api.nvim_get_current_win()
	local cur_buf = vim.api.nvim_win_get_buf(cur_win)

	-- Prevent moving/swapping from excluded buffer
	if is_special_buf(cur_buf) then
		vim.notify("Moving or swapping excluded buffers is not allowed.", vim.log.levels.WARN)
		return
	end

	-- Search for next window with normal buffer in the given direction
	local win_found = false
	local start_win = cur_win
	local max_jumps = vim.fn.winnr("$")
	local target_win, target_buf

	for _ = 1, max_jumps do
		vim.cmd("wincmd " .. direction)
		target_win = vim.api.nvim_get_current_win()
		if target_win == start_win then
			break
		end

		target_buf = vim.api.nvim_win_get_buf(target_win)
		if not is_special_buf(target_buf) then
			win_found = true
			break
		end
	end

	if win_found then
		-- Swap buffers
		vim.api.nvim_win_set_buf(target_win, cur_buf)
		vim.api.nvim_win_set_buf(cur_win, target_buf)
		vim.api.nvim_set_current_win(target_win)
	else
		-- No normal neighbor found, create a new split and move buffer there
		local split_cmd = {
			h = "leftabove vsplit",
			l = "rightbelow vsplit",
			k = "leftabove split",
			j = "rightbelow split",
		}
		vim.api.nvim_set_current_win(start_win)
		vim.cmd(split_cmd[direction])
		local new_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(new_win, cur_buf)
		vim.api.nvim_set_current_win(new_win)
	end
end

function M.setup(user_config)
	-- Merge user config
	if user_config then
		if user_config.excluded_patterns then
			config.excluded_patterns = user_config.excluded_patterns
		end
		if user_config.keymaps then
			config.keymaps = vim.tbl_extend("force", config.keymaps, user_config.keymaps)
		end
	end

	-- Setup keymaps
	vim.keymap.set("n", config.keymaps.left, function()
		M.move_window("h")
	end, { desc = "Swap or move buffer left", noremap = true })
	vim.keymap.set("n", config.keymaps.down, function()
		M.move_window("j")
	end, { desc = "Swap or move buffer down", noremap = true })
	vim.keymap.set("n", config.keymaps.up, function()
		M.move_window("k")
	end, { desc = "Swap or move buffer up", noremap = true })
	vim.keymap.set("n", config.keymaps.right, function()
		M.move_window("l")
	end, { desc = "Swap or move buffer right", noremap = true })
end

return M
