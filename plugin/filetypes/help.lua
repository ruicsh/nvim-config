-- Help files.

local augroup = vim.api.nvim_create_augroup("ruicsh/filetypes/help", { clear = true })

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
