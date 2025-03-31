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
	if vim.g.vscode then
		return true
	end

	if vim.tbl_contains(IGNORE_FILETYPES, vim.bo.ft) or vim.bo.buftype ~= "" or not vim.bo.modifiable then
		return true
	end

	return false
end

-- Command to delete the saved view file
vim.api.nvim_create_user_command("ResetView", function()
	-- Get the correct view directory from Neovim's viewdir option
	-- '~=+dotfiles=+.config=+nvim=+plugin=+autocmds=+save-load-folds.lua='
	local view_dir = vim.fn.fnamemodify(vim.o.viewdir, ":p"):gsub("/$", "")
	local current_file = vim.fn.expand("%:p:~"):gsub("/", "=+")
	local view_file = view_dir .. current_file .. "="

	-- Remove existing view file if it exists
	if vim.fn.filereadable(view_file) == 1 then
		vim.fn.delete(view_file)
	end

	-- Reset all fold settings to default
	local o = vim.opt
	o.foldenable = true
	o.foldcolumn = "1"
	o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	o.foldlevel = 0
	o.foldlevelstart = 0
	o.foldmethod = "expr"
	o.foldopen = ""
	o.foldtext = "v:lua.custom_fold_text()"

	-- Create a new view
	vim.cmd("mkview")
end, {})

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
