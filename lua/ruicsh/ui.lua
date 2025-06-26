vim.ui = {}

-- Close all windows to the right/left side of the current window
vim.ui.close_windows_on_side = function(side)
	local current_win = vim.api.nvim_get_current_win()
	local current_tab = vim.api.nvim_win_get_tabpage(current_win)
	local wins = vim.api.nvim_tabpage_list_wins(current_tab)

	if #wins <= 1 then
		return
	end

	local current_pos = vim.api.nvim_win_get_position(current_win)

	for _, win in ipairs(wins) do
		if win ~= current_win then
			local pos = vim.api.nvim_win_get_position(win)
			local to_close = side == "right" and pos[2] > current_pos[2] or pos[2] < current_pos[2]
			if to_close then
				vim.api.nvim_win_close(win, false)
			end
		end
	end
end

-- Open the right side panel, closing right/left side windows if necessary
vim.ui.open_side_panel = function(cmd)
	local current_win = vim.api.nvim_get_current_win()
	local current_tab = vim.api.nvim_win_get_tabpage(current_win)
	local wins = vim.api.nvim_tabpage_list_wins(current_tab)

	local function run_command(c)
		if c then
			-- If there's a commend to run or by default open a new vertical split on the right
			local command = c or "botright vnew"
			vim.cmd(command)
		end
	end

	if #wins <= 1 then
		run_command(cmd)
		return
	end

	local current_pos = vim.api.nvim_win_get_position(current_win)
	local has_right_windows = false

	-- Check if there are windows to the right
	for _, win in ipairs(wins) do
		if win ~= current_win then
			local pos = vim.api.nvim_win_get_position(win)
			if pos[2] > current_pos[2] then
				has_right_windows = true
				break
			end
		end
	end

	if has_right_windows then
		vim.ui.close_windows_on_side("right")
	else
		vim.ui.close_windows_on_side("left")
	end

	run_command(cmd)
end
