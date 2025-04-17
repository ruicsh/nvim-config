local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("v", lhs, rhs, options)
end

-- Store relative line number jumps in the jumplist if they exceed a threshold.
k("k", function()
	return vim.v.count and (vim.v.count > 5 and "m'" .. vim.v.count or "") .. "k" or "gk"
end, { expr = true })
k("j", function()
	return vim.v.count and (vim.v.count > 5 and "m'" .. vim.v.count or "") .. "j" or "gj"
end, { expr = true })

-- Paste over currently selected text without yanking it.
k("P", '"_dP')
k("X", '"_X')
k("c", '"_c')
k("p", '"_dp')
k("x", '"_x')

-- Navigation
k("{", "6k")
k("}", "6j")

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
