local ns = vim.api.nvim_create_namespace("ruicsh/ftplugin/oil")

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
local function get_git_status(bufnr, callback)
	local oil = require("oil")
	local current_dir = oil.get_current_dir(bufnr)
	local git_root = current_dir and vim.fs.root(current_dir, ".git")

	if not git_root or not current_dir then
		callback({})
		return
	end

	local path = vim.fs.relpath(git_root, current_dir) or "."
	if path == "" then
		path = "."
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
		"--porcelain=v1",
		"--short",
		"--untracked-files=all",
		"-z",
		path,
	}, { text = true, cwd = git_root }, function(result)
		if result.code ~= 0 or not result.stdout or result.stdout == "" then
			callback({})
			return
		end

		-- `-z` prints each entry as `XY PATH`, and renames/copies are followed
		-- by the original path as an extra NUL-separated field (no `XY `).
		local status = {}
		local fields = vim.split(result.stdout, "\0", { plain = true })
		local i = 1
		while i <= #fields do
			local status_code, filepath = fields[i]:match("^(..) (.+)$")
			if status_code then
				status[vim.fs.joinpath(git_root, filepath)] = status_code
				if status_code:find("[RC]") then
					i = i + 1 -- Skip the source path of a rename/copy
				end
			end
			i = i + 1
		end
		callback(status)
	end)
end

-- Match ids added by this plugin, per buffer. Matches are window-local, and
-- `clearmatches()` would also drop matches owned by other plugins.
local match_ids = {}

-- Latest apply request per buffer. A slower, superseded run must not paint.
local generation = {}

-- Clear the git highlights this plugin added to `bufnr` (defaults to the current one)
local function clear_highlights(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ids = match_ids[bufnr]
	match_ids[bufnr] = nil

	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	local winid = vim.fn.bufwinid(bufnr)
	if winid ~= -1 then
		for _, id in ipairs(ids or {}) do
			pcall(vim.fn.matchdelete, id, winid)
		end
	end
end

-- Build reverse index: dir_path -> status_code
local function build_dir_status_index(git_status)
	local dir_status_index = {}

	for file, status_code in pairs(git_status) do
		if status_code then
			local dir = vim.fs.dirname(file)
			-- Stop at the first directory that already has a status
			while dir and dir ~= "" and not dir_status_index[dir] do
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

-- Apply git highlights to the given Oil buffer (defaults to the current one)
local function apply_git_highlights(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local gen = (generation[bufnr] or 0) + 1
	generation[bufnr] = gen

	get_git_status(bufnr, function(git_status)
		vim.schedule(function()
			-- Needs to be scheduled to avoid calling nvim API from async callback
			if generation[bufnr] ~= gen then
				return
			end

			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end

			if vim.tbl_isempty(git_status) then
				clear_highlights(bufnr)
				return
			end

			local oil = require("oil")
			local current_dir = oil.get_current_dir(bufnr)
			if not current_dir then
				return
			end

			local oil_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local dir_status_index = build_dir_status_index(git_status)
			-- The buffer may have been left while the git command was running
			local winid = vim.fn.bufwinid(bufnr)

			clear_highlights(bufnr)

			local ids = {}
			-- Group line numbers by highlight group: one matchaddpos per group
			-- instead of one Vimscript call per line.
			local lines_by_hl = {}
			for linenr in ipairs(oil_lines) do
				local entry = oil.get_entry_on_line(bufnr, linenr)
				if entry then
					local path = vim.fs.joinpath(current_dir, entry.name)

					-- Determine status code for the entry
					local status_code = nil
					if entry.type == "directory" then
						status_code = dir_status_index[path]
					elseif entry.type == "file" then
						status_code = git_status[path]
					end

					-- Apply highlights based on status code
					local symbol, hl_group = get_symbol_hl_group(status_code)
					if symbol and hl_group then
						-- Highlight whole line
						if winid ~= -1 then
							local linenrs = lines_by_hl[hl_group]
							if linenrs then
								linenrs[#linenrs + 1] = linenr
							else
								lines_by_hl[hl_group] = { linenr }
							end
						end

						vim.api.nvim_buf_set_extmark(bufnr, ns, linenr - 1, 0, {
							virt_text = { { symbol, hl_group } },
							virt_text_pos = "eol",
							hl_mode = "combine",
						})
					end
				end
			end

			for hl_group, linenrs in pairs(lines_by_hl) do
				ids[#ids + 1] = vim.fn.matchaddpos(hl_group, linenrs, 10, -1, { window = winid })
			end

			match_ids[bufnr] = ids
		end)
	end)
end

local augroup = vim.api.nvim_create_augroup("ruicsh/ftplugin/oil", { clear = true })

-- Apply highlights after Oil has fully loaded the buffer
vim.api.nvim_create_autocmd("User", {
	group = augroup,
	pattern = "OilEnter",
	callback = function(args)
		if vim.api.nvim_get_current_buf() == args.data.buf and require("oil").get_current_dir(args.data.buf) then
			apply_git_highlights(args.data.buf)
		end
	end,
})

-- OilEnter only fires when a buffer is first loaded. Re-apply when entering an
-- already-loaded Oil buffer, e.g. navigating back to a parent directory.
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "oil://*",
	callback = function(args)
		if vim.b[args.buf].oil_ready then
			apply_git_highlights(args.buf)
		end
	end,
})

-- Clear highlights when leaving Oil buffer
vim.api.nvim_create_autocmd("BufLeave", {
	group = augroup,
	pattern = "oil://*",
	callback = function(args)
		clear_highlights(args.buf)
	end,
})

-- Refresh when oil buffer content changes (file operations)
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup,
	pattern = "oil://*",
	callback = function(args)
		vim.schedule(function()
			apply_git_highlights(args.buf)
		end)
	end,
})
