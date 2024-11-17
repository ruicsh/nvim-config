local k = vim.keymap.set

-- Save changes
k("n", "<leader>w", "<cmd>silent! write<cr>", { desc = "Save file" })
k({ "s", "i", "n", "v" }, "<c-s>", "<esc>:w<cr>", { desc = "Exit insert mode and save changes." })

-- Editing
k("n", "Y", "y$", { desc = "[Y]ank to end of line" })
k("n", "[<space>", "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>", { desc = "Put empty line above" })
k("n", "]<space>", "<cmd>call append(line('.'),     repeat([''], v:count1))<cr>", { desc = "Put empty line below" })
k("n", "[p", "<cmd>pu!<cr>==", { desc = "Paste on new line above" })
k("n", "]p", "<cmd>pu<cr>==", { desc = "Paste on new line below" })
k("n", "U", "<C-r>", { desc = "Redo" })

-- Tabs
k("n", "<leader>ta", "<cmd>$tabnew<cr>", { desc = "Tabs: New" })
k("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Tabs: Close" })
k("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Tabs: Close all other" })
k("n", "<leader>tn", "<cmd>tabn<cr>", { desc = "Tabs: Jump to previous" })
k("n", "<leader>tp", "<cmd>tabp<cr>", { desc = "Tabs: Jump to next" })
k("n", "<leader>tmp", "<cmd>-tabmove<cr>", { desc = "Tabs: Move current tab to before" })
k("n", "<leader>tmn", "<cmd>+tabmove<cr>", { desc = "Tabs: Move current tab to after" })

-- Buffers
k("n", "[b", "<cmd>bprev<cr>", { desc = "Buffers: Go to previous" })
k("n", "]b", "<cmd>bnext<cr>", { desc = "Buffers: Go to next" })
k("n", "<bs>", "<c-^>", { desc = "Buffers: Go to previous visited" })
k("n", "<s-bs>", "<c-^>", { desc = "Buffers: Go to previous visited" }) -- for compatibility with vscode
k("n", "<leader>bC", "<cmd>bufdo Bdelete<cr>", { desc = "Buffers: Close all" })
k("n", "<leader>bc", "<cmd>Bdelete<cr>", { desc = "Buffers: Close" })
k("n", "<leader>bo", "<cmd>bufdo bd<cr>", { desc = "Buffers: Close all other" })
k("n", "<leader>bx", "<cmd>Bdelete!<cr>", { desc = "Buffers: Exit" })

-- Git
k("n", "<leader>hh", "<cmd>vertical Git<cr>", { desc = "Git: Status" })

-- LSP - TypeScript
k("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", { desc = "[T]ypeScript: [o]rganize imports" })
k("n", "<leader>ts", "<cmd>TSToolsSortImports<cr>", { desc = "[T]ypeScript: [s]ort imports" })
k("n", "<leader>tu", "<cmd>TSToolsRemoveUnusedImports<cr>", { desc = "[T]ypeScript: Remove [u]nused imports" })
k("n", "<leader>td", "<cmd>TSToolsGoToSourceDefinition<cr>", { desc = "[T]ypeScript: Go to source [d]efinition" })
k("n", "<leader>tr", "<cmd>TSToolsRenameFile<cr>", { desc = "[T]ypeScript: [r]ename [f]ile" })

-- Sort
k("n", "<leader>s'", "vi'<esc><cmd>Sort<cr>", { desc = "[S]ort: Inside [']" })
k("n", "<leader>s(", "vi(<esc><cmd>Sort<cr>", { desc = "[S]ort: Inside [(]" })
k("n", "<leader>s[", "vi[<esc><cmd>Sort<cr>", { desc = "[S]ort: Inside [[]" })
k("n", "<leader>s{", "vi{<esc><cmd>Sort<cr>", { desc = "[S]ort: Inside [{]" })
k("n", "<leader>s}", "V}k<esc><cmd>Sort<cr>}", { desc = "[S]ort: Paragrah" })
k("n", '<leader>s"', 'vi"<esc><cmd>Sort<cr>', { desc = '[So]rt: Inside ["]' })

-- Center screen when moving
k("n", "<c-b>", "<c-b>zz")
k("n", "<c-d>", "<c-d>zz")
k("n", "<c-f>", "<c-f>zz")
k("n", "<c-u>", "<c-u>zz")
k("n", "<c-d>", "<c-d>zz")
k("n", "<c-i>", "<c-i>zz")
k("n", "<c-o>", "<c-o>zz")
k("n", "N", "Nzz")
k("n", "n", "nzz")
k("n", "G", "Gzz")
k("n", "gg", "ggzz")
k("n", "gd", "gdzz")
k("n", "%", "%zz")
k("n", "*", "*zz")
k("n", "#", "#zz")

-- Don't include small jumps.
k("n", "{", "<cmd>keepj normal!{zz<cr>")
k("n", "}", "<cmd>keepj normal!}zz<cr>")
k("n", "k", "(v:count > 5 ? \"m'\" .. v:count : '') .. 'k'", { expr = true, noremap = true })
k("n", "j", "(v:count > 5 ? \"m'\" .. v:count : '') .. 'j'", { expr = true, noremap = true })

-- Splits
k("n", "|", "<c-w>w", { desc = "Splits: Switch" })
k("n", "<c-w>v", "<cmd>SmartVerticalSplit<cr>", { desc = "Splits: Open vertical" })
k("n", "<c-w>|", "<cmd>SmartVerticalSplit<cr>", { desc = "Splits: Open vertical" })
k("n", "<c-w>[", "<c-w>x<c-w>w", { desc = "Splits: Move file to the left" })
k("n", "<c-w>]", "<c-w>x<c-w>w", { desc = "Splits: Move file to the right" })

-- Don't place on register when deleting/changing.
k("n", "C", '"_C')
k("n", "c", '"_c')
k("n", "cc", '"_cc')
k("n", "x", '"_x')
k("n", "X", '"_X')

-- Folds
k("n", "zk", "zk%^") -- Jump to start of previous fold.

-- This remap also removes the default behavior of going down a line with <cr>.
k("n", "<cr>", "<cmd>noh<cr>", { silent = true }) -- Remove search highlighting.
k("n", "J", "mzJ`z") -- Keep cursor in place when joining lines.
k("n", "<c-\\>", "<cmd>terminal<cr>", { desc = "Open classic terminal" }) -- Instead of using ToggleTerm.
