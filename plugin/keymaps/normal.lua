-- Normal mode keymaps `:h normal-index`

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation {{{

-- More deterministic short distance jumps
-- https://nanotipsforvim.prose.sh/vertical-navigation-%E2%80%93-without-relative-line-numbers
k("{", "6k", { desc = "Jump up 6 lines", silent = true })
k("}", "6j", { desc = "Jump down 6 lines", silent = true })

-- Store relative line number jumps in the jumplist, by setting a mark. `:h m'`
-- For small jumps, use visual lines. `:h gk`
k("k", function()
	return vim.v.count > 0 and "m'" .. vim.v.count .. "k" or "gk"
end, { expr = true })
k("j", function()
	return vim.v.count > 0 and "m'" .. vim.v.count .. "j" or "gj"
end, { expr = true })

-- <c-i> would trigger the toggle fold because it's the same as <tab> `:h CTRL-I`
-- ' as in jump to mark and ;, as used in the changelist (g;, g,). `h g;`
k("';", "<c-o>", { desc = "Older cursor position" })
k("',", "<c-i>", { desc = "Newer cursor position" })

-- Jump to mark `:h map-backtick`
k("'", "`", { desc = "Jump to mark cursor" })

-- }}}

-- Editing {{{

k("U", "<c-r>", { desc = "Redo" }) -- `:h ctrl-r`

-- Keep same logic from `y/c/d` on `v`
k("V", "v$") -- Select until end of line
k("vv", "V") -- Enter visual linewise mode `:h V`

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

-- Center screen on search results
k("n", "nzvzz", { desc = "Search: Next (center screen)" })
k("N", "Nzvzz", { desc = "Search: Previous (center screen)" })

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

-- Split window and search current word from beginning of file
-- Make `<c-w><c-i>` work with `n` and `N` `:h CTRL-W_i`
local function split_and_search_current_word()
	local cword = vim.fn.expand("<cword>")
	vim.ux.open_side_panel("vsplit || normal! gg")
	vim.cmd("/" .. vim.fn.escape(cword, "\\[]^$.*~/"))
	vim.cmd("normal! nzvzz")
end

local split_search_keys = {
	"<c-w><c-i>",
	"<c-w>i",
}
for _, key in ipairs(split_search_keys) do
	k(key, split_and_search_current_word, { desc = "Split window and search current word from beginning of file" })
end

-- }}}

-- Stop setting keymaps incompatible with vscode
if vim.g.vscode then
	return
end

-- Buffers {{{
k("<bs>", "<c-6>", { desc = "Toggle to last buffer" }) -- `:h CTRL-6`
-- }}}

-- Windows {{{
k("<bslash>", "<c-w>p", { desc = "Windows: Previous" }) -- `:h CTRL-W_p`
k("<bar>", "<c-w>w", { desc = "Windows: Cycle" }) -- `:h CTRL-W_w`
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
