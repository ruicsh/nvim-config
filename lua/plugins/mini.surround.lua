-- Surround actions.
-- https://github.com/nvim-mini/mini.surround

return {
	"nvim-mini/mini.surround",
	opts = {
		mappings = {
			add = "ys",
			delete = "ds",
			find = "",
			find_left = "",
			highlight = "",
			replace = "cs",
			update_n_lines = "",

			suffix_last = "",
			suffix_next = "",
		},
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
		vim.keymap.del("x", "ys")
		vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

		-- Make special mapping for "add surrounding for line"
		vim.keymap.set("n", "yss", "ys_", { remap = true })
	end,
}
