vim.wo.wrap = true
vim.bo.buflisted = false

local function k(mode, lhs, rhs, opts)
	local options = vim.tbl_extend("force", { buffer = 0 }, opts or {})
	vim.keymap.set(mode, lhs, rhs, options)
end

k("n", "<leader>ar", ":CopilotCodeReview<cr>", { desc = "Code Review" })
k("n", "<localleader>ps", ":Git push<cr>", { desc = "Push to upstream" })
k("n", "<localleader>pf", ":Git push --force-with-lease<cr>", { desc = "Force push" })
