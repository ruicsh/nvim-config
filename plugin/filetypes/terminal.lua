-- Terminal buffers

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.signcolumn = "yes" -- Shows left padding on the window

		-- opencode uses <esc> to cancel actions, map it when not in a sidekick terminal
		if vim.bo.filetype ~= "sidekick_terminal" then
			vim.keymap.set("t", "<c-[>", [[<c-\><c-n>]], { desc = "Exit terminal mode", buffer = true })
		end
	end,
})
