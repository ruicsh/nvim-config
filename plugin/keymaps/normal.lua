local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation
k("H", "0^", { desc = "Jump to first character on line" })
k("L", "$", { desc = "Jump to end of line" })
k("{", ":keepjumps normal!6k<cr>", { desc = "Jump up 6 lines" })
k("}", ":keepjumps normal!6j<cr>", { desc = "Jump down 6 lines" })
-- Don't include small jumps on jumplist.
k("k", "(v:count > 10 ? \"m'\" .. v:count : '') .. 'k'", { expr = true })
k("j", "(v:count > 10 ? \"m'\" .. v:count : '') .. 'j'", { expr = true })

-- Editing
k("[<space>", ":call append(line('.') - 1, repeat([''], v:count1))<cr>", { desc = "Put empty line above" })
k("]<space>", ":call append(line('.'),     repeat([''], v:count1))<cr>", { desc = "Put empty line below" })
k("[p", ":pu!<cr>==", { desc = "Paste on new line above" })
k("]p", ":pu<cr>==", { desc = "Paste on new line below" })
k("U", "<C-r>", { desc = "Redo" })

-- Sort
k("<leader>s'", "vi'<esc>:Sort<cr>", { desc = "[S]ort: Inside [']" })
k("<leader>s(", "vi(<esc>:Sort<cr>", { desc = "[S]ort: Inside [(]" })
k("<leader>s[", "vi[<esc>:Sort<cr>", { desc = "[S]ort: Inside [[]" })
k("<leader>s{", "vi{<esc>:Sort<cr>", { desc = "[S]ort: Inside [{]" })
k("<leader>s}", "V}k<esc>:Sort<cr>}", { desc = "[S]ort: Paragrah" })
k('<leader>s"', 'vi"<esc>:Sort<cr>', { desc = '[So]rt: Inside ["]' })

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
k("<leader>td", ":tabclose<cr>", { desc = "Tabs: Close" })
k("<leader>tn", ":tabnew<cr>", { desc = "Tabs: New" })
k("<leader>to", ":tabonly<cr>", { desc = "Tabs: Close all other" })
k("<leader>tH", ":-tabmove<cr>", { desc = "Tabs: Move current tab to before" })
k("<leader>tL", ":+tabmove<cr>", { desc = "Tabs: Move current tab to after" })

-- Quickfix
k("[<c-q>", ":cpfile<cr>", { desc = "Quickfix: Previous file" })
k("]<c-q>", ":cnfile<cr>", { desc = "Quickfix: Next file" })
k("<leader>qc", ":OpenChangesInQuickfix<cr>", { desc = "Quickfix: open changes list" })
k("<leader>qj", ":OpenJumpsInQuickfix<cr>", { desc = "Quickfix: open jumps list" })

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
k("<c-\\>", ":terminal<cr>", { desc = "Open classic terminal" }) -- Instead of using ToggleTerm.
k("yc", "yy:normal gcc<cr>p") -- Duplicate a line and comment out the first line.
k("J", "mzJ`z:delmarks z<cr>", { silent = true }) -- Keep cursor in place when joining lines
k("<leader>w", ":silent! write<cr>", { silent = true, desc = "Save file" }) -- Save changes
k("zk", "zk%^") -- Jump to start of previous fold.
