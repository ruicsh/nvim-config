-- Open Markdown links in browser

local function get_opener()
	if vim.fn.has("mac") == 1 then
		return "open"
	elseif vim.fn.has("unix") == 1 then
		return "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		return "cmd.exe"
	end
end

local function open_markdown_url()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]

	-- Pattern to match Markdown links [text](url)
	local start_idx, _, text, url = string.find(line, "%[([^%]]+)%]%(([^%)]+)%)")

	if start_idx then
		-- Check if cursor is within the text portion of the link
		local text_start = start_idx + 1
		local text_end = text_start + #text - 1

		local opener = get_opener()
		local cmd
		if vim.fn.has("win32") == 1 then
			if col >= text_start - 1 and col <= text_end - 1 then
				cmd = { opener, "/c", "start", "", url }
			else
				cmd = { opener, "/c", "start", "", vim.fn.expand("<cfile>") }
			end
		else
			if col >= text_start - 1 and col <= text_end - 1 then
				cmd = { opener, url }
			else
				cmd = { opener, vim.fn.expand("<cfile>") }
			end
		end

		vim.system(cmd):wait()
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "copilot-chat" },
	callback = function()
		vim.keymap.set("n", "gx", open_markdown_url, { buffer = true, silent = true })
	end,
})
