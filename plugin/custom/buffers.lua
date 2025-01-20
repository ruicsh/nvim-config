-- Buffers management (on quickfix list)

local icons = require("config/icons")

local ns = vim.api.nvim_create_namespace("ruicsh/custom/quickbuffers")
local augroup = vim.api.nvim_create_augroup("ruicsh/custom/quickbuffers", { clear = true })

local typeIconsMap = {
	A = icons.buffers.alternate,
	C = icons.buffers.current,
}

local typeHighlightMap = {
	A = "BuffersSignAlternate",
	C = "BuffersSignCurrent",
}

local function set_qf_statucolumn_signs(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	local items = vim.fn.getqflist()
	for i, entry in ipairs(items) do
		if entry.valid == 1 then
			local qtype = entry.type == "" and "" or entry.type:sub(1, 1):upper()
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

local function get_entry_type(bufnr)
	local current_bufnr = vim.api.nvim_get_current_buf()
	local alternate_bufnr = vim.fn.bufnr("#")

	if current_bufnr == bufnr then
		return "Current"
	end

	if alternate_bufnr == bufnr then
		return "Alternate"
	end
end

local function get_buffers_list()
	local items = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local is_loaded = vim.api.nvim_buf_is_loaded(bufnr)
		local is_listed = vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
		if is_loaded and is_listed then
			local filename = vim.api.nvim_buf_get_name(bufnr)
			local is_hidden = vim.api.nvim_get_option_value("bufhidden", { buf = bufnr }) == "hide"

			if not filename or filename == "" or is_hidden then
				goto continue
			end

			local cursor_pos = vim.api.nvim_buf_get_mark(bufnr, '"')
			local lnum = cursor_pos[1]
			local col = cursor_pos[2]
			local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
			local snippet = lines and lines[1] or ""
			snippet = snippet:gsub("\t", string.rep(" ", vim.bo.tabstop))

			table.insert(items, {
				bufnr = bufnr,
				filename = filename,
				lnum = lnum,
				col = col,
				type = get_entry_type(bufnr),
				text = snippet,
			})

			::continue::
		end
	end

	return items
end

local function open_buffers_list()
	local context = vim.fn.getqflist({ context = 1 }).context
	local action = context.type == "buffers" and "r" or " " -- add or replace qf list
	local items = get_buffers_list()

	vim.fn.setqflist({}, action, {
		title = "Buffers",
		items = items,
		idx = vim.api.nvim_get_current_buf(),
		context = { type = "buffers" },
	})

	vim.cmd.copen()
end

vim.keymap.set("n", "<leader>,", open_buffers_list, { noremap = true, silent = true, unique = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "qf",
	callback = function(event)
		local context = vim.fn.getqflist({ context = 1 }).context
		if context and context.type ~= "buffers" then
			return
		end

		set_qf_statucolumn_signs(event.buf)
	end,
})
