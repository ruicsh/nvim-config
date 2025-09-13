-- Sort lines, selections, or text objects
-- https://github.com/sQVe/sort.nvim

return {
	"sQVe/sort.nvim",
	keys = function()
		local mappings = {
			{ "<leader>ss", "<leader>s<leader>s", "Line", { remap = true } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Sort")
	end,
	opts = {
		mappings = {
			operator = "<leader>s",
			textobject = false,
			motion = false,
		},
	},
}
