-- Toggle off hlsearch when entering insert mode and the cursor is moved
-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/autocmd.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/toggle-hlsearch", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	group = augroup,
	callback = function()
		vim.schedule(function()
			vim.cmd.nohlsearch()
		end)
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
	group = augroup,
	callback = function()
		if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
			vim.schedule(function()
				vim.cmd.nohlsearch()
			end)
		end
	end,
})
