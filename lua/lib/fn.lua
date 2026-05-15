local M = {}

-- Check if a keymap is set
M.is_keymap_set = function(mode, lhs)
	local keymaps = vim.api.nvim_get_keymap(mode)
	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == lhs then
			return true
		end
	end
	return false
end

-- Check if it's running on Windows
M.is_windows = function()
	return vim.fn.has("win32") == 1
end

M.fmt_relative_time = function(timestamp)
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

M.urlencode = function(str)
	return (str:gsub("[^%w%-_%.~]", function(c)
		return string.format("%%%02X", string.byte(c))
	end))
end

-- Returns a list of { key, count } for non-zero diagnostic severities in the given buffer.
-- key is one of "error", "warning", "information", "hint".
local DIAGNOSTIC_SEVERITIES = {
	{ key = "error", severity = vim.diagnostic.severity.ERROR },
	{ key = "warning", severity = vim.diagnostic.severity.WARN },
	{ key = "information", severity = vim.diagnostic.severity.INFO },
	{ key = "hint", severity = vim.diagnostic.severity.HINT },
}

M.diagnostic_counts = function(bufnr)
	local results = {}
	for _, entry in ipairs(DIAGNOSTIC_SEVERITIES) do
		local s = entry.severity
		local count = vim.diagnostic.count(bufnr, { severity = s })[s]
		if count and count > 0 then
			table.insert(results, { key = entry.key, count = count })
		end
	end
	return results
end

--- Get a buffer-local variable, falling back to the alternate buffer if not found in the current one.
---@param name string
---@return any
M.get_buf_var = function(name)
	local val = vim.b[name]
	if val == nil or val == "" then
		local alt_buf = vim.fn.bufnr("#")
		if alt_buf > 0 and vim.api.nvim_buf_is_valid(alt_buf) then
			val = vim.b[alt_buf][name]
		end
	end
	return val
end

return M
