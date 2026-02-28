local fn = require("lib/fn")

local M = {}

local is_loaded = false

-- Read env files on a given directory
local function load_from_dir(dir)
	dir = dir and dir or vim.fn.stdpath("config")
	if not dir or not vim.fn.isdirectory(dir) then
		return
	end

	local dir_sep = fn.is_windows() and "\\" or "/"
	local file = dir .. dir_sep .. ".nvim.env"
	local env_file = io.open(file, "r")
	if not env_file then
		return
	end

	local ok, err = pcall(function()
		for line in env_file:lines() do
			if not line:match("^%s*#") then -- Skip comments
				for key, value in string.gmatch(line, "([%w_]+)%s*=%s*([^#]+)") do -- varname=value
					value = value:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
					vim.fn.setenv(key, value)
				end
			end
		end
	end)

	env_file:close()

	if not ok then
		vim.notify("Error parsing " .. file .. ": " .. tostring(err), vim.log.levels.WARN)
	end
end

M.load = function()
	-- Load the env file only once
	if not is_loaded then
		-- Deduplicate directories to avoid loading the same .nvim.env twice
		-- (e.g., when cwd is already the git root)
		local seen = {}
		for _, dir in ipairs({
			vim.fn.stdpath("config"), -- Neovim configuration directory
			vim.fs.root(vim.fn.getcwd(), ".git"), -- Git root directory
			vim.fn.getcwd(), -- Current working directory
		}) do
			if dir and not seen[dir] then
				seen[dir] = true
				load_from_dir(dir)
			end
		end
		is_loaded = true
	end
end

-- Read an environment variable, separated by commas, and returns a list
M.get_list = function(key)
	local env = M.get(key)
	if not env then
		return {}
	end

	return vim.split(env, ",")
end

M.get_bool = function(key)
	local env = M.get(key)
	if not env then
		return false
	end

	env = env:lower()
	return env == "1" or env == "true" or env == "yes" or env == "on"
end

M.get_number = function(key)
	local env = M.get(key)
	if not env then
		return nil
	end

	return tonumber(env)
end

M.get = function(key)
	M.load()

	local env = vim.fn.getenv(key)
	if env == vim.NIL or env == "" then
		return nil
	end

	return env
end

return M
