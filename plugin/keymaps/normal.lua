local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation
k("{", ":keepjumps normal!6k<cr>", { desc = "Jump up 6 lines", silent = true })
k("}", ":keepjumps normal!6j<cr>", { desc = "Jump down 6 lines", silent = true })
k("j", "gj", { desc = "Jump down 1 line" }) -- Always use visual lines
k("k", "gk", { desc = "Jump up 1 line" }) -- Always use visual lines
k("<up>", "gk", { desc = "Jump down 1 line" }) -- Always use visual lines
k("<down>", "gj", { desc = "Jump up 1 line" }) -- Always use visual lines

-- Mark position before search
-- https://github.com/justinmk/config/blob/master/.config/nvim/init.vim#L149
k("/", "ms/", { desc = "Search forward" })

-- Editing
k("[p", ":pu!<cr>==", { desc = "Paste on new line above" })
k("]p", ":pu<cr>==", { desc = "Paste on new line below" })
k("U", "<C-r>", { desc = "Redo" })
k("<leader>w", vim.cmd.write, { desc = "Save file", silent = true }) -- Save changes
k("J", "mzJ`z:delmarks z<cr>") -- Keep cursor in place when joining lines
k("ycc", "yygccp", { remap = true }) -- Duplicate a line and comment out the first line.

-- Don't place on register when deleting/changing.
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

-- Keep same logic from y/c/d on v
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

-- Center cursor
k("n", "nzz", { desc = "Search: Next" }) -- When jumping to next search result
k("N", "Nzz", { desc = "Search: Previous" }) -- When jumping to previous search result
k("<c-o>", "<c-o>zz", { desc = "Jump to older cursor position" }) -- When jumping to older cursor position
k("<c-i>", "<tab>zz", { desc = "Jump to newer cursor position" }) -- When jumping to newer cursor position

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
k("Q", "<nop>") -- Avoid unintentional switches to Ex mode.

-- Taba: Go to #{1..9}
for i = 1, 9 do
	k("§" .. i, function()
		vim.cmd.tabnext(i)
	end, { desc = "Tabs: Go to #" .. i })
end
