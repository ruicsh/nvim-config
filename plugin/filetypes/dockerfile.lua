vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("ruicsh/filetypes/dockerfile", { clear = true }),
	pattern = { "Dockerfile", "dockerfile", "dockerfile.*" },
	callback = function()
		-- Ignore this file
		if vim.bo.filetype == "lua" then
			return
		end

		-- Set the filetype to any files with dockerfile in the name
		vim.bo.filetype = "dockerfile"
	end,
})
