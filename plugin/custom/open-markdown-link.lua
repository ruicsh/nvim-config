-- Open Markdown links in browser

local function get_opener()
	if vim.fn.has("mac") == 1 then
		return "open"
	elseif vim.fn.has("unix") == 1 then
		return "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		return "start"
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

		if col >= text_start - 1 and col <= text_end - 1 then
			local opener = get_opener()
			vim.system({ opener, url }):wait()
		else
			vim.system({ "open", vim.fn.expand("<cfile>") })
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "copilot-chat" },
	callback = function()
		vim.keymap.set("n", "gx", open_markdown_url, { buffer = true, silent = true })
	end,
})
