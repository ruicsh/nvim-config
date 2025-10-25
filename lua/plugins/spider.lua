-- Move by subwords and skip insignificant punctuation.
-- https://github.com/chrisgrieser/nvim-spider

return {
	"chrisgrieser/nvim-spider",
	keys = function()
		local spider = require("spider")

		local motion = function(key)
			return function()
				spider.motion(key)
			end
		end

		local mappings = {
			{ "w", motion("w"), "Word forward", mode = { "n", "o", "x" } },
			{ "e", motion("e"), "End of word", mode = { "n", "o", "x" } },
			{ "b", motion("b"), "Word backward", mode = { "n", "o", "x" } },
			{ "ge", motion("ge"), "Backward to end of word", mode = { "n", "o", "x" } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Spider Motions")
	end,

	lazy = true,
}
