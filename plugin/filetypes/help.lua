-- Help files.

local group = vim.api.nvim_create_augroup("ruicsh/ft/help", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "help",
	callback = function(event)
		-- Always open help panel on a vertical split, full height.
		-- https://github.com/dmmulroy/kickstart.nix/blob/main/config/nvim/
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")

		local k = vim.keymap.set
		local opts = { buffer = event.buf }

		-- Better navigation.
		-- https://vim.fandom.com/wiki/Learn_to_use_help#Simplify_help_navigation
		k("n", "<cr>", "<c-]>", opts)
		k("n", "<bs>", "<c-T>", opts)
	end,
})
