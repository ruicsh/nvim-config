local M = {}

-- Base window config for side panels (right-aligned, half-width float).
-- Used by lib/ui, sidekick.
M.side_panel_win_config = function()
	return {
		anchor = "NE",
		border = { "", "", "", "", "", "", "", "│" },
		col = vim.o.columns,
		height = vim.o.lines - vim.o.cmdheight,
		relative = "editor",
		row = 0,
		style = "minimal",
		width = math.floor(vim.o.columns * 0.5),
	}
end

local function create_floating_panel_window(options)
	options = options or {}

	-- Create a blank buffer or reuse the provided one
	local bufnr = options.bufnr or vim.api.nvim_create_buf(false, false)

	local win_config = vim.tbl_extend("force", M.side_panel_win_config(), {
		focusable = true,
	})
	local winnr = vim.api.nvim_open_win(bufnr, true, win_config)

	-- Identify the window as a side panel, content or wrapper
	vim.api.nvim_win_set_var(winnr, "side_panel", true)
	-- Add left padding to prevent content from being flush against the border
	vim.wo[winnr].signcolumn = "yes:1"
end

M.is_narrow_screen = function()
	return vim.o.columns < 170
end

local PRE_WRAP_VAR = "pre_wrap_value"
local SPACER_VAR = "wrap_spacer"

-- Get a window var, or nil if it's not set
local function win_var(winnr, name)
	local ok, value = pcall(vim.api.nvim_win_get_var, winnr, name)
	if ok then
		return value
	end
	return nil
end

-- Width of a right-aligned floating side panel (any plugin, geometric detection)
M.right_panel_width = function()
	local half = math.floor(vim.o.columns * 0.5)
	local width = 0
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(winnr)
		if cfg.relative == "editor" and cfg.width >= half and cfg.col >= half then
			width = math.max(width, cfg.width)
		end
	end
	return width
end

-- First non-floating (editing) window
local function find_editing_window()
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(winnr)
		if cfg.relative == "" then
			return winnr
		end
	end
	return nil
end

-- Number of non-floating (editing) windows
local function count_editing_windows()
	local count = 0
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(winnr)
		if cfg.relative == "" then
			count = count + 1
		end
	end
	return count
end

-- Restore the original wrap value on a wrapped window
local function restore_wrap(win)
	if not vim.api.nvim_win_is_valid(win) then
		return
	end
	local was = win_var(win, PRE_WRAP_VAR)
	if was ~= nil then
		vim.wo[win].wrap = was
		pcall(vim.api.nvim_win_del_var, win, PRE_WRAP_VAR)
	end
end

-- Close all wrap spacers and restore their paired windows
local function close_wrap_spacers()
	local spacers = {}
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		local target = win_var(winnr, SPACER_VAR)
		if target then
			table.insert(spacers, { winnr = winnr, target = target })
		end
	end
	for _, spacer in ipairs(spacers) do
		restore_wrap(spacer.target)
		if vim.api.nvim_win_is_valid(spacer.winnr) then
			vim.api.nvim_win_close(spacer.winnr, true)
		end
	end
end

-- Close the spacer paired with `win` (if any)
local function close_spacer_for(win)
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		if win_var(winnr, SPACER_VAR) == win and vim.api.nvim_win_is_valid(winnr) then
			vim.api.nvim_win_close(winnr, true)
		end
	end
end

-- Clean up lingering spacers when the last side panel closes, covering close
-- paths that don't go through close_side_panels (e.g. sidekick's own toggle).
vim.api.nvim_create_autocmd("WinClosed", {
	group = vim.api.nvim_create_augroup("ruicsh/ui/wrap", { clear = true }),
	callback = function()
		vim.schedule(function()
			if M.right_panel_width() == 0 then
				close_wrap_spacers()
			end
		end)
	end,
})

-- Toggle soft-wrap on the current buffer.
-- When a right side panel is open, a lone normal window cannot be narrowed,
-- so split it and leave an empty "spacer" window on the right (hidden under
-- the panel) to shrink the buffer to the visible area. Toggling off (or
-- closing the panel) closes the spacer and restores the original wrap value.
M.toggle_wrap = function()
	local win = vim.api.nvim_get_current_win()
	if vim.api.nvim_win_get_config(win).relative ~= "" then
		-- Invoked from inside a side panel: wrap the underlying buffer
		win = find_editing_window()
		if not win then
			vim.notify("No normal window to wrap", vim.log.levels.WARN)
			return
		end
		vim.api.nvim_set_current_win(win)
	end

	if win_var(win, PRE_WRAP_VAR) ~= nil then
		-- Toggle off: restore wrap and close the paired spacer
		restore_wrap(win)
		close_spacer_for(win)
		return
	end

	-- Toggle on. A right side panel is required (without one there's nothing to
	-- narrow), and the narrowing split needs a single-window layout.
	if M.right_panel_width() == 0 then
		return
	end
	if count_editing_windows() > 1 then
		vim.notify("Narrowing requires a single-window layout", vim.log.levels.WARN)
		return
	end

	vim.api.nvim_win_set_var(win, PRE_WRAP_VAR, vim.wo[win].wrap)
	vim.wo[win].wrap = true

	-- A lone normal window can't be narrowed, so split it and leave an empty
	-- window on the right (hidden under the panel) to shrink the buffer.
	-- Closing the buffer window (rather than the panel) leaves the spacer in
	-- place until the panel closes; the WinClosed cleanup only runs when no
	-- right panel remains.
	vim.cmd("rightbelow vnew")
	local spacer = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].buflisted = false
	vim.bo[buf].bufhidden = "wipe"
	vim.api.nvim_win_set_var(spacer, SPACER_VAR, win)

	-- Cover the full panel width, which may exceed the split's half width
	vim.api.nvim_win_set_width(spacer, M.right_panel_width() - 1)

	vim.api.nvim_set_current_win(win)
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
	close_wrap_spacers()

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
