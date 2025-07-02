vim.opt_local.relativenumber = false
vim.opt_local.statusline = "%!v:lua._G.status_line_qf()"
vim.opt_local.cursorline = true

vim.keymap.set("n", "<c-j>", "j", { desc = "Next quickfix item", buffer = true })
vim.keymap.set("n", "<c-k>", "k", { desc = "Previous quickfix item", buffer = true })

vim.keymap.set("n", "<cr>", function()
	local item = vim.fn.getqflist()[vim.fn.line(".")]
	if item and item.valid == 1 then
		vim.cmd("cc " .. vim.fn.line("."))
		vim.cmd("cclose")
	end
end, { buffer = true, desc = "Open item and close quickfix" })
