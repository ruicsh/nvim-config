-- Custom fold text.
-- https://www.reddit.com/r/neovim/comments/16sqyjz/finally_we_can_have_highlighted_folds/

local NODES_TO_HIGHLIGHT = { "function", "method", "class" }

function _G.custom_fold_text()
	local pos = vim.v.foldstart
	local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
	local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
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
			local hl_group = vim.tbl_contains(NODES_TO_HIGHLIGHT, name) and "FoldedHeading" or "Folded"
			if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
				result[#result] = { text, hl_group }
			else
				table.insert(result, { text, hl_group })
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
