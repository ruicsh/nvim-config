-- AI Sidekick
-- https://github.com/folke/sidekick.nvim

local T = require("lib")

return {
	"folke/sidekick.nvim",
	opts = function()
		return {
			cli = {
				win = {
					layout = "float",
					float = T.ui.side_panel_win_config(),
					keys = {
						buffers = { "<c-b>", "buffers", mode = "nt", desc = "open buffer picker" },
						files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
						hide_n = false,
						hide_ctrl_q = false,
						hide_ctrl_dot = false,
						hide_ctrl_z = { "<c-bslash>", "blur", mode = "nt", desc = "Focus Editor" },
						prompt = false,
						stopinsert = false,
						nav_left = false,
						nav_down = false,
						nav_up = false,
						nav_right = false,
					},
				},
				tools = {
					copilot = {
						-- drop the default `--banner` arg
						cmd = { "copilot" },
					},
				},
			},
			nes = {
				enabled = false,
			},
		}
	end,
	keys = function()
		local cli = require("sidekick.cli")
		local tool = T.env.get("AI_CODING_AGENT_TOOL")

		local a = {
			send = function(msg)
				return function()
					cli.send({ name = tool, msg = msg })
				end
			end,
			show = function()
				cli.show({ name = tool })
			end,
			toggle = function()
				cli.toggle({ name = tool, focus = true })
			end,
		}

		local function ai_review_branch()
			T.git.pick_review_base(function(base, merge_base)
				-- The agent has repo access, so point it at the same merge-base
				-- diff instead of shipping the whole patch through the prompt.
				local msg = (
					"Review the changes on this branch since it diverged from %s. "
					.. "Run `git diff %s` to see them, including any uncommitted work. "
					.. "Focus on bugs, regressions, and missing tests. Cite file:line; don't restate the diff."
				):format(base, merge_base)
				a.send(msg)()
			end)
		end

		return {
			{ "<leader>h<c-bslash>", ai_review_branch, desc = "Git: AI review branch vs merge-base" },
			{ "<c-bslash>", a.send("{this}"), mode = { "x" }, desc = "Sidekick: Send Visual Selection" },
			{ "<c-bslash>", a.show, mode = { "n", "t", "i" }, desc = "Sidekick: Focus" },
			{ "<c-w><c-bslash>", a.toggle, mode = { "n", "t", "i" }, desc = "Sidekick: Toggle" },
			{ "<c-w><bslash>", a.toggle, mode = { "n", "t", "i" }, desc = "Sidekick: Toggle" },
		}
	end,
}
