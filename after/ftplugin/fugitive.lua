vim.opt_local.wrap = false
vim.opt_local.buflisted = false

-- Jump to the first entry
vim.cmd("normal ]/")

local function k(mode, lhs, rhs, opts)
	local options = vim.tbl_extend("force", { buffer = 0 }, opts or {})
	vim.keymap.set(mode, lhs, rhs, options)
end

k("n", "<leader>hp", "<cmd>Git push<cr>", { desc = "push" })
k("n", "<leader>hP", "<cmd>Git push --force-with-lease<cr>", { desc = "push --force-with-lease" })
k("n", "<leader>hu", "<cmd>Git push -u origin HEAD<cr>", { desc = "push -u origin HEAD" })

-- Diff for commit under cursor
k("n", "<leader>hd", function()
	local line = vim.api.nvim_get_current_line()
	local sha = line:match("^%s*([0-9a-fA-F]+)")
	if sha then
		vim.cmd("CodeDiff " .. sha .. "~1")
	end
end, { desc = "Diff" })

k("n", "<leader>ar", "<cmd>CopilotCodeReview<cr>", { desc = "Code Review" })

k("n", "<tab>", "=", { desc = "Toggle section", remap = true })
k("n", "q", function()
	require("snacks.bufdelete").delete()
	vim.cmd("tabclose")
end, { desc = "Close" })

-- Commit in new vertical split
k("n", "cc", function()
	vim.cmd("only")
	vim.cmd("vertical Git commit")
end, { desc = "Commit in new tab" })

-- Always open file under cursor in vertical split
k("n", "<cr>", function()
	vim.cmd("only")
	vim.cmd("normal gO") -- `:h fugitive_gO`
end, { desc = "Open file under cursor" })
