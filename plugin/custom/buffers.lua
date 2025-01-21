--  Buffers switch using quickfix list

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

-- List all buffers that are loaded, listed and not hidden
local function list_buffers()
	local bufnrs = {}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local is_loaded = vim.api.nvim_buf_is_loaded(bufnr)
		local is_listed = vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
		local filename = vim.api.nvim_buf_get_name(bufnr)
		local is_hidden = vim.api.nvim_get_option_value("bufhidden", { buf = bufnr }) == "hide"

		if is_loaded and is_listed and filename and filename ~= "" and not is_hidden then
			table.insert(bufnrs, bufnr)
		end
	end

	return bufnrs
end

local function get_qf_items()
	local bufnrs = list_buffers()

	local items = {}
	for _, bufnr in ipairs(bufnrs) do
		local filename = vim.api.nvim_buf_get_name(bufnr)

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
	end

	return items
end

local function set_qflist(items, opts)
	local action = opts and opts.action or " "
	local idx = opts and opts.idx or vim.api.nvim_get_current_buf()

	vim.fn.setqflist({}, action, {
		title = "Buffers",
		items = items,
		idx = idx,
		context = { type = "buffers" },
	})
end

local function open_qflist()
	local context = vim.fn.getqflist({ context = 1 }).context
	local action = context.type == "buffers" and "r" or " " -- add or replace qf list
	local items = get_qf_items()

	set_qflist(items, { action = action })

	vim.cmd.copen()
end

local mappings = {
	move = function(direction)
		return function()
			local idx = vim.fn.line(".")
			local last_line = vim.fn.line("$")

			-- Skip if already at the top or bottom
			if idx == 1 and (direction == "up" or direction == "top") then
				return
			elseif idx == last_line and (direction == "down" or direction == "bottom") then
				return
			end

			local items = vim.fn.getqflist()
			local current = items[idx]
			table.remove(items, idx)

			local new_idx
			if direction == "up" then
				new_idx = idx - 1
			elseif direction == "down" then
				new_idx = idx + 1
			elseif direction == "top" then
				new_idx = 1
			elseif direction == "bottom" then
				new_idx = last_line
			end

			table.insert(items, new_idx, current)

			set_qflist(items, { idx = new_idx, action = "r" })
		end
	end,
	close = function()
		local idx = vim.fn.line(".")
		local items = vim.fn.getqflist()
		local current = items[idx]
		vim.api.nvim_buf_delete(current.bufnr, { force = true })
		table.remove(items, idx)
		set_qflist(items, { idx = idx, action = "r" })
	end,
}

local function set_keymaps(bufnr)
	local function k(lhs, rhs, desc)
		local opts = { silent = true, noremap = true, buffer = bufnr }
		opts.desc = "Buffers: " .. desc
		vim.keymap.set("n", lhs, rhs, opts)
	end

	k("]e", mappings.move("down"), "Move up")
	k("[e", mappings.move("up"), "Move down")
	k("]E", mappings.move("bottom"), "Move to top")
	k("[E", mappings.move("top"), "Move to bottom")

	k("dd", mappings.close, "Close buffer")
	k("D", mappings.close, "Close buffer")
end

vim.keymap.set("n", "<leader>,", open_qflist, { noremap = true, silent = true, unique = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "qf",
	callback = function(event)
		local context = vim.fn.getqflist({ context = 1 }).context
		if context and context.type ~= "buffers" then
			return
		end

		set_keymaps(event.buf)

		set_qf_statucolumn_signs(event.buf)
	end,
})
