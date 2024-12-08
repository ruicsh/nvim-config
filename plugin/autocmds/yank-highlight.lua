-- Highlight selection when yanking
-- https://github.com/dmmulroy/kickstart.nix/blob/main/config/nvim/

local group = vim.api.nvim_create_augroup("ruicsh/yank_highlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 200,
			visual = true,
			priority = 250, -- With priority higher than the LSP references one.
		})
	end,
})
