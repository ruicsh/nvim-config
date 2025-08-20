local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("o", lhs, rhs, options)
end

-- Match pairs
k("m", "%", { desc = "Match pair" })
