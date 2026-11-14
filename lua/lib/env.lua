local fn = require("lib/fn")

local M = {}

local is_loaded = false

-- File read for the Neovim process itself. Other tools (rest.nvim, etc.) have
-- their own naming conventions, so `discover` takes the pattern from the caller.
local NVIM_ENV_FILE = "^%.nvim%.env$"

local function is_dir(path)
	return path ~= nil and path ~= "" and vim.fn.isdirectory(path) == 1
end

-- True when `name` matches any of the `patterns`.
local function is_excluded(name, patterns)
	if not patterns then
		return false
	end
	for _, pattern in ipairs(patterns) do
		if name:match(pattern) then
			return true
		end
	end
	return false
end

-- Non-recursive list of files in `dir` matching `pattern` (and no `exclude`).
local function files_in(dir, pattern, exclude)
	local files = {}
	for name, kind in vim.fs.dir(dir) do
		-- `kind ~= "directory"` rather than `kind == "file"` so symlinked
		-- dotfiles (a common dotfiles setup) are not skipped.
		if kind ~= "directory" and name:match(pattern) and not is_excluded(name, exclude) then
			files[#files + 1] = vim.fs.joinpath(dir, name)
		end
	end
	return files
end

--- Find files matching `opts.pattern` and return their paths.
---
--- By default roots are the current buffer's directory and the cwd, each walked
--- upwards, so a file next to the buffer wins over a project one. Results are
--- deduplicated; `sort = false` preserves the root/walk order (needed when the
--- caller relies on precedence, e.g. later files overriding earlier ones).
---@param opts { pattern: string, exclude?: string|string[], roots?: string[], upward?: boolean, sort?: boolean }
---@return string[]
M.discover = function(opts)
	assert(opts and type(opts.pattern) == "string", "lib.env.discover requires a `pattern`")

	local roots = opts.roots or { vim.fs.dirname(vim.api.nvim_buf_get_name(0)), vim.fn.getcwd() }
	local exclude = type(opts.exclude) == "string" and { opts.exclude } or opts.exclude
	local files, seen = {}, {}

	for _, root in ipairs(roots) do
		local dir = root
		while is_dir(dir) do
			for _, path in ipairs(files_in(dir, opts.pattern, exclude)) do
				if not seen[path] then
					seen[path] = true
					files[#files + 1] = path
				end
			end
			if opts.upward == false then
				break
			end
			local parent = vim.fs.dirname(dir)
			if parent == dir then
				break
			end
			dir = parent
		end
	end

	if opts.sort ~= false then
		table.sort(files)
	end
	return files
end

-- Read the `KEY=value` pairs of an env file into the process environment.
local function load_file(file)
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
	if is_loaded then
		return
	end
	is_loaded = true

	-- Precedence: Neovim config directory, then the git root, then the cwd, so
	-- the more specific file wins. Deduplicated by `discover` when the cwd is
	-- already the git root, and unsorted to keep this order.
	local roots = { vim.fn.stdpath("config") }
	local git_root = vim.fs.root(vim.fn.getcwd(), ".git")
	if git_root then
		roots[#roots + 1] = git_root
	end
	roots[#roots + 1] = vim.fn.getcwd()

	local files = M.discover({
		pattern = NVIM_ENV_FILE,
		roots = roots,
		upward = false,
		sort = false,
	})
	for _, file in ipairs(files) do
		load_file(file)
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
