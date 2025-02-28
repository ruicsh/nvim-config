-- Open Markdown links in vim/browser

local function open_markdown_link()
	local line = vim.api.nvim_get_current_line()

	-- Pattern to match Markdown links [text](url)
	local start_idx, _, _, url = string.find(line, "%[([^%]]+)%]%(([^%)]+)%)")

	-- If no inline link found, try reference-style links [text][reference]
	if not start_idx then
		start_idx, _, _, url = string.find(line, "%[([^%]]+)%]%[([^%]]+)%]")
	end

	if start_idx then
		local target = (url or vim.fn.expand("<cfile>"))
		if target:match("^https?://") then
			-- Handle URLs with vim.ui.open
			local success, err = pcall(vim.ui.open, target)
			if not success then
				vim.notify("Failed to open URL: " .. err, vim.log.levels.ERROR)
			end
		else
			-- Handle local files with vim commands
			target = vim.fn.fnamemodify(target, ":p")
			if vim.fn.filereadable(target) == 1 then
				-- Use edit command to open the file
				vim.cmd("edit " .. vim.fn.fnameescape(target))
			else
				vim.notify("File not found: " .. target, vim.log.levels.WARN)
			end
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "copilot-chat" },
	callback = function()
		vim.keymap.set("n", "gx", open_markdown_link, { buffer = true, silent = true })
	end,
})
