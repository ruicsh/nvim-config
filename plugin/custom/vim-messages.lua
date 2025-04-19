-- List :messages in a separate window
-- https://github.com/deathbeam/dotfiles/blob/master/vim/.vimrc#L178C1-L179C1

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/vim-messages", { clear = true })

vim.api.nvim_create_user_command("VimMessages", function()
	local height = math.floor(vim.o.lines * 0.2) -- Set height to 20% of screen
	vim.cmd(height .. "new +set\\ filetype=vim-messages")

	-- List messages
	local messages = vim.fn.execute("messages")
	local lines = messages and vim.split(messages, "\n") or {}
	-- Filter out empty lines
	lines = vim.tbl_filter(function(line)
		return line ~= ""
	end, lines)

	if #lines == 0 then
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "No messages to display", "" })
	else
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end

	vim.cmd("normal! G") -- Jump to the end of the buffer
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
