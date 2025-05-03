-- Enhanced increment/decrement
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
				augend.constant.alias.Alpha, -- [A-Z]
				augend.constant.alias.alpha, -- [a-z]
				augend.constant.alias.bool, -- true/false
				augend.constant.new({ -- yes/no
					elements = { "yes", "no" },
					word = true,
					cyclic = true,
				}),

				augend.date.alias["%H:%M"], -- 23:59
				augend.date.new({ -- 2023-10-01
					pattern = "%Y-%m-%d",
					default_kind = "day",
					only_valid = true,
				}),

				augend.integer.alias.decimal, -- 1234

				augend.semver.alias.semver, -- 1.2.3
			},
		})
	end,
}
