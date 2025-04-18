local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation
k("{", ":keepjumps normal!6k<cr>", { desc = "Jump up 6 lines", silent = true })
k("}", ":keepjumps normal!6j<cr>", { desc = "Jump down 6 lines", silent = true })
-- Store relative line number jumps in the jumplist if they exceed a threshold.
-- For small jumps, use visual lines.
k("k", function()
	return vim.v.count > 5 and "m'" .. vim.v.count .. "k" or "gk"
end, { expr = true })
k("j", function()
	return vim.v.count > 5 and "m'" .. vim.v.count .. "j" or "gj"
end, { expr = true })
-- <c-i> would trigger the toggle fold because it's the same as <tab>
-- ' as in jump to mark and ;, as used in the changelist (g;, g,).
k("';", "<c-o>", { desc = "Older cursor position" })
k("',", "<c-i>", { desc = "Newer cursor position" })

-- Editing
k("[p", ":pu!<cr>==", { desc = "Paste on new line above" })
k("]p", ":pu<cr>==", { desc = "Paste on new line below" })
k("U", "<C-r>", { desc = "Redo" })
k("<leader>w", vim.cmd.write, { desc = "Save file", silent = true }) -- Save changes
k("J", "mzJ`z:delmarks z<cr>") -- Keep cursor in place when joining lines
k("ycc", "yygccp", { remap = true }) -- Duplicate a line and comment out the first line.

-- Don't place on register when changing text or deleting a character.
k("C", '"_C')
k("c", '"_c')
k("cc", '"_cc')
k("x", '"_x')
k("X", '"_X')

-- Don't store empty lines in register.
-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
k("dd", function()
	return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

-- Keep same logic from `y/c/d` on `v`
k("V", "v$") -- Select until end of line
k("vv", "V") -- Enter visual linewise mode

-- Copy relative file path
k("<leader>yf", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	vim.fn.setreg("+", path)
end, { desc = "Copy relative file path" })

-- Copy directory path
k("<leader>yd", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":~:.")
	vim.fn.setreg("+", path)
end, { desc = "Copy directory path" })

-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
k("cn", "*``cgn", { desc = "Change word (forward)" })
k("cN", "*``cgN", { desc = "Change word (backward)" })

-- https://github.com/justinmk/config/blob/master/.config/nvim/init.vim#L214C18-L215C1
k("gV", "`[v`]", { desc = "Select last insert text" })

-- Don't store jumps when browsing search results
k("n", ":keepjumps normal! n<cr>", { desc = "Search: Next" })
k("N", ":keepjumps normal! N<cr>", { desc = "Search: Previous" })

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

-- Split search
-- Mimics the native behavior of `<c-w>i` :h CTRL-W_i
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

-- Make `<c-w><c-i>` work with `n` and `N`
k("<c-w><c-i>", function()
	local cword = vim.fn.expand("<cword>")
	vim.cmd.split()
	vim.cmd("normal! gg")
	vim.cmd("/" .. vim.fn.escape(cword, "\\[]^$.*~/"))
	vim.cmd("normal! n")
end, { desc = "Split window and search current word from beginning of file" })

-- This simulates the native `[<c-i>` behavior but doesn't include imported files.
-- It also allows using `n` to jump to the next search result (native is `]<c-i>`).
-- `<c-i>` is the same as `<tab>` :h [_CTRL-I
k("[<c-i>", function()
	local cword = vim.fn.expand("<cword>")
	vim.cmd("normal! ms")
	vim.cmd("normal! gg")
	vim.cmd("/" .. vim.fn.escape(cword, "\\[]^$.*~/"))
	vim.cmd("normal! n")
end, { desc = "Search current word (from beginning of file)" })

-- Clear search highlight when moving back to position before starting the search
k("'s", function()
	vim.cmd("normal! `s")
	vim.cmd.nohlsearch()
end, { desc = "Jump to last search" })

-- List messages in a buffer
-- https://github.com/deathbeam/dotfiles/blob/master/vim/.vimrc#L178C1-L179C1
k("<leader>nm", function()
	vim.cmd("botright new +set\\ buftype=nofile\\ bufhidden=wipe\\ wrap")
	vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.2)) -- Set height to 30% of screen
	vim.cmd("put =execute('messages')")
end, { desc = "Messages" })

k("Q", "<nop>") -- Avoid unintentional switches to Ex mode.

---
-- Stop setting keymaps incompatible with vscode
---
if vim.g.vscode then
	return
end

-- Delete marks
k("M", function()
	local mark = vim.fn.getcharstr()
	vim.cmd.delmark(mark)
end, { desc = "Delete mark" })

-- Buffers
k("<bs>", ":JumpToLastVisitedBuffer<cr>", { desc = "Toggle to last buffer" })
local bufdelete = require("snacks.bufdelete")
k("<leader>bC", bufdelete.all, { desc = "Buffers: Close all" })
k("<leader>bo", bufdelete.other, { desc = "Buffers: Close all other" })

-- Windows
k("|", "<c-w>w", { desc = "Windows: Switch" })
k("<c-w>[", ":SendBufferToWindow h<cr>", { desc = "Windows: Send to left window" })
k("<c-w>]", ":SendBufferToWindow l<cr>", { desc = "Windows: Send to right window" })

-- Quickfix
k("<leader>qq", vim.cmd.copen, { desc = "Quickfix: Open quickfix" })
k("<leader>ql", vim.cmd.lopen, { desc = "Quickfix: Open location list" })
k("<leader>qc", ":OpenChangesInQuickfix<cr>", { desc = "Quickfix: open changes list" })
k("<leader>qj", ":OpenJumpsInQuickfix<cr>", { desc = "Quickfix: open jumps list" })

-- LSP navigation
k("<cr>", "<c-]>", { desc = "LSP: Jump to definition" })
k("<s-cr>", "<c-T>", { desc = "LSP: Jump back from definition" })

-- Miscellaneous
k("<c-\\>", ":ToggleTerminal<cr>", { desc = "Terminal: Toggle" })

-- Tabs: Go to #{1..9}
for i = 1, 9 do
	k("§" .. i, function()
		vim.cmd.tabnext(i)
	end, { desc = "Tabs: Go to #" .. i })
end
