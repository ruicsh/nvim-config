local T = require("lib")

vim.opt_local.foldenable = true
vim.opt_local.foldmethod = "syntax"
vim.opt_local.foldlevel = 99
vim.opt_local.wrap = true

-- Close the side panel with `q`. In a regular window, fall back to the global
-- `q` mapping (close buffer/window) by dropping this buffer-local one.
vim.keymap.set("n", "q", function()
	if T.ui.right_panel_width() > 0 then
		T.ui.close_side_panels()
		return
	end

	vim.api.nvim_buf_del_keymap(0, "n", "q")
	vim.api.nvim_feedkeys("q", "m", false) -- `m`: use the global mapping
end, { buffer = 0, desc = "Close git diff" })
