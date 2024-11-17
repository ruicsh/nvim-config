-- Copy file path to clipboard.
-- FIXME: make it relative to workspace root dir

vim.api.nvim_create_user_command("CopyFilePathToClipboard", function()
	local filepath = vim.fn.expand("%")
	vim.fn.setreg("+", filepath)
end, {})
