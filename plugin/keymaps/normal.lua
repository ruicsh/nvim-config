local function k(lhs, rhs, opts)
	local options = vim.tbl_extend("force", { noremap = true, unique = true }, opts or {})
	vim.keymap.set("n", lhs, rhs, options)
end

-- Navigation
k("{", ":keepjumps normal!6k<cr>", { desc = "Jump up 6 lines", silent = true })
k("}", ":keepjumps normal!6j<cr>", { desc = "Jump down 6 lines", silent = true })

-- Editing
k("[p", ":pu!<cr>==", { desc = "Paste on new line above" })
k("]p", ":pu<cr>==", { desc = "Paste on new line below" })
k("U", "<C-r>", { desc = "Redo" })
k("<leader>w", vim.cmd.write, { desc = "Save file", silent = true }) -- Save changes
k("J", "mzJ`z:delmarks z<cr>") -- Keep cursor in place when joining lines
k("ycc", "yygccp", { remap = true }) -- Duplicate a line and comment out the first line.

-- Move lines
k("]e", ":m .+1<cr>==", { desc = "Move line down" })
k("[e", ":m .-2<cr>==", { desc = "Move line up" })

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

-- Keep same logic from y/c/d on v for selection
k("V", "v$") -- Select until end of line
k("vv", "V") -- Enter visual linewise mode

k("<leader>yf", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	vim.fn.setreg("+", path)
end, { desc = "Copy relative file path" })

k("<leader>yd", function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":~:.")
	vim.fn.setreg("+", path)
end, { desc = "Copy directory path" })

---
-- Stop setting keymaps incompatible with vscode
---
if vim.g.vscode then
	return
end

-- Folds
k("[z", "zm", { desc = "Folds: More" })
k("]z", "zr", { desc = "Folds: Reduce" })
k(vim.fn.is_windows() and "<c-Z>" or "<c-s-z>", ":ResetView<cr>", { desc = "Folds: Reset saved view" })

local function toggle_fold()
	local linenr = vim.fn.line(".")
	-- If there's no fold to be opened/closed, do nothing.
	if vim.fn.foldlevel(linenr) == 0 then
		return
	end

	-- Open if closed, close if open.
	local cmd = vim.fn.foldclosed(linenr) == -1 and "zc" or "zO"
	vim.cmd("normal! " .. cmd)
end
k("<tab>", toggle_fold, { noremap = true, silent = true, desc = "Folds: Toggle" })

local function toggle_fold_one_level()
	local linenr = vim.fn.line(".")
	local current_fold_level = vim.fn.foldlevel(linenr)
	-- If there's no fold to be opened/closed, do nothing.
	if current_fold_level == 0 then
		return
	end

	-- Open fold if closed (1 level only).
	local is_open = vim.fn.foldclosed(linenr) == -1
	if not is_open then
		vim.cmd("normal! zo")
		return
	end

	-- Close all direct children folds.
	local next_line = linenr + 1
	while next_line <= vim.fn.line("$") do
		local next_foldlevel = vim.fn.foldlevel(next_line)

		if next_foldlevel < current_fold_level then
			return
		elseif next_foldlevel > current_fold_level and vim.fn.foldclosed(next_line) == -1 then
			vim.cmd(next_line .. "," .. next_line .. "foldclose")
			next_line = vim.fn.foldclosedend(next_line) + 1
		else
			next_line = next_line + 1
		end
	end
end
k("<s-tab>", toggle_fold_one_level, { noremap = true, silent = true, desc = "Folds: Toggle (one foldlevel)" })

-- Buffers
k("<bs>", ":JumpToLastVisitedBuffer<cr>", { desc = "Toggle to last buffer" })
local bufdelete = require("snacks.bufdelete")
k("<leader>bC", bufdelete.all, { desc = "Buffers: Close all" })
k("<leader>bo", bufdelete.other, { desc = "Buffers: Close all other" })

-- Windows
k("|", "<c-w>w", { desc = "Windows: Switch" })
k("<c-w>[", ":SendBufferToWindow h<cr>", { desc = "Windows: Send to left window" })
k("<c-w>]", ":SendBufferToWindow l<cr>", { desc = "Windows: Send to right window" })

-- Tabs
k("<leader>tc", vim.cmd.tabclose, { desc = "Tabs: Close", silent = true })
k("<leader>tn", vim.cmd.tabnew, { desc = "Tabs: New", silent = true })

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
