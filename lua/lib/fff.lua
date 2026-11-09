-- Snacks picker sources backed by the fff.nvim index.
-- fff does the indexing, frecency ranking and content search; Snacks renders the UI.
--
-- All sources run with `live = true`, so Snacks uses the input for the finder
-- (`filter.search`) while keeping the matcher pattern empty. This way fff's
-- ranking is preserved and Snacks does not re-filter the results.

local M = {}

-- Enough results to browse/filter; larger pages only cost Lua table conversion
local FILE_LIMIT = 200
local GREP_LIMIT = 200

-- Stop polling for the index after ~10s (250ms per attempt)
local REFRESH_ATTEMPTS = 40

-- Map fff git statuses to the short XY codes Snacks' git formatter expects.
local git_status = {
	deleted = " D",
	ignored = "!!",
	modified = " M",
	renamed = "R ",
	staged = "M ",
	untracked = "??",
}

-- Fold path case on the platforms whose default filesystems are case-insensitive
local FOLD_CASE = vim.fn.has("win32") == 1 or vim.fn.has("mac") == 1

local function absolute(ctx, relative_path)
	return vim.fs.joinpath(ctx:cwd(), relative_path)
end

local function path_key(path)
	return FOLD_CASE and path:lower() or path
end

--- fff indexes in the background, so an early search can come back empty.
local function index_ready()
	local ok, picker = pcall(require, "fff.file_picker")
	if not ok or not picker.is_initialized() then
		return false
	end
	local ok_progress, progress = pcall(picker.get_scan_progress)
	return ok_progress and progress and progress.is_index_ready == true
end

--- Re-run the finder while fff is still building its index, but never forever.
local function refresh_while_indexing(opts, ctx, count)
	if count > 0 or opts._fff_refresh or index_ready() then
		return
	end
	if (opts._fff_refresh_attempts or 0) >= REFRESH_ATTEMPTS then
		return
	end
	opts._fff_refresh_attempts = (opts._fff_refresh_attempts or 0) + 1
	opts._fff_refresh = true
	vim.defer_fn(function()
		opts._fff_refresh = nil
		if ctx.picker and not ctx.picker.closed then
			ctx.picker:find({ refresh = true })
		end
	end, 250)
end

local function fff_file_items(ctx, query, limit)
	local buf = ctx.filter and ctx.filter.current_buf
	local current_file = buf and vim.api.nvim_buf_get_name(buf) or nil
	local result = require("fff").file_search(query, {
		current_file = current_file ~= "" and current_file or nil,
		max_results = limit,
	})

	local items = {}
	for _, item in ipairs(result.items) do
		items[#items + 1] = {
			file = absolute(ctx, item.relative_path),
			status = git_status[item.git_status],
			text = item.relative_path,
		}
	end
	return items
end

function M.file_finder(opts, ctx)
	local items = fff_file_items(ctx, vim.trim(ctx.filter.search), opts.limit_live or FILE_LIMIT)
	refresh_while_indexing(opts, ctx, #items)
	return items
end

local function buffer_item(buf, name, root, lnum)
	local file = vim.fs.normalize(vim.fn.fnamemodify(name, ":p"))
	local ok, rel = pcall(vim.fs.relpath, root, file)
	if not ok or not rel or rel == "." then
		rel = file
	end
	local mark = vim.api.nvim_buf_get_mark(buf, '"')
	return {
		buf = buf,
		file = file,
		pos = { mark[1] ~= 0 and mark[1] or (lnum or 1), 0 },
		text = rel,
	}
end

--- Filter open buffers with Vim's fuzzy matcher, since the Snacks matcher is
--- bypassed for live finders. fff constraint tokens are ignored here.
local function filter_buffers(query, items)
	local tokens = {}
	for token in query:gmatch("%S+") do
		if not token:find("[:!*?{}%[%]]") then
			tokens[#tokens + 1] = token
		end
	end
	if #tokens == 0 then
		return items
	end

	for _, token in ipairs(tokens) do
		local names, seen = {}, {}
		for _, item in ipairs(items) do
			if not seen[item.text] then
				seen[item.text] = true
				names[#names + 1] = item.text
			end
		end
		local matched = vim.fn.matchfuzzy(names, token)
		if #matched == 0 then
			return {}
		end
		local keep = {}
		for _, name in ipairs(matched) do
			keep[name] = true
		end
		local filtered = {}
		for _, item in ipairs(items) do
			if keep[item.text] then
				filtered[#filtered + 1] = item
			end
		end
		items = filtered
	end
	return items
end

-- Smart picker: open buffers first, then fff's frecency-ranked files.

function M.smart_finder(opts, ctx)
	local query = vim.trim(ctx.filter.search)
	local limit = opts.limit_live or FILE_LIMIT
	local root = ctx:cwd()
	local items = {}
	local seen = {}

	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	table.sort(bufs, function(a, b)
		return (a.lastused or 0) > (b.lastused or 0)
	end)
	local buffers = {}
	for _, info in ipairs(bufs) do
		local buf = info.bufnr
		if info.name ~= "" and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
			buffers[#buffers + 1] = buffer_item(buf, info.name, root, info.lnum)
		end
	end

	for _, item in ipairs(filter_buffers(query, buffers)) do
		if #items >= limit then
			break
		end
		local key = path_key(item.file)
		if not seen[key] then
			seen[key] = true
			items[#items + 1] = item
		end
	end

	local files_added = 0
	local file_limit = limit - #items
	if file_limit > 0 then
		for _, item in ipairs(fff_file_items(ctx, query, file_limit)) do
			local key = path_key(vim.fs.normalize(item.file))
			if not seen[key] then
				seen[key] = true
				files_added = files_added + 1
				items[#items + 1] = item
			end
		end
		refresh_while_indexing(opts, ctx, files_added)
	end

	return items
end

local function grep_positions(item)
	local positions = {}
	local max = #item.line_content
	-- fff ranges are `{ 0-based start, 1-based inclusive end }`
	for _, range in ipairs(item.match_ranges or {}) do
		for i = range[1] + 1, math.min(range[2], max) do
			positions[#positions + 1] = i
		end
	end
	return positions
end

local function grep_item(item, ctx)
	local line = item.line_content
	local positions = grep_positions(item)
	return {
		file = absolute(ctx, item.relative_path),
		line = line,
		pos = { item.line_number, math.min(item.col, #line) },
		positions = #positions > 0 and positions or nil,
		text = string.format("%s:%d:%d:%s", item.relative_path, item.line_number, item.col + 1, line),
	}
end

-- Honours the config's GREP_EXCLUDE_FILES (previously passed to rg by Snacks)
local grep_excludes

local function with_grep_excludes(query)
	if grep_excludes == nil then
		local ok, env = pcall(require, "lib/env")
		grep_excludes = ok and env.get_list("GREP_EXCLUDE_FILES") or {}
	end
	if #grep_excludes == 0 then
		return query
	end
	local parts = { query }
	for _, pattern in ipairs(grep_excludes) do
		parts[#parts + 1] = "!" .. pattern
	end
	return table.concat(parts, " ")
end

function M.grep_finder(opts, ctx)
	local query = vim.trim(ctx.filter.search)
	if query == "" then
		return {}
	end

	local result = require("fff").content_search(with_grep_excludes(query), {
		mode = opts.grep_mode or "regex",
		page_size = opts.limit_live or GREP_LIMIT,
	})

	local items = {}
	for _, item in ipairs(result.items) do
		items[#items + 1] = grep_item(item, ctx)
	end
	refresh_while_indexing(opts, ctx, #items)
	return items
end

function M.live_grep(opts)
	opts = opts or {}
	require("snacks").picker.pick("grep", {
		grep_mode = opts.mode,
		search = opts.search,
		title = opts.title,
	})
end

function M.grep_word()
	require("snacks").picker.pick("grep_word")
end

function M.smart()
	-- Uses the shared `smart` source configured in `lua/plugins/snacks.picker.lua`
	require("snacks").picker.pick("smart")
end

return M
