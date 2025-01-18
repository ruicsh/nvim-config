local icons = require("config/icons")

local ns = vim.api.nvim_create_namespace("ruicsh/quickfix")
local augroup = vim.api.nvim_create_augroup("ruicsh/quickfix", { clear = true })

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
	return entry.type == "" and "" or entry.type:sub(1, 1):upper()
end

-- Extract snippet code from entry's text (path/filename.lua:123:45: error: message)
local function get_snippet(entry)
	local qtype = get_qtype(entry)
	local text = entry.text
	local snippet = #qtype > 0 and text:gsub("^ " .. qtype .. " ", "") or text
	snippet = snippet:gsub("^[^:]+:[0-9]+:[0-9]+:", "")
	return vim.trim(snippet)
end

local diagnosticIconsMap = {
	E = icons.diagnostics.error,
	W = icons.diagnostics.warning,
	I = icons.diagnostics.information,
	H = icons.diagnostics.hint,
	N = icons.diagnostics.hint,
}

local diagnosticHighlightMap = {
	E = "DiagnosticSignError",
	W = "DiagnosticSignWarn",
	I = "DiagnosticSignInfo",
	H = "DiagnosticSignHint",
	N = "DiagnosticSignHint",
}

-- Set the diagnostic signs in the status column
local function set_statucolumn_signs(bufnr, entries)
	for i, entry in ipairs(entries) do
		if entry.valid == 1 then
			local qtype = get_qtype(entry)
			if qtype ~= "" then
				vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
					sign_text = diagnosticIconsMap[qtype],
					sign_hl_group = diagnosticHighlightMap[qtype],
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
		vim.wo.spell = false

		-- set the diagnostic signs in the status column async
		local items = vim.fn.getqflist()
		set_statucolumn_signs(event.buf, items)
	end,
})

vim.o.quickfixtextfunc = "{info -> v:lua._G.quickfixtextfunc(info)}"
