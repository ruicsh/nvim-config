local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("v", lhs, rhs, options)
end

-- Keep visual selection after indenting.
k("<", "<gv")
k(">", ">gv")

-- Paste over currently selected text without yanking it.
k("P", '"_dP')
k("X", '"_X')
k("c", '"_c')
k("p", '"_dp')
k("x", '"_x')

-- Navigation
k("{", "6k")
k("}", "6j")

-- Move lines
k("]e", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
k("[e", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

k("|", "<c-w>w", { desc = "Windows: Switch" })

-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
local function replace_selection(direction)
	vim.g.mc = vim.api.nvim_replace_termcodes("y/\\V<C-r>=escape(@\", '/')<CR><CR>", true, true, true)
	return function()
		return vim.g.mc .. "``cg" .. direction
	end
end
k("cn", replace_selection("n"), { expr = true, desc = "Change selection (forward)" })
k("cN", replace_selection("N"), { expr = true, desc = "Change selection (backward)" })
