-- Apply Git status highlights in Oil file manager

local augroup = vim.api.nvim_create_augroup("ruicsh/filetype/oil", { clear = true })
local ns = vim.api.nvim_create_namespace("ruicsh/filetype/oil")

local function get_highlight_group(status_code)
	if not status_code then
		return nil, nil
	end

	local first_char = status_code:sub(1, 1)
	local second_char = status_code:sub(2, 2)

	-- Check staged changes first (prioritize staged over unstaged)
	if first_char == "A" then
		return "OilGitAdded", "+"
	elseif first_char == "M" then
		return "OilGitModified", "~"
	elseif first_char == "R" then
		return "OilGitRenamed", "→"
	end

	-- Check unstaged changes
	if second_char == "M" then
		return "OilGitModified", "~"
	end

	-- Untracked files
	if status_code == "??" then
		return "OilGitUntracked", "?"
	end

	-- Ignored files
	if status_code == "!!" then
		return "OilGitIgnored", "!"
	end

	return nil, nil
end

local function get_git_status()
	local oil = require("oil")
	local current_dir = oil.get_current_dir()
	local git_root = vim.git.get_root_dir()

	if not git_root or not current_dir then
		return {}
	end

	-- Get relative path from git root to current directory
	local rel_path = vim.fs.relpath(current_dir, git_root) or "."
	if rel_path == "" then
		rel_path = "."
	end

	local result = vim.system({
		"git",
		"-C",
		git_root,
		"status",
		"--porcelain",
		"--ignored",
		"--",
		rel_path,
	}, { text = true }):wait()

	if result.code ~= 0 then
		return {}
	end

	local output = result.stdout
	if not output or output == "" then
		return {}
	end

	local status = {}
	for line in output:gmatch("[^\r\n]+") do
		if #line >= 3 then
			local status_code = line:sub(1, 2)
			local filepath = line:sub(4)

			-- Handle renames (format: "old-name -> new-name")
			if status_code:sub(1, 1) == "R" then
				local arrow_pos = filepath:find(" %-> ")
				if arrow_pos then
					filepath = filepath:sub(arrow_pos + 4)
				end
			end

			-- Remove leading "./" if present
			if filepath:sub(1, 2) == "./" then
				filepath = filepath:sub(3)
			end

			-- Convert to absolute path
			local abs_path = vim.fs.joinpath(git_root, filepath)

			status[abs_path] = status_code
		end
	end

	return status
end

local function clear_highlights()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function apply_git_highlights()
	local oil = require("oil")
	local current_dir = oil.get_current_dir()

	local git_status = get_git_status()
	if vim.tbl_isempty(git_status) then
		clear_highlights()
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	clear_highlights()

	for i, line in ipairs(lines) do
		local entry = oil.get_entry_on_line(bufnr, i)
		if entry and entry.type == "file" then
			local filepath = vim.fs.joinpath(current_dir, entry.name)

			local status_code = git_status[filepath]
			local hl_group, symbol = get_highlight_group(status_code)

			if hl_group and symbol then
				-- Find the filename part in the line and highlight it
				local name_start = line:find(entry.name, 1, true)
				if name_start then
					-- Highlight the filename
					vim.fn.matchaddpos(hl_group, { { i, name_start, #entry.name } })

					-- Add symbol as virtual text at the end of the line
					vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
						virt_text = { { symbol, hl_group } },
						virt_text_pos = "eol",
						hl_mode = "combine",
					})
				end
			end
		end
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "oil://*",
	callback = function()
		-- Small delay to ensure oil is fully loaded
		vim.defer_fn(apply_git_highlights, 100)
	end,
})

-- Clear highlights when leaving oil buffers
vim.api.nvim_create_autocmd("BufLeave", {
	group = augroup,
	pattern = "oil://*",
	callback = clear_highlights,
})

-- Refresh when oil buffer content changes (file operations)
vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "TextChangedI" }, {
	group = augroup,
	pattern = "oil://*",
	callback = function()
		vim.schedule(apply_git_highlights)
	end,
})

-- Catch common git-related user events
vim.api.nvim_create_autocmd("User", {
	group = augroup,
	pattern = { "FugitiveChanged" },
	callback = function()
		if vim.bo.filetype == "oil" then
			vim.schedule(apply_git_highlights)
		end
	end,
})
