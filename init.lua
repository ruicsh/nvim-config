vim.loader.enable()

-- colorscheme
vim.cmd.colorscheme("nordstone")

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("ruicsh.globals")

-- Load lazy package manager.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	ui = {
		border = "rounded",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"rplugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	change_detection = { notify = false },
	spec = {
		{ import = "ruicsh.plugins.buffers", cond = not vim.g.vscode },
		{ import = "ruicsh.plugins.coding", cond = not vim.g.vscode },
		{ import = "ruicsh.plugins.editor" },
		{ import = "ruicsh.plugins.explorer", cond = not vim.g.vscode },
		{ import = "ruicsh.plugins.git", cond = not vim.g.vscode },
		{ import = "ruicsh.plugins.lsp", cond = not vim.g.vscode },
		{ import = "ruicsh.plugins.markdown", cond = not vim.g.vscode },
		{ import = "ruicsh.plugins.search", cond = not vim.g.vscode },
		{ import = "ruicsh.plugins.treesitter", cond = not vim.g.vscode },
		{ import = "ruicsh.plugins.ui", cond = not vim.g.vscode },
	},
})
