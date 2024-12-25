-- Spectre panel.

local group = vim.api.nvim_create_augroup("ruicsh/ft/spectre_panel", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "spectre_panel",
	callback = function(event)
		local k = vim.keymap.set
		local opts = { buffer = event.buf }

		-- When deleting the path, have it trigger a new search.
		k("n", "D", "A<c-u><esc>", opts)
	end,
})
