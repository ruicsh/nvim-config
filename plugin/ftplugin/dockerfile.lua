-- Dockerfile

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/dockerfile", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup,
	pattern = { "Dockerfile", "dockerfile", "dockerfile.*" },
	callback = function()
		if vim.bo.filetype == "lua" then
			return
		end

		vim.bo.filetype = "dockerfile"
	end,
})
