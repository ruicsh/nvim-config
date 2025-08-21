local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("o", lhs, rhs, options)
end

-- Matching pairs (use `m` instead of `%`)
k("m", "<Plug>(MatchitOperationForward)", { desc = "Match pair" }) -- `:h matchit-%`
k("gm", "<Plug>(MatchitOperationBackward)", { desc = "Match pair backward" }) -- `:h o_g%`
k("[m", "<Plug>(MatchitOperationMultiBackward)", { desc = "Unmatched pair backward" }) -- `:h o_[%`
k("]m", "<Plug>(MatchitOperationMultiForward)", { desc = "Unmatched pair forward" }) -- `:h o_]%`
