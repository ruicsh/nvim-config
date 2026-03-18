-- Git diff
-- https://github.com/esmuellert/codediff.nvim

return {
	"ruicsh/codediff.nvim",
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
		diff = {
			layout = "inline",
		},
		explorer = {
			focus_on_select = true,
			view_mode = "tree",
			width = 60,
		},
		keymaps = {
			view = {
				next_hunk = false, -- Always use gitsigns navigation in CodeDiff buffers
				prev_hunk = false, -- Always use gitsigns navigation in CodeDiff buffers
				next_file = "<c-n>",
				prev_file = "<c-p>",
			},
			conflict = {
				accept_current = "co",
				accept_incoming = "ct",
				accept_both = "cb",
				discard = "cx",
			},
		},
		highlights = {
			char_brightness = 1,
		},
	},

	cmd = "CodeDiff",
	branch = "feat/explorer-scroll-diff-buffers",
	dependencies = { "MunifTanjim/nui.nvim" },
}
