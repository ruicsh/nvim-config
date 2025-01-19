local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, silent = true, unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation
k("{", ":keepjumps normal!6k<cr>", { desc = "Jump up 6 lines" })
k("}", ":keepjumps normal!6j<cr>", { desc = "Jump down 6 lines" })

-- Editing
k("[<space>", ":call append(line('.') - 1, repeat([''], v:count1))<cr>", { desc = "Put empty line above" }) -- FIXME: will be default in v0.11
k("]<space>", ":call append(line('.'),     repeat([''], v:count1))<cr>", { desc = "Put empty line below" }) -- FIXME: will be default in v0.11
k("[p", ":pu!<cr>==", { desc = "Paste on new line above" })
k("]p", ":pu<cr>==", { desc = "Paste on new line below" })
k("U", "<C-r>", { desc = "Redo" })

-- Don't place on register when deleting/changing.
k("C", '"_C')
k("c", '"_c')
k("cc", '"_cc')
k("x", '"_x')
k("X", '"_X')

-- Buffers
k("<bs>", "<c-^>", { desc = "Buffers: Go to previous visited" })
local bufdelete = require("snacks.bufdelete")
k("<leader>bC", bufdelete.all, { desc = "Buffers: Close all" })
k("<leader>bo", bufdelete.other, { desc = "Buffers: Close all other" })
k("<tab>", ":bnext<cr>", { desc = "Buffers: Next" })
k("<s-tab>", ":bprev<cr>", { desc = "Buffers: Previous" })

-- Windows
k("|", "<c-w>w", { desc = "Windows: Switch" })
k("<c-w>|", "<c-w>v", { desc = "Windows: Split vertically" })
k("<c-w>[", "<c-w>x<c-w>w", { desc = "Windows: Move file to the left" })
k("<c-w>]", "<c-w>x<c-w>w", { desc = "Windows: Move file to the right" })

-- Tabs
k("<leader>tc", ":tabclose<cr>", { desc = "Tabs: Close" })
k("<leader>tn", ":tabnew<cr>", { desc = "Tabs: New" })
k("<leader>to", ":tabonly<cr>", { desc = "Tabs: Close all other" })

-- Quickfix
k("<leader>qq", ":copen<cr>", { desc = "Quickfix: Open quickfix" })
k("<leader>ql", ":lopen<cr>", { desc = "Quickfix: Open location list" })
k("<leader>qc", ":OpenChangesInQuickfix<cr>", { desc = "Quickfix: open changes list" })
k("<leader>qj", ":OpenJumpsInQuickfix<cr>", { desc = "Quickfix: open jumps list" })
k("[<c-q>", ":cpfile<cr>", { desc = "Quickfix: Previous file" }) -- FIXME: will be default in v0.11
k("]<c-q>", ":cnfile<cr>", { desc = "Quickfix: Next file" }) -- FIXME: will be default in v0.11

-- Git
k("<leader>hh", ":vertical Git<cr>", { desc = "Git: Status" })

-- Don't store empty lines in register.
-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
k("dd", function()
	return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

-- Keep same logic from y/c/d on v for selection
k("V", "v$") -- Select until end of line
k("vv", "V") -- Enter visual linewise mode

-- Miscellaneous
k("<c-\\>", ":terminal<cr>", { desc = "Open classic terminal", silent = true })
k("gcp", "yy:normal gcc<cr>p") -- Duplicate a line and comment out the first line.
k("J", "mzJ`z:delmarks z<cr>", { silent = true }) -- Keep cursor in place when joining lines
k("<leader>w", ":silent! write<cr>", { silent = true, desc = "Save file" }) -- Save changes
k("zk", "zk%^") -- Jump to start of previous fold.

k("<cr>", "<c-]>", { desc = "LSP: Jump to definition" })
-- k("<bs>", "<c-T>", { desc = "", unique = false, silent = false })
