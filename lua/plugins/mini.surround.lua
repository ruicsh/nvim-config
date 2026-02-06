-- Surround actions.
-- https://github.com/nvim-mini/mini.surround

return {
	"nvim-mini/mini.surround",
	opts = {
		mappings = {
			add = "sa",
			delete = "sd",
			find = "sf",
			find_left = "sF",
			highlight = "sh",
			replace = "sr",

			suffix_last = "",
			suffix_next = "",
		},
		n_lines = 20,
		search_method = "cover_or_next",
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
		vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

		-- Make special mapping for "add surrounding for line"
		vim.keymap.set("n", "saa", "sa_", { remap = true })
	end,
}
