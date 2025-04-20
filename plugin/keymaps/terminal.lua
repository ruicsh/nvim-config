local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("t", lhs, rhs, options)
end

-- Toggle terminal open/close
k("<c-\\>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-\\><c-n>", true, true, true), "n", true)
	vim.cmd("ToggleTerminal")
end, { desc = "Toggle terminal" })

-- Leave terminal window with <c-w>hjkl.
local code_term_esc = vim.api.nvim_replace_termcodes("<c-\\><c-n>", true, true, true)
for _, key in ipairs({ "h", "j", "k", "l" }) do
	k("<c-w>" .. key, function()
		local code_dir = vim.api.nvim_replace_termcodes("<c-w>" .. key, true, true, true)
		vim.api.nvim_feedkeys(code_term_esc .. code_dir, "t", true)
	end, {})
end
