local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, silent = true, unique = true }, opts or {})
	vim.keymap.set("i", lhs, rhs, options)
end

-- Use nvim-cmp instead of the default autocomplete (when on empty line)
local cmp = require("cmp")
k("<c-n>", cmp.complete)
k("<c-p>", cmp.complete)
