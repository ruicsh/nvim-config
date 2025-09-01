-- Surround actions.
-- https://github.com/nvim-mini/mini.surround

return {
	"nvim-mini/mini.surround",
	opts = {
		mappings = {
			add = "Sa",
			delete = "Sd",
			find = "",
			find_left = "",
			highlight = "",
			replace = "Sr",
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
		search_method = "cover_or_next",
	},
	config = function(_, opts)
		vim.keymap.set("n", "S", "<nop>") -- Disable `S` to avoid conflicts

		require("mini.surround").setup(opts)

		-- `:h MiniSurround-vim-surround-config`
		vim.keymap.del("x", "Sa")
		vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
	end,
}
