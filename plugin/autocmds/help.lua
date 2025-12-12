-- Help files.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/help", { clear = true })

-- Open help on floating side panel (or re-use panel if opened).
vim.api.nvim_create_autocmd("CmdLineLeave", {
	group = augroup,
	pattern = ":",
	callback = function()
		local cmd = vim.fn.getcmdline()
		if cmd:match("^help%s") or cmd:match("^h%s") or cmd == "h" or cmd == "help" then
			local buffers = vim.fn.getbufinfo({ bufloaded = 1 })
			local help_bufnr = nil

			-- Check if a help buffer is already opened.
			for _, buf in ipairs(buffers) do
				local ft = vim.api.nvim_get_option_value("filetype", { buf = buf.bufnr })
				if ft == "help" then
					help_bufnr = buf.bufnr
					break
				end
			end

			-- If help buffer is already opened, switch to its window.
			if help_bufnr then
				local win_ids = vim.fn.win_findbuf(help_bufnr)
				if #win_ids > 0 then
					vim.api.nvim_set_current_win(win_ids[1])
					return
				end
			end

			-- Open new help page in the side panel
			vim.ux.open_side_panel({
				mode = "replace",
			})
		end
	end,
})
