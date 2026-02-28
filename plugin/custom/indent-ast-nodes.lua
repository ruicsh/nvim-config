-- AST aware indentation
-- Use `<` and `>` to indent the current node (and children) in the AST

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

local STATEMENT_BOUNDARIES = {
	python = {
		"expression_statement",
		"assignment_statement",
		"function_definition",
		"if_statement",
		"for_statement",
		"while_statement",
		"try_statement",
		"with_statement",
		"class_definition",
	},
	lua = {
		"chunk",
		"function_declaration",
		"local_function",
		"if_statement",
		"for_statement",
		"while_statement",
		"function_call",
		"assignment_statement",
	},
	javascript = {
		"expression_statement",
		"variable_declaration",
		"function_declaration",
		"arrow_function",
		"if_statement",
		"for_statement",
		"while_statement",
		"try_statement",
		"class_declaration",
		"method_definition",
		"export_statement",
		"import_statement",
	},
	typescript = {
		"expression_statement",
		"variable_declaration",
		"function_declaration",
		"arrow_function",
		"if_statement",
		"for_statement",
		"while_statement",
		"try_statement",
		"class_declaration",
		"method_definition",
		"export_statement",
		"import_statement",
		"interface_declaration",
		"type_alias_declaration",
		"enum_declaration",
	},
}

local function get_node_line_range(node)
	local filetype = vim.bo.filetype
	local boundaries = STATEMENT_BOUNDARIES[filetype]

	-- If filetype isn't supported, return just the node's range
	if not boundaries then
		local start_row, _, end_row, _ = node:range()
		return start_row + 1, end_row + 1
	end

	-- Find the root of the current expression/statement
	while node:parent() and node:parent():type() ~= "module" do
		local parent = node:parent()
		local parent_type = parent:type()
		-- Stop at language-specific statement/expression boundaries
		if vim.tbl_contains(boundaries, parent_type) then
			break
		end
		node = parent
	end

	local start_row, _, end_row, _ = node:range()

	-- Get total line count of the buffer
	local line_count = vim.api.nvim_buf_line_count(0)
	-- If the range spans the entire file (or nearly the entire file), return nil
	if start_row == 0 and end_row >= line_count - 1 then
		return nil, nil
	end

	return start_row + 1, end_row + 1
end

local function indent_node(direction)
	return function()
		local fallback = direction == "<" and "<<" or ">>"

		local node = vim.treesitter.get_node()
		if not node then
			return vim.cmd("normal! " .. fallback)
		end

		local start_row, end_row = get_node_line_range(node)
		-- If get_node_line_range returns nil (whole file), do nothing
		if not start_row or not end_row then
			return
		end

		-- Check if we're trying to outdent and the node is already at column 1
		if direction == "<" then
			local line_text = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, true)[1]
			local first_non_blank = line_text:match("^%s*"):len()
			if first_non_blank == 0 then
				return -- Do nothing if already at column 1
			end
		end

		-- Store current cursor position
		local cur_pos = vim.api.nvim_win_get_cursor(0)
		local cur_line = cur_pos[1]
		local cur_col = cur_pos[2]

		-- Perform the indent operation
		vim.cmd(string.format("%d,%d" .. direction, start_row, end_row))

		-- Calculate new column position based on indent direction
		if cur_line >= start_row and cur_line <= end_row then
			if direction == ">" then
				cur_col = cur_col + vim.bo.shiftwidth
			else
				cur_col = math.max(0, cur_col - vim.bo.shiftwidth)
			end
		end

		-- Restore cursor position with adjusted column
		vim.api.nvim_win_set_cursor(0, { cur_line, cur_col })
	end
end

k("g<", indent_node("<"))
k("g>", indent_node(">"))
