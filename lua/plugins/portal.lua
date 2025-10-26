-- Location list navigation
-- https://github.com/cbochs/portal.nvim

return {
	"cbochs/portal.nvim",
	keys = function()
		local mappings = {
			{ "[[", ":Portal jumplist backward<cr>", "Backward" },
			{ "]]", ":Portal jumplist forward<cr>", "Forward" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Portal")
	end,
	opts = {
		labels = { "a", "s", "d", "f" },
	},
}
