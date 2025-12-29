local M = {}

local function create_floating_panel_window(options)
	options = options or {}

	local width = math.floor(vim.o.columns * 0.5)
	local height = vim.o.lines - vim.o.cmdheight - 1

	-- Create a blank buffer or reuse the provided one
	local bufnr = options.bufnr or vim.api.nvim_create_buf(false, false)

	local winnr = vim.api.nvim_open_win(bufnr, true, {
		anchor = "NE",
		border = { "", "", "", "", "", "", "", "│" },
		col = vim.o.columns,
		focusable = true,
		height = height,
		relative = "editor",
		row = 0,
		style = "minimal",
		width = width,
	})

	-- Identify the window as a side panel, content or wrapper
	vim.api.nvim_win_set_var(winnr, "side_panel", true)
end

M.is_narrow_screen = function()
	return vim.o.columns < 170
end

-- Open a floating window on the right side, half the width of the screen
M.open_side_panel = function(options)
	options = options or {}

	M.close_side_panels()

	if options.cmd then
		vim.cmd(options.cmd)
	end

	if options.mode == "replace" then
		-- Take note of the current window, cursor position and buffer
		local winnr = vim.api.nvim_get_current_win()
		local pos = vim.api.nvim_win_get_cursor(winnr)
		local bufnr = vim.api.nvim_get_current_buf()

		-- Store visual selection if any
		local mode = vim.fn.mode()
		local visual_selection = nil
		if mode == "v" or mode == "V" or mode == "\22" then
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			visual_selection = { start_pos = start_pos, end_pos = end_pos }
		end

		-- Replace the buffer in the options to open in the floating panel
		options.bufnr = bufnr

		create_floating_panel_window(options)

		-- Restore cursor position
		vim.api.nvim_win_set_cursor(0, pos)

		-- Restore visual selection if any
		if visual_selection then
			vim.api.nvim_win_set_cursor(0, { visual_selection.start_pos[2], visual_selection.start_pos[3] - 1 })
			vim.cmd("normal! v")
			vim.api.nvim_win_set_cursor(0, { visual_selection.end_pos[2], visual_selection.end_pos[3] - 1 })
		end

		-- Close the old window
		if vim.api.nvim_win_is_valid(winnr) then
			vim.api.nvim_win_close(winnr, true)
		end
	else
		create_floating_panel_window(options)
	end
end

-- Close all floating panels
M.close_side_panels = function()
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		local ok, side_panel = pcall(vim.api.nvim_win_get_var, winnr, "side_panel")
		if ok and side_panel then
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(winnr) then
					vim.api.nvim_win_close(winnr, true)
				end
			end)
		end
	end
end

return M
