vim.fn = vim.fn or {}

-- Takes a table of keys, returns a keymaps lazy config
vim.fn.get_lazy_keys_config = function(mappings, desc_prefix)
	return vim.tbl_map(function(mapping)
		local lhs = mapping[1]
		local rhs = mapping[2]
		local desc = desc_prefix and desc_prefix .. ": " .. mapping[3] or mapping[3]
		local opts = mapping[4]
		local mode = opts and opts.mode or "n"
		local expr = opts and opts.expr or false
		local remap = opts and opts.remap or false

		local unique = true
		if opts and opts.unique ~= nil then
			unique = opts.unique
		end

		return {
			lhs,
			rhs,
			mode = mode,
			noremap = true,
			unique = unique,
			desc = desc,
			expr = expr,
			remap = remap,
		}
	end, mappings)
end

-- Check if a keymap is set
vim.fn.is_keymap_set = function(mode, lhs)
	local keymaps = vim.api.nvim_get_keymap(mode)
	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == lhs then
			return true
		end
	end
	return false
end

-- Check if a diff window is open
vim.fn.is_diff_open = function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_get_option_value("diff", { win = win }) then
			return true
		end
	end
end

-- Check if it's running on Windows
vim.fn.is_windows = function()
	return vim.fn.has("win32") == 1
end

vim.fn.get_lsp_client = function(client_id)
	for _, client in pairs(vim.lsp.get_clients()) do
		if client.id == client_id then
			return client
		end
	end

	return nil
end

-- Create a notification and remove it after delay (in ms)
vim.fn.notify = function(msg, log_level)
	local notify = require("mini.notify")

	local id = notify.add(msg, log_level)
	vim.defer_fn(function()
		notify.remove(id)
	end, 3000)

	return id
end

-- Read env files on a given directory
vim.fn.load_env_file = function(dir)
	dir = dir and dir or vim.fn.stdpath("config")
	if not dir or not vim.fn.isdirectory(dir) then
		return
	end

	local dir_sep = vim.fn.is_windows() and "\\" or "/"
	local file = dir .. dir_sep .. ".nvim.env"
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

-- Read an environment variable, separated by commas, and returns a list
vim.fn.env_get_list = function(key)
	local list = {}
	local env = vim.fn.getenv(key)
	if env ~= vim.NIL and env ~= "" then
		list = vim.split(env, ",")
	end

	return list
end

local env_file_loaded = false

vim.fn.env_get = function(key)
	-- Load the env file only once
	if not env_file_loaded then
		vim.fn.load_env_file(vim.fn.stdpath("config"))
		vim.fn.load_env_file(vim.fn.getcwd())
		env_file_loaded = true
	end

	local env = vim.fn.getenv(key)
	if env == vim.NIL or env == "" then
		return nil
	end

	return env
end

local spinners = {} -- Store spinner timers by buffer
local icon_spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

vim.fn.start_spinner = function(bufnr, msg)
	local new_timer = vim.uv and vim.uv.new_timer or vim.loop.new_timer
	local spinner_timer = new_timer()
	if not spinners[bufnr] then
		spinners[bufnr] = { idx = 1, timer = spinner_timer }
	end

	spinners[bufnr].timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			-- Check if the buffer is still valid before updating it
			if not vim.api.nvim_buf_is_valid(bufnr) then
				vim.fn.stop_spinner(bufnr)
				return
			end

			if not spinners[bufnr] then
				return
			end

			spinners[bufnr].idx = (spinners[bufnr].idx % #icon_spinner) + 1
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
				icon_spinner[spinners[bufnr].idx] .. " " .. msg,
				"",
			})
			vim.cmd("normal! j") -- Set cursor on the last line
		end)
	)
end

vim.fn.stop_spinner = function(bufnr)
	if spinners[bufnr] then
		spinners[bufnr].timer:stop()
		spinners[bufnr].timer:close()
		spinners[bufnr] = nil
	end
end

vim.fn.exec = function(cmd)
	local handle = io.popen(cmd, "r")
	if not handle then
		vim.notify("Could not execute command: " .. cmd)
		return nil
	end

	local result = handle:read("*a")
	handle:close()

	return result
end

vim.fn.fmt_relative_time = function(timestamp)
	-- Get current timestamp for relative time calculations
	local now = os.time()
	local diff = now - timestamp

	-- Format different time ranges
	if diff < 60 then
		return "now"
	elseif diff < 3600 then
		local mins = math.floor(diff / 60)
		return string.format("%dm", mins)
	elseif diff < 86400 then
		local hours = math.floor(diff / 3600)
		return string.format("%dh", hours)
	elseif diff < 30 * 24 * 60 * 60 then
		local days = math.floor(diff / 86400)
		return string.format("%dd", days)
	else
		-- For older dates, return full date format
		return os.date("%Y-%m-%d", timestamp)
	end
end

vim.fn.urlencode = function(str)
	return (str:gsub("[^%w%-_%.~]", function(c)
		return string.format("%%%02X", string.byte(c))
	end))
end
