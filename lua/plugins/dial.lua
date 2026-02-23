-- Enhanced increment/decrement.
-- https://github.com/monaqa/dial.nvim

local function add_tailwind_rules(default)
	local augend = require("dial.augend")

	local colors = {}
	for _, color in ipairs({
		"amber",
		"blue",
		"cyan",
		"emerald",
		"fuchsia",
		"gray",
		"green",
		"indigo",
		"lime",
		"mauve",
		"mist",
		"neutral",
		"olive",
		"orange",
		"pink",
		"purple",
		"red",
		"rose",
		"sky",
		"slate",
		"stone",
		"taupe",
		"teal",
		"violet",
		"yellow",
		"zinc",
	}) do
		local color_group = {}
		for _, shade in ipairs({ "100", "200", "300", "400", "500", "600", "700", "800", "900", "950" }) do
			table.insert(color_group, color .. "-" .. shade)
		end
		table.insert(colors, color_group)
	end

	for _, group in ipairs(colors) do
		table.insert(
			default,
			augend.constant.new({
				elements = group,
				word = false,
				cyclic = true,
			})
		)
	end

	local align_items = {
		"items-start",
		"items-end",
		"items-center",
		"items-baseline",
		"items-stretch",
	}
	local bg_linear = {
		"bg-linear-to-t",
		"bg-linear-to-tr",
		"bg-linear-to-r",
		"bg-linear-to-br",
		"bg-linear-to-b",
		"bg-linear-to-bl",
		"bg-linear-to-l",
		"bg-linear-to-tl",
	}
	local bg_position = {
		"bg-top-left",
		"bg-top",
		"bg-top-right",
		"bg-left",
		"bg-center",
		"bg-right",
		"bg-bottom-left",
		"bg-bottom",
		"bg-bottom-right",
	}
	local bg_repeat = {
		"bg-repeat",
		"bg-repeat-x",
		"bg-repeat-y",
		"bg-repeat-space",
		"bg-repeat-round",
		"bg-no-repeat",
	}
	local bg_size = {
		"bg-auto",
		"bg-cover",
		"bg-contain",
	}
	local border_radius = {}
	local border_radius_t = {}
	local border_radius_b = {}
	local border_radius_l = {}
	local border_radius_r = {}
	local border_radius_tl = {}
	local border_radius_tr = {}
	local border_radius_bl = {}
	local border_radius_br = {}
	local border_radius_values = {
		"none",
		"xs",
		"sm",
		"md",
		"lg",
		"xl",
		"2xl",
		"3xl",
		"4xl",
		"full",
	}
	for _, value in ipairs(border_radius_values) do
		table.insert(border_radius, "rounded-" .. value)
		table.insert(border_radius_t, "rounded-t-" .. value)
		table.insert(border_radius_b, "rounded-b-" .. value)
		table.insert(border_radius_l, "rounded-l-" .. value)
		table.insert(border_radius_r, "rounded-r-" .. value)
		table.insert(border_radius_tl, "rounded-tl-" .. value)
		table.insert(border_radius_tr, "rounded-tr-" .. value)
		table.insert(border_radius_bl, "rounded-bl-" .. value)
		table.insert(border_radius_br, "rounded-br-" .. value)
	end
	local box_shadow = {
		"shadow-none",
		"shadow-2xs",
		"shadow-xs",
		"shadow-sm",
		"shadow-md",
		"shadow-lg",
		"shadow-xl",
		"shadow-2xl",
	}
	local display = {
		"block",
		"inline-block",
		"inline",
		"flex",
		"inline-flex",
		"grid",
		"inline-grid",
		"flow-root",
		"contents",
		"hidden",
	}
	local flex_direction = {
		"flex-row",
		"flex-row-reverse",
		"flex-col",
		"flex-col-reverse",
	}
	local font_size = {
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
	}
	local font_stretch = {
		"font-stretch-ultra-condensed",
		"font-stretch-extra-condensed",
		"font-stretch-condensed",
		"font-stretch-semi-condensed",
		"font-stretch-normal",
		"font-stretch-semi-expanded",
		"font-stretch-expanded",
		"font-stretch-extra-expanded",
		"font-stretch-ultra-expanded",
	}
	local font_weight = {
		"font-thin",
		"font-extralight",
		"font-light",
		"font-normal",
		"font-medium",
		"font-semibold",
		"font-bold",
		"font-extrabold",
		"font-black",
	}
	local justify_content = {
		"justify-start",
		"justify-end",
		"justify-center",
		"justify-between",
		"justify-around",
		"justify-evenly",
		"justify-stretch",
		"justify-baseline",
		"justify-normal",
	}
	local line_height = {
		"leading-none",
		"leading-tight",
		"leading-snug",
		"leading-normal",
		"leading-relaxed",
		"leading-loose",
	}
	local blend_modes = {
		"normal",
		"multiply",
		"screen",
		"overlay",
		"darken",
		"lighten",
		"color-dodge",
		"color-burn",
		"hard-light",
		"soft-light",
		"difference",
		"exclusion",
		"hue",
		"saturation",
		"color",
		"luminosity",
		"plus-lighter",
		"plus-darker",
	}
	local mix_blend_mode = {}
	local bg_blend_mode = {}
	for _, mode in ipairs(blend_modes) do
		table.insert(mix_blend_mode, "mix-blend-" .. mode)
		table.insert(bg_blend_mode, "bg-blend-" .. mode)
	end
	local position = { "static", "fixed", "absolute", "relative", "sticky" }
	local text_align = { "text-left", "text-center", "text-right", "text-justify", "text-start", "text-end" }
	local text_wrap = { "text-wrap", "text-nowrap", "text-balance", "text-pretty" }
	local tracking = {
		"tracking-tighter",
		"tracking-tight",
		"tracking-normal",
		"tracking-wide",
		"tracking-wider",
		"tracking-widest",
	}

	local tw_rules = {
		align_items,
		bg_blend_mode,
		bg_linear,
		bg_position,
		bg_repeat,
		bg_size,
		border_radius,
		border_radius_t,
		border_radius_b,
		border_radius_l,
		border_radius_r,
		border_radius_tl,
		border_radius_tr,
		border_radius_bl,
		border_radius_br,
		box_shadow,
		display,
		flex_direction,
		font_size,
		font_stretch,
		font_weight,
		justify_content,
		line_height,
		mix_blend_mode,
		position,
		text_align,
		text_wrap,
		tracking,
	}

	for _, group in ipairs(tw_rules) do
		table.insert(
			default,
			augend.constant.new({
				elements = group,
				word = true,
				cyclic = true,
			})
		)
	end
end

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
		local config = require("dial.config")

		local default = {
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
				-- TypeScript primitive types
				elements = { "string", "number", "boolean", "undefined", "null" },
				word = true,
				cyclic = true,
			}),
			augend.integer.alias.decimal,
		}

		-- Tailwind
		add_tailwind_rules(default)

		config.augends:register_group({
			default = default,
		})
	end,
}
