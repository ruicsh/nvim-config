-- Normal mode keymaps `:h normal-index`

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
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
-- Always jump on visual lines, not actual lines. `:h gj`
-- Always jump to the start of the line. `:h g0`
k("{", "6gkg0", { desc = "Jump up 6 lines" })
k("}", "6gjg0", { desc = "Jump down 6 lines" })

-- For small jumps, use visual lines. `:h gk`
-- Store relative line number jumps in the jumplist, by setting a mark. `:h m'`
k("k", [[v:count > 0 ? "m'" . v:count . "k" : "gk"]], { expr = true })
k("j", [[v:count > 0 ? "m'" . v:count . "j" : "gj"]], { expr = true })

-- Jump to mark `:h map-backtick`
k("'", "`", { desc = "Jump to mark position" })

-- Jumplist
k("<leader>[", "<c-o>", { desc = "Jump to older position in jumplist" }) -- `:h <c-o>`
k("<leader>]", "<c-i>", { desc = "Jump to newer position in jumplist" }) -- `:h <c-i>`
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
-- Helper to set search keymaps
local function ks(lhs, rhs, opts)
	k(lhs, function()
		vim.schedule(vim.search.show_search_count)
		return "ms" .. rhs -- Mark position before search with `ms`. `:h m`
	end, vim.tbl_extend("force", { expr = true }, opts or {}))
end

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
	ks(key, key, { desc = desc })
end

local search_browse_keys = { "n", "N" } -- `:h n`
for _, key in ipairs(search_browse_keys) do
	ks(key, key .. "zv", { desc = "Browse search results" })
end

-- Search for first occurrence of word under cursor
ks("[/", "[<c-i>zv", { desc = "Search for first occurrence of word under cursor" }) -- `:h [_ctrl-i`

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
ks("g/", ":keepjumps normal! *N<cr>", { desc = "Search current word", silent = true }) -- `:h *`
ks("g./", "/<c-r>/<cr>N", { desc = "Repeat last search" }) -- `:h quote_/`

-- Web search
k("gb/", function()
	local query = vim.fn.expand("<cword>")
	local encoded = vim.fn.urlencode(query)
	local url = ("https://google.com/search?q=%s"):format(encoded)
	vim.cmd("Browse " .. url)
end, { desc = "Search web for word under cursor" })

-- Replace current word under cursor
k("gr/", ":%s/\\<<c-r><c-w>\\>//g<left><left>", { desc = "Replace current word" })

-- Clear search highlight
k("<esc>", function()
	vim.search.clear_search_count()
	vim.cmd.nohlsearch()
	return "<esc>"
end, { desc = "Clear search highlight", expr = true })
--
-- }}}

-- Buffers {{{
--
k("<bs>", ":b#<cr>", { desc = "Switch to previous buffer" }) -- `:h :b#`
--
-- }}}

-- Windows {{{
--
-- Switch windows
k("<bar>", "<c-w>w", { desc = "Next window" }) -- `:h CTRL-W_w`

-- Close window, not if it's the last one
k("q", function()
	-- List all windows, discard non-focusable ones
	local num_wins = #vim.api.nvim_list_wins()
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		local win = vim.api.nvim_win_get_config(winnr)
		if win.focusable == false then
			num_wins = num_wins - 1
		end
	end

	-- If there's only one window left, and it's an unnamed buffer, do nothing
	if num_wins == 1 then
		local buf = vim.api.nvim_get_current_buf()
		local bufname = vim.api.nvim_buf_get_name(buf)
		if bufname == "" then
			return ""
		end
	end

	if num_wins == 1 then
		return ":bdelete<cr>" -- `:h :bd`
	end

	return "<c-w>q" -- `:h CTRL-W_q`
end, { expr = true, silent = true, desc = "Close buffer/window" })
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
k("[<tab>", ":tabprevious<cr>", { desc = "Tabs: Previous" }) -- `:h :tabprevious`
k("]<tab>", ":tabnext<cr>", { desc = "Tabs: Next" }) -- `:h :tabnext`
--
-- }}}

-- Folds {{{
--
-- Jump to newer position in jumplist
k("<tab>", "za", { desc = "Toggle fold" }) -- `:h za`
k("<s-tab>", "zA", { desc = "Toggle all folds" }) -- `:h zA`
--
-- }}}

-- Miscellaneous {{{
--
k("<leader>v", "<c-v>", { desc = "Enter visual block mode" }) -- `:h <c-v>`
k("Q", "q", { desc = "Start recording macro" }) -- `:h q`
k("g:", ":lua = ", { desc = "Evaluate Lua expression" }) -- `:h :lua`
k("gK", ":help <c-r><c-w><cr>", { desc = "Help for word under cursor" }) -- `:h :help`
k("gV", "`[v`]", { desc = "Reselect last changed or yanked text" }) -- `:h `[`
k("gf", ":edit <cfile><CR>") -- Allow gf to open non-existing files `:h gf`
--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
