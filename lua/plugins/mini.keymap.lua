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
		local limit = 5
		local lhs = string.rep(key, limit)
		local rhs = string.rep(opposite_key, limit)
		km.map_combo({ "n", "x" }, lhs, rhs)
	end
end

-- Different behaviour for <tab>/<s-tab>/<cr> depending on context
local function super_tab()
	local km = require("mini.keymap")

	km.map_multistep("i", "<tab>", {
		"jump_after_tsnode",
		"jump_after_close",
	})

	km.map_multistep("i", "<s-tab>", {
		"jump_before_tsnode",
		"jump_before_open",
	})
end

return {
	"echasnovski/mini.keymap",
	config = function()
		hardtime()
		super_tab()
	end,
}
