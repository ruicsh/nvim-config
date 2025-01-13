-- Fuzzy finder
-- https://github.com/ibhagwan/fzf-lua

return {
	"ibhagwan/fzf-lua",
	keys = function()
		local fzf = require("fzf-lua")
		local mappings = {
			{ "<leader><leader>", fzf.files, "Find files" },
			{ "<leader>f", fzf.live_grep, "Search in workspace" },
			{ "<leader>.", fzf.resume, "FZF: Last search" },
			{ "<leader>nh", fzf.helptags, "Search: Help" },
			{ "<leader>nc", fzf.commands, "Search: Commands" },
			{ "<leader>nk", fzf.keymaps, "Search: Keymaps" },
			{ "<leader>hf", fzf.git_status, "Git: Files" },
		}
		return vim.fn.getlazykeysconf(mappings)
	end,
	opts = {
		"telescope",
		winopts = {
			-- https://github.com/ibhagwan/fzf-lua/issues/808#issuecomment-1620961060
			on_create = function()
				vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true, buffer = true })
			end,
		},
	},

	event = { "VeryLazy" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}
