vim.opt_local.wrap = false
vim.opt_local.buflisted = false
vim.opt_local.cursorline = true

-- Jump to the first entry
vim.cmd("normal ]/")

local function k(mode, lhs, rhs, opts)
	local options = vim.tbl_extend("force", { buffer = 0 }, opts or {})
	vim.keymap.set(mode, lhs, rhs, options)
end

k("n", "<leader>hp", "<cmd>Git push<cr>", { desc = "push" })
k("n", "<leader>hP", "<cmd>Git push --force-with-lease<cr>", { desc = "push --force-with-lease" })
k("n", "<leader>hu", "<cmd>Git push -u origin HEAD<cr>", { desc = "push -u origin HEAD" })

k("n", "<tab>", "=", { desc = "Toggle section", remap = true })
k("n", "q", function()
	require("snacks.bufdelete").delete()
end, { desc = "Close" })

-- Commit in new vertical split
k("n", "cc", function()
	vim.cmd("only")
	vim.cmd("vertical Git commit")
end, { desc = "Commit in new tab" })

-- Open the file under the cursor in the current window, replacing the status
-- buffer. Fugitive's own `:Gedit` "blurs" status windows (keeps them and edits
-- in another window), but its <CR> mapping is also what knows which line of the
-- diff the cursor is on, so reuse it with the blur behaviour suppressed.
local fugitive_cr = vim.fn.maparg("<CR>", "n", false, true)

local set_open_mapping
local function open_under_cursor()
	local buf = vim.api.nvim_get_current_buf()
	local fugitive_type = vim.b.fugitive_type

	if not next(fugitive_cr) then
		return
	end

	vim.b.fugitive_type = nil
	vim.keymap.del("n", "<CR>", { buffer = buf })
	vim.fn.mapset("n", false, fugitive_cr)
	pcall(vim.api.nvim_feedkeys, "\r", "x", false)

	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.b[buf].fugitive_type = fugitive_type

	-- Restore our mappings on the status buffer in case it is visited again
	set_open_mapping(buf)
end

set_open_mapping = function(buf)
	k("n", "<CR>", open_under_cursor, { buffer = buf or 0, desc = "Open file at cursor line" })
	k("n", "gf", open_under_cursor, { buffer = buf or 0, desc = "Open file at cursor line" })
end
set_open_mapping()

k("n", "<c-n>", "]/", { desc = "Next file/section", remap = true })
k("n", "<c-p>", "[/", { desc = "Previous file/section", remap = true })
