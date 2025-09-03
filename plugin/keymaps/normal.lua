-- Normal mode keymaps `:h normal-index`

local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation {{{
--
-- More deterministic short distance jumps
-- https://nanotipsforvim.prose.sh/vertical-navigation-%E2%80%93-without-relative-line-numbers
k("<", "6k", { desc = "Jump up 6 lines" })
k(">", "6j", { desc = "Jump down 6 lines" })
k("<c-u>", "6k", { desc = "Jump up 6 lines" })
k("<c-d>", "6j", { desc = "Jump down 6 lines" })

-- For small jumps, use visual lines. `:h gk`
-- Store relative line number jumps in the jumplist, by setting a mark. `:h m'`
k("k", function()
	return vim.v.count > 0 and "m'" .. vim.v.count .. "k" or "gk"
end, { expr = true })
k("j", function()
	return vim.v.count > 0 and "m'" .. vim.v.count .. "j" or "gj"
end, { expr = true })

-- Jump to mark `:h map-backtick`
k("'", "`", { desc = "Jump to mark position" })

-- Matching pairs (use `m` instead of `%`)
k("mm", "<Plug>(MatchitNormalForward)", { desc = "Match pair" }) -- `:h matchit-%`
k("gm", "<Plug>(MatchitNormalBackward)", { desc = "Match pair backward" }) -- `:h g%`
k("[m", "<Plug>(MatchitNormalMultiBackward)", { desc = "Unmatched pair backward" }) -- `:h [%`
k("]m", "<Plug>(MatchitNormalMultiForward)", { desc = "Unmatched pair forward" }) -- `:h ]%`

-- Jump to start/end of line
k("<s-h>", "^", { desc = "Jump to start of line" }) -- `:h ^`
k("<s-l>", "g_", { desc = "Jump to end of line" }) -- `:h g_`

k("<c-s-o>", "<c-i>", { desc = "Jump forward in jumplist" }) -- `:h CTRL-I`
--
-- }}}

-- Editing {{{
--
k("U", "<c-r>", { desc = "Redo" }) -- `:h ctrl-r`

-- Keep same logic from `y/c/d` on `v`
k("V", "v$") -- Select until end of line
k("vv", "V") -- Enter visual linewise mode `:h V`

-- Paste on adjacent line
k("[p", ":put!<cr>==", { desc = "Paste on line above" }) -- `:h :put!`
k("]p", ":put<cr>==", { desc = "Paste on line below" }) -- `:h :put`

-- Move current line up/down
-- https://www.reddit.com/r/vim/comments/i8b5z1/is_there_a_more_elegant_way_to_move_lines_than_eg/
k("<a-up>", ":<c-u>move-2<cr>==", { desc = "Move current line up" }) -- `:h :move`
k("<a-down>", ":<c-u>move+1<cr>==", { desc = "Move current line down" }) -- `:h :move`

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
	k(key, '"_' .. key) -- `:h "_`
end

-- Don't store empty lines in register.
-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
k("dd", function()
	return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
k("cn", "*``cgn", { desc = "Change word (forward)" }) -- `:h gn`
k("cN", "*``cgN", { desc = "Change word (backward)" }) -- `:h gN`

-- Toggle character case without moving cursor
k("~", "v~", { desc = "Toggle character case" }) -- `:h ~`
--
-- }}}

-- Search {{{
--
-- Mark position before search
-- Use `'s` to go back to where search started
-- https://github.com/justinmk/config/blob/master/.config/nvim/plugin/my/keymaps.lua#L51
local mark_search_keys = {
	["/"] = "Search forward",
	["?"] = "Search backward",
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

-- Search for first occurrence of word under cursor
k("[/", "ms[<c-i>zv", { desc = "Search for first occurrence of word under cursor" }) -- `:h [_ctrl-i`

-- Search for first occurrence of word under cursor, in a new window
k("<c-w>/", function()
	local word = vim.fn.expand("<cword>")
	if word ~= "" then
		vim.cmd("only | vsplit | silent! ijump /" .. word .. "/ | normal! zv") -- `:h ijump`
	end
end, { desc = "Search for first occurrence of word under cursor in new window" })

-- Clear search highlight when moving back to position before starting the search
k("'s", function()
	vim.cmd("normal! `s")
	vim.cmd.nohlsearch()
end, { desc = "Jump to where search started" })

-- `*` is hard to type
k("g/", "ms:keepjumps normal! *N<cr>", { desc = "Search current word", silent = true }) -- `:h *`
k("<s-g>/", "/\\<<c-r><c-w>\\>", { desc = "Search current word (no jumps)" }) -- `:h c_ctrl-g`
k("g./", "ms/<c-r>/<cr>N", { desc = "Repeat last search" }) -- `:h quote_/`

-- Web search
k("gb/", function()
	local query = vim.fn.expand("<cword>")
	local encoded = vim.fn.urlencode(query)
	local url = ("https://google.com/search?q=%s"):format(encoded)
	vim.cmd("Browse " .. url)
end, { desc = "Search web for word under cursor" })

-- Replace current word under cursor
k("gr/", ":%s/\\<<c-r><c-w>\\>//g<left><left>", { desc = "Replace current word" })
--
-- }}}

-- Buffers {{{
--
k("<c-e>", require("snacks").bufdelete.delete, { desc = "Close buffer" }) -- `:h :bdelete`
k("<bs>", "<c-6>", { desc = "Toggle to last buffer" }) -- `:h CTRL-6`
k("<c-n>", ":bnext<cr>", { desc = "Next buffer" }) -- `:h :bnext`
k("<c-p>", ":bprevious<cr>", { desc = "Previous buffer" }) -- `:h :bprevious`
--
-- }}}

-- Windows {{{
--
-- Switch windows
k("<tab>", "<c-w>w", { desc = "Next window" }) -- `:h CTRL-W_w`

-- Close window, not if it's the last one
k("q", function()
	return vim.fn.winnr("$") == 1 and "" or "<c-w>q" -- `:h CTRL-W_q`
end, { expr = true })
k("<c-q>", ":qa!<cr>", { desc = "Quit all" }) -- Quit all windows and exit Vim

-- Same as `:h ctrl-w_T` but without closing the current window
k("<c-w>t", function()
	local file = vim.fn.expand("%:p")
	require("snacks").bufdelete.delete() -- Close current buffer, keep window layout
	vim.cmd("tabedit " .. file) -- Open the file in a new tab
end, { desc = "Windows: Move to new tab" })
--
-- }}}

-- Tabs {{{
--
k("<leader><tab><tab>", ":tabnew<cr>", { desc = "Tabs: New" }) -- `:h :tabnew`
k("<leader><tab>q", ":tabclose<cr>", { desc = "Tabs: Close" }) -- `:h :tabclose`
--
-- }}}

-- Miscellaneous {{{
--
k("Q", "q", { desc = "Start recording macro" }) -- `:h q`
k("gV", "`[v`]", { desc = "Reselect last changed or yanked text" }) -- `:h `[`
k("g:", ":lua = ", { desc = "Evaluate Lua expression" }) -- `:h :lua`
k("gK", ":help <c-r><c-w><cr>", { desc = "Help for word under cursor" }) -- `:h :help`
k("za", "zA", { desc = "Toggle fold under cursor" }) -- `:h zA`
k("<c-t>", ":ToggleTerminal<cr>", { desc = "Terminal: Toggle" })
--
-- }}}

-- Disable default keymaps {{{
--
-- Have to ween myself off using these, bad for my wrists
local disable_keys = { "{", "}" }
for _, key in ipairs(disable_keys) do
	k(key, "<nop>", { desc = "Disable default behavior" })
end

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
