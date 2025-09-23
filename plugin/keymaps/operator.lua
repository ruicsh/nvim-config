local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("o", lhs, rhs, options)
end

-- Start/end of line
k("H", "^", { desc = "Start of line" }) -- `:h ^`
k("L", "g_", { desc = "End of line" }) -- `:h g_`

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
