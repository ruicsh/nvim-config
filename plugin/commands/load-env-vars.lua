-- Load environment variables from .env files

vim.api.nvim_create_user_command("LoadEnvVars", function()
	local dirs = {
		-- Config directory
		vim.fn.stdpath("config"),
		-- Current working directory
		vim.fn.getcwd(),
		-- Git root directory
		vim.git.root(),
	}

	for _, dir in ipairs(dirs) do
		if vim.fn.isdirectory(dir) == 1 then
			local file = dir .. "/.env"
			if vim.fn.filereadable(file) == 1 then
				vim.fn.load_env_file(dir)
			end
		end
	end
end, {})
