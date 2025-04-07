-- Open the repo of the active file in the browser.
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md

return {
	"folke/snacks.nvim",
	keys = (function()
		local snacks = require("snacks")

		local function open_commit_url()
			local notify = require("mini.notify")
			local blame = vim.git.blame()

			if blame.commit:match("^00000000") or blame.commit == "fatal" then
				local id = notify.add("Not commited yet.", "WARN")
				vim.defer_fn(function()
					notify.remove(id)
				end, 3000)
				return
			end

			local url = string.format("%s/commit/%s", blame.repo_url, blame.commit)
			vim.ui.open(url)
		end

		local mappings = {
			{ "<leader>hxf", snacks.gitbrowse.open, "Open file in browser" },
			{ "<leader>hxb", open_commit_url, "Open commit in browser" },
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

	event = "BufRead",
	enabled = not vim.g.vscode,
}
