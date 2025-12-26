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

		return {
			{ "<c-a>", map("increment", "normal"), desc = "Dial: Increment" },
			{ "<c-x>", map("decrement", "normal"), desc = "Dial: Decrement" },
			{ "g<c-a>", map("increment", "gnormal"), desc = "Dial: Increment" },
			{ "g<c-x>", map("decrement", "gnormal"), desc = "Dial: Decrement" },
			{ "<c-a>", map("increment", "visual"), desc = "Dial: Increment", mode = "x" },
			{ "<c-x>", map("decrement", "visual"), desc = "Dial: Decrement", mode = "x" },
			{ "g<c-a>", map("increment", "gvisual"), desc = "Dial: Increment", mode = "x" },
			{ "g<c-x>", map("decrement", "gvisual"), desc = "Dial: Decrement", mode = "x" },
		}
	end,

	config = function()
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			default = {
				augend.constant.alias.alpha,
				augend.constant.alias.Alpha,
				augend.constant.new({
					elements = { "false", "true" },
					cyclic = true,
					preserve_case = true,
				}),
				augend.constant.new({
					elements = { "no", "yes" },
					cyclic = true,
					preserve_case = true,
				}),
				augend.constant.new({
					elements = { "off", "on" },
					cyclic = true,
					preserve_case = true,
				}),
				augend.constant.new({
					elements = { "!==", "===" },
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "!=", "==" },
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "and", "or" },
					word = true,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "&&", "||" },
					word = false,
					cyclic = true,
				}),
				augend.date.alias["%Y/%m/%d"],
				augend.date.alias["%m/%d/%Y"],
				augend.date.alias["%d/%m/%Y"],
				augend.date.alias["%m/%d/%y"],
				augend.date.alias["%m/%d"],
				augend.date.alias["%Y-%m-%d"],
				augend.date.alias["%H:%M:%S"],
				augend.date.alias["%H:%M"],
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
				augend.semver.alias.semver,
			},
		})
	end,
}
