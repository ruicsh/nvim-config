-- Toggle to enable or disable autoformat on save.
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
	vim.g.format_on_save = not vim.g.format_on_save
	vim.notify(
		string.format("%s formatting...", vim.g.format_on_save and "Enabling" or "Disabling"),
		vim.log.levels.INFO
	)
end, { desc = "Toggle conform.nvim format on save", nargs = 0 })
