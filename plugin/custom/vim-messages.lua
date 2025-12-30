-- List :messages in a separate floating window

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/vim-messages", { clear = true })

local vim_messages_winnr = nil

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
	local height = math.floor(vim.o.lines * 0.4)
	local col = 0
	local row = vim.o.lines - height - 3

	-- Create floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, filtered_lines)

	local winnr = vim.api.nvim_open_win(buf, true, {
		border = { "─", "─", "─", "", "", "─", "", "" }, -- Only top border
		col = col,
		height = height,
		relative = "editor",
		row = row,
		style = "minimal",
		title = " Messages ",
		width = width,
		zindex = 300,
	})

	vim_messages_winnr = winnr

	vim.api.nvim_set_option_value("wrap", true, { win = winnr })
	vim.api.nvim_set_option_value("number", true, { win = winnr })
	vim.api.nvim_set_option_value("numberwidth", 3, { win = winnr })
	vim.api.nvim_set_option_value("filetype", "vim-messages", { buf = buf })
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

	-- Set cursor to the last line
	vim.api.nvim_win_set_cursor(winnr, { vim.api.nvim_buf_line_count(buf), 0 })
end, {})

vim.api.nvim_create_user_command("VimMessagesClose", function()
	if vim_messages_winnr and vim.api.nvim_win_is_valid(vim_messages_winnr) then
		vim.api.nvim_win_close(vim_messages_winnr, true)
		vim_messages_winnr = nil
	end
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

local k = vim.keymap.set
local opts = { silent = true, noremap = true }

k("n", "<leader>nn", "<cmd>VimMessages<cr>", opts)
k("n", "<leader>nc", "<cmd>messages clear<cr>", opts)
