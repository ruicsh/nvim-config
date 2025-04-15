-- Have a single terminal buffer that can be toggled with a command
-- https://github.com/jaimecgomezz/here.term/

local terminals = {}
local previous_bufs = {}
local terminal_processes = {} -- Track running processes

-- Close the terminal buffer and return to the previous buffer
local function exit_terminal()
	local tab_id = vim.api.nvim_get_current_tabpage()
	local previous_bufnr = previous_bufs[tab_id]

	-- Enter the buffer that was active before the terminal
	if previous_bufnr and vim.fn.buflisted(previous_bufnr) == 1 then
		vim.cmd.buffer(previous_bufnr)
		return
	end

	-- If the previous buffer isn't available, find another valid buffer
	local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })
	for _, buf in ipairs(listed_buffers) do
		if buf.bufnr ~= terminals[tab_id] then
			vim.cmd.buffer(buf.bufnr)
			return
		end
	end
end

-- Get the running process in the terminal buffer
local function get_terminal_process(bufnr)
	if not bufnr then
		return nil
	end

	-- Get job ID associated with this terminal
	local chan_id = vim.fn.getbufvar(bufnr, "terminal_job_id")
	if not chan_id or chan_id == "" then
		return nil
	end

	-- Get process info using jobpid
	local pid = vim.fn.jobpid(chan_id)
	if not pid or pid <= 0 then
		return nil
	end

	-- Use ps to get the shell process name first
	local cmd = string.format("ps -p %d -o comm=", pid)
	local shell_output = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 or not shell_output or shell_output == "" then
		return nil
	end

	-- Now check for child processes of this shell
	cmd = string.format("pgrep -P %d | xargs -I{} ps -p {} -o comm=", pid)
	local child_output = vim.fn.system(cmd)

	-- If there are child processes, return those, otherwise return the shell name
	if child_output and #child_output > 0 and not child_output:match("^%s*$") then
		-- Extract the most interesting process (filtering out common utilities)
		local processes = vim.split(child_output, "\n")
		for _, proc in ipairs(processes) do
			-- Skip empty lines
			if proc and #proc > 0 and not proc:match("^%s*$") then
				-- Extract just the base command without path and trim whitespace
				local base_cmd = proc:gsub("^.*/", ""):match("^%s*(.-)%s*$")
				-- Extract only the command name without arguments
				base_cmd = base_cmd:match("^([^%s]+)")
				if base_cmd ~= "ps" and base_cmd ~= "pgrep" and base_cmd ~= "xargs" then
					return base_cmd
				end
			end
		end
	end
end

-- Open a terminal buffer in the current tab (or reuse the existing one)
local function enter_terminal()
	local tab_id = vim.api.nvim_get_current_tabpage()
	local terminal_bufnr = terminals[tab_id]

	-- Save the current buffer before entering terminal
	previous_bufs[tab_id] = vim.api.nvim_get_current_buf()

	-- Check if terminal exists for this tab and is valid
	if terminal_bufnr and vim.fn.bufexists(terminal_bufnr) == 1 then
		vim.cmd.buffer(terminal_bufnr)
	else
		vim.cmd.terminal()
		terminals[tab_id] = vim.api.nvim_get_current_buf()
	end

	-- Update process info after a short delay to initialize terminal
	vim.defer_fn(function()
		local process = get_terminal_process(terminals[tab_id])
		terminal_processes[tab_id] = process
	end, 500)
end

-- Expose function to get terminal process for the current tab
function _G.get_tab_terminal_process()
	local tab_id = vim.api.nvim_get_current_tabpage()
	local terminal_bufnr = terminals[tab_id]

	-- If we don't have a cached process or it's been more than 5 seconds, refresh
	if terminal_bufnr and vim.fn.bufexists(terminal_bufnr) == 1 then
		terminal_processes[tab_id] = get_terminal_process(terminal_bufnr)
	end

	return terminal_processes[tab_id]
end

vim.api.nvim_create_user_command("ToggleTerminal", function()
	if vim.bo.buftype == "terminal" then
		exit_terminal()
	else
		enter_terminal()
	end
end, {})
