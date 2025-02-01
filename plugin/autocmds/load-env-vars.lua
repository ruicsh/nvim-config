-- Load environment variables from .env files

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/load_env_vars", { clear = true })

-- Load environment variables from .env file
local function load_env_file(dir)
	local file = dir .. "/.env"
	local env_file = io.open(file, "r")
	if not env_file then
		return
	end

	for line in env_file:lines() do
		for key, value in string.gmatch(line, "([%w_]+)=([%w_-]+)") do
			vim.fn.setenv(key, value)
		end
	end

	env_file:close()
end

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function()
		-- Load environment variables from .env file in config directory
		load_env_file(vim.fn.stdpath("config"))

		-- Load environment variables from .env file in current working directory
		load_env_file(vim.fn.getcwd())
	end,
})
