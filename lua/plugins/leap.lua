-- Jump with search labels
-- https://github.com/ggandor/leap.nvim

return {
	"ggandor/leap.nvim",
	config = function()
		local k = function(mode, lhs, rhs, opts)
			local desc = opts.desc and "Leap: " .. opts.desc or ""
			local options = vim.tbl_extend("force", opts, { desc = desc, noremap = true, silent = true })
			vim.keymap.set(mode, lhs, rhs, options)
		end

		k("n", "s", "<Plug>(leap)", { desc = "Search" })
		k("n", "S", "<Plug>(leap-from-window)", { desc = "Search on windows" })
		k({ "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Forward" })
		k({ "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Backward" })
	end,

	dependencies = {
		"tpope/vim-repeat",
	},
}
