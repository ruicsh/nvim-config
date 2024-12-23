local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set("c", lhs, rhs, options)
end

-- Move up/down in the history and in wildmenu.
k("<c-k>", "<c-p>")
k("<c-j>", "<c-n>")
