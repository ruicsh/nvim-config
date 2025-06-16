-- Terminal mode keymaps

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("t", lhs, rhs, options)
end

-- Enter normal mode :h t_CTRL-\_CTRL-N
k("<c-[>", "<c-bslash><c-n>", { desc = "Enter normal mode" })

-- Toggle terminal buffer (close as we are in terminal mode)
k("<c-bslash>", function()
	vim.cmd("ToggleTerminal")
end, { desc = "Toggle terminal" })
