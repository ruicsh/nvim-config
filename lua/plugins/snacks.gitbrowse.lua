-- Open the repo of the active file in the browser.
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			{ "<leader>hx", snacks.gitbrowse.open, "Open in browser" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "Git")
	end)(),
	opts = {
		gitbrowse = {
			enabled = true,
			url_patterns = {
				["github%.rebarsys%.corp"] = {
					branch = "/tree/{branch}",
					file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
					permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
					commit = "/commit/{commit}",
				},
			},
		},
	},

	event = { "BufReadPre", "BufNewFile" },
}
