local ns = vim.api.nvim_create_namespace("ruicsh/ftplugin/oil")

-- Oil creates one buffer per directory and re-sources this file for each, so
-- state must live outside the chunk. A chunk-local table would forget the
-- caches on the next `FileType oil`.
local state = _G.ruicsh_oil_git
	or {
		status_cache = {}, -- git root -> { at, status, index }
		pending = {}, -- git root -> { waiters = { callback, ... } }
		roots = {}, -- directory -> repository root, or false
		generation = {}, -- bufnr -> latest apply request
		painted = {}, -- bufnr -> { status, tick }
		extmark_opts = {}, -- status code -> opts table, or false
	}
_G.ruicsh_oil_git = state

-- Line decoration per git status code, cached so changed lines reuse one table.
-- `nvim_buf_set_extmark` only reads it and there is no batch API.
local extmark_opts = state.extmark_opts

local function get_extmark_opts(status_code)
	if not status_code then
		return nil
	end

	local cached = extmark_opts[status_code]
	if cached ~= nil then
		return cached or nil
	end

	local first_char = status_code:sub(1, 1)
	local second_char = status_code:sub(2, 2)
	local symbol, hl_group

	if first_char == "A" or second_char == "A" then
		symbol, hl_group = "+", "diffAdded"
	elseif first_char == "M" or second_char == "M" then
		symbol, hl_group = "~", "diffChanged"
	elseif first_char == "R" or second_char == "R" then
		symbol, hl_group = "→", "diffRenamed"
	elseif first_char == "D" or second_char == "D" then
		symbol, hl_group = "-", "diffChanged"
	elseif first_char == "?" then
		symbol, hl_group = "?", "diffFile"
	elseif first_char == "!" then
		symbol, hl_group = "!", "diffIgnored"
	end

	if not symbol then
		extmark_opts[status_code] = false
		return nil
	end

	local opts = {
		virt_text = { { symbol, hl_group } },
		virt_text_pos = "eol",
		line_hl_group = hl_group,
		hl_mode = "combine",
	}
	extmark_opts[status_code] = opts

	return opts
end

-- Git status per repository with a short TTL: re-entering a buffer re-applies
-- highlights, and every `git status` spawns a process.
local status_cache = state.status_cache
local STATUS_TTL = 5000

-- `git status` runs in flight per repository.
local status_pending = state.pending

-- Repository root per directory, since `vim.fs.root` stats every parent.
local root_cache = state.roots

-- Both caches live for the session, so cap them and evict the least recently
-- used entry. Status entries carry `at`; root entries carry no time.
local STATUS_CACHE_LIMIT = 32
local ROOT_CACHE_LIMIT = 512

local function trim_cache(cache, limit, last_used)
	local count, oldest_key, oldest_at = 0, nil, nil

	for key, value in pairs(cache) do
		count = count + 1
		local at = last_used and last_used(value) or 0
		if not oldest_at or at < oldest_at then
			oldest_key, oldest_at = key, at
		end
	end

	-- Normally one insert over the limit, so this evicts once.
	while count > limit do
		if not oldest_key then
			break
		end
		cache[oldest_key] = nil
		count = count - 1
		oldest_key, oldest_at = nil, nil
		for key, value in pairs(cache) do
			local at = last_used and last_used(value) or 0
			if not oldest_at or at < oldest_at then
				oldest_key, oldest_at = key, at
			end
		end
	end
end

local function get_git_root(dir)
	local root = root_cache[dir]
	if root == nil then
		root = vim.fs.root(dir, ".git") or false
		root_cache[dir] = root
		trim_cache(root_cache, ROOT_CACHE_LIMIT)
	end
	return root or nil
end

-- Reverse index: dir_path -> status_code
local function build_dir_status_index(git_status)
	local dir_status_index = {}

	for file, status_code in pairs(git_status) do
		if status_code then
			if status_code:sub(1, 1) == "!" then
				dir_status_index[file] = status_code
			end
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

local function status_equals(a, b)
	if a == b then
		return true
	end

	local a_count = 0
	for file, status_code in pairs(a) do
		a_count = a_count + 1
		if b[file] ~= status_code then
			return false
		end
	end

	local b_count = 0
	for _ in pairs(b) do
		b_count = b_count + 1
	end

	return a_count == b_count
end

-- Get git status for the repository containing the current Oil directory
local function get_git_status(bufnr, callback)
	local oil = require("oil")
	local current_dir = oil.get_current_dir(bufnr)
	local git_root = current_dir and get_git_root(current_dir)

	if not git_root then
		callback({}, {})
		return
	end

	local cached = status_cache[git_root]
	if cached and vim.uv.now() - cached.at < STATUS_TTL then
		callback(cached.status, cached.index)
		return
	end

	-- OilEnter and BufEnter both fire on open, so a cold-cache miss is normal.
	-- Join the run in flight instead of spawning a second `git status`.
	local pending = status_pending[git_root]
	if pending then
		pending.waiters[#pending.waiters + 1] = callback
		return
	end

	local entry = { waiters = { callback } }
	status_pending[git_root] = entry

	-- One run per repository, not per directory. `-z` prints `XY PATH` per entry
	-- and renames/copies add the source path as an extra NUL field.
	-- `core.quotepath=false` keeps non-ASCII paths readable on Windows, and
	-- GIT_OPTIONAL_LOCKS avoids taking the index lock for a read-only command.
	vim.system({
		"git",
		"-C",
		git_root,
		"-c",
		"core.quotepath=false",
		"status",
		"--porcelain=v1",
		"--short",
		"--ignored-matching",
		"--untracked-files=normal",
		"-z",
	}, { text = true, cwd = git_root, env = { GIT_OPTIONAL_LOCKS = "0" } }, function(result)
		local status = {}

		if result.code == 0 and result.stdout and result.stdout ~= "" then
			local fields = vim.split(result.stdout, "\0", { plain = true })
			local i = 1
			while i <= #fields do
				local status_code, filepath = fields[i]:match("^(..) (.+)$")
				if status_code then
					filepath = filepath:gsub("[/\\]+$", "")
					status[vim.fs.joinpath(git_root, filepath)] = status_code
					if status_code:find("[RC]") then
						i = i + 1 -- Skip the source path of a rename/copy
					end
				end
				i = i + 1
			end
		end

		local index = build_dir_status_index(status)

		-- Cache was invalidated mid-flight (an oil write): a newer run owns the
		-- entry, so deliver this result without caching it.
		if status_pending[git_root] == entry then
			status_pending[git_root] = nil
			status_cache[git_root] = { at = vim.uv.now(), status = status, index = index }
			trim_cache(status_cache, STATUS_CACHE_LIMIT, function(entry)
				return entry.at
			end)
		end

		for _, waiter in ipairs(entry.waiters) do
			waiter(status, index)
		end
	end)
end

-- Latest apply request per buffer. A slower, superseded run must not paint.
local generation = state.generation

-- Painted status and changedtick per buffer, so a no-op re-entry is skipped.
local painted = state.painted

-- Clear the git highlights this plugin added to `bufnr` (defaults to the current one)
local function clear_highlights(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

-- Apply git highlights to the given Oil buffer (defaults to the current one)
local function apply_git_highlights(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local gen = (generation[bufnr] or 0) + 1
	generation[bufnr] = gen

	get_git_status(bufnr, function(git_status, dir_status_index)
		vim.schedule(function()
			-- Scheduled: no nvim API calls from an async callback
			if generation[bufnr] ~= gen then
				return
			end

			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end

			local tick = vim.api.nvim_buf_get_changedtick(bufnr)
			local previous = painted[bufnr]
			if previous and previous.tick == tick and status_equals(previous.status, git_status) then
				return
			end

			local oil = require("oil")
			local current_dir = oil.get_current_dir(bufnr)
			if not current_dir then
				return
			end

			clear_highlights(bufnr)

			if not vim.tbl_isempty(git_status) then
				local line_count = vim.api.nvim_buf_line_count(bufnr)

				for linenr = 1, line_count do
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
						local opts = get_extmark_opts(status_code)
						if opts then
							vim.api.nvim_buf_set_extmark(bufnr, ns, linenr - 1, 0, opts)
						end
					end
				end
			end

			painted[bufnr] = {
				status = git_status,
				tick = tick,
			}
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

-- OilEnter fires only on first load. Re-apply when re-entering a loaded Oil
-- buffer. Hidden-buffer extmarks cost nothing, and re-applying is skipped when
-- nothing changed.
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "oil://*",
	callback = function(args)
		if vim.b[args.buf].oil_ready then
			apply_git_highlights(args.buf)
		end
	end,
})

-- Refresh when oil buffer content changes (file operations)
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup,
	pattern = "oil://*",
	callback = function(args)
		vim.schedule(function()
			local dir = require("oil").get_current_dir(args.buf)
			if dir then
				local root = get_git_root(dir)
				if root then
					status_cache[root] = nil
					-- A run started before this write must not satisfy later callers.
					status_pending[root] = nil
				end
			end
			apply_git_highlights(args.buf)
		end)
	end,
})

-- Drop per-buffer bookkeeping
vim.api.nvim_create_autocmd("BufWipeout", {
	group = augroup,
	pattern = "oil://*",
	callback = function(args)
		generation[args.buf] = nil
		painted[args.buf] = nil
	end,
})
