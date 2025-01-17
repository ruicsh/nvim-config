-- Toogle off hlsearch when entering insert mode and the cursor is moved
-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/autocmd.lua

local group = vim.api.nvim_create_augroup("ruicsh/toggle_hlsearch", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	group = group,
	callback = function()
		vim.schedule(function()
			vim.cmd.nohlsearch()
		end)
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
	group = group,
	callback = function()
		if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
			vim.schedule(function()
				vim.cmd.nohlsearch()
			end)
		end
	end,
})
