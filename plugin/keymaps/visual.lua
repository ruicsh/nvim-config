-- Visual mode keymaps `:h visual-index`

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("x", lhs, rhs, options)
end

-- Remove any delay for these keys
local disable_keys = { "<space>", "<leader>", "s" }
for _, key in ipairs(disable_keys) do
	k(key, "<nop>", { unique = false })
end
--
-- }}}

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

-- Start/end of line
k("<s-h>", "^", { desc = "Start of line" }) -- `:h ^`
k("<s-l>", "g_", { desc = "End of line" }) -- `:h g_`
--
-- }}}

-- Editing {{{
--
k("Y", "y$") -- Make Y behave like normal mode
k("yy", "y") -- So that yanking has no delay (because of `yc`)

-- Save file
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update | redraw<cr>", { desc = "Save", unique = false })
end

-- Move selection up/down
-- https://www.reddit.com/r/vim/comments/i8b5z1/is_there_a_more_elegant_way_to_move_lines_than_eg/
k("<a-up>", ":move-2<cr>='[gv", { desc = "Move selection up" })
k("<a-down>", ":move'>+1<cr>='[gv", { desc = "Move selection down" })

-- Indent/dedent selection
k(">", ">gv") -- Reselect after indent
k("<", "<gv") -- Reselect after dedent

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

-- Repeat last change across visual selection
k(".", ":normal .<cr>", { desc = "Repeat last change" }) -- `:h .`

-- Indent/dedent and reselect
k("<tab>", ">gv|") -- `:h gv`
k("<s-tab>", "<gv") -- `:h gv`

--
-- }}}

-- Search {{{
--
-- Search current selection
k("g/", function()
	local selection = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
	local text = vim.trim(table.concat(selection, " "))
	local escaped = vim.fn.escape(text, [[\/.*$^~[]])
	return "<esc>/" .. escaped .. "<cr>N"
end, { desc = "Search selection", expr = true })

-- Search current selection in the workspace
k("<leader>g/", require("snacks.picker").grep_word, { desc = "Search selection in workspace" })

-- Search inside visual selection
k("/", "<esc>/\\%V", { desc = "Search inside selection" }) -- `:h /\%V`

-- Web search selection
k("gb/", function()
	local selection = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
	local query = vim.trim(table.concat(selection, " "))
	local encoded = vim.fn.urlencode(query)
	local url = ("https://google.com/search?q=%s"):format(encoded)
	vim.cmd("Browse " .. url)
	vim.api.nvim_input("<esc>")
end)

-- Replace selection
k("gr/", '"hy:%s/\\<<c-r>h\\>//g<left><left>', { desc = "Replace selection" })
--
-- }}}

-- Windows {{{
--
k("<bslash>", "<esc><c-w>p", { desc = "Windows: Previous" }) -- `:h CTRL-W_p`
k("<bar>", "<esc><c-w>w", { desc = "Windows: Cycle" }) -- `:h CTRL-W_w`
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0
