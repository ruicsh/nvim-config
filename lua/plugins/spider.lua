-- Move by subwords and skip insignificant punctuation.
-- https://github.com/chrisgrieser/nvim-spider

return {
	"chrisgrieser/nvim-spider",
	keys = function()
		local spider = require("spider")

		local function motion(key)
			return function()
				spider.motion(key)
			end
		end

		return {
			{ "w", motion("w"), desc = "Words: Next", mode = { "n", "o", "x" } },
			{ "e", motion("e"), desc = "Words: End", mode = { "n", "o", "x" } },
			{ "b", motion("b"), desc = "Words: Previous", mode = { "n", "o", "x" } },
			{ "ge", motion("ge"), desc = "Words: End of previous", mode = { "n", "o", "x" } },
		}
	end,
}
