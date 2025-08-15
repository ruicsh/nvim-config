-- Toggle OpenCode terminal in a right side panel
-- https://opencode.ai/

local api, fn, map = vim.api, vim.fn, vim.keymap.set

-- Allow override via `vim.g.opencode_command` or ENV OPENCODE_CMD, fallback to "opencode"
local COMMAND = vim.g.opencode_command or vim.env.OPENCODE_CMD or "opencode"

local function has_executable()
	return fn.executable(COMMAND) == 1
end

local function install_help()
	return table.concat({
		"opencode CLI not found (" .. COMMAND .. ")",
		"Install it with one of:",
		"  curl -fsSL https://opencode.ai/install | bash",
		"  brew install sst/tap/opencode   # macOS",
		"  npm i -g opencode-ai            # Node.js",
		"Then run: opencode auth login",
	}, "\n")
end

local function is_opencode_terminal(bufnr)
	if not bufnr or not api.nvim_buf_is_valid(bufnr) then
		return false
	end

	if api.nvim_get_option_value("buftype", { buf = bufnr }) ~= "terminal" then
		return false
	end

	-- Prefer explicit marker; fallback to name heuristic.
	if vim.b[bufnr] and vim.b[bufnr].opencode_terminal then
		return true
	end

	local name = api.nvim_buf_get_name(bufnr)
	return name:match((":%s$"):format(COMMAND)) ~= nil
end

local function is_job_running(bufnr)
	if not bufnr or not api.nvim_buf_is_valid(bufnr) then
		return false
	end

	local job_id = vim.b[bufnr] and vim.b[bufnr].terminal_job_id
	if type(job_id) ~= "number" or job_id <= 0 then
		return false
	end

	local status = fn.jobwait({ job_id }, 0)[1]
	return status == -1 -- -1 means still running
end

-- Find an opencode terminal window.
-- Returns a table { tab, win, buf, running } or nil.
-- Prefers a running session; otherwise returns the first stale one.
local function find_opencode_window()
	local stale
	for _, tab in ipairs(api.nvim_list_tabpages()) do
		for _, win in ipairs(api.nvim_tabpage_list_wins(tab)) do
			local buf = api.nvim_win_get_buf(win)
			if is_opencode_terminal(buf) then
				if is_job_running(buf) then
					return { tab = tab, win = win, buf = buf, running = true }
				elseif not stale then
					stale = { tab = tab, win = win, buf = buf, running = false }
				end
			end
		end
	end
	return stale
end

local function focus(tab, win)
	if api.nvim_tabpage_is_valid(tab) then
		api.nvim_set_current_tabpage(tab)
	end

	if api.nvim_win_is_valid(win) then
		api.nvim_set_current_win(win)
	end
end

local function spawn_opencode_terminal_in(win, stale_buf)
	if not has_executable() then
		vim.notify(install_help(), vim.log.levels.WARN, { title = "opencode" })
		return
	end

	if win and api.nvim_win_is_valid(win) then
		api.nvim_set_current_win(win)
	end

	-- Clean stale terminal buffer if present (non-running).
	if stale_buf and api.nvim_buf_is_valid(stale_buf) then
		pcall(api.nvim_buf_delete, stale_buf, { force = true })
	end

	vim.cmd(("terminal %s"):format(COMMAND))
	vim.b.opencode_terminal = true
	vim.bo.bufhidden = "wipe" -- avoid hidden terminal buffer bloat
	vim.cmd("startinsert")
end

local function toggle_opencode_terminal()
	local found = find_opencode_window()

	-- If the current window is an opencode terminal, close it (true toggle)
	local cur_buf = api.nvim_get_current_buf()
	if is_opencode_terminal(cur_buf) then
		-- If it's the only window in tab, close the tab; else just close window
		if #api.nvim_tabpage_list_wins(api.nvim_get_current_tabpage()) == 1 then
			vim.cmd("tabclose")
		else
			vim.cmd("close")
		end
		return
	end

	if found and found.running then
		focus(found.tab, found.win)
		vim.cmd("startinsert")
		return
	end

	if found then
		focus(found.tab, found.win)
		spawn_opencode_terminal_in(found.win, found.buf)
		return
	end

	-- Open in a right side panel instead of a new tab
	local panel_win = vim.ux and vim.ux.open_side_panel(false)
	if panel_win and api.nvim_win_is_valid(panel_win) then
		spawn_opencode_terminal_in(panel_win)
	else
		-- Fallback to vertical split if panel API unavailable
		vim.cmd("vsplit")
		spawn_opencode_terminal_in(api.nvim_get_current_win())
	end
end

-- Keymap
map("n", "<leader><c-a>", toggle_opencode_terminal, {
	desc = "Toggle OpenCode Terminal",
	silent = true,
})

-- User command
api.nvim_create_user_command("OpencodeToggle", toggle_opencode_terminal, {})

-- Cleanup: auto-wipe terminal buffers on exit if marked
api.nvim_create_autocmd("TermClose", {
	desc = "Auto-wipe opencode terminal buffers when process exits",
	callback = function(args)
		local buf = args.buf
		if is_opencode_terminal(buf) and not is_job_running(buf) then
			-- Use a defer to let terminal finish closing cleanly
			vim.schedule(function()
				if api.nvim_buf_is_valid(buf) then
					pcall(api.nvim_buf_delete, buf, { force = true })
				end
			end)
		end
	end,
})
