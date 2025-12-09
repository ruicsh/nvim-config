-- Quickfix list.
-- https://github.com/folke/trouble.nvim/

return {
	"folke/trouble.nvim",
	keys = function()
		local mappings = {
			{ "<leader>cc", "<cmd>Trouble snacks toggle<cr>", "Toggle" },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Quickfix")
	end,
	opts = {
		focus = true,
		modes = {
			snacks = {
				mode = "snacks",
				preview = {
					type = "float",
					relative = "editor",
					border = "rounded",
					size = { width = 1, height = 25 },
					zindex = 200,
				},
			},
		},
		preview = {
			wo = {
				number = true,
				foldcolumn = "0",
				signcolumn = "yes",
			},
		},
	},
	specs = {
		"folke/snacks.nvim",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts or {}, {
				picker = {
					actions = require("trouble.sources.snacks").actions,
				},
			})
		end,
	},

	cmd = "Trouble",
}
