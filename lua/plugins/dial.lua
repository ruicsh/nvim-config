--Enhanced increment/decrement
-- https://github.com/monaqa/dial.nvim

return {
	"monaqa/dial.nvim",
	keys = function()
		local mappings = {
			{ "<c-a>", "<Plug>(dial-increment)", "Increment", { mode = { "n", "v" } } },
			{ "<c-x>", "<Plug>(dial-decrement)", "Decrement", { mode = { "n", "v" } } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Dial")
	end,
	config = function()
		local augend = require("dial.augend")

		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
				augend.date.alias["%Y/%m/%d"],
				augend.constant.alias.bool,
				augend.semver.alias.semver,
				augend.constant.new({ elements = { "let", "const" } }),
			},
		})
	end,
}
