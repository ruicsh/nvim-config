-- Set default filetype to markdown for new, undetected, or unnamed buffers.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/default-filetype", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
	group = augroup,
	callback = function(args)
		-- Skip fugitive buffers: they set their own filetype, and forcing "markdown"
		-- first makes the markdown ftplugin's `b:undo_ftplugin` run on the ft switch,
		-- which unmaps fugitive's buffer-local `gO` (`runtime/ftplugin/markdown.lua`).
		if vim.api.nvim_buf_get_name(args.buf):match("^fugitive://") then
			return
		end

		if vim.bo[args.buf].filetype == "" then
			vim.bo[args.buf].filetype = "markdown"
		end
	end,
})
