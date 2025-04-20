-- Help files.

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/help", { clear = true })

-- Open help on a vertical split (or re-use window if opened).
vim.api.nvim_create_autocmd("CmdLineLeave", {
	group = augroup,
	pattern = ":",
	callback = function()
		local cmd = vim.fn.getcmdline()
		if cmd:match("^help%s") or cmd:match("^h%s") or cmd == "h" or cmd == "help" then
			local buffers = vim.fn.getbufinfo({ bufloaded = 1 })
			local help_buf_id

			for _, buf in ipairs(buffers) do
				local ft = vim.api.nvim_get_option_value("filetype", { buf = buf.bufnr })
				if ft == "help" then
					help_buf_id = buf.bufnr
					break
				end
			end

			if help_buf_id then
				local win_ids = vim.fn.win_findbuf(help_buf_id)
				if #win_ids > 0 then
					vim.api.nvim_set_current_win(win_ids[1])
					return
				end
			end

			vim.cmd("only")
		end
	end,
})

-- Always open help panel on a vertical split, full height.
-- https://github.com/dmmulroy/kickstart.nix/blob/main/config/nvim/
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "help",
	callback = function()
		vim.cmd.wincmd("L") -- Send current window (help) to the right edge
		vim.cmd.wincmd("=") -- Make all windows the same height
	end,
})
