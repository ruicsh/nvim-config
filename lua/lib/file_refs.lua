-- File references (`@path`, `path[:line[:col]]`) printed in a buffer.
--
-- Paths are resolved relative to the editor's cwd, then the git root. Only
-- files that exist are kept, so times (`12:30`) and URLs (`localhost:3000`)
-- are dropped.

local M = {}

-- `path:line` or `path:line:col`, optionally prefixed with `@` (file mentions).
-- Dots, slashes, dashes and underscores only.
local PATTERN = "(@?[%w%._/%-]+):(%d+):?(%d*)"
-- `path` alone, when no line number is printed.
local PATH = "(@?[%w%._/%-]+)"

local function resolve(bases, path)
	path = path:gsub("^@", "")
	if path:sub(1, 1) == "/" then
		local abs = vim.fs.normalize(path)
		return vim.fn.filereadable(abs) == 1 and abs or nil
	end

	for _, base in ipairs(bases) do
		local abs = vim.fs.normalize(vim.fs.joinpath(base, path))
		if vim.fn.filereadable(abs) == 1 then
			return abs
		end
	end
end

local function overlaps(ranges, start, stop)
	for _, range in ipairs(ranges) do
		if start <= range[2] and stop >= range[1] then
			return true
		end
	end
	return false
end

--- References found in `bufnr`, newest first.
---@param bufnr integer
---@return table[]
M.collect = function(bufnr)
	local cwd = vim.fn.getcwd()
	local root = vim.fs.root(cwd, ".git") or cwd
	local bases = { cwd, root }
	local items, seen, seq = {}, {}, 0

	for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
		local covered = {}

		-- `find` (not `gmatch`) so each match keeps its byte range for `covered`.
		local from = 1
		while true do
			local start, stop, path, line_no, col_no = line:find(PATTERN, from)
			if not start then
				break
			end
			from = stop + 1

			local file = resolve(bases, path)
			if file then
				local token = path .. ":" .. line_no
				covered[#covered + 1] = { start, start + #token - 1 }

				seq = seq + 1
				seen[file .. ":" .. line_no] = {
					file = file,
					pos = { tonumber(line_no), math.max(tonumber(col_no) or 1, 1) - 1 },
					seq = seq,
					text = token,
				}
			end
		end

		-- Bare paths: no line number, so they open at the top of the file.
		from = 1
		while true do
			local start, stop = line:find(PATH, from)
			if not start then
				break
			end
			from = stop + 1

			local path = line:sub(start, stop)
			-- `@name` is an explicit mention, so it needs no slash or dot.
			local explicit = path:sub(1, 1) == "@"
			local file = (path:find("[./]") or explicit) and not overlaps(covered, start, stop) and resolve(bases, path)

			if file and not seen[file .. ":1"] then
				seq = seq + 1
				seen[file .. ":1"] = {
					file = file,
					pos = { 1, 0 },
					seq = seq,
					text = path,
				}
			end
		end
	end

	for _, item in pairs(seen) do
		items[#items + 1] = item
	end
	table.sort(items, function(a, b)
		return a.seq > b.seq
	end)
	for _, item in ipairs(items) do
		item.seq = nil
	end

	return items
end

return M
