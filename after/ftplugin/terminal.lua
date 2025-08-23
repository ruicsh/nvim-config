local function k(mode, lhs, rhs, opts)
	local options = vim.tbl_extend("force", { buffer = 0 }, opts or {})
	vim.keymap.set(mode, lhs, rhs, options)
end

k("n", "<bar>", "<c-w>p", { desc = "Go to previous window" }) -- `:h CTRL-W_p`
