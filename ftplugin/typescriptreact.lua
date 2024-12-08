local function k(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { desc = "[t]ypescript: " .. desc, buffer = true })
end

k("<leader>tso", "<cmd>TSToolsOrganizeImports<cr>", "[o]rganize imports")
k("<leader>tss", "<cmd>TSToolsSortImports<cr>", "[s]ort imports")
k("<leader>tsu", "<cmd>TSToolsRemoveUnusedImports<cr>", "Remove [u]nused imports")
k("<leader>tsd", "<cmd>TSToolsGoToSourceDefinition<cr>", "Go to source [d]efinition")
k("<leader>tsr", "<cmd>TSToolsRenameFile<cr>", "[r]ename [f]ile")
