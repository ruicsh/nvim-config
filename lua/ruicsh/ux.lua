vim.ux = vim.ux or {}

vim.ux.is_narrow_screen = function()
	return vim.o.columns < 170
end

local function create_floating_panel_window(options)
	options = options or {}
	local padding_left = options.padding_left or false

	local width = math.floor(vim.o.columns * 0.5)
	local height = vim.o.lines - vim.o.cmdheight - 2

	local bufnr_frame = 0
	if options.bufnr and not padding_left then
		bufnr_frame = options.bufnr
	else
		bufnr_frame = vim.api.nvim_create_buf(false, true)
	end

	local enter_wrapper_window = not padding_left
	local winnr = vim.api.nvim_open_win(bufnr_frame, enter_wrapper_window, {
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

	-- Create another window inside the floating window with padding-left
	if padding_left then
		local bufnr_content = options.bufnr or vim.api.nvim_create_buf(false, true)
		vim.api.nvim_open_win(bufnr_content, true, {
			border = { "" },
			col = padding_left,
			height = height,
			win = winnr,
			relative = "win",
			row = 0,
			width = width - padding_left,
		})
	end
end

-- Open a floating window on the right side, half the width of the screen
vim.ux.open_side_panel = function(options)
	options = options or {}

	vim.ux.close_side_panels()

	if options.cmd then
		vim.cmd(options.cmd)
	end

	if options.mode == "replace" then
		vim.schedule(function()
			-- Take note of the current window, cursor position and buffer
			local winnr = vim.api.nvim_get_current_win()
			local pos = vim.api.nvim_win_get_cursor(winnr)
			local bufnr = vim.api.nvim_get_current_buf()

			-- Replace the buffer in the options to open in the floating panel
			options.bufnr = bufnr

			create_floating_panel_window(options)

			-- Restore cursor position
			vim.api.nvim_win_set_cursor(0, pos)

			-- Close the old window
			if vim.api.nvim_win_is_valid(winnr) then
				vim.api.nvim_win_close(winnr, true)
			end
		end)
	else
		create_floating_panel_window(options)
	end
end

-- Close all floating panels
vim.ux.close_side_panels = function()
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(winnr).relative ~= "" then
			vim.api.nvim_win_close(winnr, true)
		end
	end
end
