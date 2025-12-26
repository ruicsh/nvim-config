-- Search results lens
-- https://github.com/kevinhwang91/nvim-hlslens

return {
	"kevinhwang91/nvim-hlslens",
	keys = function()
		local hlslens = require("hlslens")

		local function browse(key)
			return function()
				vim.cmd("normal! " .. vim.v.count1 .. key .. "zv")
				hlslens.start()
			end
		end

		local function start_search(keys)
			return function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
				vim.cmd("normal! zv")
				hlslens.start()
			end
		end

		return {
			{ "n", browse("n"), desc = "Search: Next result" },
			{ "N", browse("N"), desc = "Search: Previous result" },
			{ "*", start_search("*"), desc = "Search: Word under cursor forward" },
			{ "g/", start_search("*"), desc = "Search: Word under cursor forward" },
			{ "[/", start_search("[<c-i>"), desc = "Search: Word under cursor forward" },
			{ "#", start_search("#"), desc = "Search: Word under cursor backward" },
			{ "g*", start_search("g*"), desc = "Search: Word under cursor forward (partial)" },
			{ "g#", start_search("g#"), desc = "Search: Word under cursor backward (partial)" },
		}
	end,
	opts = {
		calm_down = true,
		nearest_only = true,
	},

	event = "VeryLazy",
}
