-- Set default filetype to markdown for new, undetected, or unnamed buffers.

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/default-filetype", { clear = true })

-- The initial unnamed buffer is entered before VimEnter. Assigning markdown
-- there would source the markdown ftplugin and start its treesitter parser
-- during startup, even when the buffer is never used. Defer that assignment
-- until the buffer is entered again or first modified, which also covers pasting
-- without ever entering insert mode.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter", "InsertEnter", "TextChanged", "TextChangedI" }, {
	group = augroup,
	callback = function(args)
		-- Skip fugitive buffers: they set their own filetype, and forcing "markdown"
		-- first makes the markdown ftplugin's `b:undo_ftplugin` run on the ft switch,
		-- which unmaps fugitive's buffer-local `gO` (`runtime/ftplugin/markdown.lua`).
		if vim.api.nvim_buf_get_name(args.buf):match("^fugitive://") then
			return
		end

		-- Skip non-file buffers (terminals, prompts, ...): markdown would drag
		-- in its ftplugin, treesitter parser and completion there.
		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		if args.event == "BufEnter" and vim.v.vim_did_enter == 0 then
			return
		end

		if vim.bo[args.buf].filetype == "" then
			vim.bo[args.buf].filetype = "markdown"
		end
	end,
})
