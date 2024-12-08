local k = vim.keymap.set

-- HJKL as amplified versions of hjkl
-- https://nanotipsforvim.prose.sh/motion-setup--hjkl-as-amplified-hjkl
k("n", "J", "<cmd>keepjumps normal!6j<cr>")
k("n", "K", "<cmd>keepjumps normal!6k<cr>")
k("n", "H", "0^")
k("n", "L", "$")

-- Don't include small jumps on jumplist.
k("n", "{", "<cmd>keepj normal!{<cr>")
k("n", "}", "<cmd>keepj normal!}<cr>")
k("n", "k", "(v:count > 10 ? \"m'\" .. v:count : '') .. 'k'", { expr = true, noremap = true })
k("n", "j", "(v:count > 10 ? \"m'\" .. v:count : '') .. 'j'", { expr = true, noremap = true })

-- Save changes
k("n", "<leader>w", "<cmd>silent! write<cr>", { desc = "Save file" })
k({ "s", "i", "n", "v" }, "<c-s>", "<esc>:w<cr>", { desc = "Exit insert mode and save changes." })

-- Editing
k("n", "[<space>", "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>", { desc = "Put empty line above" })
k("n", "]<space>", "<cmd>call append(line('.'),     repeat([''], v:count1))<cr>", { desc = "Put empty line below" })
k("n", "[p", "<cmd>pu!<cr>==", { desc = "Paste on new line above" })
k("n", "]p", "<cmd>pu<cr>==", { desc = "Paste on new line below" })
k("n", "U", "<C-r>", { desc = "Redo" })

-- Focus navigation
k("n", "<c-d>", "<c-d>zz") -- Scroll down
k("n", "<c-u>", "<c-u>zz") -- Scroll up

-- Tabs
k("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Tabs: Close" })
k("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "Tabs: New" })
k("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Tabs: Close all other" })
k("n", "<leader>tH", "<cmd>-tabmove<cr>", { desc = "Tabs: Move current tab to before" })
k("n", "<leader>tL", "<cmd>+tabmove<cr>", { desc = "Tabs: Move current tab to after" })

-- Buffers
k("n", "[b", "<cmd>bprev<cr>", { desc = "Buffers: Go to previous" })
k("n", "]b", "<cmd>bnext<cr>", { desc = "Buffers: Go to next" })
k("n", "<bs>", "<c-^>", { desc = "Buffers: Go to previous visited" })
k("n", "<s-bs>", "<c-^>", { desc = "Buffers: Go to previous visited" }) -- for compatibility with vscode
k("n", "<leader>bC", "<cmd>bufdo Bdelete<cr>", { desc = "Buffers: Close all" })
k("n", "<leader>bc", "<cmd>Bdelete<cr>", { desc = "Buffers: Close" })
k("n", "<leader>bo", "<cmd>bufdo bd<cr>", { desc = "Buffers: Close all other" })
k("n", "<leader>bx", "<cmd>Bdelete!<cr>", { desc = "Buffers: Exit" })

-- Windows
k("n", "|", "<c-w>w", { desc = "Windows: Switch" })
k("n", "<c-w>|", "<c-w>v", { desc = "Windows: Split vertically" })
k("n", "<c-w>[", "<c-w>x<c-w>w", { desc = "Windows: Move file to the left" })
k("n", "<c-w>]", "<c-w>x<c-w>w", { desc = "Windows: Move file to the right" })

-- Tabs
k("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Tabs: Close" })
k("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "Tabs: New" })
k("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Tabs: Close all other" })
k("n", "<leader>tH", "<cmd>-tabmove<cr>", { desc = "Tabs: Move current tab to before" })
k("n", "<leader>tL", "<cmd>+tabmove<cr>", { desc = "Tabs: Move current tab to after" })

-- Quickfix
k("n", "[q", "<cmd>cprev<cr>", { desc = "Quickfix: Previous" })
k("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix: Next" })
k("n", "[Q", "<cmd>cfirst<cr>", { desc = "Quickfix: First" })
k("n", "]Q", "<cmd>clast<cr>", { desc = "Quickfix: Last" })
k("n", "[<c-q>", "<cmd>cpfile<cr>", { desc = "Quickfix: Previous file" })
k("n", "]<c-q>", "<cmd>cnfile<cr>", { desc = "Quickfix: Next file" })

-- Git
k("n", "<leader>hh", "<cmd>vertical Git<cr>", { desc = "Git: Status" })

-- LSP - TypeScript
k("n", "<leader>tso", "<cmd>TSToolsOrganizeImports<cr>", { desc = "[T]ypeScript: [o]rganize imports" })
k("n", "<leader>tss", "<cmd>TSToolsSortImports<cr>", { desc = "[T]ypeScript: [s]ort imports" })
k("n", "<leader>tsu", "<cmd>TSToolsRemoveUnusedImports<cr>", { desc = "[T]ypeScript: Remove [u]nused imports" })
k("n", "<leader>tsd", "<cmd>TSToolsGoToSourceDefinition<cr>", { desc = "[T]ypeScript: Go to source [d]efinition" })
k("n", "<leader>tsr", "<cmd>TSToolsRenameFile<cr>", { desc = "[T]ypeScript: [r]ename [f]ile" })

-- Sort
k("n", "<leader>s'", "vi'<esc><cmd>Sort<cr>", { desc = "[S]ort: Inside [']" })
k("n", "<leader>s(", "vi(<esc><cmd>Sort<cr>", { desc = "[S]ort: Inside [(]" })
k("n", "<leader>s[", "vi[<esc><cmd>Sort<cr>", { desc = "[S]ort: Inside [[]" })
k("n", "<leader>s{", "vi{<esc><cmd>Sort<cr>", { desc = "[S]ort: Inside [{]" })
k("n", "<leader>s}", "V}k<esc><cmd>Sort<cr>}", { desc = "[S]ort: Paragrah" })
k("n", '<leader>s"', 'vi"<esc><cmd>Sort<cr>', { desc = '[So]rt: Inside ["]' })

-- Splits
k("n", "|", "<c-w>w", { desc = "Splits: Switch" })
k("n", "<c-w>|", "<c-w>v", { desc = "Splits: Open vertical" })
k("n", "<c-w>[", "<c-w>x<c-w>w", { desc = "Splits: Move file to the left" })
k("n", "<c-w>]", "<c-w>x<c-w>w", { desc = "Splits: Move file to the right" })

-- Don't place on register when deleting/changing.
k("n", "C", '"_C')
k("n", "c", '"_c')
k("n", "cc", '"_cc')
k("n", "x", '"_x')
k("n", "X", '"_X')

-- Don't store empty lines in register.
-- https://nanotipsforvim.prose.sh/keeping-your-register-clean-from-dd
k("n", "dd", function()
	return vim.fn.getline(".") == "" and '"_dd' or "dd"
end, { expr = true })

-- Folds
k("n", "zk", "zk%^") -- Jump to start of previous fold.

-- Switch backtick with single quote for easier access.
k("n", "''", "`'", { desc = "Position before last jump" })
k("n", "'.", "`.", { desc = "Position where last change was made" })
k("n", "'0", "`0", { desc = "Position where last exited Vim" })

-- Miscellaneous
k("n", "<esc>", "<cmd>nohl<cr><cmd>echo<cr><esc>", { silent = true }) -- Remove search highlighting and clear commandline.
k("n", "<c-\\>", "<cmd>terminal<cr>", { desc = "Open classic terminal" }) -- Instead of using ToggleTerm.
k("n", "yc", "yy<cmd>normal gcc<cr>p") -- Duplicate a line and comment out the first line.
k("n", "M", "mzJ`z") -- Keep cursor in place when joining lines
