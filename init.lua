vim.loader.enable()

vim.cmd("colorscheme nordstone")

-- Leader key
-- needs to be set before lazy.nvim
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode(",")

-- Load lazy package manager.
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	change_detection = {
		enabled = false,
		notify = false,
	},
	install = { colorscheme = { "nordstone" } },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tar",
				"tarPlugin",
				"zip",
				"zipPlugin",
				"netrwPlugin",
			},
		},
	},
	ui = {
		border = "rounded",
	},
})
