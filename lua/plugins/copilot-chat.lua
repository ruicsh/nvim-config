-- GitHub Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

-- Custom prompts to be used with the `:CopilotChat` command
local custom_prompts = {
	"angular",
	"communication",
	"js",
	"lua",
	"microbit",
	"react",
	"rust",
	"ts",
	"vim",
}

-- Read the contents of a prompt file given its basename
local function read_prompt_file(basename)
	local config_path = vim.fn.stdpath("config")
	local file_path = config_path .. "/prompts/" .. basename .. ".txt"
	return vim.fs.read_file(string.lower(file_path))
end

vim.api.nvim_create_user_command("CopilotChatGenCommitMessage", function()
	local chat = require("CopilotChat")
	local prompt = read_prompt_file("commit")

	chat.ask(prompt, {
		clear_chat_on_new_prompt = true,
		model = "gemini-2.0-flash-001",
		window = {
			col = 1,
			height = 20,
			layout = "float",
			relative = "cursor",
			row = 1,
			title = "  Commit message",
			width = 80,
		},
	})
end, {})

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	keys = function()
		local chat = require("CopilotChat")
		local actions = require("CopilotChat.actions")
		local config = require("CopilotChat.config")

		local function switch_window(cmd)
			return function()
				vim.cmd("WindowToggleMaximize") -- maximize the current window
				vim.cmd("vsplit") -- open a vertical split
				vim.cmd(cmd) -- issue the command
			end
		end

		local function show_actions()
			require("CopilotChat.integrations.snacks").pick(actions.prompt_actions())
		end

		local function ask_question()
			require("snacks").input({
				prompt = " Copilot",
			}, function(input)
				if input ~= "" then
					local cmd = "CopilotChat " .. input
					switch_window(cmd)()
				end
			end)
		end

		local function switch_prompt()
			vim.ui.select(custom_prompts, {
				prompt = "Select a custom prompt",
				format_item = function(item)
					return item
				end,
			}, function(choice)
				local cmd = "CopilotChat" .. choice

				local ft = vim.bo.filetype
				if ft ~= "copilot-chat" then
					switch_window(cmd)()
				else
					vim.cmd(cmd)
				end
			end)
		end

		local function inline(action)
			return function()
				local ft = vim.bo.filetype
				local filename = vim.fn.expand("%:t")
				local ft_prompts = {}
				if
					filename:match("%.component%.ts$")
					or filename:match("%.component%.html$")
					or filename:match("%.module%.ts$")
					or ft == "htmlangular"
				then
					table.insert(ft_prompts, "angular")
					table.insert(ft_prompts, "js")
					table.insert(ft_prompts, "ts")
				elseif ft == "javascript" then
					table.insert(ft_prompts, "js")
				elseif ft == "typescript" then
					table.insert(ft_prompts, "js")
					table.insert(ft_prompts, "ts")
				elseif ft == "vim" or ft == "lua" then
					table.insert(ft_prompts, "vim")
					table.insert(ft_prompts, "lua")
				elseif ft == "rust" then
					table.insert(ft_prompts, "rust")
				elseif ft == "typescriptreact" then
					table.insert(ft_prompts, "react")
					table.insert(ft_prompts, "js")
					table.insert(ft_prompts, "ts")
				end

				local sticky_prompts = { "communication" }
				for _, ft_prompt in ipairs(ft_prompts) do
					table.insert(sticky_prompts, ft_prompt)
				end

				local prompt = ""
				if action == "Explain" then
					prompt = config.prompts.Explain.prompt
				elseif action == "Fix" then
					prompt = config.prompts.Fix.prompt
				elseif action == "Implement" then
					-- prompt = config.prompts.Implement.prompt
				elseif action == "Optimize" then
					prompt = config.prompts.Optimize.prompt
				elseif action == "Refactor" then
					-- prompt = config.prompts.Refactor.prompt
				elseif action == "Review" then
					prompt = config.prompts.Review.prompt
				elseif action == "Simplify" then
					-- prompt = config.prompts.Simplify.prompt
				end

				for _, sticky in ipairs(sticky_prompts) do
					prompt = "> /" .. sticky .. "\n\n" .. prompt
				end

				chat.ask(prompt, {
					auto_insert_mode = false,
					clear_chat_on_new_prompt = true,
					model = "claude-3.5-sonnet",
					window = {
						col = 1,
						height = 20,
						layout = "float",
						relative = "cursor",
						row = 1,
						title = "  " .. action,
						width = 80,
					},
				})
			end
		end

		local mappings = {
			-- chat
			{ "<leader>aa", switch_window("CopilotChatOpen"), "Chat", { mode = "v" } },
			{ "<leader>aa", switch_window("CopilotChatToggle"), "Chat" },
			{ "<leader>ac", show_actions, "Chat" },
			{ "<leader>am", chat.select_model, "Models" },
			{ "<leader>ap", switch_prompt, "Switch prompt" },
			{ "<leader>aq", ask_question, "Ask" },
			{ "<leader>ax", chat.reset, "Reset" },
			{ "<c-]>", chat.stop, "Stop" },

			-- inline
			{ "<leader>ae", inline("Explain"), "Explain", { mode = "v" } },
			{ "<leader>af", inline("Fix"), "Fix", { mode = "v" } },
			{ "<leader>ai", inline("Implement"), "Implement", { mode = "v" } },
			{ "<leader>ao", inline("Optimize"), "Optimize", { mode = "v" } },
			{ "<leader>ar", inline("Refactor"), "Refactor", { mode = "v" } },
			{ "<leader>av", inline("Review"), "Review", { mode = "v" } },
			{ "<leader>as", inline("Simplify"), "Simplify", { mode = "v" } },
		}

		return vim.fn.get_lazy_keys_conf(mappings, "AI")
	end,
	opts = {
		answer_header = "  Copilot ",
		auto_insert_mode = true,
		chat_autocomplete = false,
		error_header = "  Error ",
		insert_at_end = true,
		mappings = {
			accept_diff = {
				normal = "<c-l>",
				insert = "<c-l>",
			},
			close = {
				normal = "<c-]>",
				insert = "<c-]>",
			},
			reset = {
				normal = "<c-x>",
				insert = "<c-x>",
			},
			show_diff = {
				full_diff = true,
			},
			yank_diff = {
				normal = "gy",
				register = "+",
			},
		},
		model = "claude-3.5-sonnet",
		question_header = "  ruicsh ",
		prompts = (function()
			local prompts = {}
			-- Load custom prompts
			for _, prompt in ipairs(custom_prompts) do
				prompts[prompt] = read_prompt_file(prompt)
			end
			return prompts
		end)(),
		show_help = false,
		sticky = {
			"/COPILOT_GENERATE",
		},
		window = {
			layout = "replace",
		},
	},

	lazy = false,
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
	},
}
