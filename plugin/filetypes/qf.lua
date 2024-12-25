-- Quickfix.

local group = vim.api.nvim_create_augroup("ruicsh/ft/qf", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "qf",
	callback = function(event)
		vim.cmd.packadd("cfilter") -- Install package to filter entries.

		local k = vim.keymap.set
		local opts = { buffer = event.buf, unique = true }

		k("n", "<cr>", "<cr>:cclose<cr>", opts) -- Close the quickfix when opening a file.
		k("n", "<c-p>", ":colder<cr>", opts) -- Open previous list.
		k("n", "<c-n>", ":cnewer<cr>", opts) -- Open next list.

		-- Search and replace on quickfix files.
		-- https://github.com/theHamsta/dotfiles/blob/master/.config/nvim/ftplugin/qf.lua
		k("n", "<leader>r", function()
			local fk = vim.api.nvim_feedkeys
			local tc = vim.api.nvim_replace_termcodes
			local listdo = vim.fn.getloclist(0, { winid = 0 }).winid == 0 and "cdo" or "ldo"
			-- :cdo s//<left><left>
			local cmd = ":" .. listdo .. " s//g<left><left>"
			fk(tc(cmd, true, false, true), "n", false)
		end, opts)

		-- Remove quickfix entry.
		-- https://github.com/famiu/dot-nvim/blob/master/ftplugin/qf.lua
		vim.keymap.set("n", "dd", function()
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local qflist = vim.fn.getqflist()
			-- Remove line from qflist.
			table.remove(qflist, line)
			vim.fn.setqflist(qflist, "r")
			-- Restore cursor position.
			local max_lines = vim.api.nvim_buf_line_count(0)
			vim.api.nvim_win_set_cursor(0, { math.min(line, max_lines), 0 })
		end, opts)
	end,
})
