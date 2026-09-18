-- Toggle soft-wrap on the current buffer.
-- When a right side panel is open, narrow the window to the visible area so
-- lines no longer overflow behind the panel. Closing the panel restores it.

vim.api.nvim_create_user_command("Wrap", function()
	require("lib").ui.toggle_wrap()
end, { desc = "Toggle soft-wrap (narrow window to visible area when side panel open)" })