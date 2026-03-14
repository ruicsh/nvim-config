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
					hide_ctrl_z = false,
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

		local function toggle()
			cli.toggle({ name = "opencode", focus = true })
		end

		local function send(msg)
			return function()
				cli.send({ name = "opencode", msg = msg })
			end
		end

		return {
			{ "<s-tab>", send("{selection}"), mode = { "x" }, desc = "Send Visual Selection" },
			{ "<s-tab>", toggle, mode = { "n", "t" }, desc = "Sidekick Toggle" },
			{ "<leader>cf", send("{file}"), desc = "Send File" },
			{ "<leader>cp", cli.prompt, mode = { "n", "x" }, desc = "Sidekick Select Prompt" },
			{ "<leader>ct", send("{this}"), mode = { "x", "n" }, desc = "Send This" },
		}
	end,
}
