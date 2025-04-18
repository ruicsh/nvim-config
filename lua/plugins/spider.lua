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

		local opts = { mode = { "n", "o", "v" } }

		local mappings = {
			{ "w", motion("w"), "word", opts },
			{ "e", motion("e"), "end of word", opts },
			{ "b", motion("b"), "back word", opts },
			{ "ge", motion("ge"), "back end of word", opts },
		}
		return vim.fn.get_lazy_keys_conf(mappings, "Spider")
	end,
}
