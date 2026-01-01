-- Git diffview
-- https://github.com/sindrets/diffview.nvim

local T = require("lib")

-- Used by `git df` to open diffview in a single tab
vim.api.nvim_create_user_command("DiffviewOpenOnly", function()
	vim.cmd("DiffviewOpen")
	vim.cmd("tabonly")
end, {})

return {
	"sindrets/diffview.nvim",
	keys = function()
		local function git_blame_line()
			local blame, msg = T.git.blame_line()
			if not blame then
				vim.notify(msg or "Failed to get git blame.")
				return
			end

			local commit = blame:match("^(%w+)")
			if not commit or commit == "" or commit:match("^00000000") then
				vim.notify("Not committed yet.")
				return
			end

			vim.cmd("DiffviewOpen " .. commit .. "^! --selected-file=" .. vim.fn.expand("%"))
		end

		local function diff_back()
			if vim.v.count > 0 then
				vim.cmd("DiffviewOpen HEAD~" .. tostring(vim.v.count))
				return
			end

			require("snacks.input").input({
				prompt = "Diffview {git-rev}: ",
				default = "HEAD~1",
			}, function(input)
				if input then
					vim.cmd("DiffviewOpen " .. input)
				end
			end)
		end

		return {
			{ "<leader>hD", "<cmd>DiffviewOpen<cr>", desc = "Git: Diffview" },
			{ "<leader>hl", "<cmd>DiffviewFileHistory<cr>", desc = "Git: Log" },
			{ "<leader>h%", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: Log for file" },
			{ "<leader>hl", "<cmd>'<,'>DiffviewFileHistory<cr>", desc = "Git: Log visual selection", mode = "v" },
			{ "<leader>h$", git_blame_line, desc = "Git: Blame line" },
			{ "<leader>h~", diff_back, desc = "Git: Diffview HEAD~{count}..HEAD" },
		}
	end,
	opts = function()
		local diffview = require("diffview")
		local actions = require("diffview.actions")

		local function git_commit()
			vim.cmd("DiffviewClose")
			vim.cmd("tabnew")
			vim.cmd("Git")
			vim.cmd("wincmd o")

			local prefix = T.ui.is_narrow_screen() and "" or "vertical"
			vim.cmd(prefix .. " Git commit")
		end

		-- Close Diffview or quit Neovim if it's the last tab.
		local function quit()
			if #vim.api.nvim_list_tabpages() == 1 then
				vim.cmd("qa")
			else
				vim.cmd("DiffviewClose")
			end
		end

		return {
			enhanced_diff_hl = true, -- ':h diffview-config-enhanced_diff_hl'
			file_panel = {
				win_config = {
					width = 50,
				},
			},
			keymaps = {
				file_panel = {
					["<c-n>"] = actions.select_next_entry,
					["<c-p>"] = actions.select_prev_entry,
					["q"] = quit,
					["<cr>"] = actions.focus_entry,
					["<tab>"] = actions.select_entry,
					["K"] = actions.open_commit_log,
					["cc"] = git_commit,
				},
				file_history_panel = {
					["<c-j>"] = actions.select_next_commit,
					["<c-k>"] = actions.select_prev_commit,
					["<c-n>"] = actions.select_next_entry,
					["<c-p>"] = actions.select_prev_entry,
					["q"] = quit,
					["<cr>"] = actions.focus_entry,
					["<tab>"] = actions.select_entry,
					["K"] = actions.open_commit_log,
					["<leader>hd"] = function()
						diffview.emit("copy_hash")
						vim.cmd("DiffviewOpen " .. vim.fn.getreg("*") .. "^!")
					end,
				},
				help_panel = {
					["q"] = actions.close,
				},
				view = {
					{ "n", "co", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
					{ "n", "ct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
					{ "n", "cb", actions.conflict_choose("all"), { desc = "Choose BOTH" } },
					{ "n", "c0", actions.conflict_choose("none"), { desc = "Choose NONE" } },
					["<leader>ca"] = false,
					["<leader>cb"] = false,
					["<leader>co"] = false,
					["<leader>ct"] = false,
					["<leader>cA"] = false,
					["<leader>cB"] = false,
					["<leader>cO"] = false,
					["<leader>cT"] = false,
					["q"] = quit,
				},
			},
			hooks = {
				diff_buf_read = function(bufnr)
					vim.schedule(function()
						vim.api.nvim_buf_call(bufnr, function()
							vim.cmd("normal! gg]czz") -- Focus the first hunk and center it.
						end)
					end)
				end,
			},
			view = {
				default = {
					layout = "diff2_vertical",
				},
				file_history = {
					layout = "diff2_horizontal",
				},
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
		}
	end,
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}
