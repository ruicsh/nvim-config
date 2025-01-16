-- Snippets engine
-- https://github.com/garymjr/nvim-snippets

return {
	"garymjr/nvim-snippets",
	keys = function()
		local function snip_jump(key, direction)
			return function()
				if vim.snippet.active({ direction = direction }) then
					vim.schedule(function()
						vim.snippet.jump(direction)
					end)
					return
				end
				return key
			end
		end

		local mappings = {
			{ "<tab>", snip_jump("<tab>", 1), "Next placeholder", { mode = { "i", "s" } } },
			{ "<s-tab>", snip_jump("<s-tab>", -1), "Previous placeholder", { mode = { "i", "s" } } },
		}

		return vim.fn.getlazykeysconf(mappings, "Snippets")
	end,
	opts = {
		friendly_snippets = true,
	},

	event = { "InsertEnter" },
	dependencies = {
		{ -- vscode snippets
			-- https://github.com/rafamadriz/friendly-snippets
			"rafamadriz/friendly-snippets",
		},
	},
}
