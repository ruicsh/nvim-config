-- Custom fold text.
-- https://www.reddit.com/r/neovim/comments/16sqyjz/finally_we_can_have_highlighted_folds/

local NODES_TO_HIGHLIGHT = {
	css = { "type" },
	html = { "tag" },
	js = { "function" },
	lua = { "function", "string" },
	python = { "function" },
	scss = { "type" },
	typescript = { "constructor", "function", "function.method" },
	typescriptreact = { "function" },
}

-- Cache highlight groups by filetype and node name for better performance
local highlight_cache = {}

local function get_hl_group(name)
	local ft = vim.bo.filetype

	-- Create cache key
	local cache_key = ft .. "_" .. name

	-- Return cached result if available
	if highlight_cache[cache_key] then
		return highlight_cache[cache_key]
	end

	-- Get nodes to highlight for current filetype, or empty table if none
	local nodes_to_highlight = NODES_TO_HIGHLIGHT[ft]

	-- Determine highlight group
	local hl = (nodes_to_highlight and vim.tbl_contains(nodes_to_highlight, name)) and "FoldedHeading" or "Folded"

	-- Cache the result
	highlight_cache[cache_key] = hl

	return hl
end

function _G.custom_fold_text()
	local ft = vim.bo.filetype
	local pos = vim.v.foldstart
	local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
	local lang = vim.treesitter.language.get_lang(ft)
	local parser = vim.treesitter.get_parser(0, lang)
	local query = vim.treesitter.query.get(parser:lang(), "highlights")

	if query == nil then
		return vim.fn.foldtext()
	end

	local tree = parser:parse({ pos - 1, pos })[1]
	local result = {}

	local line_pos = 0

	local prev_range = nil

	for id, node, _ in query:iter_captures(tree:root(), 0, pos - 1, pos) do
		local name = query.captures[id]
		local start_row, start_col, end_row, end_col = node:range()
		if start_row == pos - 1 and end_row == pos - 1 then
			local range = { start_col, end_col }
			if start_col > line_pos then
				table.insert(result, { line:sub(line_pos + 1, start_col), "Folded" })
			end
			line_pos = end_col
			local text = vim.treesitter.get_node_text(node, 0)
			local hl = get_hl_group(name)
			if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
				result[#result] = { text, hl }
			else
				table.insert(result, { text, hl })
			end
			prev_range = range
		end
	end

	-- count line being folded
	local line_count = vim.v.foldend - vim.v.foldstart + 1
	local fold_info = ": " .. line_count .. " lines ------"
	table.insert(result, { fold_info, "Folded" })

	return result
end
