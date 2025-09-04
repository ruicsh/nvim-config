-- OpenCode integration
-- https://github.com/NickvanDyke/opencode.nvim

return {
	"NickvanDyke/opencode.nvim",
	config = function()
		local oc = require("opencode")

		vim.g.opencode_opts = {
			terminal = {
				auto_insert = false,
				win = {
					width = 0.5,
				},
			},
		}

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
			{ "<leader><c-a>a", new_session, "New session" },
			{ "<leader><c-a>.", toggle, "Toggle" },
			{ "<leader><c-a>A", ask("@buffer: "), "Ask about buffer" },
			{ "<leader><c-a>a", ask("@selection: "), "Ask about selection", { mode = { "v" } } },
			{ "<leader><c-a>p", oc.select, "Select prompt", { mode = { "n", "v" } } },
			{ "<leader><c-a>c", command("messages_copy"), "Copy last message" },
			{ "<c-s-u>", command("messages_half_page_up"), "Scroll messages up" },
			{ "<c-s-d>", command("messages_half_page_down"), "Scroll messages down" },
		}

		for _, mapping in pairs(mappings) do
			local modes = mapping[4] and mapping[4].mode or { "n" }
			local key = mapping[1]
			local func = mapping[2]
			local desc = mapping[3]
			local opts = { noremap = true, silent = true, desc = desc }

			for _, mode in ipairs(modes) do
				vim.keymap.set(mode, key, func, opts)
			end
		end
	end,
}
