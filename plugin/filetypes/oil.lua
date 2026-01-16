-- Apply Git status highlights in Oil file manager

local T = require("lib")

local augroup = vim.api.nvim_create_augroup("ruicsh/filetype/oil", { clear = true })
local ns = vim.api.nvim_create_namespace("ruicsh/filetype/oil")

-- Return symbol and highlight group for a given git status code
local function get_symbol_hl_group(status_code)
	if not status_code then
		return nil, nil
	end

	local first_char = status_code:sub(1, 1)
	local second_char = status_code:sub(2, 2)

	if first_char == "A" or second_char == "A" then
		return "+", "diffAdded"
	elseif first_char == "M" or second_char == "M" then
		return "~", "diffChanged"
	elseif first_char == "R" or second_char == "R" then
		return "→", "diffRenamed"
	elseif first_char == "D" or second_char == "D" then
		return "-", "diffChanged"
	elseif first_char == "?" then
		return "?", "diffFile"
	elseif first_char == "!" then
		return "!", "diffIgnored"
	end

	return nil, nil
end

-- Get git status for files in the current Oil directory
local function get_git_status(callback)
	local oil = require("oil")
	local current_dir = oil.get_current_dir()
	local git_root = vim.fs.root(0, ".git")

	if not git_root or not current_dir then
		callback({})
		return
	end

	local rel_path = vim.fs.relpath(current_dir, git_root) or "."
	if rel_path == "" then
		rel_path = "."
	end

	-- Use git -c core.quotepath=false for Windows compatibility
	-- Only check current directory, not subdirectories
	vim.system({
		"git",
		"-C",
		git_root,
		"-c",
		"core.quotepath=false",
		"status",
		"--ignored=traditional",
		"--ignore-submodules=all",
		"--porcelain=v1",
		"--untracked-files=all",
		"--short",
		".",
	}, { text = true, cwd = current_dir }, function(result)
		if result.code ~= 0 or not result.stdout or result.stdout == "" then
			callback({})
			return
		end

		local status = {}
		for line in result.stdout:gmatch("[^\r\n]+") do
			if #line >= 3 then
				local status_code = line:sub(1, 2)
				local filepath = line:sub(4)

				if status_code:sub(1, 1) == "R" then
					local arrow_pos = filepath:find(" %-> ")
					if arrow_pos then
						filepath = filepath:sub(arrow_pos + 4)
					end
				end

				if filepath:sub(1, 2) == "./" then
					filepath = filepath:sub(3)
				end
				local abs_path = vim.fs.joinpath(git_root, filepath)
				status[abs_path] = status_code
			end
		end
		callback(status)
	end)
end

-- Clear all git highlights in the current buffer
local function clear_highlights()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	vim.fn.clearmatches()
end

-- Build reverse index: dir_path -> { has_added = true, has_changed = true, ... }
local function build_dir_status_index(git_status)
	local dir_status_index = {}

	for file, status_code in pairs(git_status) do
		if status_code then
			local dir = vim.fs.dirname(file)
			while dir and dir ~= "" do
				dir_status_index[dir] = status_code
				local parent = vim.fs.dirname(dir)
				if parent == dir then
					break
				end
				dir = parent
			end
		end
	end

	return dir_status_index
end

-- Apply git highlights to the current Oil buffer
local function apply_git_highlights()
	get_git_status(function(git_status)
		vim.schedule(function()
			-- Needs to be scheduled to avoid calling nvim API from async callback
			if vim.tbl_isempty(git_status) then
				clear_highlights()
				return
			end

			local oil = require("oil")
			local current_dir = oil.get_current_dir()
			local bufnr = vim.api.nvim_get_current_buf()
			local oil_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local dir_status_index = build_dir_status_index(git_status)

			clear_highlights()

			for linenr, oil_line in ipairs(oil_lines) do
				local entry = oil.get_entry_on_line(bufnr, linenr)
				if entry then
					local path = vim.fs.joinpath(current_dir, entry.name)

					-- Determine status code for the entry
					local status_code = nil
					if entry and entry.type == "directory" then
						status_code = dir_status_index[path]
					elseif entry and entry.type == "file" then
						status_code = git_status[path]
					end

					-- Apply highlights based on status code
					local symbol, hl_group = get_symbol_hl_group(status_code)
					if symbol and hl_group then
						local name_start = oil_line:find(entry.name, 1, true)
						if name_start then
							vim.fn.matchaddpos(hl_group, { { linenr, name_start, #entry.name } })
							vim.api.nvim_buf_set_extmark(bufnr, ns, linenr - 1, 0, {
								virt_text = { { symbol, hl_group } },
								virt_text_pos = "eol",
								hl_mode = "combine",
							})
						end
					end
				end
			end
		end)
	end)
end

-- Safely apply highlights, retrying if Oil is not ready
local function safe_apply_highlights()
	local oil = require("oil")
	local current_dir = oil.get_current_dir()

	if not current_dir then
		-- Oil not ready, retry
		vim.defer_fn(safe_apply_highlights, 25)
		return
	end

	-- Check if Oil has populated the buffer with entries
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local has_entries = false

	for i = 1, math.min(#lines, 5) do -- Check first few lines
		if oil.get_entry_on_line(bufnr, i) then
			has_entries = true
			break
		end
	end

	if not has_entries and #lines > 0 then
		vim.defer_fn(safe_apply_highlights, 25)
		return
	end

	apply_git_highlights()
end

-- Set up autocommands for Oil git highlights
local setup_autocmds = function()
	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		pattern = "oil://*",
		callback = function()
			safe_apply_highlights()
		end,
	})

	-- Clear highlights when leaving Oil buffer
	vim.api.nvim_create_autocmd("BufLeave", {
		group = augroup,
		pattern = "oil://*",
		callback = function()
			clear_highlights()
		end,
	})

	-- Refresh when oil buffer content changes (file operations)
	vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "TextChangedI" }, {
		group = augroup,
		pattern = "oil://*",
		callback = function()
			vim.schedule(apply_git_highlights)
		end,
	})
end

local is_initialized = false

local function initialize()
	if is_initialized or T.env.get_bool("OIL_DISABLE_GIT_HIGHLIGHTS") then
		return
	end

	setup_autocmds()

	is_initialized = true
end

initialize()
