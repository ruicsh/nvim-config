-- Tailwind CSS integration and tooling
-- https://github.com/luckasRanarison/tailwind-tools.nvim

return {
	"luckasRanarison/tailwind-tools.nvim",
	opts = {
		server = {
			override = false,
		},
		document_color = {
			enabled = false,
		},
		conceal = {
			enabled = true,
			symbol = "…",
			highlight = {
				link = "Normal",
			},
		},
	},
	config = function(_, opts)
		require("tailwind-tools").setup(opts)

		local k = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { desc = desc })
		end

		k("[s", "<cmd>TailwindPrevClass<cr>", "Tailwind: Show class")
		k("]s", "<cmd>TailwindNextClass<cr>", "Tailwind: Rename class")
	end,

	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
