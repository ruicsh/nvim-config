-- Save and restore views for each buffer

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/views", { clear = true })

local IGNORE_FILETYPES = {
	"DiffviewFileHistory",
	"DiffviewFiles",
	"copilot-chat",
	"diff",
	"fugitive",
	"gitcommit",
	"gitrebase",
	"help",
	"neo-tree",
	"oil",
	"qf",
	"svg",
}

--- Some files have special folding rules
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	pattern = "*/plugin/options.lua",
	callback = function()
		vim.opt_local.foldmethod = "marker" -- use {{{-}}} to create folds
	end,
})

-- Save view when leaving buffer
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
	group = augroup,
	callback = function(args)
		if vim.b[args.buf].view_activated then
			vim.cmd.mkview({ mods = { emsg_silent = true } })
		end
	end,
})

-- Load view if available and enable view saving for real files
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup,
	callback = function(args)
		if not vim.b[args.buf].view_activated then
			local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
			local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

			if vim.tbl_contains(IGNORE_FILETYPES, filetype) then
				return
			end

			if buftype == "" and filetype and filetype ~= "" then
				vim.b[args.buf].view_activated = true
				vim.cmd.loadview({ mods = { emsg_silent = true } })
			end
		end
	end,
})
