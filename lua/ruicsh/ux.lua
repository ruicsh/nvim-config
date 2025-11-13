vim.ux = vim.ux or {}

-- Close all windows to the right/left side of the current window
vim.ux.close_windows_on_side = function(side)
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

-- Open the side panel, closing right/left side windows if necessary
vim.ux.open_side_panel = function(cmd)
	local current_win = vim.api.nvim_get_current_win()
	local current_tab = vim.api.nvim_win_get_tabpage(current_win)
	local wins = vim.api.nvim_tabpage_list_wins(current_tab)

	-- Remove invalid windows from the list
	for i = #wins, 1, -1 do
		if not vim.api.nvim_win_is_valid(wins[i]) then
			table.remove(wins, i)
		end
	end

	local function run_command()
		-- If the command is false, we don't run anything
		if cmd ~= false then
			-- If there's a commend to run or by default open a new vertical split on the right
			local default = vim.ux.is_narrow_screen() and "botright new" or "botright vnew"
			local command = cmd or default
			vim.cmd(command)
		end
	end

	if #wins <= 1 then
		run_command()
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
		vim.ux.close_windows_on_side("right")
	else
		vim.ux.close_windows_on_side("left")
	end

	run_command()
end

vim.ux.is_narrow_screen = function()
	return vim.o.columns < 170
end

vim.ux.open_floating_panel = function(options)
	options = options or {}

	vim.ux.close_floating_panels()

	local width = math.floor(vim.o.columns * 0.5)
	local height = vim.o.lines - vim.o.cmdheight - 2

	-- Open a floating window on the right side
	local blank = vim.api.nvim_create_buf(false, true)
	local winnr = vim.api.nvim_open_win(blank, false, {
		anchor = "NE",
		border = { "", "", "", "", "", "", "", "│" },
		col = vim.o.columns,
		focusable = false,
		height = height,
		relative = "editor",
		row = 0,
		style = "minimal",
		width = width,
	})

	-- Create another window inside the floating window with left padding
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(bufnr, true, {
		border = { "" },
		col = 2,
		height = height,
		win = winnr,
		relative = "win",
		row = 0,
		width = width - 2,
	})
end

vim.ux.close_floating_panels = function()
	-- Close all floating panels
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(winnr).relative ~= "" then
			vim.api.nvim_win_close(winnr, true)
		end
	end
end
