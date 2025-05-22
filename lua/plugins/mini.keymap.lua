-- Special key mappings
-- https://github.com/echasnovski/mini.keymap

-- Stop bad navigation habits
local function hardtime()
	local km = require("mini.keymap")

	local key_opposite = {
		h = "l",
		j = "k",
		k = "j",
		l = "h",
		["<up>"] = "j",
		["<down>"] = "k",
		["<left>"] = "l",
		["<right>"] = "h",
	}

	for key, opposite_key in pairs(key_opposite) do
		local lhs = string.rep(key, 3)
		local opposite_lhs = string.rep(opposite_key, 3)

		km.map_combo({ "n", "x", "i" }, lhs, function()
			return opposite_lhs
		end)
	end
end

-- Different behavior for <tab>/<s-tab>/<cr> depending on context
local function super_tab()
	local km = require("mini.keymap")

	km.map_multistep("i", "<tab>", {
		"increase_indent",
		"pmenu_next",
		"blink_next",
		"jump_after_tsnode",
		"jump_after_close",
	})

	km.map_multistep("i", "<s-tab>", {
		"decrease_indent",
		"pmenu_prev",
		"blink_prev",
		"jump_before_tsnode",
		"jump_before_open",
	})

	km.map_multistep("i", "<cr>", {
		"pmenu_accept",
		"blink_accept",
		"minipairs_cr",
	})
end

return {
	"echasnovski/mini.keymap",
	config = function()
		hardtime()
		super_tab()
	end,
}
