-- List :messages in a separate window
-- https://github.com/deathbeam/dotfiles/blob/master/vim/.vimrc

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/vim-messages", { clear = true })

vim.api.nvim_create_user_command("VimMessages", function()
	-- List messages
	local messages = vim.fn.execute("messages")
	local lines = messages and vim.split(messages, "\n") or {}

	-- Filter out empty lines
	local filtered_lines = {}
	for _, line in ipairs(lines) do
		if line:match("%S") then
			table.insert(filtered_lines, line)
		end
	end

	-- Calculate dimensions for floating window
	local width = vim.o.columns
	local height = math.floor(vim.o.lines * 0.3) + 4
	local col = 0
	local row = vim.o.lines - height - 4

	-- Create floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, filtered_lines)

	local win = vim.api.nvim_open_win(buf, true, {
		border = "rounded",
		col = col,
		height = height,
		relative = "editor",
		row = row,
		style = "minimal",
		title = " Messages ",
		width = width,
		zindex = 300,
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
	end,
})

vim.keymap.set("n", "<leader>nn", "<cmd>VimMessages<cr>", { unique = true, desc = "Vim messages" })
