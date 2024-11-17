local function smart_vertical_split()
	-- Get list of windows in current tab.
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local current_win = vim.api.nvim_get_current_win()

	-- Look for an existing vertical split.
	for _, win in ipairs(wins) do
		if win ~= current_win then
			-- Get window position.
			local win_config = vim.api.nvim_win_get_config(win)

			-- Check if it's a vertical split.
			if win_config.relative == "" and vim.api.nvim_win_get_position(win)[2] > 0 then
				-- Focus the existing split.
				vim.api.nvim_set_current_win(win)
				return
			end
		end
	end

	-- If no vertical split found, create new one.
	vim.cmd("vsplit")
end

vim.api.nvim_create_user_command("SmartVerticalSplit", function()
	smart_vertical_split()
end, {})
