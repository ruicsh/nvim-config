local k = vim.keymap.set

-- Open buffer switcher from inside terminal
k("t", "§", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-\\><c-n>", true, true, true), "n", true)
	local bmui = require("buffer_manager.ui")
	bmui.toggle_quick_menu()
end, { silent = true })
