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
		if not line:match("^%s*#") then -- Skip comments
			for key, value in string.gmatch(line, "([%w_]+)%s*=%s*([^#]+)") do -- varname=value
				value = value:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
				vim.fn.setenv(key, value)
			end
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
