-- Custom fold text.

function _G.custom_fold_text()
	local line = vim.fn.getline(vim.v.foldstart)
	-- count line being folded
	local line_count = vim.v.foldend - vim.v.foldstart + 1
	-- perserve indentation (replace tabs with spaces)
	line = line:gsub("\t", string.rep(" ", vim.bo.tabstop))

	return line .. ": " .. line_count .. " lines ------"
end
