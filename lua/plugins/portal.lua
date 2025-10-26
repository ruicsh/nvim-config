-- Location list navigation
-- https://github.com/cbochs/portal.nvim

return {
	"cbochs/portal.nvim",
	keys = function()
		local mappings = {
			{ "<leader>[", ":Portal jumplist backward<cr>", "Backward" },
			{ "<leader>]", ":Portal jumplist forward<cr>", "Forward" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Portal")
	end,
	opts = {
		labels = { "a", "s", "d", "f" },
		window_options = {
			height = 4,
		},
	},
}
