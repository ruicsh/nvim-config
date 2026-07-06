-- Git diff
-- https://github.com/esmuellert/codediff.nvim

return {
	"esmuellert/codediff.nvim",
	keys = function()
		local function diff_back()
			if vim.v.count > 0 then
				require("codediff.commands").vscode_diff({ fargs = { "HEAD~" .. tostring(vim.v.count) } })
				return
			end

			require("snacks.input").input({
				prompt = "CodeDiff {git-rev}: ",
				default = "HEAD~1",
			}, function(input)
				if input then
					require("codediff.commands").vscode_diff({ fargs = { input } })
				end
			end)
		end

		return {
			{ "<leader>hD", "<cmd>CodeDiff<cr>", desc = "Git: Diff (explorer)" },
			{ "<leader>h~", diff_back, desc = "Git: Diff HEAD~{count}..HEAD" },
		}
	end,
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeDiffOpen",
			callback = function(ev)
				local tabpage = ev.data.tabpage
				local lifecycle = require("codediff.ui.lifecycle")

				local _, mod_win = lifecycle.get_windows(tabpage)
				local explorer = lifecycle.get_explorer(tabpage)
				if not explorer or not mod_win then
					return
				end

				local opts = { buffer = explorer.bufnr, nowait = true }

				vim.keymap.set("n", "<c-b>", function()
					vim.api.nvim_win_call(mod_win, function()
						vim.cmd("normal! \x02")
					end)
				end, opts)

				vim.keymap.set("n", "<c-f>", function()
					vim.api.nvim_win_call(mod_win, function()
						vim.cmd("normal! \x06")
					end)
				end, opts)
			end,
		})
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
	dependencies = { "MunifTanjim/nui.nvim" },
}
