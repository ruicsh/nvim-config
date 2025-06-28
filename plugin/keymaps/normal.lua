-- Normal mode keymaps `:h normal-index`

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation {{{

-- More deterministic short distance jumps
-- https://nanotipsforvim.prose.sh/vertical-navigation-%E2%80%93-without-relative-line-numbers
k("{", ":normal! 6k<cr>", { desc = "Jump up 6 lines", silent = true })
k("}", ":normal! 6j<cr>", { desc = "Jump down 6 lines", silent = true })

-- Store relative line number jumps in the jumplist.
-- For small jumps, use visual lines.
k("k", function()
	return vim.v.count > 0 and "m'" .. vim.v.count .. "k" or "gk"
end, { expr = true })
k("j", function()
	return vim.v.count > 0 and "m'" .. vim.v.count .. "j" or "gj"
end, { expr = true })

-- <c-i> would trigger the toggle fold because it's the same as <tab>
-- ' as in jump to mark and ;, as used in the changelist (g;, g,).
k("';", "<c-o>", { desc = "Older cursor position" })
k("',", "<c-i>", { desc = "Newer cursor position" })

-- Center cursor in the middle of the screen when scrolling
local center_scroll_keys = {
	["<c-u>"] = "Scroll up half a screen",
	["<c-d>"] = "Scroll down half a screen",
}
for key, desc in pairs(center_scroll_keys) do
	k(key, key .. "zz", { desc = desc })
end

-- Jump to mark, don't change jumplist `:h map-backtick` `:h g``
k("'", "g`", { desc = "Jump to mark cursor" })

-- }}}

-- Editing {{{

k("<c-v>", '"*p', { desc = "Paste" })
k("U", "<c-r>", { desc = "Redo" })

-- Keep same logic from `y/c/d` on `v`
k("V", "v$") -- Select until end of line
k("vv", "V") -- Enter visual linewise mode

-- Paste on adjacent line
k("[p", ":put!<cr>==", { desc = "Paste on line above" })
k("]p", ":put<cr>==", { desc = "Paste on line below" })

-- Move lines
k("]e", ":m .+1<cr>==", { desc = "Move line down", silent = true })
k("[e", ":m .-2<cr>==", { desc = "Move line up", silent = true })

-- Keep cursor in place when joining lines
k("J", "mzJ`z:delmarks z<cr>")

-- Save file
local save_keys = { "<c-s>", "<d-s>" }
for _, key in ipairs(save_keys) do
	k(key, "<cmd>silent! update | redraw<cr>", { desc = "Save" })
end

-- Don't store on register when changing text or deleting a character.
local black_hole_commands = { "C", "c", "cc", "x", "X" }
for _, key in pairs(black_hole_commands) do
	k(key, '"_' .. key)
end

-- Don't store empty lines in register.
-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
k("dd", function()
	return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

-- Copy relative file path
k("<leader>yf", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	vim.fn.setreg("+", path)
end, { desc = "Copy relative file path" })

-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
k("cn", "*``cgn", { desc = "Change word (forward)" })
k("cN", "*``cgN", { desc = "Change word (backward)" })

-- }}}

-- Search {{{

-- Mark position before search
-- Use `'s` to go back to where search started
-- https://github.com/justinmk/config/blob/master/.config/nvim/plugin/my/keymaps.lua#L51
local mark_search_keys = {
	["/"] = "Search forward",
	["*"] = "Search current word (forward)",
	["#"] = "Search current word (backward)",
	["£"] = "Search current word (backward)",
	["g*"] = "Search current word (forward, not whole word)",
	["g#"] = "Search current word (backward, not whole word)",
	["g£"] = "Search current word (backward, not whole word)",
}
for key, desc in pairs(mark_search_keys) do
	k(key, "ms" .. key, { desc = desc })
end

-- Clear search highlight when moving back to position before starting the search
k("'s", function()
	vim.cmd("normal! `s")
	vim.cmd.nohlsearch()
end, { desc = "Last searched from position" })

-- Split search
-- Mimics the native behaviour of `<c-w>i` :h CTRL-W_i
local split_search_keys = {
	["/"] = "Split window and search",
	["*"] = "Split window and search current word (forward)",
	["#"] = "Split window and search current word (backward)",
	["£"] = "Split window and search current word (backward)",
	["g*"] = "Split window and search current word (forward, not whole word)",
	["g#"] = "Split window and search current word (backward, not whole word)",
	["g£"] = "Split window and search current word (backward, not whole word)",
}
for key, desc in pairs(split_search_keys) do
	k("<c-w>" .. key, "<c-w>s" .. key, { desc = desc })
end

-- Split window and search current word from beginning of file
-- Make `<c-w><c-i>` work with `n` and `N` `:h CTRL-W_i`
k("<c-w><c-i>", function()
	local cword = vim.fn.expand("<cword>")
	vim.cmd.split()
	vim.cmd("normal! gg")
	vim.cmd("/" .. vim.fn.escape(cword, "\\[]^$.*~/"))
	vim.cmd("normal! n")
end, { desc = "Split window and search current word from beginning of file" })

-- This simulates the native `[<c-i>` behaviour but doesn't include imported files.
-- It sets a mark before searching, so can return to the position before the search with `'s`.
-- It also allows using `n` to jump to the next search result (native is `]<c-i>`).
-- `<c-i>` is the same as `<tab>` :h [_CTRL-I
k("[<c-i>", function()
	local cword = vim.fn.expand("<cword>")
	vim.cmd("normal! ms")
	vim.cmd("normal! gg")
	vim.cmd("/" .. vim.fn.escape(cword, "\\[]^$.*~/"))
	vim.cmd("normal! n")
end, { desc = "Search current word (from beginning of file)" })

-- Don't store jumps when browsing search results
k("n", ":normal! n<cr>", { desc = "Search: Next" })
k("N", ":normal! N<cr>", { desc = "Search: Previous" })

-- }}}

-- Stop setting keymaps incompatible with vscode
if vim.g.vscode then
	return
end

-- Buffers {{{
k("<bs>", "<c-6>", { desc = "Toggle to last buffer" })
-- }}}

-- Windows {{{
k("<bar>", "<c-w>w", { desc = "Windows: Switch" })
-- }}}

-- Folds {{{

-- Toggle
k("<tab>", function()
	local linenr = vim.fn.line(".")
	-- If there's no fold to be opened/closed, do nothing.
	if vim.fn.foldlevel(linenr) == 0 then
		return
	end

	-- Open if closed, close if open.
	local cmd = vim.fn.foldclosed(linenr) == -1 and "zc" or "zO"
	vim.cmd("normal! " .. cmd)
end, { silent = true, desc = "Folds: Toggle" })

-- }}}

-- Terminal {{{
k("<c-t>", ":ToggleTerminal<cr>", { desc = "Terminal: Toggle" })
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
