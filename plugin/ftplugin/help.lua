-- Help files.

local augroup = vim.api.nvim_create_augroup("ruicsh/ft/help", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
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
		k("n", "<bs>", "<c-T>", opts)
	end,
})

-- Open help on a vertical split.
vim.api.nvim_create_autocmd("CmdLineLeave", {
	group = augroup,
	pattern = ":",
	callback = function()
		local cmd = vim.fn.getcmdline()
		if cmd:match("^help%s") or cmd:match("^h%s") or cmd == "h" or cmd == "help" then
			vim.cmd("only")
		end
	end,
})
