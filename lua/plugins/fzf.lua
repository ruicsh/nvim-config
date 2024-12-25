-- Fuzzy finder
-- https://github.com/ibhagwan/fzf-lua

return {
	"ibhagwan/fzf-lua",
	keys = function()
		local fzf = require("fzf-lua")
		local mappings = {
			{ "<leader><leader>", fzf.files, "Find files" },
			{ "<leader>f", fzf.live_grep, "Search in workspace" },
			{ "<leader>.", fzf.resume, "Last search" },
			{ "<leader>nh", fzf.helptags, "Neovim: help" },
			{ "<leader>nc", fzf.commands, "Neovim: commands" },
			{ "<leader>hf", fzf.git_status, "Git: list files" },
		}
		return vim.fn.getlazykeysconf(mappings, "FZF")
	end,
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({ "telescope" })
	end,

	event = { "VeryLazy" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}
