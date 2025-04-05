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

-- Set keymaps for toggling marks [A-I] in the current buffer
for i = 1, 9 do
	local mark_char = string.char(64 + i) -- A=65, B=66, etc.

	vim.keymap.set("n", "<leader>" .. i, function()
		local mark_pos = vim.api.nvim_get_mark(mark_char, {})
		local current_buf = vim.api.nvim_get_current_buf()

		-- Check if mark already exists
		if mark_pos[1] == 0 then
			-- Before setting a new mark, check if current buffer already has any global mark
			local buffer_has_mark = false
			for j = 1, 9 do
				local check_mark_char = string.char(64 + j)
				local check_mark_pos = vim.api.nvim_get_mark(check_mark_char, {})
				if check_mark_pos[1] ~= 0 and check_mark_pos[3] == current_buf then
					buffer_has_mark = true
					break
				end
			end

			-- Mark doesn't exist and buffer doesn't have a mark. Set it.
			if not buffer_has_mark then
				vim.cmd("normal! gg")
				vim.cmd("mark " .. mark_char)
				vim.cmd("normal! ``") -- Jump back to where we were
			end
		elseif mark_pos[3] ~= current_buf then
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
				vim.cmd('normal! `"') -- Jump to the last cursor position before leaving
			end
		end
	end, { desc = "Toggle mark " .. i })
end

-- Delete mark from current buffer
vim.keymap.set("n", "<leader>bd", function()
	for i = 1, 9 do
		local mark_char = string.char(64 + i)
		local mark_pos = vim.api.nvim_get_mark(mark_char, {})

		-- Check if mark is in current buffer
		if mark_pos[1] ~= 0 and vim.api.nvim_get_current_buf() == mark_pos[3] then
			vim.cmd("delmarks " .. mark_char)
		end
	end
end, { desc = "Delete bookmark" })

-- Delete all global marks
vim.keymap.set("n", "<leader>bD", function()
	vim.cmd("delmarks A-I")
end, { desc = "Delete all bookmarks" })

-- Build the bookmark cache when first entering a window
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		refresh_bookmark_cache()
	end,
})
