-- CodeCompanion chat buffers
-- https://codecompanion.olimorris.dev

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/codecompanion", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "codecompanion",
	group = augroup,
	callback = function(args)
		vim.schedule(function()
			if vim.api.nvim_get_current_buf() == args.buf then
				vim.cmd("startinsert")
			end
		end)

		-- Buffer-local BufLeave
		vim.api.nvim_create_autocmd("BufLeave", {
			group = augroup,
			buffer = args.buf,
			callback = function()
				vim.cmd("stopinsert")
			end,
		})
	end,
})
