-- Git diff
-- https://github.com/esmuellert/codediff.nvim

return {
	"esmuellert/codediff.nvim",
	keys = function()
		local function diff_back()
			if vim.v.count > 0 then
				vim.cmd("CodeDiff HEAD~" .. tostring(vim.v.count))
				return
			end

			require("snacks.input").input({
				prompt = "CodeDiff {git-rev}: ",
				default = "HEAD~1",
			}, function(input)
				if input then
					vim.cmd("CodeDiff " .. input)
				end
			end)
		end

		return {
			{ "<leader>hD", "<cmd>CodeDiff<cr>", desc = "Git: Diff" },
			{ "<leader>h~", diff_back, desc = "Git: Diff HEAD~{count}..HEAD" },
		}
	end,
	opts = {
		explorer = {
			view_mode = "tree",
			width = 50,
		},
		keymaps = {
			view = {
				next_file = "<c-n>",
				prev_file = "<c-p>",
				toggle_explorer = "<c-b>",
			},
			conflict = {
				accept_current = "co",
				accept_incoming = "ct",
				accept_both = "cb",
				discard = "cx",
			},
		},
	},

	cmd = "CodeDiff",
	dependencies = { "MunifTanjim/nui.nvim" },
}
