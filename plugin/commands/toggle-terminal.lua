-- Have a single terminal buffer that can be toggled with a command
-- https://github.com/jaimecgomezz/here.term/

local current_buf = nil
local terminal_buf = nil

local function exit_terminal()
	-- enter the buffer that was active before the terminal
	if vim.fn.buflisted(current_buf) == 1 and current_buf ~= terminal_buf then
		vim.cmd.buffer(current_buf)
		return
	end

	-- if the current buffer is the terminal buffer, then go to the previous buffer
	for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
		if vim.fn.buflisted(buffer) == 1 and buffer ~= terminal_buf then
			vim.cmd.buffer(buffer)
			return
		end
	end
end

local function enter_terminal()
	if vim.fn.bufexists(terminal_buf) == 1 then
		vim.cmd.buffer(terminal_buf)
	else
		vim.cmd.terminal()
		terminal_buf = vim.api.nvim_get_current_buf()
	end
end

vim.api.nvim_create_user_command("ToggleTerminal", function()
	if vim.bo.buftype == "terminal" then
		exit_terminal()
	else
		current_buf = vim.api.nvim_get_current_buf()
		enter_terminal()
	end
end, {})
