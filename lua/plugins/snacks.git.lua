-- Git utilities.
-- https://github.com/folke/snacks.nvim/blob/main/docs/git.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local mappings = {
			{ "<leader>hL", snacks.picker.git_log, "Git: Log" },
			{ "<leader>hl", snacks.picker.git_log_file, "Git: Log file" },
			{ "<leader>hb", snacks.git.blame_line, "Git: Log line" },
			{ "<leader>hx", snacks.gitbrowse.open, "Git: Open in browser" },
		}

		return vim.fn.get_lazy_keys_conf(mappings)
	end)(),
	opts = {
		git = {
			enabled = true,
		},
		gitbrowse = {
			enabled = true,
		},
	},
}
