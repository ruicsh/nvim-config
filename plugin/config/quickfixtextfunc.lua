-- Quickfix formatting and highlighting customization

local icons = require("config/icons")

local ns = vim.api.nvim_create_namespace("ruicsh/config/quickfixtextfunc")
local augroup = vim.api.nvim_create_augroup("ruicsh/config/quickfixtextfunc", { clear = true })

-- Get the list of items from the quickfix or location list
local function get_list_items(info)
	local list
	if info.quickfix == 1 then
		list = vim.fn.getqflist({ id = info.id, items = 0 })
	else
		list = vim.fn.getloclist(info.winid, { id = info.id, items = 0 })
	end
	return list.items
end

-- Get entry's type (error, warning, info, hint) -> E, W, I, H
local function get_qtype(entry)
	if not entry.type then
		return ""
	end

	return entry.type == "" and "" or entry.type:sub(1, 1):upper()
end

-- Extract snippet code from entry's text (path/filename.lua:123:45: error: message)
local function get_snippet(entry)
	local qtype = get_qtype(entry)
	local text = entry.text

	-- if no text, return the line from the buffer
	if not text or text == "" then
		local line = vim.api.nvim_buf_get_lines(entry.bufnr, entry.lnum - 1, entry.lnum, false)[1]
		return line
	end

	local snippet = #qtype > 0 and text:gsub("^ " .. qtype .. " ", "") or text
	if not snippet then
		return ""
	end

	snippet = snippet:gsub("^[^:]+:[0-9]+:[0-9]+:", "")
	return vim.trim(snippet)
end

local typeIconsMap = {
	E = icons.diagnostics.error,
	H = icons.diagnostics.hint,
	I = icons.diagnostics.information,
	N = icons.diagnostics.hint,
	W = icons.diagnostics.warning,
}

local typeHighlightMap = {
	E = "DiagnosticSignError",
	H = "DiagnosticSignHint",
	I = "DiagnosticSignInfo",
	N = "DiagnosticSignHint",
	W = "DiagnosticSignWarn",
}

-- Set the diagnostic signs in the status column
local function set_statucolumn_signs(bufnr, entries)
	-- reset all extmarks in the buffer first
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	for i, entry in ipairs(entries) do
		if entry.valid == 1 then
			local qtype = get_qtype(entry)
			if qtype ~= "" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
					sign_text = typeIconsMap[qtype],
					sign_hl_group = typeHighlightMap[qtype],
					number_hl_group = "",
					line_hl_group = "",
					priority = 1000,
				})
			end
		end
	end
end

-- Get the maximum filename length in the list of items
local function get_max_fname_len(items, info)
	local max_fname_len = 0
	for i = info.start_idx, info.end_idx do
		local entry = items[i]
		local fname = ""
		if entry.bufnr > 0 then
			fname = vim.fn.bufname(entry.bufnr)
			fname = vim.fs.getshortpath(fname)
		end
		max_fname_len = math.max(max_fname_len, #fname)
	end
	return max_fname_len
end

function _G.quickfixtextfunc(info)
	local ret = {}

	local items = get_list_items(info)
	local max_fname_len = get_max_fname_len(items, info)
	local fmt = "%-" .. max_fname_len .. "s │%5d│ %s"

	for i = info.start_idx, info.end_idx do
		local entry = items[i]
		local str

		if entry.valid == 1 then
			local fname = ""
			if entry.bufnr > 0 then
				fname = vim.fn.bufname(entry.bufnr)
				fname = vim.fs.getshortpath(fname)
			end

			local linenr = entry.lnum > 99999 and -1 or entry.lnum
			local snippet = get_snippet(entry)

			str = fmt:format(fname, linenr, snippet)
		else
			str = get_snippet(entry.text)
		end

		table.insert(ret, str)
	end

	return ret
end

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "qf",
	callback = function(event)
		-- set the diagnostic signs in the status column async
		local items = vim.fn.getqflist()
		set_statucolumn_signs(event.buf, items)
	end,
})

vim.o.quickfixtextfunc = "{info -> v:lua._G.quickfixtextfunc(info)}"
