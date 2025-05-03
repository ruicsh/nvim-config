-- Bookmarks
-- https://github.com/cbochs/grapple.nvim

return {
	"cbochs/grapple.nvim",
	keys = function()
		local mappings = {
			{ "<leader>m", ":Grapple toggle<cr>", "Toggle" },
			{ "<leader>'", ":Grapple toggle_tags<cr>", "List" },
			{ "'1", "<cmd>Grapple select index=1<cr>", "Select #1" },
			{ "'2", "<cmd>Grapple select index=2<cr>", "Select #2" },
			{ "'3", "<cmd>Grapple select index=3<cr>", "Select #3" },
			{ "'4", "<cmd>Grapple select index=4<cr>", "Select #4" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Grapple")
	end,
	opts = {
		scope = "git_branch",
		icons = true,
		quick_select = "123456789",
	},

	cmd = "Grapple",
	event = { "BufReadPost", "BufNewFile" },
}
