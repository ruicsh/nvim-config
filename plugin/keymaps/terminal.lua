-- Terminal mode keymaps

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("t", lhs, rhs, options)
end

k("<c-q>", "<c-bslash><c-n>", { desc = "Exit terminal mode" })

k("<c-bslash>", function()
	vim.cmd("ToggleTerminal")
end, { desc = "Toggle terminal" })
