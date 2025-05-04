-- Have a single terminal buffer that can be toggled with a command
-- https://github.com/jaimecgomezz/here.term/

local terminals = {}
local previous_bufs = {}

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
end

vim.api.nvim_create_user_command("ToggleTerminal", function()
	if vim.bo.buftype == "terminal" then
		exit_terminal()
	else
		enter_terminal()
	end
end, {})

vim.keymap.set("t", "<c-\\>", function()
	vim.cmd("ToggleTerminal")
end, { desc = "Toggle terminal", unique = true, noremap = true })
