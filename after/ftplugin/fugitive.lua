vim.opt_local.wrap = true
vim.opt_local.buflisted = false

local function k(mode, lhs, rhs, opts)
	local options = vim.tbl_extend("force", { buffer = 0 }, opts or {})
	vim.keymap.set(mode, lhs, rhs, options)
end

k("n", "<leader>ar", ":CopilotCodeReview<cr>", { desc = "Code Review" })
k("n", "<leader>hp", ":Git push<cr>", { desc = "push" })
k("n", "<leader>hP", ":Git push --force-with-lease<cr>", { desc = "push --force-with-lease" })
k("n", "<leader>hu", ":Git push -u origin HEAD<cr>", { desc = "push -u origin HEAD" })
