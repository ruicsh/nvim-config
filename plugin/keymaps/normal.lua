local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation
k("{", ":keepjumps normal!6k<cr>", { desc = "Jump up 6 lines", silent = true })
k("}", ":keepjumps normal!6j<cr>", { desc = "Jump down 6 lines", silent = true })

-- Editing
k("[<space>", ":call append(line('.') - 1, repeat([''], v:count1))<cr>", { desc = "Put empty line above" }) -- FIXME: will be default in v0.11
k("]<space>", ":call append(line('.'),     repeat([''], v:count1))<cr>", { desc = "Put empty line below" }) -- FIXME: will be default in v0.11
k("[p", ":pu!<cr>==", { desc = "Paste on new line above" })
k("]p", ":pu<cr>==", { desc = "Paste on new line below" })
k("U", "<C-r>", { desc = "Redo" })

-- Move lines
k("]e", ":m .+1<cr>==", { desc = "Move line down" })
k("[e", ":m .-2<cr>==", { desc = "Move line up" })

-- Don't place on register when deleting/changing.
k("C", '"_C')
k("c", '"_c')
k("cc", '"_cc')
k("x", '"_x')
k("X", '"_X')

-- Folds
k("[z", "zk%^") -- Jump to start of previous fold.
k("]z", "zj") -- Jump to start of next fold.
k("<tab>", function()
	local linenr = vim.fn.line(".")
	-- If there's no fold to be opened/closed, do nothing.
	if vim.fn.foldlevel(linenr) == 0 then
		return
	end

	-- Open recursively if closed, close (not recursively) if open.
	local cmd = vim.fn.foldclosed(linenr) == -1 and "zc" or "zO"
	vim.cmd("normal! " .. cmd)
end, { noremap = true, silent = true, desc = "Folds: Toggle" })
k("<s-tab>", "zo", { desc = "Folds: open" })

-- Buffers
k("<bs>", ":JumpToLastVisitedBuffer<cr>", { desc = "Toggle to last buffer" })
local bufdelete = require("snacks.bufdelete")
k("<leader>bC", bufdelete.all, { desc = "Buffers: Close all" })
k("<leader>bo", bufdelete.other, { desc = "Buffers: Close all other" })

-- Windows
k("|", "<c-w>w", { desc = "Windows: Switch" })
k("<c-w>|", "<c-w>v", { desc = "Windows: Split vertically" })
k("<c-w>[", "<c-w>x<c-w>w", { desc = "Windows: Move file to the left" })
k("<c-w>]", "<c-w>x<c-w>w", { desc = "Windows: Move file to the right" })
k("<c-w>m", ":WindowToggleMaximize<cr>", { desc = "Windows: Maximize" })

-- Tabs
k("<leader>tc", ":tabclose<cr>", { desc = "Tabs: Close", silent = true })
k("<leader>tn", ":tabnew<cr>", { desc = "Tabs: New", silent = true })

-- Quickfix
k("<leader>qq", ":copen<cr>", { desc = "Quickfix: Open quickfix" })
k("<leader>ql", ":lopen<cr>", { desc = "Quickfix: Open location list" })
k("<leader>qc", ":OpenChangesInQuickfix<cr>", { desc = "Quickfix: open changes list" })
k("<leader>qj", ":OpenJumpsInQuickfix<cr>", { desc = "Quickfix: open jumps list" })
k("[<c-q>", ":cpfile<cr>", { desc = "Quickfix: Previous file" }) -- FIXME: will be default in v0.11
k("]<c-q>", ":cnfile<cr>", { desc = "Quickfix: Next file" }) -- FIXME: will be default in v0.11

-- Don't store empty lines in register.
-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
k("dd", function()
	return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

-- Keep same logic from y/c/d on v for selection
k("V", "v$") -- Select until end of line
k("vv", "V") -- Enter visual linewise mode

k("<leader>w", ":write<cr>", { desc = "Save file", silent = true }) -- Save changes
k("<s-z><s-z>", ":wqa!<cr>", { desc = "Quit file", silent = true }) -- Quit and save all

-- Miscellaneous
k("<c-t>", ":terminal<cr>", { desc = "Terminal: Open" })
k("<c-\\>", ":ToggleTerminal<cr>", { desc = "Terminal: Toggle" })
k("ycc", "yygccp", { remap = true }) -- Duplicate a line and comment out the first line.
k("J", "mzJ`z:delmarks z<cr>") -- Keep cursor in place when joining lines
k("Q", "<nop>") -- Avoid unintentional switches to Ex mode.

k("<cr>", "<c-]>", { desc = "LSP: Jump to definition" })
-- k("<bs>", "<c-T>", { desc = "", unique = false })
