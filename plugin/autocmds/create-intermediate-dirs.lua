-- Create intermediate dirs
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/create-intermediate-dirs", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup,
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end

		local fs_realpath = vim.uv and vim.uv.fs_realpath or vim.loop.fs_realpath
		local file = fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
