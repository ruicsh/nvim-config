-- Bookmarks

local augroup = vim.api.nvim_create_augroup("ruicsh/custom/bookmarks", { clear = true })

-- Cache for storing buffer bookmark information
_G.buffer_bookmarks = {}

-- Function to refresh the bookmark cache
local function refresh_bookmark_cache()
	_G.buffer_bookmarks = {}
	for i = 1, 9 do
		local mark_char = string.char(64 + i) -- A=65, B=66, etc.
		local mark = vim.api.nvim_get_mark(mark_char, {})
		if mark[1] ~= 0 and mark[3] then
			_G.buffer_bookmarks[mark[3]] = i
		end
	end
end

local notification_timer = vim.uv.new_timer()

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

-- Update the bookmark in the current buffer
local function update_bookmark()
	local marks = vim.fn.getmarklist()
	local current_buf_name = vim.fn.expand("%:p")

	-- Filter to only include global marks (uppercase letters)
	local global_marks = {}
	for _, mark_info in ipairs(marks) do
		local mark_char = mark_info.mark:sub(2)
		if mark_char:match("%u$") then
			table.insert(global_marks, mark_info)
		end
	end

	for _, mark_info in ipairs(global_marks) do
		local mark_file = vim.fn.fnamemodify(mark_info.file, ":p")
		-- Extract just the letter from the mark
		local mark_char = mark_info.mark:sub(2)
		-- Check if mark is global (A-Z) and in current buffer
		if mark_file == current_buf_name and mark_char:match("%u$") then
			-- Update the mark to current cursor position
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			vim.api.nvim_buf_set_mark(0, mark_char, cursor_pos[1], cursor_pos[2], {})
			return
		end
	end
end

-- Delete any bookmark from the current buffer
local function delete_bookmark()
	local marks_deleted = false

	for i = 1, 9 do
		local mark_char = string.char(64 + i)
		local mark_pos = vim.api.nvim_get_mark(mark_char, {})

		-- Check if mark is in current buffer
		if mark_pos[1] ~= 0 and vim.api.nvim_get_current_buf() == mark_pos[3] then
			vim.cmd("delmarks " .. mark_char)
			bookmark_notification("Delete mark #" .. i)
			marks_deleted = true
		end
	end

	if not marks_deleted then
		bookmark_notification("No bookmarks found")
	end
end

-- Set keymaps to set marks [1-9] in the current buffer
vim.keymap.set("n", "m", function()
	local char = vim.fn.getchar()
	if type(char) == "string" then
		char = string.byte(char)
	end
	local mark = vim.fn.nr2char(char)

	-- Check if it's a number from 1-9
	if mark:match("[1-9]") then
		delete_bookmark() -- Reset any existing bookmark in the current buffer

		local mark_char = string.char(64 + tonumber(mark)) -- A=65, B=66, etc.
		vim.cmd("mark " .. mark_char)
		refresh_bookmark_cache()
		bookmark_notification("Mark #" .. mark .. " set")
	else
		-- Pass through the 'm' command followed by the key
		vim.fn.feedkeys("m" .. mark, "n")
	end
end, { desc = "Set mark or handle custom marks" })

-- jump to marks [1-9]
vim.keymap.set("n", "'", function()
	local char = vim.fn.getchar()
	if type(char) == "string" then
		char = string.byte(char)
	end
	local mark = vim.fn.nr2char(char)

	-- Check if it's a number from 1-9
	if mark:match("[1-9]") then
		local mark_char = string.char(64 + tonumber(mark))
		local mark_pos = vim.api.nvim_get_mark(mark_char, {})
		if mark_pos[1] == 0 then
			bookmark_notification("Mark #" .. mark .. " not set")
			return
		end

		bookmark_notification("Jump to mark #" .. mark)

		-- Mark exists in another buffer, check if it's displayed in a window
		local target_buf = mark_pos[3]
		local found_window = false

		-- Iterate through all windows to find one displaying the target buffer
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win) == target_buf then
				-- Window found, switch to it
				vim.api.nvim_set_current_win(win)
				found_window = true
				break
			end
		end

		-- If the buffer isn't displayed in any window, jump to it in the current window
		if not found_window then
			vim.cmd("normal! `" .. mark_char)
		end
	else
		-- Pass through the "'" command followed by the key
		vim.fn.feedkeys("'" .. mark, "n")
	end
end)

-- Delete mark from current buffer
vim.keymap.set("n", "<leader>md", delete_bookmark, { desc = "Delete bookmark" })

-- Delete all global marks
vim.keymap.set("n", "<leader>mD", function()
	bookmark_notification("Delete all bookmarks")
	vim.cmd("delmarks A-I")
end, { desc = "Delete all bookmarks" })

-- Build the bookmark cache when first entering a window
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		refresh_bookmark_cache()
	end,
})

-- Update the bookmark when leaving a buffer
vim.api.nvim_create_autocmd("BufLeave", {
	group = augroup,
	callback = function()
		update_bookmark()
		refresh_bookmark_cache()
	end,
})
