-- Surround actions.
-- https://github.com/nvim-mini/mini.surround

return {
	"nvim-mini/mini.surround",
	opts = {
		mappings = {
			add = "sa",
			delete = "sd",
			find = "",
			find_left = "",
			highlight = "",
			replace = "sr",
			update_n_lines = "",
		},
		custom_surroundings = {
			c = { -- Comment
				input = { "%*%*().-()%*%*" },
				output = { left = "/*", right = "*/" },
			},
			t = { -- HTML tag
				input = { "<(%w+)>().-()</%1>" },
				output = function()
					local tag = vim.fn.input("Tag: ")
					return { left = "<" .. tag .. ">", right = "</" .. tag .. ">" }
				end,
			},
		},
	},
	config = function(_, opts)
		require("mini.surround").setup(opts)

		-- `:h MiniSurround-vim-surround-config`
		vim.keymap.del("x", "sa")
		vim.keymap.set("x", "s", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
	end,
}
