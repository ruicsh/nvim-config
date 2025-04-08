-- Bookmarks

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/bookmarks", { clear = true })

-- Cache for storing buffer bookmark information
_G.file_bookmarks = {}

local notification_timer = vim.uv.new_timer()

-- Convert a character (A-I) to its corresponding mark number (1-9)
local function char2mark(char)
	return char:byte() - 64
end

-- Convert a mark number (1-9) to its corresponding character (A-I)
local function mark2char(mark)
	return string.char(mark + 64)
end

-- Get the key for the current buffer's bookmarks
local function get_bookmark_key()
	local bufnr = vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(bufnr)
	return vim.fn.fnamemodify(file, ":p")
end

-- Display a notification message
local function bookmark_notification(msg)
	if notification_timer then
		notification_timer:stop()
	end

	vim.api.nvim_echo({ { msg, "BookmarkNotification" } }, false, {})
	notification_timer:start(3000, 0, function()
		notification_timer:stop() -- Reset the timer
		vim.schedule(function()
			vim.api.nvim_echo({}, false, {})
		end)
	end)
end

-- Initialize the buffer_bookmarks cache
local function init_buffer_bookmarks()
	local marks = vim.fn.getmarklist()
	for _, mark_info in ipairs(marks) do
		local mark_char = mark_info.mark:sub(2)
		if mark_char:match("%u$") then
			local mark = char2mark(mark_char)
			_G.file_bookmarks[mark_info.file] = mark
		end
	end
end

-- Update the bookmark in the current buffer
local function update_bookmark()
	local key = get_bookmark_key()

	-- Buffer doesn't have any bookmarks
	if not _G.file_bookmarks[key] then
		return
	end

	-- Update cursor position on the bookmark
	local mark = _G.file_bookmarks[key]
	local char = mark2char(mark)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_buf_set_mark(0, char, cursor_pos[1], cursor_pos[2], {})
end

-- Delete any bookmark from the current buffer
local function delete_bookmark()
	local key = get_bookmark_key()
	local mark = _G.file_bookmarks[key]

	if not mark then
		bookmark_notification("No bookmarks found")
		return
	end

	-- Delete any bookmark from the current buffer
	local char = mark2char(mark)
	vim.cmd("delmarks " .. char)
	bookmark_notification("Delete mark #" .. mark)
	_G.file_bookmarks[key] = nil
end

-- Delete all bookmarks accross all buffers
local function delete_all_bookmarks()
	bookmark_notification("Delete all bookmarks")
	vim.cmd("delmarks A-I")
	_G.file_bookmarks = {}
end

-- Get the input mark from the user
local function get_input_mark()
	local nr = vim.fn.getchar()
	if type(nr) == "string" then
		nr = string.byte(nr)
	end

	local mark = vim.fn.nr2char(nr)
	-- Check if it's a number from 1-9
	if mark:match("[1-9]") then
		return mark
	end
end

-- Set keymaps to set marks [1-9] in the current buffer
vim.keymap.set("n", "m", function()
	local mark = get_input_mark()
	if not mark then
		vim.fn.feedkeys("m" .. mark, "n")
		return
	end

	local key = get_bookmark_key()
	local char = mark2char(mark)
	vim.cmd("mark " .. char)
	_G.file_bookmarks[key] = mark

	bookmark_notification("Mark #" .. mark .. " set")
end, { desc = "Set mark or handle custom marks" })

-- jump to marks [1-9]
vim.keymap.set("n", "'", function()
	local mark = get_input_mark()
	if not mark then
		vim.fn.feedkeys("'" .. mark, "n")
		return
	end

	local char = mark2char(mark)
	local mark_pos = vim.api.nvim_get_mark(char, {})
	if mark_pos[1] == 0 then
		bookmark_notification("Mark #" .. mark .. " not set")
		return
	end

	-- If the buffer is displayed in a window, switch to it
	local target_buf = mark_pos[3]
	local found_window = false
	local wins = vim.fn.win_findbuf(target_buf)
	if #wins > 0 then
		vim.api.nvim_set_current_win(wins[1])
		found_window = true
	end

	-- Jump to it in the current window
	if not found_window then
		vim.cmd("normal! `" .. char)
	end

	bookmark_notification("Jump to mark #" .. mark)
end)

-- Delete mark from current buffer
vim.keymap.set("n", "<leader>md", delete_bookmark, { desc = "Delete bookmark" })

-- Delete all global marks
vim.keymap.set("n", "<leader>mD", delete_all_bookmarks, { desc = "Delete all bookmarks" })

-- When entering vim, initialize the file_bookmarks cache
vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function()
		init_buffer_bookmarks()
	end,
})

-- Update the bookmark when leaving a buffer
vim.api.nvim_create_autocmd("BufLeave", {
	group = augroup,
	callback = function()
		update_bookmark()
	end,
})
