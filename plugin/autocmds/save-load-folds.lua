-- Save and restore views for each buffer
-- https://github.com/chrisgrieser/nvim-origami/blob/main/lua/origami/keep-folds-across-sessions.lua

local augroup = vim.api.nvim_create_augroup("ruicsh/autocmds/save-load-folds", { clear = true })

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

local function is_ignored()
	if vim.tbl_contains(IGNORE_FILETYPES, vim.bo.ft) or vim.bo.buftype ~= "" or not vim.bo.modifiable then
		return true
	end

	return false
end

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
		if is_ignored() then
			return
		end

		if vim.b[args.buf].view_activated then
			vim.cmd.mkview({ mods = { emsg_silent = true } })
		end
	end,
})

-- Load view if available and enable view saving for real files
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup,
	callback = function(args)
		if is_ignored() then
			return
		end

		if not vim.b[args.buf].view_activated then
			vim.b[args.buf].view_activated = true
			vim.cmd.loadview({ mods = { emsg_silent = true } })
		end
	end,
})
