-- List :messages in a separate window
-- https://github.com/deathbeam/dotfiles/blob/master/vim/.vimrc

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/vim-messages", { clear = true })

vim.api.nvim_create_user_command("VimMessages", function()
	-- List messages
	local messages = vim.fn.execute("messages")
	local lines = messages and vim.split(messages, "\n") or {}

	-- Filter out empty lines
	lines = vim.fn.filter(lines, 'v:val =~ "\\S"')

	-- Calculate dimensions for floating window
	local width = math.floor(vim.o.columns * 0.3)
	local height = vim.o.lines - 3
	local col = vim.o.columns - width
	local row = 0

	-- Create floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "single",
	})

	vim.api.nvim_set_option_value("wrap", true, { win = win })
	vim.api.nvim_set_option_value("number", true, { win = win })
	vim.api.nvim_set_option_value("numberwidth", 3, { win = win })
	vim.api.nvim_set_option_value("filetype", "vim-messages", { buf = buf })

	-- Set cursor to the last line
	vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
end, {})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "vim-messages",
	callback = function()
		vim.bo.buftype = "nofile" -- Set buffer type to nofile
		vim.bo.bufhidden = "wipe" -- Wipe the buffer when it's hidden
		vim.wo.wrap = true -- Enable line wrapping
		vim.wo.relativenumber = false -- Disable relative line numbers

		vim.keymap.set("n", "<c-e>", "<c-w>q", { buffer = 0, desc = "Close messages window" })
	end,
})

vim.keymap.set("n", "<leader>nn", "<cmd>VimMessages<cr>", { unique = true, desc = "Vim messages" })
