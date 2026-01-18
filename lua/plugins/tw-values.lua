-- View all applied tailwindcss values on an element
-- https://github.com/MaximilianLloyd/tw-values.nvim

return {
	"ruicsh/tw-values.nvim",
	keys = {
		{ "<leader><s-k>", "<cmd>TWValues<cr>", desc = "Tailwind: Show values" },
	},
	opts = {
		border = "rounded",
		title = "",
		show_unknown_classes = true,
		focus_preview = false,
		copy_register = "*",
		keymaps = {
			copy = "<c-y>",
		},
	},
}
