-- Fuzzy finder
-- https://github.com/ibhagwan/fzf-lua

return {
	"ibhagwan/fzf-lua",
	keys = function()
		local fzf = require("fzf-lua")

		return {
			{ "<leader><leader>", fzf.files, { desc = "Find files" } },
			{ "<leader>f", fzf.live_grep, { desc = "Search in workspace" } },
			{ "<leader>.", fzf.resume, { desc = "Last search" } },
			{ "<leader>nh", fzf.helptags, { desc = "Neovim: help" } },
			{ "<leader>nc", fzf.commands, { desc = "Neovim: commands" } },
			{ "<leader>hf", fzf.git_status, { desc = "Git: list files" } },
		}
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
