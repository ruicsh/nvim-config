local function k(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { desc = "[t]ypescript: " .. desc, buffer = true, lazy = true })
end

k("<leader>tso", ":TSToolsOrganizeImports<cr>", "[o]rganize imports")
k("<leader>tss", ":TSToolsSortImports<cr>", "[s]ort imports")
k("<leader>tsu", ":TSToolsRemoveUnusedImports<cr>", "Remove [u]nused imports")
k("<leader>tsd", ":TSToolsGoToSourceDefinition<cr>", "Go to source [d]efinition")
k("<leader>tsr", ":TSToolsRenameFile<cr>", "[r]ename [f]ile")
