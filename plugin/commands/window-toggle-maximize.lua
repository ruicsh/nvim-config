-- Maximizes the current window, or restores the layout if it is already maximized.

local is_maximized = false
local saved_layout = {}
local maximized_buf = nil

local function save_layout()
	saved_layout = vim.fn.winlayout() -- Capture the layout tree
	local wins = vim.api.nvim_tabpage_list_wins(0)
	saved_layout.buffers = {}
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		table.insert(saved_layout.buffers, { win = win, buf = buf })
	end
	maximized_buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
end

-- Function to restore the saved layout
local function restore_node(node, buf_list, buf_index)
	-- Recursive function to recreate the layout
	if node[1] == "leaf" then
		-- Assign the correct buffer to the current window
		local buf = buf_list[buf_index[1]].buf
		if buf and vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_win_set_buf(0, buf)
		end
		buf_index[1] = buf_index[1] + 1
	else
		-- Create new splits and restore layout recursively
		local split_cmd = node[1] == "row" and "vsplit" or "split"
		for i, child in ipairs(node[2]) do
			if i > 1 then
				vim.cmd(split_cmd)
			end
			restore_node(child, buf_list, buf_index)
		end
	end
end

-- Function to restore the saved layout
local function restore_layout()
	vim.cmd("only") -- Close all windows except the current one
	local buf_index = { 1 }
	restore_node(saved_layout, saved_layout.buffers, buf_index)
end

vim.api.nvim_create_user_command("WindowToggleMaximize", function(opts)
	local target_win = tonumber(opts.args) or vim.api.nvim_get_current_win() -- Default to current window

	-- The target window is floating, use window that opened it
	if vim.api.nvim_win_get_config(target_win).relative ~= "" then
		vim.cmd("close") -- close floating window
		target_win = vim.api.nvim_get_current_win()
	end

	if is_maximized then
		restore_layout()
		-- Move the cursor back to the window with the previously maximized buffer
		local wins = vim.api.nvim_tabpage_list_wins(0)
		for _, win in ipairs(wins) do
			if vim.api.nvim_win_get_buf(win) == maximized_buf then
				vim.api.nvim_set_current_win(win)
				break
			end
		end
		is_maximized = false
	else
		save_layout()
		vim.api.nvim_set_current_win(target_win)
		vim.cmd("only") -- Maximize the current window
		is_maximized = true
	end
end, {})
