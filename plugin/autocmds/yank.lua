local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/yank", { clear = true })

-- Highlight selection when yanking
-- https://github.com/dmmulroy/kickstart.nix/blob/main/config/nvim/
local function highlight_yank()
	vim.highlight.on_yank({
		higroup = "IncSearch",
		timeout = 200,
		visual = true,
		priority = 250,
	})
end

-- Keep cursor on yank.
-- https://nanotipsforvim.prose.sh/sticky-yank

-- Mark the position of the cursor before yanking
vim.keymap.set({ "n", "o", "v" }, "y", function()
	local position = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_buf_set_mark(0, "y", position[1], position[2], {})
	return "y"
end, { expr = true, unique = true })

-- Check if the cursor position is valid
local function is_valid_cursor_position(bufnr, line, col)
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	if line > line_count then
		return false
	end
	local line_length = #vim.api.nvim_buf_get_lines(bufnr, line - 1, line, true)[1]
	return col <= line_length
end

-- Restore the cursor position after yanking
local function restore_cursor()
	if vim.v.event.operator == "y" then
		local bufnr = vim.api.nvim_get_current_buf()
		local ok, mark_pos = pcall(vim.api.nvim_buf_get_mark, bufnr, "y")
		if ok and mark_pos[1] > 0 then
			-- Check if the mark position is valid before setting cursor
			if is_valid_cursor_position(bufnr, mark_pos[1], mark_pos[2]) then
				vim.api.nvim_win_set_cursor(0, { mark_pos[1], mark_pos[2] })
			end
			vim.api.nvim_buf_del_mark(bufnr, "y")
		end
	end
end

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		highlight_yank()
		restore_cursor()
	end,
})
