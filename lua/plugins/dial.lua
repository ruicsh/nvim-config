-- Enhanced increment/decrement.
-- https://github.com/monaqa/dial.nvim

return {
	"monaqa/dial.nvim",
	keys = function()
		local dial = require("dial.map")

		local function map(direction, mode)
			return function()
				dial.manipulate(direction, mode)
			end
		end

		local mappings = {
			{ "<c-a>", map("increment", "normal"), "Increment" },
			{ "<c-x>", map("decrement", "normal"), "Decrement" },
			{ "g<c-a>", map("increment", "gnormal"), "Increment" },
			{ "g<c-x>", map("decrement", "gnormal"), "Decrement" },
			{ "<c-a>", map("increment", "visual"), "Increment", { mode = "x" } },
			{ "<c-x>", map("decrement", "visual"), "Decrement", { mode = "x" } },
			{ "g<c-a>", map("increment", "gvisual"), "Increment", { mode = "x" } },
			{ "g<c-x>", map("decrement", "gvisual"), "Decrement", { mode = "x" } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Dial")
	end,

	config = function()
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			default = {
				augend.constant.alias.bool,
				augend.date.alias["%Y-%m-%d"],
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
				augend.semver.alias.semver,
			},
		})
	end,
}
