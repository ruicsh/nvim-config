-- AI Sidekick
-- https://github.com/folke/sidekick.nvim

local T = require("lib")

return {
	"folke/sidekick.nvim",
	opts = {
		cli = {
			mux = {
				enabled = false,
			},
			win = {
				layout = "float",
				float = T.ui.side_panel_win_config(),
				keys = {
					buffers = false,
					files = false,
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
		},
		nes = {
			enabled = false,
		},
	},
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

		return {
			{ "<c-bslash>", a.send("{selection}"), mode = { "x" }, desc = "Sidekick: Send Visual Selection" },
			{ "<c-bslash>", a.show, mode = { "n", "t", "i" }, desc = "Sidekick: Focus" },
			{ "<c-w><c-bslash>", a.toggle, mode = { "n", "t", "i" }, desc = "Sidekick: Toggle" },
		}
	end,
}
