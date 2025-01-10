local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, silent = true, unique = true }, opts or {})
	vim.keymap.set("t", lhs, rhs, options)
end

-- Open buffer switcher from inside terminal.
k("§", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-\\><c-n>", true, true, true), "n", true)
	local bmui = require("buffer_manager.ui")
	bmui.toggle_quick_menu()
end, { silent = true })

-- Paste from register in terminal.
k("<c-r>", [['<c-\><c-n>"'.nr2char(getchar()).'pi']], { expr = true })
