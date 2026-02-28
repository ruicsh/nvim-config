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

local spinners = {} -- Store spinner timers by buffer
local icon_spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

M.start_spinner = function(bufnr, msg)
	-- Stop any existing spinner for this buffer first to avoid timer leak
	if spinners[bufnr] then
		M.stop_spinner(bufnr)
	end

	local spinner_timer = vim.uv.new_timer()
	spinners[bufnr] = { idx = 1, timer = spinner_timer }

	spinners[bufnr].timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			-- Check if the buffer is still valid before updating it
			if not vim.api.nvim_buf_is_valid(bufnr) then
				M.stop_spinner(bufnr)
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
			-- Move cursor to the last line only if we're currently in this buffer
			if vim.api.nvim_get_current_buf() == bufnr then
				local line_count = vim.api.nvim_buf_line_count(bufnr)
				pcall(vim.api.nvim_win_set_cursor, 0, { line_count, 0 })
			end
		end)
	)
end

M.stop_spinner = function(bufnr)
	if spinners[bufnr] then
		spinners[bufnr].timer:stop()
		spinners[bufnr].timer:close()
		spinners[bufnr] = nil
	end
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
local DIAGNOSTIC_KEYS = { "error", "warning", "information", "hint" }
M.diagnostic_counts = function(bufnr)
	local results = {}
	for i, key in ipairs(DIAGNOSTIC_KEYS) do
		local ki = vim.diagnostic.severity[i]
		local severity = vim.diagnostic.severity[ki]
		local count = vim.diagnostic.count(bufnr, { severity = severity })[severity]
		if count and count > 0 then
			table.insert(results, { key = key, count = count })
		end
	end
	return results
end

return M
