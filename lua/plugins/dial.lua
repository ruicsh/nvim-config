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
				augend.constant.new({
					-- Tailwind CSS font-stretch classes
					elements = {
						"font-stretch-ultra-condensed",
						"font-stretch-extra-condensed",
						"font-stretch-condensed",
						"font-stretch-semi-condensed",
						"font-stretch-normal",
						"font-stretch-semi-expanded",
						"font-stretch-expanded",
						"font-stretch-extra-expanded",
						"font-stretch-ultra-expanded",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS font-weight classes
						"font-thin",
						"font-extralight",
						"font-light",
						"font-normal",
						"font-medium",
						"font-semibold",
						"font-bold",
						"font-extrabold",
						"font-black",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS justify-content classes
						"justify-start",
						"justify-end",
						"justify-center",
						"justify-between",
						"justify-around",
						"justify-evenly",
						"justify-stretch",
						"justify-baseline",
						"justify-normal",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS line-height classes
						"leading-none",
						"leading-tight",
						"leading-snug",
						"leading-normal",
						"leading-relaxed",
						"leading-loose",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS align-items classes
						"items-start",
						"items-end",
						"items-center",
						"items-baseline",
						"items-stretch",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS position classes
						"static",
						"fixed",
						"absolute",
						"relative",
						"sticky",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS border-radius classes
						"rounded-none",
						"rounded-xs",
						"rounded-sm",
						"rounded-md",
						"rounded-lg",
						"rounded-xl",
						"rounded-2xl",
						"rounded-3xl",
						"rounded-4xl",
						"rounded-full",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS box-shadow classes
						"shadow-none",
						"shadow-2xs",
						"shadow-xs",
						"shadow-sm",
						"shadow-md",
						"shadow-lg",
						"shadow-xl",
						"shadow-2xl",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS font-size classes
						"text-xs",
						"text-sm",
						"text-base",
						"text-lg",
						"text-xl",
						"text-2xl",
						"text-3xl",
						"text-4xl",
						"text-5xl",
						"text-6xl",
						"text-7xl",
						"text-8xl",
						"text-9xl",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS text-align classes
						"text-left",
						"text-center",
						"text-right",
						"text-justify",
						"text-start",
						"text-end",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS text-wrap classes
						"text-wrap",
						"text-nowrap",
						"text-balance",
						"text-pretty",
					},
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						-- Tailwind CSS letter-spacing classes
						"tracking-tighter",
						"tracking-tight",
						"tracking-normal",
						"tracking-wide",
						"tracking-wider",
						"tracking-widest",
					},
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
