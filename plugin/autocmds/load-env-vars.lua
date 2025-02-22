-- Load environment variables from .env files

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/load-env-vars", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function()
		-- Load environment variables from .env file in config directory
		vim.fn.load_env_file(vim.fn.stdpath("config"))

		-- Load environment variables from .env file in current working directory
		vim.fn.load_env_file(vim.fn.getcwd())

		-- Load environment variables from .env file in git root
		vim.fn.load_env_file(vim.git.root())
	end,
})
