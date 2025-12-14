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

		local mappings = {
			{ "w", motion("w"), "Next", { mode = { "n", "o", "x" } } },
			{ "e", motion("e"), "End", { mode = { "n", "o", "x" } } },
			{ "b", motion("b"), "Previous", { mode = { "n", "o", "x" } } },
			{ "ge", motion("ge"), "End of previous", { mode = { "n", "o", "x" } } },
		}

		return vim.fn.get_lazy_keys_config(mappings, "Words")
	end,
}
