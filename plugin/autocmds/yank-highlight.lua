-- Highlight selection when yanking
-- https://github.com/dmmulroy/kickstart.nix/blob/main/config/nvim/

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/yank-highlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 200,
			visual = true,
			priority = 250, -- With priority higher than the LSP references one.
		})
	end,
})
