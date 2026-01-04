-- Normal mode keymaps `:h normal-index`

local T = require("lib")

-- Setup {{{
--
local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Remove any delay for these keys
local disable_keys = { "<space>", "<leader>" }
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
k("{", "m'6gkg0", { desc = "Jump up 6 lines" })
k("}", "m'6gjg0", { desc = "Jump down 6 lines" })

-- For small jumps, use visual lines. `:h gk`
k("k", [[v:count > 0 ? "k" : "gk"]], { expr = true })
k("j", [[v:count > 0 ? "j" : "gj"]], { expr = true })

-- Jump to mark `:h map-backtick`
k("'", "`", { desc = "Jump to mark position" })

--
-- }}}

-- Editing {{{
--
k("U", "<c-r>", { desc = "Redo" }) -- `:h ctrl-r`

-- Keep same logic from `y/c/d` on `v`
k("V", "v$") -- Select until end of line
k("vv", "V") -- Enter visual line wise mode `:h V`

-- Keep cursor in place when joining lines
k("J", "mzJ`z:delmarks z<cr>")

-- Save file
k("<c-s>", "<cmd>silent! update | redraw<cr>", { desc = "Save" })

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

--
-- }}}

-- Search {{{
--
-- Search for first occurrence of word under cursor, in a new window
k("<c-w>/", function()
	local word = vim.fn.expand("<cword>")
	if word ~= "" then
		vim.cmd("only | vsplit | silent! ijump /" .. word .. "/ | normal! zv") -- `:h ijump`
	end
end, { desc = "Search for first occurrence of word under cursor in new window" })

-- Web search
k("gw/", function()
	local query = vim.fn.expand("<cword>")
	local encoded = T.fn.urlencode(query)
	local url = ("https://google.com/search?q=%s"):format(encoded)
	vim.cmd("Browse " .. url)
end, { desc = "Search web for word under cursor" })

-- Replace current word under cursor
k("gr/", "<cmd>%s/\\<<c-r><c-w>\\>//g<left><left>", { desc = "Replace current word" })

--
-- }}}

-- Windows {{{
--

-- Close window, not if it's the last one
k("q", function()
	-- If current window is a side panel, close all side panels and return
	local winnr = vim.api.nvim_get_current_win()
	local ok, side_panel = pcall(vim.api.nvim_win_get_var, winnr, "side_panel")
	if ok and side_panel then
		T.ui.close_side_panels()
		return
	end

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
		return "<cmd>bdelete<cr>" -- `:h :bd`
	end

	return "<c-w>q" -- `:h CTRL-W_q`
end, { expr = true, silent = true, desc = "Close buffer/window" })

k("<c-q>", "<cmd>qa!<cr>", { desc = "Quit all" }) -- Quit all windows and exit Vim
k("<leader>q", function()
	T.ui.close_side_panels()
	vim.cmd("VimMessagesClose")
	vim.cmd("CopilotChatClose")
end, { desc = "Close side panels" }) -- Close all side panels

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
k("<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Tabs: New" }) -- `:h :tabnew`
k("<leader><tab>q", "<cmd>tabclose<cr>", { desc = "Tabs: Close" }) -- `:h :tabclose`
k("[<tab>", "<cmd>tabprevious<cr>", { desc = "Tabs: Previous" }) -- `:h :tabprevious`
k("]<tab>", "<cmd>tabnext<cr>", { desc = "Tabs: Next" }) -- `:h :tabnext`

for i = 1, 9 do
	k("<leader><tab>" .. i, i .. "gt", { desc = "Tabs: Go to " .. i }) -- `:h :gt`
end
--
-- }}}

-- Yank current path {{{
--
local function yank_path(fmt)
	return function()
		local path = vim.fn.expand(fmt)
		if path == "" then
			vim.notify("No file name", vim.log.levels.WARN)
			return
		end
		vim.fn.setreg("+", path) -- `:h setreg()`
		vim.notify(("Yanked %s"):format(path), vim.log.levels.INFO)
	end
end

k("%%", yank_path("%:."), { desc = "Yank filename (relative)" })
k("%D", yank_path("%:p:h"), { desc = "Yank directory (absolute)" })
k("%d", yank_path("%:.:h"), { desc = "Yank directory (relative)" })
k("%f", yank_path("%:t"), { desc = "Yank basename (with extension)" })
k("%n", yank_path("%:t:r"), { desc = "Yank basename (no extension)" })
k("%p", yank_path("%:p"), { desc = "Yank filename (absolute)" })

--
-- }}}

-- Miscellaneous {{{
--

k("<bs>", "<cmd>b#<cr>", { desc = "Switch to previous buffer" }) -- `:h :b#`
k("<f1>", "<nop>") -- Disable F1 help
k("<leader>v", "<c-v>", { desc = "Enter visual block mode" }) -- `:h <c-v>`
k("<tab>", "za", { desc = "Toggle folds" }) -- `:h za`
k("Q", "q", { desc = "Start recording macro" }) -- `:h q`

--
-- }}}

-- vim: foldmethod=marker:foldmarker={{{,}}}:foldlevel=0:foldenable
