-- Hit-enter when cmdline
-- https://www.reddit.com/r/neovim/comments/1jqk8x1/comment/ml8a9pa/

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/cmdline-hit-enter", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = augroup,
	callback = function()
		vim.opt.messagesopt = "hit-enter,history:1000"

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved" }, {
			group = augroup,
			callback = function()
				vim.opt.messagesopt = "wait:500,history:1000"
			end,
			once = true,
		})
	end,
})
