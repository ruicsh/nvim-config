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
					buffers = { "<c-s-b>", "buffers", mode = "nt", desc = "open buffer picker" },
					files = { "<c-s-f>", "files", mode = "nt", desc = "open file picker" },
					hide_n = { "Q", "hide", mode = "n", desc = "hide the terminal window" },
					hide_ctrl_q = { "<c-s-q>", "hide", mode = "n", desc = "hide the terminal window" },
					hide_ctrl_dot = { "<c-.>", "hide", mode = "nt", desc = "hide the terminal window" },
					hide_ctrl_z = { "<c-s-z>", "hide", mode = "nt", desc = "hide the terminal window" },
					prompt = { "<c-s-p>", "prompt", mode = "t", desc = "insert prompt or context" },
					stopinsert = { "<c-s-q>", "stopinsert", mode = "t", desc = "enter normal mode" },
					nav_left = { "<c-s-h>", "nav_left", expr = true, desc = "navigate to the left window" },
					nav_down = { "<c-s-j>", "nav_down", expr = true, desc = "navigate to the below window" },
					nav_up = { "<c-s-k>", "nav_up", expr = true, desc = "navigate to the above window" },
					nav_right = { "<c-s-l>", "nav_right", expr = true, desc = "navigate to the right window" },
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
			{ "<c-.>", toggle, desc = "Sidekick Toggle", mode = { "n", "t", "i" } },
			{ "<c-.>", send("{selection}"), mode = { "x" }, desc = "Send Visual Selection" },
			{ "<leader>ct", send("{this}"), mode = { "x", "n" }, desc = "Send This" },
			{ "<leader>cf", send("{file}"), desc = "Send File" },
			{ "<leader>cp", cli.prompt, mode = { "n", "x" }, desc = "Sidekick Select Prompt" },
		}
	end,
}
