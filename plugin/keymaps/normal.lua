local k = vim.keymap.set

-- Navigation
k("n", "H", "0^", { desc = "Jump to first character on line" })
k("n", "L", "$", { desc = "Jump to end of line" })
k("n", "{", ":keepjumps normal!6k<cr>", { desc = "Jump up 6 lines" })
k("n", "}", ":keepjumps normal!6j<cr>", { desc = "Jump down 6 lines" })
-- Don't include small jumps on jumplist.
k("n", "k", "(v:count > 10 ? \"m'\" .. v:count : '') .. 'k'", { expr = true })
k("n", "j", "(v:count > 10 ? \"m'\" .. v:count : '') .. 'j'", { expr = true })

-- Editing
k("n", "[<space>", ":call append(line('.') - 1, repeat([''], v:count1))<cr>", { desc = "Put empty line above" })
k("n", "]<space>", ":call append(line('.'),     repeat([''], v:count1))<cr>", { desc = "Put empty line below" })
k("n", "[p", ":pu!<cr>==", { desc = "Paste on new line above" })
k("n", "]p", ":pu<cr>==", { desc = "Paste on new line below" })
k("n", "U", "<C-r>", { desc = "Redo" })

-- Sort
k("n", "<leader>s'", "vi'<esc>:Sort<cr>", { desc = "[S]ort: Inside [']" })
k("n", "<leader>s(", "vi(<esc>:Sort<cr>", { desc = "[S]ort: Inside [(]" })
k("n", "<leader>s[", "vi[<esc>:Sort<cr>", { desc = "[S]ort: Inside [[]" })
k("n", "<leader>s{", "vi{<esc>:Sort<cr>", { desc = "[S]ort: Inside [{]" })
k("n", "<leader>s}", "V}k<esc>:Sort<cr>}", { desc = "[S]ort: Paragrah" })
k("n", '<leader>s"', 'vi"<esc>:Sort<cr>', { desc = '[So]rt: Inside ["]' })

-- Don't place on register when deleting/changing.
k("n", "C", '"_C')
k("n", "c", '"_c')
k("n", "cc", '"_cc')
k("n", "x", '"_x')
k("n", "X", '"_X')

-- Buffers
k("n", "<bs>", "<c-^>", { desc = "Buffers: Go to previous visited" })
local bufdelete = require("snacks.bufdelete")
k("n", "<leader>bC", bufdelete.all, { desc = "Buffers: Close all" })
k("n", "<leader>bo", bufdelete.other, { desc = "Buffers: Close all other" })
k("n", "<tab>", ":bnext<cr>", { desc = "Buffers: Next" })
k("n", "<s-tab>", ":bprev<cr>", { desc = "Buffers: Previous" })

-- Windows
k("n", "|", "<c-w>w", { desc = "Windows: Switch" })
k("n", "<c-w>|", "<c-w>v", { desc = "Windows: Split vertically" })
k("n", "<c-w>[", "<c-w>x<c-w>w", { desc = "Windows: Move file to the left" })
k("n", "<c-w>]", "<c-w>x<c-w>w", { desc = "Windows: Move file to the right" })

-- Tabs
k("n", "<leader>td", ":tabclose<cr>", { desc = "Tabs: Close" })
k("n", "<leader>tn", ":tabnew<cr>", { desc = "Tabs: New" })
k("n", "<leader>to", ":tabonly<cr>", { desc = "Tabs: Close all other" })
k("n", "<leader>tH", ":-tabmove<cr>", { desc = "Tabs: Move current tab to before" })
k("n", "<leader>tL", ":+tabmove<cr>", { desc = "Tabs: Move current tab to after" })

-- Quickfix
k("n", "[<c-q>", ":cpfile<cr>", { desc = "Quickfix: Previous file" })
k("n", "]<c-q>", ":cnfile<cr>", { desc = "Quickfix: Next file" })
k("n", "<leader>qc", ":OpenChangesInQuickfix<cr>", { desc = "Quickfix: open changes list" })
k("n", "<leader>qj", ":OpenJumpsInQuickfix<cr>", { desc = "Quickfix: open jumps list" })

-- Git
k("n", "<leader>hh", ":vertical Git<cr>", { desc = "Git: Status" })

-- Don't store empty lines in register.
-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
k("n", "dd", function()
	return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

-- Keep same logic from y/c/d on v for selection
k("n", "V", "v$") -- Select until end of line
k("n", "vv", "V") -- Enter visual linewise mode

-- Miscellaneous
k("n", "<c-\\>", ":terminal<cr>", { desc = "Open classic terminal" }) -- Instead of using ToggleTerm.
k("n", "yc", "yy:normal gcc<cr>p") -- Duplicate a line and comment out the first line.
k("n", "J", "mzJ`z:delmarks z<cr>", { silent = true }) -- Keep cursor in place when joining lines
k("n", "<leader>w", ":silent! write<cr>", { silent = true, desc = "Save file" }) -- Save changes
k("n", "zk", "zk%^") -- Jump to start of previous fold.
