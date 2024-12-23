-- Move by subwords in camelCase
-- https://github.com/chrisgrieser/nvim-spider

return {
	"chrisgrieser/nvim-spider",
	keys = function()
		local function motion(char)
			return function()
				local spider = require("spider")
				spider.motion(char)
			end
		end

		local opts = { mode = { "n", "o", "x" }, silent = true }

		return {
			{ "w", motion("w"), opts },
			{ "e", motion("e"), opts },
			{ "b", motion("b"), opts },
			{ "ge", motion("ge"), opts },
		}
	end,

	event = { "VeryLazy" },
}
