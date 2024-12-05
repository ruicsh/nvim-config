-- Shareable file links
-- https://github.com/ruifm/gitlinker.nvim

return {
	"ruifm/gitlinker.nvim",
	config = function()
		local gitlinker = require("gitlinker")
		local actions = require("gitlinker.actions")
		local hosts = require("gitlinker.hosts")

		gitlinker.setup({
			mappings = "<leader>hy",
			opts = {
				remote = nil,
				add_current_line_on_normal_mode = true,
				action_callback = actions.copy_to_clipboard,
				print_url = true,
			},
			callbacks = {
				["github.com"] = hosts.get_github_type_url,
				["gitlab.com"] = hosts.get_gitlab_type_url,
				["try.gitea.io"] = hosts.get_gitea_type_url,
				["codeberg.org"] = hosts.get_gitea_type_url,
				["bitbucket.org"] = hosts.get_bitbucket_type_url,
				["try.gogs.io"] = hosts.get_gogs_type_url,
				["git.sr.ht"] = hosts.get_srht_type_url,
				["git.launchpad.net"] = hosts.get_launchpad_type_url,
				["repo.or.cz"] = hosts.get_repoorcz_type_url,
				["git.kernel.org"] = hosts.get_cgit_type_url,
				["git.savannah.gnu.org"] = hosts.get_cgit_type_url,
			},
		})
	end,

	event = { "VeryLazy" },
}
