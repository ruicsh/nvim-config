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
	mark = tostring(mark)
	if mark:match("[1-9]") then
		return string.char(tonumber(mark) + 64)
	end
	return mark
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
		bookmark_notification("No bookmark found")
		return
	end

	-- Delete any bookmark from the current buffer
	local char = mark2char(mark)
	vim.cmd("delmarks " .. char)
	bookmark_notification("Deleted bookmark #" .. mark)
	_G.file_bookmarks[key] = nil
end

-- Delete all bookmarks accross all buffers
local function delete_all_bookmarks()
	bookmark_notification("Deleted all bookmarks")
	vim.cmd("delmarks A-I")
	_G.file_bookmarks = {}
end

-- Set keymaps to set marks [1-9] in the current buffer
vim.keymap.set("n", "m", function()
	local mark = vim.fn.getcharstr()
	local char = mark2char(mark)
	local key = get_bookmark_key()
	vim.cmd("mark " .. char)

	if not mark:match("[1-9]") then
		bookmark_notification("Set mark " .. mark)
	else
		_G.file_bookmarks[key] = char
		bookmark_notification("Set bookmark #" .. mark)
	end
end, { desc = "Set mark or handle custom marks" })

-- jump to marks [1-9]
vim.keymap.set("n", "'", function()
	local mark = vim.fn.getcharstr()

	-- Default behavior for marks [a-z]
	if not mark:match("[1-9]") then
		vim.fn.feedkeys("'" .. mark, "n")
		return
	end

	-- If the buffer is displayed in a window, switch to it
	local char = mark2char(mark)
	local mark_pos = vim.api.nvim_get_mark(char, {})
	if mark_pos[1] == 0 then
		bookmark_notification("Bookmark #" .. mark .. " not set")
		return
	end

	local target_buf = mark_pos[3]
	local found_window = false
	local wins = vim.fn.win_findbuf(target_buf)
	if #wins > 0 then
		vim.api.nvim_set_current_win(wins[1])
		found_window = true
		return
	end

	-- Jump to it in the current window
	if not found_window then
		vim.cmd("normal! `" .. char)
	end

	bookmark_notification("Jump to bookmark #" .. mark)
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
