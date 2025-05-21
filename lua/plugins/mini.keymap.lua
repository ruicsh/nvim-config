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
		["{"] = "}",
		["}"] = "{",
		["<up>"] = "j",
		["<down>"] = "k",
		["<left>"] = "l",
		["<right>"] = "h",
		w = "b",
		b = "w",
	}

	for key, opposite_key in pairs(key_opposite) do
		local lhs = string.rep(key, 5)
		local opposite_lhs = string.rep(opposite_key, 5)

		km.map_combo({ "n", "x" }, lhs, function()
			vim.notify("Too many " .. key)
			vim.cmd.normal(opposite_lhs)
		end)
	end
end

return {
	"echasnovski/mini.keymap",
	config = function()
		hardtime()
	end,
}
