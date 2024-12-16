-- Use quickfix to list jump and change list
-- https://github.com/debugloop/dotfiles/blob/main/home/nvim/lua/maps.lua

-- Reverse a list
local function reverse_list(tbl)
	local reversed = {}
	for i = #tbl, 1, -1 do
		table.insert(reversed, tbl[i])
	end
	return reversed
end

-- Find index of a value on a list
local function find_index(haystack, needle)
	for i, v in ipairs(haystack) do
		if v == needle then
			return i
		end
	end
	return nil
end

-- List buffers ordered by last accessed
local function get_buffers_sorted_by_last_accessed()
	local jumplist = vim.fn.getjumplist()[1]

	local bufs = {}
	for _, v in ipairs(jumplist) do
		if vim.fn.bufloaded(v.bufnr) == 1 then
			if find_index(bufs, v.bufnr) == nil then
				table.insert(bufs, v.bufnr)
			end
		end
	end

	return bufs
end

-- List changes
local function get_changes_list()
	local buffers = reverse_list(get_buffers_sorted_by_last_accessed())

	local qf_list = {}
	for _, bufnr in ipairs(buffers) do
		-- Sort the changelist time descending
		local changelist = reverse_list(vim.fn.getchangelist(bufnr)[1])
		local seen = {}
		for _, v in ipairs(changelist) do
			local text = vim.api.nvim_buf_get_lines(bufnr, v.lnum - 1, v.lnum, false)[1]
			-- Don't include lines that aren't there anymore
			local trimmed = text and text:match("^%s*(.-)%s*$") or ""
			if not seen[v.lnum] and #trimmed ~= 0 then
				-- Don't include the same line again
				seen[v.lnum] = true
				table.insert(qf_list, {
					bufnr = bufnr,
					lnum = v.lnum,
					col = v.col,
					text = text,
				})
			end
		end
	end

	return qf_list
end

-- List jumps
local function get_jumps_list()
	local jumplist = vim.fn.getjumplist()[1]

	local qf_list = {}
	for _, v in ipairs(jumplist) do
		if vim.fn.bufloaded(v.bufnr) == 1 then
			table.insert(qf_list, {
				bufnr = v.bufnr,
				lnum = v.lnum,
				col = v.col,
				text = vim.api.nvim_buf_get_lines(v.bufnr, v.lnum - 1, v.lnum, false)[1],
			})
		end
	end

	return reverse_list(qf_list)
end

-- Take a list, set it to quickfix and open its window
local function set_qf_list(opts)
	vim.fn.setqflist({}, " ", opts)
	vim.cmd.cwindow()
end

vim.api.nvim_create_user_command("OpenChangesInQuickfix", function()
	set_qf_list({ items = get_changes_list(), title = "Changes" })
end, {})

vim.api.nvim_create_user_command("OpenJumpsInQuickfix", function()
	set_qf_list({ items = get_jumps_list(), title = "Jumps" })
end, {})