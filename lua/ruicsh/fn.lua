-- Takes a table of keys, returns a keymaps lazy config
vim.fn.get_lazy_keys_conf = function(mappings, desc_prefix)
	return vim.tbl_map(function(mapping)
		local lhs = mapping[1]
		local rhs = mapping[2]
		local desc = desc_prefix and desc_prefix .. ": " .. mapping[3] or mapping[3]
		local opts = mapping[4]
		local mode = opts and opts.mode or "n"
		local expr = opts and opts.expr or false
		local remap = opts and opts.remap or false

		return {
			lhs,
			rhs,
			mode = mode,
			noremap = true,
			unique = true,
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

-- Read .env files on a given directory
vim.fn.load_env_file = function(dir)
	dir = dir and dir or vim.fn.stdpath("config")

	if not dir or not vim.fn.isdirectory(dir) then
		return
	end

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
