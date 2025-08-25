-- Visual mode keymaps `:h visual-index`

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("x", lhs, rhs, options)
end

-- Navigation {{{
--
-- More deterministic short distance jumps
-- https://nanotipsforvim.prose.sh/vertical-navigation-%E2%80%93-without-relative-line-numbers
k("{", "6k")
k("}", "6j")

-- Use visual lines. `:h gk`
k("k", function()
	return vim.v.count > 0 and "k" or "gk"
end, { expr = true })
k("j", function()
	return vim.v.count > 0 and "j" or "gj"
end, { expr = true })

-- Matching pairs (use `m` instead of `%`)
k("m", "<Plug>(MatchitVisualForward)", { desc = "Match pair" }) -- `:h matchit-%`
k("gm", "<Plug>(MatchitVisualBackward)", { desc = "Match pair backward" }) -- `:h v_g%`
k("[m", "<Plug>(MatchitVisualMultiBackward)", { desc = "Unmatched pair backward" }) -- `:h v_[%`
k("]m", "<Plug>(MatchitVisualMultiForward)", { desc = "Unmatched pair forward" }) -- `:h v_]%`
k("am", "<Plug>(MatchitVisualTextObject)", { desc = "Around matched pair" }) -- `:h v_a%`

-- Start/end of line
k("<s-h>", "^", { desc = "Start of line" }) -- `:h ^`
k("<s-l>", "g_", { desc = "End of line" }) -- `:h g_`
--
-- }}}

-- Editing {{{
--
k("Y", "y$") -- Make Y behave like normal mode

-- Save file
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update | redraw<cr>", { desc = "Save", unique = false })
end

-- Move selection up/down
k("<a-up>", ":move '<-2<cr>gv=gv", { desc = "Move selection up" })
k("<a-down>", ":move '>+1<cr>gv=gv", { desc = "Move selection down" })

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

-- Same behaviour for `I`/`A` as in normal mode
-- https://www.reddit.com/r/neovim/comments/1k4efz8/comment/moelhto/
k("<s-i>", function()
	return vim.fn.mode() == "V" and "^<c-v><s-i>" or "<s-i>"
end, { expr = true })
k("<s-a>", function()
	return vim.fn.mode() == "V" and "$<c-v><s-a>" or "<s-a>"
end, { expr = true })
--
-- }}}

-- Search {{{
--
k("/", "<esc>/\\%V", { desc = "Search in selection" }) -- `:h /\%V`
k("g?", function()
	local selection = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() }), " "
	local query = vim.trim(table.concat(selection, " "))
	local url = ("https://google.com/search?q=%s"):format(query)
	vim.ui.open(url)
	vim.api.nvim_input("<esc>")
end)
--
-- }}}

-- Windows {{{
--
k("<bslash>", "<esc><c-w>p", { desc = "Windows: Previous" }) -- `:h CTRL-W_p`
k("<bar>", "<esc><c-w>w", { desc = "Windows: Cycle" }) -- `:h CTRL-W_w`
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0
