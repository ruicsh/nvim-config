-- Fuzzy finder
-- https://github.com/ibhagwan/fzf-lua

return {
	"ibhagwan/fzf-lua",
	keys = function()
		local fzf = require("fzf-lua")
		local mappings = {
			{ "<leader><space>", fzf.files, "Find files" },
			{ "<leader>f", fzf.live_grep, "Search in workspace" },
			{ "<leader>.", fzf.resume, "FZF: Last search" },
			{ "<leader>nh", fzf.helptags, "Search: Help" },
			{ "<leader>nc", fzf.commands, "Search: Commands" },
			{ "<leader>nk", fzf.keymaps, "Search: Keymaps" },
		}
		return vim.fn.getlazykeysconf(mappings)
	end,
	opts = {
		"telescope",
		files = {
			cwd_prompt = false,
			prompt = "Files: ",
			formatter = "path.filename_first",
		},
		fzf_colors = {
			["bg"] = { "bg", "NormalFloat" },
			["bg+"] = { "bg", "CursorLine" },
			["fg"] = { "fg", "Comment" },
			["fg+"] = { "fg", "Normal" },
			["hl"] = { "fg", "CmpItemAbbrMatch" },
			["hl+"] = { "fg", "CmpItemAbbrMatch" },
			["gutter"] = { "bg", "NormalFloat" },
			["header"] = { "fg", "NonText" },
			["info"] = { "fg", "NonText" },
			["pointer"] = { "bg", "Cursor" },
			["separator"] = { "bg", "NormalFloat" },
			["spinner"] = { "fg", "NonText" },
		},
		grep = {
			cmd = "rg -o -r '' --column --no-heading --smart-case",
			prompt = "Text: ",
		},
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
