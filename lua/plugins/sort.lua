-- Sort lines, selections, or text objects
-- https://github.com/sQVe/sort.nvim

return {
	"sQVe/sort.nvim",
	opts = {
		mappings = {
			motion = false,
			operator = "<leader>s",
			textobject = false,
		},
	},
	config = function(_, opts)
		require("sort").setup(opts)

		local mappings = {
			{ "n", "<leader>ss", "<leader>s<leader>s", "Sort Line" },
		}

		for _, map in ipairs(mappings) do
			local mode, lhs, rhs, desc = unpack(map)
			vim.keymap.set(mode, lhs, rhs, { desc = desc, remap = true })
		end
	end,
}
