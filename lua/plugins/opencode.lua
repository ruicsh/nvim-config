-- OpenCode integration
-- https://github.com/NickvanDyke/opencode.nvim

return {
	"NickvanDyke/opencode.nvim",
	opts = {
		terminal = {
			auto_insert = false,
			win = {
				width = 0.5,
			},
		},
	},
	keys = function()
		local oc = require("opencode")

		local function new_session()
			vim.cmd("only")
			oc.command("session_new")
			vim.cmd.wincmd("w")
		end

		local function toggle()
			oc.toggle()
			vim.cmd.wincmd("w")
		end

		local function ask(prompt)
			return function()
				vim.cmd("only")
				oc.ask(prompt)
			end
		end

		local function command(cmd)
			return function()
				oc.command(cmd)
			end
		end

		local mappings = {
			{ "<a-a>a", new_session, "New session" },
			{ "<a-a>.", toggle, "Toggle" },
			{ "<a-a>A", ask("@buffer: "), "Ask about buffer" },
			{ "<a-a>a", ask("@selection: "), "Ask about selection", { mode = "v" } },
			{ "<a-a>p", oc.select_prompt, "Select prompt", { mode = { "n", "v" } } },
			{ "<a-a>c", command("messages_copy"), "Copy last message" },
			{ "<c-s-u>", command("messages_half_page_up"), "Scroll messages up" },
			{ "<c-s-d>", command("messages_half_page_down"), "Scroll messages down" },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI Agent")
	end,
}
