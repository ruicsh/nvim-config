-- Visual mode keymaps `:h visual-index`

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("v", lhs, rhs, options)
end

-- Navigation {{{

-- More deterministic short distance jumps
-- https://nanotipsforvim.prose.sh/vertical-navigation-%E2%80%93-without-relative-line-numbers
k("{", "6k")
k("}", "6j")

-- Store relative line number jumps in the jumplist if they exceed a threshold.
-- For small jumps, use visual lines.
k("k", function()
	return vim.v.count > 0 and "m'" .. vim.v.count .. "k" or "gk"
end, { expr = true })
k("j", function()
	return vim.v.count > 0 and "m'" .. vim.v.count .. "j" or "gj"
end, { expr = true })

-- }}}

-- Editing {{{
k("Y", "y$") -- Make Y behave like normal mode

-- Save file
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update | redraw<cr>", { desc = "Save", unique = false })
end

-- Move lines
k("]e", ":m '>+1<cr>gv=gv", { desc = "Move line down", silent = true })
k("[e", ":m '<-2<cr>gv=gv", { desc = "Move line up", silent = true })

-- Paste over currently selected text without yanking it.
k("P", '"_dP')
k("X", '"_X')
k("c", '"_c')
k("p", '"_dp')
k("x", '"_x')

-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
local function replace_selection(direction)
	vim.g.mc = vim.api.nvim_replace_termcodes("y/\\V<c-r>=escape(@\", '/')<cr><cr>", true, true, true)
	return function()
		return vim.g.mc .. "``cg" .. direction
	end
end
k("cn", replace_selection("n"), { expr = true, desc = "Change selection (forward)" })
k("cN", replace_selection("N"), { expr = true, desc = "Change selection (backward)" })

-- Same behavior for `I`/`A` as in normal mode
-- https://www.reddit.com/r/neovim/comments/1k4efz8/comment/moelhto/
k("I", function()
	return vim.fn.mode() == "V" and "^<c-v>I" or "I"
end, { expr = true })
k("A", function()
	return vim.fn.mode() == "V" and "$<c-v>A" or "A"
end, { expr = true })

-- }}}

-- Search {{{
k("/", "<esc>/\\%V") -- Search within visual selection
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0
